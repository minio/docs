.. _minio-mc-admin-user-sts:

=====================
``mc admin user sts``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user sts

Description
-----------

.. versionadded:: RELEASE.2023-02-16T19-20-11Z

.. start-mc-admin-user-sts-desc

The :mc:`mc admin user sts` command operates on credentials generated using a :ref:`Security Token Service (STS) <minio-security-token-service>` API.

.. end-mc-admin-user-sts-desc

:abbr:`STS (Security Token Service)` credentials provide temporary access to the MinIO deployment.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

The :mc:`mc admin user sts` command has the following subcommand:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc:`~mc admin user sts info`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-sts-info.rst
          :start-after: start-mc-admin-sts-info-desc
          :end-before: end-mc-admin-sts-info-desc


.. toctree::
   :titlesonly:
   :hidden:

   /reference/minio-mc-admin/mc-admin-user-sts-info
