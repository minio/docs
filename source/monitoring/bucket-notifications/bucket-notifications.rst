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

   * - :guilabel:`AMQP`
     - Publish notifications to an AMQP service such as 
       `RabbitMQ <https://www.rabbitmq.com>`__.

       See :ref:`minio-bucket-notifications-publish-amqp` for a tutorial.

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