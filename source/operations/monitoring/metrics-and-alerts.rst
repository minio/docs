.. _minio-metrics-and-alerts-endpoints:
.. _minio-metrics-and-alerts-alerting:
.. _minio-metrics-and-alerts:

==================
Metrics and alerts
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


MinIO publishes metrics using the :prometheus-docs:`Prometheus Data Model <concepts/data_model/>`.
You can use any scraping tool to pull metrics data from MinIO for further analysis and alerting.

Starting with MinIO Server :minio-release:`RELEASE.2024-07-15T19-02-30Z` and MinIO Client :mc-release:`RELEASE.2024-07-11T18-01-28Z`, metrics version 3 provides additional endpoints.
MinIO recommends version 3 for new deployments.

.. admonition:: Metrics version 2
   :class: note

   Existing deployments can continue to use version 2 :ref:`metrics <minio-metrics-v2>` and :ref:`Grafana dashboards <minio-grafana>`.


Version 3 Endpoints
-------------------

For metrics version 3, all metrics are available under the base ``/minio/metrics/v3`` endpoint.
You can scrape the base endpoint to collect all metrics in a single operation, or append an optional path to return a specific category.

.. important:: 

   The V3 metrics on this page may have gaps, inaccuracies, or incorrect information.
   Reference the `minio/minio <https://github.com/minio/minio>`_ repository and review the source code for the most accurate representation of metrics as available.

For example, the following endpoint returns audit metrics:

.. code-block:: shell
   :class: copyable

   http://HOSTNAME:PORT/minio/metrics/v3/audit

Replace ``HOSTNAME:PORT`` with the :abbr:`FQDN (Fully Qualified Domain Name)` and port of the MinIO deployment.
For deployments with a load balancer managing connections between MinIO nodes, specify the address of the load balancer.

By default, MinIO requires authentication to scrape the metrics endpoints.
To generate the needed bearer tokens, use :mc:`mc admin prometheus generate`.
You can also disable metrics endpoint authentication by setting :envvar:`MINIO_PROMETHEUS_AUTH_TYPE` to ``public``.

MinIO provides the following scraping endpoints, relative to the base URL:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Category
     - Path

   * - API
     - ``/api/requests``
       
       ``/bucket/api``

   * - Audit
     - ``/audit``

   * - Cluster
     - ``/cluster/config``
       
       ``/cluster/erasure-set``
       
       ``/cluster/health``
       
       ``/cluster/iam``
       
       ``/cluster/usage/buckets``
       
       ``/cluster/usage/objects``

   * - Debug
     - ``/debug/go``

   * - ILM
     - ``/ilm``

   * - Logger webhook
     - ``/logger/webhook``

   * - Notification
     - ``/notification``

   * - Replication
     - ``/replication``
       
       ``/bucket/replication``

   * - Scanner
     - ``/scanner``

   * - System
     - ``/system/drive``
       
       ``/system/memory``
       
       ``/system/cpu``
       
       ``/system/network/internode``
       
       ``/system/process``

For a complete list of metrics for each endpoint, see :ref:`Available version 3 metrics <minio-metrics-and-alerts-available-metrics>`.

   
To enable historical data visualization in MinIO Console, set the following environment variables on each node in the MinIO deployment:

- Set :envvar:`MINIO_PROMETHEUS_URL` to the URL of the Prometheus service
- Set :envvar:`MINIO_PROMETHEUS_JOB_ID` to the unique job ID assigned to the collected metrics

.. _minio-metrics-and-alerts-available-metrics:

Available version 3 metrics
---------------------------

MinIO publishes a number of metrics for clusters, API requests, buckets, and other aspects of the MinIO service:

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

Many metrics include labels identifying the resource which generated that metric and other relevant details.

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
   /operations/monitoring/metrics-v2
