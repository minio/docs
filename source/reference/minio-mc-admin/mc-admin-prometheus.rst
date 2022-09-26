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

The :mc-cmd:`mc admin prometheus` command generates a configuration file for
use with `Prometheus <https://prometheus.io/>`__.

.. end-mc-admin-prometheus-desc

For more complete documentation on using MinIO with Prometheus, see :ref:`How to monitor MinIO server with Prometheus 
<minio-metrics-collect-using-prometheus>`

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Syntax
------

.. mc-cmd:: generate
   :fullpath:

   Generates a JWT bearer token for use with configuring 
   :ref:`Prometheus metrics collection <minio-metrics-and-alerts>`. The command
   has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin prometheus generate TARGET

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc:`alias <mc alias>` of a configured MinIO deployment for which
      the command generates a Prometheus-compatible configuration file.

