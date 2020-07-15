.. _minio-bucket:

=======
Buckets
=======

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2


A :ref:`bucket <minio-bucket>` is a folder or storage container that can hold an
arbitrary number of :ref:`objects <minio-object>`. Minio buckets provide the
same functionality as an Amazon Web Services (AWS) S3 Bucket. The MinIO API is
fully compatible with the Amazon S3 API, where applications can seamlessly
transition to using the MinIO deployment with minimal code changes.

Bucket Notifications
--------------------

MinIO Bucket Notifications allow you to automatically publish notifications
to one or more configured endpoints when specific events occur in a bucket.

See :doc:`/minio-features/bucket-notifications` for more information.

Push Notifications
~~~~~~~~~~~~~~~~~~

MinIO supports pushing events to the following targets:

- AMQP
- MQTT
- Elasticsearch
- NSQ
- Redis
- NATS
- PostgreSQL
- MySQL
- Apache Kafka
- Webhooks

Use the ``mc admin`` utility to configure the MinIO deployment to actively
push notifications to each configured target. For more complete documentation, 
see <logging tbd>

Listener API
~~~~~~~~~~~~

MinIO provides two routes to listen for events for a given bucket:

- The ``mc event`` command.
- The ``BucketNotification`` API.

.. todo: Add more information here as its available. 

Write Once Read Many (WORM)
---------------------------

MinIO supports enabling Write-Once Read-Many (WORM) for specific objects
in a bucket *or* for all objects in the bucket. Objects with WORM applied
are immutable, and can only be deleted if the WORM configuration includes an
expiry. 

Configure WORM for Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~

ToDo: Enable, Disable WORM

Configure WORM for Specific Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ToDo: Enable, Disable WORM per object

