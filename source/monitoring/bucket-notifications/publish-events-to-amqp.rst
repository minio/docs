.. _minio-bucket-notifications-publish-amqp:

=================================
Publish Events to AMQP (RabbitMQ)
=================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports publishing :ref:`bucket notification
<minio-bucket-notifications>` events to a `AMQP 0-9-1 <https://www.amqp.org/>`__ 
service endpoint such as `RabbitMQ <https://www.rabbitmq.com>`__. 

MinIO relies on the :github:`streadway/amqp` project for AMQP connectivity. The
project is primarily tested against `RabbitMQ <https://www.rabbitmq.com/>`__
deployments, though other `AMQP 0-9-1-compatible <https://www.amqp.org/>`__
services *may* also work. The procedures on this page assume a RabbitMQ
deployment using the AMQP 0-9-1 protocol as the service endpoint.

Add an AMQP Endpoint to a MinIO Deployment
------------------------------------------

The following procedure adds a new AMQP service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

.. include:: /includes/common-admonitions.rst
   :start-after: start-restart-downtime
   :end-before: end-restart-downtime

Prerequisites
~~~~~~~~~~~~~~

AMQP 0-9-1 Service Endpoint
+++++++++++++++++++++++++++

MinIO relies on the :github:`streadway/amqp` project for AMQP connectivity. The
project is primarily tested against `RabbitMQ <https://www.rabbitmq.com/>`__
deployments, though other `AMQP 0-9-1-compatible <https://www.amqp.org/>`__
services *may* also work. This procedure assumes a RabbitMQ deployment 
using the 0-9-1 protocol as the service endpoint.

If the AMQP service requires authentication, you *must* provide an appropriate
username and password during the configuration process to grant MinIO access
to the service.

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.

1) Add the AMQP Endpoint to MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can configure a new AMQP service endpoint using either environment variables
*or* by setting runtime configuration settings.

.. tabs::

   .. tab:: Environment Variables

      MinIO supports specifying the AMQP service endpoint and associated
      configuration settings using 
      :ref:`environment variables 
      <minio-server-envvar-bucket-notification-amqp>`. The 
      :mc:`minio server` process applies the specified settings on its 
      next startup.
      
      The following example code sets *all*  environment variables
      related to configuring an AMQP service endpoint. The minimum
      *required* variables are
      :envvar:`MINIO_NOTIFY_AMQP_ENABLE` and :envvar:`MINIO_NOTIFY_AMQP_URL`:

      .. code-block:: shell
         :class: copyable

         set MINIO_NOTIFY_AMQP_ENABLE_<IDENTIFIER>="on"
         set MINIO_NOTIFY_AMQP_URL_<IDENTIFIER>="<ENDPOINT>"
         set MINIO_NOTIFY_AMQP_EXCHANGE_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_AMQP_EXCHANGE_TYPE_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_AMQP_ROUTING_KEY_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_AMQP_MANDATORY_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_AMQP_DURABLE_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_AMQP_NO_WAIT_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_AMQP_INTERNAL_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_AMQP_AUTO_DELETED_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_AMQP_DELIVERY_MODE_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_AMQP_QUEUE_DIR_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_AMQP_QUEUE_LIMIT_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_AMQP_COMMENT_<IDENTIFIER>="<string>"

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the
        AMQP service endpoint. Use the same ``<IDENTIFIER>`` value for all 
        environment variables related to the new AMQP service endpoint.
        The following examples assume an identifier of ``PRIMARY``.

        If the specified ``<IDENTIFIER>`` matches an existing AMQP service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_amqp <mc admin config get>` to
        review the currently configured AMQP endpoints on the MinIO deployment.

      - Replace ``<ENDPOINT>`` with the URL of the AMQP service endpoint.
        For example:

        ``amqp://user:password@hostname:port``

      See :ref:`AMQP Service for Bucket Notifications
      <minio-server-envvar-bucket-notification-amqp>` for complete documentation
      on each environment variable.

   .. tab:: Configuration Settings

      MinIO supports adding or updating AMQP endpoints on a running 
      :mc:`minio server` process using the :mc-cmd:`mc admin config set` command 
      and the :mc-conf:`notify_amqp` configuration key. You must restart the 
      :mc:`minio server` process to apply any new or updated configuration
      settings.

      The following example code sets *all*  settings related to configuring an
      AMQP service endpoint. The minimum *required* setting is 
      :mc-conf:`notify_amqp url <notify_amqp.url>`:

      .. code-block:: shell
         :class: copyable

         mc admin config set ALIAS/ notify_amqp:IDENTIFIER \
           url="ENDPOINT" \
           exchange="<string>" \
           exchange_type="<string>" \
           routing_key="<string>" \
           mandatory="<string>" \
           durable="<string>" \
           no_wait="<string>" \
           internal="<string>" \
           auto_deleted="<string>" \
           delivery_mode="<string>" \
           queue_dir="<string>" \
           queue_limit="<string>" \
           comment="<string>"

      - Replace ``IDENTIFIER`` with a unique descriptive string for the
        AMQP service endpoint. The following examples in this procedure
        assume an identifier of ``PRIMARY``.

        If the specified ``IDENTIFIER`` matches an existing AMQP service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_amqp <mc admin config get>` to
        review the currently configured AMQP endpoints on the MinIO deployment.

      - Replace ``ENDPOINT`` with the URL of the AMQP service endpoint.
        For example:

        ``amqp://user:password@hostname:port``

      See :ref:`AMQP Bucket Notification Configuration Settings
      <minio-server-config-bucket-notification-amqp>` for complete 
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

Replace ``ALIAS`` with the :mc:`alias <mc-alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured AMQP
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:amqp

You must specify the ARN resource when configuring bucket notifications with
the associated AMQP deployment as a target.

3) Configure Bucket Notifications using the AMQP Endpoint as a Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc event add` command to add a new bucket notification 
event with the configured AMQP service as a target:

.. code-block:: shell
   :class: copyable

   mc event add ALIAS/BUCKET arn:minio:sqs::primary:amqp \
     --event EVENTS

- Replace ``ALIAS`` with the :mc:`alias <mc-alias>` of a MinIO deployment.
- Replace ``BUCKET`` with the name of the bucket in which to configure the 
  event.
- Replace ``EVENTS`` with a comma-separated list of :ref:`events 
  <mc-event-supported-events>` for which MinIO triggers notifications.

Use :mc-cmd:`mc event list` to view all configured bucket events for 
a given notification target:

.. code-block:: shell
   :class: copyable

   mc event list ALIAS/BUCKET arn:minio:sqs::primary:amqp

4) Validate the Configured Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on the bucket for which you configured the new event and 
check the AMQP service for the notification data. The action required
depends on which :mc-cmd:`events <mc-event-add-event>` were specified
when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc-cmd:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET



Update an AMQP Endpoint in a MinIO Deployment
---------------------------------------------

The following procedure updates an existing AMQP service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

.. include:: /includes/common-admonitions.rst
   :start-after: start-restart-downtime
   :end-before: end-restart-downtime

Prerequisites
~~~~~~~~~~~~~~

AMQP 0-9-1 Service Endpoint
+++++++++++++++++++++++++++

MinIO relies on the :github:`streadway/amqp` project for AMQP connectivity. The
project is primarily tested against `RabbitMQ <https://www.rabbitmq.com/>`__
deployments, though other `AMQP 0-9-1-compatible <https://www.amqp.org/>`__
services *may* also work. This procedure *assumes* a RabbitMQ deployment 
as the service endpoint.

If the AMQP service requires authentication, you *must* provide an appropriate
username and password during the configuration process to grant MinIO access
to the service.

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.


1) List Configured AMQP Endpoints In The Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config get` command to list the currently
configured AMQP service endpoints in the deployment:

.. code-block:: shell
   :class: copyable

   mc admin config get ALIAS/ notify_amqp

Replace ``ALIAS`` with the :mc:`alias <mc-alias>` of the MinIO deployment.

The command output resembles the following:

.. code-block:: shell

   notify_amqp:primary delivery_mode="0" exchange_type="" no_wait="off" queue_dir="" queue_limit="0"  url="amqp://user:password@hostname:port" auto_deleted="off" durable="off" exchange="" internal="off" mandatory="off" routing_key=""
   notify_amqp:secondary delivery_mode="0" exchange_type="" no_wait="off" queue_dir="" queue_limit="0"  url="amqp://user:password@hostname:port" auto_deleted="off" durable="off" exchange="" internal="off" mandatory="off" routing_key=""

The :mc-conf:`notify_amqp` key is the top-level configuration key for an
:ref:`minio-server-config-bucket-notification-amqp`. The 
:mc-conf:`url <notify_amqp.url>` key specifies the AMQP service endpoint 
for the given `notify_amqp` key. The ``notify_amqp:<IDENTIFIER>`` suffix 
describes the unique identifier for that AMQP service endpoint.

Note the identifier for the AMQP service endpoint you want to update for
the next step. 

2) Update the AMQP Endpoint
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config set` command to set the new configuration
for the AMQP service endpoint:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS/ notify_amqp:<IDENTIFIER> \
      url="amqp://user:password@hostname:port" \
      exchange="<string>" \
      exchange_type="<string>" \
      routing_key="<string>" \
      mandatory="<string>" \
      durable="<string>" \
      no_wait="<string>" \
      internal="<string>" \
      auto_deleted="<string>" \
      delivery_mode="<string>" \
      queue_dir="<string>" \
      queue_limit="<string>" \
      comment="<string>"

The :mc-conf:`notify_amqp url <notify_amqp.url>` configuration setting is the
*minimum* required for an AMQP service endpoint. All other configuration
settings are *optional*. See :ref:`minio-server-config-bucket-notification-amqp`
for a complete list of AMQP configuration settings.

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

Replace ``ALIAS`` with the :mc:`alias <mc-alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured AMQP
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:amqp

3) Validate the Changes
~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on a bucket which has an event configuration using the updated
AMQP service endpoint and check the AMQP service for the notification data. The
action required depends on which :mc-cmd:`events <mc-event-add-event>` were
specified when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc-cmd:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET
