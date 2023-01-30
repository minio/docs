============
``mc share``
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc share


Description
-----------

.. start-mc-share-desc

Use the :mc:`mc share` commands to manage presigned URLs for downloading and uploading objects to a MinIO bucket.

.. end-mc-share-desc

Subcommands
-----------

:mc:`mc share` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc share download`
     - .. include:: /reference/minio-mc/mc-share-download.rst
          :start-after: start-mc-share-download-desc
          :end-before: end-mc-share-download-desc

   * - :mc:`~mc share list`
     - .. include:: /reference/minio-mc/mc-share-list.rst
          :start-after: start-mc-share-list-desc
          :end-before: end-mc-share-list-desc

   * - :mc:`~mc share upload`
     - .. include:: /reference/minio-mc/mc-share-upload.rst
          :start-after: start-mc-share-upload-desc
          :end-before: end-mc-share-upload-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-share-download
   /reference/minio-mc/mc-share-upload
   /reference/minio-mc/mc-share-list