.. _minio-mc-admin-cluster-iam:

========================
``mc admin cluster iam``
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin cluster iam

Description
-----------

.. versionadded:: RELEASE.2022-06-26T18-51-48Z

.. start-mc-admin-cluster-iam-desc

The :mc:`mc admin cluster iam` command and its subcommands provide tools for manually importing and exporting MinIO :ref:`IAM <minio-authentication-and-identity-management>` metadata.

.. end-mc-admin-cluster-iam-desc

For automatic synchronization of all IAM configurations in a deployment to a remote site, use :ref:`site replication <minio-site-replication-overview>`.

The :mc:`mc admin cluster iam` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc:`~mc admin cluster iam import`
     - .. include:: /reference/minio-mc-admin/mc-admin-cluster-iam-import.rst
          :start-after: start-mc-admin-cluster-iam-import-desc
          :end-before: end-mc-admin-cluster-iam-import-desc

   * - :mc:`~mc admin cluster iam export`
     - .. include:: /reference/minio-mc-admin/mc-admin-cluster-iam-export.rst
          :start-after: start-mc-admin-cluster-iam-export-desc
          :end-before: end-mc-admin-cluster-iam-export-desc



.. toctree::
   :titlesonly:
   :hidden:

   /reference/minio-mc-admin/mc-admin-cluster-iam-import
   /reference/minio-mc-admin/mc-admin-cluster-iam-export


