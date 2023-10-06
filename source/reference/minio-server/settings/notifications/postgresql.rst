.. _minio-server-envvar-bucket-notification-postgresql:

=====================================
Settings for PostgreSQL Notifications
=====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an POSTGRES service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-postgresql` for a tutorial on using these settings.

Environment Variables
---------------------

You can specify multiple PostgreSQL service endpoints by appending a unique identifier ``_ID`` for each set of related PostgreSQL environment variables on to the top level key. 
For example, the following commands set two distinct PostgreSQL service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

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

For example, :envvar:`MINIO_NOTIFY_POSTGRES_ENABLE_PRIMARY <MINIO_NOTIFY_POSTGRES_ENABLE>` indicates the environment variable is associated to an PostgreSQL service endpoint with ID of ``PRIMARY``.

.. envvar:: MINIO_NOTIFY_POSTGRES_ENABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-enable
      :end-before: end-minio-notify-postgresql-enable

   Requires specifying the following additional environment variables if set to ``on``:

   - :envvar:`MINIO_NOTIFY_POSTGRES_CONNECTION_STRING`
   - :envvar:`MINIO_NOTIFY_POSTGRES_TABLE`
   - :envvar:`MINIO_NOTIFY_POSTGRES_FORMAT`

   This environment variable corresponds with the :mc-conf:`notify_postgres <notify_postgres>` configuration setting.

.. envvar:: MINIO_NOTIFY_POSTGRES_CONNECTION_STRING

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-connection-string
      :end-before: end-minio-notify-postgresql-connection-string

   This environment variable corresponds with the :mc-conf:`notify_postgres connection_string <notify_postgres.connection_string>` configuration setting.

   .. include:: /includes/linux/minio-server.rst
      :start-after: start-notify-target-online-desc
      :end-before: end-notify-target-online-desc

.. envvar:: MINIO_NOTIFY_POSTGRES_TABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-table
      :end-before: end-minio-notify-postgresql-table

   This environment variable corresponds with the :mc-conf:`notify_postgres table <notify_postgres.table>` configuration setting.


.. envvar:: MINIO_NOTIFY_POSTGRES_FORMAT

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-format
      :end-before: end-minio-notify-postgresql-format

   This environment variable corresponds with the :mc-conf:`notify_postgres format <notify_postgres.format>` configuration setting.


.. envvar:: MINIO_NOTIFY_POSTGRES_MAX_OPEN_CONNECTIONS

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-max-open-connections
      :end-before: end-minio-notify-postgresql-max-open-connections

   This environment variable corresponds with the :mc-conf:`notify_postgres max_open_connections <notify_postgres.max_open_connections>` configuration setting.

.. envvar:: MINIO_NOTIFY_POSTGRES_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-queue-dir
      :end-before: end-minio-notify-postgresql-queue-dir

   This environment variable corresponds with the :mc-conf:`notify_postgres queue_dir <notify_postgres.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_POSTGRES_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-queue-limit
      :end-before: end-minio-notify-postgresql-queue-limit

   This environment variable corresponds with the :mc-conf:`notify_postgres queue_limit <notify_postgres.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_POSTGRES_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-postgresql-comment
      :end-before: end-minio-notify-postgresql-comment

   This environment variable corresponds with the :mc-conf:`notify_postgres comment <notify_postgres.comment>` configuration setting.


.. _minio-server-config-bucket-notification-postgresql:

Configuration Values
--------------------

The following section documents settings for configuring an PostgreSQL service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-postgresql` for a tutorial on using these environment variables.

.. mc-conf:: notify_postgres

   The top-level configuration key for defining an PostgreSQL service endpoint for use
   with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an PostgreSQL service endpoint. 
   The following arguments are *required* for each target: 
   
   - :mc-conf:`~notify_postgres.connection_string`
   - :mc-conf:`~notify_postgres.table`
   - :mc-conf:`~notify_postgres.format`

   Specify additional optional arguments as a whitespace (``" "``)-delimited 
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_postgres \ 
        connection_string="host=postgresql.example.com port=5432..."
        table="minioevents" \
        format="namespace" \
        [ARGUMENT="VALUE"] ... \

   You can specify multiple PostgreSQL service endpoints by appending ``[:name]`` to
   the top level key. For example, the following commands set two distinct PostgreSQL
   service endpoints as ``primary`` and ``secondary`` respectively:

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

   The :mc-conf:`notify_postgres` configuration key supports the following 
   arguments:

   .. mc-conf:: connection_string
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-connection-string
         :end-before: end-minio-notify-postgresql-connection-string
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_CONNECTION_STRING` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: table
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-table
         :end-before: end-minio-notify-postgresql-table
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_TABLE` environment variable.

   .. mc-conf:: format
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-format
         :end-before: end-minio-notify-postgresql-format
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_FORMAT` environment variable.

   .. mc-conf:: max_open_connections
      :delimiter: " "
      
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-max-open-connections
         :end-before: end-minio-notify-postgresql-max-open-connections
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_MAX_OPEN_CONNECTIONS` environment variable.


   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-queue-dir
         :end-before: end-minio-notify-postgresql-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-queue-limit
         :end-before: end-minio-notify-postgresql-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-postgresql-comment
         :end-before: end-minio-notify-postgresql-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_POSTGRES_COMMENT` environment variable.