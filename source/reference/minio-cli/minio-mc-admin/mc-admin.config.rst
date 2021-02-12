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

The :mc-cmd:`mc admin config` command manages configuration settings for the
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

   Sets a :ref:`configuration key <minio-server-configuration-settings>` on the 
   MinIO deployment.

.. mc-cmd:: get
   :fullpath:

   Gets a :ref:`configuration key <minio-server-configuration-settings>` on the
   MinIO deployment.

.. _minio-server-configuration-settings:

Configuration Settings
----------------------

The following configuration settings define runtime behavior of the 
MinIO :mc:`server <minio server>` process:

.. _minio-server-config-bucket-notification-amqp:

AMQP Service for Bucket Notifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section documents settings for configuring an AMQP
service as a target for :doc:`MinIO Bucket Notifications
</concepts/bucket-notifications>`. See
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

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-exchange
         :end-before:  end-minio-notify-amqp-exchange

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_EXCHANGE`
      environment variable.

   .. mc-conf:: exchange_type 
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-exchange-type
         :end-before:  end-minio-notify-amqp-exchange-type

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_EXCHANGE_TYPE`
      environment variable.

   .. mc-conf:: routing_key 
      :delimiter: " "
   
      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-routing-key
         :end-before:  end-minio-notify-amqp-routing-key

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_ROUTING_KEY`
      environment variable.

   .. mc-conf:: mandatory 
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-mandatory
         :end-before:  end-minio-notify-amqp-mandatory

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_MANDATORY`
      environment variable.

   .. mc-conf:: durable 
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-durable
         :end-before:  end-minio-notify-amqp-durable

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_DURABLE`
      environment variable.

   .. mc-conf:: no_wait 
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-no-wait
         :end-before:  end-minio-notify-amqp-no-wait

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_NO_WAIT`
      environment variable.

   .. mc-conf:: internal 
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-internal
         :end-before:  end-minio-notify-amqp-internal

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_INTERNAL`
      environment variable.

   .. explanation is very unclear. Need to revisit this.

   .. mc-conf:: auto_deleted 
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-auto-deleted
         :end-before:  end-minio-notify-amqp-auto-deleted

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_AUTO_DELETED`
      environment variable.

   .. mc-conf:: delivery_mode 
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-delivery-mode
         :end-before:  end-minio-notify-amqp-delivery-mode

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_DELIVERY_MODE`
      environment variable.

   .. mc-conf:: queue_dir 
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-queue-dir
         :end-before:  end-minio-notify-amqp-queue-dir

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_QUEUE_DIR`
      environment variable.

   .. mc-conf:: queue_limit 
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-queue-limit
         :end-before:  end-minio-notify-amqp-queue-limit

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_QUEUE_LIMIT`
      environment variable.

   .. mc-conf:: comment 
      :delimiter: " "

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-amqp-comment
         :end-before:  end-minio-notify-amqp-comment

      This field corresponds to the :envvar:`MINIO_NOTIFY_AMQP_COMMENT`
      environment variable.