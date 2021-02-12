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

Specify the directory path to use for undelivered messages, 
such as ``/home/events``.

.. end-minio-notify-amqp-queue-dir


.. start-minio-notify-amqp-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``10000``.

.. end-minio-notify-amqp-queue-limit


.. start-minio-notify-amqp-comment

Specify a comment for the AMQP setting.

.. end-minio-notify-amqp-comment