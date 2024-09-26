====================
``mc admin scanner``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin scanner


Description
-----------

.. start-mc-admin-scanner-desc

The :mc:`mc admin scanner` commands provide information about the :ref:`scanner <minio-concepts-scanner>` process. 

.. end-mc-admin-scanner-desc

Subcommands
-----------

:mc:`mc admin scanner` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc admin scanner status`
     - .. include:: /reference/minio-mc-admin/mc-admin-scanner-status.rst
          :start-after: start-mc-admin-scanner-status-desc
          :end-before: end-mc-admin-scanner-status-desc

   * - :mc:`~mc admin scanner trace`
     - .. include:: /reference/minio-mc-admin/mc-admin-scanner-trace.rst
          :start-after: start-mc-admin-scanner-trace-desc
          :end-before: end-mc-admin-scanner-trace-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc-admin/mc-admin-scanner-status
   /reference/minio-mc-admin/mc-admin-scanner-trace
