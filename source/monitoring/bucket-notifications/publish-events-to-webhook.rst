.. _minio-bucket-notifications-publish-webhook:

=========================
Publish Events to Webhook
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports publishing :ref:`bucket notification
<minio-bucket-notifications>` events to a 
`Webhook <https://en.wikipedia.org/wiki/Webhook>`__ service endpoint.

Add a Webhook Endpoint to a MinIO Deployment
--------------------------------------------

The following procedure adds a new Webhook service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

.. include:: /includes/common-admonitions.rst
   :start-after: start-restart-downtime
   :end-before: end-restart-downtime

Prerequisites
~~~~~~~~~~~~~

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.

1) Add the Webhook Endpoint to MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can configure a new Webhook service endpoint using either environment
variables *or* by setting runtime configuration settings.

.. tab-set::

   .. tab-item:: Environment Variables

      MinIO supports specifying the Webhook service endpoint and associated
      configuration settings using 
      :ref:`environment variables 
      <minio-server-envvar-bucket-notification-webhook>`. The 
      :mc:`minio server` process applies the specified settings on its 
      next startup.
      
      The following example code sets *all*  environment variables
      related to configuring an Webhook service endpoint. The minimum
      *required* variables are
      :envvar:`MINIO_NOTIFY_WEBHOOK_ENABLE` and 
      :envvar:`MINIO_NOTIFY_WEBHOOK_ENDPOINT`:


      .. code-block:: shell
         :class: copyable

         set MINIO_NOTIFY_WEBHOOK_ENABLE_<IDENTIFIER>_="on"
         set MINIO_NOTIFY_WEBHOOK_ENDPOINT_<IDENTIFIER>_="ENDPOINT"
         set MINIO_NOTIFY_WEBHOOK_AUTH_TOKEN_<IDENTIFIER>_="<string>"
         set MINIO_NOTIFY_WEBHOOK_QUEUE_DIR_<IDENTIFIER>_="<string>"
         set MINIO_NOTIFY_WEBHOOK_QUEUE_LIMIT_<IDENTIFIER>_="<string>"
         set MINIO_NOTIFY_WEBHOOK_CLIENT_CERT_<IDENTIFIER>_="<string>"
         set MINIO_NOTIFY_WEBHOOK_CLIENT_KEY_<IDENTIFIER>_="<string>"
         set MINIO_NOTIFY_WEBHOOK_COMMENT_<IDENTIFIER>_="<string>"

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the
        Webhook service endpoint. Use the same ``<IDENTIFIER>`` value for all 
        environment variables related to the new target service endpoint.
        The following examples assume an identifier of ``PRIMARY``.

        If the specified ``<IDENTIFIER>`` matches an existing Webhook service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_webhook <mc admin config get>` to
        review the currently configured Webhook endpoints on the MinIO deployment.

      - Replace ``<ENDPOINT>`` with the URL of the Webhook service endpoint.
        For example:

        ``https://webhook.example.com``

      See :ref:`Webhook Service for Bucket Notifications
      <minio-server-envvar-bucket-notification-webhook>` for complete documentation
      on each environment variable.

   .. tab-item:: Configuration Settings

      MinIO supports adding or updating Webhook endpoints on a running 
      :mc:`minio server` process using the :mc-cmd:`mc admin config set` command 
      and the :mc-conf:`notify_webhook` configuration key. You must restart the 
      :mc:`minio server` process to apply any new or updated configuration
      settings.

      The following example code sets *all*  settings related to configuring an
      Webhook service endpoint. The minimum *required* setting is 
      :mc-conf:`notify_webhook endpoint <notify_webhook.endpoint>`:

      .. code-block:: shell
         :class: copyable

         mc admin config set ALIAS/ notify_webhook:IDENTIFIER \
            endpoint="<ENDPOINT>" \
            auth_token="<string>" \
            queue_dir="<string>" \
            queue_limit="<string>" \
            client_cert="<string>" \
            client_key="<string>" \
            comment="<string>"

      - Replace ``IDENTIFIER`` with a unique descriptive string for the
        Webhook service endpoint. The following examples in this procedure
        assume an identifier of ``PRIMARY``.

        If the specified ``IDENTIFIER`` matches an existing Webhook service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_webhook <mc admin config get>` to
        review the currently configured Webhook endpoints on the MinIO deployment.

      - Replace ``ENDPOINT`` with the URL of the Webhook service endpoint.
        For example:

        ``https://webhook.example.com``

      See :ref:`Webhook Bucket Notification Configuration Settings
      <minio-server-config-bucket-notification-webhook>` for complete 
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

The :mc:`minio server` process prints a line on startup for each configured
Webhook target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:webhook

You must specify the ARN resource when configuring bucket notifications with
the associated Webhook deployment as a target.

3) Configure Bucket Notifications using the Webhook Endpoint as a Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc event add` command to add a new bucket notification 
event with the configured Webhook service as a target:

.. code-block:: shell
   :class: copyable

   mc event add ALIAS/BUCKET arn:minio:sqs::primary:webhook \
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

   mc event list ALIAS/BUCKET arn:minio:sqs::primary:webhook

4) Validate the Configured Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on the bucket for which you configured the new event and 
check the Webhook service for the notification data. The action required
depends on which :mc-cmd:`events <mc event add --event>` were specified
when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc-cmd:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET

Update an Webhook Endpoint in a MinIO Deployment
------------------------------------------------

The following procedure updates an existing Webhook service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

.. include:: /includes/common-admonitions.rst
   :start-after: start-restart-downtime
   :end-before: end-restart-downtime

Prerequisites
~~~~~~~~~~~~~~

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.


1) List Configured Webhook Endpoints In The Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config get` command to list the currently
configured Webhook service endpoints in the deployment:

.. code-block:: shell
   :class: copyable

   mc admin config get ALIAS/ notify_webhook

Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO deployment.

The command output resembles the following:

.. code-block:: shell

   notify_webhook:primary endpoint="https://webhook.example.com" auth_token="" queue_limit="0" queue_dir="" client_cert="" client_key=""
   notify_webhook:secondary endpoint="https://webhook.example.com" auth_token="" queue_limit="0" queue_dir="" client_cert="" client_key=""

The :mc-conf:`notify_webhook` key is the top-level configuration key for an
:ref:`minio-server-config-bucket-notification-webhook`. The 
:mc-conf:`endpoint <notify_webhook.endpoint>` key specifies the Webhook service
endpoint for the given `notify_webhook` key. The ``notify_webhook:<IDENTIFIER>``
suffix describes the unique identifier for that Webhook service endpoint.

Note the identifier for the Webhook service endpoint you want to update for
the next step. 

2) Update the Webhook Endpoint
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config set` command to set the new configuration
for the Webhook service endpoint:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS/ notify_webhook:IDENTIFIER \
      endpoint="<ENDPOINT>" \
      auth_token="<string>" \
      queue_dir="<string>" \
      queue_limit="<string>" \
      client_cert="<string>" \
      client_key="<string>" \
      comment="<string>"

The :mc-conf:`notify_webhook endpoint <notify_webhook.endpoint>` configuration
setting is the *minimum* required for an Webhook service endpoint. All other
configuration settings are *optional*. See
:ref:`minio-server-config-bucket-notification-webhook` for a complete list of
Webhook configuration settings.

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

The :mc:`minio server` process prints a line on startup for each configured Webhook
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:webhook

3) Validate the Changes
~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on a bucket which has an event configuration using the updated
Webhook service endpoint and check the Webhook service for the notification
data. The action required depends on which :mc-cmd:`events <mc event add --event>`
were specified when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc-cmd:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET