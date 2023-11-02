.. _minio-server-envvar-bucket-notification-postgresql:
.. _minio-server-config-bucket-notification-postgresql:

================================
PostgreSQL Notification Settings
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an POSTGRES service as a target for :ref:`Bucket Notifications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-postgresql` for a tutorial on using these settings.

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

Multiple PostgreSQL Targets
---------------------------

You can specify multiple PostgreSQL service endpoints by appending a unique identifier ``_ID`` for each set of related PostgreSQL settings on to the top level key. 
For example, the following commands set two distinct PostgreSQL service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell
         :class: copyable
      
         set MINIO_NOTIFY_POSTGRES_ENABLE_PRIMARY="on"
         set MINIO_NOTIFY_POSTGRES_CONNECTION_STRING_PRIMARY="host=postgresql-endpoint.example.net port=4222..."
         set MINIO_NOTIFY_POSTGRES_TABLE_PRIMARY="minioevents"
         set MINIO_NOTIFY_POSTGRES_FORMAT_PRIMARY="namespace"
      
         set MINIO_NOTIFY_POSTGRES_ENABLE_SECONDARY="on"
         set MINIO_NOTIFY_POSTGRES_CONNECTION_STRING_SECONDARY="host=postgresql-endpoint.example.net port=4222..."
         set MINIO_NOTIFY_POSTGRES_TABLE_SECONDARY="minioevents"
         set MINIO_NOTIFY_POSTGRES_FORMAT_SECONDARY="namespace"

   .. tab-item:: Configuration Settings
      :sync: config

      .. code-block:: shell
   
         mc admin config set notify_postgres:primary \ 
            connection_string="host=postgresql.example.com port=5432..."
            table="minioevents" \
            format="namespace" \
            [ARGUMENT=VALUE ...]
   
         mc admin config set notify_postgres:secondary \
            connection_string="host=postgresql.example.com port=5432..."
            table="minioevents" \
            format="namespace" \
            [ARGUMENT=VALUE ...]

With these settings, :envvar:`MINIO_NOTIFY_POSTGRES_ENABLE_PRIMARY <MINIO_NOTIFY_POSTGRES_ENABLE>` indicates the environment variable is associated to an PostgreSQL service endpoint with ID of ``PRIMARY``.

Settings
--------

Enable
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_POSTGRES_ENABLE

      Specify ``on`` to enable publishing bucket notifications to a PostgreSQL service endpoint.

      Defaults to ``off``.

      Requires specifying the following additional environment variables if set to ``on``:
   
      - :envvar:`MINIO_NOTIFY_POSTGRES_CONNECTION_STRING`
      - :envvar:`MINIO_NOTIFY_POSTGRES_TABLE`
      - :envvar:`MINIO_NOTIFY_POSTGRES_FORMAT`

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_postgres

      The top-level configuration key for defining an PostgreSQL service endpoint for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.
   
      Use :mc-cmd:`mc admin config set` to set or update an PostgreSQL service endpoint. 
      The following arguments are *required* for each target: 
      
      - :mc-conf:`~notify_postgres.connection_string`
      - :mc-conf:`~notify_postgres.table`
      - :mc-conf:`~notify_postgres.format`
   
      Specify additional optional arguments as a whitespace (``" "``)-delimited list.

      .. code-block:: shell
         :class: copyable
   
         mc admin config set notify_postgres                            \ 
           connection_string="host=postgresql.example.com port=5432..." \
           table="minioevents"                                          \
           format="namespace"                                           \
           [ARGUMENT="VALUE"] ... 

Connection String
~~~~~~~~~~~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_POSTGRES_CONNECTION_STRING

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_postgres connection_string
         :delimiter: " "

Specify the `URI connection string <https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING>`__ of the PostgreSQL service endpoint. 
MinIO supports ``key=value`` format for the PostgreSQL connection string. 
For example:

``"host=https://postgresql.example.com port=5432 ..."``

For more complete documentation on supported PostgreSQL connection string parameters, see the `PostgreSQL Connection Strings documentation <https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING>`__.

.. include:: /includes/linux/minio-server.rst
   :start-after: start-notify-target-online-desc
   :end-before: end-notify-target-online-desc

Table
~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_POSTGRES_TABLE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_postgres table
         :delimiter: " "

Specify the name of the PostgreSQL table to which MinIO publishes event notifications.

Format
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_POSTGRES_FORMAT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_postgres format
         :delimiter: " "
      
Specify the format of event data written to the PostgreSQL service endpoint.
MinIO supports the following values:

``namespace``
   For each bucket event, MinIO creates a JSON document with the bucket and object name from the event as the document ID and the actual event as part of the document body. 
   Additional updates to that object modify the existing table entry for that object. 
   Similarly, deleting the object also deletes the corresponding table entry.
   
``access``
   For each bucket event, MinIO creates a JSON document with the event details and appends it to the table with a PostgreSQL-generated random ID. 
   Additional updates to an object result in new index entries,    and existing entries remain unmodified.

Max Open Connections
~~~~~~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_POSTGRES_MAX_OPEN_CONNECTIONS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_postgres max_open_connections
         :delimiter: " "

Specify the maximum number of open connections to the PostgreSQL database.

Defaults to ``2``.

Queue Directory
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar
      
      .. envvar:: MINIO_NOTIFY_POSTGRES_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_postgres queue_dir
         :delimiter: " "

Specify the directory path to enable MinIO's persistent event store for undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the PostgreSQL server/broker is offline and replays the stored events when connectivity resumes.

Queue Limit
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_POSTGRES_QUEUE_LIMIT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_postgres queue_limit
         :delimiter: " "

Specify the maximum limit for undelivered messages. 
Defaults to ``100000``.

Comment
~~~~~~~

*Optional*

.. tab-set:: 

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_POSTGRES_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_postgres comment
         :delimiter: " "

Specify a comment to associate with the PostgreSQL configuration.