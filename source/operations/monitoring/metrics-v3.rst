.. _minio-metrics-v3:

=================
Metrics version 3
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

For metrics version 3, all metrics are available under the base ``/minio/metrics/v3`` endpoint, optionally appending an additional path for each category.

For example, the following endpoint returns audit metrics:

.. code-block:: shell
   :class: copyable

   http://HOSTNAME:PORT/minio/metrics/v3/audit

Replace ``HOSTNAME:PORT`` with the :abbr:`FQDN (Fully Qualified Domain Name)` and port of the MinIO deployment.
For deployments with a load balancer managing connections between MinIO nodes, specify the address of the load balancer.

By default, MinIO requires authentication to scrape the metrics endpoints.
To generate the needed bearer tokens, use :mc:`mc admin prometheus generate`.
You can also disable metrics endpoint authentication by setting :envvar:`MINIO_PROMETHEUS_AUTH_TYPE` to ``public``.

MinIO provides the following v3 types and scraping endpoints, relative to the base URL:

.. list-table::
   :header-rows: 1
   :widths: 25 25 50
   :width: 100%

   * - Category
     - Metric type
     - Path

   * - API
     - ``api``
     - ``/api/requests``

       ``/bucket/api``

   * - Audit
     - ``audit``
     - ``/audit``

   * - Cluster
     - ``cluster``
     - ``/cluster/config``

       ``/cluster/erasure-set``

       ``/cluster/health``

       ``/cluster/iam``

       ``/cluster/usage/buckets``

       ``/cluster/usage/objects``

   * - Debug
     - ``debug``
     - ``/debug/go``

   * - ILM
     - ``ilm``
     - ``/ilm``

   * - Logger webhook
     - ``logger``
     - ``/logger/webhook``

   * - Notification
     - ``notification``
     - ``/notification``

   * - Replication
     - ``replication``
     - ``/replication``

       ``/bucket/replication``

   * - Scanner
     - ``scanner``
     - ``/scanner``

   * - System
     - ``system``
     - ``/system/drive``

       ``/system/memory``

       ``/system/cpu``

       ``/system/network/internode``

       ``/system/process``

For a complete list of metrics for each endpoint, see :ref:`Available Metrics <minio-metrics-and-alerts-available-metrics>`.

You can also access metrics using :mc-cmd:`mc admin prometheus metrics` and the metric type for the desired category.
For more information, see the :mc-cmd:`MinIO Admin Client reference <mc admin prometheus metrics>`.

.. cond:: k8s

   The MinIO Operator supports deploying a per-tenant Prometheus instance configured to support metrics and visualization.

   If you deploy the Tenant with this feature disabled *but* still want the historical metric views, you can instead configure an external Prometheus service to scrape the Tenant metrics.
   Once configured, you can update the Tenant to query that Prometheus service to retrieve metric data:

.. cond:: linux or container or macos or windows

   To enable historical data visualization in MinIO Console, set the following environment variables on each node in the MinIO deployment:

- Set :envvar:`MINIO_PROMETHEUS_URL` to the URL of the Prometheus service
- Set :envvar:`MINIO_PROMETHEUS_JOB_ID` to the unique job ID assigned to the collected metrics

.. _minio-metrics-and-alerts-available-v3-metrics:

Available v3 metrics
--------------------

MinIO publishes a number of metrics at the cluster, node, or bucket levels.
Each metric includes a label for the MinIO server which generated that metric.

- :ref:`API Metrics <minio-available-v3-api-metrics>`
- :ref:`Audit Metrics <minio-available-v3-audit-metrics>`
- :ref:`Cluster Metrics <minio-available-v3-cluster-metrics>`
- :ref:`Debug Metrics <minio-available-v3-debug-metrics>`
- :ref:`ILM Metrics <minio-available-v3-ilm-metrics>`
- :ref:`Logger webhook Metrics <minio-available-v3-logger-webhook-metrics>`
- :ref:`Notification Metrics <minio-available-v3-notification-metrics>`
- :ref:`Replication Metrics <minio-available-v3-replication-metrics>`
- :ref:`Scanner Metrics <minio-available-v3-scanner-metrics>`
- :ref:`System Metrics <minio-available-v3-system-metrics>`


.. _minio-available-v3-api-metrics:

.. include:: /includes/common-metrics-v3-api.md
   :parser: myst_parser.sphinx_

.. _minio-available-v3-audit-metrics:

.. include:: /includes/common-metrics-v3-audit.md
   :parser: myst_parser.sphinx_

.. _minio-available-v3-cluster-metrics:

.. include:: /includes/common-metrics-v3-cluster.md
   :parser: myst_parser.sphinx_

.. _minio-available-v3-debug-metrics:

.. include:: /includes/common-metrics-v3-debug.md
   :parser: myst_parser.sphinx_

.. _minio-available-v3-ilm-metrics:

.. include:: /includes/common-metrics-v3-ilm.md
   :parser: myst_parser.sphinx_

.. _minio-available-v3-logger-webhook-metrics:

.. include:: /includes/common-metrics-v3-logger-webhook.md
   :parser: myst_parser.sphinx_

.. _minio-available-v3-notification-metrics:

.. include:: /includes/common-metrics-v3-notification.md
   :parser: myst_parser.sphinx_

.. _minio-available-v3-replication-metrics:

.. include:: /includes/common-metrics-v3-replication.md
   :parser: myst_parser.sphinx_

.. _minio-available-v3-scanner-metrics:

.. include:: /includes/common-metrics-v3-scanner.md
   :parser: myst_parser.sphinx_

.. _minio-available-v3-system-metrics:

.. include:: /includes/common-metrics-v3-system.md
   :parser: myst_parser.sphinx_


.. toctree::
   :titlesonly:
   :hidden:

   /operations/monitoring/collect-minio-metrics-using-prometheus
   /operations/monitoring/monitor-and-alert-using-influxdb
