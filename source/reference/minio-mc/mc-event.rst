============
``mc event``
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc event


Description
-----------

.. start-mc-event-desc

The :mc:`mc event` command supports adding, removing, and listing bucket event notifications.

.. end-mc-event-desc

MinIO automatically sends triggered events to the configured notification targets. 
MinIO supports notification targets like AMQP (RabbitMQ), Redis, ElasticSearch, NATS and PostgreSQL. 
See :ref:`MinIO Bucket Notifications <minio-bucket-notifications>` for more information.


Subcommands
-----------

:mc:`mc event` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc event add`
     - .. include:: /reference/minio-mc/mc-event-add.rst
          :start-after: start-mc-event-add-desc
          :end-before: end-mc-event-add-desc

   * - :mc:`~mc event list`
     - .. include:: /reference/minio-mc/mc-event-list.rst
          :start-after: start-mc-event-list-desc
          :end-before: end-mc-event-list-desc

   * - :mc:`~mc event remove`
     - .. include:: /reference/minio-mc/mc-event-remove.rst
          :start-after: start-mc-event-remove-desc
          :end-before: end-mc-event-remove-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-event-add
   /reference/minio-mc/mc-event-list
   /reference/minio-mc/mc-event-remove
