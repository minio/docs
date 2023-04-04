============
``mc batch``
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc batch


.. versionadded:: mc RELEASE.2023-03-20T17-17-53Z

   Added the ability to cancel jobs with the :mc:`mc batch cancel` command.


Description
-----------

.. start-mc-batch-desc

The :mc:`mc batch` commands allow you to run one or more job tasks on a MinIO deployment.

.. end-mc-batch-desc

Subcommands
-----------

:mc-cmd:`mc batch` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc batch cancel`
     - .. include:: /reference/minio-mc/mc-batch-cancel.rst
          :start-after: start-mc-batch-cancel-desc
          :end-before: end-mc-batch-cancel-desc

   * - :mc:`~mc batch describe`
     - .. include:: /reference/minio-mc/mc-batch-describe.rst
          :start-after: start-mc-batch-describe-desc
          :end-before: end-mc-batch-describe-desc
   
   * - :mc:`~mc batch generate`
     - .. include:: /reference/minio-mc/mc-batch-generate.rst
          :start-after: start-mc-batch-generate-desc
          :end-before: end-mc-batch-generate-desc

   * - :mc:`~mc batch list`
     - .. include:: /reference/minio-mc/mc-batch-list.rst
          :start-after: start-mc-batch-list-desc
          :end-before: end-mc-batch-list-desc

   * - :mc:`~mc batch start`
     - .. include:: /reference/minio-mc/mc-batch-start.rst
          :start-after: start-mc-batch-start-desc
          :end-before: end-mc-batch-start-desc

   * - :mc:`~mc batch status`
     - .. include:: /reference/minio-mc/mc-batch-status.rst
          :start-after: start-mc-batch-status-desc
          :end-before: end-mc-batch-status-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-batch-cancel
   /reference/minio-mc/mc-batch-describe
   /reference/minio-mc/mc-batch-generate
   /reference/minio-mc/mc-batch-list
   /reference/minio-mc/mc-batch-start
   /reference/minio-mc/mc-batch-status
