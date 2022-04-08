.. _minio-bucket-replication-serverside-twoway:

=============================================
Enable Two-Way Server-Side Bucket Replication
=============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1


The procedure on this page creates a new bucket replication rule for two-way "active-active" synchronization of objects between MinIO buckets.

.. image:: /images/replication/active-active-twoway-replication.svg
   :width: 600px
   :alt: Active-Active Replication synchronizes data between two remote clusters.
   :align: center

- To configure replication between arbitrary S3-compatible services, use :mc-cmd:`mc mirror`.

- To configure one-way "active-passive" replication between MinIO clusters, see :ref:`minio-bucket-replication-serverside-oneway`.
  
- To configure multi-site "active-active" replication between MinIO clusters, see :ref:`minio-bucket-replication-serverside-multi`.

This tutorial covers configuring Active-Active replication between two MinIO clusters. For a tutorial on multi-site replication between three or more MinIO clusters, see :ref:`minio-bucket-replication-serverside-multi`.

.. seealso::

   - Use the :mc-cmd:`mc replicate edit` command to modify an existing
     replication rule.

   - Use the :mc-cmd:`mc replicate edit` command with the :mc-cmd:`--state "disable" <mc replicate edit --state>` flag to disable an existing replication rule.

   - Use the :mc-cmd:`mc replicate rm` command to remove an existing replication rule.

.. _minio-bucket-replication-serverside-twoway-requirements:

Requirements
------------

Install and Configure ``mc`` with Access to Both Clusters.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses :mc:`mc` for performing operations on both the source and destination MinIO cluster. Install :mc:`mc` on a machine with network access to both source and destination clusters. See the ``mc`` :ref:`Installation Quickstart <mc-install>` for instructions on downloading and installing ``mc``.

Use the :mc:`mc alias` command to create an alias for both MinIO clusters. Alias creation requires specifying an access key for a user on the cluster. This user **must** have permission to create and manage users and policies on the cluster. Specifically, ensure the user has *at minimum*:

- :policy-action:`admin:CreateUser`
- :policy-action:`admin:ListUsers`
- :policy-action:`admin:GetUser`
- :policy-action:`admin:CreatePolicy`
- :policy-action:`admin:GetPolicy`
- :policy-action:`admin:AttachUserOrGroupPolicy`

.. _minio-bucket-replication-serverside-twoway-permissions:

Required Permissions
~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-required-permissions
   :end-before: end-replication-required-permissions

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

Use Consistent Replication Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports customizing the replication configuration to enable or disable
the following replication behaviors:

- Replication of delete operations
- Replication of delete markers
- Replication of existing objects
- Replication of metadata-only changes

When configuring replication rules for a bucket, ensure that both MinIO deployments participating in active-active replication use the *same* replication behaviors to ensure consistent and predictable synchronization of objects.

Replication of Existing Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports automatically replicating existing objects in a bucket.

MinIO requires explicitly enabling replication of existing objects using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate edit --replicate` and including the ``existing-objects`` replication feature flag. This procedure includes the required flags for enabling replication of existing objects.

Replication of Delete Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating delete operations onto the target bucket. Specifically, MinIO can replicate versioning :s3-docs:`Delete Markers <versioning-workflows.html>` and the deletion of specific versioned objects:

- For delete operations on an object, MinIO replication also creates the delete marker on the target bucket.

- For delete operations on versions of an object, MinIO replication also deletes those versions on the target bucket.

MinIO requires explicitly enabling replication of delete operations using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate edit --replicate`. This procedure includes the required flags for enabling replication of delete operations and delete markers.

MinIO does *not* replicate delete operations resulting from the application of :ref:`lifecycle management expiration rules <minio-lifecycle-management-expiration>`. Configure matching expiration rules on both the source and destination bucket to ensure consistent application of object expiration.

See :ref:`minio-replication-behavior-delete` for more complete documentation.

Multi-Site Replication
~~~~~~~~~~~~~~~~~~~~~~

MinIO supports configuring multiple remote targets per bucket or bucket prefix. This enables configuring multi-site active-active replication between MinIO deployments.

This procedure covers active-active replication between *two* MinIO sites. You can repeat this procedure for each "pair" of MinIO deployments in the replication mesh. For a dedicated tutorial, see :ref:`minio-bucket-replication-serverside-multi`.

Procedure
---------

This procedure uses the :ref:`aliases <alias>` ``ALPHA`` and ``BAKER`` to reference each MinIO deployment being configured for replication. Replace these values with the appropriate alias for your target MinIO deployments.

This procedure assumes each alias corresponds to a user with the :ref:`necessary replication permissions <minio-bucket-replication-serverside-twoway-permissions>`.

1) Create the Replication Remote Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin bucket remote add` command to create a replication target for the each deployment. MinIO supports *one* remote target per destination bucket. You cannot create multiple remote targets for the same destination bucket.

.. code-block:: shell
   :class: copyable

   mc admin bucket remote add ALPHA/BUCKET \
      https://ReplicationRemoteUser:LongRandomSecretKey@HOSTNAME/BUCKET \
      --service "replication"

- Replace ``BUCKET`` with the name of the bucket on the ``ALPHA`` deployment to use as the replication source. Replace ``ALPHA`` with the :ref:`alias <alias>` of the MinIO deployment on which you are configuring replication.

- Replace ``HOSTNAME`` with the URL of the ``BAKER`` deployment.

- Replace ``BUCKET`` with the name of the bucket on the ``REMOTE`` deployment to use as the replication destination.

The command returns an ARN similar to the following:

.. code-block:: shell

   Role ARN = 'arn:minio:replication::<UUID>:BUCKET'

Copy the ARN string for use in the next step, noting the MinIO deployment on which it was created.

Repeat this step on the second MinIO deployment, replacing the ``ALPHA`` alias with the ``BAKER`` alias and the ``HOSTNAME`` with the URL of the ``ALPHA`` deployment.

You should have two ARNs at the conclusion of this step - one created on ``ALPHA/BUCKET`` pointing at ``BAKER/BUCKET``, and one created on ``BAKER/BUCKET`` pointing at ``ALPHA/BUCKET``. Use the :mc-cmd:`mc admin bucket remote ls` command to verify the created replication remote targets before proceeding.

2) Create a New Bucket Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc replicate add` command to add the new server-side
replication rule to the each MinIO deployment. 

.. code-block:: shell
   :class: copyable

   mc replicate add ALPHA/BUCKET \
      --remote-bucket 'arn:minio:replication::<UUID>:BUCKET' \
      --replicate "delete,delete-marker,existing-objects"

- Replace ``BUCKET`` with the name of the bucket on the ``ALPHA`` deployment to use as the replication source. Replace ``ALPHA`` with the :ref:`alias <alias>` of the MinIO deployment on which you are configuring replication. The name *must* match the bucket specified when creating the remote target in the previous step.

- Replace the ``--remote-bucket`` value with the ARN returned in the previous step. Ensure you specify the ARN created on the ``ALPHA`` deployment. You can use :mc-cmd:`mc admin bucket remote ls` to list all remote ARNs configured on the deployment.

- The ``--replicate "delete,delete-marker,existing-objects"`` flag enables the following replication features:
  
  - :ref:`Replication of Deletes <minio-replication-behavior-delete>` 
  - :ref:`Replication of existing Objects <minio-replication-behavior-existing-objects>`
  
  See :mc-cmd:`mc replicate add --replicate` for more complete documentation. Omit these fields to disable replication of delete operations or replication of existing objects respectively.

Specify any other supported optional arguments for :mc-cmd:`mc replicate add`.

Repeat this step on the second MinIO deployment, replacing the ``ALPHA`` alias with the ``BAKER`` alias and the ``HOSTNAME`` with the URL of the ``ALPHA`` deployment.

You should have two replication rules configured at the conclusion of this step - one created on ``ALPHA/BUCKET`` and one created on ``BAKER/BUCKET``. Use the :mc-cmd:`mc replicate ls` command to verify the created replication rules.

3) Validate the Replication Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp` to copy a new object to the ``ALPHA/BUCKET``  bucket. 

.. code-block:: shell
   :class: copyable

   mc cp ~/foo.txt ALPHA/BUCKET

Use :mc-cmd:`mc ls` to verify the object exists on the destination bucket:

.. code-block:: shell
   :class: copyable

   mc ls BAKER/BUCKET

Repeat this test by copying a new object to the ``Baker`` source bucket.

.. code-block:: shell
   :class: copyable

   mc cp ~/otherfoo.txt BAKER/BUCKET

Use :mc-cmd:`mc ls` to verify the object exists on the destination bucket:

.. code-block:: shell
   :class: copyable

   mc ls ALPHA/BUCKET
