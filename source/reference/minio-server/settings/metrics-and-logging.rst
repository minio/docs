.. _minio-server-envvar-metrics-logging:

============================
Metrics and Logging Settings
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page covers settings that control behavior related to MinIO metrics and logging. 
See :ref:`minio-metrics-and-alerts` for more information.

These settings configure publishing regular :mc:`minio server` logs and audit logs to an HTTP webhook. 
See :ref:`minio-logging` for more complete documentation.

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

- :ref:`minio-server-envvar-logging-regular`
- :ref:`minio-server-envvar-logging-audit`
- :ref:`minio-server-envvar-logging-audit-kafka`

Prometheus Authentication
-------------------------

This setting controls how MinIO authenticates to Prometheus.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MINIO_PROMETHEUS_AUTH_TYPE

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Specifies the authentication mode for the Prometheus :ref:`scraping endpoints <minio-metrics-and-alerts>`.

- ``jwt`` - *Default* MinIO requires that the scraping client specify a JWT token for authenticating requests. 
   Use :mc-cmd:`mc admin prometheus generate` to generate the necessary JWT bearer tokens.

- ``public`` MinIO does not require that scraping clients authenticate their requests.

.. _minio-server-envvar-logging-regular:
.. _minio-server-config-logging-regular:

Server Logs
-----------

The following section documents settings for configuring MinIO to publish :mc:`minio server` logs to an HTTP webhook endpoint. 
See :ref:`minio-logging-publish-server-logs` for more complete documentation and tutorials on using these settings.

Defining Multiple Endpoints
~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can specify multiple webhook endpoints as log targets by appending a unique identifier ``_ID`` for each set of related logging environment variables. 
For example, the following settings define two distinct server logs webhook endpoints:

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar
   
      .. code-block:: shell
         :class: copyable
      
         export MINIO_LOGGER_WEBHOOK_ENABLE_PRIMARY="on"
         export MINIO_LOGGER_WEBHOOK_AUTH_TOKEN_PRIMARY="TOKEN"
         export MINIO_LOGGER_WEBHOOK_ENDPOINT_PRIMARY="http://webhook-1.example.net"
      
         export MINIO_LOGGER_WEBHOOK_ENABLE_SECONDARY="on"
         export MINIO_LOGGER_WEBHOOK_AUTH_TOKEN_SECONDARY="TOKEN"
         export MINIO_LOGGER_WEBHOOK_ENDPOINT_SECONDARY="http://webhook-2.example.net"

   .. tab-item:: Configuration Setting
      :sync: config

      .. code-block:: shell
         :class: copyable

         mc admin config set logger_webhook:primary \
            endpoint="http://webhook-01.example.net" [ARGUMENTS=VALUE ...]

         mc admin config set logger_webhook:secondary \
            endpoint="http://webhook-02.example.net" [ARGUMENTS=VALUE ...]

Settings
~~~~~~~~

Enable
++++++

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MINIO_LOGGER_WEBHOOK_ENABLE

      Specify ``"on"`` to enable publishing :mc:`minio server` logs to the HTTP webhook endpoint.
      
      Requires specifying :envvar:`MINIO_LOGGER_WEBHOOK_ENDPOINT`.
   
   .. tab-item:: Configuration Setting

      There is no configuration setting for this value.
      Use the environment variable instead.


Endpoint
++++++++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_LOGGER_WEBHOOK_ENDPOINT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: logger_webhook endpoint
         :delimiter: " "

The HTTP endpoint of the webhook. 

Auth Token
++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_LOGGER_WEBHOOK_AUTH_TOKEN

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

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: logger_webhook auth_token
         :delimiter: " "
   
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
   
         Consult the documentation for the desired service for more details.

Client Certificate
++++++++++++++++++

*Optional*

Requires also setting the *Client Key*.

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_LOGGER_WEBHOOK_CLIENT_CERT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: logger_webhook client_cert
         :delimiter: " "

The path to the mTLS certificate to use for authenticating to the webhook logger.
   
Client Key
++++++++++

*Optional*

Required if you define the *Client Certificate*.

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_LOGGER_WEBHOOK_CLIENT_KEY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: logger_webhook client_key
         :delimiter: " "

The path to the mTLS certificate key to use to authenticate with the webhook logger service.

Proxy
+++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_LOGGER_WEBHOOK_PROXY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: logger_webhook proxy
         :delimiter: " "

      .. versionadded:: MinIO RELEASE.2023-02-22T18-23-45Z 

Define a proxy to use for the webhook logger when communicating from MinIO to external webhooks.

Queue Directory
+++++++++++++++

*Optional*

.. versionadded:: RELEASE.2023-05-18T00-05-36Z

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_LOGGER_WEBHOOK_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: logger_webhook queue_dir
         :delimiter: " "

Specify the directory path, such as ``/opt/minio/events``, to enable MinIO's persistent event store for undelivered messages.
The MinIO process must have read, write, and list access on the specified directory.

MinIO stores undelivered events in the specified store while the webhook service is offline and replays the stored events when connectivity resumes.
 
Queue Size
++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar
      
      .. envvar:: MINIO_LOGGER_WEBHOOK_QUEUE_SIZE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: logger_webhook queue_size
         :delimiter: " "

An integer value to use for the queue size for logger webhook targets.

.. _minio-server-envvar-logging-audit:
.. _minio-server-config-logging-audit:

Webhook Audit Logs
------------------

The following section documents environment variables for configuring MinIO to publish audit logs to an HTTP webhook endpoint. 
See :ref:`minio-logging-publish-audit-logs` for more complete documentation and tutorials on using these environment variables.

Multiple Targets
~~~~~~~~~~~~~~~~

You can specify multiple webhook endpoints as audit log targets by appending a unique identifier ``_ID`` for each set of related logging settings. 

For example, the following commands set two distinct audit log webhook endpoints:

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

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

   .. tab-item:: Configuration Setting
      :sync: config

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

Settings
~~~~~~~~

Enable
++++++

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MINIO_AUDIT_WEBHOOK_ENABLE
      
         Specify ``"on"`` to enable publishing audit logs to the HTTP webhook endpoint.
      
         Requires specifying :envvar:`MINIO_AUDIT_WEBHOOK_ENDPOINT`.
      
   .. tab-item:: Configuration Setting

      Configure an audit webhook to enable it.
      There is *not* a separate ``enable`` configuration setting.

Endpoint
++++++++

*Required*

.. tab-set:: 
   
   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_WEBHOOK_ENDPOINT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_webhook endpoint
         :delimiter: " "

The HTTP endpoint of the webhook.

Auth Token
++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_WEBHOOK_AUTH_TOKEN

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_webhook auth_token
         :delimiter: " "

An authentication token of the appropriate type for the endpoint.
Omit for endpoints which do not require authentication.

To allow for a variety of token types, MinIO creates the request authentication header using the value *exactly as specified*.
Depending on the endpoint, you may need to include additional information.

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      For example, for a Bearer token, prepend ``Bearer``:

      .. code-block:: shell
         :class: copyable

         set MINIO_AUDIT_WEBHOOK_AUTH_TOKEN_myendpoint="Bearer 1a2b3c4f5e"

      Modify the value according to the endpoint requirements.
      
      A custom authentication format could resemble the following:

      .. code-block:: shell
         :class: copyable

         set MINIO_AUDIT_WEBHOOK_AUTH_TOKEN_xyz="ServiceXYZ 1a2b3c4f5e"

   .. tab-item:: Configuration Setting
      :sync: config

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

Consult the documentation for the desired service for more details.

Client Certificate
++++++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_WEBHOOK_CLIENT_CERT

      Requires also specifying :envvar:`MINIO_AUDIT_WEBHOOK_CLIENT_KEY`.
   
   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_webhook client_cert
         :delimiter: " "

      Requires also specifying :mc-conf:`~audit_webhook.client_key`.

The x.509 client certificate to present to the HTTP webhook. 
Omit for webhooks which do not require clients to present a known TLS certificate.

Client Key
++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_WEBHOOK_CLIENT_KEY

      Requires also specifying :envvar:`MINIO_AUDIT_WEBHOOK_CLIENT_CERT`.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_webhook client_key
         :delimiter: " "

      Requires specifying :mc-conf:`~audit_webhook.client_cert`.

The x.509 private key to present to the HTTP webhook. 
Omit for webhooks which do not require clients to present a known TLS certificate.


Queue Directory
+++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_WEBHOOK_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_webhook queue_dir
         :delimiter: " "

.. versionadded:: RELEASE.2023-05-18T00-05-36Z

Specify the directory path, such as ``/opt/minio/events``, to enable MinIO's persistent event store for undelivered messages.
The MinIO process must have read, write, and list access on the specified directory.

MinIO stores undelivered events in the specified store while the webhook service is offline and replays the stored events when connectivity resumes.

Queue Size
++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_WEBHOOK_QUEUE_SIZE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_webhook queue_size
         :delimiter: " "

An integer value to use for the queue size for audit webhook targets.
The default is ``100000`` events.

.. _minio-server-envvar-logging-audit-kafka:
.. _minio-server-config-logging-kafka-audit:

Kafka Audit Logs
----------------

The following section documents environment variables for configuring MinIO to publish audit logs to a Kafka broker.


.. mc-conf:: audit_kafka

   The top-level configuration key for defining a Kafka broker target for publishing :ref:`MinIO audit logs <minio-logging>`.

   Use :mc-cmd:`mc admin config set` to set or update a Kafka audit target.
   Specify additional optional arguments as a whitespace (``" "``)-delimited list.

   .. code-block:: shell
      :class: copyable

      mc admin config set audit_kafka \
         brokers="https://kafka-endpoint.example.net:9092" [ARGUMENTS=VALUE ...]


Settings
~~~~~~~~

Enable
++++++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MINIO_AUDIT_KAFKA_ENABLE
   
      Set to ``"on"`` to enable the target.

      Set to ``"off"`` to disable the target.

   .. tab-item:: Configuration Setting
      
      There is not a configuration setting for this value.
      Use the environment variable to disable a configured audit webhook target.

Brokers
+++++++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_BROKERS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka brokers
         :delimiter: " "

A comma-separated list of Kafka broker addresses:

.. code-block:: shell

   brokers="https://kafka-1.example.net:9092,https://kafka-2.example.net:9092"

At least one broker must be online and reachable by the MinIO server to initialize and send audit log events.
MinIO checks each specified broker in order of specification.

Topic
+++++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_TOPIC
   
   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka topic
         :delimiter: " "

The name of the Kafka topic to associate to MinIO audit log events.

TLS
+++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_TLS  

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka tls
         :delimiter: " "

Set to ``"on"`` to enable TLS connectivity to the specified Kafka brokers.

Defaults to ``"off"``.

TLS Skip Verify
+++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_TLS_SKIP_VERIFY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka tls_skip_verify
         :delimiter: " "

Set to ``"on"`` to direct MinIO to skip verification of the Kafka broker TLS certificates.

You can use this option for enabling connectivity to Kafka brokers using TLS certificates signed by unknown parties, such as self-signed or corporate-internal Certificate Authorities (CA).

MinIO by default uses the system trust store *and* the contents of the MinIO :ref:`CA directory <minio-tls>` for verifying remote client TLS certificates.

Defaults to ``"off"`` for strict verification of TLS certificates.

SASL
++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_SASL

      Requires specifying :envvar:`MINIO_AUDIT_KAFKA_SASL_USERNAME` and :envvar:`MINIO_AUDIT_KAFKA_SASL_PASSWORD`.

   .. tab-item:: Configuration Setting
      :sync: config
   
      .. mc-conf:: audit_kafka sasl
         :delimiter: " "

      Requires specifying :mc-conf:`~audit_kafka.sasl_username` and :mc-conf:`~audit_kafka.sasl_password`.

Set to ``"on"`` to direct MinIO to use SASL to authenticate against the Kafka brokers.

SASL Username
+++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_SASL_USERNAME

      Requires specifying :envvar:`MINIO_AUDIT_KAFKA_SASL` and :envvar:`MINIO_AUDIT_KAFKA_SASL_PASSWORD`.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka sasl_username
         :delimiter: " "

      Requires specifying :mc-conf:`~audit_kafka.sasl` and :mc-conf:`~audit_kafka.sasl_password`.

The SASL username MinIO uses for authentication against the Kafka brokers.

SASL Password
+++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_SASL_PASSWORD

      Requires specifying :envvar:`MINIO_AUDIT_KAFKA_SASL` and :envvar:`MINIO_AUDIT_KAFKA_SASL_USERNAME`.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka sasl_password
         :delimiter: " "

      Requires specifying :mc-conf:`~audit_kafka.sasl` and :mc-conf:`~audit_kafka.sasl_username`.

The SASL password MinIO uses for authentication against the Kafka brokers.

SASL Mechanism
++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_SASL_MECHANISM

      .. important::

         The ``PLAIN`` authentication mechanism sends credentials in plain text over the network.
         Use :envvar:`MINIO_AUDIT_KAFKA_TLS` or to enable TLS connectivity to the Kafka brokers and ensure secure transmission of SASL credentials.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka sasl_mechanism
         :delimiter: " "

      .. important::

         The ``PLAIN`` authentication mechanism sends credentials in plain text over the network.
         Use :mc-conf:`~audit_kafka.tls` to enable TLS connectivity to the Kafka brokers and ensure secure transmission of SASL credentials.

The SASL mechanism MinIO uses for authentication against the Kafka brokers.

Defaults to ``plain``.

TLS  Client Auth
++++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_TLS_CLIENT_AUTH

      Requires specifying :envvar:`MINIO_AUDIT_KAFKA_CLIENT_TLS_CERT` and :envvar:`MINIO_AUDIT_KAFKA_CLIENT_TLS_KEY`.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka tls_client_auth
         :delimiter: " "

      Requires specifying :mc-conf:`~audit_kafka.client_tls_cert` and :mc-conf:`~audit_kafka.client_tls_key`.

Set to ``"on"`` to direct MinIO to use mTLS to authenticate against the Kafka brokers.

Client TLS Certificate
++++++++++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_CLIENT_TLS_CERT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka client_tls_cert
         :delimiter: " "

The path to the TLS client certificate to use for mTLS authentication.

Client TLS Key
++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_CLIENT_TLS_KEY

   .. tab-item:: Configuration Setting
      :sync: config
   
      .. mc-conf:: audit_kafka client_tls_key
         :delimiter: " "

The path to the TLS client private key to use for mTLS authentication.

Version
+++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_VERSION

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka version
         :delimiter: " "

The version of the Kafka broker MinIO expects at the specified endpoints.

MinIO returns an error if the Kakfa broker version does not match those specified to this setting.

Comment
+++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config
   
      .. mc-conf:: audit_kafka comment
         :delimiter: " "

A comment to associate with the configuration.

Queue Directory
+++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka queue_dir
         :delimiter: " "

Specify the directory path to enable MinIO's persistent event store for undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the Kafka service is offline and replays the stored events when connectivity resumes.

Queue Size
++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_AUDIT_KAFKA_QUEUE_SIZE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: audit_kafka queue_size
         :delimiter: " "

Specify the maximum limit for undelivered messages. 
Defaults to ``100000``.