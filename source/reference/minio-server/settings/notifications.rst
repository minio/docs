.. _minio-server-envvar-notifications:

=============================
Bucket Notifications Settings
=============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page covers settings that control behavior related to :ref:`MinIO bucket notifications <minio-bucket-notifications>`. 

.. _minio-server-config-logging-logs:

Sync Events
-----------

*Optional*

.. tab-set::

   .. tab-item::Environment Variable
      :sync: envvar

      .. envvar:: MINIO_API_SYNC_EVENTS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: sync_events         

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-api-sync-events
   :end-before: end-minio-api-sync-events

Supported Notification Targets
------------------------------

Notifications require a target to receive the events.
MinIO supports a variety of possible targets.
Settings for each target type have their own pages.
Select the appropriate link below for the type of target you use for notifications.

- :ref:`minio-server-envvar-bucket-notification-amqp`
- :ref:`minio-server-envvar-bucket-notification-elasticsearch`
- :ref:`minio-server-envvar-bucket-notification-kafka`
- :ref:`minio-server-envvar-bucket-notification-mqtt`
- :ref:`minio-server-envvar-bucket-notification-mysql`
- :ref:`minio-server-envvar-bucket-notification-nats`
- :ref:`minio-server-envvar-bucket-notification-nsq`
- :ref:`minio-server-envvar-bucket-notification-postgresql`
- :ref:`minio-server-envvar-bucket-notification-redis`
- :ref:`minio-server-envvar-bucket-notification-webhook`

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-server/settings/notifications/amqp
   /reference/minio-server/settings/notifications/elasticsearch
   /reference/minio-server/settings/notifications/kafka
   /reference/minio-server/settings/notifications/mqtt
   /reference/minio-server/settings/notifications/mysql
   /reference/minio-server/settings/notifications/nats
   /reference/minio-server/settings/notifications/nsq
   /reference/minio-server/settings/notifications/postgresql
   /reference/minio-server/settings/notifications/redis
   /reference/minio-server/settings/notifications/webhook-service
   