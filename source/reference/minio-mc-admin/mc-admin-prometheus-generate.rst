================================
``mc admin prometheus generate``
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin prometheus generate

Description
-----------

.. start-mc-admin-prometheus-generate-desc

The :mc:`mc admin prometheus generate` command generates a metrics scraping configuration file for use with `Prometheus <https://prometheus.io/>`__.

.. end-mc-admin-prometheus-generate-desc

For more complete documentation on using MinIO with Prometheus, see :ref:`How to monitor MinIO server with Prometheus <minio-metrics-collect-using-prometheus>`

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command generates a Prometheus scrape configuration that collects bucket metrics from the deployment at :term:`alias` ``myminio``:

      .. code-block:: shell
         :class: copyable

         mc admin prometheus generate myminio bucket

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin prometheus generate  \
                                           ALIAS     \
                                           [TYPE]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc:`alias <mc alias>` of a configured MinIO deployment for which the command generates a Prometheus-compatible configuration file.

.. mc-cmd:: TYPE
   :optional:

   The type of metrics to scrape.

      .. versionchanged:: RELEASE.2023-10-07T15-07-38Z

         ``resource`` metrics added

      Valid values are:

      - ``bucket``
      - ``cluster``
      - ``node``
      - ``resource``

      If not specified, the command returns cluster metrics.
      Cluster metrics also include node metrics.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Example
-------

Generate a scrape config for bucket metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin prometheus generate` to print bucket metrics for a MinIO deployment:

.. code-block:: shell
   :class: copyable

      mc admin prometheus generate ALIAS bucket

- Replace ``ALIAS`` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

The output resembles the following:

.. code-block:: shell

   scrape_configs:
   - job_name: minio-job-bucket
     bearer_token: [auth token]
     metrics_path: /minio/v2/metrics/bucket
     scheme: http
     static_configs:
     - targets: ['localhost:9000']
