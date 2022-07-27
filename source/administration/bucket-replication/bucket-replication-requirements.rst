.. _minio-bucket-replication-requirements:

=========================================
Requirements to Set Up Bucket Replication
=========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. _minio-bucket-replication-serverside-oneway-permissions:

Bucket replication uses rules to duplicate content from one MinIO bucket to another MinIO bucket.

Replication can be done in any of the following ways:

- :ref:`Active-Passive <minio-bucket-replication-serverside-oneway>`
  The affected contents of a bucket duplicate to another bucket in a one-way direction.
  Changes to affected contents on the remote bucket do **not** apply the objects on the origin bucket. 
- `Active-Active <minio-bucket-replication-serverside-twoway>`
  Changes to the affected contents of either bucket duplicate to the other bucket in a two-way direction.
- `Multi-Site Active-Active <><minio-bucket-replication-serverside-multi>`
  Changes to the affected contents on any bucket set up for bucket replication affect all of the other buckets.

This page explains the prerequisites that must be met before you can set up any of these types of bucket replication.

Permissions
-----------

.. include:: /includes/common-replication.rst
   :start-after: start-replication-required-permissions
   :end-before: end-replication-required-permissions

Matching Object Encryption Settings
-----------------------------------

.. include:: /includes/common-replication.rst
   :start-after: start-replication-encrypted-objects
   :end-before: end-replication-encrypted-objects

MinIO Deployments
-----------------

.. include:: /includes/common-replication.rst
   :start-after: start-replication-minio-only
   :end-before: end-replication-minio-only

Versioning
----------

.. include:: /includes/common-replication.rst
   :start-after: start-replication-requires-versioning
   :end-before: end-replication-requires-versioning

Matching Object Locking State
-----------------------------

.. include:: /includes/common-replication.rst
   :start-after: start-replication-requires-object-locking
   :end-before: end-replication-requires-object-locking