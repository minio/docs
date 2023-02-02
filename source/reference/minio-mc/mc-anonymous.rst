================
``mc anonymous``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc anonymous


Description
-----------

.. start-mc-anonymous-desc

The :mc:`mc anonymous` command supports setting or removing anonymous :ref:`policies <minio-policy>` to a bucket and its contents. 
Buckets with anonymous policies allow public access where clients can perform any action granted by the policy without :ref:`authentication <minio-authentication-and-identity-management>`.

.. end-mc-anonymous-desc

Subcommands
-----------

:mc-cmd:`mc anonymous` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc anonymous get`
     - .. include:: /reference/minio-mc/mc-anonymous-get.rst
          :start-after: start-mc-anonymous-get-desc
          :end-before: end-mc-anonymous-get-desc

   * - :mc:`~mc anonymous get-json`
     - .. include:: /reference/minio-mc/mc-anonymous-get-json.rst
          :start-after: start-mc-anonymous-get-json-desc
          :end-before: end-mc-anonymous-get-json-desc

   * - :mc:`~mc anonymous links`
     - .. include:: /reference/minio-mc/mc-anonymous-links.rst
          :start-after: start-mc-anonymous-links-desc
          :end-before: end-mc-anonymous-links-desc

   * - :mc:`~mc anonymous list`
     - .. include:: /reference/minio-mc/mc-anonymous-list.rst
          :start-after: start-mc-anonymous-list-desc
          :end-before: end-mc-anonymous-list-desc

   * - :mc:`~mc anonymous set`
     - .. include:: /reference/minio-mc/mc-anonymous-set.rst
          :start-after: start-mc-anonymous-set-desc
          :end-before: end-mc-anonymous-set-desc

   * - :mc:`~mc anonymous set-json`
     - .. include:: /reference/minio-mc/mc-anonymous-set-json.rst
          :start-after: start-mc-anonymous-set-json-desc
          :end-before: end-mc-anonymous-set-json-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-anonymous-set
   /reference/minio-mc/mc-anonymous-get
   /reference/minio-mc/mc-anonymous-list
   /reference/minio-mc/mc-anonymous-links
   /reference/minio-mc/mc-anonymous-get-json
   /reference/minio-mc/mc-anonymous-set-json
