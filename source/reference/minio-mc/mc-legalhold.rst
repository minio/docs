================
``mc legalhold``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc legalhold


Description
-----------

.. start-mc-legalhold-desc

The :mc:`mc legalhold` command sets, removes, or retrieves the :ref:`object legal hold (WORM) <minio-object-locking-legalhold>` settings for object(s).

.. end-mc-legalhold-desc

Subcommands
-----------

:mc:`mc legalhold` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc legalhold clear`
     - .. include:: /reference/minio-mc/mc-legalhold-clear.rst
          :start-after: start-mc-legalhold-clear-desc
          :end-before: end-mc-legalhold-clear-desc

   * - :mc:`~mc legalhold info`
     - .. include:: /reference/minio-mc/mc-legalhold-info.rst
          :start-after: start-mc-legalhold-info-desc
          :end-before: end-mc-legalhold-info-desc

   * - :mc:`~mc legalhold set`
     - .. include:: /reference/minio-mc/mc-legalhold-set.rst
          :start-after: start-mc-legalhold-set-desc
          :end-before: end-mc-legalhold-set-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-legalhold-clear
   /reference/minio-mc/mc-legalhold-info
   /reference/minio-mc/mc-legalhold-set
