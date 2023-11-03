.. _minio-server-envvar-bucket-notification-amqp:
.. _minio-server-config-bucket-notification-amqp:

==========================
AMQP Notification Settings
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an AMQP service as a target for :ref:`Bucket Notifications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-amqp` for a tutorial on using these settings.

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

Multiple AMQP Targets
---------------------

You can specify multiple AMQP service endpoints by appending a unique identifier ``_ID`` for each set of related AMQP settings to the top level key. 

Examples
~~~~~~~~

For example, the following commands set two distinct AMQP service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. tab-set::
   
   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell
         :class: copyable
      
         set MINIO_NOTIFY_AMQP_ENABLE_PRIMARY="on"
         set MINIO_NOTIFY_AMQP_URL_PRIMARY="amqp://user:password@amqp-endpoint.example.net:5672"
      
         set MINIO_NOTIFY_AMQP_ENABLE_SECONDARY="on"
         set MINIO_NOTIFY_AMQP_URL_SECONDARY="amqp://user:password@amqp-endpoint.example.net:5672"
   
      For example, :envvar:`MINIO_NOTIFY_AMQP_ENABLE_PRIMARY <MINIO_NOTIFY_AMQP_ENABLE>` indicates the environment variable is associated to an AMQP service endpoint with ID of ``PRIMARY``.
   
   .. tab-item:: Configuration Settings
      :sync: config

      .. code-block:: shell

         mc admin config set notify_amqp:primary \ 
            url="user:password@amqp://amqp-endpoint.example.net:5672" [ARGUMENT=VALUE ...]

         mc admin config set notify_amqp:secondary \
            url="user:password@amqp://amqp-endpoint.example.net:5672" [ARGUMENT=VALUE ...]

      Notice that for configuration settings, the unique identifier appends to ``amqp`` only, not to each individual argument.


Settings
--------

Enable
~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MINIO_NOTIFY_AMQP_ENABLE

      Requires specifying :envvar:`MINIO_NOTIFY_AMQP_URL` if set to ``on``.

      Specify ``on`` to enable publishing bucket notifications to an AMQP endpoint.

      Defaults to ``off``.

   .. tab-item:: Configuration Setting

      .. mc-conf:: notify_amqp

      The top-level configuration key for defining an AMQP service endpoint for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

      Use :mc-cmd:`mc admin config set` to set or update an AMQP service endpoint. 
      The :mc-conf:`~notify_amqp.url` argument is *required* for each target.
      Specify additional optional arguments as a whitespace (``" "``)-delimited list.

      .. code-block:: shell
         :class: copyable
   
         mc admin config set notify_amqp \ 
           url="amqp://user:password@endpoint:port" \
           [ARGUMENT="VALUE"] ... 

URL
~~~
      
*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_URL

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp url
         :delimiter: " "

Specify the AMQP server endpoint to which MinIO publishes bucket events.
For example, ``amqp://myuser:mypassword@localhost:5672``.

.. include:: /includes/linux/minio-server.rst
   :start-after: start-notify-target-online-desc
   :end-before: end-notify-target-online-desc

Exchange
~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_EXCHANGE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp exchange 
         :delimiter: " "

Specify the name of the AMQP exchange to use.

Exchange Type
~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_EXCHANGE_TYPE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp exchange_type 
         :delimiter: " "

Specify the type of the AMQP exchange.

Routing Key
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_ROUTING_KEY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp routing_key 
         :delimiter: " "
   
Specify the routing key for publishing events.

Mandatory
~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_MANDATORY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp mandatory 
         :delimiter: " "

Specify ``off`` to ignore undelivered messages errors. 
Defaults to ``on``.

Durable
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_DURABLE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp durable 
         :delimiter: " "

Specify ``on`` to persist the message queue across broker restarts. 
Defaults to ``off``.

No Wait
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_NO_WAIT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp no_wait 
         :delimiter: " "

Specify ``on`` to enable non-blocking message delivery. 
Defaults to ``off``.

Internal
~~~~~~~~

*Optional*

.. tab-set::


   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_INTERNAL

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp internal 
         :delimiter: " "

.. explanation is very unclear. Need to revisit this.

Specify ``on`` to use the exchange only if it is bound to other exchanges. 
See the RabbitMQ documentation on `Exchange to Exchange Bindings
<https://www.rabbitmq.com/e2e.html>`__ for more information on AMQP exchange binding.

Auto Deleted
~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_AUTO_DELETED

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp auto_deleted 
         :delimiter: " "

Specify ``on`` to automatically delete the message queue if there are no consumers. 
Defaults to ``off``.

Delivery Mode
~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_DELIVERY_MODE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp delivery_mode 
         :delimiter: " "

Specify ``1`` for set the delivery mode to non-persistent queue.

Specify ``2`` to set the delivery mode to persistent queue.

Queue Directory
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp queue_dir 
         :delimiter: " "

Specify the directory path to enable MinIO's persistent event store for undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the AMQP service is offline and replays the stored events when connectivity resumes.

Queue Limit
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_QUEUE_LIMIT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp queue_limit 
         :delimiter: " "

Specify the maximum limit for undelivered messages. 
Defaults to ``100000``.

Comment
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_AMQP_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_amqp comment 
         :delimiter: " "

Specify a comment for the AMQP configuration.