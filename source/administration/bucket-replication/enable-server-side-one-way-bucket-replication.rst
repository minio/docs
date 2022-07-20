.. _minio-bucket-replication-serverside-oneway:

=============================================
Enable One-Way Server-Side Bucket Replication
=============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1


The procedure on this page creates a new bucket replication rule for one-way synchronization of objects from one MinIO bucket to another MinIO bucket.
The buckets can be on the same MinIO deployment or on separate MinIO deployments.

.. image:: /images/replication/active-passive-oneway-replication.svg
   :width: 450px
   :alt: Active-Passive Replication synchronizes data from a source MinIO cluster to a remote MinIO cluster.
   :align: center


- To configure two-way "active-active" replication between MinIO buckets, see :ref:`minio-bucket-replication-serverside-twoway`.
- To configure multi-site "active-active" replication between MinIO clusters, see :ref:`minio-bucket-replication-serverside-multi`

.. note::

   To configure replication between arbitrary S3-compatible services (not necessarily MinIO), use :mc-cmd:`mc mirror`.

.. seealso::

   - Use the :mc-cmd:`mc replicate edit` command to modify an existing replication rule.

   - Use the :mc-cmd:`mc replicate edit` command with the :mc-cmd:`--state "disable" <mc replicate edit --state>` flag to disable an existing replication rule.

   - Use the :mc-cmd:`mc replicate rm` command to remove an existing replication rule.

.. _minio-bucket-replication-serverside-oneway-requirements:

Requirements
------------

.. _minio-bucket-replication-serverside-oneway-permissions:

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

Replication of Existing Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports automatically replicating existing objects in a bucket.

MinIO requires explicitly enabling replication of existing objects using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate edit --replicate` and including the ``existing-objects`` replication feature flag. 
This procedure includes the required flags for enabling replication of existing objects.

Replication of Delete Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating S3 ``DELETE`` operations onto the target bucket. 
Specifically, MinIO can replicate versioning :s3-docs:`Delete Markers <versioning-workflows.html>` and the deletion of specific versioned objects:

- For delete operations on an object, MinIO replication also creates the delete marker on the target bucket.

- For delete operations on versions of an object, MinIO replication also deletes those versions on the target bucket.

MinIO requires explicitly enabling replication of delete operations using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate edit --replicate`. 
This procedure includes the required flags for enabling replication of delete operations and delete markers.

MinIO does *not* replicate delete operations resulting from the application of :ref:`lifecycle management expiration rules <minio-lifecycle-management-expiration>`.

See :ref:`minio-replication-behavior-delete` for more complete documentation.

Multi-Site Replication
~~~~~~~~~~~~~~~~~~~~~~

MinIO supports configuring multiple remote targets per bucket or bucket prefix. For example, you can configure a bucket to replicate data to two or more remote MinIO deployments, where one deployment is a 1:1 copy (replication of all operations including deletions) and another is a full historical record (replication of only non-destructive write operations).

This procedure documents one-way replication to a single remote MinIO deployment. You can repeat this tutorial for multiple remote targets for a single bucket.

Procedure
---------

This procedure uses the :ref:`aliases <alias>` ``SOURCE`` and ``REMOTE`` to reference each MinIO deployment being configured for replication. 
Replace these values with the appropriate alias for your target MinIO deployments.

This procedure assumes each alias corresponds to a user with the :ref:`necessary replication permissions <minio-bucket-replication-serverside-oneway-permissions>`.

1) Create a Replication Remote Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set:: 

   .. tab-item:: Console

      The MinIO Console automatically creates a remote target when generating a replication rule.
      Proceed to the next step.

   .. tab-item:: Command Line

      .. include:: /includes/common/bucket-replication.rst
         :start-after: start-create-replication-remote-targets-cli
         :end-before: end-create-replication-remote-targets-cli


2) Create a New Bucket Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set:: 

   .. tab-item:: Console

      .. include:: /includes/common/bucket-replication.rst
         :start-after: start-create-bucket-replication-rule-console
         :end-before: end-create-bucket-replication-rule-console

   .. tab-item:: Command Line

      .. include:: /includes/common/bucket-replication.rst
         :start-after: start-create-bucket-replication-rule-cli
         :end-before: end-create-bucket-replication-rule-cli


3) Validate the Replication Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set:: 

   .. tab-item:: Console

      .. include:: /includes/common/bucket-replication.rst
         :start-after: start-validate-bucket-replication-console
         :end-before: end-validate-bucket-replication-console

   .. tab-item:: Command Line

      .. include:: /includes/common/bucket-replication.rst
         :start-after: start-validate-bucket-replication-cli
         :end-before: end-validate-bucket-replication-cli
