.. _minio-server-envvar-bucket-notification-mysql:
.. _minio-server-config-bucket-notification-mysql:

===========================
MySQL Notification Settings
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring a MYSQL service as a target for :ref:`Bucket Notifications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-mysql` for a tutorial on using these settings.

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

Multiple MYSQL Targets
----------------------

You can specify multiple MySQL service endpoints by appending a unique identifier ``_ID`` for each set of related MySQL settings on to the top level key. 

Examples
~~~~~~~~

The following commands set two distinct MySQL service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

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

      With these settings, :envvar:`MINIO_NOTIFY_MYSQL_ENABLE_PRIMARY <MINIO_NOTIFY_MYSQL_ENABLE>` indicates the environment variable is associated to a MySQL service endpoint with ID of ``PRIMARY``.

   .. tab-item:: Configuration Settings
      :sync: config

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

Settings
--------

Enable
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MYSQL_ENABLE

      Specify ``on`` to enable publishing bucket notifications to a MySQL service endpoint.

      Defaults to ``off``.
   
      Requires specifying the following additional environment variables if set to ``on``:
   
      - :envvar:`MINIO_NOTIFY_MYSQL_DSN_STRING`
      - :envvar:`MINIO_NOTIFY_MYSQL_TABLE`
      - :envvar:`MINIO_NOTIFY_MYSQL_FORMAT`

   .. tab-item:: Configuration Settings
      :sync: config

      .. mc-conf:: notify_mysql
   
      The top-level configuration key for defining an MySQL service endpoint for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.
   
      Use :mc-cmd:`mc admin config set` to set or update an MySQL service endpoint. 
      The following arguments are *required* for each target: 
      
      - :mc-conf:`~notify_mysql.dsn_string`
      - :mc-conf:`~notify_mysql.table`
      - :mc-conf:`~notify_mysql.format`
   
      Specify additional optional arguments as a whitespace (``" "``)-delimited list.

      .. code-block:: shell
         :class: copyable
   
         mc admin config set notify_mysql \ 
           dsn_string="username:password@tcp(mysql.example.com:3306)/miniodb"
           table="minioevents" \
           format="namespace" \
           [ARGUMENT="VALUE"] ... \


Data Source Name (DSN) String
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar
      
      .. envvar:: MINIO_NOTIFY_MYSQL_DSN_STRING

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mysql dsn_string
         :delimiter: " "

Specify the data source name (DSN) of the MySQL service endpoint. MinIO expects the following format:

``<user>:<password>@tcp(<host>:<port>)/<database>``
 
For example:
 
``"username:password@tcp(mysql.example.com:3306)/miniodb"``
      
.. include:: /includes/linux/minio-server.rst
   :start-after: start-notify-target-online-desc
   :end-before: end-notify-target-online-desc

Table
~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MYSQL_TABLE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mysql table
         :delimiter: " "

Specify the name of the MySQL table to which MinIO publishes event notifications.
      
Format
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MYSQL_FORMAT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mysql format
         :delimiter: " "
      
Specify the format of event data written to the MySQL service endpoint.
MinIO supports the following values:

``namespace``
   For each bucket event, MinIO creates a JSON document with the bucket and object name from the event as the document ID and the actual event as part of the document body. 
   Additional updates to that object modify the existing table entry for that object. 
   Similarly, deleting the object also deletes the corresponding table entry.
   
``access``
   For each bucket event, MinIO creates a JSON document with the event details and appends it to the table with a MySQL-generated random ID. 
   Additional updates to an object result in new index entries,    and existing entries remain unmodified.
      
Max Open Connections
~~~~~~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MYSQL_MAX_OPEN_CONNECTIONS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mysql max_open_connections
         :delimiter: " "

Specify the maximum number of open connections to the MySQL database.

Defaults to ``2``.
      
Queue Directory
~~~~~~~~~~~~~~~

*Optional*


.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MYSQL_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mysql queue_dir
         :delimiter: " "

Specify the directory path to enable MinIO's persistent event store for undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the MySQL server/broker is offline and replays the stored events when connectivity resumes.

Queue Limit
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MYSQL_QUEUE_LIMIT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mysql queue_limit
         :delimiter: " "

Specify the maximum limit for undelivered messages. Defaults to ``100000``.

Comment
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_MYSQL_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_mysql comment
         :delimiter: " "

Specify a comment to associate with the MySQL configuration.