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

MinIO server-side replication only works between MinIO clusters. Both the
source and destination clusters *must* run MinIO. 

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
  :mc:`alias <mc alias>` of the MinIO cluster.

- Replace :mc-cmd:`PATH <mc version enable TARGET>` with the bucket on which
  to enable versioning.

Required Permissions
~~~~~~~~~~~~~~~~~~~~

Bucket Replication requires at minimum the following permissions on the 
source and destination clusters:

.. tabs::

   .. tab:: Source Policy

      The source cluster *must* have a user with *at minimum* following attached
      *or* inherited policy:

      .. code-block:: shell
         :class: copyable

         {
            "Version": "2012-10-17",
            "Statement": [
               {
                     "Action": [
                        "admin:SetBucketTarget",
                        "admin:GetBucketTarget"
                     ],
                     "Effect": "Allow",
                     "Sid": ""
               },
               {
                     "Effect": "Allow",
                     "Action": [
                        "s3:GetReplicationConfiguration",
                        "s3:ListBucket",
                        "s3:ListBucketMultipartUploads",
                        "s3:GetBucketLocation",
                        "s3:GetBucketVersioning"
                     ],
                     "Resource": [
                        "arn:aws:s3:::SOURCEBUCKETNAME"
                     ]
               }
            ]
         }

      Replace ``SOURCEBUCKETNAME`` with the name of the source bucket from which
      MinIO replicates objects. 

      Use the :mc-cmd:`mc admin policy set` command to associate the policy to
      a user on the source MinIO cluster.

   .. tab:: Destination Policy

      The destination cluster *must* have a user with *at minimum* the
      following attached *or* inherited policy:

      .. code-block:: shell
         :class: copyable

         {
            "Version": "2012-10-17",
            "Statement": [
               {
                     "Effect": "Allow",
                     "Action": [
                        "s3:GetReplicationConfiguration",
                        "s3:ListBucket",
                        "s3:ListBucketMultipartUploads",
                        "s3:GetBucketLocation",
                        "s3:GetBucketVersioning",
                        "s3:GetBucketObjectLockConfiguration"
                     ],
                     "Resource": [
                        "arn:aws:s3:::DESTINATIONBUCKETNAME"
                     ]
               },
               {
                     "Effect": "Allow",
                     "Action": [
                        "s3:GetReplicationConfiguration",
                        "s3:ReplicateTags",
                        "s3:AbortMultipartUpload",
                        "s3:GetObject",
                        "s3:GetObjectVersion",
                        "s3:GetObjectVersionTagging",
                        "s3:PutObject",
                        "s3:DeleteObject",
                        "s3:ReplicateObject",
                        "s3:ReplicateDelete"
                     ],
                     "Resource": [
                        "arn:aws:s3:::DESTINATIONBUCKETNAME/*"
                     ]
               }
            ]
         }

      Replace ``DESTINATIONBUCKETNAME`` with the name of the target bucket to
      which MinIO replicates objects.

      Use the :mc-cmd:`mc admin policy set` command to associate the policy 
      to a user on the target MinIO cluster.

MinIO strongly recommends creating users specifically for supporting 
bucket replication operations. See 
:mc:`mc admin user` and :mc:`mc admin policy` for more complete
documentation on adding users and policies to a MinIO cluster.

Replication of Existing Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO performs replication as part of writing an object (PUT operations). 
MinIO does *not* apply replication rules to existing objects written
*before* enabling replication.

For buckets with existing objects, consider using :mc:`mc mirror` or 
:mc:`mc cp` to seed the destination bucket. Consider scheduling a maintenance
window during which applications stop writes to the bucket. Once 
the :mc:`~mc mirror` or :mc:`~mc cp` fully sync the source and destination,
enable bucket replication and resume normal operations on the bucket.

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

MinIO requires explicitly enabling replication of delete operations using the
:mc-cmd-option:`mc replicate add replicate` flag. This procedure includes the
required flags for enabling replication of delete operations and delete markers.

.. note::

   If a delete operation removes the last object in a bucket prefix, MinIO
   recursively deletes any empty directories within that prefix. For example:

   ``play/mybucket/path/to/foo.txt``

   The bucket prefix is ``/path/to/foo.txt``. If ``foo.txt`` is the last object
   in prefix, MinIO deletes the entire prefix. If an object exists at ``/path``,
   MinIO stops deleting the prefix at that point. 

.. admonition:: MinIO Trims Empty Object Prefixes

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
   located at that prefix. If a command removes ``myphoto.jpg``, it also
   automatically trims the empty ``/janaury`` prefix. If <command> then removes
   the ``myotherphoto.jpg``, it also automatically trims both the ``/february``
   prefix *and* the now-empty ``/2021`` prefix. If <command> removes the
   ``NewYears.jpg`` object, the ``/NYE21`` prefix remains in place since it was
   *explicitly* created.

Replication of Encrypted Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating objects encrypted with automatic 
Server-Side Encryption (SSE-S3). Both the source and destination buckets
*must* have automatic SSE-S3 enabled for MinIO to replicate an encrypted object.

As part of the replication process, MinIO *decrypts* the object on the source
bucket and transmits the unencrypted object. The destination MinIO cluster then
re-encrypts the object using the destination bucket SSE-S3 configuration. MinIO
*strongly recommends* :ref:`enabling TLS <minio-TLS>` on both source and
destination clusters to ensure the safety of objects during transmission.

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
  :mc:`alias <mc alias>` of the MinIO cluster.

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
  :mc:`alias <mc alias>` of the MinIO cluster.

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
  :mc:`alias <mc alias>` of the MinIO cluster.

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
  :mc:`alias <mc alias>` of the MinIO cluster.

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

      *Required*

      Specify the ARN for the destination cluster and bucket. You can
      retrieve the ARN using :mc-cmd:`mc admin bucket remote`:
      
      - Use the :mc-cmd:`mc admin bucket remote ls` to retrieve a list of 
        ARNs for the bucket on the destination cluster.

      - Use the :mc-cmd:`mc admin bucket remote add` to create an ARN for 
        the bucket on the destination cluster. 

      The specified ARN bucket *must* match the value specified to
      :mc-cmd-option:`~mc replicate add remote-bucket`.


   .. mc-cmd:: remote-bucket
      :option:

      *Required*

      Specify the name of the bucket on the destination cluster. The 
      name *must* match the ARN specified to 
      :mc-cmd-option:`~mc replicate add arn`.


   .. mc-cmd:: replicate
      :option:

      *Optional*

      Specify a comma-separated list of the following values to enable extended
      replication features:

      - ``delete`` - Directs MinIO to replicate DELETE operations to the
        destination bucket.

      - ``delete-marker`` - Directs MinIO to replicate delete markers to the 
        destination bucket. 


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

      Disables verification of the destination cluster's TLS certificate.
      This option may be required if the destination cluster uses a 
      self-signed certificate *or* a certificate signed by an unknown 
      Certificate Authority.

   .. mc-cmd:: disable
      :option:

      *Optional*

      Creates the replication rule in the "disabled" state. MinIO
      does not begin replicating objects using the rule until it 
      is enabled using :mc-cmd:`mc replicate edit`.


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

      Specify the name of the bucket on the destination cluster. The 
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

      MinIO does *not* apply the updated replication rules to existing 
      objects in the source bucket. For example, enabling delete marker
      replication does not automatically replicate existing objects with 
      delete markers. 


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

      Disables verification of the destination cluster's TLS certificate.
      This option may be required if the destination cluster uses a 
      self-signed certificate *or* a certificate signed by an unknown 
      Certificate Authority.

   .. mc-cmd:: state
      :option:

      *Optional*

      Enables or disables the replication rule. Specify one of the following
      values:

      - ``"enable"`` - Enables the replication rule. MinIO begins replicating
        objects written *after* enabling the rule. Existing objects require
        manual migration to the destination bucket.

      - ``"disable"`` - Disables the replication rule. 

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
      :mc-cmd:`~mc replicate add SOURCE` path. For example:

      .. code-block:: shell

         mc replicate add play/mybucket

   .. mc-cmd:: insecure
      :option:

      *Optional*

      Disables verification of the destination cluster's TLS certificate.
      This option may be required if the destination cluster uses a 
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

      Disables verification of the destination cluster's TLS certificate.
      This option may be required if the destination cluster uses a 
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
      :mc-cmd:`~mc replicate add SOURCE` path. For example:

      .. code-block:: shell

         mc replicate export play/mybucket

   .. mc-cmd:: insecure
      :option:

      *Optional*

      Disables verification of the destination cluster's TLS certificate.
      This option may be required if the destination cluster uses a 
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
      :mc-cmd:`~mc replicate edit SOURCE` path. For example:

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