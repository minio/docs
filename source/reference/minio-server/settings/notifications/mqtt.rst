.. _minio-server-envvar-bucket-notification-mqtt:
.. _minio-server-config-bucket-notification-mqtt:

==========================
MQTT Notification Settings
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an MQTT service as a target for :ref:`Bucket Notifications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-mqtt` for a tutorial on using these settings.

Multiple MQTT Targets
---------------------

You can specify multiple MQTT service endpoints by appending a unique identifier ``_ID`` for each set of related MQTT settings to the top level key. 
For example, the following commands set two distinct MQTT service endpoints as ``PRIMARY`` and ``SECONDARY``, respectively:

.. tab-set:: 
   
   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell
         :class: copyable
   
         set MINIO_NOTIFY_MQTT_ENABLE_PRIMARY="on"
         set MINIO_NOTIFY_MQTT_BROKER_PRIMARY="tcp://user:password@mqtt-endpoint.example.net:1883"
   
         set MINIO_NOTIFY_MQTT_ENABLE_SECONDARY="on"
         set MINIO_NOTIFY_MQTT_BROKER_SECONDARY="tcp://user:password@mqtt-endpoint.example.net:1883"

   .. tab-item:: Configuration Setting
      :sync: config

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

With these settings, :envvar:`MINIO_NOTIFY_MQTT_ENABLE_PRIMARY <MINIO_NOTIFY_MQTT_ENABLE>` indicates the environment variable is associated to an MQTT service endpoint with an ID of ``PRIMARY``.

Settings
--------

Enable
~~~~~~

*Required*

.. tab-set:: 
   
   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MQTT_ENABLE

      Specify ``on`` to enable publishing bucket notifications to an MQTT endpoint.
      
      Defaults to ``off``.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mqtt

      The top-level configuration key for defining an MQTT server/broker endpoint for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.
   
      Use :mc-cmd:`mc admin config set` to set or update an MQTT server/broker endpoint. 
      The following arguments are *required* for each endpoint: 
      
      - :mc-conf:`~notify_mqtt.broker`
      - :mc-conf:`~notify_mqtt.topic`
      - :mc-conf:`~notify_mqtt.username` *Optional if MQTT server/broker does not enforce authentication/authorization*
      - :mc-conf:`~notify_mqtt.password` *Optional if MQTT server/broker does not enforce authentication/authorization*

      Specify additional optional arguments as a whitespace (``" "``)-delimited list.

      .. code-block:: shell
         :class: copyable
   
         mc admin config set notify_mqtt \ 
            broker="tcp://endpoint:port" \
            topic="minio/bucket-name/events/" \
            username="username" \
            password="password" \
            [ARGUMENT="VALUE"] ... \

Broker
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MQTT_BROKER

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mqtt broker
         :delimiter: " "

Specify the MQTT server/broker endpoint. 
MinIO supports TCP, TLS, or Websocket connections to the server/broker URL. 
For example:

- ``tcp://mqtt.example.net:1883``
- ``tls://mqtt.example.net:1883``
- ``ws://mqtt.example.net:1883``

.. include:: /includes/linux/minio-server.rst
   :start-after: start-notify-target-online-desc
   :end-before: end-notify-target-online-desc

Topic
~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MQTT_TOPIC

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mqtt topic
         :delimiter: " "

Specify the name of the MQTT topic to associate with events published by MinIO to the MQTT endpoint.

Username
~~~~~~~~

*Required if the MQTT server/broker enforces authentication/authorization*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MQTT_USERNAME

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mqtt username
         :delimiter: " "

Specify the MQTT username MinIO should use to authenticate to the MQTT server/broker.

Password
~~~~~~~~

*Required if the MQTT server/broker enforces authentication/authorization*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MQTT_PASSWORD

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mqtt password
         :delimiter: " "

Specify the password for the MQTT username MinIO uses to authenticate to the MQTT server/broker.

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

Quality of Service
~~~~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MQTT_QOS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mqtt qos
         :delimiter: " "

Specify the Quality of Service priority for the published events. 

Defaults to ``0``.

Keep Alive Interval
~~~~~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MQTT_KEEP_ALIVE_INTERVAL

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mqtt keep_alive_interval
         :delimiter: " "

Specify the keep-alive interval for the MQTT connections. MinIO 
supports the following units of time measurement:

- ``s`` - seconds, "60s"
- ``m`` - minutes, "60m"
- ``h`` - hours, "24h"
- ``d`` - days, "7d"

Reconnect Interval
~~~~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MQTT_RECONNECT_INTERVAL

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mqtt reconnect_interval
         :delimiter: " "

Specify the reconnect interval for the MQTT connections. MinIO 
supports the following units of time measurement:

- ``s`` - seconds, "60s"
- ``m`` - minutes, "60m"
- ``h`` - hours, "24h"
- ``d`` - days, "7d"

Queue Directory
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MQTT_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mqtt queue_dir 
         :delimiter: " "

Specify the directory path to enable MinIO's persistent event store for undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the MQTT server/broker is offline and replays the stored events when connectivity resumes.

Queue Limit
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MQTT_QUEUE_LIMIT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mqtt queue_limit 
         :delimiter: " "

Specify the maximum limit for undelivered messages. 
Defaults to ``100000``.

Comment
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MQTT_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mqtt comment 
         :delimiter: " "

Specify a comment to associate with the MQTT configuration.