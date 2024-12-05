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

Starting with MinIO Server :minio-release:`RELEASE.2024-07-15T19-02-30Z` and MinIO Client :mc-release:`RELEASE.2024-07-11T18-01-28Z`, :ref:`metrics version 3 (v3) <minio-metrics-and-alerts>` provides additional endpoints and metrics.
To generate a v3 scrape configuration use the ``--api_version v3`` option.

MinIO recommends new deployments use :ref:`version 3 (v3) <minio-metrics-and-alerts>`.
Existing deployments can continue to use :ref:`metrics version 2 <minio-metrics-v2>`

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command generates a Prometheus scrape configuration that collects version 2 bucket metrics from the deployment at :term:`alias` ``myminio``:

      .. code-block:: shell
         :class: copyable

         mc admin prometheus generate myminio bucket

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin prometheus generate                                        \
                                           ALIAS                                           \
                                           [TYPE]                                          \
                                           [--api_version v3]                              \
                                           [--bucket <bucket name>]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc:`alias <mc alias>` of a configured MinIO deployment for which the command generates a Prometheus-compatible configuration file.

.. mc-cmd:: --api-version
   :optional:

   To generate a scrape configuration for :ref:`v3 metrics <minio-metrics-and-alerts>`, include  an ``--api-version v3`` parameter.
   ``v3`` is the only accepted value.

   Omit ``--api-version`` to generate a :ref:`v2 metrics <minio-metrics-v2>` configuration.

.. mc-cmd:: --bucket
   :optional:

   Only valid for v3 metrics.

   For v3 metric types that return bucket-level metrics, specify a bucket name.
   Requires :mc-cmd:`~mc admin prometheus generate --api-version`.

   ``--bucket`` works for the following v3 metric types:

   - ``api``
   - ``replication``

   The following example generates a configuration for API metrics from the bucket ``mybucket``:

   .. code-block:: shell
      :class: copyable

      mc admin prometheus generate ALIAS api --bucket mybucket --api-version v3

.. mc-cmd:: TYPE
   :optional:

   The type of metrics to scrape.

      Valid values for metrics version 3 are:

      - ``api``
      - ``audit``
      - ``cluster``
      - ``debug``
      - ``ilm``
      - ``logger``
      - ``notification``
      - ``replication``
      - ``scanner``
      - ``system``

      If not specified, a ``v3`` command returns all metrics.

      Valid values for metrics version 2 are:

      - ``bucket``
      - ``cluster``
      - ``node``
      - ``resource``

      If not specified, a ``v2`` command returns cluster metrics.
      Cluster metrics include rollups of certain node metrics.


Global flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Examples
--------

Generate a default metrics v3 config
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin prometheus generate --api-version v3 <mc admin prometheus generate --api-version>` to generate a scrape configuration that collects all v3 metrics for a MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin prometheus generate ALIAS --api-version v3

- Replace ``ALIAS`` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

The output resembles the following:

.. code-block:: shell

   scrape_configs:
   - job_name: minio-job
     bearer_token: [auth token]
     metrics_path: /minio/metrics/v3
     scheme: http
     static_configs:
     - targets: ['localhost:9000']


Generate a v3 metrics config for another type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To generate a configuration for another metric type, specify the type.
The following generates a scrape configuration for v3 cluster metrics:

.. code-block:: shell
   :class: copyable

   mc admin prometheus generate ALIAS cluster --api-version v3

- Replace ``ALIAS`` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

The output resembles the following:

.. code-block:: shell

   scrape_configs:
   - job_name: minio-job-cluster
     bearer_token: [auth token]
     metrics_path: /minio/metrics/v3/cluster
     scheme: http
     static_configs:
     - targets: ['localhost:9000']

To generate a configuration for a :mc-cmd:`different metric type <mc admin prometheus generate TYPE>`, replace ``cluster`` with the desired type.


Generate a v3 bucket replication metrics config
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example generates a scrape configuration for v3 replication metrics of bucket ``mybucket``:

.. code-block:: shell
   :class: copyable

   mc admin prometheus generate ALIAS replication --bucket mybucket --api-version v3

- Replace ``ALIAS`` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

The output resembles the following:

.. code-block:: shell

   scrape_configs:
   - job_name: minio-job-replication
     bearer_token: [auth token]
     metrics_path: /minio/metrics/v3/bucket/replication/mybucket
     scheme: https
     static_configs:
     - targets: [`localhost:9000`]

Generate a v3 config for bucket API metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example generates a scrape configuration for v3 API metrics for bucket ``mybucket``:

.. code-block:: shell
   :class: copyable

   mc admin prometheus generate ALIAS api --bucket mybucket --api-version v3

- Replace ``ALIAS`` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

The output resembles the following:

.. code-block:: shell

   scrape_configs:
   - job_name: minio-job-api
     bearer_token: [auth token]
     metrics_path: /minio/metrics/v3/bucket/api/mybucket
     scheme: https
     static_configs:
     - targets: [`localhost:9000`]


Generate a default metrics v2 config
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By default, :mc-cmd:`mc admin prometheus generate` generates a scrape configuration for v2 cluster metrics:

.. code-block:: shell
   :class: copyable

   mc admin prometheus generate ALIAS

- Replace ``ALIAS`` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

The output resembles the following:

.. code-block:: shell

   scrape_configs:
   - job_name: minio-job
     bearer_token: [auth token]
     metrics_path: /minio/v2/metrics
     scheme: http
     static_configs:
     - targets: ['localhost:9000']


Generate a v2 config for other metric types
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To generate a configuration for another metric type, specify the type.
The following generates a scrape configuration for v2 bucket metrics:

.. code-block:: shell
   :class: copyable

   mc admin prometheus generate ALIAS bucket

