.. _minio-server-envvar-bucket-notification-elasticsearch:
.. _minio-server-config-bucket-notification-elasticsearch:

===================================
Elasticsearch Notification Settings
===================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an Elasticsearch service as a target for :ref:`Bucket Notifications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-elasticsearch` for a tutorial on using these settings.

Multiple Elasticsearch Targets
------------------------------

You can specify multiple Elasticsearch service endpoints by appending a unique identifier ``_ID`` for each set of related settings. 
For example, the following commands set two distinct Elasticsearch service endpoints as ``PRIMARY`` and ``SECONDARY``, respectively:

Examples
~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

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

   .. tab-item:: Configuration Settings
      :sync: config

      .. code-block:: shell

         mc admin config set notify_elasticsearch:primary \ 
            url="user:password@https://elasticsearch-endpoint.example.net:9200" \
            index="bucketevents" \
            format="namespace" \
            [ARGUMENT=VALUE ...]

         mc admin config set notify_elasticsearch:secondary \
            url="user:password@https://elasticsearch-endpoint.example.net:9200" \
            index="bucketevents" \
            format="namespace" \
            [ARGUMENT=VALUE ...]

      Notice that for configuration settings, the unique identifier appends to ``notify_elasticsearch`` only, not to each individual argument.

Settings
--------

Enable
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MINIO_NOTIFY_ELASTICSEARCH_ENABLE

      Specify ``on`` to enable publishing bucket notifications to an Elasticsearch service endpoint.
      
      Defaults to ``off``.

      Requires specifying the following additional environment variables if set to ``on``:
   
      - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_URL`
      - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_INDEX`
      - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_FORMAT`

   .. tab-item:: Configuration Setting
      
      .. mc-conf:: notify_elasticsearch
      
         The top-level configuration key for defining an Elasticsearch service endpoint for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.
      
         Use :mc-cmd:`mc admin config set` to set or update an Elasticsearch service endpoint. 
         The following arguments are *required* for each target:
         
         - :mc-conf:`~notify_elasticsearch.url`
         - :mc-conf:`~notify_elasticsearch.index`
         - :mc-conf:`~notify_elasticsearch.format`
         
         Specify additional optional arguments as a whitespace (``" "``)-delimited list.
      
         .. code-block:: shell
            :class: copyable
      
            mc admin config set notify_elasticsearch \ 
              url="https://user:password@elasticsearch.example.com:9200" \
              [ARGUMENT="VALUE"] ... \

URL
~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_ELASTICSEARCH_URL

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_elasticsearch url
         :delimiter: " "

Specify the Elasticsearch service endpoint to which MinIO publishes bucket events. 
For example, ``https://elasticsearch.example.com:9200``.

MinIO supports passing authentication information using as URL parameters using the format ``PROTOCOL://USERNAME:PASSWORD@HOSTNAME:PORT``.

.. include:: /includes/linux/minio-server.rst
   :start-after: start-notify-target-online-desc
   :end-before: end-notify-target-online-desc

Index
~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_ELASTICSEARCH_INDEX

   .. tab-item:: Configuration Setting

      .. mc-conf:: notify_elasticsearch index
         :delimiter: " "

Specify the name of the Elasticsearch index in which to store or update MinIO bucket events. 
Elasticsearch automatically creates the index if it does not exist.

Format
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_ELASTICSEARCH_FORMAT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_elasticsearch format
         :delimiter: " "

Specify the format of event data written to the Elasticsearch index. 
MinIO supports the following values:

``namespace``
   For each bucket event, MinIO creates a JSON document with the bucket and object name from the event as the document ID and the actual event as part of the document body. 
   Additional updates to that object modify the existing index entry for that object. 
   Similarly, deleting the object also deletes the corresponding index entry.
   
``access``
   For each bucket event, MinIO creates a JSON document with the event details and appends it to the index with an Elasticsearch-generated random ID. 
   Additional updates to an object result in new index entries,    and existing entries remain unmodified.

Username
~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_ELASTICSEARCH_USERNAME

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_elasticsearch username
         :delimiter: " "

The username for connecting to an Elasticsearch service endpoint which enforces authentication.

Password
~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_ELASTICSEARCH_PASSWORD

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_elasticsearch password
         :delimiter: " "

The password for connecting to an Elasticsearch service endpoint which enforces authentication.

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

Queue Directory
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_ELASTICSEARCH_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_elasticsearch queue_dir 
         :delimiter: " "

Specify the directory path to enable MinIO's persistent event store for undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the Elasticsearch service is offline and replays the stored events when connectivity resumes.

Queue Limit
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_ELASTICSEARCH_QUEUE_LIMIT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_elasticsearch queue_limit 
         :delimiter: " "

Specify the maximum limit for undelivered messages. 
Defaults to ``100000``.

Comment
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_ELASTICSEARCH_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_elasticsearch comment 
         :delimiter: " "

Specify a comment to associate with the Elasticsearch configuration.