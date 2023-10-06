.. _minio-server-envvar-bucket-notification-kafka:

================================
Settings for Kafka Notifications
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an Kafka service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-kafka` for a tutorial on using these settings.

Environment Variables
---------------------

You can specify multiple Kafka service endpoints by appending a unique identifier ``_ID`` for each set of related Kafka environment variables on to the top level key. 
For example, the following commands set two distinct Kafka service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_KAFKA_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_KAFKA_BROKERS_PRIMARY="https://kafka1.example.net:9200, https://kafka2.example.net:9200"

   set MINIO_NOTIFY_KAFKA_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_KAFKA_BROKERS_SECONDARY="https://kafka1.example.net:9200, https://kafka2.example.net:9200"

.. envvar:: MINIO_NOTIFY_KAFKA_ENABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-enable
      :end-before: end-minio-notify-kafka-enable

.. envvar:: MINIO_NOTIFY_KAFKA_BROKERS

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-brokers
      :end-before: end-minio-notify-kafka-brokers

   This environment variable corresponds with the :mc-conf:`notify_kafka brokers <notify_kafka.brokers>` configuration setting.

   .. include:: /includes/linux/minio-server.rst
      :start-after: start-notify-target-online-desc
      :end-before: end-notify-target-online-desc

.. envvar:: MINIO_NOTIFY_KAFKA_TOPIC

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-topic
      :end-before: end-minio-notify-kafka-topic

   This environment variable corresponds with the :mc-conf:`notify_kafka topic <notify_kafka.topic>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_SASL

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-sasl-root
      :end-before: end-minio-notify-kafka-sasl-root

   This environment variable corresponds with the :mc-conf:`notify_kafka sasl <notify_kafka.sasl>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_SASL_USERNAME

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-sasl-username
      :end-before: end-minio-notify-kafka-sasl-username

   This environment variable corresponds with the :mc-conf:`notify_kafka sasl_username <notify_kafka.sasl_username>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_SASL_PASSWORD

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-sasl-password
      :end-before: end-minio-notify-kafka-sasl-password

   This environment variable corresponds with the :mc-conf:`notify_kafka sasl_password <notify_kafka.sasl_password>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_SASL_MECHANISM

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-sasl-mechanism
      :end-before: end-minio-notify-kafka-sasl-mechanism

   This environment variable corresponds with the :mc-conf:`notify_kafka sasl_mechanism <notify_kafka.sasl_mechanism>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_TLS_CLIENT_AUTH

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-tls-client-auth
      :end-before: end-minio-notify-kafka-tls-client-auth

   This environment variable corresponds with the :mc-conf:`notify_kafka tls_client_auth <notify_kafka.tls_client_auth>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_TLS

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-tls-root
      :end-before: end-minio-notify-kafka-tls-root

   This environment variable corresponds with the :mc-conf:`notify_kafka tls <notify_kafka.tls>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_TLS_SKIP_VERIFY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-tls-skip-verify
      :end-before: end-minio-notify-kafka-tls-skip-verify

   This environment variable corresponds with the :mc-conf:`notify_kafka tls_skip_verify <notify_kafka.tls_skip_verify>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_CLIENT_TLS_CERT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-client-tls-cert
      :end-before: end-minio-notify-kafka-client-tls-cert

   This environment variable corresponds with the :mc-conf:`notify_kafka client_tls_cert <notify_kafka.client_tls_cert>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_CLIENT_TLS_KEY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-client-tls-key
      :end-before: end-minio-notify-kafka-client-tls-key

   This environment variable corresponds with the :mc-conf:`notify_kafka client_tls_key <notify_kafka.client_tls_key>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_VERSION

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-version
      :end-before: end-minio-notify-kafka-version

   This environment variable corresponds with the :mc-conf:`notify_kafka version <notify_kafka.version>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-queue-dir
      :end-before: end-minio-notify-kafka-queue-dir

   This environment variable corresponds with the :mc-conf:`notify_kafka queue_dir <notify_kafka.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-queue-limit
      :end-before: end-minio-notify-kafka-queue-limit

   This environment variable corresponds with the :mc-conf:`notify_kafka queue_limit <notify_kafka.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-comment
      :end-before: end-minio-notify-kafka-comment

   This environment variable corresponds with the :mc-conf:`notify_kafka comment <notify_kafka.comment>` configuration setting.

.. _minio-server-config-bucket-notification-kafka:

Configuration Values
--------------------

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