.. Descriptions for AMQP bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/concepts/bucket-notifications.rst

.. start-minio-notify-amqp-enable

Specify ``on`` to enable publishing bucket notifications to an AMQP endpoint.

Defaults to ``off``.

.. end-minio-notify-amqp-enable


.. start-minio-notify-amqp-url

Specify the AMQP server endpoint to which MinIO publishes bucket events.
For example, ``amqp://myuser:mypassword@localhost:5672``.

.. end-minio-notify-amqp-url


.. start-minio-notify-amqp-exchange

Specify the name of the AMQP exchange to use.

.. end-minio-notify-amqp-exchange


.. start-minio-notify-amqp-exchange-type

Specify the type of the AMQP exchange.

.. end-minio-notify-amqp-exchange-type


.. start-minio-notify-amqp-routing-key

Specify the routing key for publishing events.

.. end-minio-notify-amqp-routing-key


.. start-minio-notify-amqp-mandatory

Specify ``off`` to ignore undelivered messages errors. Defaults to ``on``.

.. end-minio-notify-amqp-mandatory


.. start-minio-notify-amqp-durable

Specify ``on`` to persist the message queue across broker restarts. Defaults to
'off'.

.. end-minio-notify-amqp-durable


.. start-minio-notify-amqp-no-wait

Specify ``on`` to enable non-blocking message delivery. Defaults to 'off'.

.. end-minio-notify-amqp-no-wait


.. start-minio-notify-amqp-internal

Specify ``on`` to use the exchange only if it is bound to other exchanges.

.. end-minio-notify-amqp-internal


.. start-minio-notify-amqp-auto-deleted

Specify ``on`` to automatically delete the message queue if there are no
consumers. Defaults to ``off``.

.. end-minio-notify-amqp-auto-deleted


.. start-minio-notify-amqp-delivery-mode

Specify ``1`` for set the delivery mode to non-persistent queue.

Specify ``2`` to set the delivery mode to persistent queue.

.. end-minio-notify-amqp-delivery-mode


.. start-minio-notify-amqp-queue-dir

Specify the directory path to enable MinIO's persistent event store for
undelivered messages, such as ``/home/events``.

MinIO stores undelivered events in the specified store while the AMQP
service is offline and replays the directory when connectivity resumes.

.. end-minio-notify-amqp-queue-dir


.. start-minio-notify-amqp-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``10000``.

.. end-minio-notify-amqp-queue-limit


.. start-minio-notify-amqp-comment

Specify a comment for the AMQP configuration.

.. end-minio-notify-amqp-comment

.. Descriptions for MQTT bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/concepts/bucket-notifications.rst

.. start-minio-notify-mqtt-enable

Specify ``on`` to enable publishing bucket notifications to an MQTT endpoint.

Defaults to ``off``.

.. end-minio-notify-mqtt-enable


.. start-minio-notify-mqtt-broker

Specify the MQTT server/broker endpoint. MinIO supports TCP, TLS, or Websocket
connections to the server/broker URL. For example:

- ``tcp://mqtt.example.net:1883``
- ``tls://mqtt.example.net:1883``
- ``ws://mqtt.example.net:1883``

.. end-minio-notify-mqtt-broker


.. start-minio-notify-mqtt-topic

Specify the name of the MQTT topic to associate with events published by 
MinIO to the MQTT endpoint.

.. end-minio-notify-mqtt-topic


.. start-minio-notify-mqtt-username

Specify the MQTT username with which MinIO authenticates to the MQTT
server/broker.

.. end-minio-notify-mqtt-username


.. start-minio-notify-mqtt-password

Specify the password for the MQTT username with which MinIO authenticates to the
MQTT server/broker.

.. end-minio-notify-mqtt-password


.. start-minio-notify-mqtt-qos

Specify the Quality of Service priority for the published events. 

Defaults to ``0``.

.. end-minio-notify-mqtt-qos


.. start-minio-notify-mqtt-keep-alive-interval

Specify the keep-alive interval for the MQTT connections. MinIO 
supports the following units of time measurement:

- ``s`` - seconds, "60s"
- ``m`` - minutes, "60m"
- ``h`` - hours, "24h"
- ``d`` - days, "7d"

.. end-minio-notify-mqtt-keep-alive-interval


.. start-minio-notify-mqtt-reconnect-interval

Specify the reconnect interval for the MQTT connections. MinIO 
supports the following units of time measurement:

- ``s`` - seconds, "60s"
- ``m`` - minutes, "60m"
- ``h`` - hours, "24h"
- ``d`` - days, "7d"

.. end-minio-notify-mqtt-reconnect-interval


.. start-minio-notify-mqtt-queue-dir

Specify the directory path to enable MinIO's persistent event store for
undelivered messages, such as ``/home/events``.

MinIO stores undelivered events in the specified store while the MQTT 
server/broker is offline and replays the directory when connectivity resumes.

.. end-minio-notify-mqtt-queue-dir


.. start-minio-notify-mqtt-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``10000``.

.. end-minio-notify-mqtt-queue-limit


.. start-minio-notify-mqtt-comment

Specify a comment to associate to the MQTT configuration.

.. end-minio-notify-mqtt-comment

