.. _minio-server-envvar-metrics-logging:

======================================================
Environment Variables to Configure Metrics and Logging
======================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

These environment variables control behavior related to MinIO metrics and logging. 
See :ref:`minio-metrics-and-alerts` for more information.

Prometheus Authentication
-------------------------

This environment variables controls how MinIO authenticates to Prometheus.

.. envvar:: MINIO_PROMETHEUS_AUTH_TYPE

   Specifies the authentication mode for the Prometheus :ref:`scraping endpoints <minio-metrics-and-alerts>`.

   - ``jwt`` - *Default* MinIO requires that the scraping client specify a JWT token for authenticating requests. 
     Use :mc-cmd:`mc admin prometheus generate` to generate the necessary JWT bearer tokens.

   - ``public`` MinIO does not require that scraping clients authenticate their requests.



Environment Variables for Logging
---------------------------------

These environment variables configure publishing regular :mc:`minio server` logs and audit logs to an HTTP webhook. 
See :ref:`minio-logging` for more complete documentation.

- :ref:`minio-server-envvar-logging-regular`
- :ref:`minio-server-envvar-logging-audit`
- :ref:`minio-server-envvar-logging-audit-kafka`

.. _minio-server-envvar-logging-regular:

Server Logs
~~~~~~~~~~~

The following section documents environment variables for configuring MinIO to publish :mc:`minio server` logs to an HTTP webhook endpoint. 
See :ref:`minio-logging-publish-server-logs` for more complete documentation and tutorials on using these environment variables.

You can specify multiple webhook endpoints as log targets by appending a unique identifier ``_ID`` for each set of related logging environment variables. 
For example, the following command set two distinct server logs webhook endpoints:

.. code-block:: shell
   :class: copyable

   export MINIO_LOGGER_WEBHOOK_ENABLE_PRIMARY="on"
   export MINIO_LOGGER_WEBHOOK_AUTH_TOKEN_PRIMARY="TOKEN"
   export MINIO_LOGGER_WEBHOOK_ENDPOINT_PRIMARY="http://webhook-1.example.net"

   export MINIO_LOGGER_WEBHOOK_ENABLE_SECONDARY="on"
   export MINIO_LOGGER_WEBHOOK_AUTH_TOKEN_SECONDARY="TOKEN"
   export MINIO_LOGGER_WEBHOOK_ENDPOINT_SECONDARY="http://webhook-2.example.net"

.. envvar:: MINIO_LOGGER_WEBHOOK_ENABLE

   Specify ``"on"`` to enable publishing :mc:`minio server` logs to the HTTP webhook endpoint.

   Requires specifying :envvar:`MINIO_LOGGER_WEBHOOK_ENDPOINT`.

   This environment variable corresponds with the top-level :mc-conf:`logger_webhook` configuration setting.

.. envvar:: MINIO_LOGGER_WEBHOOK_ENDPOINT

   The HTTP endpoint of the webhook. 

   This environment variable corresponds with the :mc-conf:`logger_webhook endpoint <logger_webhook.endpoint>` configuration setting.

.. envvar:: MINIO_LOGGER_WEBHOOK_AUTH_TOKEN

   *Optional*

   An authentication token of the appropriate type for the endpoint.
   Omit for endpoints which do not require authentication.

   To allow for a variety of token types, MinIO creates the request authentication header using the value *exactly as specified*.
   Depending on the endpoint, you may need to include additional information.

   For example: for a Bearer token, prepend ``Bearer``:

   .. code-block:: shell
      :class: copyable

      set MINIO_LOGGER_WEBHOOK_AUTH_TOKEN_myendpoint="Bearer 1a2b3c4f5e"

   Modify the value according to the endpoint requirements.
   A custom authentication format could resemble the following:

   .. code-block:: shell
      :class: copyable

      set MINIO_LOGGER_WEBHOOK_AUTH_TOKEN_xyz="ServiceXYZ 1a2b3c4f5e"

   Consult the documentation for the desired service for more details.

   This environment variable corresponds with the :mc-conf:`logger_webhook auth_token <logger_webhook.auth_token>` configuration setting.

.. envvar:: MINIO_LOGGER_WEBHOOK_CLIENT_CERT

   *Optional*

   The path to the mTLS certificate to use for authenticating to the webhook logger.

   Requires specifying :envvar:`MINIO_LOGGER_WEBHOOK_CLIENT_KEY`.

   This environment variable corresponds with the :mc-conf:`logger_webhook client_cert <logger_webhook.client_cert>` configuration setting.

.. envvar:: MINIO_LOGGER_WEBHOOK_CLIENT_KEY

   *Optional*

   The path to the mTLS certificate key to use to authenticate with the webhook logger service.

   Requires specifying :envvar:`MINIO_LOGGER_WEBHOOK_CLIENT_CERT`.

   This environment variable corresponds with the :mc-conf:`logger_webhook client_key <logger_webhook.client_key>` configuration setting.

.. envvar:: MINIO_LOGGER_WEBHOOK_PROXY

   *Optional*

   Define a proxy to use for the webhook logger when communicating from MinIO to external webhooks.

   This environment variable corresponds with the :mc-conf:`logger_webhook proxy <logger_webhook.proxy>` configuration setting.

.. envvar:: MINIO_LOGGER_WEBHOOK_QUEUE_DIR

   .. versionadded:: RELEASE.2023-05-18T00-05-36Z

   *Optional*

   Specify the directory path, such as ``/opt/minio/events``, to enable MinIO's persistent event store for undelivered messages.
   The MinIO process must have read, write, and list access on the specified directory.

   MinIO stores undelivered events in the specified store while the webhook service is offline and replays the stored events when connectivity resumes.

   This environment variable corresponds with the :mc-conf:`logger_webhook queue_dir <logger_webhook.queue_dir>` configuration setting.

.. envvar:: MINIO_LOGGER_WEBHOOK_QUEUE_SIZE

   *Optional*

   An integer value to use for the queue size for logger webhook targets.

   This environment variable corresponds with the :mc-conf:`logger_webhook queue_size <logger_webhook.queue_size>` configuration setting.

.. _minio-server-envvar-logging-audit:

Webhook Audit Logs
~~~~~~~~~~~~~~~~~~

The following section documents environment variables for configuring MinIO to publish audit logs to an HTTP webhook endpoint. 
See :ref:`minio-logging-publish-audit-logs` for more complete documentation and tutorials on using these environment variables.

You can specify multiple webhook endpoints as audit log targets by appending a unique identifier ``_ID`` for each set of related logging environment variables. 
For example, the following command set two distinct audit log webhook endpoints:

.. code-block:: shell
   :class: copyable

   export MINIO_AUDIT_WEBHOOK_ENABLE_PRIMARY="on"
   export MINIO_AUDIT_WEBHOOK_AUTH_TOKEN_PRIMARY="TOKEN"
   export MINIO_AUDIT_WEBHOOK_ENDPOINT_PRIMARY="http://webhook-1.example.net"
   export MINIO_AUDIT_WEBHOOK_CLIENT_CERT_SECONDARY="/tmp/cert.pem"
   export MINIO_AUDIT_WEBHOOK_CLIENT_KEY_SECONDARY="/tmp/key.pem"

   export MINIO_AUDIT_WEBHOOK_ENABLE_SECONDARY="on"
   export MINIO_AUDIT_WEBHOOK_AUTH_TOKEN_SECONDARY="TOKEN"
   export MINIO_AUDIT_WEBHOOK_ENDPOINT_SECONDARY="http://webhook-1.example.net"
   export MINIO_AUDIT_WEBHOOK_CLIENT_CERT_SECONDARY="/tmp/cert.pem"
   export MINIO_AUDIT_WEBHOOK_CLIENT_KEY_SECONDARY="/tmp/key.pem"

.. envvar:: MINIO_AUDIT_WEBHOOK_ENABLE

   Specify ``"on"`` to enable publishing audit logs to the HTTP webhook endpoint.

   Requires specifying :envvar:`MINIO_AUDIT_WEBHOOK_ENDPOINT`.

   This environment variable corresponds with top-level :mc-conf:`audit_webhook` configuration setting.

.. envvar:: MINIO_AUDIT_WEBHOOK_ENDPOINT

   The HTTP endpoint of the webhook. 

   This environment variable corresponds with the :mc-conf:`audit_webhook endpoint <audit_webhook.endpoint>` configuration setting.

.. envvar:: MINIO_AUDIT_WEBHOOK_AUTH_TOKEN

   *Optional*

   An authentication token of the appropriate type for the endpoint.
   Omit for endpoints which do not require authentication.

   To allow for a variety of token types, MinIO creates the request authentication header using the value *exactly as specified*.
   Depending on the endpoint, you may need to include additional information.

   For example: for a Bearer token, prepend ``Bearer``:

   .. code-block:: shell
      :class: copyable

      set MINIO_AUDIT_WEBHOOK_AUTH_TOKEN_myendpoint="Bearer 1a2b3c4f5e"

   Modify the value according to the endpoint requirements.
   A custom authentication format could resemble the following:

   .. code-block:: shell
      :class: copyable

      set MINIO_AUDIT_WEBHOOK_AUTH_TOKEN_xyz="ServiceXYZ 1a2b3c4f5e"

   Consult the documenation for the desired service for more details.

   This environment variable corresponds with the :mc-conf:`audit_webhook auth_token <audit_webhook.auth_token>` configuration setting.

.. envvar:: MINIO_AUDIT_WEBHOOK_CLIENT_CERT

   *Optional*

   The x.509 client certificate to present to the HTTP webhook. 
   Omit for webhooks which do not require clients to present a known TLS certificate.

   Requires specifying :envvar:`MINIO_AUDIT_WEBHOOK_CLIENT_KEY`.

   This environment variable corresponds with the :mc-conf:`audit_webhook client_cert <audit_webhook.client_cert>` configuration setting.

.. envvar:: MINIO_AUDIT_WEBHOOK_CLIENT_KEY

   *Optional*

   The x.509 private key to present to the HTTP webhook. 
   Omit for webhooks which do not require clients to present a known TLS certificate.

   Requires specifying :envvar:`MINIO_AUDIT_WEBHOOK_CLIENT_CERT`.

   This environment variable corresponds with the :mc-conf:`audit_webhook client_key <audit_webhook.client_key>` configuration setting.

.. envvar:: MINIO_AUDIT_WEBHOOK_QUEUE_DIR

   .. versionadded:: RELEASE.2023-05-18T00-05-36Z

   *Optional*

   Specify the directory path, such as ``/opt/minio/events``, to enable MinIO's persistent event store for undelivered messages.
   The MinIO process must have read, write, and list access on the specified directory.

   MinIO stores undelivered events in the specified store while the webhook service is offline and replays the stored events when connectivity resumes.

   This environment variable corresponds with the :mc-conf:`audit_webhook queue_dir <audit_webhook.queue_dir>` configuration setting.

.. envvar:: MINIO_AUDIT_WEBHOOK_QUEUE_SIZE

   *Optional*

   An integer value to use for the queue size for audit webhook targets.

   This environment variable corresponds with the :mc-conf:`audit_webhook queue_size <audit_webhook.queue_size>` configuration setting.

.. _minio-server-envvar-logging-audit-kafka:

Kafka Audit Logs
~~~~~~~~~~~~~~~~

The following section documents environment variables for configuring MinIO to publish audit logs to a Kafka broker.

.. envvar:: MINIO_AUDIT_KAFKA_ENABLE
   :required:

   Set to ``"on"`` to enable the target.

   Set to ``"off"`` to disable the target.

.. envvar:: MINIO_AUDIT_KAFKA_BROKERS
   :required:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-brokers-desc
      :end-before: end-minio-kafka-audit-logging-brokers-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.brokers` configuration setting.
    
.. envvar:: MINIO_AUDIT_KAFKA_TOPIC
   :required:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-topic-desc
      :end-before: end-minio-kafka-audit-logging-topic-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.topic` configuration setting.
    
.. envvar:: MINIO_AUDIT_KAFKA_TLS  
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-tls-desc
      :end-before: end-minio-kafka-audit-logging-tls-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.tls` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_TLS_SKIP_VERIFY
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-tls-skip-verify-desc
      :end-before: end-minio-kafka-audit-logging-tls-skip-verify-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.tls_skip_verify` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_SASL
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-sasl-desc
      :end-before: end-minio-kafka-audit-logging-sasl-desc

   Requires specifying :envvar:`MINIO_AUDIT_KAFKA_SASL_USERNAME` and :envvar:`MINIO_AUDIT_KAFKA_SASL_PASSWORD`.

   This environment variable corresponds with the :mc-conf:`audit_kafka.sasl` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_SASL_USERNAME
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-sasl-username-desc
      :end-before: end-minio-kafka-audit-logging-sasl-username-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.sasl_username` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_SASL_PASSWORD
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-sasl-password-desc
      :end-before: end-minio-kafka-audit-logging-sasl-password-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.sasl_password` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_SASL_MECHANISM
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-sasl-mechanism-desc
      :end-before: end-minio-kafka-audit-logging-sasl-mechanism-desc

   .. important::

      The ``PLAIN`` authentication mechanism sends credentials in plain text over the network.
      Use :envvar:`MINIO_AUDIT_KAFKA_TLS` to enable TLS connectivity to the Kafka brokers and ensure secure transmission of SASL credentials.

   This environment variable corresponds with the :mc-conf:`audit_kafka.sasl_mechanism` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_TLS_CLIENT_AUTH
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-tls-client-auth-desc
      :end-before: end-minio-kafka-audit-logging-tls-client-auth-desc

   Requires specifying :envvar:`MINIO_AUDIT_KAFKA_CLIENT_TLS_CERT` and :envvar:`MINIO_AUDIT_KAFKA_CLIENT_TLS_KEY`.

   This environment variable corresponds with the :mc-conf:`audit_kafka.tls_client_auth` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_CLIENT_TLS_CERT
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-client-tls-cert-desc
      :end-before: end-minio-kafka-audit-logging-client-tls-cert-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.client_tls_cert` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_CLIENT_TLS_KEY
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-client-tls-key-desc
      :end-before: end-minio-kafka-audit-logging-client-tls-key-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.client_tls_key` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_VERSION
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-version-desc
      :end-before: end-minio-kafka-audit-logging-version-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.version` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_COMMENT
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-comment-desc
      :end-before: end-minio-kafka-audit-logging-comment-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.comment` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_QUEUE_DIR
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-queue-dir-desc
      :end-before: end-minio-kafka-audit-logging-queue-dir-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.queue_dir` configuration setting.

.. envvar:: MINIO_AUDIT_KAFKA_QUEUE_SIZE
   :optional:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-kafka-audit-logging-queue-size-desc
      :end-before: end-minio-kafka-audit-logging-queue-size-desc

   This environment variable corresponds with the :mc-conf:`audit_kafka.queue_size` configuration setting.


Configuration Values for Logging
--------------------------------

These environment variables configure publishing regular :mc:`minio server` logs and audit logs to an HTTP webhook. 
See :ref:`minio-logging` for more complete documentation.

- :ref:`minio-server-config-logging-regular`
- :ref:`minio-server-config-logging-audit`
- :ref:`minio-server-config-logging-kafka-audit`


.. _minio-server-config-logging-regular:

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

      An authentication token of the appropriate type for the endpoint.
      Omit for endpoints which do not require authentication.

      To allow for a variety of token types, MinIO creates the request authentication header using the value *exactly as specified*.
      Depending on the endpoint, you may need to include additional information.

      For example: for a Bearer token, prepend ``Bearer``:

      .. code-block:: shell
         :class: copyable

            mc admin config set myminio logger_webhook   \
               endpoint="https://webhook-1.example.net"  \
               auth_token="Bearer 1a2b3c4f5e"

      Modify the value according to the endpoint requirements.
      A custom authentication format could resemble the following:

      .. code-block:: shell
         :class: copyable

            mc admin config set myminio logger_webhook   \
	       endpoint="https://webhook-1.example.net"  \
               auth_token="ServiceXYZ 1a2b3c4f5e"

      Consult the documenation for the desired service for more details.

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

      An authentication token of the appropriate type for the endpoint.
      Omit for endpoints which do not require authentication.

      To allow for a variety of token types, MinIO creates the request authentication header using the value *exactly as specified*.
      Depending on the endpoint, you may need to include additional information.

      For example: for a Bearer token, prepend ``Bearer``:

      .. code-block:: shell
         :class: copyable

         mc admin config set myminio audit_webhook       \
                  endpoint="http://webhook.example.net"  \
                  auth_token="Bearer 1a2b3c4f5e"

      Modify the value according to the endpoint requirements.
      A command for a custom authentication format could resemble the following:

      .. code-block:: shell
         :class: copyable

         mc admin config set myminio audit_webhook       \
                  endpoint="http://webhook.example.net"  \
                  auth_token="ServiceXYZ 1a2b3c4f5e"

      Consult the documenation for the desired service for more details.

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