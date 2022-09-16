.. _minio-mc-replicate-edit:

=====================
``mc replicate edit``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc replicate edit

Syntax
------

.. start-mc-replicate-edit-desc

The :mc:`mc replicate edit` command modifies an existing 
:ref:`bucket replication rule <minio-bucket-replication-serverside>`.

.. end-mc-replicate-edit-desc

.. code-block:: shell

   mc [GLOBALFLAGS] replicate edit FLAGS [FLAGS] ARGUMENTS [ARGUMENTS]

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command modifies an existing replication rule for the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc replicate edit --id "c76um9h4b0t1ijr36mug"           \
            --replicate "delete,delete-marker,existing-objects"  \
            myminio/mydata

      The new replication configuration synchronizes all versioned delete
      operations, delete marker creation, and existing objects to the remote
      MinIO deployment.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] replicate edit                \
                          --id "string"                 \
                          [--remote-bucket "string"]    \
                          [--disable]                   \
                          [--id "string"]               \
                          [--replicate "string"]        \
                          [--state "string"]            \
                          [--storage-class "string"]    \
                          [--tags "string"]             \
                          [--priority int]              \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* the :ref:`alias <alias>` of the MinIO deployment and full path to
   the bucket or bucket prefix on which to modify the replication rule. For
   example:

   .. code-block:: none

      mc replicate edit --id "c75nrap4b0talo3ipthg" [FLAGS]

.. mc-cmd:: --id
   

   *Required* Specify the unique ID for a configured replication rule. 
   Use the :mc:`mc replicate ls` command to list the replication rules
   for a bucket.

.. mc-cmd:: --priority
   

   *Optional* Specify the integer priority of the replication rule. The value
   *must* be unique among all other rules on the source bucket. Higher values
   imply a *higher* priority than all other rules.

.. mc-cmd:: --remote-bucket
   

    *Optional* Specify the ARN for the destination deployment and bucket. You
    can retrieve the ARN using :mc-cmd:`mc admin bucket remote`:
    
    - Use the :mc-cmd:`mc admin bucket remote ls` to retrieve a list of 
      ARNs for the bucket on the destination deployment.

    - Use the :mc-cmd:`mc admin bucket remote add` to create a replication ARN
      for the bucket on the destination deployment. 

.. mc-cmd:: --replicate
   

   *Optional* Specify a comma-separated list of the following values to enable
   extended replication features:

   - ``delete`` - Directs MinIO to replicate DELETE operations to the
     destination bucket.

   - ``delete-marker`` - Directs MinIO to replicate delete markers to the 
     destination bucket. 

   - ``replica-metadata-sync`` - Directs MinIO to synchronize metadata-only
     changes on a replicated object back to the source. This feature only
     effects :ref:`two-way active-active
     <minio-bucket-replication-serverside-twoway>` replication
     configurations.

     Omitting this value directs MinIO to stop replicating metadata-only
     changes back to the source. 

   - ``existing-objects`` - Directs MinIO to replicate objects created
     prior to configuring or enabling replication. MinIO by default does
     *not* synchronize existing objects to the remote target.

     See :ref:`minio-replication-behavior-existing-objects` for more
     information.

.. mc-cmd:: --state
   

   *Optional* Enables or disables the replication rule. Specify one of the
   following values:

   - ``"enable"`` - Enables the replication rule.

   - ``"disable"`` - Disables the replication rule. 

   Objects created while replication is disabled are not immediately eligible
   for replication after enabling the rule. You must explicitly enable
   replication of existing objects by including ``"existing-objects"`` to the
   list of replication features specified to 
   :mc-cmd:`mc replicate edit --replicate`. See
   :ref:`minio-replication-behavior-existing-objects` for more information.

.. mc-cmd:: --storage-class
   

   *Optional*  Specify the MinIO :ref:`storage class <minio-ec-storage-class>`
   to apply to replicated objects. 

.. mc-cmd:: --tags
   

   *Optional* Specify one or more ampersand ``&`` separated key-value pair tags
   which MinIO uses for filtering objects to replicate. For example:

   .. code-block:: shell

      mc replicate edit --id "ID" --tags "TAG1=VALUE&TAG2=VALUE&TAG3=VALUE"

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

Use :mc:`mc replicate edit` to modify an existing replication rule.

.. code-block:: shell
   :class: copyable

   mc replicate edit ALIAS/PATH \
      --id ID \
      [--FLAGS]

- Replace :mc-cmd:`ALIAS <mc replicate edit ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate edit ALIAS>` with the path to the 
  bucket or bucket prefix on which the rule exists.

- Replace :mc-cmd:`ID <mc replicate edit --id>` with the unique identifier for the
  rule to modify. Use :mc:`mc replicate ls` to retrieve the list of 
  replication rules on the bucket and their corresponding identifiers.

.. note::

   Modifying a replication configuration rule does not effect already replicated
   objects. For example, modifying the :mc-cmd:`~mc replicate edit --tags`
   filter does not result in the removal of replicated objects which do not
   meet the filter.

Disable or Enable an Existing Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc replicate edit` with the
:mc-cmd:`~mc replicate edit --state` flag to disable or enable a 
replication rule.

.. code-block:: shell
   :class: copyable

   mc replicate edit ALIAS/PATH \
      --id ID \
      --state "disabled"|"enabled"

- Replace :mc-cmd:`ALIAS <mc replicate edit ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate edit ALIAS>` with the path to the 
  bucket or bucket prefix on which the rule exists.

- Replace :mc-cmd:`ID <mc replicate edit --id>` with the unique identifier for the
  rule to modify. Use :mc:`mc replicate ls` to retrieve the list of 
  replication rules on the bucket and their corresponding identifiers.

- Specify either ``"disabled"`` or ``"enabled"`` to the 
  :mc-cmd:`~mc replicate edit --state` flag to disable or enable the replication
  rule.

.. note::

   MinIO requires enabling :ref:`existing object replication 
   <minio-replication-behavior-existing-objects>` to synchronize objects
   written or removed after disabling a replication rule. 

   For rules *without* existing object replication, MinIO synchronizes only
   those write or delete operations issued while the replication rule is
   *enabled*.

Behavior
--------

Required Permissions
~~~~~~~~~~~~~~~~~~~~

MinIO strongly recommends creating users specifically for supporting 
bucket replication operations. See 
:mc:`mc admin user` and :mc:`mc admin policy` for more complete
documentation on adding users and policies to a MinIO deployment.

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

      Use the :mc-cmd:`mc admin policy add` to add this policy to each
      deployment acting as a replication source. Use :mc-cmd:`mc admin user add`
      to create a user on the deployment and :mc-cmd:`mc admin policy set`
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

      Use the :mc-cmd:`mc admin policy add` to add this policy to each
      deployment acting as a replication target. Use :mc-cmd:`mc admin user add`
      to create a user on the deployment and :mc-cmd:`mc admin policy set`
      to associate the policy to that new user.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
