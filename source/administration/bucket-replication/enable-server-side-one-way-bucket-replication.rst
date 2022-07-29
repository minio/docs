.. _minio-bucket-replication-serverside-oneway:

=============================================
Enable One-Way Server-Side Bucket Replication
=============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


The procedure on this page creates a new bucket replication rule for one-way synchronization of objects from one MinIO bucket to another MinIO bucket.
The buckets can be on the same MinIO deployment or on separate MinIO deployments.

.. image:: /images/replication/active-passive-oneway-replication.svg
   :width: 800px
   :alt: Active-Passive Replication synchronizes data from a source MinIO deployment to a remote MinIO deployment.
   :align: center


- To configure two-way "active-active" replication between MinIO buckets, see :ref:`minio-bucket-replication-serverside-twoway`.
- To configure multi-site "active-active" replication between MinIO deployments, see :ref:`minio-bucket-replication-serverside-multi`

.. note::

   To configure replication between arbitrary S3-compatible services (not necessarily MinIO), use :mc-cmd:`mc mirror`.


Requirements
------------


Replication requires all participating clusters meet the :ref:`following requirements <minio-bucket-replication-requirements>`. 
This procedure assumes you have reviewed and validated those requirements.

For more details, see the :ref:`Bucket Replication Requirements <minio-bucket-replication-requirements>` page.


Considerations
--------------

Click to expand any of the following:

.. dropdown:: Replication of Existing Objects
   :icon: fold-down

   MinIO supports automatically replicating existing objects in a bucket.

   MinIO requires explicitly enabling replication of existing objects using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate edit --replicate` and including the ``existing-objects`` replication feature flag. 
   This procedure includes the required flags for enabling replication of existing objects.

.. dropdown:: Replication of Delete Operations
   :icon: fold-down

   MinIO supports replicating S3 ``DELETE`` operations onto the target bucket. 
   Specifically, MinIO can replicate versioning :s3-docs:`Delete Markers <versioning-workflows.html>` and the deletion of specific versioned objects:

   - For delete operations on an object, MinIO replication also creates the delete marker on the target bucket.

   - For delete operations on versions of an object, MinIO replication also deletes those versions on the target bucket.

   MinIO requires explicitly enabling replication of delete operations using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate edit --replicate`. 
   This procedure includes the required flags for enabling replication of delete operations and delete markers.

   MinIO does *not* replicate delete operations resulting from the application of :ref:`lifecycle management expiration rules <minio-lifecycle-management-expiration>`.

   See :ref:`minio-replication-behavior-delete` for more complete documentation.

.. dropdown:: Multi-Site Replication
   :icon: fold-down

   MinIO supports configuring multiple remote targets per bucket or bucket prefix. 
   For example, you can configure a bucket to replicate data to two or more remote MinIO deployments, where one deployment is a 1:1 copy (replication of all operations including deletions) and another is a full historical record (replication of only non-destructive write operations).

   This procedure documents one-way replication to a single remote MinIO deployment. 
   You can repeat this tutorial to replicate a single bucket to multiple remote targets.

Procedure
---------

- :ref:`<minio-bucket-replication-one-way-minio-console-procedure>`
   - :ref:`<minio-bucket-replication-one-way-minio-console-create-replication-rules>` 
   - :ref:`<minio-bucket-replication-one-way-minio-console-validate-replication-config>`
- :ref:`<minio-bucket-replication-one-way-minio-cli-procedure>`
   - :ref:`<minio-bucket-replication-one-way-minio-cli-create-remote-targets>`
   - :ref:`<minio-bucket-replication-one-way-minio-cli-create-replication-rules>`
   - :ref:`<minio-bucket-replication-one-way-minio-cli-verify-replication-config>` 

.. _minio-bucket-replication-one-way-minio-console-procedure:

Configure One-Way Bucket Replication Using the MinIO Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. _minio-bucket-replication-one-way-minio-console-create-replication-rules:

1) Create a New Bucket Replication Rule
+++++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-create-bucket-replication-rule-console-desc
   :end-before: end-create-bucket-replication-rule-console-desc

.. _minio-bucket-replication-one-way-minio-console-validate-replication-config:

2) Validate the Replication Configuration
+++++++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-validate-bucket-replication-console-desc
   :end-before: end-validate-bucket-replication-console-desc

.. _minio-bucket-replication-one-way-minio-cli-procedure:

Configure One-Way Bucket Replication Using the Command Line (:mc:`mc`)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses the :ref:`aliases <alias>` ``SOURCE`` and ``REMOTE`` to reference each MinIO deployment being configured for replication. 
Replace these values with the appropriate alias for your target MinIO deployments.

This procedure assumes each alias corresponds to a user with the :ref:`necessary replication permissions <minio-bucket-replication-serverside-oneway-permissions>`.

.. _minio-bucket-replication-one-way-minio-cli-create-remote-targets:

1) Create a Replication Remote Target
+++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-create-replication-remote-targets-cli-desc
   :end-before: end-create-replication-remote-targets-cli-desc

.. _minio-bucket-replication-one-way-minio-cli-create-replication-rules:

2) Create a New Bucket Replication Rule
+++++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-create-bucket-replication-rule-cli-desc
   :end-before: end-create-bucket-replication-rule-cli-desc

.. _minio-bucket-replication-one-way-minio-cli-verify-replication-config:

3) Validate the Replication Configuration
+++++++++++++++++++++++++++++++++++++++++

.. include:: /includes/common/bucket-replication.rst
   :start-after: start-validate-bucket-replication-cli-desc
   :end-before: end-validate-bucket-replication-cli-desc

.. seealso::

   - Use the :mc-cmd:`mc replicate edit` command to modify an existing replication rule.

   - Use the :mc-cmd:`mc replicate edit` command with the :mc-cmd:`--state "disable" <mc replicate edit --state>` flag to disable an existing replication rule.

   - Use the :mc-cmd:`mc replicate rm` command to remove an existing replication rule.
