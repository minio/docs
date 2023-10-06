.. _minio-server-envvar-bucket-notification-mysql:

================================
Settings for MySQL Notifications
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an MYSQL service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-mysql` for a tutorial on using these settings.

Environment Variables
---------------------

You can specify multiple MySQL service endpoints by appending a unique identifier ``_ID`` for each set of related MySQL environment variables on to the top level key. 
For example, the following commands set two distinct MySQL service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_MYSQL_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_MYSQL_DSN_STRING_PRIMARY="username:password@tcp(mysql.example.com:3306)/miniodb"
   set MINIO_NOTIFY_MYSQL_TABLE_PRIMARY="minioevents"
   set MINIO_NOTIFY_MYSQL_FORMAT_PRIMARY="namespace"

   set MINIO_NOTIFY_MYSQL_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_MYSQL_DSN_STRING_SECONDARY="username:password@tcp(mysql.example.com:3306)/miniodb"
   set MINIO_NOTIFY_MYSQL_TABLE_SECONDARY="minioevents"
   set MINIO_NOTIFY_MYSQL_FORMAT_SECONDARY="namespace"

For example, :envvar:`MINIO_NOTIFY_MYSQL_ENABLE_PRIMARY <MINIO_NOTIFY_MYSQL_ENABLE>` indicates the environment variable is associated to an MySQL service endpoint with ID of ``PRIMARY``.

.. envvar:: MINIO_NOTIFY_MYSQL_ENABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-enable
      :end-before: end-minio-notify-mysql-enable

   Requires specifying the following additional environment variables if set to ``on``:

   - :envvar:`MINIO_NOTIFY_MYSQL_DSN_STRING`
   - :envvar:`MINIO_NOTIFY_MYSQL_TABLE`
   - :envvar:`MINIO_NOTIFY_MYSQL_FORMAT`

   This environment variable corresponds with the :mc-conf:`notify_mysql <notify_mysql>` configuration setting.

.. envvar:: MINIO_NOTIFY_MYSQL_DSN_STRING

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-connection-string
      :end-before: end-minio-notify-mysql-connection-string

   This environment variable corresponds with the :mc-conf:`notify_mysql dsn_string <notify_mysql.dsn_string>` configuration setting.

   .. include:: /includes/linux/minio-server.rst
      :start-after: start-notify-target-online-desc
      :end-before: end-notify-target-online-desc

.. envvar:: MINIO_NOTIFY_MYSQL_TABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-table
      :end-before: end-minio-notify-mysql-table

   This environment variable corresponds with the :mc-conf:`notify_mysql table <notify_mysql.table>` configuration setting.

.. envvar:: MINIO_NOTIFY_MYSQL_FORMAT

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-format
      :end-before: end-minio-notify-mysql-format

   This environment variable corresponds with the :mc-conf:`notify_mysql format <notify_mysql.format>` configuration setting.

.. envvar:: MINIO_NOTIFY_MYSQL_MAX_OPEN_CONNECTIONS

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-max-open-connections
      :end-before: end-minio-notify-mysql-max-open-connections

   This environment variable corresponds with the :mc-conf:`notify_mysql max_open_connections <notify_mysql.max_open_connections>` configuration setting.

.. envvar:: MINIO_NOTIFY_MYSQL_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-queue-dir
      :end-before: end-minio-notify-mysql-queue-dir

   This environment variable corresponds with the :mc-conf:`notify_mysql queue_dir <notify_mysql.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_MYSQL_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-queue-limit
      :end-before: end-minio-notify-mysql-queue-limit

   This environment variable corresponds with the :mc-conf:`notify_mysql queue_limit <notify_mysql.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_MYSQL_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-mysql-comment
      :end-before: end-minio-notify-mysql-comment

   This environment variable corresponds with the :mc-conf:`notify_mysql comment <notify_mysql.comment>` configuration setting.


.. _minio-server-config-bucket-notification-mysql:

Configuration Values
--------------------

The following section documents settings for configuring an MySQL service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-mysql` for a tutorial on using these environment variables.

.. mc-conf:: notify_mysql

   The top-level configuration key for defining an MySQL service endpoint for use
   with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an MySQL service endpoint. 
   The following arguments are *required* for each target: 
   
   - :mc-conf:`~notify_mysql.dsn_string`
   - :mc-conf:`~notify_mysql.table`
   - :mc-conf:`~notify_mysql.format`

   Specify additional optional arguments as a whitespace (``" "``)-delimited 
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_mysql \ 
        dsn_string="username:password@tcp(mysql.example.com:3306)/miniodb"
        table="minioevents" \
        format="namespace" \
        [ARGUMENT="VALUE"] ... \

   You can specify multiple MySQL service endpoints by appending ``[:name]`` to
   the top level key. For example, the following commands set two distinct MySQL
   service endpoints as ``primary`` and ``secondary`` respectively:

   .. code-block:: shell

      mc admin config set notify_mysql:primary \ 
         dsn_string="username:password@tcp(mysql.example.com:3306)/miniodb"
         table="minioevents" \
         format="namespace" \
         [ARGUMENT=VALUE ...]

      mc admin config set notify_mysql:secondary \
         dsn_string="username:password@tcp(mysql.example.com:3306)/miniodb"
         table="minioevents" \
         format="namespace" \
         [ARGUMENT=VALUE ...]

   The :mc-conf:`notify_mysql` configuration key supports the following 
   arguments:

   .. mc-conf:: dsn_string
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-connection-string
         :end-before: end-minio-notify-mysql-connection-string
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_DSN_STRING` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: table
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-table
         :end-before: end-minio-notify-mysql-table
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_TABLE` environment variable.

   .. mc-conf:: format
      :delimiter: " "
      
      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-format
         :end-before: end-minio-notify-mysql-format
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_FORMAT` environment variable.

   .. mc-conf:: max_open_connections
      :delimiter: " "
      
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-max-open-connections
         :end-before: end-minio-notify-mysql-max-open-connections
      
      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_MAX_OPEN_CONNECTIONS` environment variable.


   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-queue-dir
         :end-before: end-minio-notify-mysql-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-queue-limit
         :end-before: end-minio-notify-mysql-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-mysql-comment
         :end-before: end-minio-notify-mysql-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_MYSQL_COMMENT` environment variable.