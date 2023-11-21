============
``mc alias``
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc alias


Description
-----------

.. start-mc-alias-desc

The :mc:`mc alias` commands provide a convenient interface for managing the list of S3-compatible hosts that :mc-cmd:`mc` can connect to and run operations against.

.. end-mc-alias-desc

.. important:: 
   
   :mc-cmd:`mc` commands that operate on S3-compatible services *require* specifying an alias for that service.

Subcommands
-----------

:mc:`mc alias` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc alias list`
     - .. include:: /reference/minio-mc/mc-alias-list.rst
          :start-after: start-mc-alias-list-desc
          :end-before: end-mc-alias-list-desc

   * - :mc:`~mc alias remove`
     - .. include:: /reference/minio-mc/mc-alias-remove.rst
          :start-after: start-mc-alias-remove-desc
          :end-before: end-mc-alias-remove-desc

   * - :mc:`~mc alias set`
     - .. include:: /reference/minio-mc/mc-alias-set.rst
          :start-after: start-mc-alias-set-desc
          :end-before: end-mc-alias-set-desc

   * - :mc:`~mc alias import`
     - .. include:: /reference/minio-mc/mc-alias-import.rst
          :start-after: start-mc-alias-import-desc
          :end-before: end-mc-alias-import-desc

   * - :mc:`~mc alias export`
     - .. include:: /reference/minio-mc/mc-alias-export.rst
          :start-after: start-mc-alias-export-desc
          :end-before: end-mc-alias-export-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-alias-list
   /reference/minio-mc/mc-alias-remove
   /reference/minio-mc/mc-alias-set
   /reference/minio-mc/mc-alias-import
   /reference/minio-mc/mc-alias-export
