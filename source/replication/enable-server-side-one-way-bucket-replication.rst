.. _minio-bucket-replication-serverside-oneway:

=============================================
Enable One-Way Server-Side Bucket Replication
=============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


MinIO Server-Side Bucket Replication supports automatically synchronizing 
objects between a source and destination bucket. The destination bucket
can be on the same MinIO cluster as the source *or* an independent remote
MinIO cluster.

The procedure on this page creates a new bucket replication rule for
one-way synchronization of objects from a source MinIO cluster to a destination
MinIO cluster. 

- Use the :mc-cmd:`mc replicate edit` command to modify an existing
  replication rule.

- Use the :mc-cmd-option:`mc replicate edit` command with the
  :mc-cmd-option:`--state "disable" <mc replicate edit state>` flag to
  disable an existing replication rule.

- Use the :mc-cmd:`mc replicate rm` command to remove an existing replication
  rule.


.. todo: Diagram

.. todo
   This procedure specifically enables only one-way replication between the 
   source and destination buckets. For a procedure on two-way "active-active"
   replication, see <tutorial>.

.. _minio-bucket-replication-serverside-oneway-requirements:

Requirements
------------

MinIO Server-Side Replication Requires a MinIO Cluster as the Destination
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

``mc`` Command Line Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses :mc:`mc` for performing operations on both the source 
and destination MinIO cluster. See the ``mc`` 
:ref:`Installation Quickstart <mc-install>` for instructions on downloading
and installing ``mc``.

.. _minio-bucket-replication-serverside-oneway-permissions:

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

Considerations
--------------

Replication of Existing Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO performs replication as part of writing an object (PUT operations). MinIO
does *not* apply replication rules to existing objects in the bucket. Use
:mc:`mc cp` or :mc:`mc mirror` to migrate existing objects to the destination
bucket.

Replication of Delete Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating delete operations onto the target bucket. 
Specifically, MinIO can replicate versioning
:s3-docs:`Delete Markers <versioning-workflows.html>` and the deletion
of specific versioned objects:

- For delete operations on an object, MinIO replication also creates the delete
  marker on the target bucket.

- For delete operations on versions of an object,
  MinIO replication also deletes those versions on the target bucket.

MinIO requires explicitly enabling replication of delete operations using the
:mc-cmd-option:`mc replicate add replicate` or 
:mc-cmd-option:`mc replicate edit replicate`. This procedure includes the
required flags for enabling replication of delete operations and delete markers.

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

Procedure
---------

1) Configure ``mc`` Access to the Source and Destination Cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc alias set` command to add an alias for both source 
and destination MinIO clusters. 

.. tabs::

   .. tab: Source Cluster

      .. code-block:: shell
         :class: copyable

         mc alias set SourceCluster HOSTNAME ACCESSKEY SECRETKEY

      - Replace :mc-cmd:`~mc alias set HOSTNAME` with the hostname or IP address
        of a node in the source MinIO cluster. For distributed MinIO clusters
        using a load balancer, specify the hostname or IP address of that load
        balancer.

      - Replace :mc-cmd:`~mc alias set ACCESSKEY` and 
        :mc-cmd:`~mc alias set SECRETKEY` with the access and secret key for a
        user with the :ref:`required permissions
        <minio-bucket-replication-serverside-oneway-permissions>` on the source
        MinIO cluster.

   .. tab:: DestinationCluster

      .. code-block:: shell
         :class: copyable

         mc alias set DestinationCluster HOSTNAME ACCESSKEY SECRETKEY

      - Replace :mc-cmd:`~mc alias set HOSTNAME` with the hostname or IP address
        of a node in the destination MinIO cluster. For distributed MinIO
        clusters using a load balancer, specify the hostname or IP address of
        that load balancer.

      - Replace :mc-cmd:`~mc alias set ACCESSKEY` and 
        :mc-cmd:`~mc alias set SECRETKEY` with the access and secret key for a
        user with the :ref:`required permissions
        <minio-bucket-replication-serverside-oneway-permissions>` on the
        destination MinIO cluster.

2) Create a Replication Target for the Destination Cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin bucket remote` command to create a replication target
for the destination cluster. MinIO supports *one* remote target per destination
bucket. You cannot create multiple remote targets for the same destination
bucket.

.. code-block:: shell
   :class: copyable

   mc admin bucket remote add SourceCluster/SOURCEBUCKET \
      https://ACCESSKEY:SECRETKEY@HOSTNAME/DESTINATIONBUCKET
      --service "replication"
      [--sync]

- Replace ``SOURCEBUCKET`` with the name of the bucket on the source cluster.
  The name of the bucket *must* match the bucket name specified to the source
  user's replication :ref:`policy
  <minio-bucket-replication-serverside-oneway-permissions>`.

- Replace ``ACCESSKEY`` and ``SECRETKEY`` with the access and secret key for 
  a user with the :ref:`required permissions 
  <minio-bucket-replication-serverside-oneway-permissions>` on the destination
  MinIO cluster.

- Replace the ``HOSTNAME`` with the hostname or IP address of
  a node in the MinIO cluster. For distributed MinIO clusters using a 
  load balancer, specify the hostname or IP address of that load balancer.

- Replace the ``DESTINATIONBUCKET`` with the name of the bucket on the
  destination cluster. The name of the bucket *must* match the bucket name
  specified to the destination user's replication :ref:`policy
  <minio-bucket-replication-serverside-oneway-permissions>`.

- MinIO defaults to using asynchronous object replication, where MinIO 
  replicates objects *after* returning the PUT object response. Specify the
  :mc-cmd-option:`~mc admin bucket remote add sync` option to enable
  synchronous replication, where MinIO attempts to replicate the object
  *prior* to returning the PUT object response.

The command returns an ARN similar to the following:

.. code-block:: shell

   Role ARN = 'arn:minio:replication::<UUID>:DESTINATIONBUCKET'

Copy the ARN string for use in the next step.

3) Create a New Bucket Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc replicate add` command to add the new server-side
replication rule to the source MinIO cluster. 

.. code-block:: shell
   :class: copyable

   mc replicate add SourceCluster/SOURCEBUCKET \
      --remote-bucket DESTINATIONBUCKET \
      --arn 'arn:minio:replication::<UUID>:DESTINATIONBUCKET' \
      --replicate "delete,delete-marker"

- Replace ``SOURCEBUCKET`` with the name of the bucket on the source cluster.

- Replace the ``DESTINATIONBUCKET`` with the name of the bucket on the
  destination cluster.

- Replace the ``--arn`` value with the ARN returned in the previous step.
  
- Replace ``PRIORITY`` with the integer priority of this replication rule. 

- The ``--replicate "delete,delete-marker"`` flag enables replicating delete
  markers and deletion of object versions. See 
  :mc-cmd-option:`mc replicate add replicate` for more complete documentation.
  Omit this field to disable replication of delete operations.

Specify any other supported optional arguments for 
:mc-cmd:`mc replicate add`.

4) Validate the Replication Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp` to copy a new object to the source bucket. 

.. code-block:: shell
   :class: copyable

   mc cp ~/foo.txt SourceCluster/SOURCEBUCKET

Use :mc-cmd:`mc ls` to verify the object exists on the destination bucket:

.. code-block:: shell
   :class: copyable

   mc ls DestinationCluster/DESTINATIONBUCKET

If the remote target was configured *without* the 
:mc-cmd-option:`~mc admin bucket remote add sync` option, the destination
bucket may have some delay before it receives the new object.