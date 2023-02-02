================
``mc replicate``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc replicate


Description
-----------

.. start-mc-replicate-desc

The :mc:`mc replicate <mc replicate add>` command configures and manages the :ref:`Server-Side Bucket Replication <minio-bucket-replication-serverside>` for a MinIO deployment, including :ref:`active-active replication configurations <minio-bucket-replication-serverside-twoway>` and :ref:`resynchronization <minio-replication-behavior-resync>`.

.. end-mc-replicate-desc

.. note::

   For multi-site replication, see :mc:`mc admin replicate`.

Subcommands
-----------

:mc:`mc replicate` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc replicate add`
     - .. include:: /reference/minio-mc/mc-replicate-add.rst
          :start-after: start-mc-replicate-add-desc
          :end-before: end-mc-replicate-add-desc

   * - :mc:`~mc replicate diff`
     - .. include:: /reference/minio-mc/mc-replicate-diff.rst
          :start-after: start-mc-replicate-diff-desc
          :end-before: end-mc-replicate-diff-desc

   * - :mc:`~mc replicate export`
     - .. include:: /reference/minio-mc/mc-replicate-export.rst
          :start-after: start-mc-replicate-export-desc
          :end-before: end-mc-replicate-export-desc

   * - :mc:`~mc replicate import`
     - .. include:: /reference/minio-mc/mc-replicate-import.rst
          :start-after: start-mc-replicate-import-desc
          :end-before: end-mc-replicate-import-desc

   * - :mc:`~mc replicate ls`
     - .. include:: /reference/minio-mc/mc-replicate-ls.rst
          :start-after: start-mc-replicate-ls-desc
          :end-before: end-mc-replicate-ls-desc

   * - :mc:`~mc replicate resync`
     - .. include:: /reference/minio-mc/mc-replicate-resync.rst
          :start-after: start-mc-replicate-resync-desc
          :end-before: end-mc-replicate-resync-desc

   * - :mc:`~mc replicate rm`
     - .. include:: /reference/minio-mc/mc-replicate-rm.rst
          :start-after: start-mc-replicate-rm-desc
          :end-before: end-mc-replicate-rm-desc

   * - :mc:`~mc replicate status`
     - .. include:: /reference/minio-mc/mc-replicate-status.rst
          :start-after: start-mc-replicate-status-desc
          :end-before: end-mc-replicate-status-desc

   * - :mc:`~mc replicate update`
     - .. include:: /reference/minio-mc/mc-replicate-update.rst
          :start-after: start-mc-replicate-update-desc
          :end-before: end-mc-replicate-update-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-replicate-add
   /reference/minio-mc/mc-replicate-diff
   /reference/minio-mc/mc-replicate-ls
   /reference/minio-mc/mc-replicate-update
   /reference/minio-mc/mc-replicate-resync
   /reference/minio-mc/mc-replicate-rm
   /reference/minio-mc/mc-replicate-status
   /reference/minio-mc/mc-replicate-export
   /reference/minio-mc/mc-replicate-import