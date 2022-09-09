.. _minio-bucket-notifications-publish-redis:

=======================
Publish Events to Redis
=======================

.. default-domain:: minio

.. |ARN| replace:: ``arn:minio:sqs::primary:redis``

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports publishing :ref:`bucket notification
<minio-bucket-notifications>` events to a `Redis <https://redis.io/>`__ 
service endpoint.

Add a Redis Endpoint to a MinIO Deployment
-------------------------------------------

The following procedure adds a new Redis service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

Prerequisites
~~~~~~~~~~~~~

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.

1) Add the Redis Endpoint to MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can configure a new Redis service endpoint using either environment variables
*or* by setting runtime configuration settings.

.. tab-set::

   .. tab-item:: Environment Variables

      MinIO supports specifying the Redis service endpoint and associated
      configuration settings using 
      :ref:`environment variables 
      <minio-server-envvar-bucket-notification-redis>`. The 
      :mc:`minio server` process applies the specified settings on its 
      next startup.
      
      The following example code sets *all*  environment variables
      related to configuring an Redis service endpoint. The minimum
      *required* variables are:

      - :envvar:`MINIO_NOTIFY_REDIS_ENABLE` 
      - :envvar:`MINIO_NOTIFY_REDIS_ADDRESS`
      - :envvar:`MINIO_NOTIFY_REDIS_KEY` 
      - :envvar:`MINIO_NOTIFY_REDIS_FORMAT`

      .. code-block:: shell
         :class: copyable

         set MINIO_NOTIFY_REDIS_ENABLE_<IDENTIFIER>="on"
         set MINIO_NOTIFY_REDIS_ADDRESS_<IDENTIFIER>="<ENDPOINT>"
         set MINIO_NOTIFY_REDIS_KEY_<IDENTIFIER>="<STRING>"
         set MINIO_NOTIFY_REDIS_FORMAT_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_REDIS_PASSWORD_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_REDIS_QUEUE_DIR_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_REDIS_QUEUE_LIMIT_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_REDIS_COMMENT_<IDENTIFIER>="<string>"

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the
        TARGET service endpoint. Use the same ``<IDENTIFIER>`` value for all 
        environment variables related to the new target service endpoint.
        The following examples assume an identifier of ``PRIMARY``.

        If the specified ``<IDENTIFIER>`` matches an existing Redis service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_redis <mc admin config get>` to
        review the currently configured Redis endpoints on the MinIO deployment.

      - Replace ``<ENDPOINT>`` with the URL of the Redis service endpoint.
        For example: ``https://redis.example.com:6369``


      See :ref:`Redis Service for Bucket Notifications
      <minio-server-envvar-bucket-notification-redis>` for complete documentation
      on each environment variable.

   .. tab-item:: Configuration Settings

      MinIO supports adding or updating Redis endpoints on a running 
      :mc:`minio server` process using the :mc-cmd:`mc admin config set` command 
      and the :mc-conf:`notify_redis` configuration key. You must restart the 
      :mc:`minio server` process to apply any new or updated configuration
      settings.

      The following example code sets *all*  settings related to configuring an
      Redis service endpoint. The minimum *required* settings are:

      - :mc-conf:`notify_redis address <notify_redis.address>`
      - :mc-conf:`notify_redis key <notify_redis.key>`
      - :mc-conf:`notify_redis format <notify_redis.format>`

      .. code-block:: shell
         :class: copyable

         mc admin config set ALIAS/ notify_redis:IDENTIFIER \
           address="ENDPOINT" \
           key="<string>" \
           format="<string>" \
           password="<string>" \
           queue_dir="<string>" \
           queue_limit="<string>" \
           comment="<string>"

      - Replace ``IDENTIFIER`` with a unique descriptive string for the
        Redis service endpoint. The following examples in this procedure
        assume an identifier of ``PRIMARY``.

        If the specified ``IDENTIFIER`` matches an existing Redis service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_redis <mc admin config get>` to
        review the currently configured Redis endpoints on the MinIO deployment.

      - Replace ``ENDPOINT`` with the URL of the Redis service endpoint.
        For example: ``https://redis.example.com:6369``

      See :ref:`Redis Bucket Notification Configuration Settings
      <minio-server-config-bucket-notification-redis>` for complete 
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

The :mc:`minio server` process prints a line on startup for each configured Redis
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:redis

You must specify the ARN resource when configuring bucket notifications with
the associated Redis deployment as a target.

.. include:: /includes/common-bucket-notifications.rst
   :start-after: start-bucket-notification-find-arn
   :end-before: end-bucket-notification-find-arn

3) Configure Bucket Notifications using the Redis Endpoint as a Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc event add` command to add a new bucket notification 
event with the configured Redis service as a target:

.. code-block:: shell
   :class: copyable

   mc event add ALIAS/BUCKET arn:minio:sqs::primary:redis \
     --event EVENTS

- Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment.
- Replace ``BUCKET`` with the name of the bucket in which to configure the 
  event.
- Replace ``EVENTS`` with a comma-separated list of :ref:`events 
  <mc-event-supported-events>` for which MinIO triggers notifications.

Use :mc:`mc event list` to view all configured bucket events for 
a given notification target:

.. code-block:: shell
   :class: copyable

   mc event list ALIAS/BUCKET arn:minio:sqs::primary:redis

4) Validate the Configured Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on the bucket for which you configured the new event and 
check the Redis service for the notification data. The action required
depends on which :mc-cmd:`events <mc event add --event>` were specified
when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET

Update an Redis Endpoint in a MinIO Deployment
----------------------------------------------

The following procedure updates an existing Redis service endpoint for
supporting :ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

Prerequisites
~~~~~~~~~~~~~~

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.


1) List Configured Redis Endpoints In The Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config get` command to list the currently
configured Redis service endpoints in the deployment:

.. code-block:: shell
   :class: copyable

   mc admin config get ALIAS/ notify_redis

Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO deployment.

The command output resembles the following:

.. code-block:: shell

   notify_redis:primary address="https://redis.example.com:6369" format="namespace" key="minioevent" password="" queue_dir="" queue_limit="0"
   notify_redis:secondary address="https://redis.example.com:6369" format="namespace" key="minioevent" password="" queue_dir="" queue_limit="0"

The :mc-conf:`notify_redis` key is the top-level configuration key for an
:ref:`minio-server-config-bucket-notification-redis`. The 
:mc-conf:`address <notify_redis.address>` key specifies the Redis service endpoint 
for the given `notify_redis` key. The ``notify_redis:<IDENTIFIER>`` suffix 
describes the unique identifier for that Redis service endpoint.

Note the identifier for the Redis service endpoint you want to update for
the next step. 

2) Update the Redis Endpoint
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config set` command to set the new configuration
for the Redis service endpoint:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS/ notify_redis:IDENTIFIER \
      address="ENDPOINT" \
      key="<string>" \
      format="<string>" \
      password="<string>" \
      queue_dir="<string>" \
      queue_limit="<string>" \
      comment="<string>"

The :mc-conf:`notify_redis address <notify_redis.address>` configuration setting
is the *minimum* required for an Redis service endpoint. All other configuration
settings are *optional*. See
:ref:`minio-server-config-bucket-notification-redis` for a complete list of
Redis configuration settings.

3) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured Redis
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:redis

4) Validate the Changes
~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on a bucket which has an event configuration using the updated
Redis service endpoint and check the Redis service for the notification data. The
action required depends on which :mc-cmd:`events <mc event add --event>` were
specified when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET