==============
``mc version``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc version

Description
-----------

.. start-mc-version-desc

The :mc:`mc version` commands enable, disable, and retrieve the :ref:`versioning <minio-bucket-versioning>` status for a MinIO bucket.

.. end-mc-version-desc

For more information about object versioning in MinIO, see :ref:`minio-bucket-versioning`.

:mc:`mc version` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc version enable`
     - .. include:: /reference/minio-mc/mc-version-enable.rst
          :start-after: start-mc-version-enable-desc
          :end-before: end-mc-version-enable-desc

   * - :mc:`~mc version info`
     - .. include:: /reference/minio-mc/mc-version-info.rst
          :start-after: start-mc-version-info-desc
          :end-before: end-mc-version-info-desc

   * - :mc:`~mc version suspend`
     - .. include:: /reference/minio-mc/mc-version-suspend.rst
          :start-after: start-mc-version-suspend-desc
          :end-before: end-mc-version-suspend-desc


Behavior
--------

Object Locking Enables Bucket Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While bucket versioning is disabled by default, configuring object locking on a bucket or an object in that bucket automatically enables versioning for the bucket.
See :mc:`mc retention` for more information on configuring object locking.

Bucket Versioning with Existing Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enabling bucket versioning on a bucket with existing data immediately applies a versioning ID to any unversioned object.

Disabling bucket versioning on a bucket with existing versioned data does *not* remove any versioned objects.
Applications can continue to access versioned data after disabling bucket versioning.
Use :mc-cmd:`mc rm --versions ALIAS/BUCKET/OBJECT <mc rm --versions>` to delete an object *and* all its versions.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

.. toctree::
   :titlesonly:
   :hidden:

   /reference/minio-mc/mc-version-enable
   /reference/minio-mc/mc-version-info
   /reference/minio-mc/mc-version-suspend
