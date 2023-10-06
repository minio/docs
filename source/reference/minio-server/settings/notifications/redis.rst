.. _minio-server-envvar-bucket-notification-redis:

================================
Settings for Redis Notifications
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring a Redis service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-redis` for a tutorial on using these settings.

Environment Variables
---------------------

You can specify multiple Redis service endpoints by appending a unique identifier ``_ID`` to the end of the top level key for each set of related Redis environment variables. 
For example, the following commands set two distinct Redis service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_REDIS_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_REDIS_REDIS_ADDRESS_PRIMARY="https://user:password@redis-endpoint.example.net:9200"
   set MINIO_NOTIFY_REDIS_KEY_PRIMARY="bucketevents"
   set MINIO_NOTIFY_REDIS_FORMAT_PRIMARY="namespace"


   set MINIO_NOTIFY_REDIS_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_REDIS_REDIS_ADDRESS_SECONDARY="https://user:password@redis-endpoint.example.net:9200"
   set MINIO_NOTIFY_REDIS_KEY_SECONDARY="bucketevents"
   set MINIO_NOTIFY_REDIS_FORMAT_SECONDARY="namespace"

.. envvar:: MINIO_NOTIFY_REDIS_ENABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-enable
      :end-before: end-minio-notify-redis-enable

   Requires specifying the following additional environment variables if set to ``on``:

   - :envvar:`MINIO_NOTIFY_REDIS_ADDRESS`
   - :envvar:`MINIO_NOTIFY_REDIS_KEY`
   - :envvar:`MINIO_NOTIFY_REDIS_FORMAT`

   This environment variable corresponds with the :mc-conf:`notify_redis <notify_redis>` configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_ADDRESS

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-address
      :end-before: end-minio-notify-redis-address

   This environment variable corresponds with the :mc-conf:`notify_redis address <notify_redis.address>` configuration setting.

   .. include:: /includes/linux/minio-server.rst
      :start-after: start-notify-target-online-desc
      :end-before: end-notify-target-online-desc

.. envvar:: MINIO_NOTIFY_REDIS_KEY

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-key
      :end-before: end-minio-notify-redis-key

   This environment variable corresponds with the :mc-conf:`notify_redis key <notify_redis.key>` configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_FORMAT

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-format
      :end-before: end-minio-notify-redis-format

   This environment variable corresponds with the :mc-conf:`notify_redis format <notify_redis.format>` configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_PASSWORD

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-password
      :end-before: end-minio-notify-redis-password

   This environment variable corresponds with the :mc-conf:`notify_redis password <notify_redis.password>` configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-queue-dir
      :end-before: end-minio-notify-redis-queue-dir

   This environment variable corresponds with the :mc-conf:`notify_redis queue_dir <notify_redis.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-queue-limit
      :end-before: end-minio-notify-redis-queue-limit

   This environment variable corresponds with the :mc-conf:`notify_redis queue_limit <notify_redis.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-comment
      :end-before: end-minio-notify-redis-comment

   This environment variable corresponds with the :mc-conf:`notify_redis comment <notify_redis.comment>` configuration setting.

.. _minio-server-config-bucket-notification-redis:

Configuration Values
--------------------

The following section documents settings for configuring an Redis server/broker as a publishing target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-redis` for a tutorial on using these configuration settings.

.. mc-conf:: notify_redis

   The top-level configuration key for defining an Redis server/broker endpoint
   for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an Redis server/broker
   endpoint. The following arguments are *required* for each endpoint: 
   
   - :mc-conf:`~notify_redis.address`
   - :mc-conf:`~notify_redis.key`
   - :mc-conf:`~notify_redis.format`

   Specify additional optional arguments as a whitespace (``" "``)-delimited
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_redis \ 
         address="ENDPOINT" \
         key="<string>" \
         format="<string>" \
         [ARGUMENT="VALUE"] ... \

   You can specify multiple Redis server/broker endpoints by appending
   ``[:name]`` to the top level key. For example, the following commands set two
   distinct Redis service endpoints as ``primary`` and ``secondary``
   respectively:

   .. code-block:: shell

      mc admin config set notify_redis:primary \ 
         address="ENDPOINT" \
         key="<string>" \
         format="<string>" \
         [ARGUMENT="VALUE"] ... \

      mc admin config set notify_redis:secondary \
         address="ENDPOINT" \
         key="<string>" \
         format="<string>" \
         [ARGUMENT="VALUE"] ... \

   The :mc-conf:`notify_redis` configuration key supports the following 
   arguments:

   .. mc-conf:: address
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-address
         :end-before: end-minio-notify-redis-address

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_REDIS_ADDRESS` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: key
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-key
         :end-before: end-minio-notify-redis-key

   This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_REDIS_KEY` environment variable.

   .. mc-conf:: format
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-format
         :end-before: end-minio-notify-redis-format

   This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_REDIS_FORMAT` environment variable.

   .. mc-conf:: password
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-password
         :end-before: end-minio-notify-redis-password

   This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_REDIS_PASSWORD` environment variable.

   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-queue-dir
         :end-before: end-minio-notify-redis-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_REDIS_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-queue-limit
         :end-before: end-minio-notify-redis-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_REDIS_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-comment
         :end-before: end-minio-notify-redis-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_REDIS_COMMENT` environment variable.
