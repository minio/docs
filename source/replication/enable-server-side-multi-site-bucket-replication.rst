.. _minio-bucket-replication-serverside-multi:

================================================
Enable Multi-Site Server-Side Bucket Replication
================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


The procedure on this page configures automatic server-side bucket
replication between multiple MinIO deployments. Multi-Site Active-Active
replication builds on the 
:ref:`minio-bucket-replication-serverside-twoway` procedure with additional
considerations required to ensure predictable replication behavior across
all sites.

.. image:: /images/replication/active-active-multi-replication.svg
   :width: 600px
   :alt: Active-Active Replication synchronizes data between multiple remote deployments.
   :align: center

- To configure replication between arbitrary S3-compatible services, use
  :mc-cmd:`mc mirror`.

- To configure one-way "active-active" replication between two MinIO
  deployments, see :ref:`minio-bucket-replication-serverside-twoway`.

- To configure one-way "active-passive" replication between MinIO deployments,
  see :ref:`minio-bucket-replication-serverside-oneway`.

Multi-Site Active-Active replication configurations can span multiple
racks, datacenters, or geographic locations. Complexity of configuring and
maintaining multi-site configurations generally increase with the number of 
sites and size of each site. Enterprises looking to implement
multi-site replication should consider leveraging `MinIO SUBNET
<https://min.io/pricing?ref=docs>`__ support to access the expertise, planning,
and engineering resources required for addressing that use case. 

MinIO multi-site replication requires MinIO server
:minio-release:`RELEASE.2021-09-23T04-46-24Z` and :mc:`mc`
:mc-release:`RELEASE.2021-09-23T05-44-03Z` and later.

.. seealso::

   - Use the :mc-cmd:`mc replicate edit` command to modify an existing
     replication rule.

   - Use the :mc-cmd-option:`mc replicate edit` command with the
     :mc-cmd-option:`--state "disable" <mc replicate edit state>` flag to
     disable an existing replication rule.

   - Use the :mc-cmd:`mc replicate rm` command to remove an existing replication
     rule.

.. _minio-bucket-replication-serverside-multi-requirements:

Requirements
------------

Replication Requires MinIO Remote Targets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO server-side replication only works between MinIO deployments. All
deployments participating in the multi-site replication configuration
*must* run MinIO. MinIO strongly recommends using the *same* MinIO server
version across all sites. 

To configure replication between arbitrary S3-compatible services,
use :mc-cmd:`mc mirror`.

Replication Requires Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO relies on the immutability protections provided by versioning to
synchronize objects as part of replication.

Use the :mc-cmd:`mc version suspend` command to enable versioning for the bucket
across *all* MinIO deployments participating in the multi-site replication
configuration.

.. code-block:: shell
   :class: copyable

   mc version ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc version ALIAS>` with the
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc version ALIAS>` with the bucket on which
  to enable versioning.

Install and Configure ``mc`` with Access to Both Clusters.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses :mc:`mc` for performing operations on both the source and
destination MinIO cluster. Install :mc:`mc` on a machine with network access to
both source and destination deployments. See the ``mc`` 
:ref:`Installation Quickstart <mc-install>` for instructions on downloading and
installing ``mc``.

Use the :mc:`mc alias` command to create an alias for both MinIO deployments.
Alias creation requires specifying an access key for a user on the cluster.
This user **must** have permission to create and manage users and policies
on the cluster. Specifically, ensure the user has *at minimum*:

- :policy-action:`admin:CreateUser`
- :policy-action:`admin:ListUsers`
- :policy-action:`admin:GetUser`
- :policy-action:`admin:CreatePolicy`
- :policy-action:`admin:GetPolicy`
- :policy-action:`admin:AttachUserOrGroupPolicy`

.. _minio-bucket-replication-serverside-multi-permissions:

Required Permissions
~~~~~~~~~~~~~~~~~~~~

Bucket replication requires specific permissions on the source and
destination deployments to configure and enable replication rules. 

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

      Use the :mc-cmd:`mc admin policy add` to add this policy to *both*
      deployments. You can then create a user on both deployments using
      :mc-cmd:`mc admin user add` and associate the policy to those users
      with :mc-cmd:`mc admin policy set`.

   .. tab-item:: Replication Remote User

      The following policy provides permissions for enabling synchronization of
      replicated data *into* the cluster. Use the :mc-cmd:`mc admin policy add`
      to add this policy to *both* deployments.

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

      Use the :mc-cmd:`mc admin policy add` to add this policy to *both*
      deployments. You can then create a user on both deployments using
      :mc-cmd:`mc admin user add` and associate the policy to those users
      with :mc-cmd:`mc admin policy set`.

MinIO strongly recommends creating users specifically for supporting 
bucket replication operations. See 
:mc:`mc admin user` and :mc:`mc admin policy` for more complete
documentation on adding users and policies to a MinIO cluster.

Considerations
--------------

Use Consistent Replication Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports customizing the replication configuration to enable or disable
the following replication behaviors:

- Replication of delete operations
- Replication of delete markers
- Replication of existing objects
- Replication of metadata-only changes

When configuring replication rules for a bucket, ensure that all MinIO
deployments participating in multi-site replication use the *same* replication
behaviors to ensure consistent and predictable synchronization of objects.

Replication of Existing Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with :mc:`mc` :minio-git:`RELEASE.2021-06-13T17-48-22Z
<mc/releases/tag/RELEASE.2021-06-13T17-48-22Z>` and :mc:`minio`
:minio-git:`RELEASE.2021-06-07T21-40-51Z
<minio/releases/tag/RELEASE.2021-06-07T21-40-51Z>`, MinIO supports automatically
replicating existing objects in a bucket.

MinIO requires explicitly enabling replication of existing objects using the
:mc-cmd-option:`mc replicate add replicate` or
:mc-cmd-option:`mc replicate edit replicate` and including the 
``existing-objects`` replication feature flag. This procedure includes the
required flags for enabling replication of existing objects.

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

MinIO does *not* replicate delete operations resulting from the application of
:ref:`lifecycle management expiration rules
<minio-lifecycle-management-expiration>`. Configure matching expiration rules
for the bucket on all replication sites to ensure consistent application of
object expiration.

Replication of Encrypted Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating objects encrypted with automatic 
Server-Side Encryption (SSE-S3). Both the source and destination buckets
*must* have automatic SSE-S3 enabled for MinIO to replicate an encrypted object.

As part of the replication process, MinIO *decrypts* the object on the source
bucket and transmits the unencrypted object. The destination MinIO cluster then
re-encrypts the object using the destination bucket SSE-S3 configuration. MinIO
*strongly recommends* :ref:`enabling TLS <minio-TLS>` on both source and
destination deployments to ensure the safety of objects during transmission.

MinIO does *not* support replicating client-side encrypted objects 
(SSE-C).

Replication of Locked Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating objects held under 
:ref:`WORM Locking <minio-object-locking>`. Both replication buckets *must* have
object locking enabled for MinIO to replicate the locked object. For
active-active configuration, MinIO recommends using the *same* 
retention rules on both buckets to ensure consistent behavior across
sites.

You must enable object locking during bucket creation as per S3 behavior. 
You can then configure object retention rules at any time.
Object locking requires :ref:`versioning <minio-bucket-versioning>` and
enables the feature implicitly.

Procedure
---------

This procedure requires repeating steps for each MinIO deployment participating
in the multi-site replication configuration. Depending on the number of 
deployments, this procedure may require significant time and care in 
implementation. MinIO recommends reading through the procedure *before*
attempting to implement the documented steps.

1) Create Replication Administrator Users
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example creates a replication administrator policy and
associates that policy to a user on the MinIO deployment.  Replace the
password ``LongRandomSecretKey`` with a long, random, and secure secret key 
as per your organizations best practices for password generation

.. code-block:: shell
   :class: copyable

   wget -O - https://docs.min.io/minio/baremetal/examples/ReplicationAdminPolicy.json | \
   mc admin policy add ALIAS ReplicationAdminPolicy /dev/stdin
   mc admin user add ALIAS ReplicationAdmin LongRandomSecretKey
   mc admin policy set ALIAS ReplicationAdminPolicy user=ReplicationAdmin

The ``ReplicationAdminPolicy.json`` contains the limited set of 
:ref:`permissions <minio-bucket-replication-serverside-multi-permissions>` 
required for configuring replication rules. Replace the 
``LongRandomSecretKey`` 

Repeat this step for each MinIO deployment participating in the multi-site
replication configuration. For example, a configuration with three MinIO
deployments should repeat this step three times.

The example assumes that the specified aliases have the necessary permissions
for creating policies and users on both deployments. See :ref:`minio-users` and
:ref:`MinIO Policy Based Access Control <minio-policy>` for more complete
documentation on MinIO users and policies respectively.

2) Create Replication Remote Users
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example creates a replication remote policy and
associates that policy to a user on the MinIO deployment. Replace the
password ``LongRandomSecretKey`` with a long, random, and secure secret key 
as per your organizations best practices for password generation.


.. code-block:: shell
   :class: copyable
   
   wget -O - https://docs.min.io/minio/baremetal/examples/ReplicationRemoteUserPolicy.json | \
   mc admin policy add ALIAS ReplicationRemoteUserPolicy /dev/stdin
   mc admin user add ALIAS ReplicationRemoteUser LongRandomSecretKey
   mc admin policy set ALIAS ReplicationRemoteUserPolicy user=ReplicationRemoteUser

The ``ReplicationRemoteUserPolicy.json`` contains the limited set of 
:ref:`permissions <minio-bucket-replication-serverside-multi-permissions>` 
required for configuring replication rules.

Repeat this step for each MinIO deployment participating in the multi-site
replication configuration. For example, a configuration with three MinIO
deployments should repeat this step three times.

The example assumes that the specified aliases have the necessary permissions
for creating policies and users on both deployments. See :ref:`minio-users` and
:ref:`MinIO Policy Based Access Control <minio-policy>` for more complete
documentation on MinIO users and policies respectively.

3) Configure Replication Administrative Access to Each Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc alias set` command to add a replication-specific alias for
each remote deployment

.. code-block:: shell
   :class: copyable

   mc alias set ALIAS-Replication HOSTNAME ReplicationAdmin LongRandomSecretKey

Repeat this step for each MinIO deployment participating in the multi-site
replication configuration. Replace the ``ALIAS`` prefix to match the 
actual alias for that deployment. 

For example, a multi-site replication configuration consisting of MinIO 
deployments ``Alpha``, ``Baker``, and ``Charlie`` would resemble the following:

.. code-block:: shell
   :class: copyable

   mc alias set Alpha-Replication   https://alpha-minio.example.net   ReplicationAdmin LongRandomSecretKey
   mc alias set Baker-Replication   https://baker-minio.example.net   ReplicationAdmin LongRandomSecretKey
   mc alias set Charlie-Replication https://charlie-minio.example.net ReplicationAdmin LongRandomSecretKey

4) Create the Replication Rule on each Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin bucket remote` command to create a remote target
for each MinIO deployment participating in the multi-site replication
configuration.

.. code-block:: shell
   :class: copyable

   mc admin bucket remote add ALIAS-Replication/BUCKET \
      https://ReplicationRemoteUser:LongRandomSecretKey@HOSTNAME/BUCKET \
      --service "replication" \
      [--sync]

- Replace ``BUCKET`` with the name of the bucket on which you are
  configuring multi-site replication.

- Replace ``HOSTNAME`` with the URL of the remote MinIO deployment

- (Optional) Specify the :mc-cmd-option:`~mc admin bucket remote add sync`
  option to enable synchronous replication. Omit the option to use the default
  of asynchronous replication. See the reference documentation for
  :mc-cmd-option:`~mc admin bucket remote add sync` for more information on
  synchronous vs asynchronous replication.

The command returns an ARN similar to the following. Copy this ARN for use in
following steps. 

.. code-block:: shell

   Role ARN = 'arn:minio:replication::<UUID>:BUCKET'

Use the :mc-cmd:`mc replicate add` command to create the replication rule using
the remote as a target:

.. code-block:: shell
   :class: copyable

   mc replicate add ALIAS-Replication/BUCKET \
      --remote-bucket 'arn:minio:replication::<UUID>:BUCKET' \
      --replicate "delete,delete-marker,existing-objects"
      --priority 1

- Replace ``BUCKET`` with the name of the bucket on which you are
  configuring multi-site replication. The name *must* match the bucket
  specified when creating the remote target.

- Replace the ``--remote-bucket`` value with the ARN returned in the previous 
  step. 

- The ``--replicate "delete,delete-marker,existing-objects"`` flag enables
  the following replication features:
  
  - :ref:`Replication of Deletes <minio-replication-behavior-delete>` 
  - :ref:`Replication of Existing Objects <minio-replication-behavior-existing-objects>`
  
  See :mc-cmd-option:`mc replicate add replicate` for more complete
  documentation. Omit these fields to disable replication of delete operations
  or replication of existing objects respectively.

  You *must* specify the same set of replication features for all
  MinIO deployments participating in this bucket's multi-site replication.

- Replace ``--priority`` with a unique value for the bucket. If the bucket
  has multiple replication rules, you may need to use 
  :mc-cmd:`mc replicate ls` to identify an unused priority value.

Repeat these commands for each remote MinIO deployment participating in the
multi-site replication configuration. For example, a multi-site replication
configuration consisting of MinIO deployments ``Alpha``, ``Baker``, and
``Charlie`` would require repeating this step on each deployment for each
remote. Specifically:

- The ``Alpha`` deployment would perform this step once for
  ``Baker`` and once for ``Charlie``. 

- The ``Baker`` deployment would perform this step once for ``Alpha`` and 
  once for ``Charlie``.

- The ``Charlie`` deployment would perform this step once for ``Baker`` and
  once for ``Alpha``.

5) Validate the Replication Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp` to copy a new object the bucket on any of the deployments:

.. code-block:: shell
   :class: copyable

   mc cp ~/foo.txt ALIAS/BUCKET

Use :mc-cmd:`mc ls` to verify the object exists on each deployment:

.. code-block:: shell
   :class: copyable

   mc ls ALIAS/BUCKET

Repeat this test on each of the deployments by copying a new unique file and
checking the other deployments for that file.

You can also use :mc-cmd:`mc stat` to check the file to check the
current :ref:`replication stage <minio-replication-process>` of the object.
