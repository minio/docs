.. _minio-bucket-replication-serverside-multi:

================================================
Enable Multi-Site Server-Side Bucket Replication
================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


The procedure on this page configures automatic server-side bucket replication between multiple MinIO deployments. Multi-Site Active-Active replication builds on the :ref:`minio-bucket-replication-serverside-twoway` procedure with additional considerations required to ensure predictable replication behavior across all sites.

.. image:: /images/replication/active-active-multi-replication.svg
   :width: 600px
   :alt: Active-Active Replication synchronizes data between multiple remote deployments.
   :align: center

- To configure replication between arbitrary S3-compatible services, use :mc:`mc mirror`.

- To configure one-way "active-active" replication between two MinIO deployments, see :ref:`minio-bucket-replication-serverside-twoway`.

- To configure one-way "active-passive" replication between MinIO deployments, see :ref:`minio-bucket-replication-serverside-oneway`.

Multi-Site Active-Active replication configurations can span multiple racks, datacenters, or geographic locations. Complexity of configuring and maintaining multi-site configurations generally increase with the number of sites and size of each site. Enterprises looking to implement multi-site replication should consider leveraging `MinIO SUBNET <https://min.io/pricing?ref=docs>`__ support to access the expertise, planning, and engineering resources required for addressing that use case. 

.. seealso::

   - Use the :mc:`mc replicate update` command to modify an existing replication rule.

   - Use the :mc:`mc replicate update` command with the :mc-cmd:`--state "disable" <mc replicate update --state>` flag to disable an existing replication rule.

   - Use the :mc:`mc replicate rm` command to remove an existing replication rule.

.. _minio-bucket-replication-serverside-multi-requirements:

Requirements
------------

You must meet all of the basic requirements for bucket replication described in :ref:`Bucket Replication Requirements <minio-bucket-replication-requirements>`.

In addition, to create multi-site bucket replication set up, you must meet the following additional requirements:

Access to All Clusters
~~~~~~~~~~~~~~~~~~~~~~

You must have network access and log in credentials with correct permissions to all deployments to set up multi-site active-active bucket replication.

You can access the deployments by logging in to the :ref:`MinIO Console <minio-console>` for each deployment or by installing :mc:`mc` and using the command line.

If using the command line, use the :mc:`mc alias` command to create an alias for each MinIO deployment. 
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

Click to expand any of the following:

.. dropdown:: Use Consistent Replication Settings
   :icon: fold-down

   MinIO supports customizing the replication configuration to enable or disable the following replication behaviors:

   - Replication of delete operations
   - Replication of delete markers
   - Replication of existing objects
   - Replication of metadata-only changes

   When configuring replication rules for a bucket, ensure that all MinIO deployments participating in multi-site replication use the *same* replication behaviors to ensure consistent and predictable synchronization of objects.

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
   Configure matching expiration rules for the bucket on all replication sites to ensure consistent application of object expiration.

Procedure 
---------

This procedure requires repeating steps for each MinIO deployment participating in the multi-site replication configuration. Depending on the number of deployments, this procedure may require significant time and care in implementation. MinIO recommends reading through the procedure *before* attempting to implement the documented steps.

- :ref:`Configure Multi-Site Bucket Replication Using the MinIO Console <minio-bucket-replication-multi-site-minio-console-procedure>`
   - :ref:`Create the Replication Rules <minio-bucket-replication-multi-site-minio-console-create-replication-rules>` 
   - :ref:`Validate the Replication Configuration <minio-bucket-replication-multi-site-minio-console-validate-replication-config>`
- :ref:`Configure Multi-Site Bucket Replication Using the Command Line <minio-bucket-replication-multi-site-minio-cli-procedure>`
   - :ref:`Create Replication Remote Targets <minio-bucket-replication-multi-site-minio-cli-create-remote-targets>`
   - :ref:`Create New Bucket Replication Rules <minio-bucket-replication-multi-site-minio-cli-create-replication-rules>`
   - :ref:`Validate the Replication Configuration <minio-bucket-replication-multi-site-minio-cli-verify-replication-config>` 

.. _minio-bucket-replication-multi-site-minio-console-procedure:

Configure Multi-Site Bucket Replication Using the MinIO Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. _minio-bucket-replication-multi-site-minio-console-create-replication-rules:

1) Create the Replication Rules
+++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-create-bucket-replication-rule-console-desc
   :end-before: end-create-bucket-replication-rule-console-desc

Repeat the above steps to create a rule from this deployment to each of the other target deployments.

Then, repeat the above steps on each of the other deployments in the multi-site setup so that each deployment has a separate replication rule for all of the other deployments.

.. _minio-bucket-replication-multi-site-minio-console-validate-replication-config:

2) Validate the Replication Configuration
+++++++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-validate-bucket-replication-console-desc
   :end-before: end-validate-bucket-replication-console-desc

Repeat this test on each deployment by copying a new unique file and checking that the file replicates to each of the other deployments.

.. _minio-bucket-replication-multi-site-minio-cli-procedure:

Configure Multi-Site Bucket Replication Using the Command Line ``mc``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses the placeholder ``ALIAS`` to reference the :ref:`alias <alias>` each MinIO deployment being configured for replication. 
Replace these values with the appropriate alias for each MinIO deployment.

This procedure assumes each alias corresponds to a user with the :ref:`necessary replication permissions <minio-bucket-replication-requirements>`.

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z

   :mc:`mc replicate add` automatically creates the necessary replication targets, removing the need for using the deprecated ``mc admin remote bucket add`` command.
   This procedure only documents the procedure as of that release.

.. _minio-bucket-replication-multi-site-minio-cli-create-remote-targets:

.. _minio-bucket-replication-multi-site-minio-cli-create-replication-rules:

1) Create New Bucket Replication Rules
++++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-create-bucket-replication-rule-cli-desc
   :end-before: end-create-bucket-replication-rule-cli-desc

Repeat these commands for each remote MinIO deployment participating in the multi-site replication configuration. 
For example, a multi-site replication configuration consisting of MinIO deployments ``minio1``, ``minio2``, and ``minio3`` would require repeating this step on each deployment for each remote. 
         
Specifically, in this scenario, perform this step twice on each deployment:

- On the ``minio1`` deployment, once for a rule for ``minio2`` and again for a separate rule for ``minio3``. 

- On the ``minio2`` deployment, once for a rule for ``minio1`` and again for a separate rule for ``minio3``.

- On the ``minio3`` deployment, once for a rule for ``minio1`` and again for a separate rule for ``minio2``.

.. _minio-bucket-replication-multi-site-minio-cli-verify-replication-config:

2) Validate the Replication Configuration
+++++++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-validate-bucket-replication-cli-desc
   :end-before: end-validate-bucket-replication-cli-desc

Repeat this test on each deployment by copying a new unique file and checking that the file replicates to each of the other deployments.

You can also use :mc:`mc stat` to check the file to check the current :ref:`replication stage <minio-replication-process>` of the object.
