.. _minio-server-envvar-bucket-notification-nsq:
.. _minio-server-config-bucket-notification-nsq:

=========================
NSQ Notification Settings
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an NSQ service as a target for :ref:`Bucket Notifications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-nsq` for a tutorial on using these settings.

Multiple NSQ Targets
--------------------

You can specify multiple NSQ service endpoints by appending a unique identifier ``_ID`` to the end of the top level key for each set of related NSQ settings.
For example, the following commands set two distinct NSQ service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell
         :class: copyable
      
         set MINIO_NOTIFY_NSQ_ENABLE_PRIMARY="on"
         set MINIO_NOTIFY_NSQ_NSQD_ADDRESS_PRIMARY="https://user:password@nsq-endpoint.example.net:9200"
         set MINIO_NOTIFY_NSQ_TOPIC_PRIMARY="bucketevents"
      
         set MINIO_NOTIFY_NSQ_ENABLE_SECONDARY="on"
         set MINIO_NOTIFY_NSQ_NSQD_ADDRESS_SECONDARY="https://user:password@nsq-endpoint.example.net:9200"
         set MINIO_NOTIFY_NSQ_TOPIC_SECONDARY="bucketevents"

   .. tab-item:: Configuration Settings
      :sync: config

      .. code-block:: shell

         mc admin config set notify_nsq:primary \ 
            nsqd_address="ENDPOINT" \
            topic="<string>" \
            [ARGUMENT="VALUE"] ... \
   
         mc admin config set notify_nsq:secondary \
            nsqd_address="ENDPOINT" \
            topic="<string>" \
            [ARGUMENT="VALUE"] ... \

Settings
--------

Enable
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar
      
      .. envvar:: MINIO_NOTIFY_NSQ_ENABLE

      Specify ``on`` to enable publishing bucket notifications to an NSQ endpoint.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nsq

      The top-level configuration key for defining an NSQ server/broker endpoint for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.
   
      Use :mc-cmd:`mc admin config set` to set or update an NSQ server/broker endpoint. 
      The following arguments are *required* for each endpoint: 
      
      - :mc-conf:`~notify_nsq.nsqd_address`
      - :mc-conf:`~notify_nsq.topic`
   
      Specify additional optional arguments as a whitespace (``" "``)-delimited list.

      .. code-block:: shell
         :class: copyable
   
         mc admin config set notify_nsq                          \ 
            nsqd_address="https://nsq-endpoint.example.net:4150" \
            topic="<string>"                                     \
            [ARGUMENT="VALUE"] ...

NSQ Daemon Server Address
~~~~~~~~~~~~~~~~~~~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NSQ_NSQD_ADDRESS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nsq nsqd_address
         :delimiter: " "

Specify the NSQ server address where the NSQ Daemon runs. 
For example:

``https://nsq-endpoint.example.net:4150``

.. include:: /includes/linux/minio-server.rst
   :start-after: start-notify-target-online-desc
   :end-before: end-notify-target-online-desc

Topic
~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NSQ_TOPIC

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nsq topic
         :delimiter: " "

Specify the name of the NSQ topic MinIO uses when publishing events to the broker.

TLS
~~~

*Optional*

.. tab-set::
   
   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NSQ_TLS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nsq tls
         :delimiter: " "

Specify ``on`` to enable TLS connectivity to the NSQ service broker.

TLS Skip Verify
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NSQ_TLS_SKIP_VERIFY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nsq tls_skip_verify
         :delimiter: " "

Enables or disables TLS verification of the NSQ service broker TLS certificates.

- Specify ``on`` to disable TLS verification (Default).
- Specify ``off`` to enable TLS verification.

Queue Directory
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NSQ_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config
   
      .. mc-conf:: notify_nsq queue_dir
         :delimiter: " "

Specify the directory path to enable MinIO's persistent event store for undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the NSQ server/broker is offline and replays the stored events when connectivity resumes.


Queue Limit
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar
      
      .. envvar:: MINIO_NOTIFY_NSQ_QUEUE_LIMIT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nsq queue_limit
         :delimiter: " "

Specify the maximum limit for undelivered messages. 
Defaults to ``100000``.

Comment
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NSQ_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nsq comment
         :delimiter: " "

Specify a comment to associate with the NSQ configuration.