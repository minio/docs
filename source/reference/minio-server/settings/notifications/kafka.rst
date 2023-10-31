.. _minio-server-envvar-bucket-notification-kafka:
.. _minio-server-config-bucket-notification-kafka:

===========================
Kafka Notification Settings
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an Kafka service as a target for :ref:`Bucket Notifications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-kafka` for a tutorial on using these settings.

Multiple Kafka Targets
----------------------

You can specify multiple Kafka service endpoints by appending a unique identifier ``_ID`` for each set of related Kafka settings on to the top level key. 

Examples
~~~~~~~~

For example, the following commands set two distinct Kafka service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. tab-set:: 
   
   .. tab-item:: Environment Variable
      :sync: envvar

      .. code-block:: shell
         :class: copyable
      
         set MINIO_NOTIFY_KAFKA_ENABLE_PRIMARY="on"
         set MINIO_NOTIFY_KAFKA_BROKERS_PRIMARY="https://kafka1.example.net:9200, https://kafka2.example.net:9200"
      
         set MINIO_NOTIFY_KAFKA_ENABLE_SECONDARY="on"
         set MINIO_NOTIFY_KAFKA_BROKERS_SECONDARY="https://kafka1.example.net:9200, https://kafka2.example.net:9200"

   .. tab-item:: Configuration Setting
      :sync: config

      .. code-block:: shell

         mc admin config set notify_kafka:primary \ 
            brokers="https://kafka1.example.net:9200, https://kafka2.example.net:9200"
            [ARGUMENT=VALUE ...]

         mc admin config set notify_kafka:secondary \
            brokers="https://kafka1.example.net:9200, https://kafka2.example.net:9200"
            [ARGUMENT=VALUE ...]

      Notice that for configuration settings, the unique identifier appends to ``notify_kafka`` only, not to each individual argument.

Settings
--------

Enable
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_ENABLE

      Specify ``on`` to enable publishing bucket notifications to a Kafka service endpoint.

      Defaults to ``off``.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka

      The top-level configuration key for defining an Kafka service endpoint for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

      Use :mc-cmd:`mc admin config set` to set or update an Kafka service endpoint.
      The :mc-conf:`~notify_kafka.brokers` argument is *required* for each target.
      Specify additional optional arguments as a whitespace (``" "``)-delimited list.

      .. code-block:: shell
         :class: copyable

         mc admin config set notify_kafka \ 
           brokers="https://kafka1.example.net:9200, https://kafka2.example.net:9200"
           [ARGUMENT="VALUE"] ... \

Brokers
~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_BROKERS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka brokers
         :delimiter: " "

Specify a comma-separated list of Kafka broker addresses. 
For example:

``"kafka1.example.com:2021,kafka2.example.com:2021"``

.. include:: /includes/linux/minio-server.rst
   :start-after: start-notify-target-online-desc
   :end-before: end-notify-target-online-desc

Topic
~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_TOPIC

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka topic
         :delimiter: " "

Specify the name of the Kafka topic to which MinIO publishes bucket events.

SASL
~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_SASL

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka sasl
         :delimiter: " "

Specify ``on`` to enable SASL authentication.

SASL Username
~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_SASL_USERNAME

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka sasl_username
         :delimiter: " "

Specify the username for performing SASL/PLAIN or SASL/SCRAM authentication to the Kafka broker(s).

SASL Password
~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_SASL_PASSWORD

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka sasl_password
         :delimiter: " "

Specify the password for performing SASL/PLAIN or SASL/SCRAM authentication to the Kafka broker(s).

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

SASL Mechanism
~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_SASL_MECHANISM

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka sasl_mechanism
         :delimiter: " "

Specify the SASL mechanism to use for authenticating to the Kafka broker(s).
MinIO supports the following mechanisms:

- ``PLAIN`` (Default)
- ``SHA256``
- ``SHA512``

TLS Client Auth
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_TLS_CLIENT_AUTH

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka tls_client_auth
         :delimiter: " "

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

TLS
~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_TLS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka tls
         :delimiter: " "

Specify ``on`` to enable TLS connectivity to the Kafka broker(s).

TLS Skip Verify
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_TLS_SKIP_VERIFY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka tls_skip_verify
         :delimiter: " "

Enables or disables TLS verification of the NATS service endpoint TLS certificates.

- Specify ``on`` to disable TLS verification *(Default)*.
- Specify ``off`` to enable TLS verification.

Client TLS Cert
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_CLIENT_TLS_CERT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka client_tls_cert
         :delimiter: " "

Specify the path to the client certificate to use for performing mTLS authentication to the Kafka broker(s).

Client TLS Key
~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_CLIENT_TLS_KEY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka client_tls_key
         :delimiter: " "

Specify the path to the client private key to use for performing mTLS authentication to the Kafka broker(s).

Version
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_VERSION

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka version
         :delimiter: " "

Specify the version of the Kafka cluster to assume when performing operations against that cluster. 
See the `sarama reference documentation <https://github.com/shopify/sarama/blob/v1.20.1/config.go#L327>`__ for more information on this field's behavior.

Queue Directory
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka queue_dir
         :delimiter: " "

Specify the directory path to enable MinIO's persistent event store for undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the Kafka server/broker is offline and replays the stored events when connectivity resumes.

Queue Limit
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_KAFKA_QUEUE_LIMIT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka queue_limit
         :delimiter: " "

Specify the maximum limit for undelivered messages. 
Defaults to ``100000``.

Comment
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar
      
      .. envvar:: MINIO_NOTIFY_KAFKA_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_kafka comment
         :delimiter: " "

Specify a comment to associate with the Kafka configuration.