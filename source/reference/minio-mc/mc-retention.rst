================
``mc retention``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc retention


Description
-----------

.. start-mc-retention-desc

The :mc:`mc retention` command configures the :ref:`Write-Once Read-Many (WORM) locking <minio-object-locking>` settings for an object or object(s) in a bucket. 
You can also set the default object lock settings for a bucket, where all objects without explicit object lock settings inherit the bucket default.

.. end-mc-retention-desc

Subcommands
-----------

:mc:`mc retention` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc retention clear`
     - .. include:: /reference/minio-mc/mc-retention-clear.rst
          :start-after: start-mc-retention-clear-desc
          :end-before: end-mc-retention-clear-desc

   * - :mc:`~mc retention info`
     - .. include:: /reference/minio-mc/mc-retention-info.rst
          :start-after: start-mc-retention-info-desc
          :end-before: end-mc-retention-info-desc

   * - :mc:`~mc retention set`
     - .. include:: /reference/minio-mc/mc-retention-set.rst
          :start-after: start-mc-retention-set-desc
          :end-before: end-mc-retention-set-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-retention-set
   /reference/minio-mc/mc-retention-info
   /reference/minio-mc/mc-retention-clear