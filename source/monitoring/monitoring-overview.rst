==========
Monitoring
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Metrics and Alerts
------------------

MinIO provides cluster and node-level metrics through `Prometheus
<https://prometheus.io/>`__-compatible scraping endpoints. Prometheus is an
Open-Source systems and service monitoring system which supports analyzing and
alerting based on collected metrics. The Prometheus ecosystem includes multiple
:prometheus-docs:`integrations <operating/integrations/>`, allowing wide
latitude in processing and storing collected metrics. You can alternatively use
any other Prometheus-compatible metrics scraping software.

- See :ref:`minio-metrics-and-alerts` for more complete documentation on 
  MinIO Metrics and Alerts.

- See :ref:`minio-metrics-collect-using-prometheus` for a tutorial on 
  configuring Prometheus for monitoring a MinIO deployment. 

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

Bucket Notifications
--------------------

MinIO supports publishing bucket or object events to the following supported 
targets on certain supported events. 

- :ref:`minio-bucket-notifications-publish-amqp`
- :ref:`minio-bucket-notifications-publish-mqtt`
- :ref:`minio-bucket-notifications-publish-nats`
- :ref:`minio-bucket-notifications-publish-nsq`
- :ref:`minio-bucket-notifications-publish-elasticsearch`
- :ref:`minio-bucket-notifications-publish-kafka`
- :ref:`minio-bucket-notifications-publish-mysql`
- :ref:`minio-bucket-notifications-publish-postgresql`
- :ref:`minio-bucket-notifications-publish-redis`
- :ref:`minio-bucket-notifications-publish-webhook` 

See :ref:`minio-bucket-notifications`
for more complete documentation on MinIO Bucket Notifications.


.. toctree::
   :titlesonly:
   :hidden:

   /monitoring/metrics-alerts/minio-metrics-and-alerts
   /monitoring/logging/minio-logging
   /monitoring/healthcheck-probe
   /monitoring/bucket-notifications/bucket-notifications