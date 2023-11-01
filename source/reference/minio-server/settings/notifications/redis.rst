.. _minio-server-envvar-bucket-notification-redis:
.. _minio-server-config-bucket-notification-redis:

===========================
Redis Notification Settings
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring a Redis service as a target for :ref:`Bucket Notifications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-redis` for a tutorial on using these settings.

Multiple Redis Targets
----------------------

You can specify multiple Redis service endpoints by appending a unique identifier ``_ID`` to the end of the top level key for each set of related Redis settings. 
For example, the following commands set two distinct Redis service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell
         :class: copyable
      
         set MINIO_NOTIFY_REDIS_ENABLE_PRIMARY="on"
         set MINIO_NOTIFY_REDIS_REDIS_ADDRESS_PRIMARY="https://user:password@redis-endpoint.example.net:9200"
         set MINIO_NOTIFY_REDIS_KEY_PRIMARY="bucketevents"
         set MINIO_NOTIFY_REDIS_FORMAT_PRIMARY="namespace"
      
      
         set MINIO_NOTIFY_REDIS_ENABLE_SECONDARY="on"
         set MINIO_NOTIFY_REDIS_REDIS_ADDRESS_SECONDARY="https://user:password@redis-endpoint2.example.net:9200"
         set MINIO_NOTIFY_REDIS_KEY_SECONDARY="bucketevents"
         set MINIO_NOTIFY_REDIS_FORMAT_SECONDARY="namespace"

   .. tab-item:: Configuration Settings
      :sync: config

      .. code-block:: shell

         mc admin config set notify_redis:primary              \ 
            address="https://redis-endpoint.example.net:9200"  \
            key="bucketevents"                                 \
            format="namespace"                                 \
            [ARGUMENT="VALUE"] ...                             \
   
         mc admin config set notify_redis:secondary            \
            address="https://redis-endpoint2.example.net:9200" \
            key="bucketevents"                                 \
            format="namespace"                                 \
            [ARGUMENT="VALUE"] ... 

Settings
--------

Enable
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_REDIS_ENABLE

      Specify ``on`` to enable publishing bucket notifications to a Redis service endpoint.

      Defaults to ``off``.
   
      Requires specifying the following additional environment variables if set to ``on``:
   
      - :envvar:`MINIO_NOTIFY_REDIS_ADDRESS`
      - :envvar:`MINIO_NOTIFY_REDIS_KEY`
      - :envvar:`MINIO_NOTIFY_REDIS_FORMAT`
   
   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_redis

      The top-level configuration key for defining an Redis server/broker endpoint for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.
   
      Use :mc-cmd:`mc admin config set` to set or update an Redis server/broker endpoint. 
      The following arguments are *required* for each endpoint: 
      
      - :mc-conf:`~notify_redis.address`
      - :mc-conf:`~notify_redis.key`
      - :mc-conf:`~notify_redis.format`
   
      Specify additional optional arguments as a whitespace (``" "``)-delimited list.
   
      .. code-block:: shell
         :class: copyable
   
         mc admin config set notify_redis \ 
            address="ENDPOINT" \
            key="<string>" \
            format="<string>" \
            [ARGUMENT="VALUE"] ... \

Address
~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_REDIS_ADDRESS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_redis address
         :delimiter: " "

Specify the Redis service endpoint to which MinIO publishes bucket events.
For example, ``https://redis.example.com:6369``.

.. include:: /includes/linux/minio-server.rst
   :start-after: start-notify-target-online-desc
   :end-before: end-notify-target-online-desc

Key
~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_REDIS_KEY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_redis key
         :delimiter: " "

Specify the Redis key to use for storing and updating events. 
Redis auto-creates the key if it does not exist.

Format
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_REDIS_FORMAT

   .. tab-item:: Configuration Setting
      :sync: config
      
      .. mc-conf:: notify_redis format
         :delimiter: " "

Specify the format of event data written to the Redis service endpoint. 
MinIO supports the following values:

``namespace``
   For each bucket event, MinIO creates a JSON document with the bucket and object name from the event as the document ID and the actual event as part of the document body. 
   Additional updates to that object modify the existing index entry for that object. 
   Similarly, deleting the object also deletes the corresponding index entry.
   
``access``
   For each bucket event, MinIO creates a JSON document with the event details and appends it to the key with a Redis-generated random ID. 
   Additional updates to an object result in new index entries,    and existing entries remain unmodified.

Password
~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_REDIS_PASSWORD

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_redis password
         :delimiter: " "

Specify the password for the Redis server.

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

Queue Directory
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_REDIS_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_redis queue_dir
         :delimiter: " "

Specify the directory path to enable MinIO's persistent event store for undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the Redis server/broker is offline and replays the stored events when connectivity resumes.

Queue Limit
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_REDIS_QUEUE_LIMIT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_redis queue_limit
         :delimiter: " "

Specify the maximum limit for undelivered messages. 
Defaults to ``100000``.

Comment
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_REDIS_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_redis comment
         :delimiter: " "

Specify a comment to associate with the Redis configuration.