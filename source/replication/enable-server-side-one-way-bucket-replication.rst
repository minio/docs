.. _minio-bucket-replication-serverside-oneway:

=============================================
Enable One-Way Server-Side Bucket Replication
=============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1


The procedure on this page creates a new bucket replication rule for
one-way synchronization of objects between MinIO buckets.

.. image:: /images/replication/active-passive-oneway-replication.svg
   :width: 450px
   :alt: Active-Passive Replication synchronizes data from a source MinIO cluster to a remote MinIO cluster.
   :align: center

- To configure replication between arbitrary S3-compatible services, use
  :mc-cmd:`mc mirror`.

- To configure two-way "active-active" replication between MinIO clusters,
  see :ref:`minio-bucket-replication-serverside-twoway`.

- To configure multi-site "active-active" replication between MinIO clusters,
  see :ref:`minio-bucket-replication-serverside-multi`

.. seealso::

   - Use the :mc-cmd:`mc replicate edit` command to modify an existing
     replication rule.

   - Use the :mc-cmd:`mc replicate edit` command with the
     :mc-cmd:`--state "disable" <mc replicate edit --state>` flag to
     disable an existing replication rule.

   - Use the :mc-cmd:`mc replicate rm` command to remove an existing replication
     rule.

.. _minio-bucket-replication-serverside-oneway-requirements:

Requirements
------------

Install and Configure ``mc`` with Access to Both Clusters.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses :mc:`mc` for performing operations on both the source and
destination MinIO cluster. Install :mc:`mc` on a machine with network access to
both source and destination clusters. See the ``mc`` 
:ref:`Installation Quickstart <mc-install>` for instructions on downloading and
installing ``mc``.

Use the :mc:`mc alias` command to create an alias for both MinIO clusters.
Alias creation requires specifying an access key for a user on the cluster.
This user **must** have permission to create and manage users and policies
on the cluster. Specifically, ensure the user has *at minimum*:

- :policy-action:`admin:CreateUser`
- :policy-action:`admin:ListUsers`
- :policy-action:`admin:GetUser`
- :policy-action:`admin:CreatePolicy`
- :policy-action:`admin:GetPolicy`
- :policy-action:`admin:AttachUserOrGroupPolicy`

.. _minio-bucket-replication-serverside-oneway-permissions:

Required Permissions
~~~~~~~~~~~~~~~~~~~~

Bucket Replication requires at minimum the following permissions on the 
source and destination clusters:

.. tab-set::

   .. tab-item:: Replication Admin

      The following policy provides permissions for configuring and enabling
      replication on a cluster. 

      .. literalinclude:: /extra/examples/ReplicationAdminPolicy.json
         :class: copyable
         :language: json

      - The ``"EnableRemoteBucketConfiguration"`` statement grants permission
        for creating a remote target for supporting replication.

      - The ``"EnableReplicationRuleConfiguration"`` statement grants permission
        for creating replication rules on a bucket. The ``"arn:aws:s3:::*``
        resource applies the replication permissions to *any* bucket on the
        source cluster. You can restrict the user policy to specific buckets
        as-needed.

   .. tab-item:: Replication Remote User

      The following policy provides permissions for enabling synchronization of
      replicated data *into* the cluster. 

      .. literalinclude:: /extra/examples/ReplicationRemoteUserPolicy.json
         :class: copyable
         :language: json

      - The ``"EnableReplicationOnBucket"`` statement grants permission for 
        a remote target to retrieve bucket-level configuration for supporting
        replication operations on *all* buckets in the MinIO cluster. To
        restrict the policy to specific buckets, specify those buckets as an
        element in the ``Resource`` array similar to
        ``"arn:aws:s3:::bucketName"``.

      - The ``"EnableReplicatingDataIntoBucket"`` statement grants permission
        for a remote target to synchronize data into *any* bucket in the MinIO
        cluster. To restrict the policy to specific buckets, specify those 
        buckets as an element in the ``Resource`` array similar to 
        ``"arn:aws:s3:::bucketName/*"``.
      
Use the reference policies above to create the necessary policies using :mc-cmd:`mc admin policy add`. After creating the necessary policy, MinIO strongly recommends creating a dedicated user or service account for supporting bucket replication operations.

- MinIO deployments configured for :ref:`Active Directory/LDAP <minio-external-identity-management-ad-ldap>` or :ref:`OpenID Connect <minio-external-identity-management-openid>` user management can create a dedicated :ref:`service account <minio-idp-service-account>` for bucket replication.

- MinIO deployments configured for :ref:`MinIO <minio-users>` user management can create either a dedicated user *or* service account for bucket replication.

See :mc:`mc admin user`, :mc:`mc admin user svcacct`, and :mc:`mc admin policy` for more complete documentation on adding users, service accounts, and policies to a MinIO cluster.

Replication Requires Matching Object Encryption Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-encrypted-objects
   :end-before: end-replication-encrypted-objects

Replication Requires MinIO Deployments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-minio-only
   :end-before: end-replication-minio-only

Replication Requires Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-requires-versioning
   :end-before: end-replication-requires-versioning

Replication Requires Matching Object Locking State
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-requires-object-locking
   :end-before: end-replication-requires-object-locking

Considerations
--------------

Replication of Existing Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports automatically replicating existing objects in a bucket.

MinIO requires explicitly enabling replication of existing objects using the
:mc-cmd:`mc replicate add --replicate` or
:mc-cmd:`mc replicate edit --replicate` and including the 
``existing-objects`` replication feature flag. This procedure includes the
required flags for enabling replication of existing objects.

Replication of Delete Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating S3 ``DELETE`` operations onto the target bucket. 
Specifically, MinIO can replicate versioning
:s3-docs:`Delete Markers <versioning-workflows.html>` and the deletion
of specific versioned objects:

- For delete operations on an object, MinIO replication also creates the delete
  marker on the target bucket.

- For delete operations on versions of an object,
  MinIO replication also deletes those versions on the target bucket.

MinIO requires explicitly enabling replication of delete operations using the
:mc-cmd:`mc replicate add --replicate` or 
:mc-cmd:`mc replicate edit --replicate`. This procedure includes the
required flags for enabling replication of delete operations and delete markers.

MinIO does *not* replicate delete operations resulting from the 
application of :ref:`lifecycle management expiration rules
<minio-lifecycle-management-expiration>`.

See :ref:`minio-replication-behavior-delete` for more complete documentation.

Multi-Site Replication
~~~~~~~~~~~~~~~~~~~~~~

MinIO supports configuring multiple remote targets per
bucket or bucket prefix. For example, you can configure a bucket to replicate
data to two or more remote MinIO deployments, where one deployment is a 1:1 copy
(replication of all operations including deletions) and another is a full
historical record (replication of only non-destructive write operations).

This procedure documents one-way replication to a single remote MinIO
deployment. You can repeat this tutorial for multiple remote targets for a
single bucket.

MinIO multi-site replication requires MinIO server
:minio-release:`RELEASE.2021-09-23T04-46-24Z` and :mc:`mc`
:mc-release:`RELEASE.2021-09-23T05-44-03Z` and later.

Procedure
---------

1) Configure User Accounts and Policies for Replication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This step creates users and policies on both MinIO clusters for
supporting replication operations. You can skip this step if both
clusters already have users with the necessary
:ref:`permissions <minio-bucket-replication-serverside-oneway-permissions>`.

The following examples use ``Alpha`` and ``Baker`` as placeholder :mc:`aliases
<mc alias>` for each MinIO cluster. You should replace these values with the
appropriate aliases for the MinIO clusters on which you are configuring bucket
replication. These examples assume that the specified aliases have
the necessary permissions for creating policies and users on both clusters. See
:ref:`minio-users` and :ref:`MinIO Policy Based Access Control <minio-policy>` for more complete documentation on
MinIO users and policies respectively.

A\) Create Replication Administrator
   The following code creates a user and policy for supporting configuring
   replication on the ``Alpha`` cluster. Replace the
   password ``LongRandomSecretKey`` with a long, random, and secure secret key 
   as per your organizations best practices for password generation.

   .. code-block:: shell
      :class: copyable

      wget -O - https://docs.min.io/minio/baremetal/examples/ReplicationAdminPolicy.json | \
      mc admin policy add Alpha ReplicationAdminPolicy /dev/stdin
      mc admin user add Alpha alphaReplicationAdmin LongRandomSecretKey
      mc admin policy set Alpha ReplicationAdminPolicy user=alphaReplicationAdmin

B\) Create Remote Replication User
   The following code creates a user and policy for supporting synchronizing
   data into the ``Baker`` cluster. Replace the password
   ``LongRandomSecretKey`` with a long, random, and secure secret key as per
   your organizations best practices for password generation.

   .. code-block:: shell
      :class: copyable
      
      wget -O - https://docs.min.io/minio/baremetal/examples/ReplicationRemoteUserPolicy.json | \
      mc admin policy add Baker ReplicationRemoteUserPolicy /dev/stdin
      mc admin user add Baker bakerReplicationRemoteUser LongRandomSecretKey
      mc admin policy set Baker ReplicationRemoteUserPolicy user=bakerReplicationRemoteUser

2) Configure ``mc`` Access to the Source and Destination Cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc alias set` command to add an alias for both source 
and destination MinIO clusters. 

Use the :mc-cmd:`mc alias set` command to add a replication-specific alias for
both remote clusters:

.. code-block:: shell
   :class: copyable

   mc alias set AlphaReplication HOSTNAME alphaReplicationAdmin LongRandomSecretKey
   mc alias set BakerReplication HOSTNAME bakerReplicationRemoteUser LongRandomSecretKey

3) Create a Replication Target for the Destination Cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin bucket remote` command to create a replication target
for the destination cluster. MinIO supports *one* remote target per destination
bucket. You cannot create multiple remote targets for the same destination
bucket.

.. code-block:: shell
   :class: copyable

   mc admin bucket remote add AlphaReplication/SOURCEBUCKET \
      https://bakerReplicationRemoteUser:LongRandomSecretKey@HOSTNAME/DESTINATIONBUCKET \
      --service "replication"
      [--sync]

- Replace ``SOURCEBUCKET`` with the name of the source bucket on the 
  ``Alpha`` cluster.

- Replace ``HOSTNAME`` with the URL of the ``Baker`` cluster.

- Replace ``DESTINATIONBUCKET`` with the name of the target bucket on the
  ``Baker`` cluster.

- Specify the :mc-cmd:`~mc admin bucket remote add` option to
  enable synchronous replication. Omit the option to use the default of 
  asynchronous replication. See the reference documentation for 
  :mc-cmd:`~mc admin bucket remote add` for more information
  on synchronous vs asynchronous replication.

The command returns an ARN similar to the following:

.. code-block:: shell

   Role ARN = 'arn:minio:replication::<UUID>:DESTINATIONBUCKET'

Copy the ARN string for use in the next step.

4) Create a New Bucket Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc replicate add` command to add the new server-side
replication rule to the source MinIO cluster. 

.. code-block:: shell
   :class: copyable

   mc replicate add AlphaReplication/SOURCEBUCKET \
      --remote-bucket 'arn:minio:replication::<UUID>:DESTINATIONBUCKET' \
      --replicate "delete,delete-marker,existing-objects"

- Replace ``SOURCEBUCKET`` with the name of the bucket from which Alpha
  replicates data. The name *must* match the bucket specified when
  creating the remote target in the previous step.

- Replace the ``--remote-bucket`` value with the ARN returned in the previous
  step. Ensure you specify the ARN created on the ``Alpha`` cluster. You can use
  :mc-cmd:`mc admin bucket remote ls` to list all remote ARNs configured on the
  cluster.

- The ``--replicate "delete,delete-marker,existing-objects"`` flag enables
  the following replication features:
  
  - :ref:`Replication of Deletes <minio-replication-behavior-delete>` 
  - :ref:`Replication of existing Objects <minio-replication-behavior-existing-objects>`
  
  See :mc-cmd:`mc replicate add --replicate` for more complete
  documentation. Omit these fields to disable replication of delete operations
  or replication of existing objects respectively.

Specify any other supported optional arguments for 
:mc-cmd:`mc replicate add`.

5) Validate the Replication Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp` to copy a new object to the source bucket. 

.. code-block:: shell
   :class: copyable

   mc cp ~/foo.txt Alpha/SOURCEBUCKET

Use :mc-cmd:`mc ls` to verify the object exists on the destination bucket:

.. code-block:: shell
   :class: copyable

   mc ls Baker/DESTINATIONBUCKET

If the remote target was configured *without* the 
:mc-cmd:`~mc admin bucket remote add` option, the destination
bucket may have some delay before it receives the new object.