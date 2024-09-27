.. _minio-metrics-and-alerts-endpoints:
.. _minio-metrics-and-alerts-alerting:
.. _minio-metrics-and-alerts:

==================
Metrics and Alerts
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. versionadded:: RELEASE.2024-07-15T19-02-30Z

   Metrics version 3 (v3) provides additional metrics and metric types for more targeted scraping.
	   
MinIO publishes metrics using the :prometheus-docs:`Prometheus Data Model <concepts/data_model/>`.
You can use any scraping tool to pull metrics data from MinIO for further analysis and alerting.

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


.. _minio-metrics-and-alerts-available-metrics:

v3 metrics

v2 metrics

.. toctree::
   :titlesonly:
   :hidden:

   /operations/monitoring/metrics-v3
   /operations/monitoring/metrics-v2
   /operations/monitoring/collect-minio-metrics-using-prometheus
   /operations/monitoring/monitor-and-alert-using-influxdb
