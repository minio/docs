.. _minio-server-envvar-bucket-notification-amqp:

===============================
Settings for AMQP Notifications
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an AMQP service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-amqp` for a tutorial on using these settings.

Environment Variables
---------------------

You can specify multiple AMQP service endpoints by appending a unique identifier ``_ID`` for each set of related AMQP environment variables to the top level key. 
For example, the following commands set two distinct AMQP service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_AMQP_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_AMQP_URL_PRIMARY="amqp://user:password@amqp-endpoint.example.net:5672"

   set MINIO_NOTIFY_AMQP_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_AMQP_URL_SECONDARY="amqp://user:password@amqp-endpoint.example.net:5672"

For example, :envvar:`MINIO_NOTIFY_AMQP_ENABLE_PRIMARY <MINIO_NOTIFY_AMQP_ENABLE>` indicates the environment variable is associated to an AMQP service endpoint with ID of ``PRIMARY``.

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

   This environment variable corresponds with the :mc-conf:`notify_amqp url <notify_amqp.url>` configuration setting.

   .. include:: /includes/linux/minio-server.rst
      :start-after: start-notify-target-online-desc
      :end-before: end-notify-target-online-desc

.. envvar:: MINIO_NOTIFY_AMQP_EXCHANGE

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-exchange
      :end-before:  end-minio-notify-amqp-exchange

   This environment variable corresponds with the :mc-conf:`notify_amqp exchange <notify_amqp.exchange>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_EXCHANGE_TYPE

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-exchange-type
      :end-before:  end-minio-notify-amqp-exchange-type

   This environment variable corresponds with the :mc-conf:`notify_amqp exchange_type <notify_amqp.exchange_type>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_ROUTING_KEY

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-routing-key
      :end-before:  end-minio-notify-amqp-routing-key

   This environment variable corresponds with the :mc-conf:`notify_amqp routing_key <notify_amqp.routing_key>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_MANDATORY

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-mandatory
      :end-before:  end-minio-notify-amqp-mandatory

   This environment variable corresponds with the :mc-conf:`notify_amqp mandatory <notify_amqp.mandatory>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_DURABLE

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-durable
      :end-before:  end-minio-notify-amqp-durable

   This environment variable corresponds with the :mc-conf:`notify_amqp durable <notify_amqp.durable>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_NO_WAIT

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-no-wait
      :end-before:  end-minio-notify-amqp-no-wait

   This environment variable corresponds with the :mc-conf:`notify_amqp no_wait <notify_amqp.no_wait>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_INTERNAL

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-internal
      :end-before:  end-minio-notify-amqp-internal

   This environment variable corresponds with the :mc-conf:`notify_amqp internal <notify_amqp.internal>` configuration setting.

   .. explanation is very unclear. Need to revisit this.

.. envvar:: MINIO_NOTIFY_AMQP_AUTO_DELETED

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-auto-deleted
      :end-before:  end-minio-notify-amqp-auto-deleted

   This environment variable corresponds with the :mc-conf:`notify_amqp auto_deleted <notify_amqp.auto_deleted>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_DELIVERY_MODE

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-delivery-mode
      :end-before:  end-minio-notify-amqp-delivery-mode

   This environment variable corresponds with the :mc-conf:`notify_amqp delivery_mode <notify_amqp.delivery_mode>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_QUEUE_DIR

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-queue-dir
      :end-before:  end-minio-notify-amqp-queue-dir

   This environment variable corresponds with the :mc-conf:`notify_amqp queue_dir <notify_amqp.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_QUEUE_LIMIT


   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-queue-limit
      :end-before:  end-minio-notify-amqp-queue-limit

   This environment variable corresponds with the :mc-conf:`notify_amqp queue_limit <notify_amqp.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_AMQP_COMMENT

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-amqp-comment
      :end-before:  end-minio-notify-amqp-comment

   This environment variable corresponds with the :mc-conf:`notify_amqp comment <notify_amqp.comment>` configuration setting.

.. _minio-server-config-bucket-notification-amqp:

Configuration Values
--------------------

The following section documents settings for configuring an AMQP service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-amqp` for a tutorial on using these environment variables.

.. mc-conf:: notify_amqp

   The top-level configuration key for defining an AMQP service endpoint for use
   with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an AMQP service endpoint. 
   The :mc-conf:`~notify_amqp.url` argument is *required* for each target.
   Specify additional optional arguments as a whitespace (``" "``)-delimited list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_amqp \ 
        url="amqp://user:password@endpoint:port" \
        [ARGUMENT="VALUE"] ... \

   You can specify multiple AMQP service endpoints by appending ``[:name]`` to the top level key. 
   For example, the following commands set two distinct AMQP service endpoints as ``primary`` and ``secondary`` respectively:

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