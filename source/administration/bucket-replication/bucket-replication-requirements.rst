.. _minio-bucket-replication-requirements:

=========================================
Requirements to Set Up Bucket Replication
=========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. _minio-bucket-replication-serverside-oneway-permissions:

Bucket replication uses rules to synchronize the contents of a bucket on one MinIO deployment to a bucket on a remote MinIO deployment.

Replication can be done in any of the following ways:

- :ref:`Active-Passive <minio-bucket-replication-serverside-oneway>`
  Eligible objects replicate from the source bucket to the remote bucket.
  Any changes on the remote bucket do not replicate back.
- :ref:`Active-Active <minio-bucket-replication-serverside-twoway>`
  Changes to eligible objects of either bucket replicate to the other bucket in a two-way direction.
- :ref:`Multi-Site Active-Active <minio-bucket-replication-serverside-multi>`
  Changes to eligible objects on any bucket set up for bucket replication replicate to all of the other buckets.

Ensure you meet the following prerequisites before you set up any of these replication configurations.

Permissions Required for Setting Up Bucket Replication
------------------------------------------------------

.. include:: /includes/common-replication.rst
   :start-after: start-replication-required-permissions
   :end-before: end-replication-required-permissions

Matching Object Encryption Settings for Bucket Replication
----------------------------------------------------------

.. include:: /includes/common-replication.rst
   :start-after: start-replication-encrypted-objects
   :end-before: end-replication-encrypted-objects

Bucket Replication Requires MinIO Deployments
---------------------------------------------

.. include:: /includes/common-replication.rst
   :start-after: start-replication-minio-only
   :end-before: end-replication-minio-only

Versioning Objects for Bucket Replication
-----------------------------------------

.. include:: /includes/common-replication.rst
   :start-after: start-replication-requires-versioning
   :end-before: end-replication-requires-versioning

Matching Object Locking State With Bucket Replication
-----------------------------------------------------

.. include:: /includes/common-replication.rst
   :start-after: start-replication-requires-object-locking
   :end-before: end-replication-requires-object-locking