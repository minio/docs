.. _minio-bucket-notifications-publish-postgresql:

============================
Publish Events to PostgreSQL
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. |postgresql-uri-reference| replace:: `PostgreSQL Connection String <https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING>`__

MinIO supports publishing :ref:`bucket notification
<minio-bucket-notifications>` events to 
`PostgreSQL <https://www.postgresql.org/>`__. MinIO supports
PostgreSQL 9.5 and later *only*.

Add a PostgreSQL Endpoint to a MinIO Deployment
-----------------------------------------------

The following procedure adds a new PostgreSQL service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

.. include:: /includes/common-admonitions.rst
   :start-after: start-restart-downtime
   :end-before: end-restart-downtime

Prerequisites
~~~~~~~~~~~~~

PostgreSQL 9.5 and later
++++++++++++++++++++++++

MinIO relies on features introduced with PostgreSQL 9.5.

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.

1) Add the PostgreSQL Endpoint to MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can configure a new PostgreSQL service endpoint using either environment
variables *or* by setting runtime configuration settings.

.. tab-set::

   .. tab-item:: Environment Variables

      MinIO supports specifying the PostgreSQL service endpoint and associated
      configuration settings using 
      :ref:`environment variables 
      <minio-server-envvar-bucket-notification-postgresql>`. The 
      :mc:`minio server` process applies the specified settings on its 
      next startup.
      
      The following example code sets *all*  environment variables
      related to configuring a PostgreSQL service endpoint. The minimum
      *required* variables are:
      
      - :envvar:`MINIO_NOTIFY_POSTGRESQL_CONNECTION_STRING` 
      - :envvar:`MINIO_NOTIFY_POSTGRESQL_TABLE`
      - :envvar:`MINIO_NOTIFY_POSTGRESQL_FORMAT`

      .. code-block:: shell
         :class: copyable

         set MINIO_NOTIFY_CONNECTION_STRING_<IDENTIFIER>="on"
         set MINIO_NOTIFY_TABLE_<IDENTIFIER>="ENDPOINT"
         set MINIO_NOTIFY_FORMAT_<IDENTIFIER>=""
         set MINIO_NOTIFY_MAX_OPEN_CONNECTIONS_<IDENTIFIER>=""
         set MINIO_NOTIFY_QUEUE_DIR_<IDENTIFIER>=""
         set MINIO_NOTIFY_QUEUE_LIMIT_<IDENTIFIER>=""
         set MINIO_NOTIFY_COMMENT_<IDENTIFIER>=""


      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the
        PostgreSQL service endpoint. Use the same ``<IDENTIFIER>`` value for all 
        environment variables related to the new target service endpoint.
        The following examples assume an identifier of ``PRIMARY``.

        If the specified ``<IDENTIFIER>`` matches an existing PostgreSQL service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_postgresql <mc admin config get>` to
        review the currently configured PostgreSQL endpoints on the MinIO deployment.

      - Replace ``<ENDPOINT>`` with the |postgresql-uri-reference|
        for PostgreSQL service endpoint. MinIO supports ``key=value`` format for 
        the connection string. For example:

        ``"host=https://postgresql.example.com port=5432 ..."``

        For more complete documentation on supported PostgreSQL connection
        string parameters, see |postgresql-uri-reference|.

      See :ref:`PostgreSQL Service for Bucket Notifications
      <minio-server-envvar-bucket-notification-postgresql>` for complete
      documentation on each environment variable.

   .. tab-item:: Configuration Settings

      MinIO supports adding or updating PostgreSQL endpoints on a running 
      :mc:`minio server` process using the :mc-cmd:`mc admin config set` command 
      and the :mc-conf:`notify_postgresql` configuration key. You must restart the 
      :mc:`minio server` process to apply any new or updated configuration
      settings.

      The following example code sets *all*  settings related to configuring an
      PostgreSQL service endpoint. The minimum *required* setting are: 
      
      - :mc-conf:`notify_postgresql connection_string 
        <notify_postgresql.connection_string>`
      - :mc-conf:`notify_postgresql table <notify_postgresql.table>`
      - :mc-conf:`notify_postgresql format <notify_postgresql.format>`

      .. code-block:: shell
         :class: copyable

         mc admin config set ALIAS/ notify_postgresql:IDENTIFIER \
            connection_string="ENDPOINT" \
            table="<string>" \
            format="<string>" \
            max_open_connections="<string>" \
            queue_dir="<string>" \
            queue_limit="<string>" \
            comment="<string>"

      - Replace ``IDENTIFIER`` with a unique descriptive string for the
        PostgreSQL service endpoint. The following examples in this procedure
        assume an identifier of ``PRIMARY``.

        If the specified ``IDENTIFIER`` matches an existing PostgreSQL service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_postgresql <mc admin config get>` to
        review the currently configured PostgreSQL endpoints on the MinIO deployment.

      - Replace ``<ENDPOINT>`` with the `PostgreSQL URI connection string 
        <https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING>`__ 
        of the PostgreSQL service endpoint. MinIO supports ``key=value`` format
        for the PostgreSQL connection string. For example:

        ``"host=https://postgresql.example.com port=5432 ..."``

        For more complete documentation on supported PostgreSQL connection
        string parameters, see |postgresql-uri-reference|.

      See :ref:`PostgreSQL Bucket Notification Configuration Settings
      <minio-server-config-bucket-notification-postgresql>` for complete 
      documentation on each setting.

2) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. important::

   MinIO restarts *all* :mc:`minio server` processes associated to the 
   deployment at the same time. Applications may experience a brief period of 
   downtime during the restart process. 

   Consider scheduling the restart during a maintenance period to minimize
   interruption of services.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured PostgreSQL
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:postgresql

You must specify the ARN resource when configuring bucket notifications with
the associated PostgreSQL deployment as a target.

3) Configure Bucket Notifications using the PostgreSQL Endpoint as a Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc event add` command to add a new bucket notification 
event with the configured PostgreSQL service as a target:

.. code-block:: shell
   :class: copyable

   mc event add ALIAS/BUCKET arn:minio:sqs::primary:postgresql \
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

   mc event list ALIAS/BUCKET arn:minio:sqs::primary:postgresql

4) Validate the Configured Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on the bucket for which you configured the new event and 
check the PostgreSQL service for the notification data. The action required
depends on which :mc-cmd:`events <mc event add --event>` were specified
when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc-cmd:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET

Update a PostgreSQL Endpoint in a MinIO Deployment
---------------------------------------------------

The following procedure updates an existing PostgreSQL service endpoint for
supporting :ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

.. include:: /includes/common-admonitions.rst
   :start-after: start-restart-downtime
   :end-before: end-restart-downtime

Prerequisites
~~~~~~~~~~~~~

PostgreSQL 9.5 and later
++++++++++++++++++++++++

MinIO relies on features introduced with PostgreSQL 9.5.

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.


1) List Configured PostgreSQL Endpoints In The Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config get` command to list the currently
configured PostgreSQL service endpoints in the deployment:

.. code-block:: shell
   :class: copyable

   mc admin config get ALIAS/ notify_postgresql

Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO deployment.

The command output resembles the following:

.. code-block:: shell

   notify_postgresql:primary queue_dir="" connection_string="postgresql://" queue_limit="0"  table="" format="namespace"
   notify_postgresql:secondary queue_dir="" connection_string="" queue_limit="0"  table="" format="namespace"

The :mc-conf:`notify_postgresql` key is the top-level configuration key for an
:ref:`minio-server-config-bucket-notification-postgresql`. The
:mc-conf:`connection_string <notify_postgresql.connection_string>` key specifies
the PostgreSQL service endpoint for the given `notify_postgresql` key. The
``notify_postgresql:<IDENTIFIER>`` suffix describes the unique identifier for
that PostgreSQL service endpoint.

Note the identifier for the PostgreSQL service endpoint you want to update for
the next step. 

2) Update the PostgreSQL Endpoint
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config set` command to set the new configuration
for the PostgreSQL service endpoint:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS/ notify_postgresql:IDENTIFIER \
      connection_string="ENDPOINT" \
      table="<string>" \
      format="<string>" \
      max_open_connections="<string>" \
      queue_dir="<string>" \
      queue_limit="<string>" \
      comment="<string>"

The following configuration settings are the *minimum* required for a 
PostgreSQL service endpoint:

- :mc-conf:`notify_postgresql connection_string 
  <notify_postgresql.connection_string>`
- :mc-conf:`notify_postgresql table <notify_postgresql.table>`
- :mc-conf:`notify_postgresql format <notify_postgresql.format>`

All other configuration settings are *optional*. See
:ref:`minio-server-config-bucket-notification-postgresql` for a complete list of
PostgreSQL configuration settings.

3) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. important::

   MinIO restarts *all* :mc:`minio server` processes associated to the 
   deployment at the same time. Applications may experience a brief period of 
   downtime during the restart process. 

   Consider scheduling the restart during a maintenance period to minimize
   interruption of services.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured PostgreSQL
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:postgresql

3) Validate the Changes
~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on a bucket which has an event configuration using the updated
PostgreSQL service endpoint and check the PostgreSQL service for the notification data. The
action required depends on which :mc-cmd:`events <mc event add --event>` were
specified when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc-cmd:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET