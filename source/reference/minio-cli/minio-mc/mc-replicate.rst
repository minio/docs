================
``mc replicate``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc replicate

Description
-----------

.. start-mc-replicate-desc

The :mc:`mc replicate` command configures 
:ref:`Server-Side Bucket Replication <minio-bucket-replication-serverside>`
between MinIO deployments. 

.. end-mc-replicate-desc

Create Remote Target Before Configuring Replication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:mc:`mc replicate` depends on the ARN resource returned by 
:mc:`mc admin bucket remote`. 

Server-Side Replication Requires MinIO Source and Destination
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO server-side replication only works between MinIO deployments. Both the
source and destination deployments *must* run MinIO. 

To configure replication between arbitrary S3-compatible services,
use :mc-cmd:`mc mirror`.

Enable Versioning on Source and Destination Buckets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO relies on the immutability protections provided by versioning to
synchronize objects between the source and replication target.

Use the :mc-cmd:`mc version enable` command to enable versioning on 
*both* the source and destination bucket before starting this procedure:

.. code-block:: shell
   :class: copyable

   mc version enable ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc version enable TARGET>` with the
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc version enable TARGET>` with the bucket on which
  to enable versioning.

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

Replication of Existing Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with :mc:`mc` :minio-git:`RELEASE.2021-06-13T17-48-22Z
<mc/releases/tag/RELEASE.2021-06-13T17-48-22Z>` and :mc:`minio`
:minio-git:`RELEASE.2021-06-07T21-40-51Z
<minio/releases/tag/RELEASE.2021-06-07T21-40-51Z>`, MinIO supports automatically
replicating existing objects in a bucket. MinIO existing object replication
implements functionality similar to 
`AWS: Replicating existing objects between S3 buckets
<https://aws.amazon.com/blogs/storage/replicating-existing-objects-between-s3-buckets/>`__
without the overhead of contacting technical support. 

- To enable replication of existing objects when creating a new replication
  rule, include ``"existing-objects"`` to the list of replication features 
  specified to :mc-cmd-option:`mc replicate add replicate`.

- To enable replication of existing objects for an existing replication rule,
  add ``"existing-objects"`` to the list of existing replication features using
  :mc-cmd-option:`mc replicate add replicate`. You must specify *all*
  desired replication features when editing the replication rule. 

See :ref:`minio-replication-behavior-existing-objects` for more complete
documentation on this behavior.

Synchronization of Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports :ref:`two-way active-active
<minio-bucket-replication-serverside-twoway>` replication configurations, where
MinIO synchronizes new and modified objects between a bucket on two MinIO
deployments. Starting with :mc:`mc` :minio-git:`RELEASE.2021-05-18T03-39-44Z
<mc/releases/tag/RELEASE.2021-05-18T03-39-44Z>`, MinIO by default synchronizes
metadata-only changes to a replicated object back to the "source" deployment.
Prior to the this update, MinIO did not support synchronizing metadata-only
changes to a replicated object.

With metadata synchronization enabled, MinIO resets the object 
:ref:`replication status <minio-replication-process>` to indicate 
replication eligibility. Specifically, when an application performs a
metadata-only update to an object with the ``REPLICA`` status, MinIO marks the
object as ``PENDING`` and eligible for replication.

To disable metadata synchronization, use the 
:mc-cmd-option:`mc replicate edit replicate` command and omit 
``replica-metadata-sync`` from the replication feature list. 

Replication of Delete Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating delete operations onto the target bucket. 
Specifically, MinIO can replicate both 
:s3-docs:`Delete Markers <versioning-workflows.html>` *and* the deletion
of specific versioned objects:

- For delete operations on an object, MinIO replication also creates the delete
  marker on the target bucket. 

- For delete operations on versions of an object,
  MinIO replication also deletes those versions on the target bucket.

MinIO does *not* replicate objects deleted due to
:ref:`lifecycle management expiration rules
<minio-lifecycle-management-expiration>`. MinIO only replicates explicit
client-driven delete operations.

MinIO requires explicitly enabling replication of delete operations using the
:mc-cmd-option:`mc replicate add replicate` flag. This procedure includes the
required flags for enabling replication of delete operations and delete markers.
See :ref:`minio-replication-behavior-delete` for more complete documentation
on this behavior.

Replication of Encrypted Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating objects encrypted with automatic 
Server-Side Encryption (SSE-S3). Both the source and destination buckets
*must* have automatic SSE-S3 enabled for MinIO to replicate an encrypted object.

As part of the replication process, MinIO *decrypts* the object on the source
bucket and transmits the unencrypted object. The destination MinIO deployment then
re-encrypts the object using the destination bucket SSE-S3 configuration. MinIO
*strongly recommends* :ref:`enabling TLS <minio-TLS>` on both source and
destination deployments to ensure the safety of objects during transmission.

MinIO does *not* support replicating client-side encrypted objects 
(SSE-C).

Examples
--------

See the following tutorials for more complete procedures on configuring
server-side replication with :mc:`mc replicate`:

- :ref:`minio-bucket-replication-serverside-oneway`

Add a New Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc replicate add` to add a new replication rule to a bucket or bucket
prefix. :mc:`mc replicate` depends on the ARN resource returned by 
:mc:`mc admin bucket remote`. 

.. code-block:: shell
   :class: copyable

   mc replicate add ALIAS/PATH \
      --arn ARN \
      --remote-bucket BUCKET \
      [--FLAGS]

- Replace :mc-cmd:`ALIAS <mc replicate add SOURCE>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate add SOURCE>` with the path to the 
  bucket or bucket prefix on which to add the new rule.

- Replace :mc-cmd:`ARN <mc replicate add arn>` with the ARN of the 
  remote bucket target created by :mc:`mc admin bucket remote`.

- Replace :mc-cmd:`BUCKET <mc replicate add remote-bucket>` with the name of the
  remote bucket target. The specified bucket name *must* match the ``ARN``
  bucket.

Include all other optional flags.

Modify an Existing Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc replicate edit` to modify an existing replication rule.

.. code-block:: shell
   :class: copyable

   mc replicate edit ALIAS/PATH \
      --id ID \
      [--FLAGS]

- Replace :mc-cmd:`ALIAS <mc replicate edit SOURCE>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate edit SOURCE>` with the path to the 
  bucket or bucket prefix on which the rule exists.

- Replace :mc-cmd:`ID <mc replicate edit id>` with the unique identifier for the
  rule to modify. Use :mc-cmd:`mc replicate ls` to retrieve the list of 
  replication rules on the bucket and their corresponding identifiers.

.. important::

   MinIO applies replication rules to objects as part of write operations. 
   Modifying a replication rule has no effect on existing objects in the 
   bucket. For example, enabling delete marker replication through the 
   :mc-cmd-option:`~mc replicate edit replicate` option does not automatically
   replicate existing delete markers or deleted object versions.

Disable or Enable an Existing Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc replicate edit` with the
:mc-cmd-option:`~mc replicate edit state` flag to disable or enable a 
replication rule.

.. code-block:: shell
   :class: copyable

   mc replicate edit ALIAS/PATH \
      --id ID \
      --state "disabled"|"enabled"

- Replace :mc-cmd:`ALIAS <mc replicate edit SOURCE>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate edit SOURCE>` with the path to the 
  bucket or bucket prefix on which the rule exists.

- Replace :mc-cmd:`ID <mc replicate edit id>` with the unique identifier for the
  rule to modify. Use :mc-cmd:`mc replicate ls` to retrieve the list of 
  replication rules on the bucket and their corresponding identifiers.

- Specify either ``"disabled"`` or ``"enabled"`` to the 
  :mc-cmd:`~mc replicate edit state` flag to disable or enable the replication
  rule.

.. important::

   MinIO applies replication rules to objects as part of write operations. 
   Modifying a replication rule has no effect on existing objects in the 
   bucket. In context of enabling or disabling a replication rule, 
   objects written to a bucket with no enabled replication rules are 
   not automatically replicated if one or more rules are enabled later.

Remove a Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc replicate rm` to remove an existing replication rule:

.. code-block:: shell
   :class: copyable

   mc replicate rm ALIAS/PATH --id ID

- Replace :mc-cmd:`ALIAS <mc replicate rm SOURCE>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate rm SOURCE>` with the path to the 
  bucket or bucket prefix on which the rule exists.

- Replace :mc-cmd:`ID <mc replicate rm id>` with the unique identifier for the
  rule to modify. Use :mc-cmd:`mc replicate ls` to retrieve the list of 
  replication rules on the bucket and their corresponding identifiers.

.. important::

  MinIO applies replication rules to objects as part of write operations. 
  Deleting a replication rule has no effect on objects replicated as 
  part of that rule.

Syntax
------

.. mc-cmd:: add
   :fullpath:

   Adds a new server-side replication configuration rule for a bucket. 
   Requires specifying the resource returned by
   :mc:`mc admin bucket remote`.

   :mc-cmd:`mc replicate add` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc replicate add SOURCE \
         --arn ARN \
         --remote-bucket DESTINATION \
         --replicate OPTIONS \
         [FLAGS]

   :mc-cmd:`mc replicate add` supports the following arguments:

   .. mc-cmd:: SOURCE

      *Required*

      The full path to the bucket on which to add the bucket
      replication configuration. Specify the 
      :mc:`alias <mc alias>` of a configured MinIO service as the prefix to the 
      :mc-cmd:`~mc replicate add SOURCE` path. For example:

      .. code-block:: shell

         mc replicate add play/mybucket

   .. mc-cmd:: arn
      :option:

      *Deprecated in* :mc-release:`RELEASE.2021-09-23T05-44-03Z`. 
      :mc-cmd-option:`mc replicate add remote-bucket` supersedes all
      functionality provided by this option.

   .. mc-cmd:: remote-bucket
      :option:

      *Required*

      Specify the ARN for the destination deployment and bucket. You can
      retrieve the ARN using :mc-cmd:`mc admin bucket remote`:
      
      - Use the :mc-cmd:`mc admin bucket remote ls` to retrieve a list of 
        ARNs for the bucket on the destination deployment.

      - Use the :mc-cmd:`mc admin bucket remote add` to create a replication ARN
        for the bucket on the destination deployment. 

      The specified ARN bucket *must* match the value specified to
      :mc-cmd-option:`~mc replicate add remote-bucket`.

      *Added in* :mc-release:`RELEASE.2021-09-23T05-44-03Z`. Requires
      MinIO server :minio-release:`RELEASE.2021-09-23T04-46-24Z`.


   .. mc-cmd:: replicate
      :option:

      *Optional*

      Specify a comma-separated list of the following values to enable extended
      replication features. 

      - ``delete`` - Directs MinIO to replicate DELETE operations to the
        destination bucket.

      - ``delete-marker`` - Directs MinIO to replicate delete markers to the 
        destination bucket. 

      - ``existing-objects`` - Directs MinIO to replicate objects created
        before replication was enabled *or* while replication was suspended.

   .. mc-cmd:: tags
      :option:

      *Optional*

      Specify one or more ampersand ``&`` separated key-value pair tags which
      MinIO uses for filtering objects to replicate. For example:

      .. code-block:: shell

         --tags "TAG1=VALUE&TAG2=VALUE&TAG3=VALUE"

      MinIO applies the replication rule to any object whose tag set
      contains the specified replication tags.


   .. mc-cmd:: id
      :option:

      *Optional*

      Specify a unique ID for the replication rule. MinIO automatically
      generates an ID if one is not specified.


   .. mc-cmd:: priority
      :option:

      *Optional*

      Specify the integer priority of the replication rule. The value
      *must* be unique among all other rules on the source bucket. 
      Higher values imply a *higher* priority than all other rules.

      The default value is ``0``. 


   .. mc-cmd:: storage-class
      :option:

      *Optional*

      Specify the MinIO :ref:`storage class <minio-ec-storage-class>` to 
      apply to replicated objects. 


   .. mc-cmd:: insecure
      :option:

      *Optional*

      Disables verification of the destination deployment's TLS certificate.
      This option may be required if the destination deployment uses a 
      self-signed certificate *or* a certificate signed by an unknown 
      Certificate Authority.

   .. mc-cmd:: disable
      :option:

      *Optional*

      Creates the replication rule in the "disabled" state. MinIO
      does not begin replicating objects using the rule until it 
      is enabled using :mc-cmd:`mc replicate edit`.

      Objects created while replication is disabled are not
      immediately eligible for replication after enabling the rule.
      You must explicitly enable replication of existing
      objects by including ``"existing-objects"`` to the list of
      replication features specified to 
      :mc-cmd-option:`mc replicate edit replicate`. See
      :ref:`minio-replication-behavior-existing-objects` for more
      information.


.. mc-cmd:: edit
   :fullpath:

   Modifies an existing server-side replication configuration rule for a bucket.
   
   :mc-cmd:`mc replicate edit` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc replicate edit SOURCE --id IDENTIFIER [FLAGS]

   :mc-cmd:`mc replicate edit` supports the following arguments:

   .. mc-cmd:: SOURCE

      *Required*

      The full path to the bucket on which to edit the bucket
      replication configuration. Specify the 
      :mc:`alias <mc alias>` of a configured MinIO service as the prefix to the 
      :mc-cmd:`~mc replicate edit SOURCE` path. For example:

      .. code-block:: shell

         mc replicate edit play/mybucket

   .. mc-cmd:: id
      :option:

      *Required*

      Specify the unique ID for a configured replication rule. 

   .. mc-cmd:: remote-bucket
      :option:

      *Optional*

      Specify the name of the bucket on the destination deployment. The 
      name *must* match the replication rule ARN. Use 
      :mc-cmd:`mc replicate ls` to validate the ARN for each configured
      replication rule on the bucket.

   .. mc-cmd:: replicate
      :option:

      *Optional*

      Specify a comma-separated list of the following values to enable extended
      replication features:

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


   .. mc-cmd:: tags
      :option:

      *Optional*

      Specify one or more ampersand ``&`` separated key-value pair tags which
      MinIO uses for filtering objects to replicate. For example:

      .. code-block:: shell

         --tags "TAG1=VALUE&TAG2=VALUE&TAG3=VALUE"

      MinIO applies the replication rule to any object whose tag set
      contains the specified replication tags.

   .. mc-cmd:: priority
      :option:

      *Optional*

      Specify the integer priority of the replication rule. The value
      *must* be unique among all other rules on the source bucket. 
      Higher values imply a *higher* priority than all other rules.


   .. mc-cmd:: storage-class
      :option:

      *Optional*

      Specify the MinIO :ref:`storage class <minio-ec-storage-class>` to 
      apply to replicated objects. 


   .. mc-cmd:: insecure
      :option:

      *Optional*

      Disables verification of the destination deployment's TLS certificate.
      This option may be required if the destination deployment uses a 
      self-signed certificate *or* a certificate signed by an unknown 
      Certificate Authority.

   .. mc-cmd:: state
      :option:

      *Optional*

      Enables or disables the replication rule. Specify one of the following
      values:

      - ``"enable"`` - Enables the replication rule.

      - ``"disable"`` - Disables the replication rule. 

      Objects created while replication is disabled are not immediately eligible
      for replication after enabling the rule. You must explicitly enable
      replication of existing objects by including ``"existing-objects"`` to the
      list of replication features specified to 
      :mc-cmd-option:`mc replicate edit replicate`. See
      :ref:`minio-replication-behavior-existing-objects` for more information.

.. mc-cmd:: ls
   :fullpath:

   Lists the server-side replication configuration rules for a bucket.

   :mc-cmd:`mc replicate ls` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc replicate ls SOURCE [FLAGS]

   :mc-cmd:`mc replicate ls` supports the following arguments:

   .. mc-cmd:: SOURCE

      *Required*

      The full path to the bucket on which to list the
      replication configurations. Specify the 
      :mc:`alias <mc alias>` of a configured MinIO service as the prefix to the 
      :mc-cmd:`~mc replicate ls SOURCE` path. For example:

      .. code-block:: shell

         mc replicate ls play/mybucket

   .. mc-cmd:: insecure
      :option:

      *Optional*

      Disables verification of the destination deployment's TLS certificate.
      This option may be required if the destination deployment uses a 
      self-signed certificate *or* a certificate signed by an unknown 
      Certificate Authority.

   .. mc-cmd:: status
      :option:

      *Optional*

      Filter replication rules on the bucket based on their status. Specify
      one of the following values:

      - ``enabled`` - Show only enabled replication rules.
      - ``disabled`` - Show only disabled replication rules.
   
      If omitted, :mc-cmd:`mc replicate ls` defaults to showing all replication
      rules.
      

.. mc-cmd:: export
   :fullpath:

   Exports all server-side replication configuration rules for a bucket as a
   JSON document.

   :mc-cmd:`mc replicate export` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc replicate export SOURCE [FLAGS]

   :mc-cmd:`mc replicate export` supports the following arguments:

   .. mc-cmd:: SOURCE

      *Required*

      The full path to the bucket for which to export the
      replication configurations. Specify the 
      :mc:`alias <mc alias>` of a configured MinIO service as the prefix to the 
      :mc-cmd:`~mc replicate add SOURCE` path. For example:

      .. code-block:: shell

         mc replicate export play/mybucket

   .. mc-cmd:: insecure
      :option:

      *Optional*

      Disables verification of the destination deployment's TLS certificate.
      This option may be required if the destination deployment uses a 
      self-signed certificate *or* a certificate signed by an unknown 
      Certificate Authority.

.. mc-cmd:: import
   :fullpath:

   Imports JSON-formatted server-side replication rules for a bucket through
   ``STDIN``.

   :mc-cmd:`mc replicate import` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc replicate import SOURCE [FLAGS]

   :mc-cmd:`mc replicate import` also supports input redirection for
   specifying the path to the JSON-formatted rules:

   .. code-block:: shell
      :class: copyable

      mc replicate import SOURCE [FLAGS] < /path/to/config

   :mc-cmd:`mc replicate import` supports the following arguments:

   .. mc-cmd:: SOURCE

      *Required*

      The full path to the bucket to which to import the
      replication configurations. Specify the 
      :mc:`alias <mc alias>` of a configured MinIO service as the prefix to the 
      :mc-cmd:`~mc replicate import SOURCE` path. For example:

      .. code-block:: shell

         mc replicate import play/mybucket

   .. mc-cmd:: insecure
      :option:

      *Optional*

      Disables verification of the destination deployment's TLS certificate.
      This option may be required if the destination deployment uses a 
      self-signed certificate *or* a certificate signed by an unknown 
      Certificate Authority.


.. mc-cmd:: rm
   :fullpath:

   Removes one or more server-side replication rules on a bucket.

   :mc-cmd:`mc replicate rm` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc replicate rm SOURCE --id ID [FLAGS]

   :mc-cmd:`mc replicate rm` supports the following arguments:

   .. mc-cmd:: SOURCE

      *Required*

      The full path to the bucket on which to remove the bucket
      replication configuration. Specify the 
      :mc:`alias <mc alias>` of a configured MinIO service as the prefix to the 
      :mc-cmd:`~mc replicate rm SOURCE` path. For example:

      .. code-block:: shell

         mc replicate edit play/mybucket

   .. mc-cmd:: id
      :option:

      *Optional*

      Specify the unique ID for a configured replication rule.

   .. mc-cmd:: all
      :option:

      Removes all replication rules on the specified bucket. Requires
      specifying the :mc-cmd-option:`~mc replicate rm force` flag.

   .. mc-cmd:: force
      :option:

      *Optional*

      Required if specifying :mc-cmd-option:`~mc replicate rm all` .

.. mc-cmd:: resync, reset
   :fullpath:

   Resynchronizes all objects in the specified bucket to the remote target
   bucket. See :ref:`minio-replication-behavior-resync` for
   more complete documentation.

   :mc-cmd:`mc replicate resync` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc replicate resync SOURCE [args]

   :mc-cmd:`mc replicate resync` supports the following arguments:

   .. mc-cmd:: SOURCE

      *Required*

      The full path to the bucket on which to resync the bucket
      replication status. Specify the 
      :mc:`alias <mc alias>` of a configured MinIO service as the prefix to the 
      :mc-cmd:`~mc replicate edit SOURCE` path. For example:

      .. code-block:: shell

         mc replicate resync play/mybucket

   .. mc-cmd:: older-than

      *Optional*

      Specify a duration in days where MinIO only resynchronizes objects
      older than the specified duration.
