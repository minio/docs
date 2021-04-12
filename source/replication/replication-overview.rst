.. _minio-bucket-replication:

==================
Bucket Replication
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO supports server-side and client-side replication of objects between source
and destination buckets. MinIO offers both active-passive (one-way) and
active-active (two-way) flavors of the following replication types:

:ref:`Server-Side Bucket Replication <minio-bucket-replication-serverside>`
  Configure per-bucket rules for automatically synchronizing objects between
  buckets within the same MinIO cluster *or* between two independent MinIO
  Clusters. MinIO applies rules as part of object write operations 
  (e.g. ``PUT``) and automatically synchronizes new objects *and* object
  mutations, such as new object versions or changes to object metadata.
  
  MinIO server-side bucket replication only supports MinIO clusters for the
  remote replication target.

:ref:`Client-side Bucket Replication <minio-bucket-replication-clientside>`
  Use the :mc-cmd:`mc mirror` process to synchronize objects between buckets
  within the same S3-compatible cluster *or* between two independent
  S3-compatible clusters. Client-side replication using :mc-cmd:`mc mirror`
  supports MinIO-to-S3 and similar replication configurations.

.. _minio-bucket-replication-serverside:

Server-Side Bucket Replication
------------------------------

MinIO server-side bucket replication is an automatic bucket-level configuration
that synchronizes objects between a source and destination bucket. MinIO
server-side replication *requires* the source and destination bucket be MinIO
clusters. The source and destination bucket *may* be the same MinIO cluster *or*
two independent MinIO clusters.

For each write operation to the bucket, MinIO checks all configured replication
rules for the bucket and applies the matching rule with highest configured
priority. MinIO synchronizes new objects *and* object mutations, such as 
new object versions or changes to object metadata. This includes
metadata operations such as enabling or modifying object locking or
retention settings.

MinIO server-side bucket replication is functionally similar to Amazon S3
replication while adding the following MinIO-only features:

- Source and destination bucket names can match, supporting site-to-site
  use cases such as Splunk or Veeam BC/DR. 

- Simplified implementation than S3 bucket replication configuration, removing
  the need to configure settings like AccessControlTranslation, Metrics, and 
  SourceSelectionCriteria.

- Active-Active (Two-Way) replication of objects between source and destination
  buckets.

.. _minio-replication-process:

Replication Process
~~~~~~~~~~~~~~~~~~~

MinIO uses a replication queuing system with multiple concurrent replication
workers operating on that queue. MinIO continuously works to replicate and
remove objects from the queue while scanning for new unreplicated objects to
add to the queue. 

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

   * - ``COMPLETED``
     - The object has successfully replicated to the remote cluster.

   * - ``FAILED``
     - The object failed to replicate to the remote cluster. 

       MinIO continuously scans for ``FAILED`` objects not yet in the
       replication queue and adds them to the queue as space is available.

   * - ``REPLICA``
     - The object is itself a replica from a remote source.

       MinIO ignores ``REPLICA`` objects, including any metadata-only changes
       to that object. MinIO does not support 
       AWS `replica modification sync 
       <https://aws.amazon.com/about-aws/whats-new/2020/12/amazon-s3-replication-adds-support-two-way-replication/>`__
       at this time.

The replication process generally has one of the following flows:

- ``PENDING -> COMPLETED``
- ``PENDING -> FAILED -> COMPLETED``

Synchronous vs Asynchronous Replication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports specifying either asynchronous (default) or synchronous
replication for a given remote target.

With the default asynchronous replication, MinIO completes the originating
``PUT`` operation *before* placing the object into a :ref:`replication queue
<minio-replication-process>`. The originating client may therefore see a 
successful ``PUT`` operation *before* the object is replicated. While
this may result in stale or missing objects on the remote, it mitigates
the risk of slow write operations due to replication load.
  
With synchronous replication, MinIO attempts to replicate the object *prior* to
completing the originating ``PUT`` operation. MinIO returns a successful ``PUT``
operation whether or not the replication attempts succeeds. While this may
result in more reliable synchronization between the source and remote target,
it may also increase the time of each write operation due to replication load.

You must explicitly enable synchronous replication when configuring the remote
target target using the :mc-cmd:`mc admin bucket remote add` command with the
:mc-cmd-option:`~mc admin bucket remote add sync` flag.

Replication of Delete Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating delete operations, where MinIO synchronizes
deleting specific object versions *and* new :s3-docs:`delete markers 
<delete-marker-replication.html>`. Delete operation replication uses
the same :ref:`replication process <minio-replication-process>` as all other
replication operations. 

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

MinIO requires explicitly enabling versioned deletes and delete marker
replication . Use the :mc-cmd-option:`mc replicate add replicate` field to
specify both or either ``delete`` and ``delete-marker`` to enable versioned
deletes and delete marker replication respectively. To enable both, specify both
strings using a comma separator ``delete,delete-marker``.

.. toctree::
   :hidden:
   :titlesonly:

   /replication/enable-server-side-one-way-bucket-replication
   /replication/enable-server-side-two-way-bucket-replication
   

.. _minio-bucket-replication-clientside:

Client-Side Bucket Replication
------------------------------

The :mc:`mc` command :mc-cmd:`mc mirror` supports watching a source bucket
and automatically replicating objects to a destination bucket. 

