.. _minio-mc-replicate-add:

====================
``mc replicate add``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc replicate add

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z 

   ``mc replicate add`` replaces the ``mc admin bucket remote add`` command.

   MinIO automatically creates remote targets based on a given file path or resource location (such as an IP or DNS address).
   Users defining a remote target no longer need to determine an ARN for the remote bucket.

Syntax
------

.. start-mc-replicate-add-desc

The :mc:`mc replicate add` command creates a new :ref:`server-side replication
<minio-bucket-replication-serverside>` rule for a bucket on a MinIO deployment.

.. end-mc-replicate-add-desc

.. note::

   Where :mc:`mc mirror` only synchronizes the current version of an object, ``mc replicate`` synchronizes all versions, version information, and metadata for the objects.

The MinIO deployment automatically begins synchronizing new objects to the remote MinIO deployment after creating the rule. 
You can optionally configure synchronization of existing objects, delete operations, and fully-deleted objects.

This command *requires* first configuring the remote bucket target using the
:mc-cmd:`mc admin bucket remote add` command. You must specify the resulting
remote ARN as part of running :mc:`mc replicate add`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command adds a new replication rule for the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc replicate add                                                     \
            --remote-bucket https://user:secret@minio.mysite.tld:9090/bucket  \
            --replicate "delete,delete-marker,existing-objects"               \
            myminio/mydata

      The replication rule synchronizes versioned delete operations, delete markers, and existing objects to the remote MinIO deployment.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] replicate add                     \
                          --remote-bucket string          \
                          [--bandwidth "string"]            \
                          [--disable]                       \
                          [--disable-proxy]                 \
                          [--healthcheck-seconds integer]   \
                          [--id "string"]                   \
                          [--limit-upload "string"]         \
                          [--limit-download "string"]       \
                          [--path "string"]                 \
                          [--region "string"]               \
                          [--replicate "string"]            \
                          [--storage-class "string"]        \
                          [--sync]                          \
                          [--tags "string"]                 \
                          [--priority int]                  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment and full path to the bucket or bucket prefix on which to create the replication rule. 
   For example:

   .. code-block:: none

      mc replicate add --remote-bucket https://user:secret@myminio.cloudprovider.tld:9090/bucket play/mybucket

.. mc-cmd:: --remote-bucket
   :required:

   Specify the credentials, destination deployment, and bucket of the remote location. 

   For example, a URL based target might look like the following:

   .. code-block::

      https://user:secret@myminio.cloudprovider.tld:9090/bucket

.. mc-cmd:: --bandwidth
   :optional:

   Limit bandwidth rates to no more than the specified rate in KiB/s, MiB/s, or GiB/s.
   Valid units include: 
   
   - ``B`` for bytes
   - ``K`` for kilobytes
   - ``G`` for gigabytes
   - ``T`` for terabytes
   - ``Ki`` for kibibytes
   - ``Gi`` for gibibytes
   - ``Ti`` for tebibytes

   For example, to limit bandwidth rates to no more than 1 GiB/s, use the following:

   .. code-block::

      --limit-upload 1Gi

   If not specified, MinIO does not limit the bandwidth rate.

    
.. mc-cmd:: --disable
   :optional:

   Creates the replication rule in the "disabled" state. 
   MinIO does not begin replicating objects using the rule until it is enabled using :mc:`mc replicate update`.

   Objects created while replication is disabled are not immediately eligible for replication after enabling the rule.
   You must explicitly enable replication of existing objects by including ``"existing-objects"`` to the list of replication features specified to :mc-cmd:`mc replicate update --replicate`. 
   See :ref:`minio-replication-behavior-existing-objects` for more information.

.. mc-cmd:: --disable-proxy
   :optional:

   When defining active-active replication between buckets, do not proxy.

   By default, MinIO proxies.

.. mc-cmd:: --healthcheck-seconds
   :optional:

   The length of time in seconds between checks on the health of the remote bucket.

   If not specified, MinIO uses an interval of 60 seconds.

.. mc-cmd:: --id
   :optional:

   Specify a unique ID for the replication rule. 
   MinIO automatically generates an ID if one is not specified.

.. mc-cmd:: --limit-download
   :optional:

   Limit download rates to no more than a specified rate in KiB/s, MiB/s, or GiB/s.
   Valid units include: 
   
   - ``B`` for bytes
   - ``K`` for kilobytes
   - ``G`` for gigabytes
   - ``T`` for terabytes
   - ``Ki`` for kibibytes
   - ``Gi`` for gibibytes
   - ``Ti`` for tebibytes

   For example, to limit download rates to no more than 1 GiB/s, use the following:

   .. code-block::

      --limit-download 1G

   If not specified, MinIO uses an unlimited download rate.

.. mc-cmd:: --limit-upload
   :optional:

   Limit upload rates to no more than the specified rate in KiB/s, MiB/s, or GiB/s.
   Valid units include: 
   
   - ``B`` for bytes
   - ``K`` for kilobytes
   - ``G`` for gigabytes
   - ``T`` for terabytes
   - ``Ki`` for kibibytes
   - ``Gi`` for gibibytes
   - ``Ti`` for tebibytes

   For example, to limit upload rates to no more than 1 GiB/s, use the following:

   .. code-block::

      --limit-upload 1G

   If not specified, MinIO uses an unlimited upload rate.


.. mc-cmd:: --path
   :optional:

   Enable path-style lookup support for the remote bucket.

   Valid values include:

   - ``on`` - use a path lookup to find the remote bucket
   - ``off`` - use a resource locator style (such as a domain or IP address) lookup to find the remote bucket
   - ``auto`` - ask MinIO to identify the correct type of lookup to use to find the remote bucket

   When not defined, MinIO uses the ``auto`` value.

.. mc-cmd:: --priority
   :optional:

   Specify the integer priority of the replication rule. 
   The value *must* be unique among all other rules on the source bucket. 
   Higher values imply a *higher* priority than all other rules.

   The default value is ``0``. 

.. mc-cmd:: --region
   :optional:

   The region of the destination bucket to replicate contents to.

.. mc-cmd:: --replicate
   :optional:

   Specify a comma-separated list of the following values to enable extended replication features. 

   - ``delete`` - Directs MinIO to replicate DELETE operations to the destination bucket.

   - ``delete-marker`` - Directs MinIO to replicate delete markers to the destination bucket. 

   - ``existing-objects`` - Directs MinIO to replicate objects created before replication was enabled *or* while replication was suspended.

   - ``metadata-sync`` - Directs MinIO to replicate metadata for each object.
     For active-active replication situations only.

     Omitting this value directs MinIO to stop replicating metadata-only changes back to the source. 

   If not specified, MinIO syncs all options.

.. mc-cmd:: --storage-class
   :optional:

   Specify the MinIO :ref:`storage class <minio-ec-storage-class>` to apply to replicated objects. 

.. mc-cmd:: --sync
   :optional:

   Enable synchronous replication for this remote target.

   By default, MinIO uses asynchronous replication.

.. mc-cmd:: --tags
   :optional:

   Specify one or more ampersand ``&`` separated key-value pair tags which MinIO uses for filtering objects to replicate. 
   For example:

   .. code-block:: shell

      mc replicate add --tags "TAG1=VALUE&TAG2=VALUE&TAG3=VALUE" ALIAS

   MinIO applies the replication rule to any object whose tag set
   contains the specified replication tags.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Configure Bucket Replication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following :mc:`mc replicate add` command creates a replication configuration that synchronizes all new objects, existing objects, delete operations, and delete markers to the remote target:

.. code-block:: shell
   :class: copyable

   mc replicate add myminio/mybucket \
      --remote-bucket https://user:secret@minio.mysite.tld/remotebucket \
      --replicate "delete,delete-marker,existing-objects"

- Replace ``myminio/mybucket`` with the :mc-cmd:`~mc replicate add ALIAS` and full bucket path for which to create the replication configuration.

- Replace the :mc-cmd:`~mc replicate add --remote-bucket` value with the URL or path of the remote target. 
  If using a file path format location, use the ``--path on`` option.

- The :mc-cmd:`~mc replicate add --replicate` flag directs MinIO to replicate all delete operations, delete markers, and existing objects to the remote. 
  See :ref:`minio-replication-behavior-delete` and :ref:`minio-replication-behavior-existing-objects` for more information on replication behavior.

Configure Bucket Replication for Historical Data Record
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following :mc:`mc replicate add` command creates a new bucket replication configuration that synchronizes all new and existing objects to the remote target:

.. code-block:: shell
   :class: copyable

   mc replicate add myminio/mybucket \
      --remote-bucket https://user:secret@minio.mysite.tld/remotebucket \
      --replicate "existing-objects"

- Replace ``myminio/mybucket`` with the :mc-cmd:`~mc replicate add ALIAS` and full bucket path for which to create the replication configuration.

- Replace the :mc-cmd:`~mc replicate add --remote-bucket` value with the location of the remote target. 
  If using a file path format location, use the ``--path on`` option.

- The :mc-cmd:`~mc replicate add --replicate` flag directs MinIO to replicate all existing objects to the remote. 
  See :ref:`minio-replication-behavior-existing-objects` for more information on replication behavior.

The resulting remote copy represents a historical record of objects on the remote, where delete operations on the source have no effect on the remote copy.

Behavior
--------

Server-Side Replication Requires MinIO Source and Destination
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO server-side replication only works between MinIO deployments. 
Both the source and destination deployments *must* run MinIO. 

To configure replication between arbitrary S3-compatible services, use :mc:`mc mirror`.

Enable Versioning on Source and Destination Buckets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO relies on the immutability protections provided by versioning to synchronize objects between the source and replication target.

Use the :mc:`mc version enable` command to enable versioning on *both* the source and destination bucket before starting this procedure:

.. code-block:: shell
   :class: copyable

   mc version enable ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc version ALIAS>` with the :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc version ALIAS>` with the bucket on which to enable versioning.

Required Permissions
~~~~~~~~~~~~~~~~~~~~

MinIO strongly recommends creating users specifically for supporting bucket replication operations. 
See :mc:`mc admin user` and :mc:`mc admin policy` for more complete documentation on adding users and policies to a MinIO deployment.

.. tab-set::

   .. tab-item:: Replication Admin

      The following policy provides permissions for configuring and enabling replication on a deployment. 

      .. literalinclude:: /extra/examples/ReplicationAdminPolicy.json
         :class: copyable
         :language: json

      - The ``"EnableRemoteBucketConfiguration"`` statement grants permission for creating a remote target for supporting replication.

      - The ``"EnableReplicationRuleConfiguration"`` statement grants permission for creating replication rules on a bucket. 
        The ``"arn:aws:s3:::*`` resource applies the replication permissions to *any* bucket on the source deployment. 
        You can restrict the user policy to specific buckets as-needed.

      Use the :mc-cmd:`mc admin policy create` to add this policy to each deployment acting as a replication source. 
      Use :mc-cmd:`mc admin user add` to create a user on the deployment and :mc-cmd:`mc admin policy attach` to associate the policy to that new user.

   .. tab-item:: Replication Remote User

      The following policy provides permissions for enabling synchronization of replicated data *into* the deployment. 

      .. literalinclude:: /extra/examples/ReplicationRemoteUserPolicy.json
         :class: copyable
         :language: json

      - The ``"EnableReplicationOnBucket"`` statement grants permission for a remote target to retrieve bucket-level configuration for supporting replication operations on *all* buckets in the MinIO deployment. 
        To restrict the policy to specific buckets, specify those buckets as an element in the ``Resource`` array similar to ``"arn:aws:s3:::bucketName"``.

      - The ``"EnableReplicatingDataIntoBucket"`` statement grants permission for a remote target to synchronize data into *any* bucket in the MinIO deployment. 
        To restrict the policy to specific buckets, specify those buckets as an element in the ``Resource`` array similar to ``"arn:aws:s3:::bucketName/*"``.

      Use the :mc-cmd:`mc admin policy create` to add this policy to each deployment acting as a replication target. 
      Use :mc-cmd:`mc admin user add` to create a user on the deployment and :mc-cmd:`mc admin policy attach` to associate the policy to that new user.

Replication of Existing Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with :mc:`mc` :minio-git:`RELEASE.2021-06-13T17-48-22Z <mc/releases/tag/RELEASE.2021-06-13T17-48-22Z>` and :mc:`minio` :minio-git:`RELEASE.2021-06-07T21-40-51Z <minio/releases/tag/RELEASE.2021-06-07T21-40-51Z>`, MinIO supports automatically replicating existing objects in a bucket. 
MinIO existing object replication implements functionality similar to `AWS Replicating existing objects between S3 buckets <https://aws.amazon.com/blogs/storage/replicating-existing-objects-between-s3-buckets/>`__ without the overhead of contacting technical support. 

- To enable replication of existing objects when creating a new replication rule, include ``"existing-objects"`` to the list of replication features specified to :mc-cmd:`mc replicate add --replicate`.

- To enable replication of existing objects for an existing replication rule, add ``"existing-objects"`` to the list of existing replication features using :mc-cmd:`mc replicate add --replicate`. 
  You must specify *all* desired replication features when editing the replication rule. 

See :ref:`minio-replication-behavior-existing-objects` for more complete documentation on this behavior.

Synchronization of Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports :ref:`two-way active-active <minio-bucket-replication-serverside-twoway>` replication configurations, where MinIO synchronizes new and modified objects between a bucket on two MinIO deployments. 
Starting with :mc:`mc` :minio-git:`RELEASE.2021-05-18T03-39-44Z <mc/releases/tag/RELEASE.2021-05-18T03-39-44Z>`, MinIO by default synchronizes metadata-only changes to a replicated object back to the "source" deployment. 
Prior to the this update, MinIO did not support synchronizing metadata-only changes to a replicated object.

With metadata synchronization enabled, MinIO resets the object :ref:`replication status <minio-replication-process>` to indicate replication eligibility. 
Specifically, when an application performs a metadata-only update to an object with the ``REPLICA`` status, MinIO marks the object as ``PENDING`` and eligible for replication.

To disable metadata synchronization, use the :mc-cmd:`mc replicate update --replicate` command and omit ``replica-metadata-sync`` from the replication feature list. 

Replication of Delete Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating delete operations onto the target bucket. 
Specifically, MinIO can replicate both :s3-docs:`Delete Markers <versioning-workflows.html>` *and* the deletion of specific versioned objects:

- For delete operations on an object, MinIO replication also creates the delete marker on the target bucket. 

- For delete operations on versions of an object, MinIO replication also deletes those versions on the target bucket.

MinIO does *not* replicate objects deleted due to :ref:`lifecycle management expiration rules <minio-lifecycle-management-expiration>`. 
MinIO only replicates explicit client-driven delete operations.

MinIO requires explicitly enabling replication of delete operations using the :mc-cmd:`mc replicate add --replicate` flag. 
This procedure includes the required flags for enabling replication of delete operations and delete markers.
See :ref:`minio-replication-behavior-delete` for more complete documentation on this behavior.

Replication of Encrypted Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating objects encrypted with automatic Server-Side Encryption (SSE-S3). 
Both the source and destination buckets *must* have automatic SSE-S3 enabled for MinIO to replicate an encrypted object.

As part of the replication process, MinIO *decrypts* the object on the source bucket and transmits the unencrypted object. 
The destination MinIO deployment then re-encrypts the object using the destination bucket SSE-S3 configuration.
MinIO *strongly recommends* :ref:`enabling TLS <minio-TLS>` on both source and destination deployments to ensure the safety of objects during transmission.

MinIO does *not* support replicating client-side encrypted objects (SSE-C).

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
