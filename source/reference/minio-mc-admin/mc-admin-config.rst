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

Syntax
------

.. mc-cmd:: set
   :fullpath:

   Sets a :ref:`configuration key <minio-server-configuration-settings>` on the 
   MinIO deployment.

.. mc-cmd:: get
   :fullpath:

   Gets a :ref:`configuration key <minio-server-configuration-settings>` on the MinIO deployment.

.. mc-cmd:: export
   :fullpath:

   Exports any configuration settings created using `mc admin config set`.

.. mc-cmd:: import
   :fullpath:

   Imports configuration settings exported using `mc admin config export`.

.. _minio-server-configuration-settings:

Configuration Settings
----------------------

The following configuration settings define runtime behavior of the 
MinIO :mc:`server <minio server>` process:

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

      This setting corresponds to the
      :envvar:`MINIO_LOGGER_WEBHOOK_ENDPOINT` environment variable.

   .. mc-conf:: auth_token

      *Optional*

      The JSON Web Token (JWT) to use for authenticating to the HTTP webhook.
      Omit for webhooks which do not enforce authentication.

      This setting corresponds to the
      :envvar:`MINIO_LOGGER_WEBHOOK_AUTH_TOKEN` environment variable.

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

      This setting corresponds to the 
      :envvar:`MINIO_AUDIT_WEBHOOK_ENDPOINT` environment variable.

   .. mc-conf:: auth_token
      
      *Optional*

      The JSON Web Token (JWT) to use for authenticating to the HTTP webhook.
      Omit for webhooks which do not enforce authentication.

      This setting corresponds to the 
      :envvar:`MINIO_AUDIT_WEBHOOK_AUTH_TOKEN` environment variable.

   .. mc-conf:: client_cert

      *Optional*

      The x.509 client certificate to present to the HTTP webhook. Omit for
      webhooks which do not require clients to present a known TLS certificate.

      Requires specifying :mc-conf:`~audit_webhook.client_key`.

      This setting corresponds to the
      :envvar:`MINIO_AUDIT_WEBHOOK_CLIENT_CERT` environment variable.

   .. mc-conf:: client_key

      *Optional*

      The x.509 private key to present to the HTTP webhook. Omit for
      webhooks which do not require clients to present a known TLS certificate.

      Requires specifying :mc-conf:`~audit_webhook.client_cert`.

      This setting corresponds to the
      :envvar:`MINIO_AUDIT_WEBHOOK_CLIENT_KEY` environment variable.

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

      This key corresponds to the :envvar:`MINIO_NOTIFY_AMQP_URL` environment
      variable. 

   .. mc-conf:: exchange 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-exchange
         :end-before:  end-minio-notify-amqp-exchange

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_EXCHANGE`
      environment variable.

   .. mc-conf:: exchange_type 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-exchange-type
         :end-before:  end-minio-notify-amqp-exchange-type

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_EXCHANGE_TYPE`
      environment variable.

   .. mc-conf:: routing_key 
      :delimiter: " "

      *Optional*
   
      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-routing-key
         :end-before:  end-minio-notify-amqp-routing-key

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_ROUTING_KEY`
      environment variable.

   .. mc-conf:: mandatory 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-mandatory
         :end-before:  end-minio-notify-amqp-mandatory

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_MANDATORY`
      environment variable.

   .. mc-conf:: durable 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-durable
         :end-before:  end-minio-notify-amqp-durable

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_DURABLE`
      environment variable.

   .. mc-conf:: no_wait 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-no-wait
         :end-before:  end-minio-notify-amqp-no-wait

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_NO_WAIT`
      environment variable.

   .. mc-conf:: internal 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-internal
         :end-before:  end-minio-notify-amqp-internal

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_INTERNAL`
      environment variable.

   .. explanation is very unclear. Need to revisit this.

   .. mc-conf:: auto_deleted 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-auto-deleted
         :end-before:  end-minio-notify-amqp-auto-deleted

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_AUTO_DELETED`
      environment variable.

   .. mc-conf:: delivery_mode 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-delivery-mode
         :end-before:  end-minio-notify-amqp-delivery-mode

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_DELIVERY_MODE`
      environment variable.

   .. mc-conf:: queue_dir 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-queue-dir
         :end-before:  end-minio-notify-amqp-queue-dir

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_QUEUE_DIR`
      environment variable.

   .. mc-conf:: queue_limit 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-queue-limit
         :end-before:  end-minio-notify-amqp-queue-limit

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_QUEUE_LIMIT`
      environment variable.

   .. mc-conf:: comment 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-comment
         :end-before:  end-minio-notify-amqp-comment

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_COMMENT`
      environment variable.

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

      This field corresponds to the :envvar:`MINIO_NOTIFY_MQTT_BROKER`
      environment variable.

   .. mc-conf:: topic
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-topic
         :end-before:  end-minio-notify-mqtt-topic

      This field corresponds to the :envvar:`MINIO_NOTIFY_MQTT_TOPIC`
      environment variable.

   .. mc-conf:: username
      :delimiter: " "

      *Required if the MQTT server/broker enforces authentication/authorization*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-username
         :end-before:  end-minio-notify-mqtt-username

      This field corresponds to the :envvar:`MINIO_NOTIFY_MQTT_TOPIC`
      environment variable.

   .. mc-conf:: password
      :delimiter: " "

      *Required if the MQTT server/broker enforces authentication/authorization*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-password
         :end-before:  end-minio-notify-mqtt-password

      This field corresponds to the :envvar:`MINIO_NOTIFY_MQTT_PASSWORD`
      environment variable.

   .. mc-conf:: qos
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-qos
         :end-before:  end-minio-notify-mqtt-qos

      This field corresponds to the :envvar:`MINIO_NOTIFY_MQTT_QOS`
      environment variable.

   .. mc-conf:: keep_alive_interval
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-keep-alive-interval
         :end-before:  end-minio-notify-mqtt-keep-alive-interval

      This field corresponds to the :envvar:`MINIO_NOTIFY_MQTT_KEEP_ALIVE_INTERVAL`
      environment variable.

   .. mc-conf:: reconnect_interval
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-reconnect-interval
         :end-before:  end-minio-notify-mqtt-reconnect-interval

      This field corresponds to the :envvar:`MINIO_NOTIFY_MQTT_RECONNECT_INTERVAL`
      environment variable.

   .. mc-conf:: queue_dir 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-queue-dir
         :end-before:  end-minio-notify-mqtt-queue-dir

      This field corresponds to the :envvar:`MINIO_NOTIFY_MQTT_QUEUE_DIR`
      environment variable.

   .. mc-conf:: queue_limit 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-queue-limit
         :end-before:  end-minio-notify-mqtt-queue-limit

      This field corresponds to the :envvar:`MINIO_NOTIFY_MQTT_QUEUE_LIMIT`
      environment variable.

   .. mc-conf:: comment 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mqtt-comment
         :end-before:  end-minio-notify-mqtt-comment

      This field corresponds to the :envvar:`MINIO_NOTIFY_MQTT_COMMENT`
      environment variable.

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

      This field corresponds to the
      :envvar:`MINIO_NOTIFY_ELASTICSEARCH_URL` environment variable.

   .. mc-conf:: index
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-index
         :end-before: end-minio-notify-elasticsearch-index

      This field corresponds to the
      :envvar:`MINIO_NOTIFY_ELASTICSEARCH_INDEX` environment variable.

   .. mc-conf:: format
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-format
         :end-before: end-minio-notify-elasticsearch-format

      This field corresponds to the
      :envvar:`MINIO_NOTIFY_ELASTICSEARCH_FORMAT` environment variable.

   .. mc-conf:: username
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-username
         :end-before: end-minio-notify-elasticsearch-username

      This field corresponds to the
      :envvar:`MINIO_NOTIFY_ELASTICSEARCH_USERNAME` environment variable.

   .. mc-conf:: password
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-password
         :end-before: end-minio-notify-elasticsearch-password

      This field corresponds to the
      :envvar:`MINIO_NOTIFY_ELASTICSEARCH_PASSWORD` environment variable.


   .. mc-conf:: queue_dir 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-queue-dir
         :end-before:  end-minio-notify-elasticsearch-queue-dir

      This field corresponds to the
      :envvar:`MINIO_NOTIFY_ELASTICSEARCH_QUEUE_DIR` environment variable.

   .. mc-conf:: queue_limit 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-queue-limit
         :end-before:  end-minio-notify-elasticsearch-queue-limit

      This field corresponds to the
      :envvar:`MINIO_NOTIFY_ELASTICSEARCH_QUEUE_LIMIT` environment variable.

   .. mc-conf:: comment 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-comment
         :end-before:  end-minio-notify-elasticsearch-comment

      This field corresponds to the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_COMMENT`
      environment variable.


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

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_NSQ_NSQD_ADDRESS` environment variable.
      
   .. mc-conf:: topic
      :delimiter: " "

      *Required*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-topic
         :end-before: end-minio-notify-nsq-topic

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_NSQ_TOPIC` environment variable.
      
   .. mc-conf:: tls
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-tls
         :end-before: end-minio-notify-nsq-tls

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_NSQ_TLS` environment variable.
      
      
   .. mc-conf:: tls_skip_verify
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-tls-skip-verify
         :end-before: end-minio-notify-nsq-tls-skip-verify

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_NSQ_TLS_SKIP_VERIFY` environment variable.
     
      
   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-queue-dir
         :end-before: end-minio-notify-nsq-queue-dir

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_NSQ_QUEUE_DIR` environment variable.
      
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-queue-limit
         :end-before: end-minio-notify-nsq-queue-limit

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_NSQ_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-comment
         :end-before: end-minio-notify-nsq-comment

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_NSQ_COMMENT` environment variable.


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

   This configuration setting corresponds to the 
   :envvar:`MINIO_NOTIFY_REDIS_ADDRESS` environment variable.

   .. mc-conf:: key
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-key
         :end-before: end-minio-notify-redis-key

   This configuration setting corresponds to the 
   :envvar:`MINIO_NOTIFY_REDIS_KEY` environment variable.

   .. mc-conf:: format
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-format
         :end-before: end-minio-notify-redis-format

   This configuration setting corresponds to the 
   :envvar:`MINIO_NOTIFY_REDIS_FORMAT` environment variable.

   .. mc-conf:: password
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-password
         :end-before: end-minio-notify-redis-password

   This configuration setting corresponds to the 
   :envvar:`MINIO_NOTIFY_REDIS_PASSWORD` environment variable.

   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-queue-dir
         :end-before: end-minio-notify-redis-queue-dir

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_REDIS_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-queue-limit
         :end-before: end-minio-notify-redis-queue-limit

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_REDIS_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-redis-comment
         :end-before: end-minio-notify-redis-comment

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_REDIS_COMMENT` environment variable.



.. _minio-server-config-bucket-notification-nats:

NATS Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an NATS
service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-nats` for a tutorial on 
using these environment variables.

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

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_ADDRESS`.

   .. mc-conf:: subject
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-subject
         :end-before: end-minio-notify-nats-subject

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_SUBJECT`.

   .. mc-conf:: username
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-username
         :end-before: end-minio-notify-nats-username

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_USERNAME`.

   .. mc-conf:: password
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-password
         :end-before: end-minio-notify-nats-password

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_PASSWORD`.

   .. mc-conf:: token
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-token
         :end-before: end-minio-notify-nats-token

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_TOKEN`.

   .. mc-conf:: tls
      :delimiter: "
      
      *Optional*"

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-tls
         :end-before: end-minio-notify-nats-tls

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_TLS`.

   .. mc-conf:: tls_skip_verify
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-tls-skip-verify
         :end-before: end-minio-notify-nats-tls-skip-verify

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_TLS_SKIP_VERIFY`.

   .. mc-conf:: ping_interval
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-ping-interval
         :end-before: end-minio-notify-nats-ping-interval

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_PING_INTERVAL`.

   .. mc-conf:: streaming
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming
         :end-before: end-minio-notify-nats-streaming

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_STREAMING`.

   .. mc-conf:: streaming_async
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming-async
         :end-before: end-minio-notify-nats-streaming-async

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_STREAMING_ASYNC`.

   .. mc-conf:: streaming_max_pub_acks_in_flight
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming-max-pub-acks-in-flight
         :end-before: end-minio-notify-nats-streaming-max-pub-acks-in-flight

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_STREAMING_MAX_PUB_ACKS_IN_FLIGHT`.

   .. mc-conf:: streaming_cluster_id
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming-cluster-id
         :end-before: end-minio-notify-nats-streaming-cluster-id

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_STREAMING_CLUSTER_ID`.

   .. mc-conf:: cert_authority
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-cert-authority
         :end-before: end-minio-notify-nats-cert-authority

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_CERT_AUTHORITY`.

   .. mc-conf:: client_cert
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-client-cert
         :end-before: end-minio-notify-nats-client-cert

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_CLIENT_CERT`.

   .. mc-conf:: client_key
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-client-key
         :end-before: end-minio-notify-nats-client-key

      This configuration setting corresponds with the environment variable
      :envvar:`MINIO_NOTIFY_NATS_CLIENT_KEY`.

   
   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-queue-dir
         :end-before: end-minio-notify-nats-queue-dir

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_NATS_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-queue-limit
         :end-before: end-minio-notify-nats-queue-limit

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_NATS_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-comment
         :end-before: end-minio-notify-nats-comment

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_NATS_COMMENT` environment variable.

.. _minio-server-config-bucket-notification-postgresql:

PostgreSQL Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an PostgreSQL
service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-postgresql` for a tutorial on 
using these environment variables.

.. mc-conf:: notify_postgresql

   The top-level configuration key for defining an PostgreSQL service endpoint for use
   with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an PostgreSQL service endpoint. 
   The following arguments are *required* for each target: 
   
   - :mc-conf:`~notify_postgresql.connection_string`
   - :mc-conf:`~notify_postgresql.table`
   - :mc-conf:`~notify_postgresql.format`

   Specify additional optional arguments as a whitespace (``" "``)-delimited 
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_postgresql \ 
        connection_string="host=postgresql.example.com port=5432..."
        table="minioevents" \
        format="namespace" \
        [ARGUMENT="VALUE"] ... \

   You can specify multiple PostgreSQL service endpoints by appending ``[:name]`` to
   the top level key. For example, the following commands set two distinct PostgreSQL
   service endpoints as ``primary`` and ``secondary`` respectively:

   .. code-block:: shell

      mc admin config set notify_postgresql:primary \ 
         connection_string="host=postgresql.example.com port=5432..."
         table="minioevents" \
         format="namespace" \
         [ARGUMENT=VALUE ...]

      mc admin config set notify_postgresql:secondary \
         connection_string="host=postgresql.example.com port=5432..."
         table="minioevents" \
         format="namespace" \
         [ARGUMENT=VALUE ...]

   The :mc-conf:`notify_postgresql` configuration key supports the following 
   arguments:

   .. mc-conf:: connection_string
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-connection-string
         :end-before: end-minio-notify-postgresql-connection-string
      
      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_POSTGRESQL_CONNECTION_STRING` environment
      variable.

   .. mc-conf:: table
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-table
         :end-before: end-minio-notify-postgresql-table
      
      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_POSTGRESQL_TABLE` environment
      variable.

   .. mc-conf:: format
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-format
         :end-before: end-minio-notify-postgresql-format
      
      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_POSTGRESQL_FORMAT` environment
      variable.

   .. mc-conf:: max_open_connections
      :delimiter: " "
      
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-max-open-connections
         :end-before: end-minio-notify-postgresql-max-open-connections
      
      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_POSTGRESQL_MAX_OPEN_CONNECTIONS` environment
      variable.


   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-queue-dir
         :end-before: end-minio-notify-postgresql-queue-dir

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_POSTGRESQL_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-queue-limit
         :end-before: end-minio-notify-postgresql-queue-limit

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_POSTGRESQL_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-comment
         :end-before: end-minio-notify-postgresql-comment

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_POSTGRESQL_COMMENT` environment variable.

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
      
      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_MYSQL_DSN_STRING` environment
      variable.

   .. mc-conf:: table
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-table
         :end-before: end-minio-notify-mysql-table
      
      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_MYSQL_TABLE` environment
      variable.

   .. mc-conf:: format
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-format
         :end-before: end-minio-notify-mysql-format
      
      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_MYSQL_FORMAT` environment
      variable.

   .. mc-conf:: max_open_connections
      :delimiter: " "
      
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-max-open-connections
         :end-before: end-minio-notify-mysql-max-open-connections
      
      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_MYSQL_MAX_OPEN_CONNECTIONS` environment
      variable.


   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-queue-dir
         :end-before: end-minio-notify-mysql-queue-dir

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_MYSQL_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-queue-limit
         :end-before: end-minio-notify-mysql-queue-limit

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_MYSQL_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-comment
         :end-before: end-minio-notify-mysql-comment

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_MYSQL_COMMENT` environment variable.

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

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_BROKERS` environment variable.

   .. mc-conf:: topic
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-topic
         :end-before: end-minio-notify-kafka-topic

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_TOPIC` environment variable.

   .. mc-conf:: sasl
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-sasl-root
         :end-before: end-minio-notify-kafka-sasl-root

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_SASL` environment variable.

   .. mc-conf:: sasl_username
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-sasl-username
         :end-before: end-minio-notify-kafka-sasl-username

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_SASL_USERNAME` environment variable.

   .. mc-conf:: sasl_password
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-sasl-password
         :end-before: end-minio-notify-kafka-sasl-password

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_SASL_PASSWORD` environment variable.

   .. mc-conf:: sasl_mechanism
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-sasl-mechanism
         :end-before: end-minio-notify-kafka-sasl-mechanism

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_SASL_MECHANISM` environment variable.

   .. mc-conf:: tls_client_auth
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-tls-client-auth
         :end-before: end-minio-notify-kafka-tls-client-auth

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_TLS_CLIENT_AUTH` environment variable.

   .. mc-conf:: tls
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-tls-root
         :end-before: end-minio-notify-kafka-tls-root

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_TLS` environment variable.

   .. mc-conf:: tls_skip_verify
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-tls-skip-verify
         :end-before: end-minio-notify-kafka-tls-skip-verify

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_TLS_SKIP_VERIFY` environment variable.

   .. mc-conf:: client_tls_cert
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-client-tls-cert
         :end-before: end-minio-notify-kafka-client-tls-cert

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_CLIENT_TLS_CERT` environment variable.

   .. mc-conf:: client_tls_key
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-client-tls-key
         :end-before: end-minio-notify-kafka-client-tls-key

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_CLIENT_TLS_KEY` environment variable.

   .. mc-conf:: version
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-version
         :end-before: end-minio-notify-kafka-version

      This configuration setting corresponds to the
      :envvar:`MINIO_NOTIFY_KAFKA_VERSION` environment variable.


   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-queue-dir
         :end-before: end-minio-notify-kafka-queue-dir

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_KAFKA_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-queue-limit
         :end-before: end-minio-notify-kafka-queue-limit

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_KAFKA_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-kafka-comment
         :end-before: end-minio-notify-kafka-comment

      This configuration setting corresponds to the 
      :envvar:`MINIO_NOTIFY_KAFKA_COMMENT` environment variable.

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

      This configuration setting corresponds with the 
      :envvar:`MINIO_NOTIFY_WEBHOOK_ENDPOINT` environment variable.

   .. mc-conf:: auth_token
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-auth-token
         :end-before: end-minio-notify-webhook-auth-token

      This configuration setting corresponds with the 
      :envvar:`MINIO_NOTIFY_WEBHOOK_AUTH_TOKEN` environment variable.

   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-queue-dir
         :end-before: end-minio-notify-webhook-queue-dir

      This configuration setting corresponds with the 
      :envvar:`MINIO_NOTIFY_WEBHOOK_QUEUE_DIR` environment variable.

   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-queue-limit
         :end-before: end-minio-notify-webhook-queue-limit

      This configuration setting corresponds with the 
      :envvar:`MINIO_NOTIFY_WEBHOOK_QUEUE_LIMIT` environment variable.

   .. mc-conf:: client_cert
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-client-cert
         :end-before: end-minio-notify-webhook-client-cert

      This configuration setting corresponds with the 
      :envvar:`MINIO_NOTIFY_WEBHOOK_CLIENT_CERT` environment variable.

   .. mc-conf:: client_key
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-client-key
         :end-before: end-minio-notify-webhook-client-key

      This configuration setting corresponds with the 
      :envvar:`MINIO_NOTIFY_WEBHOOK_CLIENT_KEY` environment variable.

   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-comment
         :end-before: end-minio-notify-webhook-comment

      This configuration setting corresponds with the 
      :envvar:`MINIO_NOTIFY_WEBHOOK_COMMENT` environment variable.

Active Directory / LDAP Identity Management
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for enabling external identity 
management using an Active Directory or LDAP service. See 
:ref:`minio-external-identity-management-ad-ldap` for a tutorial on using these 
configuration settings.

.. mc-conf:: identity_ldap

   The top-level key for configuring
   :ref:`external identity management using Active Directory or LDAP 
   <minio-external-identity-management-ad-ldap>`.

   Use the :mc-cmd:`mc admin config set` to set or update the 
   AD/LDAP configuration. The following arguments are *required*:

   - :mc-conf:`~identity_ldap.server_addr`
   - :mc-conf:`~identity_ldap.lookup_bind_dn`
   - :mc-conf:`~identity_ldap.lookup_bind_password`
   - :mc-conf:`~identity_ldap.user_dn_search_base_dn`
   - :mc-conf:`~identity_ldap.user_dn_search_filter`

   .. code-block:: shell
      :class: copyable

      mc admin config set identity_ldap \
         server_addr="https://ad-ldap.example.net/" \
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

   This environment configuration setting with the 
   :envvar:`MINIO_IDENTITY_LDAP_SERVER_ADDR` environment variable.

   .. mc-conf:: sts_expiry
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-sts-expiry
         :end-before: end-minio-ad-ldap-sts-expiry

      This environment configuration setting with the 
      :envvar:`MINIO_IDENTITY_LDAP_STS_EXPIRY` environment variable.

   .. mc-conf:: lookup_bind_dn
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-lookup-bind-dn
         :end-before: end-minio-ad-ldap-lookup-bind-dn

      This environment configuration setting with the 
      :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN` environment variable.

   .. mc-conf:: lookup_bind_password
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-lookup-bind-password
         :end-before: end-minio-ad-ldap-lookup-bind-password
         
      This environment variable configuration setting the 
      :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD` environment variable.

   .. mc-conf:: user_dn_search_base_dn
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-user-dn-search-base-dn
         :end-before: end-minio-ad-ldap-user-dn-search-base-dn
         
      This environment variable configuration setting the 
      :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN` environment variable.

   .. mc-conf:: user_dn_search_filter
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-user-dn-search-filter
         :end-before: end-minio-ad-ldap-user-dn-search-filter
         
      This environment variable configuration setting the 
      :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER` environment variable.

   .. mc-conf:: username_format
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-username-format
         :end-before: end-minio-ad-ldap-username-format

      This environment configuration setting with the 
      :envvar:`MINIO_IDENTITY_LDAP_USERNAME_FORMAT` environment variable.

   .. mc-conf:: group_search_filter
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-group-search-filter
         :end-before: end-minio-ad-ldap-group-search-filter
         
      This environment variable configuration setting the 
      :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER` environment variable.

   .. mc-conf:: group_search_base_dn
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-group-search-base-dn
         :end-before: end-minio-ad-ldap-group-search-base-dn
         
      This environment variable configuration setting the 
      :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN` environment variable.

   .. mc-conf:: tls_skip_verify
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-tls-skip-verify
         :end-before: end-minio-ad-ldap-tls-skip-verify

      This environment configuration setting with the 
      :envvar:`MINIO_IDENTITY_LDAP_TLS_SKIP_VERIFY` environment variable.

   .. mc-conf:: server_insecure
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-server-insecure
         :end-before: end-minio-ad-ldap-server-insecure

      This environment configuration setting with the 
      :envvar:`MINIO_IDENTITY_LDAP_SERVER_INSECURE` environment variable.

   .. mc-conf:: server_starttls
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-server-starttls
         :end-before: end-minio-ad-ldap-server-starttls

      This environment configuration setting with the 
      :envvar:`MINIO_IDENTITY_LDAP_SERVER_STARTTLS` environment variable.

   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-comment
         :end-before: end-minio-ad-ldap-comment

      This configuration setting corresponds with the 
      :envvar:`MINIO_IDENTITY_LDAP_COMMENT` environment variable.   

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

      This configuration setting corresponds with the 
      :envvar:`MINIO_IDENTITY_OPENID_CONFIG_URL` environment variable.

   .. mc-conf:: client_id
      :delimiter: " "

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-client-id
         :end-before: end-minio-openid-client-id

      This configuration setting corresponds with the 
      :envvar:`MINIO_IDENTITY_OPENID_CLIENT_ID` environment variable.

   .. mc-conf:: client_secret
      :delimiter: " "

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-client-secret
         :end-before: end-minio-openid-client-secret

      This configuration setting corresponds with the 
      :envvar:`MINIO_IDENTITY_OPENID_CLIENT_SECRET` environment variable.
      
   .. mc-conf:: claim_name
      :delimiter: " "

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-claim-name
         :end-before: end-minio-openid-claim-name

      This configuration setting corresponds with the 
      :envvar:`MINIO_IDENTITY_OPENID_CLAIM_NAME` environment variable.
      
   .. mc-conf:: claim_prefix
      :delimiter: " "

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-claim-prefix
         :end-before: end-minio-openid-claim-prefix

      This configuration setting corresponds with the 
      :envvar:`MINIO_IDENTITY_OPENID_CLAIM_PREFIX` environment variable.
      
   .. mc-conf:: scopes
      :delimiter: " "

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-scopes
         :end-before: end-minio-openid-scopes

      This configuration setting corresponds with the 
      :envvar:`MINIO_IDENTITY_OPENID_SCOPES` environment variable.
      
   .. mc-conf:: redirect_uri
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-redirect-uri
         :end-before: end-minio-openid-redirect-uri

      This configuration setting corresponds with the 
      :envvar:`MINIO_IDENTITY_OPENID_REDIRECT_URI` environment variable.

   .. mc-conf:: comment
      :delimiter: " "

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-comment
         :end-before: end-minio-openid-comment

      This configuration setting corresponds with the 
      :envvar:`MINIO_IDENTITY_OPENID_COMMENT` environment variable.
      