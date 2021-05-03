============
MinIO Server
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: minio

MinIO Server
------------

The :mc:`minio server` command starts the MinIO server process:

.. code-block:: shell
   :class: copyable

   minio server /mnt/disk{1...4}

For examples of deploying :mc:`minio server` on a bare metal environment, 
see :ref:`minio-installation`.

For examples of deploying :mc:`minio server` on a Kubernetes environment,
see :docs-k8s:`Kubernetes documentation <>`.

Configuration Settings
~~~~~~~~~~~~~~~~~~~~~~

The :mc:`minio server` process stores its configuration in the storage
backend :mc-cmd:`directory <minio server DIRECTORIES>`. You can modify
configuration options using the
:mc-cmd:`mc admin config` command.

Syntax
~~~~~~~

.. mc:: minio server

Starts the ``minio`` server process.

The command has the following syntax:

.. code-block:: shell
   :class: copyable

   minio server [FLAGS] HOSTNAME/DIRECTORIES [HOSTNAME/DIRECTORIES..]

The command accepts the following arguments:

.. mc-cmd:: HOSTNAME

   The hostname of a :mc:`minio server` process.

   For standalone deployments, this field is *optional*. You can start a 
   standalone :mc:`~minio server` process with only the
   :mc-cmd:`~minio server DIRECTORIES` argument.

   For distributed deployments, specify the hostname of each :mc:`minio server`
   in the deployment. The group of :mc:`minio server` processes represent a
   single :ref:`Server Pool <minio-intro-server-pool>`.

   :mc-cmd:`~minio server HOSTNAME` supports MinIO expansion notation
   ``{x...y}`` to denote a sequential series of hostnames. MinIO *requires*
   sequential hostnames to identify each :mc:`minio server` process in the set.
   
   For example,
   ``https://minio{1...4}.example.net`` expands to:

   - ``https://minio1.example.net``
   - ``https://minio2.example.net``
   - ``https://minio3.example.net``
   - ``https://minio4.example.net``

   You must run the :mc:`minio server` command with the *same* combination of
   :mc-cmd:`~minio server HOSTNAME` and :mc-cmd:`~minio server DIRECTORIES` on
   each host in the Server Pool.
   
   Each additional ``HOSTNAME/DIRECTORIES`` pair denotes an additional Server
   Set for the purpose of horizontal expansion of the MinIO deployment. For more
   information on Server Pools, see :ref:`Server Pool <minio-intro-server-pool>`.

.. mc-cmd:: DIRECTORIES

   The directories or drives the :mc:`minio server` process uses as the 
   storage backend. 

   :mc-cmd:`~minio server DIRECTORIES` supports MinIO expansion notation
   ``{x...y}`` to denote a sequential series of folders or drives. For example,
   ``/mnt/disk{1...4}`` expands to:

   - ``/mnt/disk1``
   - ``/mnt/disk2``
   - ``/mnt/disk3``
   - ``/mnt/disk4``

   The :mc-cmd:`~minio server DIRECTORIES` path(s) *must* be empty when first
   starting the :mc:`minio <minio server>` process.

   The :mc:`minio server` process requires *at least* 4 drives or directories
   to enable :ref:`erasure coding <minio-erasure-coding>`.

   .. important::

      MinIO recommends locally-attached drives, where the
      :mc-cmd:`~minio server DIRECTORIES` path points to each disk on the
      host machine. MinIO recommends *against* using network-attached
      storage, as network latency reduces performance of those drives
      compared to locally-attached storage.

      For development or evaluation, you can specify multiple logical
      directories or partitions on a single physical volume to enable erasure
      coding on the deployment.
      
      For production environments, MinIO does **not recommend** using multiple
      logical directories or partitions on a single physical disk. While MinIO
      supports those configurations, the potential cost savings come at the risk
      of decreased reliability.
      

.. mc-cmd:: address
   :option:

   *Optional* Binds the :mc:`minio <minio server>` server process to a
   specific network address and port number. Specify the address and port as
   ``ADDRESS:PORT``, where ``ADDRESS`` is an IP address or hostname and
   ``PORT`` is a valid and open port on the host system.

   To change the port number for all IP addresses or hostnames configured
   on the host machine, specify ``:PORT`` where ``PORT`` is a valid
   and open port on the host.

   If omitted, :mc:`minio <minio server>` binds to port ``9000`` on all
   configured IP addresses or hostnames on the host machine.

.. mc-cmd:: certs-dir, -S
   :option:

   *Optional* Specifies the path to the folder containing certificates the
   :mc:`minio` process uses for configuring TLS/SSL connectivity.

   Omit to use the default directory paths:

   - Linux/OSX: ``${HOME}/.minio/certs`` 
   - Windows: ``%%USERPROFILE%%\.minio\certs``.

   See :ref:`minio-TLS` for more information on TLS/SSL connectivity.

.. mc-cmd:: quiet
   :option:

   *Optional* Disables startup information.

.. mc-cmd:: anonymous
   :option:

   *Optional* Hides sensitive information from logging.

.. mc-cmd:: json
   :option:

   *Optional* Outputs server logs and startup information in ``JSON``
   format.

.. _minio-server-environment-variables:

Environment Variables
---------------------

The :mc:`minio server` processes uses the following
environment variables during startup to set configuration settings.

Root Credentials
~~~~~~~~~~~~~~~~

.. envvar:: MINIO_ROOT_USER_FILE

   The access key for the :ref:`root <minio-users-root>` user.

   .. warning::

      If :envvar:`MINIO_ROOT_USER_FILE` is unset, 
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments. 
      MinIO strongly recommends specifying a unique, long, and random
      :envvar:`MINIO_ROOT_USER_FILE` value for all environments.

.. envvar:: MINIO_ROOT_PASSWORD_FILE

   The access key for the :ref:`root <minio-users-root>` user.

   .. warning::

      If :envvar:`MINIO_ROOT_PASSWORD_FILE` is unset, 
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments. 
      MinIO strongly recommends specifying a unique, long, and random
      :envvar:`MINIO_ROOT_PASSWORD_FILE` value for all environments.

.. envvar:: MINIO_ACCESS_KEY

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   The access key for the :ref:`root <minio-users-root>` user. 

   This environment variable is *deprecated* in favor of the 
   :envvar:`MINIO_ROOT_USER_FILE` environment variable. 

   .. warning::

      If :envvar:`MINIO_ACCESS_KEY` is unset, 
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments. 
      MinIO strongly recommends specifying a unique, long, and random
      :envvar:`MINIO_ACCESS_KEY` value for all environments.

.. envvar:: MINIO_SECRET_KEY

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   The secret key for the :ref:`root <minio-users-root>` user.

   This environment variable is *deprecated* in favor of the
   :envvar:`MINIO_ROOT_PASSWORD_FILE` environment variable.

   .. warning::

      If :envvar:`MINIO_SECRET_KEY` is unset,
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments.
      MinIO strongly recommends specifying a unique, long, and random
      :envvar:`MINIO_ACCESS_KEY` value for all environments.

.. envvar:: MINIO_ACCESS_KEY_OLD

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   To perform root credential rotation, modify the
   :envvar:`MINIO_ROOT_USER_FILE` and `MINIO_ROOT_PASSWORD_FILE` environment
   variables.

.. envvar:: MINIO_SECRET_KEY_OLD

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   To perform root credential rotation, modify the
   :envvar:`MINIO_ROOT_USER_FILE` and `MINIO_ROOT_PASSWORD_FILE` environment
   variables.

Key Management Service and Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. envvar:: MINIO_KMS_SECRET_KEY

   .. versionadded:: RELEASE.2021-04-22T15-44-28Z

   The client-provided encryption key to use for encrypting the
   MinIO backend (users, groups, policies, and server configuration).
   See :minio-git:`KMS IAM/Config Encryption
   <minio/blob/master/docs/kms/IAM.md>` for more information.

   Specify a 32-bit base-64 encrypted string in the following format:

   ``<key-name>:<encryption-string>``

   - Replace the ``<key-name>`` with any string. You must use this
     key name if you later migrate to using a dedicated KMS for 
     managing encryption keys.

   - Replace ``<encryption-key>`` with a 32-bit base64 encoded value.
     For example:

     .. code-block:: shell
        :class: copyable

        cat /dev/urandom | head -c 32 | base64 -

   Prior to :minio-release:`RELEASE.2021-04-22T15-44-28Z`, MinIO used the
   :ref:`root <minio-users-root>` user credentials for encrypting the backend. 

.. envvar:: MINIO_KMS_KES_ENDPOINT

   The endpoint for the MinIO Key Encryption Service (KES) process to use
   for supporting SSE-S3 and MinIO backend encryption operations.

.. envvar:: MINIO_KMS_KES_KEY_FILE

   The private key associated to the the :envvar:`MINIO_KMS_KES_CERT_FILE` x.509
   certificate to use when authenticating to the KES server. The KES server
   requires clients to present their certificate for performing mutual TLS
   (mTLS).

   See the :minio-git:`KES wiki <kes/wiki/Configuration#policy-configuration>` 
   for more complete documentation on KES access control.

.. envvar:: MINIO_KMS_KES_CERT_FILE

   The x.509 certificate to present to the KES server. The KES server requires
   clients to present their certificate for performing mutual TLS (mTLS).

   The KES server computes an 
   :minio-git:`identity <kes/wiki/Configuration#policy-configuration>`
   from the certificate and compares it to its configured    
   policies. The KES server grants the
   :mc:`minio` server access to only those operations explicitly granted by the
   policy.

   See the :minio-git:`KES wiki <kes/wiki/Configuration#policy-configuration>`
   for more complete documentation on KES access control.

.. envvar:: MINIO_KMS_KES_KEY_NAME

   The name of an external key on the Key Management system (KMS) configured on
   the KES server and used for performing en/decryption operations. MinIO uses
   this key for supporting server-side encryption of objects (SSE-S3) and MinIO
   backend encryption.

Storage Class
~~~~~~~~~~~~~

These environment variables configure the :ref:`parity <minio-ec-parity>`
to use for objects written to the MinIO cluster. 

MinIO Storage Classes are distinct from AWS Storage Classes, where the latter
refers to the specific storage tier on which to store a given object. 

.. envvar:: MINIO_STORAGE_CLASS_STANDARD

   The number of :ref:`parity blocks <minio-ec-parity>` to create for 
   objects with the standard (default) storage class. MinIO uses the
   ``EC:N`` notation to refer to the number of parity blocks (``N``).
   This environment variable only applies to deployments with 
   :ref:`Erasure Coding <minio-erasure-coding>` enabled. 

   Defaults to ``4``. 

.. envvar:: MINIO_STORAGE_CLASS_REDUCED

   The number of :ref:`parity blocks <minio-ec-parity>` to create for objects
   with the reduced redundancy storage class. MinIO uses the ``EC:N``
   notation to refer to the number of parity blocks (``N``). This environment
   variable only applies to deployments with :ref:`Erasure Coding
   <minio-erasure-coding>` enabled. 

   Defaults to ``2``.

.. envvar:: MINIO_STORAGE_CLASS_COMMENT

   Adds a comment to the storage class settings.

Bucket Notifications
~~~~~~~~~~~~~~~~~~~~

These environment variables configure notification targets for use with 
:doc:`MinIO Bucket Notifications </monitoring/bucket-notifications/bucket-notifications>`:
   
- :ref:`minio-server-envvar-bucket-notification-amqp`
- :ref:`minio-server-envvar-bucket-notification-mqtt`
- :ref:`minio-server-envvar-bucket-notification-elasticsearch`
- :ref:`minio-server-envvar-bucket-notification-nsq`
- :ref:`minio-server-envvar-bucket-notification-redis`
- :ref:`minio-server-envvar-bucket-notification-postgresql`
- :ref:`minio-server-envvar-bucket-notification-mysql`
- :ref:`minio-server-envvar-bucket-notification-kafka`
- :ref:`minio-server-envvar-bucket-notification-webhook`

.. _minio-server-envvar-bucket-notification-amqp:

AMQP Service for Bucket Notifications
+++++++++++++++++++++++++++++++++++++

The following section documents environment variables for configuring an AMQP
service as a target for :doc:`MinIO Bucket Notifications
</monitoring/bucket-notifications/bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-amqp` for a tutorial on 
using these environment variables.

You can specify multiple AMQP service endpoints by appending a unique identifier
``_ID`` for each set of related AMQP environment variables:
the top level key. For example, the following commands set two distinct AMQP
service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_AMQP_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_AMQP_URL_PRIMARY="amqp://user:password@amqp-endpoint.example.net:5672"

   set MINIO_NOTIFY_AMQP_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_AMQP_URL_SECONDARY="amqp://user:password@amqp-endpoint.example.net:5672"

For example, :envvar:`MINIO_NOTIFY_AMQP_ENABLE_PRIMARY
<MINIO_NOTIFY_AMQP_ENABLE>` indicates the environment variable is associated to
an AMQP service endpoint with ID of ``PRIMARY``.

.. envvar:: MINIO_NOTIFY_AMQP_ENABLE
   
   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-enable
      :end-before:  end-minio-notify-amqp-enable

   Requires specifying :envvar:`MINIO_NOTIFY_AMQP_URL` if set to ``on``.

.. envvar:: MINIO_NOTIFY_AMQP_URL

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-url
      :end-before:  end-minio-notify-amqp-url

   This field is *required* if :envvar:`MINIO_NOTIFY_AMQP_ENABLE` is ``on``.
   All other AMQP-related variables are optional.

   This variable corresponds to the :mc-conf:`notify_amqp url <notify_amqp.url>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_EXCHANGE 

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-exchange
      :end-before:  end-minio-notify-amqp-exchange

   This variable corresponds to the :mc-conf:`notify_amqp exchange 
   <notify_amqp.exchange>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_EXCHANGE_TYPE 

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-exchange-type
      :end-before:  end-minio-notify-amqp-exchange-type

   This variable corresponds to the :mc-conf:`notify_amqp exchange_type
   <notify_amqp.exchange_type>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_ROUTING_KEY 
   
   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-routing-key
      :end-before:  end-minio-notify-amqp-routing-key

   This variable corresponds to the :mc-conf:`notify_amqp routing_key
   <notify_amqp.routing_key>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_MANDATORY 

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-mandatory
      :end-before:  end-minio-notify-amqp-mandatory

   This variable corresponds to the :mc-conf:`notify_amqp mandatory
   <notify_amqp.mandatory>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_DURABLE 

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-durable
      :end-before:  end-minio-notify-amqp-durable

   This variable corresponds to the :mc-conf:`notify_amqp durable
   <notify_amqp.durable>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_NO_WAIT 

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-no-wait
      :end-before:  end-minio-notify-amqp-no-wait

   This variable corresponds to the :mc-conf:`notify_amqp no_wait
   <notify_amqp.no_wait>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_INTERNAL 

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-internal
      :end-before:  end-minio-notify-amqp-internal

   This variable corresponds to the :mc-conf:`notify_amqp internal
   <notify_amqp.internal>` configuration setting.

   .. explanation is very unclear. Need to revisit this.

.. envvar:: MINIO_NOTIFY_AMQP_AUTO_DELETED 

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-auto-deleted
      :end-before:  end-minio-notify-amqp-auto-deleted

   This variable corresponds to the :mc-conf:`notify_amqp auto_deleted
   <notify_amqp.auto_deleted>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_DELIVERY_MODE 

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-delivery-mode
      :end-before:  end-minio-notify-amqp-delivery-mode

   This variable corresponds to the :mc-conf:`notify_amqp delivery_mode
   <notify_amqp.delivery_mode>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_QUEUE_DIR 

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-queue-dir
      :end-before:  end-minio-notify-amqp-queue-dir

   This variable corresponds to the :mc-conf:`notify_amqp queue_dir
   <notify_amqp.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_QUEUE_LIMIT 


   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-queue-limit
      :end-before:  end-minio-notify-amqp-queue-limit

   This variable corresponds to the :mc-conf:`notify_amqp queue_limit
   <notify_amqp.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_COMMENT 

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-comment
      :end-before:  end-minio-notify-amqp-comment

   This variable corresponds to the :mc-conf:`notify_amqp comment
   <notify_amqp.comment>` configuration setting.

.. _minio-server-envvar-bucket-notification-mqtt:

MQTT Service for Bucket Notifications
+++++++++++++++++++++++++++++++++++++

The following section documents environment variables for configuring an MQTT
service as a target for :doc:`MinIO Bucket Notifications
</monitoring/bucket-notifications/bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-mqtt` for a tutorial on 
using these environment variables.

You can specify multiple MQTT service endpoints by appending a unique identifier
``_ID`` for each set of related MQTT environment variables:
the top level key. For example, the following commands set two distinct MQTT
service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_MQTT_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_MQTT_BROKER_PRIMARY="tcp://user:password@mqtt-endpoint.example.net:1883"

   set MINIO_NOTIFY_MQTT_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_MQTT_BROKER_SECONDARY="tcp://user:password@mqtt-endpoint.example.net:1883"

For example, :envvar:`MINIO_NOTIFY_MQTT_ENABLE_PRIMARY
<MINIO_NOTIFY_MQTT_ENABLE>` indicates the environment variable is associated to
an MQTT service endpoint with ID of ``PRIMARY``.

.. envvar:: MINIO_NOTIFY_MQTT_ENABLE

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-enable
      :end-before: end-minio-notify-mqtt-enable

   This variable corresponds to the 
   :mc-conf:`notify_mqtt <notify_mqtt>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_BROKER

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-broker
      :end-before: end-minio-notify-mqtt-broker

   This variable corresponds to the 
   :mc-conf:`notify_mqtt broker <notify_mqtt.broker>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_TOPIC

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-topic
      :end-before: end-minio-notify-mqtt-topic

   This variable corresponds to the 
   :mc-conf:`notify_mqtt topic <notify_mqtt.topic>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_USERNAME

   *Required if the MQTT server/broker enforces authentication/authorization*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-username
      :end-before: end-minio-notify-mqtt-username

   This variable corresponds to the 
   :mc-conf:`notify_mqtt username <notify_mqtt.username>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_PASSWORD

   *Required if the MQTT server/broker enforces authentication/authorization*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-password
      :end-before: end-minio-notify-mqtt-password

   This variable corresponds to the 
   :mc-conf:`notify_mqtt password <notify_mqtt.password>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_QOS

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-qos
      :end-before: end-minio-notify-mqtt-qos

   This variable corresponds to the 
   :mc-conf:`notify_mqtt qos <notify_mqtt.qos>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_KEEP_ALIVE_INTERVAL

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-keep-alive-interval
      :end-before: end-minio-notify-mqtt-keep-alive-interval

   This variable corresponds to the 
   :mc-conf:`notify_mqtt keep_alive_interval <notify_mqtt.keep_alive_interval>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_RECONNECT_INTERVAL

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-reconnect-interval
      :end-before: end-minio-notify-mqtt-reconnect-interval

   This variable corresponds to the 
   :mc-conf:`notify_mqtt reconnect_interval <notify_mqtt.reconnect_interval>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_QUEUE_DIR

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-queue-dir
      :end-before: end-minio-notify-mqtt-queue-dir

   This variable corresponds to the 
   :mc-conf:`notify_mqtt queue_dir <notify_mqtt.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_QUEUE_LIMIT

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-queue-limit
      :end-before: end-minio-notify-mqtt-queue-limit

   This variable corresponds to the 
   :mc-conf:`notify_mqtt queue_limit <notify_mqtt.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_COMMENT

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-comment
      :end-before: end-minio-notify-mqtt-comment

   This variable corresponds to the 
   :mc-conf:`notify_mqtt comment <notify_mqtt.comment>` configuration setting.

.. _minio-server-envvar-bucket-notification-elasticsearch:

Elasticsearch Service for Bucket Notifications
++++++++++++++++++++++++++++++++++++++++++++++

The following section documents environment variables for configuring an
Elasticsearch service as a target for :doc:`MinIO Bucket Notifications
</monitoring/bucket-notifications/bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-elasticsearch` for a tutorial on using
these environment variables.

You can specify multiple Elasticsearch service endpoints by appending a unique identifier
``_ID`` for each set of related Elasticsearch environment variables:
the top level key. For example, the following commands set two distinct Elasticsearch
service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_ELASTICSEARCH_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_ELASTICSEARCH_URL_PRIMARY="https://user:password@elasticsearch-endpoint.example.net:9200"
   set MINIO_NOTIFY_ELASTICSEARCH_INDEX_PRIMARY="bucketevents"
   set MINIO_NOTIFY_ELASTICSEARCH_FORMAT_PRIMARY="namespace"

   set MINIO_NOTIFY_ELASTICSEARCH_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_ELASTICSEARCH_URL_SECONDARY="https://user:password@elasticsearch-endpoint.example.net:9200"
   set MINIO_NOTIFY_ELASTICSEARCH_INDEX_SECONDARY="bucketevents"
   set MINIO_NOTIFY_ELASTICSEARCH_FORMAT_SECONDARY="namespace"


.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_ENABLE

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-enable
      :end-before:  end-minio-notify-elasticsearch-enable

   Requires specifying the following additional environment variables if set to
   ``on``:

   - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_URL`
   - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_INDEX`
   - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_FORMAT`

   This variable corresponds to the :mc-conf:`notify_elasticsearch`
   configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_URL

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-url
      :end-before:  end-minio-notify-elasticsearch-url

   This variable corresponds to the 
   :mc-conf:`notify_elasticsearch url <notify_elasticsearch.url>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_INDEX

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-index
      :end-before:  end-minio-notify-elasticsearch-index

   This variable corresponds to the 
   :mc-conf:`notify_elasticsearch index <notify_elasticsearch.index>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_FORMAT

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-format
      :end-before:  end-minio-notify-elasticsearch-format

   This variable corresponds to the 
   :mc-conf:`notify_elasticsearch format <notify_elasticsearch.format>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_USERNAME

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-username
      :end-before:  end-minio-notify-elasticsearch-username

   This variable corresponds to the 
   :mc-conf:`notify_elasticsearch username <notify_elasticsearch.username>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_PASSWORD

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-password
      :end-before:  end-minio-notify-elasticsearch-password

   This variable corresponds to the 
   :mc-conf:`notify_elasticsearch password <notify_elasticsearch.password>`
   configuration setting.
.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-queue-dir
      :end-before:  end-minio-notify-elasticsearch-queue-dir

   This variable corresponds to the 
   :mc-conf:`notify_elasticsearch queue_dir <notify_elasticsearch.queue_dir>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-queue-limit
      :end-before:  end-minio-notify-elasticsearch-queue-limit

   This variable corresponds to the 
   :mc-conf:`notify_elasticsearch queue_limit <notify_elasticsearch.queue_limit>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-comment
      :end-before:  end-minio-notify-elasticsearch-comment

   This variable corresponds to the 
   :mc-conf:`notify_elasticsearch comment <notify_elasticsearch.comment>`
   configuration setting.

.. _minio-server-envvar-bucket-notification-nsq:

NSQ Service for Bucket Notifications
++++++++++++++++++++++++++++++++++++

The following section documents environment variables for configuring an
NSQ service as a target for :doc:`MinIO Bucket Notifications
</monitoring/bucket-notifications/bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-nsq` for a tutorial on using
these environment variables.

You can specify multiple NSQ service endpoints by appending a unique
identifier ``_ID`` for each set of related NSQ environment variables:
the top level key. For example, the following commands set two distinct
NSQ service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_NSQ_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_NSQ_NSQD_ADDRESS_PRIMARY="https://user:password@nsq-endpoint.example.net:9200"
   set MINIO_NOTIFY_NSQ_TOPIC_PRIMARY="bucketevents"

   set MINIO_NOTIFY_NSQ_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_NSQ_NSQD_ADDRESS_SECONDARY="https://user:password@nsq-endpoint.example.net:9200"
   set MINIO_NOTIFY_NSQ_TOPIC_SECONDARY="bucketevents"

.. envvar:: MINIO_NOTIFY_NSQ_ENABLE

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-enable
      :end-before: end-minio-notify-nsq-enable

   This variable corresponds to the 
   :mc-conf:`notify_nsq <notify_nsq>` configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_NSQD_ADDRESS

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-nsqd-address
      :end-before: end-minio-notify-nsq-nsqd-address

   This variable corresponds to the 
   :mc-conf:`notify_nsq nsqd_address <notify_nsq.nsqd_address>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_TOPIC

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-topic
      :end-before: end-minio-notify-nsq-topic

   This variable corresponds to the 
   :mc-conf:`notify_nsq topic <notify_nsq.topic>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_TLS

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-tls
      :end-before: end-minio-notify-nsq-tls

   This variable corresponds to the 
   :mc-conf:`notify_nsq tls <notify_nsq.tls>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_TLS_SKIP_VERIFY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-tls-skip-verify
      :end-before: end-minio-notify-nsq-tls-skip-verify

   This variable corresponds to the 
   :mc-conf:`notify_nsq tls_skip_verify <notify_nsq.tls_skip_verify>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-queue-dir
      :end-before: end-minio-notify-nsq-queue-dir

   This variable corresponds to the 
   :mc-conf:`notify_nsq queue_dir <notify_nsq.queue_dir>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-queue-limit
      :end-before: end-minio-notify-nsq-queue-limit

   This variable corresponds to the 
   :mc-conf:`notify_nsq queue_limit <notify_nsq.queue_limit>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-comment
      :end-before: end-minio-notify-nsq-comment

   This variable corresponds to the 
   :mc-conf:`notify_nsq comment <notify_nsq.comment>` 
   configuration setting.

.. _minio-server-envvar-bucket-notification-redis:

Redis Service for Bucket Notifications
++++++++++++++++++++++++++++++++++++++

The following section documents environment variables for configuring an
Redis service as a target for :doc:`MinIO Bucket Notifications
</monitoring/bucket-notifications/bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-redis` for a tutorial on using
these environment variables.

You can specify multiple Redis service endpoints by appending a unique
identifier ``_ID`` for each set of related Redis environment variables: the top
level key. For example, the following commands set two distinct Redis service
endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_REDIS_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_REDIS_REDIS_ADDRESS_PRIMARY="https://user:password@redis-endpoint.example.net:9200"
   set MINIO_NOTIFY_REDIS_KEY_PRIMARY="bucketevents"
   set MINIO_NOTIFY_REDIS_FORMAT_PRIMARY="namespace"


   set MINIO_NOTIFY_REDIS_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_REDIS_REDIS_ADDRESS_SECONDARY="https://user:password@redis-endpoint.example.net:9200"
   set MINIO_NOTIFY_REDIS_KEY_SECONDARY="bucketevents"
   set MINIO_NOTIFY_REDIS_FORMAT_SECONDARY="namespace"

.. envvar:: MINIO_NOTIFY_REDIS_ENABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-enable
      :end-before: end-minio-notify-redis-enable

   Requires specifying the following additional environment variables if set to
   ``on``:

   - :envvar:`MINIO_NOTIFY_REDIS_ADDRESS`
   - :envvar:`MINIO_NOTIFY_REDIS_KEY`
   - :envvar:`MINIO_NOTIFY_REDIS_FORMAT`

   This variable corresponds to the
   :mc-conf:`notify_redis <notify_redis>` configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_ADDRESS

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-address
      :end-before: end-minio-notify-redis-address

   This variable corresponds to the
   :mc-conf:`notify_redis address <notify_redis.address>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_KEY

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-key
      :end-before: end-minio-notify-redis-key

   This variable corresponds to the
   :mc-conf:`notify_redis key <notify_redis.key>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_FORMAT

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-format
      :end-before: end-minio-notify-redis-format

   This variable corresponds to the
   :mc-conf:`notify_redis format <notify_redis.format>` 
   configuration setting.
      

.. envvar:: MINIO_NOTIFY_REDIS_PASSWORD

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-password
      :end-before: end-minio-notify-redis-password

   This variable corresponds to the
   :mc-conf:`notify_redis password <notify_redis.password>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-queue-dir
      :end-before: end-minio-notify-redis-queue-dir

   This variable corresponds to the 
   :mc-conf:`notify_redis queue_dir <notify_redis.queue_dir>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-queue-limit
      :end-before: end-minio-notify-redis-queue-limit

   This variable corresponds to the 
   :mc-conf:`notify_redis queue_limit <notify_redis.queue_limit>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_REDIS_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-redis-comment
      :end-before: end-minio-notify-redis-comment

   This variable corresponds to the 
   :mc-conf:`notify_redis comment <notify_redis.comment>` 
   configuration setting.

.. _minio-server-envvar-bucket-notification-nats:

NATS Service for Bucket Notifications
+++++++++++++++++++++++++++++++++++++

The following section documents environment variables for configuring an NATS
service as a target for :doc:`MinIO Bucket Notifications
</monitoring/bucket-notifications/bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-nats` for a tutorial on 
using these environment variables.

You can specify multiple NATS service endpoints by appending a unique identifier
``_ID`` for each set of related NATS environment variables:
the top level key. For example, the following commands set two distinct NATS
service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_NATS_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_NATS_ADDRESS_PRIMARY="https://nats-endpoint.example.net:4222"
   set MINIO_NOTIFY_NATS_SUBJECT="minioevents"

   set MINIO_NOTIFY_NATS_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_NATS_ADDRESS_SECONDARY="https://nats-endpoint.example.net:4222"
   set MINIO_NOTIFY_NATS_SUBJECT="minioevents"

For example, :envvar:`MINIO_NOTIFY_NATS_ENABLE_PRIMARY
<MINIO_NOTIFY_NATS_ENABLE>` indicates the environment variable is associated to
an NATS service endpoint with ID of ``PRIMARY``.

.. envvar:: MINIO_NOTIFY_NATS_ENABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-enable
      :end-before: end-minio-notify-nats-enable

   This environment variable corresponds with the 
   :mc-conf:`notify_nats <notify_nats>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_ADDRESS

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-address
      :end-before: end-minio-notify-nats-address

   This environment variable corresponds with the 
   :mc-conf:`notify_nats address <notify_nats.address>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_SUBJECT

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-subject
      :end-before: end-minio-notify-nats-subject

   This environment variable corresponds with the 
   :mc-conf:`notify_nats subject <notify_nats.subject>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_USERNAME

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-username
      :end-before: end-minio-notify-nats-username

   This environment variable corresponds with the 
   :mc-conf:`notify_nats username <notify_nats.username>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_PASSWORD

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-password
      :end-before: end-minio-notify-nats-password

   This environment variable corresponds with the 
   :mc-conf:`notify_nats password <notify_nats.password>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_TOKEN

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-token
      :end-before: end-minio-notify-nats-token

   This environment variable corresponds with the 
   :mc-conf:`notify_nats token <notify_nats.token>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_TLS

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-tls
      :end-before: end-minio-notify-nats-tls

   This environment variable corresponds with the 
   :mc-conf:`notify_nats tls <notify_nats.tls>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_TLS_SKIP_VERIFY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-tls-skip-verify
      :end-before: end-minio-notify-nats-tls-skip-verify

   This environment variable corresponds with the 
   :mc-conf:`notify_nats tls_skip_verify <notify_nats.tls_skip_verify>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_PING_INTERVAL

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-ping-interval
      :end-before: end-minio-notify-nats-ping-interval

   This environment variable corresponds with the 
   :mc-conf:`notify_nats ping_interval <notify_nats.ping_interval>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_STREAMING

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-streaming
      :end-before: end-minio-notify-nats-streaming

   This environment variable corresponds with the 
   :mc-conf:`notify_nats streaming <notify_nats.streaming>` configuration 
   setting.

.. envvar:: MINIO_NOTIFY_NATS_STREAMING_ASYNC

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-streaming-async
      :end-before: end-minio-notify-nats-streaming-async

   This environment variable corresponds with the 
   :mc-conf:`notify_nats streaming_async <notify_nats.streaming_async>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_STREAMING_MAX_PUB_ACKS_IN_FLIGHT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-streaming-max-pub-acks-in-flight
      :end-before: end-minio-notify-nats-streaming-max-pub-acks-in-flight

   This environment variable corresponds with the 
   :mc-conf:`notify_nats streaming_max_pub_acks_in_flight 
   <notify_nats.streaming_max_pub_acks_in_flight>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_STREAMING_CLUSTER_ID

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-streaming-cluster-id
      :end-before: end-minio-notify-nats-streaming-cluster-id

   This environment variable corresponds with the 
   :mc-conf:`notify_nats streaming_cluster_id 
   <notify_nats.streaming_cluster_id>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_CERT_AUTHORITY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-cert-authority
      :end-before: end-minio-notify-nats-cert-authority

   This environment variable corresponds with the 
   :mc-conf:`notify_nats cert_authority <notify_nats.cert_authority>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_CLIENT_CERT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-client-cert
      :end-before: end-minio-notify-nats-client-cert

   This environment variable corresponds with the 
   :mc-conf:`notify_nats client_cert <notify_nats.client_cert>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_CLIENT_KEY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-client-key
      :end-before: end-minio-notify-nats-client-key

   This environment variable corresponds with the 
   :mc-conf:`notify_nats client_key <notify_nats.client_key>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-queue-dir
      :end-before: end-minio-notify-nats-queue-dir

   This environment variable corresponds with the 
   :mc-conf:`notify_nats queue_dir <notify_nats.queue_dir>` configuration 
   setting.

.. envvar:: MINIO_NOTIFY_NATS_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-queue-limit
      :end-before: end-minio-notify-nats-queue-limit

   This environment variable corresponds with the 
   :mc-conf:`notify_nats queue_limit <notify_nats.queue_limit>` configuration 
   setting.

.. envvar:: MINIO_NOTIFY_NATS_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-comment
      :end-before: end-minio-notify-nats-comment

   This environment variable corresponds with the 
   :mc-conf:`notify_nats comment <notify_nats.comment>` configuration setting.


.. _minio-server-envvar-bucket-notification-postgresql:

PostgreSQL Service for Bucket Notifications
+++++++++++++++++++++++++++++++++++++++++++

The following section documents environment variables for configuring an POSTGRESQL
service as a target for :doc:`MinIO Bucket Notifications
</monitoring/bucket-notifications/bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-postgresql` for a tutorial on 
using these environment variables.

You can specify multiple PostgreSQL service endpoints by appending a unique identifier
``_ID`` for each set of related PostgreSQL environment variables:
the top level key. For example, the following commands set two distinct PostgreSQL
service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_POSTGRESQL_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_POSTGRESQL_CONNECTION_STRING_PRIMARY="host=postgresql-endpoint.example.net port=4222..."
   set MINIO_NOTIFY_POSTGRESQL_TABLE_PRIMARY="minioevents"
   set MINIO_NOTIFY_POSTGRESQL_FORMAT_PRIMARY="namespace"

   set MINIO_NOTIFY_POSTGRESQL_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_POSTGRESQL_CONNECTION_STRING_SECONDARY="host=postgresql-endpoint.example.net port=4222..."
   set MINIO_NOTIFY_POSTGRESQL_TABLE_SECONDARY="minioevents"
   set MINIO_NOTIFY_POSTGRESQL_FORMAT_SECONDARY="namespace"

For example, :envvar:`MINIO_NOTIFY_POSTGRESQL_ENABLE_PRIMARY
<MINIO_NOTIFY_POSTGRESQL_ENABLE>` indicates the environment variable is
associated to an PostgreSQL service endpoint with ID of ``PRIMARY``.

.. envvar:: MINIO_NOTIFY_POSTGRESQL_ENABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-enable
      :end-before: end-minio-notify-postgresql-enable

   Requires specifying the following additional environment variables if set
   to ``on``:

   - :envvar:`MINIO_NOTIFY_POSTGRESQL_CONNECTION_STRING`
   - :envvar:`MINIO_NOTIFY_POSTGRESQL_TABLE`
   - :envvar:`MINIO_NOTIFY_POSTGRESQL_FORMAT`

   This environment variable corresponds with the
   :mc-conf:`notify_postgresql <notify_postgresql>` configuration setting.

.. envvar:: MINIO_NOTIFY_POSTGRESQL_CONNECTION_STRING
   
   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-connection-string
      :end-before: end-minio-notify-postgresql-connection-string

   This environment variable corresponds with the
   :mc-conf:`notify_postgresql connection_string <notify_postgresql.connection_string>`
   configuration setting.


.. envvar:: MINIO_NOTIFY_POSTGRESQL_TABLE
   
   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-table
      :end-before: end-minio-notify-postgresql-table

   This environment variable corresponds with the
   :mc-conf:`notify_postgresql table <notify_postgresql.table>`
   configuration setting.


.. envvar:: MINIO_NOTIFY_POSTGRESQL_FORMAT
   
   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-format
      :end-before: end-minio-notify-postgresql-format

   This environment variable corresponds with the
   :mc-conf:`notify_postgresql format <notify_postgresql.format>`
   configuration setting.


.. envvar:: MINIO_NOTIFY_POSTGRESQL_MAX_OPEN_CONNECTIONS
   
   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-max-open-connections
      :end-before: end-minio-notify-postgresql-max-open-connections

   This environment variable corresponds with the
   :mc-conf:`notify_postgresql max_open_connections 
   <notify_postgresql.max_open_connections>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_POSTGRESQL_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-queue-dir
      :end-before: end-minio-notify-postgresql-queue-dir

   This environment variable corresponds with the 
   :mc-conf:`notify_postgresql queue_dir <notify_postgresql.queue_dir>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_POSTGRESQL_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-queue-limit
      :end-before: end-minio-notify-postgresql-queue-limit

   This environment variable corresponds with the 
   :mc-conf:`notify_postgresql queue_limit <notify_postgresql.queue_limit>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_POSTGRESQL_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-comment
      :end-before: end-minio-notify-postgresql-comment

   This environment variable corresponds with the 
   :mc-conf:`notify_postgresql comment <notify_postgresql.comment>` 
   configuration setting.

.. _minio-server-envvar-bucket-notification-mysql:

MySQL Service for Bucket Notifications
++++++++++++++++++++++++++++++++++++++

The following section documents environment variables for configuring an MYSQL
service as a target for :doc:`MinIO Bucket Notifications
</monitoring/bucket-notifications/bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-mysql` for a tutorial on 
using these environment variables.

You can specify multiple MySQL service endpoints by appending a unique
identifier ``_ID`` for each set of related MySQL environment variables: the top
level key. For example, the following commands set two distinct MySQL service
endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_MYSQL_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_MYSQL_DSN_STRING_PRIMARY="username:password@tcp(mysql.example.com:3306)/miniodb"
   set MINIO_NOTIFY_MYSQL_TABLE_PRIMARY="minioevents"
   set MINIO_NOTIFY_MYSQL_FORMAT_PRIMARY="namespace"

   set MINIO_NOTIFY_MYSQL_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_MYSQL_DSN_STRING_SECONDARY="username:password@tcp(mysql.example.com:3306)/miniodb"
   set MINIO_NOTIFY_MYSQL_TABLE_SECONDARY="minioevents"
   set MINIO_NOTIFY_MYSQL_FORMAT_SECONDARY="namespace"

For example, :envvar:`MINIO_NOTIFY_MYSQL_ENABLE_PRIMARY
<MINIO_NOTIFY_MYSQL_ENABLE>` indicates the environment variable is
associated to an MySQL service endpoint with ID of ``PRIMARY``.

.. envvar:: MINIO_NOTIFY_MYSQL_ENABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-enable
      :end-before: end-minio-notify-mysql-enable

   Requires specifying the following additional environment variables if set
   to ``on``:

   - :envvar:`MINIO_NOTIFY_MYSQL_DSN_STRING`
   - :envvar:`MINIO_NOTIFY_MYSQL_TABLE`
   - :envvar:`MINIO_NOTIFY_MYSQL_FORMAT`

   This environment variable corresponds with the
   :mc-conf:`notify_mysql <notify_mysql>` configuration setting.

.. envvar:: MINIO_NOTIFY_MYSQL_DSN_STRING
   
   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-connection-string
      :end-before: end-minio-notify-mysql-connection-string

   This environment variable corresponds with the
   :mc-conf:`notify_mysql dsn_string <notify_mysql.dsn_string>`
   configuration setting.


.. envvar:: MINIO_NOTIFY_MYSQL_TABLE
   
   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-table
      :end-before: end-minio-notify-mysql-table

   This environment variable corresponds with the
   :mc-conf:`notify_mysql table <notify_mysql.table>`
   configuration setting.


.. envvar:: MINIO_NOTIFY_MYSQL_FORMAT
   
   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-format
      :end-before: end-minio-notify-mysql-format

   This environment variable corresponds with the
   :mc-conf:`notify_mysql format <notify_mysql.format>`
   configuration setting.


.. envvar:: MINIO_NOTIFY_MYSQL_MAX_OPEN_CONNECTIONS
   
   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-max-open-connections
      :end-before: end-minio-notify-mysql-max-open-connections

   This environment variable corresponds with the
   :mc-conf:`notify_mysql max_open_connections 
   <notify_mysql.max_open_connections>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_MYSQL_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-queue-dir
      :end-before: end-minio-notify-mysql-queue-dir

   This environment variable corresponds with the 
   :mc-conf:`notify_mysql queue_dir <notify_mysql.queue_dir>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_MYSQL_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-queue-limit
      :end-before: end-minio-notify-mysql-queue-limit

   This environment variable corresponds with the 
   :mc-conf:`notify_mysql queue_limit <notify_mysql.queue_limit>` 
   configuration setting.

.. envvar:: MINIO_NOTIFY_MYSQL_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-comment
      :end-before: end-minio-notify-mysql-comment

   This environment variable corresponds with the 
   :mc-conf:`notify_mysql comment <notify_mysql.comment>` 
   configuration setting.


.. _minio-server-envvar-bucket-notification-kafka:

Kafka Service for Bucket Notifications
++++++++++++++++++++++++++++++++++++++

The following section documents environment variables for configuring an
Kafka service as a target for :doc:`MinIO Bucket Notifications
</monitoring/bucket-notifications/bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-kafka` for a tutorial on using
these environment variables.

You can specify multiple Kafka service endpoints by appending a unique
identifier ``_ID`` for each set of related Kafka environment variables: the top
level key. For example, the following commands set two distinct Kafka service
endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

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

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka brokers <notify_kafka.brokers>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_TOPIC

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-topic
      :end-before: end-minio-notify-kafka-topic

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka topic <notify_kafka.topic>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_SASL_USERNAME

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-sasl-username
      :end-before: end-minio-notify-kafka-sasl-username

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka sasl_username <notify_kafka.sasl_username>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_SASL_PASSWORD

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-sasl-password
      :end-before: end-minio-notify-kafka-sasl-password

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka sasl_password <notify_kafka.sasl_password>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_SASL_MECHANISM

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-sasl-mechanism
      :end-before: end-minio-notify-kafka-sasl-mechanism

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka sasl_mechanism <notify_kafka.sasl_mechanism>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_TLS_CLIENT_AUTH

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-tls-client-auth
      :end-before: end-minio-notify-kafka-tls-client-auth

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka tls_client_auth <notify_kafka.tls_client_auth>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_SASL

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-sasl
      :end-before: end-minio-notify-kafka-sasl

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka sasl <notify_kafka.sasl>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_TLS

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-tls
      :end-before: end-minio-notify-kafka-tls

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka tls <notify_kafka.tls>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_TLS_SKIP_VERIFY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-tls-skip-verify
      :end-before: end-minio-notify-kafka-tls-skip-verify

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka tls_skip_verify <notify_kafka.tls_skip_verify>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_CLIENT_TLS_CERT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-client-tls-cert
      :end-before: end-minio-notify-kafka-client-tls-cert

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka client_tls_cert <notify_kafka.client_tls_cert>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_CLIENT_TLS_KEY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-client-tls-key
      :end-before: end-minio-notify-kafka-client-tls-key

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka client_tls_key <notify_kafka.client_tls_key>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_VERSION

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-version
      :end-before: end-minio-notify-kafka-version

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka version <notify_kafka.version>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-queue-dir
      :end-before: end-minio-notify-kafka-queue-dir

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka queue_dir <notify_kafka.queue_dir>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-queue-limit
      :end-before: end-minio-notify-kafka-queue-limit

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka queue_limit <notify_kafka.queue_limit>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_KAFKA_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-kafka-comment
      :end-before: end-minio-notify-kafka-comment

   This environment variable corresponds to the 
   :mc-conf:`notify_kafka comment <notify_kafka.comment>`
   configuration setting.

.. _minio-server-envvar-bucket-notification-webhook:

Webhook Service for Bucket Notifications
++++++++++++++++++++++++++++++++++++++++

The following section documents environment variables for configuring an
Webhook service as a target for :doc:`MinIO Bucket Notifications
</monitoring/bucket-notifications/bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-webhook` for a tutorial on using
these environment variables.

You can specify multiple Webhook service endpoints by appending a unique
identifier ``_ID`` for each set of related Webhook environment variables: the top
level key. For example, the following commands set two distinct Webhook service
endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_WEBHOOK_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_WEBHOOK_ENDPOINT_PRIMARY="https://webhook1.example.net"

   set MINIO_NOTIFY_WEBHOOK_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_WEBHOOK_ENDPOINT_SECONDARY="https://webhook1.example.net"

.. envvar:: MINIO_NOTIFY_WEBHOOK_ENABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-enable
      :end-before: minio-notify-webhook-enable

.. envvar:: MINIO_NOTIFY_WEBHOOK_ENDPOINT
   
   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-endpoint
      :end-before: minio-notify-webhook-endpoint

   This environment variable corresponds with the 
   :mc-conf:`notify_webhook endpoint <notify_webhook.endpoint>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_WEBHOOK_AUTH_TOKEN
   
   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-auth-token
      :end-before: minio-notify-webhook-auth-token

   This environment variable corresponds with the 
   :mc-conf:`notify_webhook auth_token <notify_webhook.auth_token>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_WEBHOOK_QUEUE_DIR
   
   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-queue-dir
      :end-before: minio-notify-webhook-queue-dir

   This environment variable corresponds with the 
   :mc-conf:`notify_webhook queue_dir <notify_webhook.queue_dir>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_WEBHOOK_QUEUE_LIMIT
   
   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-queue-limit
      :end-before: minio-notify-webhook-queue-limit

   This environment variable corresponds with the 
   :mc-conf:`notify_webhook queue_limit <notify_webhook.queue_limit>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_WEBHOOK_CLIENT_CERT
   
   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-client-cert
      :end-before: minio-notify-webhook-client-cert

   This environment variable corresponds with the 
   :mc-conf:`notify_webhook client_cert <notify_webhook.client_cert>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_WEBHOOK_CLIENT_KEY
   
   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-client-key
      :end-before: minio-notify-webhook-client-key

   This environment variable corresponds with the 
   :mc-conf:`notify_webhook client_key <notify_webhook.client_key>`
   configuration setting.

.. envvar:: MINIO_NOTIFY_WEBHOOK_COMMENT
   
   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-comment
      :end-before: minio-notify-webhook-comment

   This environment variable corresponds with the 
   :mc-conf:`notify_webhook comment <notify_webhook.comment>`
   configuration setting.
