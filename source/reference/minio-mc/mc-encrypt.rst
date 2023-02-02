==============
``mc encrypt``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc encrypt


Description
-----------

.. start-mc-encrypt-desc

The :mc:`mc encrypt` commands set, update, or disable the default bucket Server-Side Encryption (SSE) mode. 
MinIO automatically encrypts objects using the specified SSE mode.

.. end-mc-encrypt-desc

Subcommands
-----------

:mc:`mc encrypt` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc encrypt clear`
     - .. include:: /reference/minio-mc/mc-encrypt-clear.rst
          :start-after: start-mc-encrypt-clear-desc
          :end-before: end-mc-encrypt-clear-desc

   * - :mc:`~mc encrypt info`
     - .. include:: /reference/minio-mc/mc-encrypt-info.rst
          :start-after: start-mc-encrypt-info-desc
          :end-before: end-mc-encrypt-info-desc

   * - :mc:`~mc encrypt set`
     - .. include:: /reference/minio-mc/mc-encrypt-set.rst
          :start-after: start-mc-encrypt-set-desc
          :end-before: end-mc-encrypt-set-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-encrypt-clear
   /reference/minio-mc/mc-encrypt-info
   /reference/minio-mc/mc-encrypt-set
