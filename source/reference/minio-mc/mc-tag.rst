==========
``mc tag``
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc tag


Description
-----------

.. start-mc-tag-desc

The :mc:`mc tag` command adds, removes, and lists tags associated to a bucket or object.

.. end-mc-tag-desc

MinIO supports adding up to 10 custom tags to an object.

Subcommands
-----------

:mc:`mc tag` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc tag list`
     - .. include:: /reference/minio-mc/mc-tag-list.rst
          :start-after: start-mc-tag-list-desc
          :end-before: end-mc-tag-list-desc

   * - :mc:`~mc tag remove`
     - .. include:: /reference/minio-mc/mc-tag-remove.rst
          :start-after: start-mc-tag-remove-desc
          :end-before: end-mc-tag-remove-desc

   * - :mc:`~mc tag set`
     - .. include:: /reference/minio-mc/mc-tag-set.rst
          :start-after: start-mc-tag-set-desc
          :end-before: end-mc-tag-set-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-tag-set
   /reference/minio-mc/mc-tag-list
   /reference/minio-mc/mc-tag-remove