.. _minio-mc-admin-cluster-bucket:

===========================
``mc admin cluster bucket``
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin cluster bucket

Description
-----------

.. versionadded:: RELEASE.2022-06-17T02-52-50Z

.. start-mc-admin-cluster-bucket-desc

The :mc:`mc admin cluster bucket` command and its subcommands provide tools for manually importing and exporting MinIO bucket metadata.

.. end-mc-admin-cluster-bucket-desc

This metadata includes configurations related to features like :ref:`lifecycle management rules <minio-lifecycle-management>`.

You can use this command on individual buckets *or* on all buckets in a MinIO deployment.
For automatic synchronization of all buckets in a deployment to a remote site, use :ref:`site replication <minio-site-replication-overview>`.

The :mc:`mc admin cluster bucket` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc:`~mc admin cluster bucket import`
     - .. include:: /reference/minio-mc-admin/mc-admin-cluster-bucket-import.rst
          :start-after: start-mc-admin-cluster-bucket-import-desc
          :end-before: end-mc-admin-cluster-bucket-import-desc

   * - :mc:`~mc admin cluster bucket export`
     - .. include:: /reference/minio-mc-admin/mc-admin-cluster-bucket-export.rst
          :start-after: start-mc-admin-cluster-bucket-export-desc
          :end-before: end-mc-admin-cluster-bucket-export-desc



.. toctree::
   :titlesonly:
   :hidden:

   /reference/minio-mc-admin/mc-admin-cluster-bucket-import
   /reference/minio-mc-admin/mc-admin-cluster-bucket-export


