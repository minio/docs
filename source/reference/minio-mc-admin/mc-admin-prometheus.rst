=======================
``mc admin prometheus``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin prometheus

Description
-----------

.. start-mc-admin-prometheus-desc

The :mc:`mc admin prometheus` command and its subcommands provide access to MinIO Prometheus metrics.

.. end-mc-admin-prometheus-desc

Subcommands
-----------

:mc:`mc admin prometheus` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc admin prometheus generate`
     - .. include:: /reference/minio-mc-admin/mc-admin-prometheus-generate.rst
          :start-after: start-mc-admin-prometheus-generate-desc
          :end-before: end-mc-admin-prometheus-generate-desc

   * - :mc:`~mc admin prometheus metrics`
     - .. include:: /reference/minio-mc-admin/mc-admin-prometheus-metrics.rst
          :start-after: start-mc-admin-prometheus-metrics-desc
          :end-before: end-mc-admin-prometheus-metrics-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc-admin/mc-admin-prometheus-generate
   /reference/minio-mc-admin/mc-admin-prometheus-metrics
