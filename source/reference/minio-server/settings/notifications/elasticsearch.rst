.. _minio-server-envvar-bucket-notification-elasticsearch:

========================================
Settings for Elasticsearch Notifications
========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an Elasticsearch service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-elasticsearch` for a tutorial on using these settings.

Environment Variables
---------------------

You can specify multiple Elasticsearch service endpoints by appending a unique identifier ``_ID`` for each set of related Elasticsearch environment variables to the end of the top level key. 
For example, the following commands set two distinct Elasticsearch service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

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

   Requires specifying the following additional environment variables if set to ``on``:

   - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_URL`
   - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_INDEX`
   - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_FORMAT`

   This environment variable corresponds with the :mc-conf:`notify_elasticsearch` configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_URL

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-url
      :end-before:  end-minio-notify-elasticsearch-url

   This environment variable corresponds with the :mc-conf:`notify_elasticsearch url <notify_elasticsearch.url>` configuration setting.

   .. include:: /includes/linux/minio-server.rst
      :start-after: start-notify-target-online-desc
      :end-before: end-notify-target-online-desc

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_INDEX

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-index
      :end-before:  end-minio-notify-elasticsearch-index

   This environment variable corresponds with the :mc-conf:`notify_elasticsearch index <notify_elasticsearch.index>` configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_FORMAT

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-format
      :end-before:  end-minio-notify-elasticsearch-format

   This environment variable corresponds with the :mc-conf:`notify_elasticsearch format <notify_elasticsearch.format>` configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_USERNAME

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-username
      :end-before:  end-minio-notify-elasticsearch-username

   This environment variable corresponds with the :mc-conf:`notify_elasticsearch username <notify_elasticsearch.username>` configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_PASSWORD

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-password
      :end-before:  end-minio-notify-elasticsearch-password

   This environment variable corresponds with the :mc-conf:`notify_elasticsearch password <notify_elasticsearch.password>` configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-queue-dir
      :end-before:  end-minio-notify-elasticsearch-queue-dir

   This environment variable corresponds with the :mc-conf:`notify_elasticsearch queue_dir <notify_elasticsearch.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-queue-limit
      :end-before:  end-minio-notify-elasticsearch-queue-limit

   This environment variable corresponds with the :mc-conf:`notify_elasticsearch queue_limit <notify_elasticsearch.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_ELASTICSEARCH_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-elasticsearch-comment
      :end-before:  end-minio-notify-elasticsearch-comment

   This environment variable corresponds with the :mc-conf:`notify_elasticsearch comment <notify_elasticsearch.comment>` configuration setting.


.. _minio-server-config-bucket-notification-elasticsearch:

Configuration Values
--------------------

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

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_URL` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: index
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-index
         :end-before: end-minio-notify-elasticsearch-index

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_INDEX` environment variable.

   .. mc-conf:: format
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-format
         :end-before: end-minio-notify-elasticsearch-format

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_FORMAT` environment variable.

   .. mc-conf:: username
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-username
         :end-before: end-minio-notify-elasticsearch-username

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_USERNAME` environment variable.

   .. mc-conf:: password
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-password
         :end-before: end-minio-notify-elasticsearch-password

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_PASSWORD` environment variable.

   .. mc-conf:: queue_dir 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-queue-dir
         :end-before:  end-minio-notify-elasticsearch-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_QUEUE_DIR` environment variable.

   .. mc-conf:: queue_limit 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-queue-limit
         :end-before:  end-minio-notify-elasticsearch-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_QUEUE_LIMIT` environment variable.

   .. mc-conf:: comment 
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-elasticsearch-comment
         :end-before:  end-minio-notify-elasticsearch-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_ELASTICSEARCH_COMMENT` environment variable.