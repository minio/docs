.. _minio-server-envvar-bucket-notification-nsq:

==============================
Settings for NSQ Notifications
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an NSQ service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-nsq` for a tutorial on using these settings.

Environment Variables
---------------------

You can specify multiple NSQ service endpoints by appending a unique identifier ``_ID`` to the end of the top level key for each set of related NSQ environment variables.
For example, the following commands set two distinct NSQ service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

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

   This environment variable corresponds with the :mc-conf:`notify_nsq <notify_nsq>` configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_NSQD_ADDRESS

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-nsqd-address
      :end-before: end-minio-notify-nsq-nsqd-address

   This environment variable corresponds with the :mc-conf:`notify_nsq nsqd_address <notify_nsq.nsqd_address>` configuration setting.

   .. include:: /includes/linux/minio-server.rst
      :start-after: start-notify-target-online-desc
      :end-before: end-notify-target-online-desc

.. envvar:: MINIO_NOTIFY_NSQ_TOPIC

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-topic
      :end-before: end-minio-notify-nsq-topic

   This environment variable corresponds with the :mc-conf:`notify_nsq topic <notify_nsq.topic>` configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_TLS

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-tls
      :end-before: end-minio-notify-nsq-tls

   This environment variable corresponds with the :mc-conf:`notify_nsq tls <notify_nsq.tls>` configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_TLS_SKIP_VERIFY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-tls-skip-verify
      :end-before: end-minio-notify-nsq-tls-skip-verify

   This environment variable corresponds with the :mc-conf:`notify_nsq tls_skip_verify <notify_nsq.tls_skip_verify>` configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-queue-dir
      :end-before: end-minio-notify-nsq-queue-dir

   This environment variable corresponds with the :mc-conf:`notify_nsq queue_dir <notify_nsq.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-queue-limit
      :end-before: end-minio-notify-nsq-queue-limit

   This environment variable corresponds with the :mc-conf:`notify_nsq queue_limit <notify_nsq.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_NSQ_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nsq-comment
      :end-before: end-minio-notify-nsq-comment

   This environment variable corresponds with the :mc-conf:`notify_nsq comment <notify_nsq.comment>` configuration setting.

.. _minio-server-config-bucket-notification-nsq:

Configuration Values
--------------------

The following section documents settings for configuring an NSQ server/broker as a publishing target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-nsq` for a tutorial on using these configuration settings.

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

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_NSQD_ADDRESS` environment variable.
      
      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: topic
      :delimiter: " "

      *Required*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-topic
         :end-before: end-minio-notify-nsq-topic

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_TOPIC` environment variable.
      
   .. mc-conf:: tls
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-tls
         :end-before: end-minio-notify-nsq-tls

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_TLS` environment variable.
      
      
   .. mc-conf:: tls_skip_verify
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-tls-skip-verify
         :end-before: end-minio-notify-nsq-tls-skip-verify

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_TLS_SKIP_VERIFY` environment variable.
     
      
   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-queue-dir
         :end-before: end-minio-notify-nsq-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_QUEUE_DIR` environment variable.
      
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-queue-limit
         :end-before: end-minio-notify-nsq-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nsq-comment
         :end-before: end-minio-notify-nsq-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NSQ_COMMENT` environment variable.