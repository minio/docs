.. _minio-server-envvar-bucket-notification-mqtt:

===============================
Settings for MQTT Notifications
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an MQTT service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-mqtt` for a tutorial on using these settings.

Environment Variables
---------------------

You can specify multiple MQTT service endpoints by appending a unique identifier ``_ID`` for each set of related MQTT environment variables to the top level key. 
For example, the following commands set two distinct MQTT service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_MQTT_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_MQTT_BROKER_PRIMARY="tcp://user:password@mqtt-endpoint.example.net:1883"

   set MINIO_NOTIFY_MQTT_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_MQTT_BROKER_SECONDARY="tcp://user:password@mqtt-endpoint.example.net:1883"

For example, :envvar:`MINIO_NOTIFY_MQTT_ENABLE_PRIMARY <MINIO_NOTIFY_MQTT_ENABLE>` indicates the environment variable is associated to an MQTT service endpoint with ID of ``PRIMARY``.

.. envvar:: MINIO_NOTIFY_MQTT_ENABLE

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-enable
      :end-before: end-minio-notify-mqtt-enable

   This environment variable corresponds with the :mc-conf:`notify_mqtt <notify_mqtt>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_BROKER

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-broker
      :end-before: end-minio-notify-mqtt-broker

   This environment variable corresponds with the :mc-conf:`notify_mqtt broker <notify_mqtt.broker>` configuration setting.

   .. include:: /includes/linux/minio-server.rst
      :start-after: start-notify-target-online-desc
      :end-before: end-notify-target-online-desc

.. envvar:: MINIO_NOTIFY_MQTT_TOPIC

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-topic
      :end-before: end-minio-notify-mqtt-topic

   This environment variable corresponds with the :mc-conf:`notify_mqtt topic <notify_mqtt.topic>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_USERNAME

   *Required if the MQTT server/broker enforces authentication/authorization*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-username
      :end-before: end-minio-notify-mqtt-username

   This environment variable corresponds with the :mc-conf:`notify_mqtt username <notify_mqtt.username>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_PASSWORD

   *Required if the MQTT server/broker enforces authentication/authorization*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-password
      :end-before: end-minio-notify-mqtt-password

   This environment variable corresponds with the :mc-conf:`notify_mqtt password <notify_mqtt.password>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_QOS

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-qos
      :end-before: end-minio-notify-mqtt-qos

   This environment variable corresponds with the :mc-conf:`notify_mqtt qos <notify_mqtt.qos>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_KEEP_ALIVE_INTERVAL

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-keep-alive-interval
      :end-before: end-minio-notify-mqtt-keep-alive-interval

   This environment variable corresponds with the :mc-conf:`notify_mqtt keep_alive_interval <notify_mqtt.keep_alive_interval>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_RECONNECT_INTERVAL

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-reconnect-interval
      :end-before: end-minio-notify-mqtt-reconnect-interval

   This environment variable corresponds with the :mc-conf:`notify_mqtt reconnect_interval <notify_mqtt.reconnect_interval>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_QUEUE_DIR

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-queue-dir
      :end-before: end-minio-notify-mqtt-queue-dir

   This environment variable corresponds with the :mc-conf:`notify_mqtt queue_dir <notify_mqtt.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_QUEUE_LIMIT

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-queue-limit
      :end-before: end-minio-notify-mqtt-queue-limit

   This environment variable corresponds with the :mc-conf:`notify_mqtt queue_limit <notify_mqtt.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_COMMENT

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-comment
      :end-before: end-minio-notify-mqtt-comment

   This environment variable corresponds with the :mc-conf:`notify_mqtt comment <notify_mqtt.comment>` configuration setting.

.. _minio-server-config-bucket-notification-mqtt:

Configuration Values
--------------------

The following section documents settings for configuring an MQTT server/broker as a publishing target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-mqtt` for a tutorial on using these configuration settings.

.. mc-conf:: notify_mqtt

   The top-level configuration key for defining an MQTT server/broker endpoint
   for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an MQTT server/broker
   endpoint. The following arguments are *required* for each endpoint: 
   
   - :mc-conf:`~notify_mqtt.broker`
   - :mc-conf:`~notify_mqtt.topic`
   - :mc-conf:`~notify_mqtt.username` *Optional if MQTT server/broker does not enforce authentication/authorization*
   - :mc-conf:`~notify_mqtt.password` *Optional if MQTT server/broker does not enforce authentication/authorization*

   Specify additional optional arguments as a whitespace (``" "``)-delimited
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_mqtt \ 
         broker="tcp://endpoint:port" \
         topic="minio/bucket-name/events/" \
         username="username" \
         password="password" \
         [ARGUMENT="VALUE"] ... \

   You can specify multiple MQTT server/broker endpoints by appending
   ``[:name]`` to the top level key. For example, the following commands set two
   distinct MQTT service endpoints as ``primary`` and ``secondary``
   respectively:

   .. code-block:: shell

      mc admin config set notify_mqtt:primary \ 
         broker="tcp://endpoint:port" \
         topic="minio/bucket-name/events/" \
         username="username" \
         password="password" \
         [ARGUMENT="VALUE"] ... \

      mc admin config set notify_mqtt:secondary \
         broker="tcp://endpoint:port" \
         topic="minio/bucket-name/events/" \
         username="username" \
         password="password" \
         [ARGUMENT="VALUE"] ... \

   The :mc-conf:`notify_mqtt` configuration key supports the following 
   arguments:

   .. mc-conf:: broker
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-broker
         :end-before:  end-minio-notify-mqtt-broker

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MQTT_BROKER` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: topic
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-topic
         :end-before:  end-minio-notify-mqtt-topic

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MQTT_TOPIC` environment variable.

   .. mc-conf:: username
      :delimiter: " "

      *Required if the MQTT server/broker enforces authentication/authorization*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-username
         :end-before:  end-minio-notify-mqtt-username

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MQTT_TOPIC` environment variable.

   .. mc-conf:: password
      :delimiter: " "

      *Required if the MQTT server/broker enforces authentication/authorization*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-password
         :end-before:  end-minio-notify-mqtt-password

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MQTT_PASSWORD` environment variable.

   .. mc-conf:: qos
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-qos
         :end-before:  end-minio-notify-mqtt-qos

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MQTT_QOS` environment variable.

   .. mc-conf:: keep_alive_interval
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-keep-alive-interval
         :end-before:  end-minio-notify-mqtt-keep-alive-interval

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MQTT_KEEP_ALIVE_INTERVAL` environment variable.

   .. mc-conf:: reconnect_interval
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-reconnect-interval
         :end-before:  end-minio-notify-mqtt-reconnect-interval

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MQTT_RECONNECT_INTERVAL` environment variable.

   .. mc-conf:: queue_dir 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-queue-dir
         :end-before:  end-minio-notify-mqtt-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MQTT_QUEUE_DIR` environment variable.

   .. mc-conf:: queue_limit 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-queue-limit
         :end-before:  end-minio-notify-mqtt-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MQTT_QUEUE_LIMIT` environment variable.

   .. mc-conf:: comment 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-comment
         :end-before:  end-minio-notify-mqtt-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MQTT_COMMENT` environment variable.