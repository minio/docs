.. Descriptions for AMQP bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst

.. start-minio-settings-defined

You can define settings either by defining 

- an *environment variable* prior to starting or restarting the MinIO Server.
- a *configuration setting* using :mc:`mc admin config set`.
- a *configuration setting* using the :ref:`MinIO Console's <minio-console-settings>` :guilabel:`Administrator > Settings` pages.
  
If you define both an environment variable and the similar configuration setting, MinIO uses the environment variable value.

Some settings can only be defined by either an environment variable or by a configuration setting.

.. end-minio-settings-defined

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

Specify ``on`` to use the exchange only if it is bound to other exchanges. See
the RabbitMQ documentation on `Exchange to Exchange Bindings
<https://www.rabbitmq.com/e2e.html>`__ for more information on AMQP exchange
binding.

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
undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the AMQP
service is offline and replays the stored events when connectivity resumes.

.. end-minio-notify-amqp-queue-dir


.. start-minio-notify-amqp-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

.. end-minio-notify-amqp-queue-limit


.. start-minio-notify-amqp-comment

Specify a comment for the AMQP configuration.

.. end-minio-notify-amqp-comment

.. Descriptions for MQTT bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst

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

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

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
undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the MQTT 
server/broker is offline and replays the stored events when connectivity resumes.

.. end-minio-notify-mqtt-queue-dir


.. start-minio-notify-mqtt-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

.. end-minio-notify-mqtt-queue-limit


.. start-minio-notify-mqtt-comment

Specify a comment to associate with the MQTT configuration.

.. end-minio-notify-mqtt-comment

.. Descriptions for Elasticsearch bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst
   - /source/monitoring/bucket-notifications/publish-events-to-elasticsearch.rst

.. start-minio-notify-elasticsearch-enable

Specify ``on`` to enable publishing bucket notifications to an Elasticsearch 
service endpoint.

Defaults to ``off``.

.. end-minio-notify-elasticsearch-enable

.. start-minio-notify-elasticsearch-url

Specify the Elasticsearch service endpoint to which MinIO publishes bucket 
events. For example, ``https://elasticsearch.example.com:9200``.

MinIO supports passing authentication information using as URL parameters
using the format ``PROTOCOL://USERNAME:PASSWORD@HOSTNAME:PORT``.

.. end-minio-notify-elasticsearch-url

.. start-minio-notify-elasticsearch-index

Specify the name of the Elasticsearch index in which to store or update
MinIO bucket events. Elasticsearch automatically creates the index if it 
does not exist.

.. end-minio-notify-elasticsearch-index

.. start-minio-notify-elasticsearch-format

Specify the format of event data written to the Elasticsearch index. MinIO
supports the following values:

``namespace``
   For each bucket event, the MinIO creates a JSON document with the bucket
   and object name from the event as the document ID and the actual event as 
   part of the document body. Additional updates to that object modify the
   existing index entry for that object. Similarly, deleting the object
   also deletes the corresponding index entry.
   
``access``
   For each bucket event, MinIO creates a JSON document with the event
   details and appends it to the index with an Elasticsearch-generated
   random ID. Additional updates to an object result in new index entries, 
   and existing entries remain unmodified.

.. end-minio-notify-elasticsearch-format

.. start-minio-notify-elasticsearch-username

The username for connecting to an Elasticsearch service endpoint which 
enforces authentication.

.. end-minio-notify-elasticsearch-username

.. start-minio-notify-elasticsearch-password

The password for connecting to an Elasticsearch service endpoint which enforces
authentication.

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

.. end-minio-notify-elasticsearch-password

.. start-minio-notify-elasticsearch-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

.. end-minio-notify-elasticsearch-queue-limit

.. start-minio-notify-elasticsearch-queue-dir

Specify the directory path to enable MinIO's persistent event store for
undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the Elasticsearch 
service is offline and replays the stored events when connectivity resumes.

.. end-minio-notify-elasticsearch-queue-dir

.. start-minio-notify-elasticsearch-comment

Specify a comment to associate with the Elasticsearch configuration.

.. end-minio-notify-elasticsearch-comment

.. Descriptions for NSQ bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst
   - /source/monitoring/bucket-notifications/publish-events-to-nsq.rst

.. start-minio-notify-nsq-enable

Specify ``on`` to enable publishing bucket notifications to an NSQ endpoint.

.. end-minio-notify-nsq-enable

.. start-minio-notify-nsq-nsqd-address

Specify the NSQ server address. For example:

``https://nsq-endpoing.example.net:4150``

.. end-minio-notify-nsq-nsqd-address

.. start-minio-notify-nsq-topic

Specify the name of the NSQ topic MinIO uses when publishing events to the
broker.

.. end-minio-notify-nsq-topic

.. start-minio-notify-nsq-tls

Specify ``on`` to enable TLS connectivity to the NSQ service broker.

.. end-minio-notify-nsq-tls

.. start-minio-notify-nsq-tls-skip-verify

Enables or disables TLS verification of the NSQ service broker TLS certificates.

- Specify ``on`` to disable TLS verification (Default).
- Specify ``off`` to enable TLS verification.

.. end-minio-notify-nsq-tls-skip-verify

.. start-minio-notify-nsq-queue-dir

Specify the directory path to enable MinIO's persistent event store for
undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the NSQ 
server/broker is offline and replays the stored events when connectivity resumes.

.. end-minio-notify-nsq-queue-dir

.. start-minio-notify-nsq-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

.. end-minio-notify-nsq-queue-limit

.. start-minio-notify-nsq-comment


Specify a comment to associate with the NSQ configuration.

.. end-minio-notify-nsq-comment

.. Descriptions for Redis bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst
   - /source/monitoring/bucket-notifications/publish-events-to-redis.rst

.. start-minio-notify-redis-enable

Specify ``on`` to enable publishing bucket notifications to a Redis
service endpoint.

Defaults to ``off``.

.. end-minio-notify-redis-enable

.. start-minio-notify-redis-address

Specify the Redis service endpoint to which MinIO publishes bucket events.
For example, ``https://redis.example.com:6369``.

.. end-minio-notify-redis-address

.. start-minio-notify-redis-key

Specify the Redis key to use for storing and updating events. Redis 
auto-creates the key if it does not exist.

.. end-minio-notify-redis-key

.. start-minio-notify-redis-format

Specify the format of event data written to the Redis service endpoint. MinIO
supports the following values:

``namespace``
   For each bucket event, the MinIO creates a JSON document with the bucket
   and object name from the event as the document ID and the actual event as 
   part of the document body. Additional updates to that object modify the
   existing index entry for that object. Similarly, deleting the object
   also deletes the corresponding index entry.
   
``access``
   For each bucket event, MinIO creates a JSON document with the event
   details and appends it to the key with a Redis-generated
   random ID. Additional updates to an object result in new index entries, 
   and existing entries remain unmodified.

.. end-minio-notify-redis-format

.. start-minio-notify-redis-password

Specify the password for the Redis server.

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

.. end-minio-notify-redis-password


.. start-minio-notify-redis-queue-dir

Specify the directory path to enable MinIO's persistent event store for
undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the Redis 
server/broker is offline and replays the stored events when connectivity resumes.

.. end-minio-notify-redis-queue-dir

.. start-minio-notify-redis-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

.. end-minio-notify-redis-queue-limit

.. start-minio-notify-redis-comment


Specify a comment to associate with the Redis configuration.

.. end-minio-notify-redis-comment

.. Descriptions for NATS bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst
   - /source/monitoring/bucket-notifications/publish-events-to-nats.rst

.. start-minio-notify-nats-enable

Specify ``on`` to enable publishing bucket notifications to an NATS 
service endpoint.

Defaults to ``off``.

.. end-minio-notify-nats-enable

.. start-minio-notify-nats-address

Specify the NATS service endpoint to which MinIO publishes bucket events. 
For example, ``https://nats-endpoint.example.com:4222``.

.. end-minio-notify-nats-address

.. start-minio-notify-nats-subject

Specify the subscription to which MinIO associates events 
published to the NATS endpoint.

.. end-minio-notify-nats-subject

.. start-minio-notify-nats-username

Specify the username for connecting to the NATS service endpoint.

.. end-minio-notify-nats-username

.. start-minio-notify-nats-password

Specify the passport for connecting to the NATS service endpoint.

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

.. end-minio-notify-nats-password

.. start-minio-notify-nats-token

Specify the token for connecting to the NATS service endpoint.

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

.. end-minio-notify-nats-token

.. start-minio-notify-nats-tls

Specify ``on`` to enable TLS connectivity to the NATS service endpoint.

.. end-minio-notify-nats-tls

.. start-minio-notify-nats-tls-skip-verify

Enables or disables TLS verification of the NATS service endpoint TLS
certificates.

- Specify ``on`` to disable TLS verification (Default).
- Specify ``off`` to enable TLS verification.

.. end-minio-notify-nats-tls-skip-verify

.. start-minio-notify-nats-ping-interval

Specify the duration interval for client pings to the NATS server. 
MinIO supports the following time units:

- ``s`` - seconds, ``"60s"``
- ``m`` - minutes, ``"5m"``
- ``h`` - hours, ``"1h"``
- ``d`` - days, ``"1d"``

.. end-minio-notify-nats-ping-interval

.. start-minio-notify-nats-streaming

Specify ``on`` to enable JetStream support for streaming events to a NATS JetStream service endpoint.

.. end-minio-notify-nats-streaming

.. start-minio-notify-nats-jetstream

Specify ``on`` to enable asynchronous publishing of events to the NATS service endpoint.

.. end-minio-notify-nats-jetstream


.. start-minio-notify-nats-streaming-async

Specify ``on`` to enable asynchronous publishing of events to the NATS service
endpoint.

.. end-minio-notify-nats-streaming-async

.. start-minio-notify-nats-streaming-max-pub-acks-in-flight

Specify the number of messages to publish without waiting for an ACK 
response from the NATS service endpoint.

.. end-minio-notify-nats-streaming-max-pub-acks-in-flight

.. start-minio-notify-nats-streaming-cluster-id

Specify the unique ID for the NATS streaming cluster.

.. end-minio-notify-nats-streaming-cluster-id

.. start-minio-notify-nats-cert-authority

Specify the path to the Certificate Authority chain used to sign the
NATS service endpoint TLS certificates.

.. end-minio-notify-nats-cert-authority

.. start-minio-notify-nats-client-cert

Specify the path to the client certificate to use for performing 
mTLS authentication to the NATS service endpoint.

.. end-minio-notify-nats-client-cert

.. start-minio-notify-nats-client-key

Specify the path to the client private key to use for performing mTLS
authentication to the NATS service endpoint.

.. end-minio-notify-nats-client-key

.. start-minio-notify-nats-queue-dir

Specify the directory path to enable MinIO's persistent event store for
undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the NATS 
server/broker is offline and replays the stored events when connectivity resumes.

.. end-minio-notify-nats-queue-dir

.. start-minio-notify-nats-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

.. end-minio-notify-nats-queue-limit

.. start-minio-notify-nats-comment

Specify a comment to associate with the NATS configuration.

.. end-minio-notify-nats-comment

.. Descriptions for postgresql bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst
   - /source/monitoring/bucket-notifications/publish-events-to-postgresql.rst

.. start-minio-notify-postgresql-enable

Specify ``on`` to enable publishing bucket notifications to a PostgreSQL 
service endpoint.

Defaults to ``off``.

.. end-minio-notify-postgresql-enable

.. start-minio-notify-postgresql-connection-string

Specify the `URI connection string 
<https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING>`__
of the PostgreSQL service endpoint. MinIO supports ``key=value`` format for 
the PostgreSQL connection string. For example:

``"host=https://postgresql.example.com port=5432 ..."``

For more complete documentation on supported PostgreSQL connection
string parameters, see the `PostgreSQL COnnection Strings documentation
<https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING>`__
.

.. end-minio-notify-postgresql-connection-string

.. start-minio-notify-postgresql-table

Specify the name of the PostgreSQL table to which MinIO publishes 
event notifications.

.. end-minio-notify-postgresql-table

.. start-minio-notify-postgresql-format

Specify the format of event data written to the PostgreSQL service endpoint.
MinIO supports the following values:

``namespace``
   For each bucket event, the MinIO creates a JSON document with the bucket
   and object name from the event as the document ID and the actual event as 
   part of the document body. Additional updates to that object modify the
   existing table entry for that object. Similarly, deleting the object
   also deletes the corresponding table entry.
   
``access``
   For each bucket event, MinIO creates a JSON document with the event
   details and appends it to the table with a PostgreSQL-generated
   random ID. Additional updates to an object result in new index entries, 
   and existing entries remain unmodified.

.. end-minio-notify-postgresql-format

.. start-minio-notify-postgresql-max-open-connections

Specify the maximum number of open connections to the PostgreSQL database.

Defaults to ``2``.

.. end-minio-notify-postgresql-max-open-connections

.. start-minio-notify-postgresql-queue-dir

Specify the directory path to enable MinIO's persistent event store for
undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the PostgreSQL 
server/broker is offline and replays the stored events when connectivity resumes.

.. end-minio-notify-postgresql-queue-dir

.. start-minio-notify-postgresql-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

.. end-minio-notify-postgresql-queue-limit

.. start-minio-notify-postgresql-comment

Specify a comment to associate with the PostgreSQL configuration.

.. end-minio-notify-postgresql-comment


.. Descriptions for MySQL bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst
   - /source/monitoring/bucket-notifications/publish-events-to-mysql.rst

.. start-minio-notify-mysql-enable

Specify ``on`` to enable publishing bucket notifications to a MySQL 
service endpoint.

Defaults to ``off``.

.. end-minio-notify-mysql-enable

.. start-minio-notify-mysql-dsn-string

Specify the data source name (DSN) of the MySQL service endpoint. MinIO expects
the following format:

``<user>:<password>@tcp(<host>:<port>)/<database>``
 
For example:
 
``"username:password@tcp(mysql.example.com:3306)/miniodb"``

.. end-minio-notify-mysql-dsn-string

.. start-minio-notify-mysql-connection-string

Specify the data source name (DSN) connection string for the MySQL service
endpoint. MinIO expects the following format:

``<user>:<password>@tcp(<host>:<port>)/<database>``

For example:

``"username:password@tcp(mysql.example.com:3306)/miniodb"``

.. end-minio-notify-mysql-connection-string

.. start-minio-notify-mysql-table

Specify the name of the MySQL table to which MinIO publishes event
notifications.

.. end-minio-notify-mysql-table

.. start-minio-notify-mysql-format

Specify the format of event data written to the MySQL service endpoint.
MinIO supports the following values:

``namespace``
   For each bucket event, the MinIO creates a JSON document with the bucket
   and object name from the event as the document ID and the actual event as 
   part of the document body. Additional updates to that object modify the
   existing table entry for that object. Similarly, deleting the object
   also deletes the corresponding table entry.
   
``access``
   For each bucket event, MinIO creates a JSON document with the event
   details and appends it to the table with a MySQL-generated
   random ID. Additional updates to an object result in new index entries, 
   and existing entries remain unmodified.

.. end-minio-notify-mysql-format

.. start-minio-notify-mysql-max-open-connections

Specify the maximum number of open connections to the MySQL database.

Defaults to ``2``.

.. end-minio-notify-mysql-max-open-connections

.. start-minio-notify-mysql-queue-dir

Specify the directory path to enable MinIO's persistent event store for
undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the MySQL 
server/broker is offline and replays the stored events when connectivity resumes.

.. end-minio-notify-mysql-queue-dir

.. start-minio-notify-mysql-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

.. end-minio-notify-mysql-queue-limit

.. start-minio-notify-mysql-comment

Specify a comment to associate with the MySQL configuration.

.. end-minio-notify-mysql-comment


.. Descriptions for Kafka bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst
   - /source/monitoring/bucket-notifications/publish-events-to-kafka.rst

.. start-minio-notify-kafka-enable

Specify ``on`` to enable publishing bucket notifications to a Kafka
service endpoint.

Defaults to ``off``.

.. end-minio-notify-kafka-enable

.. start-minio-notify-kafka-brokers

Specify a comma-separated list of Kafka broker addresses. For example:

``"kafka1.example.com:2021,kafka2.example.com:2021"``

.. end-minio-notify-kafka-brokers

.. start-minio-notify-kafka-topic

Specify the name of the Kafka topic to which MinIO publishes 
bucket events.

.. end-minio-notify-kafka-topic

.. start-minio-notify-kafka-sasl-username

Specify the username for performing SASL/PLAIN or SASL/SCRAM authentication
to the Kafka broker(s).

.. end-minio-notify-kafka-sasl-username

.. start-minio-notify-kafka-sasl-password

Specify the password for performing SASL/PLAIN or SASL/SCRAM authentication
to the Kafka broker(s).

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

.. end-minio-notify-kafka-sasl-password

.. start-minio-notify-kafka-sasl-mechanism

Specify the SASL mechanism to use for authenticating to the Kafka broker(s).
MinIO supports the following mechanisms:

- ``PLAIN`` (Default)
- ``SHA256``
- ``SHA512``

.. end-minio-notify-kafka-sasl-mechanism

.. start-minio-notify-kafka-tls-client-auth

Specify the client authentication type of the Kafka broker(s).
The following table lists the supported values and their mappings

.. list-table::
   :header-rows: 1
   :widths: 20 80
   :width: 100%

   * - Value
     - Authentication Type

   * - 0
     - ``NoClientCert``

   * - 1
     - ``RequestClientCert``

   * - 2
     - ``RequireAnyClientCert``

   * - 3
     - ``VerifyClientCertIfGiven``

   * - 4
     - ``RequireAndVerifyClientCert``


See `ClientAuthType <https://golang.org/pkg/crypto/tls/#ClientAuthType>`__ for more information on each client auth type.
.. end-minio-notify-kafka-tls-client-auth

.. start-minio-notify-kafka-sasl-root

Specify ``on`` to enable SASL authentication.

.. end-minio-notify-kafka-sasl-root

.. start-minio-notify-kafka-tls-root

Specify ``on`` to enable TLS connectivity to the Kafka broker(s)

.. end-minio-notify-kafka-tls-root

.. start-minio-notify-kafka-tls-skip-verify

Enables or disables TLS verification of the NATS service endpoint TLS
certificates.

- Specify ``on`` to disable TLS verification (Default).
- Specify ``off`` to enable TLS verification.

.. end-minio-notify-kafka-tls-skip-verify

.. start-minio-notify-kafka-client-tls-cert

Specify the path to the client certificate to use for performing
mTLS authentication to the Kafka broker(s).

.. end-minio-notify-kafka-client-tls-cert

.. start-minio-notify-kafka-client-tls-key

Specify the path to the client private key to use for performing
mTLS authentication to the Kafka broker(s).

.. end-minio-notify-kafka-client-tls-key

.. start-minio-notify-kafka-version

Specify the version of the Kafka cluster to assume when performing operations
against that cluster. See the `sarama reference documentation 
<https://github.com/shopify/sarama/blob/v1.20.1/config.go#L327>`__ for 
more information on this field's behavior.

.. end-minio-notify-kafka-version

.. start-minio-notify-kafka-queue-dir

Specify the directory path to enable MinIO's persistent event store for
undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the Kafka 
server/broker is offline and replays the stored events when connectivity resumes.

.. end-minio-notify-kafka-queue-dir

.. start-minio-notify-kafka-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

.. end-minio-notify-kafka-queue-limit

.. start-minio-notify-kafka-comment

Specify a comment to associate with the Kafka configuration.

.. end-minio-notify-kafka-comment


.. Descriptions for Webhook bucket notification configurations.
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst
   - /source/monitoring/bucket-notifications/publish-events-to-webhook.rst


.. start-minio-notify-webhook-enable

Specify ``on`` to enable publishing bucket notifications to a Webhook
service endpoint.

Defaults to ``off``.

.. end-minio-notify-webhook-enable

.. start-minio-notify-webhook-endpoint

Specify the URL for the webhook service.

.. end-minio-notify-webhook-endpoint

.. start-minio-notify-webhook-client-cert

Specify the path to the client certificate to use for performing 
mTLS authentication to the webhook service.

.. end-minio-notify-webhook-client-cert

.. start-minio-notify-webhook-client-key

Specify the path to the client private key to use for performing 
mTLS authentication to the webhook service.

.. end-minio-notify-webhook-client-key

.. start-minio-notify-webhook-queue-dir

Specify the directory path to enable MinIO's persistent event store for
undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the webhook
service is offline and replays the stored events when connectivity resumes.

.. end-minio-notify-webhook-queue-dir

.. start-minio-notify-webhook-queue-limit

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

.. end-minio-notify-webhook-queue-limit

.. start-minio-notify-webhook-comment

Specify a comment to associate with the Webhook configuration.

.. end-minio-notify-webhook-comment

.. Root API Access

.. start-minio-root-api-access

.. versionadded:: MinIO Server RELEASE.2023-05-04T21-44-30Z

Specify ``on`` to enable and ``off`` to disable the :ref:`root <minio-users-root>` user account.
Disabling the root service account also disables all service accounts associated with root, excluding those used by site replication.
Defaults to ``on``.

Ensure you have at least one other admin user, such as one with the :userpolicy:`consoleAdmin` policy, before disabling the root account.
If you do not have another admin user, disabling the root account locks administrative access to the deployment.

.. end-minio-root-api-access


.. kafka audit settings

.. start-minio-kafka-audit-logging-brokers-desc

A comma-separated list of Kafka broker addresses:


.. code-block:: shell

   brokers="https://kafka-1.example.net:9092,https://kafka-2.example.net:9092"

At least one broker must be online and reachable by the MinIO server to initialize and send audit log events.
MinIO checks each specified broker in order of specification.

.. end-minio-kafka-audit-logging-brokers-desc

.. start-minio-kafka-audit-logging-topic-desc

The name of the Kafka topic to associate to MinIO audit log events.

.. end-minio-kafka-audit-logging-topic-desc

.. start-minio-kafka-audit-logging-tls-desc

Set to ``"on"`` to enable TLS connectivity to the specified Kafka brokers.

Defaults to ``"off"``.

.. end-minio-kafka-audit-logging-tls-desc

.. start-minio-kafka-audit-logging-tls-skip-verify-desc

Set to ``"on"`` to direct MinIO to skip verification of the Kafka broker TLS certificates.

You can use this option for enabling connectivity to Kafka brokers using TLS certificates signed by unknown parties, such as self-signed or corporate-internal Certificate Authorities (CA).

MinIO by default uses the system trust store *and* the contents of the MinIO :ref:`CA directory <minio-tls>` for verifying remote client TLS certificates.

Defaults to ``"off"`` for strict verification of TLS certificates.

.. end-minio-kafka-audit-logging-tls-skip-verify-desc

.. start-minio-kafka-audit-logging-tls-client-auth-desc

Set to ``"on"`` to direct MinIO to use mTLS to authenticate against the Kafka brokers.

.. end-minio-kafka-audit-logging-tls-client-auth-desc

.. start-minio-kafka-audit-logging-client-tls-cert-desc

The path to the TLS client certificate to use for mTLS authentication.

.. end-minio-kafka-audit-logging-client-tls-cert-desc

.. start-minio-kafka-audit-logging-client-tls-key-desc

The path to the TLS client private key to use for mTLS authentication.

.. end-minio-kafka-audit-logging-client-tls-key-desc

.. start-minio-kafka-audit-logging-sasl-desc

Set to ``"on"`` to direct MinIO to use SASL to authenticate against the Kafka brokers.

.. end-minio-kafka-audit-logging-sasl-desc

.. start-minio-kafka-audit-logging-sasl-username-desc

The SASL username MinIO uses for authentication against the Kafka brokers.

.. end-minio-kafka-audit-logging-sasl-username-desc

.. start-minio-kafka-audit-logging-sasl-password-desc

The SASL password MinIO uses for authentication against the Kafka brokers.

.. end-minio-kafka-audit-logging-sasl-password-desc

.. start-minio-kafka-audit-logging-sasl-mechanism-desc

The SASL mechanism MinIO uses for authentication against the Kafka brokers.

Defaults to ``plain``.

.. end-minio-kafka-audit-logging-sasl-mechanism-desc

.. start-minio-kafka-audit-logging-version-desc

The version of the Kafka broker MinIO expects at the specified endpoints.

MinIO returns an error if the Kakfa broker verison does not match those specified to this setting.

.. end-minio-kafka-audit-logging-version-desc

.. start-minio-kafka-audit-logging-comment-desc

A comment to associate with the configuration.

.. end-minio-kafka-audit-logging-comment-desc

.. start-minio-kafka-audit-logging-queue-dir-desc

Specify the directory path to enable MinIO's persistent event store for
undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the Kafka
service is offline and replays the stored events when connectivity resumes.

.. end-minio-kafka-audit-logging-queue-dir-desc

.. start-minio-kafka-audit-logging-queue-size-desc

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

.. end-minio-kafka-audit-logging-queue-size-desc

.. start-minio-data-compression-allow_encryption-desc

Set to ``on`` to encrypt objects after compressing them.
Defaults to ``off``.

.. admonition:: Encrypting compressed objects may compromise security
   :class: warning

   MinIO strongly recommends against encrypting compressed objects.
   If you require encryption, carefully evaluate the risk of potentially leaking information about the contents of encrypted objects.

.. end-minio-data-compression-allow_encryption-desc

.. start-minio-data-compression-comment-desc

Specify a comment to associate with the data compression configuration.

.. end-minio-data-compression-comment-desc

.. start-minio-data-compression-enable-desc

Set to ``on`` to enable data compression for new objects.
Defaults to ``off``.

Enabling or disabling data compression does not change existing objects.

.. end-minio-data-compression-enable-desc

.. start-minio-data-compression-extensions-desc

Comma-separated list of the file extensions to compress.
Setting a new list of file extensions replaces the previously configured list.
Defaults to ``".txt, .log, .csv, .json, .tar, .xml, .bin"``.

.. admonition:: Default excluded files
   :class: note

   Some types of files cannot be significantly reduced in size.
   MinIO will *not* compress these, even if specified in an :mc-conf:`~compression.extensions` argument.
   See :ref:`Excluded types <minio-data-compression-excluded-types>` for details.

.. end-minio-data-compression-extensions-desc

.. start-minio-data-compression-mime_types-desc

Comma-separated list of the MIME types to compress.
Setting	a new list of types replaces the previously configured list.
Defaults to ``"text/*, application/json, application/xml, binary/octet-stream"``.

.. admonition:: Default excluded files
   :class: note

   Some	types of files cannot be significantly reduced in size.
   MinIO will *not* compress these, even if specified in an :mc-conf:`~compression.mime_types` argument.
   See :ref:`Excluded types <minio-data-compression-excluded-types>` for details.

.. end-minio-data-compression-mime_types-desc

.. start-minio-data-compression-default-excluded-desc

.. list-table::
   :header-rows: 1
   :widths: 30 30 40
   :width: 100%

   * - Object Type
     - File Extension
     - Media (MIME) Type

   * - Audio
     -
     - ``audio/*``

   * - Video
     - | ``*.mp4``
       | ``*.mkv``
       | ``*.mov``
     - ``video/*``

   * - Image
     - | ``*.jpg``
       | ``*.png``
       | ``*.gif``
     - ``application/x-compress`` (LZW)

   * - 7ZIP Compressed
     - ``*.7z``
     -

   * - BZIP2 Compressed
     - ``*.bz2``
     - ``application/x-bz2``

   * - GZIP Compressed
     - ``*.gz``
     - ``application/x-gzip``

   * - RAR Compressed
     - ``*.rar``
     -

   * - LZMA Compressed
     - ``*.xz``
     - ``application/x-xz``

   * - ZIP Compressed
     - ``*.zip``
     - | ``application/zip``
       | ``application-x-zip-compressed``

.. end-minio-data-compression-default-excluded-desc

.. start-minio-data-compression-default-desc

+-----------------+--------------------------+
| File Extensions | Media (MIME) Types       |
+=================+==========================+
| ``.txt``        | ``text/*``               |
|                 |                          |
| ``.log``        | ``application/json``     |
|                 |                          |
| ``.csv``        | ``application/xml``      |
|                 |                          |
| ``.json``       | ``binary/octet-stream``  |
|                 |                          |
| ``.tar``        |                          |
|                 |                          |
| ``.xml``        |                          |
|                 |                          |
| ``.bin``        |                          |
+-----------------+--------------------------+

.. end-minio-data-compression-default-desc

.. start-minio-api-sync-events

Enables synchronous :ref:`bucket notifications <minio-bucket-notifications>`.

Specify ``on`` to direct MinIO to wait until the remote target returns success on receipt of an event before processing further events.

Defaults to ``off``, or asynchronous bucket notifications where MinIO does not wait for the remote target to return success on receipt of an event.

.. end-minio-api-sync-events
