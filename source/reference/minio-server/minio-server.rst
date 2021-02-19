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

.. envvar:: MINIO_ACCESS_KEY

   The access key for the :ref:`root <minio-users-root>` user. 

   .. warning::

      If :envvar:`MINIO_ACCESS_KEY` is unset, 
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments. 
      MinIO strongly recommends specifying a unique, long, and random
      :envvar:`MINIO_ACCESS_KEY` value for all environments.

.. envvar:: MINIO_SECRET_KEY

   The secret key for the :ref:`root <minio-users-root>` user.

   .. warning::

      If :envvar:`MINIO_SECRET_KEY` is unset,
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments.
      MinIO strongly recommends specifying a unique, long, and random
      :envvar:`MINIO_ACCESS_KEY` value for all environments.

.. envvar:: MINIO_ACCESS_KEY_OLD

   Used for rotating the :ref:`root <minio-users-root>` user access
   key.

   Restart the :mc:`minio server` process with *all* of the following
   environment variables to rotate the root credentials:

   - :envvar:`MINIO_ACCESS_KEY_OLD` set to the old access key.
   - :envvar:`MINIO_ACCESS_KEY` set to the new access key.
   - :envvar:`MINIO_SECRET_KEY_OLD` set to the old secret key.
   - :envvar:`MINIO_SECRET_KEY` set to the new secret key.

   The :mc:`minio server` process automatically detects and re-encrypts 
   the server configuration with the new credentials. After the process
   restarts successfully, you can restart it without 
   :envvar:`MINIO_ACCESS_KEY_OLD`.

.. envvar:: MINIO_SECRET_KEY_OLD

   Used for rotating the :ref:`root <minio-users-root>` user secret
   key.

   Restart the :mc:`minio server` process with *all* of the following
   environment variables to rotate the root credentials:

   - :envvar:`MINIO_ACCESS_KEY_OLD` set to the old access key.
   - :envvar:`MINIO_ACCESS_KEY` set to the new access key.
   - :envvar:`MINIO_SECRET_KEY_OLD` set to the old secret key.
   - :envvar:`MINIO_SECRET_KEY` set to the new secret key.

   The :mc:`minio server` process automatically detects and re-encrypts 
   the server configuration with the new credentials. After the process
   restarts successfully, you can restart it without 
   :envvar:`MINIO_SECRET_KEY_OLD`.

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
:doc:`MinIO Bucket Notifications </concepts/bucket-notifications>`:
   
- :ref:`minio-server-envvar-bucket-notification-amqp`
- :ref:`minio-server-envvar-bucket-notification-mqtt`

.. _minio-server-envvar-bucket-notification-amqp:

AMQP Service for Bucket Notifications
+++++++++++++++++++++++++++++++++++++

The following section documents environment variables for configuring an AMQP
service as a target for :doc:`MinIO Bucket Notifications
</concepts/bucket-notifications>`. See
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
</concepts/bucket-notifications>`. See
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
   :mc-conf:`notify_mqtt <notify_mqtt.broker>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_TOPIC

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-topic
      :end-before: end-minio-notify-mqtt-topic

   This variable corresponds to the 
   :mc-conf:`notify_mqtt <notify_mqtt.topic>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_USERNAME

   *Required if the MQTT server/broker enforces authentication/authorization*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-username
      :end-before: end-minio-notify-mqtt-username

   This variable corresponds to the 
   :mc-conf:`notify_mqtt <notify_mqtt.username>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_PASSWORD

   *Required if the MQTT server/broker enforces authentication/authorization*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-password
      :end-before: end-minio-notify-mqtt-password

   This variable corresponds to the 
   :mc-conf:`notify_mqtt <notify_mqtt.password>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_QOS

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-qos
      :end-before: end-minio-notify-mqtt-qos

   This variable corresponds to the 
   :mc-conf:`notify_mqtt <notify_mqtt.qos>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_KEEP_ALIVE_INTERVAL

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-keep-alive-interval
      :end-before: end-minio-notify-mqtt-keep-alive-interval

   This variable corresponds to the 
   :mc-conf:`notify_mqtt <notify_mqtt.keep_alive_interval>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_RECONNECT_INTERVAL

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-reconnect-interval
      :end-before: end-minio-notify-mqtt-reconnect-interval

   This variable corresponds to the 
   :mc-conf:`notify_mqtt <notify_mqtt.reconnect_interval>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_QUEUE_DIR

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-queue-dir
      :end-before: end-minio-notify-mqtt-queue-dir

   This variable corresponds to the 
   :mc-conf:`notify_mqtt <notify_mqtt.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_QUEUE_LIMIT

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-queue-limit
      :end-before: end-minio-notify-mqtt-queue-limit

   This variable corresponds to the 
   :mc-conf:`notify_mqtt <notify_mqtt.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_MQTT_COMMENT

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mqtt-comment
      :end-before: end-minio-notify-mqtt-comment

   This variable corresponds to the 
   :mc-conf:`notify_mqtt <notify_mqtt.comment>` configuration setting.

