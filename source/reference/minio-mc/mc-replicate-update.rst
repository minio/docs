.. _minio-mc-replicate-edit:
.. _minio-mc-replicate-update:

=======================
``mc replicate update``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc replicate edit
.. mc:: mc replicate update


.. versionchanged:: RELEASE.2022-12-24T15-21-38Z 

   ``mc replicate update`` replaces the ``mc admin bucket remote update`` command.


.. versionchanged:: RELEASE.2022-11-07T23-47-39Z

   ``mc replicate update`` replaces the ``mc replicate edit`` command.

Syntax
------

.. start-mc-replicate-update-desc

The :mc:`mc replicate update` command modifies an existing 
:ref:`bucket replication rule <minio-bucket-replication-serverside>`.

.. end-mc-replicate-update-desc

.. code-block:: shell

   mc [GLOBALFLAGS] replicate update FLAGS [FLAGS] ARGUMENTS [ARGUMENTS]

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command modifies an existing replication rule for the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc replicate update --id "c76um9h4b0t1ijr36mug"           \
            --replicate "delete,delete-marker,existing-objects"  \
            myminio/mydata

      The new replication configuration synchronizes all versioned delete
      operations, delete marker creation, and existing objects to the remote
      MinIO deployment.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] replicate update              \
                          --remote-bucket string          \
                          [--bandwidth "string"]            \
                          [--healthcheck-seconds integer]   \
                          [--id "string"]                   \
                          [--limit-upload "string"]         \
                          [--limit-download "string"]       \
                          [--path "string"]                 \
                          [--priority int]                  \
                          [--proxy]
                          [--replicate "string"]            \
                          [--state string]
                          [--storage-class "string"]        \
                          [--sync string]                          \
                          [--tags "string"]                 \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment and full path to the bucket or bucket prefix on which to modify the replication rule. 
   For example:

   .. code-block:: none

      mc replicate update --id "c75nrap4b0talo3ipthg" [FLAGS]

.. mc-cmd:: --id
   :required:
   
   Specify the unique ID for a configured replication rule. 
   Use the :mc:`mc replicate ls` command to list the replication rules for a bucket.

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

.. mc-cmd:: --healthcheck-seconds
   :optional:

   The length of time in seconds between checks on the health of the remote bucket.

   If not specified, MinIO uses an interval of 60 seconds.

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

.. mc-cmd:: --proxy
   :optional:

   When defining active-active replication between buckets, do not proxy.

   Valid values include:

   - ``enable`` - Enable proxying in active-active replication.
   - ``disable`` - Disable proxying in active-active replication.

   By default, MinIO defaults to ``enable``.


.. mc-cmd:: --remote-bucket
   :optional:

   Specify the credentials, destination deployment, and bucket of the remote location.
   Value may be either location based (IP or URL) or path based.

   For example, a URL based target might look like the following:

   .. code-block::

      https://user:secret@myminio.cloudprovider.tld:9001/bucket

.. mc-cmd:: --replicate
   :optional:

   Specify a comma-separated list of the following values to enable extended replication features:

   - ``delete`` - Directs MinIO to replicate DELETE operations to the destination bucket.

   - ``delete-marker`` - Directs MinIO to replicate delete markers to the destination bucket. 

   - ``replica-metadata-sync`` - Directs MinIO to synchronize metadata-only changes on a replicated object back to the source. 
     This feature only effects :ref:`two-way active-active <minio-bucket-replication-serverside-twoway>` replication configurations.

     Omitting this value directs MinIO to stop replicating metadata-only changes back to the source. 

   - ``existing-objects`` - Directs MinIO to replicate objects created prior to configuring or enabling replication. 
     MinIO by default does *not* synchronize existing objects to the remote target.

     See :ref:`minio-replication-behavior-existing-objects` for more information.

.. mc-cmd:: --state
   :optional:

   Enables or disables the replication rule. 
   Specify one of the following values:

   - ``"enable"`` - Enables the replication rule.
   - ``"disable"`` - Disables the replication rule. 

   Objects created while replication is disabled are not immediately eligible for replication after enabling the rule. 
   You must explicitly enable replication of existing objects by including ``"existing-objects"`` to the list of replication features specified to :mc-cmd:`mc replicate update --replicate`. 
   
   See :ref:`minio-replication-behavior-existing-objects` for more information.

.. mc-cmd:: --storage-class
   :optional:

   Specify the MinIO :ref:`storage class <minio-ec-storage-class>` to apply to replicated objects. 

.. mc-cmd:: --sync
   :optional:

   Enable synchronous replication for this remote target.

   By default, MinIO uses asynchronous replication.

.. mc-cmd:: --tags
   :optional:

   Specify one or more ampersand ``&`` separated key-value pair tags which MinIO uses for filtering objects to replicate. For example:

   .. code-block:: shell

      mc replicate update --id "ID" --tags "TAG1=VALUE&TAG2=VALUE&TAG3=VALUE"

   MinIO applies the replication rule to any object whose tag set
   contains the specified replication tags.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Modify an Existing Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc replicate update` to modify an existing replication rule.

.. code-block:: shell
   :class: copyable

   mc replicate update ALIAS/PATH \
      --id ID                     \
      [--FLAGS]

- Replace :mc-cmd:`ALIAS <mc replicate update ALIAS>` with the :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate update ALIAS>` with the path to the bucket or bucket prefix on which the rule exists.

- Replace :mc-cmd:`ID <mc replicate update --id>` with the unique identifier for the rule to modify. 
  Use :mc:`mc replicate ls` to retrieve the list of replication rules on the bucket and their corresponding identifiers.

.. note::

   Modifying a replication configuration rule does not affect already replicated objects. 
   For example, modifying the :mc-cmd:`~mc replicate update --tags` filter does not result in the removal of replicated objects which do not meet the filter.


Update the Credentials for an Existing Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc replicate update` to modify an existing replication rule.

.. code-block:: shell
   :class: copyable

   mc replicate update ALIAS/PATH \
      --id ID                     \
      --remote-bucket https://user:secret@minio.mycloud.tld:9001/mybucket

- Replace :mc-cmd:`ALIAS <mc replicate update ALIAS>` with the :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate update ALIAS>` with the path to the bucket or bucket prefix on which the rule exists.

- Replace :mc-cmd:`ID <mc replicate update --remote-bucket>` with the updated credentials, path, and bucket.


Disable or Enable an Existing Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc replicate update` with the :mc-cmd:`~mc replicate update --state` flag to disable or enable a replication rule.

.. code-block:: shell
   :class: copyable

   mc replicate update ALIAS/PATH \
      --id ID \
      --state "disable"|"enable"

- Replace :mc-cmd:`ALIAS <mc replicate update ALIAS>` with the :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate update ALIAS>` with the path to the bucket or bucket prefix on which the rule exists.

- Replace :mc-cmd:`ID <mc replicate update --id>` with the unique identifier for the rule to modify. 
  Use :mc:`mc replicate ls` to retrieve the list of replication rules on the bucket and their corresponding identifiers.

- Specify either ``"disable"`` or ``"enable"`` to the :mc-cmd:`~mc replicate update --state` flag to disable or enable the replication rule.

.. note::

   MinIO requires enabling :ref:`existing object replication <minio-replication-behavior-existing-objects>` to synchronize objects written or removed after disabling a replication rule. 

   For rules *without* existing object replication, MinIO synchronizes only those write or delete operations issued while the replication rule is *enabled*.

Behavior
--------

Required Permissions
~~~~~~~~~~~~~~~~~~~~

MinIO strongly recommends creating users specifically for supporting bucket replication operations. 
See :mc:`mc admin user` and :mc:`mc admin policy` for more complete documentation on adding users and policies to a MinIO deployment.

.. tab-set::

   .. tab-item:: Replication Admin

      The following policy provides permissions for configuring and enabling
      replication on a deployment. 

      .. literalinclude:: /extra/examples/ReplicationAdminPolicy.json
         :class: copyable
         :language: json

      - The ``"EnableRemoteBucketConfiguration"`` statement grants permission
        for creating a remote target for supporting replication.

      - The ``"EnableReplicationRuleConfiguration"`` statement grants permission
        for creating replication rules on a bucket. The ``"arn:aws:s3:::*``
        resource applies the replication permissions to *any* bucket on the
        source deployment. You can restrict the user policy to specific buckets
        as-needed.

      Use the :mc-cmd:`mc admin policy create` to add this policy to each
      deployment acting as a replication source. Use :mc-cmd:`mc admin user add`
      to create a user on the deployment and :mc-cmd:`mc admin policy attach`
      to associate the policy to that new user.

   .. tab-item:: Replication Remote User

      The following policy provides permissions for enabling synchronization of
      replicated data *into* the deployment. 

      .. literalinclude:: /extra/examples/ReplicationRemoteUserPolicy.json
         :class: copyable
         :language: json

      - The ``"EnableReplicationOnBucket"`` statement grants permission for 
        a remote target to retrieve bucket-level configuration for supporting
        replication operations on *all* buckets in the MinIO deployment. To
        restrict the policy to specific buckets, specify those buckets as an
        element in the ``Resource`` array similar to
        ``"arn:aws:s3:::bucketName"``.

      - The ``"EnableReplicatingDataIntoBucket"`` statement grants permission
        for a remote target to synchronize data into *any* bucket in the MinIO
        deployment. To restrict the policy to specific buckets, specify those 
        buckets as an element in the ``Resource`` array similar to 
        ``"arn:aws:s3:::bucketName/*"``.

      Use the :mc-cmd:`mc admin policy create` to add this policy to each
      deployment acting as a replication target. Use :mc-cmd:`mc admin user add`
      to create a user on the deployment and :mc-cmd:`mc admin policy attach`
      to associate the policy to that new user.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
