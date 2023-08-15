===================================
Monitoring Bucket and Object Events
===================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Bucket Notifications
--------------------

MinIO bucket notifications allow administrators to send notifications to supported external services on certain object or bucket events. 
MinIO supports bucket and object-level S3 events similar to the 
:s3-docs:`Amazon S3 Event Notifications <NotificationHowTo.html>`.

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

Deployment Metrics
------------------

MinIO provides a Prometheus-compatible endpoint for supporting time-series querying of metrics.

MinIO deployments :ref:`configured to enable Prometheus scraping <minio-metrics-and-alerts>` provide a detailed metrics view through the MinIO Console.

Server Logs
-----------

MinIO provides the following interfaces for remotely reading server logs:

- The :mc:`mc admin console` command returns the specified server's console output.
- MinIO supports pushing server logs to an HTTP webhook for further ingestion. 
  See :ref:`minio-logging-publish-server-logs` for more information.

.. toctree::
   :titlesonly:
   :hidden:

   /administration/monitoring/bucket-notifications