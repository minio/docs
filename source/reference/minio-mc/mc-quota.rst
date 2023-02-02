============
``mc quota``
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc quota


Description
-----------

.. start-mc-quota-desc

The :mc:`mc quota` commands configure, display, or remove a hard quota limit on a bucket. 

.. end-mc-quota-desc

When a bucket with a quota configured reaches the specified limit, MinIO rejects further ``PUT`` requests for the bucket. 

Subcommands
-----------

:mc:`mc quota` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc quota clear`
     - .. include:: /reference/minio-mc/mc-quota-clear.rst
          :start-after: start-mc-quota-clear-desc
          :end-before: end-mc-quota-clear-desc

   * - :mc:`~mc quota info`
     - .. include:: /reference/minio-mc/mc-quota-info.rst
          :start-after: start-mc-quota-info-desc
          :end-before: end-mc-quota-info-desc

   * - :mc:`~mc quota set`
     - .. include:: /reference/minio-mc/mc-quota-set.rst
          :start-after: start-mc-quota-set-desc
          :end-before: end-mc-quota-set-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-quota-clear
   /reference/minio-mc/mc-quota-info
   /reference/minio-mc/mc-quota-set