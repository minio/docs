.. _minio-bucket-replication:

==================
Bucket Replication
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports server-side and client-side replication of objects between source
and destination buckets.

:ref:`Server-Side Bucket Replication <minio-bucket-replication-serverside>`
  Configure per-bucket rules for automatically synchronizing objects between MinIO deployments.
  The deployment where you configure the bucket replication rule acts as the "source" while the configured remote deployment acts as the "target".
  MinIO applies rules as part of object write operations (e.g. ``PUT``) and automatically synchronizes new objects *and* object mutations, such as new object versions or changes to object metadata.
  
  MinIO server-side bucket replication only supports a MinIO cluster on an identical release for the remote replication target.

Client-side Bucket Replication
  Use the command process to synchronize objects between buckets within the same S3-compatible cluster *or* between two independent S3-compatible clusters. 
  Client-side replication using :mc:`mc mirror` supports MinIO-to-S3 and similar replication configurations.

.. admonition:: Bucket vs Site Replication
   :class: note

   Bucket Replication is distinct from and mutually exclusive with :ref:`site replication <minio-site-replication-overview>`.

   - Bucket Replication synchronizes data at the bucket level, such as bucket prefix paths and objects.

     You can configure bucket replication at any time, and the remote MinIO deployments may have pre-existing data on the replication target buckets.

   - Site Replication extends bucket replication to include :ref:`IAM <minio-authentication-and-identity-management>`, security tokens, access keys, and bucket-level configurations.

     Site replication is typically configured when initially deploying the MinIO peer sites.
     Only one site can hold any bucket or objects at the time of initial configuration.


.. _minio-bucket-replication-serverside:

Server-Side Bucket Replication
------------------------------

MinIO server-side bucket replication is an automatic bucket-level configuration that synchronizes objects between a source and destination bucket. 
MinIO server-side replication *requires* the source and destination bucket be two separate MinIO clusters running the same MinIO Server version.

For each write operation to the bucket, MinIO checks all configured replication rules for the bucket and applies the matching rule with highest configured priority. 
MinIO synchronizes new objects *and* object mutations, such as new object versions or changes to object metadata. 
This includes metadata operations such as enabling or modifying object locking or retention settings.

MinIO server-side bucket replication is functionally similar to Amazon S3 replication while adding the following MinIO-only features:

- Source and destination bucket names can match, supporting site-to-site use cases such as Splunk or Veeam BC/DR. 

- Simplified implementation than S3 bucket replication configuration, removing the need to configure settings like AccessControlTranslation, Metrics, and SourceSelectionCriteria.

- Active-Active (Two-Way) replication of objects between source and destination buckets.

- Multi-Site replication of objects between three or more MinIO deployments

.. _minio-replication-behavior-resync:

Resynchronization (Disaster Recovery)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Resynchronization primarily supports recovery after partial or total loss of the
data on a MinIO deployment using a healthy deployment in the replica
configuration. Use the :mc:`mc replicate resync` command completely
resynchronize the remote target (:mc:`mc admin bucket remote`) using the
specified source bucket. 

The resynchronization process checks all objects in the source bucket against
all configured replication rules that include :ref:`existing object replication
<minio-replication-behavior-existing-objects>`. For each object which matches a
rule, the resynchronization process places the object into the replication
:ref:`queue <minio-replication-process>` regardless of the object's current
:ref:`replication status <minio-replication-process>`. 

MinIO skips synchronizing those objects whose remote copy exactly match the
source, including object metadata. MinIO otherwise does not prioritize or modify
the queue with regards to the existing contents of the target.

:mc:`mc replicate resync` operates at the bucket level and does
*not* support prefix-level granularity. Initiating resynchronization on a large
bucket may result in a significant increase in replication-related load
and traffic. Use this command with caution and only when necessary.

For buckets with :ref:`object transition (Tiering)
<minio-lifecycle-management-tiering>` configured, replication resynchronization
restores objects in a non-transitioned state with no associated transition
metadata. Any data previously transitioned to the remote storage is therefore
permanently disconnected from the remote MinIO deployment. For tiering
configurations which specify an explicit human-readable prefix as part of the
remote configuration, you can safely purge the transitioned data in that prefix
to avoid costs associated to the "lost" data.

.. _minio-replication-behavior-delete:

Replication of Delete Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating delete operations, where MinIO synchronizes
deleting specific object versions *and* new 
:s3-docs:`delete markers <delete-marker-replication.html>`. Delete operation
replication uses the same :ref:`replication process <minio-replication-process>`
as all other replication operations. 

MinIO requires explicitly enabling versioned deletes and delete marker
replication . Use the :mc-cmd:`mc replicate add --replicate` field to
specify both or either ``delete`` and ``delete-marker`` to enable versioned
deletes and delete marker replication respectively. To enable both, specify both
strings using a comma separator ``delete,delete-marker``.

For delete marker replication, MinIO begins the replication process after
a delete operation creates the delete marker. MinIO uses the 
``X-Minio-Replication-DeleteMarker-Status`` metadata field for tracking 
delete marker replication status. In 
:ref:`active-active <minio-bucket-replication-serverside-twoway>` 
replication configurations, MinIO may produce duplicate delete markers if
both clusters concurrently create a delete marker for an object *or* 
if one or both clusters were down before the replication event synchronized.

For replicating the deletion of a specific object version, MinIO marks the
object version as ``PENDING`` until replication completes. Once the remote
target deletes that object version, MinIO deletes the object on the source.
While this process ensures near-synchronized version deletion, it may result
in listing operations returning the object version after the initial
delete operation. MinIO uses the ``X-Minio-Replication-Delete-Status`` for
tracking delete version replication status.

MinIO only replicates explicit client-driven delete operations. MinIO does *not*
replicate objects deleted from the application of  
:ref:`lifecycle management expiration rules
<minio-lifecycle-management-expiration>`. For :ref:`active-active
<minio-bucket-replication-serverside-twoway>` configurations, set the same
expiration rules on *all* of of the replication buckets to ensure consistent
application of object expiration.

.. admonition:: MinIO Trims Empty Object Prefixes on Source and Remote Bucket
   :class: note, dropdown

   If a delete operation removes the last object in a bucket prefix, MinIO
   recursively removes each empty part of the prefix up to the bucket root.
   MinIO only applies the recursive removal to prefixes created *implicitly* as
   part of object write operations - that is, the prefix was not created using
   an explicit directory creation command such as :mc:`mc mb`.

   If a replication rule enables replication delete operations, the replication
   process *also* applies the implicit prefix trimming behavior on the
   destination MinIO cluster.

   For example, consider a bucket ``photos`` with the following object prefixes:
   
   - ``photos/2021/january/myphoto.jpg``
   - ``photos/2021/february/myotherphoto.jpg``
   - ``photos/NYE21/NewYears.jpg``

   ``photos/NYE21`` is the *only* prefix explicitly created using :mc:`mc mb`.
   All other prefixes were *implicitly* created as part of writing the object
   located at that prefix. 
   
   - A command removes ``myphoto.jpg``. MinIO automatically trims the empty
     ``/janaury`` prefix. 
   
   - A command then removes the ``myotherphoto.jpg``. MinIO automatically
     trims the ``/february`` prefix *and* the now-empty ``/2021`` prefix. 
   
   - A command removes the ``NewYears.jpg`` object. MinIO leaves the 
     ``/NYE21`` prefix remains in place since it was *explicitly* created.

.. _minio-replication-behavior-existing-objects:

Replication of Existing Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO by default does not enable existing object replication. Objects
created before replication was configured *or* while replication is
disabled are not synchronized to the target deployment.
MinIO supports enabling replication of existing objects in a bucket. 

Enabling existing object replication marks all objects or object prefixes that
satisfy the replication rules as eligible for synchronization to the source
cluster, *even if* those objects were created prior to configuring or enabling
replication. You can enable existing object replication while configuring
or modifying a replication rule:

- For new replication rules, include ``"existing-objects"`` to the list of
  replication features specified to :mc-cmd:`mc replicate add --replicate`.

- For existing replication rules, add ``"existing-objects"`` to the list of
  existing replication features using 
  :mc-cmd:`mc replicate update --replicate`. You must specify *all* desired
  replication features when editing the replication rule. 

Enabling existing object replication does not increase the priority of objects
pending replication. MinIO uses the same core 
:ref:`replication scanner and queue system <minio-replication-process>` for
detecting and synchronizing objects regardless of the enabled replication
feature. The time required to fully synchronize a bucket depends on a number of
factors, including but not limited to the current cluster replication load,
overall cluster load, and the size of the namespace (all objects in the bucket).

.. include:: /includes/common/scanner.rst
   :start-after: start-scanner-speed-config
   :end-before: end-scanner-speed-config

If versioning was not previously enabled when configuring bucket replication, 
existing objects have a ``versionid = null``. These objects do replicate.

MinIO existing object replication
implements functionality similar to 
`AWS: Replicating existing objects between S3 buckets
<https://aws.amazon.com/blogs/storage/replicating-existing-objects-between-s3-buckets/>`__
without the overhead of contacting technical support. 

Synchronous vs Asynchronous Replication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-sync-vs-async
   :end-before: end-replication-sync-vs-async

You must explicitly enable synchronous replication when configuring the remote
target target using the :mc-cmd:`mc admin bucket remote add` command with the
:mc-cmd:`~mc admin bucket remote add` flag.

Replication Internals
~~~~~~~~~~~~~~~~~~~~~

This section documents internal replication behavior and is not critical to
using or implementing replication. This documentation is provided strictly
for learning and educational purposes.

.. _minio-replication-process:

Replication Process
+++++++++++++++++++

MinIO uses a replication queuing system with multiple concurrent replication
workers operating on that queue. MinIO continuously works to replicate and
remove objects from the queue while scanning for new unreplicated objects to
add to the queue. 


.. versionchanged:: RELEASE.2022-07-18T17-49-40Z

   MinIO queues failed replication operations and retries those operations up to three (3) times.
   
   MinIO dequeues replication operations that fail to replicate after three attempts.
   The scanner can pick up those affected objects at a later time and requeue them for replication.
  
.. versionchanged:: RELEASE.2022-08-11T04-37-28Z

   Failed or pending replications requeue automatically when performing a list or any ``GET`` or ``HEAD`` API method. 
   For example, using :mc:`mc stat`, :mc:`mc cat`,  or :mc:`mc ls` after a remote location comes back online requeues replication.

MinIO sets the ``X-Amz-Replication-Status`` metadata field according to the
replication state of the object:

.. list-table::
   :header-rows: 1
   :width: 100%
   :widths: 30 70

   * - Replication State
     - Description

   * - ``PENDING``
     - The object has not yet been replicated. MinIO applies this state
       if the object meets one of the configured replication rules on the
       bucket. MinIO continuously scans for ``PENDING`` objects not yet in the
       replication queue and adds them to the queue as space is available.

       For multi-site replication, objects remain
       in the ``PENDING`` state until replicated to *all* configured
       remotes for that bucket or bucket prefix.

   * - ``COMPLETED``
     - The object has successfully replicated to the remote cluster.

   * - ``FAILED``
     - The object failed to replicate to the remote cluster. 

       MinIO continuously scans for ``FAILED`` objects not yet in the
       replication queue and adds them to the queue as space is available.

   * - ``REPLICA``
     - The object is itself a replica from a remote source.

The replication process generally has one of the following flows:

- ``PENDING -> COMPLETED``
- ``PENDING -> FAILED -> COMPLETED``

.. toctree::
   :hidden:
   :titlesonly:

   /administration/bucket-replication/bucket-replication-requirements
   /administration/bucket-replication/enable-server-side-one-way-bucket-replication
   /administration/bucket-replication/enable-server-side-two-way-bucket-replication
   /administration/bucket-replication/enable-server-side-multi-site-bucket-replication
   /administration/bucket-replication/server-side-replication-resynchronize-remote   
