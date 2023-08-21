=====================
Monitoring and Alerts
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. container:: extlinks-video

   - `Monitoring with MinIO and Prometheus: Overview <https://youtu.be/A3vCDaFWNNs?ref=docs>`__
   - `Monitoring with MinIO and Prometheus: Lab <https://youtu.be/Oix9iXndSUY?ref=docs>`__

Metrics and Alerts
------------------

MinIO provides point-in-time metrics on cluster status and operations.
The :ref:`MinIO Console <minio-console-metrics>` provides a graphical display of these metrics.

For historical metrics and analytics, MinIO publishes cluster and node metrics using the :prometheus-docs:`Prometheus Data Model <data_model/>`.
You can use any scraping tool which supports that data model to pull metrics data from MinIO for further analysis and alerting.

The following table lists tutorials for integrating MinIO metrics with select third-party monitoring software.

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - :ref:`minio-metrics-collect-using-prometheus`
     - Configure Prometheus to Monitor and Alert for a MinIO deployment

       Configure MinIO to query the Prometheus deployment to enable historical metrics via the MinIO Console

   * - :ref:`minio-metrics-influxdb`
     - Configure InfluxDB to Monitor and Alert for a MinIO deployment.

Other metrics and analytics software suites which support the Prometheus data model may work regardless of their inclusion on the above list.

Logging
-------

MinIO publishes all :mc:`minio server` operations to the system console. 
MinIO also supports publishing server logs and audit logs to an HTTP webhook.

- :ref:`Server logs <minio-logging-publish-server-logs>` contain the same :mc:`minio server` operations logged to the system console. 
  Server logs support general monitoring and troubleshooting of operations.

- :ref:`Audit logs <minio-logging-publish-audit-logs>` are more granular descriptions of each operation on the MinIO deployment. 
  Audit logging supports security standards and regulations which require detailed tracking of operations.

MinIO publishes logs as a JSON document as a ``PUT`` request to each configured endpoint. 
The endpoint server is responsible for processing each JSON document.
MinIO requires explicit configuration of each webhook endpoint and does *not* publish logs to a webhook by default.

See :ref:`minio-logging` for more complete documentation.

Healthchecks
------------

MinIO exposes unauthenticated endpoints for probing node uptime and  cluster :ref:`high availability <minio-ec-parity>` for simple healthchecks.
These endpoints return only an HTTP status code. 
See :ref:`minio-healthcheck-api` for more information.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/monitoring/metrics-and-alerts
   /operations/monitoring/minio-logging
   /operations/monitoring/healthcheck-probe
   /operations/monitoring/grafana