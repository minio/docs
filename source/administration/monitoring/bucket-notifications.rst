.. _minio-bucket-notifications:

====================
Bucket Notifications
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO bucket notifications allow administrators to send notifications to supported external services on certain object or bucket events. 
MinIO supports bucket and object-level S3 events similar to the 
:s3-docs:`Amazon S3 Event Notifications <NotificationHowTo.html>`.

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
     - Publish notifications to an `MQTT <https://www.mqtt.org/>`__ service.

       See :ref:`minio-bucket-notifications-publish-mqtt` for a tutorial.

   * - :guilabel:`NATS`
     - Publish notifications to a `NATS <https://nats.io/>`__ service.

       See :ref:`minio-bucket-notifications-publish-nats` for a tutorial.

   * - :guilabel:`NSQ`
     - Publish notifications to a `NSQ <https://nsq.io/>`__ service.

       See :ref:`minio-bucket-notifications-publish-nsq` for a tutorial

   * - :guilabel:`Elasticsearch`
     - Publish notifications to a `Elasticsearch <https://www.elastic.co/>`__ service.

       See :ref:`minio-bucket-notifications-publish-elasticsearch` for a tutorial.

   * - :guilabel:`Kafka`
     - Publish notifications to a `Kafka <https://kafka.apache.org/>`__ service.

       See :ref:`minio-bucket-notifications-publish-kafka` for a tutorial.

   * - :guilabel:`MySQL`
     - Publish notifications to a `MySQL <https://www.mysql.com/>`__ service.

       See :ref:`minio-bucket-notifications-publish-mysql` for a tutorial.

   * - :guilabel:`PostgreSQL`
     - Publish notifications to a `PostgreSQL <https://www.postgresql.org/>`__ service.

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

MinIO bucket notifications are compatible with :s3-docs:`Amazon S3 Event Notifications <NotificationHowTo.html>`. 
This section lists all supported events.

Object Events
~~~~~~~~~~~~~

MinIO supports triggering notifications on the following S3 object events:

.. data:: s3:ObjectAccessed:Get
.. data:: s3:ObjectAccessed:GetLegalHold
.. data:: s3:ObjectAccessed:GetRetention
.. data:: s3:ObjectAccessed:Head
.. data:: s3:ObjectCreated:CompleteMultipartUpload
.. data:: s3:ObjectCreated:Copy
.. data:: s3:ObjectCreated:DeleteTagging
.. data:: s3:ObjectCreated:Post
.. data:: s3:ObjectCreated:Put
.. data:: s3:ObjectCreated:PutLegalHold
.. data:: s3:ObjectCreated:PutRetention
.. data:: s3:ObjectCreated:PutTagging
.. data:: s3:ObjectRemoved:Delete
.. data:: s3:ObjectRemoved:DeleteMarkerCreated

Specify the wildcard ``*`` character to select all events related to a prefix:

.. data:: s3:ObjectAccessed:*

   Selects all ``s3:ObjectAccessed``\ -prefixed events.
   
.. data:: s3:ObjectCreated:*

   Selects all ``s3:ObjectCreated``\ -prefixed events.

.. data:: s3:ObjectRemoved:*

   Selects all ``s3:ObjectRemoved``\ -prefixed events.

Replication Events
~~~~~~~~~~~~~~~~~~

MinIO supports triggering notifications on the following S3 replication events:

.. data:: s3:Replication:OperationCompletedReplication
.. data:: s3:Replication:OperationFailedReplication
.. data:: s3:Replication:OperationMissedThreshold
.. data:: s3:Replication:OperationNotTracked
.. data:: s3:Replication:OperationReplicatedAfterThreshold

Specify the wildcard ``*`` character to select all ``s3:Replication`` events:

.. data:: s3:Replication:*

ILM Transition Events
~~~~~~~~~~~~~~~~~~~~~

MinIO supports triggering notifications on the following S3 ILM transition events:

.. data:: s3:ObjectRestore:Post
.. data:: s3:ObjectRestore:Completed
.. data:: s3:ObjectTransition:Failed
.. data:: s3:ObjectTransition:Complete

Specify the wildcard ``*`` character to select all events related to a prefix:

.. data:: s3:ObjectTransition:*

   Selects all ``s3:ObjectTransition``\ -prefixed events.

.. data:: s3:ObjectRestore:*

   Selects all ``s3:ObjectRestore``\ -prefixed events.

Global Events
~~~~~~~~~~~~~

MinIO supports triggering notifications on the following global events. 
You can only listen to these events through the `ListenNotification <https://min.io/docs/minio/linux/developers/go/API.html#listennotification-context-context-context-prefix-suffix-string-events-string-chan-notification-info>` API:

.. data:: s3:BucketCreated
.. data:: s3:BucketRemoved

.. todo

.. toctree::
   :titlesonly:
   :hidden:

   /administration/monitoring/publish-events-to-amqp
   /administration/monitoring/publish-events-to-mqtt
   /administration/monitoring/publish-events-to-nats
   /administration/monitoring/publish-events-to-nsq
   /administration/monitoring/publish-events-to-elasticsearch
   /administration/monitoring/publish-events-to-kafka
   /administration/monitoring/publish-events-to-mysql
   /administration/monitoring/publish-events-to-postgresql
   /administration/monitoring/publish-events-to-redis
   /administration/monitoring/publish-events-to-webhook
