=====================
Prometheus Monitoring
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Metrics and Alerts
------------------

MinIO leverages `Prometheus <https://prometheus.io/>`__ for metrics and alerts.
Prometheus is an Open-Source systems and service monitoring system which
supports analyzing and alerting based on collected metrics. The Prometheus
ecosystem includes multiple :prometheus-docs:`integrations
<operating/integrations/>`, allowing wide latitude in processing and storing
collected metrics.

- MinIO publishes Prometheus-compatible scraping endpoints for cluster and
  node-level metrics. See :ref:`minio-metrics-and-alerts-endpoints` for
  more information.

- For alerts, use Prometheus :prometheus-docs:`Alerting Rules
  <prometheus/latest/configuration/alerting_rules/>` and the
  :prometheus-docs:`Alert Manager <alerting/latest/overview/>` to
  trigger alerts based on collected metrics. See
  :ref:`minio-metrics-and-alerts-alerting` for more information.

MinIO publishes collected metrics data using Prometheus-compatible data
structures. Any Prometheus-compatible scraping software can ingest and
process MinIO metrics for analysis, visualization, and alerting.

Logging
-------

MinIO publishes all :mc:`minio server` operations to the system console. 
MinIO also supports publishing server logs and audit logs to an HTTP webhook.

- :ref:`Server logs <minio-logging-publish-server-logs>` contain the same
  :mc:`minio server` operations logged to the system console. Server logs
  support general monitoring and troubleshooting of operations.

- :ref:`Audit logs <minio-logging-publish-audit-logs>` are more granular
  descriptions of each operation on the MinIO deployment. Audit logging 
  supports security standards and regulations which require detailed tracking
  of operations.

MinIO publishes logs as a JSON document as a ``PUT`` request to each configured
endpoint. The endpoint server is responsible for processing each JSON document.
MinIO requires explicit configuration of each webhook endpoint and does *not*
publish logs to a webhook by default.

See :ref:`minio-logging` for more complete documentation.

Healthchecks
------------

MinIO exposes unauthenticated endpoints for probing node uptime and 
cluster :ref:`high availability <minio-ec-parity>` for simple healthchecks.
These endpoints return only an HTTP status code. See 
:ref:`minio-healthcheck-api` for more information.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/monitoring/collect-minio-metrics-using-prometheus
   /operations/monitoring/minio-logging
   /operations/monitoring/healthcheck-probe