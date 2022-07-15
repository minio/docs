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

This procecure creates two-way, active-active replication between two MinIO deployments.

This procedure assumes you have already defined an alias for each deployment as a user with the :ref:`necessary replication permissions <minio-bucket-replication-serverside-twoway-permissions>`.

1) Create the Replication Remote Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin bucket remote add` command to create a replication target from each deployment to the appropriate bucket on the destination deployment. 
MinIO supports *one* remote target for an origin bucket to destination bucket combination. 

.. code-block:: shell
   :class: copyable

   mc admin bucket remote add ALIAS/BUCKET         \
      https://RemoteUser:Password@HOSTNAME/BUCKETDESTINATION  \
      --service "replication"

- Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO deployment that acts as the origin for the replication.
- Replace ``BUCKET`` with the name of the bucket to replicate from on the origin deployment.
- Replacete ``RemoteUser`` with the user name that has the :ref:`necessary replication permissions <minio-bucket-replication-serverside-twoway-permissions>`
- Replace ``Password`` with the secret key for the ``RemoteUser``.
- Replace ``HOSTNAME`` with the URL of the destination deployment.
- Replace ``BUCKETDESTINATION`` with the name of the bucket to replicate to on the destination deployment.

The command returns an :abbr:`ARN <Amazon Resource Name>` similar to the following:

.. code-block:: shell

   Role ARN = 'arn:minio:replication::<UUID>:BUCKET'

Copy the ARN to use in the next step, noting the MinIO deployment.

Repeat this step on the second MinIO deployment, reversing the origin and destination.

You should have two ARNs at the conclusion of this step that point from each deployment to the other deployment's bucket. 
Use :mc-cmd:`mc admin bucket remote ls` to verify the remote targets before proceeding.

1) Create a New Bucket Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc replicate add` command to add a new replication rule to each MinIO deployment. 

.. code-block:: shell
   :class: copyable

   mc replicate add ALIAS/BUCKET \
      --remote-bucket 'arn:minio:replication::<UUID>:DESTINATIONBUCKET' \
      --replicate "delete,delete-marker,existing-objects"

- Replace ``ALIAS`` with the :ref:`alias <alias>` of the origin MinIO deployment.  
  The name *must* match the bucket specified when creating the remote target in the previous step.

- Replace ``BUCKET`` with the name of the bucket to replicate from on the origin deployment. 

- Replace the ``--remote-bucket`` value with the ARN for the destination bucket determined in the first step. 
  Ensure you specify the ARN created on the origin deployment. 
  You can use :mc-cmd:`mc admin bucket remote ls` to list all remote ARNs configured on the deployment.

- The ``--replicate "delete,delete-marker,existing-objects"`` flag enables the following replication features:
  
  - :ref:`Replication of Deletes <minio-replication-behavior-delete>` 
  - :ref:`Replication of existing Objects <minio-replication-behavior-existing-objects>`
  
  See :mc-cmd:`mc replicate add --replicate` for more complete documentation. 
  Omit any field to disable replication of that component.

Specify any other supported optional arguments for :mc-cmd:`mc replicate add`.

Repeat this step on the other MinIO deployment.
Change the alias for the different origin.
Change the ARN to the ARN generated on the second deployment for the desired bucket.

You should have two replication rules configured at the conclusion of this step - one created on each deployment that points to the bucket on the other deployment.
Use the :mc-cmd:`mc replicate ls` command to verify the created replication rules.

1) Validate the Replication Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp` to copy a new object to the replicated bucket on one of the deployments. 

.. code-block:: shell
   :class: copyable

   mc cp ~/foo.txt ALIAS/BUCKET

Use :mc-cmd:`mc ls` to verify the object exists on the destination bucket:

.. code-block:: shell
   :class: copyable

   mc ls ALIAS/BUCKET

Repeat this test by copying another object to the second deployment and verifying the object replicates to the first deployment.

Once both objects exist on both deployments, you have successfully set up two-way, active-active replication between MinIO buckets.