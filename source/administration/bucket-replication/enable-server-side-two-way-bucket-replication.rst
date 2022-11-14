.. _minio-bucket-replication-serverside-twoway:

=============================================
Enable Two-Way Server-Side Bucket Replication
=============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The procedure on this page creates a new bucket replication rule for two-way "active-active" synchronization of objects between MinIO buckets.

.. image:: /images/replication/active-active-twoway-replication.svg
   :width: 800px
   :alt: Active-Active Replication synchronizes data between two remote clusters.
   :align: center

- To configure replication between arbitrary S3-compatible services, use :mc:`mc mirror`.

- To configure one-way "active-passive" replication between MinIO clusters, see :ref:`minio-bucket-replication-serverside-oneway`.
  
- To configure multi-site "active-active" replication between MinIO clusters, see :ref:`minio-bucket-replication-serverside-multi`.

This tutorial covers configuring Active-Active replication between two MinIO clusters. For a tutorial on multi-site replication between three or more MinIO clusters, see :ref:`minio-bucket-replication-serverside-multi`.


.. _minio-bucket-replication-serverside-twoway-requirements:

Requirements
------------

You must meet all of the basic requirements for bucket replication described in :ref:`Bucket Replication Requirements <minio-bucket-replication-requirements>`.

In addition, to set up active-active bucket replication, you must meet the following additional requirements:

.. _minio-bucket-replication-serverside-twoway-permissions:

Access to Both Clusters
~~~~~~~~~~~~~~~~~~~~~~~

You must have network access and login credentials with required permissions to both deployment to set up active-active bucket replication.

You can access the deployments by logging in to the :ref:`MinIO Console <minio-console>` for each deployment or by installing :mc:`mc` and using the command line.

If using the command line, use the :mc:`mc alias` command to create an alias for both MinIO deployments. 
Alias creation requires specifying an access key for a user on the deployment. 
This user **must** have permission to create and manage users and policies on the deployment. 

Specifically, ensure the user has *at minimum*:

- :policy-action:`admin:CreateUser`
- :policy-action:`admin:ListUsers`
- :policy-action:`admin:GetUser`
- :policy-action:`admin:CreatePolicy`
- :policy-action:`admin:GetPolicy`
- :policy-action:`admin:AttachUserOrGroupPolicy`


Considerations
--------------

.. dropdown:: Use Consistent Replication Settings
   :icon: fold-down

   MinIO supports customizing the replication configuration to enable or disable the following replication behaviors:

   - Replication of delete operations
   - Replication of delete markers
   - Replication of existing objects
   - Replication of metadata-only changes

   When configuring replication rules for a bucket, ensure that both MinIO deployments participating in active-active replication use the *same* replication behaviors to ensure consistent and predictable synchronization of objects.

.. dropdown:: Replication of Existing Objects
   :icon: fold-down

   MinIO supports automatically replicating existing objects in a bucket.

   MinIO requires explicitly enabling replication of existing objects using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate update --replicate` and including the ``existing-objects`` replication feature flag. 
   This procedure includes the required flags for enabling replication of existing objects.

.. dropdown:: Replication of Delete Operations
   :icon: fold-down

   MinIO supports replicating delete operations onto the target bucket. 
   Specifically, MinIO can replicate versioning :s3-docs:`Delete Markers <versioning-workflows.html>` and the deletion of specific versioned objects:

   - For delete operations on an object, MinIO replication also creates the delete marker on the target bucket.

   - For delete operations on versions of an object, MinIO replication also deletes those versions on the target bucket.

   MinIO requires explicitly enabling replication of delete operations using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate update --replicate`. 
   This procedure includes the required flags for enabling replication of delete operations and delete markers.

   MinIO does *not* replicate delete operations resulting from the application of :ref:`lifecycle management expiration rules <minio-lifecycle-management-expiration>`. 
   Configure matching expiration rules on both the source and destination bucket to ensure consistent application of object expiration.

   See :ref:`minio-replication-behavior-delete` for more complete documentation.

.. dropdown:: Multi-Site Replication
   :icon: fold-down

   MinIO supports configuring multiple remote targets per bucket or bucket prefix. 
   This enables configuring multi-site active-active replication between MinIO deployments.

   This procedure covers active-active replication between *two* MinIO sites. 
   You can repeat this procedure for each "pair" of MinIO deployments in the replication mesh. For a dedicated tutorial, see :ref:`minio-bucket-replication-serverside-multi`.

Procedure
---------

- :ref:`Configure Two-Way Bucket Replication Using the MinIO Console <minio-bucket-replication-two-way-minio-console-procedure>`
   - :ref:`Create a New Bucket Replication Rule on Each Deployment <minio-bucket-replication-two-way-minio-console-create-replication-rules>` 
   - :ref:`Validate the Replication Configuration <minio-bucket-replication-two-way-minio-console-validate-replication-config>`
- :ref:`Configure Two-Way Bucket Replication Using the Command Line <minio-bucket-replication-two-way-minio-cli-procedure>`
   - :ref:`Create Replication Remote Targets <minio-bucket-replication-two-way-minio-cli-create-remote-targets>`
   - :ref:`Create a New Bucket Replication Rule on Each Deployment <minio-bucket-replication-two-way-minio-cli-create-replication-rules>`
   - :ref:`Validate the Replication Configuration <minio-bucket-replication-two-way-minio-cli-verify-replication-config>` 

.. _minio-bucket-replication-two-way-minio-console-procedure:

Configure Two-Way Bucket Replication Using the MinIO Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. _minio-bucket-replication-two-way-minio-console-create-replication-rules:

1) Create a New Bucket Replication Rule on Each Deployment
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-create-bucket-replication-rule-console-desc
   :end-before: end-create-bucket-replication-rule-console-desc

Repeat the above steps to create a rule in the other direction.
      
A) Go to the Console for the destination deployment used above.
B) Create a replication rule from the second deployment back to the first deployment.
   The first deployment becomes the target deployment for the rule on the second deployment.

.. _minio-bucket-replication-two-way-minio-console-validate-replication-config:

2) Validate the Replication Configuration
+++++++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-validate-bucket-replication-console-desc
   :end-before: end-validate-bucket-replication-console-desc

.. _minio-bucket-replication-two-way-minio-cli-procedure:

Configure Two-Way Bucket Replication Using the Command Line (:mc:`mc`)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure creates two-way, active-active replication between two MinIO deployments.

This procedure assumes you have already defined an alias for each deployment as a user with the :ref:`necessary replication permissions <minio-bucket-replication-serverside-twoway-permissions>`.

.. _minio-bucket-replication-two-way-minio-cli-create-remote-targets:

1) Create Replication Remote Targets
++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-create-replication-remote-targets-cli-desc
   :end-before: end-create-replication-remote-targets-cli-desc

Repeat this step on the second MinIO deployment, reversing the origin and destination.

You should have two ARNs at the conclusion of this step that point from each deployment to the other deployment's bucket. 
Use :mc-cmd:`mc admin bucket remote ls` to verify the remote targets before proceeding.

.. _minio-bucket-replication-two-way-minio-cli-create-replication-rules:

2) Create a New Bucket Replication Rule on Each Deployment
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-create-bucket-replication-rule-cli-desc
   :end-before: end-create-bucket-replication-rule-cli-desc

Repeat this step on the other MinIO deployment.
Change the alias for the different origin.
Change the ARN to the ARN generated on the second deployment for the desired bucket.

You should have two replication rules configured at the conclusion of this step - one created on each deployment that points to the bucket on the other deployment.
Use the :mc:`mc replicate ls` command to verify the created replication rules.

.. _minio-bucket-replication-two-way-minio-cli-verify-replication-config:

3) Validate the Replication Configuration
+++++++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-validate-bucket-replication-cli-desc
   :end-before: end-validate-bucket-replication-cli-desc

Repeat this test by copying another object to the second deployment and verifying the object replicates to the first deployment.

Once both objects exist on both deployments, you have successfully set up two-way, active-active replication between MinIO buckets.

.. seealso::

   - Use the :mc:`mc replicate update` command to modify an existing
     replication rule.

   - Use the :mc:`mc replicate update` command with the :mc-cmd:`--state "disable" <mc replicate update --state>` flag to disable an existing replication rule.

   - Use the :mc:`mc replicate rm` command to remove an existing replication rule.