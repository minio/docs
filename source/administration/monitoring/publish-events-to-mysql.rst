.. _minio-bucket-notifications-publish-mysql:

=======================
Publish Events to MySQL
=======================

.. default-domain:: minio

.. |ARN| replace:: ``arn:minio:sqs::primary:mysql``

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports publishing :ref:`bucket notification
<minio-bucket-notifications>` events to a My`MySQL <https://www.mysql.com/>`__
service endpoint. MinIO supports MySQL 5.7.8 and later *only*.

Add a MySQL Endpoint to a MinIO Deployment
------------------------------------------

The following procedure adds a new MySQL service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

Prerequisites
~~~~~~~~~~~~~

MySQL 5.7.8 and later
+++++++++++++++++++++

MinIO relies on features introduced with MySQL 5.7.8.

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.

1) Add the MySQL Endpoint to MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can configure a new MySQL service endpoint using either environment variables
*or* by setting runtime configuration settings.

.. tab-set::

   .. tab-item:: Environment Variables

      MinIO supports specifying the MySQL service endpoint and associated
      configuration settings using 
      :ref:`environment variables 
      <minio-server-envvar-bucket-notification-mysql>`. The 
      :mc:`minio server` process applies the specified settings on its 
      next startup.
      
      The following example code sets *all*  environment variables
      related to configuring a MySQL service endpoint. The minimum
      *required* variables are:

      - :envvar:`MINIO_NOTIFY_MYSQL_ENABLE`
      - :envvar:`MINIO_NOTIFY_MYSQL_DSN_STRING` 
      - :envvar:`MINIO_NOTIFY_MYSQL_TABLE`
      - :envvar:`MINIO_NOTIFY_MYSQL_FORMAT`
      
      .. code-block:: shell
         :class: copyable

         set MINIO_NOTIFY_MYSQL_DSN_STRING_<IDENTIFIER>="on"
         set MINIO_NOTIFY_MYSQL_TABLE_<IDENTIFIER>="<ENDPOINT>"
         set MINIO_NOTIFY_MYSQL_FORMAT_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_MYSQL_MAX_OPEN_CONNECTIONS_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_MYSQL_QUEUE_DIR_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_MYSQL_QUEUE_LIMIT_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_MYSQL_COMMENT_<IDENTIFIER>="<string>"

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the
        MySQL service endpoint. Use the same ``<IDENTIFIER>`` value for all 
        environment variables related to the new target service endpoint.
        The following examples assume an identifier of ``PRIMARY``.

        If the specified ``<IDENTIFIER>`` matches an existing MySQL service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_mysql <mc admin config get>` to
        review the currently configured MySQL endpoints on the MinIO deployment.

      - Replace ``<ENDPOINT>`` with the DSN of the MySQL service endpoint.
        MinIO expects the following format:

        ``<user>:<password>@tcp(<host>:<port>)/<database>``
         
        For example:
         
        ``"username:password@tcp(mysql.example.com:3306)/miniodb"``


      See :ref:`MySQL Service for Bucket Notifications
      <minio-server-envvar-bucket-notification-mysql>` for complete documentation
      on each environment variable.

   .. tab-item:: Configuration Settings

      MinIO supports adding or updating MySQL endpoints on a running 
      :mc:`minio server` process using the :mc-cmd:`mc admin config set` command 
      and the :mc-conf:`notify_mysql` configuration key. You must restart the 
      :mc:`minio server` process to apply any new or updated configuration
      settings.

      The following example code sets *all*  settings related to configuring an
      MySQL service endpoint. The minimum *required* settings are:
   
      - :mc-conf:`notify_mysql dsn_string <notify_mysql.dsn_string>`
      - :mc-conf:`notify_mysql table <notify_mysql.table>`
      - :mc-conf:`notify_mysql format <notify_mysql.format>`
      

      .. code-block:: shell
         :class: copyable

         mc admin config set ALIAS/ notify_mysql:IDENTIFIER \
            dsn_string="<ENDPOINT>" \
            table="<string>" \
            format="<string>" \
            max_open_connections="<string>" \
            queue_dir="<string>" \
            queue_limit="<string>" \
            comment="<string>" 

      - Replace ``IDENTIFIER`` with a unique descriptive string for the
        MySQL service endpoint. The following examples in this procedure
        assume an identifier of ``PRIMARY``.

        If the specified ``IDENTIFIER`` matches an existing MySQL service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_mysql <mc admin config get>` to
        review the currently configured MySQL endpoints on the MinIO deployment.

      - Replace ``<ENDPOINT>`` with the DSN of the MySQL service endpoint.
        MinIO expects the following format:

        ``<user>:<password>@tcp(<host>:<port>)/<database>``
         
        For example:
         
        ``"username:password@tcp(mysql.example.com:3306)/miniodb"``

      See :ref:`MySQL Bucket Notification Configuration Settings
      <minio-server-config-bucket-notification-mysql>` for complete 
      documentation on each setting.

2) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured MySQL
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:mysql

You must specify the ARN resource when configuring bucket notifications with
the associated MySQL deployment as a target.

.. include:: /includes/common-bucket-notifications.rst
   :start-after: start-bucket-notification-find-arn
   :end-before: end-bucket-notification-find-arn

3) Configure Bucket Notifications using the MySQL Endpoint as a Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc event add` command to add a new bucket notification 
event with the configured MySQL service as a target:

.. code-block:: shell
   :class: copyable

   mc event add ALIAS/BUCKET arn:minio:sqs::primary:mysql \
     --event EVENTS

- Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment.
- Replace ``BUCKET`` with the name of the bucket in which to configure the 
  event.
- Replace ``EVENTS`` with a comma-separated list of :ref:`events 
  <mc-event-supported-events>` for which MinIO triggers notifications.

Use :mc-cmd:`mc event list` to view all configured bucket events for 
a given notification target:

.. code-block:: shell
   :class: copyable

   mc event list ALIAS/BUCKET arn:minio:sqs::primary:mysql

4) Validate the Configured Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on the bucket for which you configured the new event and 
check the MySQL service for the notification data. The action required
depends on which :mc-cmd:`events <mc event add --event>` were specified
when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc-cmd:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET

Update a MySQL Endpoint in a MinIO Deployment
---------------------------------------------

The following procedure updates an existing MySQL service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

Prerequisites
~~~~~~~~~~~~~~

MySQL 5.7.8 and later
+++++++++++++++++++++

MinIO relies on features introduced with MySQL 5.7.8.

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.


1) List Configured MySQL Endpoints In The Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config get` command to list the currently
configured MySQL service endpoints in the deployment:

.. code-block:: shell
   :class: copyable

   mc admin config get ALIAS/ notify_mysql

Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO deployment.

The command output resembles the following:

.. code-block:: shell

   notify_mysql:primary format="namespace" table="minio_images" dsn_string="user:pass@tcp(mysql.example.com:3306)/miniodb"
   notify_mysql:secondary format="namespace" table="minio_images" dsn_string="user:pass@tcp(mysql.example.com:3306)/miniodb"

The :mc-conf:`notify_mysql` key is the top-level configuration key for an
:ref:`minio-server-config-bucket-notification-mysql`. The 
:mc-conf:`dsn_string <notify_mysql.dsn_string>` key specifies the MySQL service
endpoint for the given `notify_mysql` key. The ``notify_mysql:<IDENTIFIER>``
suffix describes the unique identifier for that MySQL service endpoint.

Note the identifier for the MySQL service endpoint you want to update for
the next step. 

2) Update the MySQL Endpoint
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config set` command to set the new configuration
for the MySQL service endpoint:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS/ notify_mysql:IDENTIFIER \
      dsn_string="<ENDPOINT>" \
      table="<string>" \
      format="<string>" \
      max_open_connections="<string>" \
      queue_dir="<string>" \
      queue_limit="<string>" \
      comment="<string>" 

The following configuration settings are the *minimum required* for a MySQL
service endpoint:

- :mc-conf:`notify_mysql dsn_string <notify_mysql.dsn_string>`
- :mc-conf:`notify_mysql table <notify_mysql.table>`
- :mc-conf:`notify_mysql format <notify_mysql.format>`

All other configuration settings are *optional*. See
:ref:`minio-server-config-bucket-notification-mysql` for a complete list of
MySQL configuration settings.

3) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured MySQL
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:mysql

4) Validate the Changes
~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on a bucket which has an event configuration using the updated
MySQL service endpoint and check the MySQL service for the notification data. The
action required depends on which :mc-cmd:`events <mc event add --event>` were
specified when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc-cmd:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET