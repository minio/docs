.. _minio-bucket-notifications:

====================
Bucket Notifications
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO bucket notifications allow administrators to send notifications to 
supported external services on certain object or bucket events. MinIO 
supports bucket and object-level S3 events similar to the 
:s3-docs:`Amazon S3 Event Notifications <NotificationHowTo.html>`.

MinIO bucket notifications are available *only* with 
:mc:`minio server` deployments. MinIO :ref:`Gateway <minio-gateway>`
does *not* support bucket notifications.

Supported Notification Targets
------------------------------

MinIO supports publishing event notifications to the following targets:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Target
     - Description

   * - :guilabel:`AMQP` (RabbitMQ)
     - Publish notifications to an AMQP service such as 
       `RabbitMQ <https://www.rabbitmq.com>`__.

       See :ref:`minio-bucket-notifications-publish-amqp` for a tutorial.

   * - :guilabel:`MQTT`
     - Publish notifications to an `MQTT <https://www.mqtt.org/>`__  
       service.

       See :ref:`minio-bucket-notifications-publish-mqtt` for a tutorial.

   * - :guilabel:`NATS`
     - Publish notifications to a `NATS <https://nats.io/>`__ service.

       See :ref:`minio-bucket-notifications-publish-nats` for a tutorial.

   * - :guilabel:`NSQ`
     - Publish notifications to a `NSQ <https://nsq.io/>`__ service.

       See :ref:`minio-bucket-notifications-publish-nsq` for a tutorial


   * - :guilabel:`Elasticsearch`
     - Publish notifications to a `Elasticsearch <https://www.elastic.co/>`__ 
       service.

       See :ref:`minio-bucket-notifications-publish-elasticsearch` for a
       tutorial.

   * - :guilabel:`Kafka`
     - Publish notifications to a `Kafka <https://kafka.apache.org/>`__ service.

       See :ref:`minio-bucket-notifications-publish-kafka` for a tutorial.

   * - :guilabel:`MySQL`
     - Publish notifications to a `MySQL <https://www.mysql.com/>`__ service.

       See :ref:`minio-bucket-notifications-publish-mysql` for a tutorial.

   * - :guilabel:`PostgreSQL`
     - Publish notifications to a `PostgreSQL <https://www.postgresql.org/>`__
       service.

       See :ref:`minio-bucket-notifications-publish-postgresql` for a tutorial.

   * - :guilabel:`Redis`
     - Publish notifications to a `Redis <https://redis.io/>`__ service.

       See :ref:`minio-bucket-notifications-publish-redis` for a tutorial.

   * - :guilabel:`webhook`
     - Publish notifications to a `Webhook
       <https://en.wikipedia.org/wiki/Webhook>`__ service.

       See :ref:`minio-bucket-notifications-publish-webhook` for a tutorial.


.. _minio-bucket-notifications-event-types:

Supported S3 Event Types
------------------------

MinIO bucket notifications are compatible with 
:s3-docs:`Amazon S3 Event Notifications <NotificationHowTo.html>`. This 
section lists all supported events.

Object Events
~~~~~~~~~~~~~

MinIO supports triggering notifications on the following S3 object events:

.. data:: s3:ObjectRemoved:DeleteMarkerCreated
.. data:: s3:ObjectRemoved:Delete
.. data:: s3:ObjectCreated:PutRetention
.. data:: s3:ObjectCreated:PutLegalHold
.. data:: s3:ObjectCreated:Put
.. data:: s3:ObjectCreated:Post
.. data:: s3:ObjectCreated:Copy
.. data:: s3:ObjectCreated:CompleteMultipartUpload
.. data:: s3:ObjectAccessed:Head
.. data:: s3:ObjectAccessed:GetRetention
.. data:: s3:ObjectAccessed:GetLegalHold
.. data:: s3:ObjectAccessed:Get

Replication Events
~~~~~~~~~~~~~~~~~~

MinIO supports triggering notifications on the following S3 replication 
events:

.. data:: s3:Replication:OperationCompletedReplication
.. data:: s3:Replication:OperationFailedReplication
.. data:: s3:Replication:OperationMissedThreshold
.. data:: s3:Replication:OperationNotTracked
.. data:: s3:Replication:OperationReplicatedAfterThreshold

ILM Transition Events
~~~~~~~~~~~~~~~~~~~~~

MinIO supports triggering notifications on the following S3 ILM transition
events:

.. data:: s3:ObjectRestore:Post
.. data:: s3:ObjectRestore:Completed

Global Events
~~~~~~~~~~~~~

MinIO supports triggering notifications on the following global events. 
You can only listen to these events through the :legacy:`ListenNotification 
<golang-client-api-reference.html#ListenNotification>` API:

.. data:: s3:BucketCreated
.. data:: s3:BucketRemoved


.. todo

.. toctree::
   :titlesonly:
   :hidden:

   /monitoring/bucket-notifications/publish-events-to-amqp
   /monitoring/bucket-notifications/publish-events-to-mqtt
   /monitoring/bucket-notifications/publish-events-to-nats
   /monitoring/bucket-notifications/publish-events-to-nsq
   /monitoring/bucket-notifications/publish-events-to-elasticsearch
   /monitoring/bucket-notifications/publish-events-to-kafka
   /monitoring/bucket-notifications/publish-events-to-mysql
   /monitoring/bucket-notifications/publish-events-to-postgresql
   /monitoring/bucket-notifications/publish-events-to-redis
   /monitoring/bucket-notifications/publish-events-to-webhook
