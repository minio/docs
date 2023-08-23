.. _minio-mc-admin-config:

===================
``mc admin config``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin config

Description
-----------

.. start-mc-admin-config-desc

The :mc:`mc admin config` command manages configuration settings for the
:mc:`minio` server.

.. end-mc-admin-bucket-remote-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Examples
--------

Syntax
------

.. mc-cmd:: set
   :fullpath:

   Sets a :ref:`configuration key <minio-server-configuration-settings>` on the MinIO deployment.
   Configurations defined by environment variables override configurations defined by this command.

   For distributed deployments, use to modify existing endpoints.

   Endpoints using the http protocol can be either the hostname or IP address, and they may use either ``http`` or ``https``.

.. mc-cmd:: get
   :fullpath:

   Gets a :ref:`configuration key <minio-server-configuration-settings>` on the MinIO deployment created using `mc admin config set`.

.. mc-cmd:: export
   :fullpath:

   Exports any configuration settings created using `mc admin config set`.

.. mc-cmd:: history
   :fullpath:

   Lists the history of changes made to configuration keys by `mc admin config`.

   Configurations defined by environment variables do not show.

.. mc-cmd:: import
   :fullpath:

   Imports configuration settings exported using `mc admin config export`.

.. mc-cmd:: reset
   :fullpath:

   Resets config to defaults.
   Configurations defined in environment variables are not affected.

.. mc-cmd:: restore
   :fullpath:

   Roll back changes to configuration keys to a previous point in history.

   Does not affect configurations defined by environment variables.
   
.. _minio-server-configuration-settings:

Configuration Settings
----------------------

The following configuration settings define runtime behavior of the 
MinIO :mc:`server <minio server>` process:

API Configuration
~~~~~~~~~~~~~~~~~

.. mc-conf:: api

   The top-level configuration key for modifying API-related operations.

   .. mc-conf:: root_access

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-root-api-access
         :end-before: end-minio-root-api-access

      This configuration setting corresponds with the :envvar:`MINIO_API_ROOT_ACCESS` environment variable.
      To reset after an unintentional lock, set :envvar:`MINIO_API_ROOT_ACCESS` ``on`` to override this setting and temporarily re-enable the root account.
      You can then change this setting to ``on`` *or* make the necessary user/policy changes to ensure normal administrative access through other non-root accounts.

   .. mc-conf:: sync_events

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-api-sync-events
         :end-before: end-minio-api-sync-events

      This configuration setting corresponds with the :envvar:`MINIO_API_SYNC_EVENTS` environment variable.

.. _minio-server-config-logging-logs:

HTTP Webhook Log Target
~~~~~~~~~~~~~~~~~~~~~~~

.. mc-conf:: logger_webhook

   The top-level configuration key for defining an HTTP webhook target for
   publishing :ref:`MinIO logs <minio-logging>`. 

   Use :mc-cmd:`mc admin config set` to set or update an HTTP webhook target.
   Specify additional optional arguments as a whitespace (``" "``)-delimited 
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set logger_webhook \
         endpoint="http://webhook.example.net" [ARGUMENTS=VALUE ...]

   You can specify multiple HTTP webhook targets by appending 
   ``[:name]`` to the top-level key. For example, the following commands
   set two distinct HTTP webhook targets as ``primary`` and ``secondary``
   respectively:

   .. code-block:: shell
      :class: copyable

      mc admin config set logger_webhook:primary \
         endpoint="http://webhook-01.example.net" [ARGUMENTS=VALUE ...]


      mc admin config set logger_webhook:secondary \
         endpoint="http://webhook-02.example.net" [ARGUMENTS=VALUE ...]

   The :mc-conf:`logger_webhook` configuration key accepts the following 
   arguments:

   .. mc-conf:: endpoint

      *Required*

      The HTTP endpoint of the webhook.

      This configuration setting corresponds with the :envvar:`MINIO_LOGGER_WEBHOOK_ENDPOINT` environment variable.

   .. mc-conf:: auth_token

      *Optional*

      The JSON Web Token (JWT) to use for authenticating to the HTTP webhook.
      Omit for webhooks which do not enforce authentication.

      This configuration setting corresponds with the :envvar:`MINIO_LOGGER_WEBHOOK_AUTH_TOKEN` environment variable.

   .. mc-conf:: client_cert

      *Optional*

      The path to the mTLS certificate to use for authenticating to the webhook logger.

      This configuration setting corresponds with the :envvar:`MINIO_LOGGER_WEBHOOK_CLIENT_CERT` environment variable.

   .. mc-conf:: client_key

      *Optional*

      The path to the mTLS certificate key to use to authenticate with the webhook logger service.

      This configuration setting corresponds with the :envvar:`MINIO_LOGGER_WEBHOOK_CLIENT_KEY` environment variable.

   .. mc-conf:: proxy

      .. versionadded:: MinIO RELEASE.2023-02-22T18-23-45Z 

      *Optional*

      Define a proxy to use for the webhook logger when communicating from MinIO to external webhooks.

      This configuration setting corresponds with the :envvar:`MINIO_LOGGER_WEBHOOK_PROXY` environment variable.

   .. mc-conf:: queue_dir

      .. versionadded:: RELEASE.2023-05-18T00-05-36Z

      *Optional*

      Specify the directory path, such as ``/opt/minio/events``, to enable MinIO's persistent event store for undelivered messages.
      The MinIO process must have read, write, and list access on the specified directory.

      MinIO stores undelivered events in the specified store while the webhook service is offline and replays the stored events when connectivity resumes.

      This configuration setting corresponds with the :envvar:`MINIO_LOGGER_WEBHOOK_QUEUE_DIR` environment variable.

   .. mc-conf:: queue_size

      *Optional*

      An integer value to use for the queue size for logger webhook targets.
      The default is ``100000`` events.

      This configuration setting corresponds with the :envvar:`MINIO_LOGGER_WEBHOOK_QUEUE_SIZE` environment variable.

.. _minio-server-config-logging-audit:

HTTP Webhook Audit Log Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. mc-conf:: audit_webhook

   The top-level configuration key for defining an HTTP webhook target for
   publishing :ref:`MinIO audit logs <minio-logging>`. 

   Use :mc-cmd:`mc admin config set` to set or update an HTTP webhook target.
   Specify additional optional arguments as a whitespace (``" "``)-delimited 
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set audit_webhook \
         endpoint="http://webhook.example.net" [ARGUMENTS=VALUE ...]

   You can specify multiple HTTP webhook targets by appending 
   ``[:name]`` to the top-level key. For example, the following commands
   set two distinct HTTP webhook targets as ``primary`` and ``secondary``
   respectively:

   .. code-block:: shell
      :class: copyable

      mc admin config set audit_webhook:primary \
         endpoint="http://webhook-01.example.net" [ARGUMENTS=VALUE ...]


      mc admin config set audit_webhook:secondary \
         endpoint="http://webhook-02.example.net" [ARGUMENTS=VALUE ...]

   The :mc-conf:`audit_webhook` configuration key accepts the following 
   arguments:

   .. mc-conf:: endpoint

      *Required*

      The HTTP endpoint of the webhook.

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_WEBHOOK_ENDPOINT` environment variable.

   .. mc-conf:: auth_token
      
      *Optional*

      The JSON Web Token (JWT) to use for authenticating to the HTTP webhook.
      Omit for webhooks which do not enforce authentication.

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_WEBHOOK_AUTH_TOKEN` environment variable.

   .. mc-conf:: client_cert

      *Optional*

      The x.509 client certificate to present to the HTTP webhook. Omit for
      webhooks which do not require clients to present a known TLS certificate.

      Requires specifying :mc-conf:`~audit_webhook.client_key`.

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_WEBHOOK_CLIENT_CERT` environment variable.

   .. mc-conf:: client_key

      *Optional*

      The x.509 private key to present to the HTTP webhook. Omit for
      webhooks which do not require clients to present a known TLS certificate.

      Requires specifying :mc-conf:`~audit_webhook.client_cert`.

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_WEBHOOK_CLIENT_KEY` environment variable.

   .. mc-conf:: queue_dir

      .. versionadded:: RELEASE.2023-05-18T00-05-36Z

      *Optional*

      Specify the directory path, such as ``/opt/minio/events``, to enable MinIO's persistent event store for undelivered messages.
      The MinIO process must have read, write, and list access on the specified directory.

      MinIO stores undelivered events in the specified store while the webhook service is offline and replays the stored events when connectivity resumes.

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_WEBHOOK_QUEUE_DIR` environment variable.

   .. mc-conf:: queue_size

      *Optional*

      An integer value to use for the queue size for webhook targets.
      The default is ``100000`` events.

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_WEBHOOK_QUEUE_SIZE` environment variable.

.. _minio-server-config-logging-kafka-audit:

Kafka Audit Log Target
~~~~~~~~~~~~~~~~~~~~~~

.. mc-conf:: audit_kafka

   The top-level configuration key for defining a Kafka broker target for publishing :ref:`MinIO audit logs <minio-logging>`.

   Use :mc-cmd:`mc admin config set` to set or update a Kafka audit target.
   Specify additional optional arguments as a whitespace (``" "``)-delimited list.

   .. code-block:: shell
      :class: copyable

      mc admin config set audit_kafka \
         brokers="https://kafka-endpoint.example.net:9092" [ARGUMENTS=VALUE ...]

   The :mc-conf:`audit_kafka` configuration key accepts the following arguments:

   .. mc-conf:: brokers
      :required:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-brokers-desc
         :end-before: end-minio-kafka-audit-logging-brokers-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_BROKERS` environment variable.

   .. mc-conf:: topic
      :required:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-topic-desc
         :end-before: end-minio-kafka-audit-logging-topic-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_TOPIC` environment variable.

   .. mc-conf:: tls
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-tls-desc
         :end-before: end-minio-kafka-audit-logging-tls-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_TLS` environment variable.

   .. mc-conf:: tls_skip_verify
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-tls-skip-verify-desc
         :end-before: end-minio-kafka-audit-logging-tls-skip-verify-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_TLS_SKIP_VERIFY` environment variable.

   .. mc-conf:: tls_client_auth
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-tls-client-auth-desc
         :end-before: end-minio-kafka-audit-logging-tls-client-auth-desc

      Requires specifying :mc-conf:`~audit_kafka.client_tls_cert` and :mc-conf:`~audit_kafka.client_tls_key`.

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_TLS_CLIENT_AUTH` environment variable.

   .. mc-conf:: client_tls_cert
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-client-tls-cert-desc
         :end-before: end-minio-kafka-audit-logging-client-tls-cert-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_CLIENT_TLS_CERT` environment variable.


   .. mc-conf:: client_tls_key
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-client-tls-key-desc
         :end-before: end-minio-kafka-audit-logging-client-tls-key-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_CLIENT_TLS_KEY` environment variable.

   .. mc-conf:: sasl
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-sasl-desc
         :end-before: end-minio-kafka-audit-logging-sasl-desc

      Requires specifying :mc-conf:`~audit_kafka.sasl_username` and :mc-conf:`~audit_kafka.sasl_password`.

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_SASL` environment variable.


   .. mc-conf:: sasl_username
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-sasl-username-desc
         :end-before: end-minio-kafka-audit-logging-sasl-username-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_SASL_USERNAME` environment variable.

   .. mc-conf:: sasl_password
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-sasl-password-desc
         :end-before: end-minio-kafka-audit-logging-sasl-password-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_SASL_PASSWORD` environment variable.

   .. mc-conf:: sasl_mechanism
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-sasl-mechanism-desc
         :end-before: end-minio-kafka-audit-logging-sasl-mechanism-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_SASL_MECHANISM` environment variable.

      .. important::

         The ``PLAIN`` authentication mechanism sends credentials in plain text over the network.
         Use :mc-conf:`~audit_kafka.tls` to enable TLS connectivity to the Kafka brokers and ensure secure transmission of SASL credentials.

   .. mc-conf:: version
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-version-desc
         :end-before: end-minio-kafka-audit-logging-version-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_VERSION` environment variable.

   .. mc-conf:: comment
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-comment-desc
         :end-before: end-minio-kafka-audit-logging-comment-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_COMMENT` environment variable.

   .. mc-conf:: queue_dir
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-queue-dir-desc
         :end-before: end-minio-kafka-audit-logging-queue-dir-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_QUEUE_DIR` environment variable.

   .. mc-conf::	queue_size
      :optional:
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-kafka-audit-logging-queue-size-desc
         :end-before: end-minio-kafka-audit-logging-queue-size-desc

      This configuration setting corresponds with the :envvar:`MINIO_AUDIT_KAFKA_QUEUE_SIZE` environment variable.

.. _minio-server-config-bucket-notification-amqp:

AMQP Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an AMQP
service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-amqp` for a tutorial on 
using these environment variables.

.. mc-conf:: notify_amqp

   The top-level configuration key for defining an AMQP service endpoint for use
   with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an AMQP service endpoint. 
   The :mc-conf:`~notify_amqp.url` argument is *required* for each target.
   Specify additional optional arguments as a whitespace (``" "``)-delimited 
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_amqp \ 
        url="amqp://user:password@endpoint:port" \
        [ARGUMENT="VALUE"] ... \

   You can specify multiple AMQP service endpoints by appending ``[:name]`` to
   the top level key. For example, the following commands set two distinct AMQP
   service endpoints as ``primary`` and ``secondary`` respectively:

   .. code-block:: shell

      mc admin config set notify_amqp:primary \ 
         url="user:password@amqp://endpoint:port" [ARGUMENT=VALUE ...]

      mc admin config set notify_amqp:secondary \
         url="user:password@amqp://endpoint:port" [ARGUMENT=VALUE ...]

   The :mc-conf:`notify_amqp` configuration key supports the following 
   arguments:

   .. mc-conf:: url
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-url
         :end-before:  end-minio-notify-amqp-url

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_URL` environment variable. 

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: exchange 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-exchange
         :end-before:  end-minio-notify-amqp-exchange

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_EXCHANGE` environment variable.

   .. mc-conf:: exchange_type 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-exchange-type
         :end-before:  end-minio-notify-amqp-exchange-type

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_EXCHANGE_TYPE` environment variable.

   .. mc-conf:: routing_key 
      :delimiter: " "

      *Optional*
   
      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-routing-key
         :end-before:  end-minio-notify-amqp-routing-key

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_ROUTING_KEY` environment variable.

   .. mc-conf:: mandatory 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-mandatory
         :end-before:  end-minio-notify-amqp-mandatory

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_MANDATORY` environment variable.

   .. mc-conf:: durable 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-durable
         :end-before:  end-minio-notify-amqp-durable

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_DURABLE` environment variable.

   .. mc-conf:: no_wait 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-no-wait
         :end-before:  end-minio-notify-amqp-no-wait

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_NO_WAIT` environment variable.

   .. mc-conf:: internal 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-internal
         :end-before:  end-minio-notify-amqp-internal

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_INTERNAL` environment variable.

   .. explanation is very unclear. Need to revisit this.

   .. mc-conf:: auto_deleted 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-auto-deleted
         :end-before:  end-minio-notify-amqp-auto-deleted

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_AUTO_DELETED` environment variable.

   .. mc-conf:: delivery_mode 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-delivery-mode
         :end-before:  end-minio-notify-amqp-delivery-mode

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_DELIVERY_MODE` environment variable.

   .. mc-conf:: queue_dir 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-queue-dir
         :end-before:  end-minio-notify-amqp-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_QUEUE_DIR` environment variable.

   .. mc-conf:: queue_limit 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-queue-limit
         :end-before:  end-minio-notify-amqp-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_QUEUE_LIMIT` environment variable.

   .. mc-conf:: comment 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-comment
         :end-before:  end-minio-notify-amqp-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_AMQP_COMMENT` environment variable.

.. _minio-server-config-bucket-notification-mqtt:

MQTT Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an MQTT
server/broker as a publishing target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-mqtt` for a tutorial on 
using these configuration settings.

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

.. _minio-server-config-bucket-notification-elasticsearch:

Elasticsearch Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an Elasticsearch
service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-elasticsearch` for a tutorial on using
these configuration settings.

.. mc-conf:: notify_elasticsearch

   The top-level configuration key for defining an Elasticsearch service
   endpoint for use with :ref:`MinIO bucket notifications
   <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an Elasticsearch service
   endpoint. The following arguments are *required* for each target:
   
   - :mc-conf:`~notify_elasticsearch.url`
   - :mc-conf:`~notify_elasticsearch.index`
   - :mc-conf:`~notify_elasticsearch.format`
   
   Specify additional optional arguments as a whitespace (``" "``)-delimited
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_elasticsearch \ 
        url="https://user:password@endpoint:port" \
        [ARGUMENT="VALUE"] ... \

   You can specify multiple Elasticsearch service endpoints by appending
   ``[:name]`` to the top level key. For example, the following commands set two
   distinct Elasticsearch service endpoints as ``primary`` and ``secondary``
   respectively:

   .. code-block:: shell

      mc admin config set notify_elasticsearch:primary \ 
         url="user:password@https://endpoint:port" [ARGUMENT=VALUE ...]

      mc admin config set notify_elasticsearch:secondary \
         url="user:password@https://endpoint:port" [ARGUMENT=VALUE ...]

   The :mc-conf:`notify_elasticsearch` configuration key supports the following 
   arguments:

   .. mc-conf:: url
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-url
         :end-before: end-minio-notify-elasticsearch-url

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_URL` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: index
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-index
         :end-before: end-minio-notify-elasticsearch-index

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_INDEX` environment variable.

   .. mc-conf:: format
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-format
         :end-before: end-minio-notify-elasticsearch-format

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_FORMAT` environment variable.

   .. mc-conf:: username
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-username
         :end-before: end-minio-notify-elasticsearch-username

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_USERNAME` environment variable.

   .. mc-conf:: password
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-password
         :end-before: end-minio-notify-elasticsearch-password

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_PASSWORD` environment variable.

   .. mc-conf:: queue_dir 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-queue-dir
         :end-before:  end-minio-notify-elasticsearch-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_QUEUE_DIR` environment variable.

   .. mc-conf:: queue_limit 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-queue-limit
         :end-before:  end-minio-notify-elasticsearch-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_QUEUE_LIMIT` environment variable.

   .. mc-conf:: comment 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-comment
         :end-before:  end-minio-notify-elasticsearch-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_COMMENT` environment variable.


.. _minio-server-config-bucket-notification-nsq:

NSQ Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an NSQ
server/broker as a publishing target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-nsq` for a tutorial on 
using these configuration settings.

.. mc-conf:: notify_nsq

   The top-level configuration key for defining an NSQ server/broker endpoint
   for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an NSQ server/broker
   endpoint. The following arguments are *required* for each endpoint: 
   
   - :mc-conf:`~notify_nsq.nsqd_address`
   - :mc-conf:`~notify_nsq.topic`

   Specify additional optional arguments as a whitespace (``" "``)-delimited
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_nsq \ 
         nsqd_address="ENDPOINT" \
         topic="<string>" \
         [ARGUMENT="VALUE"] ... \

   You can specify multiple NSQ server/broker endpoints by appending
   ``[:name]`` to the top level key. For example, the following commands set two
   distinct NSQ service endpoints as ``primary`` and ``secondary``
   respectively:

   .. code-block:: shell

      mc admin config set notify_nsq:primary \ 
         nsqd_address="ENDPOINT" \
         topic="<string>" \
         [ARGUMENT="VALUE"] ... \

      mc admin config set notify_nsq:secondary \
         nsqd_address="ENDPOINT" \
         topic="<string>" \
         [ARGUMENT="VALUE"] ... \

   The :mc-conf:`notify_nsq` configuration key supports the following 
   arguments:


   .. mc-conf:: nsqd_address
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-nsqd-address
         :end-before: end-minio-notify-nsq-nsqd-address

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_NSQD_ADDRESS` environment variable.
      
      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: topic
      :delimiter: " "

      *Required*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-topic
         :end-before: end-minio-notify-nsq-topic

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_TOPIC` environment variable.
      
   .. mc-conf:: tls
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-tls
         :end-before: end-minio-notify-nsq-tls

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_TLS` environment variable.
      
      
   .. mc-conf:: tls_skip_verify
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-tls-skip-verify
         :end-before: end-minio-notify-nsq-tls-skip-verify

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_TLS_SKIP_VERIFY` environment variable.
     
      
   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-queue-dir
         :end-before: end-minio-notify-nsq-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_QUEUE_DIR` environment variable.
      
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-queue-limit
         :end-before: end-minio-notify-nsq-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-comment
         :end-before: end-minio-notify-nsq-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_COMMENT` environment variable.


.. _minio-server-config-bucket-notification-redis:

Redis Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an Redis
server/broker as a publishing target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-redis` for a tutorial on 
using these configuration settings.

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



.. _minio-server-config-bucket-notification-nats:

NATS Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an NATS
service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-nats` for a tutorial on 
using these environment variables.

.. admonition:: NATS Streaming Deprecated
   :class: important

   NATS Streaming is deprecated.
   Migrate to `JetStream <https://docs.nats.io/nats-concepts/jetstream>`__ instead. 

   The related MinIO configuration options and environment variables are deprecated. 

.. mc-conf:: notify_nats

   The top-level configuration key for defining an NATS service endpoint for use
   with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an NATS service endpoint. 
   The :mc-conf:`~notify_nats.address` and 
   :mc-conf:`~notify_nats.subject` arguments are *required* for each target.
   Specify additional optional arguments as a whitespace (``" "``)-delimited 
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_nats \ 
        address="htpps://nats-endpoint.example.com:4222" \
        subject="minioevents" \
        [ARGUMENT="VALUE"] ... \

   You can specify multiple NATS service endpoints by appending ``[:name]`` to
   the top level key. For example, the following commands set two distinct NATS
   service endpoints as ``primary`` and ``secondary`` respectively:

   .. code-block:: shell

      mc admin config set notify_nats:primary \ 
         address="htpps://nats-endpoint.example.com:4222" \
         subject="minioevents" \ 
         [ARGUMENT=VALUE ...]

      mc admin config set notify_nats:secondary \
         address="htpps://nats-endpoint.example.com:4222" \
         subject="minioevents" \ 
         [ARGUMENT=VALUE ...]

   The :mc-conf:`notify_nats` configuration key supports the following 
   arguments:
   
   .. mc-conf:: address
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-address
         :end-before: end-minio-notify-nats-address

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_ADDRESS`.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: subject
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-subject
         :end-before: end-minio-notify-nats-subject

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_SUBJECT`.

   .. mc-conf:: username
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-username
         :end-before: end-minio-notify-nats-username

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_USERNAME`.

   .. mc-conf:: password
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-password
         :end-before: end-minio-notify-nats-password

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_PASSWORD`.

   .. mc-conf:: token
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-token
         :end-before: end-minio-notify-nats-token

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_TOKEN`.

   .. mc-conf:: tls
      :delimiter: "
      
      *Optional*"

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-tls
         :end-before: end-minio-notify-nats-tls

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_TLS`.

   .. mc-conf:: tls_skip_verify
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-tls-skip-verify
         :end-before: end-minio-notify-nats-tls-skip-verify

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_TLS_SKIP_VERIFY`.

   .. mc-conf:: ping_interval
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-ping-interval
         :end-before: end-minio-notify-nats-ping-interval

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_PING_INTERVAL`.

   .. mc-conf:: jetstream
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-jetstream
         :end-before: end-minio-notify-nats-jetstream

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_JETSTREAM`.

   .. mc-conf:: streaming
      :delimiter: " "

      *Deprecated*

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming
         :end-before: end-minio-notify-nats-streaming

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_STREAMING`.

   .. mc-conf:: streaming_async
      :delimiter: " "

      *Deprecated*
 
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming-async
         :end-before: end-minio-notify-nats-streaming-async

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_STREAMING_ASYNC`.

   .. mc-conf:: streaming_max_pub_acks_in_flight
      :delimiter: " "

      *Deprecated*
 
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming-max-pub-acks-in-flight
         :end-before: end-minio-notify-nats-streaming-max-pub-acks-in-flight

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_STREAMING_MAX_PUB_ACKS_IN_FLIGHT`.

   .. mc-conf:: streaming_cluster_id
      :delimiter: " "

      *Deprecated*
 
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming-cluster-id
         :end-before: end-minio-notify-nats-streaming-cluster-id

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_STREAMING_CLUSTER_ID`.

   .. mc-conf:: cert_authority
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-cert-authority
         :end-before: end-minio-notify-nats-cert-authority

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_CERT_AUTHORITY`.

   .. mc-conf:: client_cert
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-client-cert
         :end-before: end-minio-notify-nats-client-cert

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_CLIENT_CERT`.

   .. mc-conf:: client_key
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-client-key
         :end-before: end-minio-notify-nats-client-key

      This configuration setting corresponds with the environment variable :envvar:`MINIO_NOTIFY_NATS_CLIENT_KEY`.

   
   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-queue-dir
         :end-before: end-minio-notify-nats-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-queue-limit
         :end-before: end-minio-notify-nats-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-comment
         :end-before: end-minio-notify-nats-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_COMMENT` environment variable.

.. _minio-server-config-bucket-notification-postgresql:

PostgreSQL Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an PostgreSQL
service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-postgresql` for a tutorial on 
using these environment variables.

.. mc-conf:: notify_postgres

   The top-level configuration key for defining an PostgreSQL service endpoint for use
   with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an PostgreSQL service endpoint. 
   The following arguments are *required* for each target: 
   
   - :mc-conf:`~notify_postgres.connection_string`
   - :mc-conf:`~notify_postgres.table`
   - :mc-conf:`~notify_postgres.format`

   Specify additional optional arguments as a whitespace (``" "``)-delimited 
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_postgres \ 
        connection_string="host=postgresql.example.com port=5432..."
        table="minioevents" \
        format="namespace" \
        [ARGUMENT="VALUE"] ... \

   You can specify multiple PostgreSQL service endpoints by appending ``[:name]`` to
   the top level key. For example, the following commands set two distinct PostgreSQL
   service endpoints as ``primary`` and ``secondary`` respectively:

   .. code-block:: shell

      mc admin config set notify_postgres:primary \ 
         connection_string="host=postgresql.example.com port=5432..."
         table="minioevents" \
         format="namespace" \
         [ARGUMENT=VALUE ...]

      mc admin config set notify_postgres:secondary \
         connection_string="host=postgresql.example.com port=5432..."
         table="minioevents" \
         format="namespace" \
         [ARGUMENT=VALUE ...]

   The :mc-conf:`notify_postgres` configuration key supports the following 
   arguments:

   .. mc-conf:: connection_string
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-connection-string
         :end-before: end-minio-notify-postgresql-connection-string
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_CONNECTION_STRING` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: table
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-table
         :end-before: end-minio-notify-postgresql-table
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_TABLE` environment variable.

   .. mc-conf:: format
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-format
         :end-before: end-minio-notify-postgresql-format
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_FORMAT` environment variable.

   .. mc-conf:: max_open_connections
      :delimiter: " "
      
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-max-open-connections
         :end-before: end-minio-notify-postgresql-max-open-connections
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_MAX_OPEN_CONNECTIONS` environment variable.


   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-queue-dir
         :end-before: end-minio-notify-postgresql-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-queue-limit
         :end-before: end-minio-notify-postgresql-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-comment
         :end-before: end-minio-notify-postgresql-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_COMMENT` environment variable.

.. _minio-server-config-bucket-notification-mysql:

MySQL Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an MySQL
service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-mysql` for a tutorial on 
using these environment variables.

.. mc-conf:: notify_mysql

   The top-level configuration key for defining an MySQL service endpoint for use
   with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an MySQL service endpoint. 
   The following arguments are *required* for each target: 
   
   - :mc-conf:`~notify_mysql.dsn_string`
   - :mc-conf:`~notify_mysql.table`
   - :mc-conf:`~notify_mysql.format`

   Specify additional optional arguments as a whitespace (``" "``)-delimited 
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_mysql \ 
        dsn_string="username:password@tcp(mysql.example.com:3306)/miniodb"
        table="minioevents" \
        format="namespace" \
        [ARGUMENT="VALUE"] ... \

   You can specify multiple MySQL service endpoints by appending ``[:name]`` to
   the top level key. For example, the following commands set two distinct MySQL
   service endpoints as ``primary`` and ``secondary`` respectively:

   .. code-block:: shell

      mc admin config set notify_mysql:primary \ 
         dsn_string="username:password@tcp(mysql.example.com:3306)/miniodb"
         table="minioevents" \
         format="namespace" \
         [ARGUMENT=VALUE ...]

      mc admin config set notify_mysql:secondary \
         dsn_string="username:password@tcp(mysql.example.com:3306)/miniodb"
         table="minioevents" \
         format="namespace" \
         [ARGUMENT=VALUE ...]

   The :mc-conf:`notify_mysql` configuration key supports the following 
   arguments:

   .. mc-conf:: dsn_string
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-connection-string
         :end-before: end-minio-notify-mysql-connection-string
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_DSN_STRING` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: table
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-table
         :end-before: end-minio-notify-mysql-table
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_TABLE` environment variable.

   .. mc-conf:: format
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-format
         :end-before: end-minio-notify-mysql-format
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_FORMAT` environment variable.

   .. mc-conf:: max_open_connections
      :delimiter: " "
      
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-max-open-connections
         :end-before: end-minio-notify-mysql-max-open-connections
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_MAX_OPEN_CONNECTIONS` environment variable.


   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-queue-dir
         :end-before: end-minio-notify-mysql-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-queue-limit
         :end-before: end-minio-notify-mysql-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-comment
         :end-before: end-minio-notify-mysql-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_COMMENT` environment variable.

.. _minio-server-config-bucket-notification-kafka:

Kafka Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an Kafka
service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-kafka` for a tutorial on 
using these environment variables.

.. mc-conf:: notify_kafka

   The top-level configuration key for defining an Kafka service endpoint for
   use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an Kafka service endpoint.
   The :mc-conf:`~notify_kafka.brokers` argument is *required* for each target.
   Specify additional optional arguments as a whitespace (``" "``)-delimited
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_kafka \ 
        brokers="https://kafka1.example.net:9200, https://kafka2.example.net:9200"
        [ARGUMENT="VALUE"] ... \

   You can specify multiple Kafka service endpoints by appending ``[:name]`` to
   the top level key. For example, the following commands set two distinct Kafka
   service endpoints as ``primary`` and ``secondary`` respectively:

   .. code-block:: shell

      mc admin config set notify_kafka:primary \ 
         brokers="https://kafka1.example.net:9200, https://kafka2.example.net:9200"
         [ARGUMENT=VALUE ...]

      mc admin config set notify_kafka:secondary \
         brokers="https://kafka1.example.net:9200, https://kafka2.example.net:9200"
         [ARGUMENT=VALUE ...]

   The :mc-conf:`notify_kafka` configuration key supports the following 
   arguments:

   .. mc-conf:: brokers
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-brokers
         :end-before: end-minio-notify-kafka-brokers

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_BROKERS` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: topic
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-topic
         :end-before: end-minio-notify-kafka-topic

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_TOPIC` environment variable.

   .. mc-conf:: sasl
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-sasl-root
         :end-before: end-minio-notify-kafka-sasl-root

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_SASL` environment variable.

   .. mc-conf:: sasl_username
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-sasl-username
         :end-before: end-minio-notify-kafka-sasl-username

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_SASL_USERNAME` environment variable.

   .. mc-conf:: sasl_password
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-sasl-password
         :end-before: end-minio-notify-kafka-sasl-password

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_SASL_PASSWORD` environment variable.

   .. mc-conf:: sasl_mechanism
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-sasl-mechanism
         :end-before: end-minio-notify-kafka-sasl-mechanism

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_SASL_MECHANISM` environment variable.

   .. mc-conf:: tls_client_auth
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-tls-client-auth
         :end-before: end-minio-notify-kafka-tls-client-auth

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_TLS_CLIENT_AUTH` environment variable.

   .. mc-conf:: tls
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-tls-root
         :end-before: end-minio-notify-kafka-tls-root

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_TLS` environment variable.

   .. mc-conf:: tls_skip_verify
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-tls-skip-verify
         :end-before: end-minio-notify-kafka-tls-skip-verify

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_TLS_SKIP_VERIFY` environment variable.

   .. mc-conf:: client_tls_cert
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-client-tls-cert
         :end-before: end-minio-notify-kafka-client-tls-cert

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_CLIENT_TLS_CERT` environment variable.

   .. mc-conf:: client_tls_key
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-client-tls-key
         :end-before: end-minio-notify-kafka-client-tls-key

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_CLIENT_TLS_KEY` environment variable.

   .. mc-conf:: version
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-version
         :end-before: end-minio-notify-kafka-version

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_VERSION` environment variable.


   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-queue-dir
         :end-before: end-minio-notify-kafka-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-queue-limit
         :end-before: end-minio-notify-kafka-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-comment
         :end-before: end-minio-notify-kafka-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_KAFKA_COMMENT` environment variable.

.. _minio-server-config-bucket-notification-webhook:

Webhook Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an Webhook
service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-webhook` for a tutorial on 
using these environment variables.

.. mc-conf:: notify_webhook

   The top-level configuration key for defining an Webhook service endpoint for use
   with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an Webhook service endpoint.
   The :mc-conf:`~notify_webhook.endpoint` argument is *required* for each target.
   Specify additional optional arguments as a whitespace (``" "``)-delimited
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_webhook \ 
        endpoint="https://webhook.example.net"
        [ARGUMENT="VALUE"] ... \

   You can specify multiple Webhook service endpoints by appending ``[:name]`` to
   the top level key. For example, the following commands set two distinct Webhook
   service endpoints as ``primary`` and ``secondary`` respectively:

   .. code-block:: shell

      mc admin config set notify_webhook:primary \ 
         endpoint="https://webhook1.example.net"
         [ARGUMENT=VALUE ...]

      mc admin config set notify_webhook:secondary \
         endpoint="https://webhook2.example.net
         [ARGUMENT=VALUE ...]

   The :mc-conf:`notify_webhook` configuration key supports the following 
   arguments:

   .. mc-conf:: endpoint
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-endpoint
         :end-before: end-minio-notify-webhook-endpoint

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_ENDPOINT` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: auth_token
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-auth-token
         :end-before: end-minio-notify-webhook-auth-token

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_AUTH_TOKEN` environment variable.

   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-queue-dir
         :end-before: end-minio-notify-webhook-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_QUEUE_DIR` environment variable.

   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-queue-limit
         :end-before: end-minio-notify-webhook-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_QUEUE_LIMIT` environment variable.

   .. mc-conf:: client_cert
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-client-cert
         :end-before: end-minio-notify-webhook-client-cert

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_CLIENT_CERT` environment variable.

   .. mc-conf:: client_key
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-client-key
         :end-before: end-minio-notify-webhook-client-key

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_CLIENT_KEY` environment variable.

   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-comment
         :end-before: end-minio-notify-webhook-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_COMMENT` environment variable.

.. _minio-ldap-config-settings:

Active Directory / LDAP Identity Management
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for enabling external identity 
management using an Active Directory or LDAP service.

.. admonition:: :mc:`mc idp ldap` commands are preferred
   :class: note

   .. versionadded:: RELEASE.2023-05-26T23-31-54Z

      MinIO recommends using the :mc:`mc idp ldap` commands for LDAP management operations.
      These commands offer better validation and additional features, while providing the same settings as the :mc-conf:`identity_ldap` configuration key.
      See :ref:`minio-authenticate-using-ad-ldap-generic` for a tutorial on using :mc:`mc idp ldap`.

      The :mc-conf:`identity_ldap` configuration key remains available for existing scripts and other tools.

.. mc-conf:: identity_ldap

   The top-level key for configuring
   :ref:`external identity management using Active Directory or LDAP 
   <minio-external-identity-management-ad-ldap>`.

   Use the :mc-cmd:`mc admin config set` command to set or update the 
   AD/LDAP configuration. The following arguments are *required*:

   - :mc-conf:`~identity_ldap.server_addr`
   - :mc-conf:`~identity_ldap.lookup_bind_dn`
   - :mc-conf:`~identity_ldap.lookup_bind_password`
   - :mc-conf:`~identity_ldap.user_dn_search_base_dn`
   - :mc-conf:`~identity_ldap.user_dn_search_filter`

   .. code-block:: shell
      :class: copyable

      mc admin config set identity_ldap \
         enabled="true" \
         server_addr="ad-ldap.example.net/" \
         lookup_bind_dn="cn=miniolookupuser,dc=example,dc=net" \
         lookup_bind_dn_password="userpassword" \
         user_dn_search_base_dn="dc=example,dc=net" \
         user_dn_search_filter="(&(objectCategory=user)(sAMAccountName=%s))"

   The :mc-conf:`identity_ldap` configuration key supports the following
   arguments:

   .. mc-conf:: server_addr
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-server-addr
         :end-before: end-minio-ad-ldap-server-addr

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SERVER_ADDR` environment variable.

   .. mc-conf:: lookup_bind_dn
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-lookup-bind-dn
         :end-before: end-minio-ad-ldap-lookup-bind-dn

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN` environment variable.

   .. mc-conf:: lookup_bind_password
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-lookup-bind-password
         :end-before: end-minio-ad-ldap-lookup-bind-password
         
      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD` environment variable.

   .. mc-conf:: user_dn_search_base_dn
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-user-dn-search-base-dn
         :end-before: end-minio-ad-ldap-user-dn-search-base-dn
         
      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN` environment variable.

   .. mc-conf:: user_dn_search_filter
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-user-dn-search-filter
         :end-before: end-minio-ad-ldap-user-dn-search-filter
         
      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER` environment variable.

   .. mc-conf:: enabled
      :delimiter: " "

      *Optional*

      Set to ``false`` to disable the AD/LDAP configuration.

      If ``false``, applications cannot generate STS credentials or otherwise authenticate to MinIO using the configured provider.

      Defaults to ``true`` or "enabled".

   .. mc-conf:: group_search_filter
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-group-search-filter
         :end-before: end-minio-ad-ldap-group-search-filter
         
      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER` environment variable.

   .. mc-conf:: group_search_base_dn
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-group-search-base-dn
         :end-before: end-minio-ad-ldap-group-search-base-dn
         
      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN` environment variable.

   .. mc-conf:: tls_skip_verify
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-tls-skip-verify
         :end-before: end-minio-ad-ldap-tls-skip-verify

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_TLS_SKIP_VERIFY` environment variable.

   .. mc-conf:: server_insecure
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-server-insecure
         :end-before: end-minio-ad-ldap-server-insecure

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SERVER_INSECURE` environment variable.

   .. mc-conf:: server_starttls
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-server-starttls
         :end-before: end-minio-ad-ldap-server-starttls

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SERVER_STARTTLS` environment variable.

   .. mc-conf:: srv_record_name
      :delimiter: " "

      .. versionadded:: RELEASE.2022-12-12T19-27-27Z

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-srv_record_name
         :end-before: end-minio-ad-ldap-srv_record_name

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SRV_RECORD_NAME` environment variable.

   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-comment
         :end-before: end-minio-ad-ldap-comment

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_COMMENT` environment variable.   

.. _minio-open-id-config-settings:

OpenID Identity Management
~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for enabling external identity
management using an OpenID Connect (OIDC)-compatible provider. 
See :ref:`minio-external-identity-management-openid` for a tutorial on using these
configuration settings.

.. mc-conf:: identity_openid

   The top-level configuration key for configuring
   :ref:`external identity management using OpenID <minio-external-identity-management-openid>`.

   Use :mc-cmd:`mc admin config set` to set or update the OpenID configuration.
   The :mc-conf:`~identity_openid.config_url` argument is *required*. Specify
   additional optional arguments as a whitespace (``" "``)-delimited list.

   .. code-block:: shell
      :class: copyable

      mc admin config set identity_openid \ 
        config_url="https://openid-provider.example.net/.well-known/openid-configuration"
        [ARGUMENT="VALUE"] ... \

   The :mc-conf:`identity_openid` configuration key supports the following 
   arguments:

   .. mc-conf:: config_url
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-config-url
         :end-before: end-minio-openid-config-url

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CONFIG_URL` environment variable.

   .. mc-conf:: enabled
      :delimiter: " "

      *Optional*

      Set to ``false`` to disable the OpenID configuration.

      Applications cannot generate STS credentials or otherwise authenticate to MinIO using the configured provider if set to ``false``.

      Defaults to ``true`` or "enabled".

   .. mc-conf:: client_id
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-client-id
         :end-before: end-minio-openid-client-id

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CLIENT_ID` environment variable.

   .. mc-conf:: client_secret
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-client-secret
         :end-before: end-minio-openid-client-secret

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CLIENT_SECRET` environment variable.
      
   .. mc-conf:: claim_name
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-claim-name
         :end-before: end-minio-openid-claim-name

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CLAIM_NAME` environment variable.
      
   .. mc-conf:: claim_prefix
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-claim-prefix
         :end-before: end-minio-openid-claim-prefix

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CLAIM_PREFIX` environment variable.

   .. mc-conf:: display_name
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-display-name
         :end-before: end-minio-openid-display-name

   .. mc-conf:: scopes
      :delimiter: " "

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-scopes
         :end-before: end-minio-openid-scopes

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_SCOPES` environment variable.
      
   .. mc-conf:: redirect_uri
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-redirect-uri
         :end-before: end-minio-openid-redirect-uri

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_REDIRECT_URI` environment variable.

   .. mc-conf:: redirect_uri_dynamic
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-redirect-uri-dynamic
         :end-before: end-minio-openid-redirect-uri-dynamic

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_REDIRECT_URI_DYNAMIC` environment variable.

   .. mc-conf:: claim_userinfo
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-claim-userinfo
         :end-before: end-minio-openid-claim-userinfo

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CLAIM_USERINFO` environment variable.

   .. mc-conf:: vendor
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-vendor
         :end-before: end-minio-openid-vendor

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_VENDOR` environment variable.

   .. mc-conf:: keycloak_realm
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-keycloak-realm
         :end-before: end-minio-openid-keycloak-realm

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_KEYCLOAK_REALM` environment variable.

      Requires :mc-conf:`identity_openid.vendor` set to ``keycloak``.

   .. mc-conf:: keycloak_admin_url
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-keycloak-admin-url
         :end-before: end-minio-openid-keycloak-admin-url

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_KEYCLOAK_ADMIN_URL` environment variable.

      Requires :mc-conf:`identity_openid.vendor` set to ``keycloak``.


   .. mc-conf:: comment
      :delimiter: " "

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-comment
         :end-before: end-minio-openid-comment

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_COMMENT` environment variable.

.. _minio-identity-management-plugin-settings:

Identity Management Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for enabling external identity management using the MinIO Identity Management Plugin.
See :ref:`minio-external-identity-management-plugin` for a tutorial on using these configuration settings.

.. mc-conf:: identity_plugin

   The top-level configuration key for enabling :ref:`minio-external-identity-management-plugin`.

   Use :mc-cmd:`mc admin config set` to set or update the configuration.
   The :mc-conf:`~identity_plugin.url` and :mc-conf:`~identity_plugin.role_policy` arguments are *required*.
   Specify additional optional arguments as a whitespace (``" "``)-delimited list.

   .. code-block:: shell
      :class: copyable

      mc admin config set identity_plugin \
        url="https://external-auth.example.net:8080/auth" \
        role_policy="consoleAdmin" \
        [ARGUMENT=VALUE] ... \

   The :mc-conf:`identity_plugin` configuration key supports the following arguments:

   .. mc-conf:: url
      :delimiter: " "
   
      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-identity-management-plugin-url
         :end-before: end-minio-identity-management-plugin-url


   .. mc-conf:: role_policy
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-identity-management-role-policy
         :end-before: end-minio-identity-management-role-policy

   .. mc-conf:: enabled
      :delimiter: " "

      *Optional*

      Set to ``false`` to disable the identity provider configuration.

      Applications cannot generate STS credentials or otherwise authenticate to MinIO using the configured provider if set to ``false``.

      Defaults to ``true`` or "enabled".

   .. mc-conf:: token
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-identity-management-auth-token
         :end-before: end-minio-identity-management-auth-token

   .. mc-conf:: role_id
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-identity-management-role-id
         :end-before: end-minio-identity-management-role-id

   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-identity-management-comment
         :end-before: end-minio-identity-management-comment


Data Compression
~~~~~~~~~~~~~~~~

The following section documents settings for enabling data compression for objects.
See :ref:`minio-data-compression` for tutorials on using these configuration settings.

.. mc-conf:: compression

   The top-level configuration key for enabling :ref:`minio-data-compression`.

   Use :mc-cmd:`mc admin config set` to set or update the configuration.
   Specify optional arguments as a whitespace (``" "``)-delimited list.

   .. code-block:: shell
      :class: copyable

      mc admin config set compression           \
                          [ARGUMENT=VALUE] ...  \

   Enabling data compression compresses the following types of data by default:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-data-compression-default-desc
      :end-before: end-minio-data-compression-default-desc

   The :mc-conf:`compression` configuration key supports the following arguments:

   .. mc-conf:: allow_encryption
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-data-compression-allow_encryption-desc
         :end-before: end-minio-data-compression-allow_encryption-desc

      This configuration setting corresponds with the :envvar:`MINIO_COMPRESSION_ALLOW_ENCRYPTION` environment variable.

   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-data-compression-comment-desc
         :end-before: end-minio-data-compression-comment-desc

   .. mc-conf:: enable
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-data-compression-enable-desc
         :end-before: end-minio-data-compression-enable-desc

      This configuration setting corresponds with the :envvar:`MINIO_COMPRESSION_ENABLE` environment variable.

   .. mc-conf:: extensions
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-data-compression-extensions-desc
         :end-before: end-minio-data-compression-extensions-desc

      This configuration setting corresponds with the :envvar:`MINIO_COMPRESSION_EXTENSIONS` environment variable.

   .. mc-conf:: mime_types
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-data-compression-mime_types-desc
         :end-before: end-minio-data-compression-mime_types-desc

      This configuration setting corresponds with the :envvar:`MINIO_COMPRESSION_MIME_TYPES` environment variable.
