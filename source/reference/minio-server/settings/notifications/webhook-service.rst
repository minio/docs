.. _minio-server-envvar-bucket-notification-webhook-service:
.. _minio-server-envvar-bucket-notification-webhook:

==========================================
Settings for Webhook Service Notifications
==========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an Webhook service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-webhook` for a tutorial on using these settings.

Environment Variables
---------------------

You can specify multiple Webhook service endpoints by appending a unique identifier ``_ID`` for each set of related Webhook environment variables on to the top level key. 
For example, the following commands set two distinct Webhook service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_WEBHOOK_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_WEBHOOK_ENDPOINT_PRIMARY="https://webhook1.example.net"

   set MINIO_NOTIFY_WEBHOOK_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_WEBHOOK_ENDPOINT_SECONDARY="https://webhook1.example.net"

.. envvar:: MINIO_NOTIFY_WEBHOOK_ENABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-enable
      :end-before: minio-notify-webhook-enable

.. envvar:: MINIO_NOTIFY_WEBHOOK_ENDPOINT

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-endpoint
      :end-before: minio-notify-webhook-endpoint

   This environment variable corresponds with the :mc-conf:`notify_webhook endpoint <notify_webhook.endpoint>` configuration setting.

   .. include:: /includes/linux/minio-server.rst
      :start-after: start-notify-target-online-desc
      :end-before: end-notify-target-online-desc

.. envvar:: MINIO_NOTIFY_WEBHOOK_AUTH_TOKEN

   *Required*

   An authentication token of the appropriate type for the endpoint.
   Omit for endpoints which do not require authentication.

   To allow for a variety of token types, MinIO creates the request authentication header using the value *exactly as specified*.
   Depending on the endpoint, you may need to include additional information.

   For example: for a Bearer token, prepend ``Bearer``:

   .. code-block:: shell
      :class: copyable

      set MINIO_NOTIFY_WEBHOOK_AUTH_TOKEN_myendpoint="Bearer 1a2b3c4f5e"

   Modify the value according to the endpoint requirements.
   A custom authentication format could resemble the following:

   .. code-block:: shell
      :class: copyable

      set MINIO_NOTIFY_WEBHOOK_AUTH_TOKEN_xyz="ServiceXYZ 1a2b3c4f5e"

   Consult the documenation for the desired service for more details.

   This environment variable corresponds with the :mc-conf:`notify_webhook auth_token <notify_webhook.auth_token>` configuration setting.

.. envvar:: MINIO_NOTIFY_WEBHOOK_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-queue-dir
      :end-before: minio-notify-webhook-queue-dir

   This environment variable corresponds with the :mc-conf:`notify_webhook queue_dir <notify_webhook.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_WEBHOOK_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-queue-limit
      :end-before: minio-notify-webhook-queue-limit

   This environment variable corresponds with the :mc-conf:`notify_webhook queue_limit <notify_webhook.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_WEBHOOK_CLIENT_CERT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-client-cert
      :end-before: minio-notify-webhook-client-cert

   This environment variable corresponds with the :mc-conf:`notify_webhook client_cert <notify_webhook.client_cert>` configuration setting.

.. envvar:: MINIO_NOTIFY_WEBHOOK_CLIENT_KEY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-client-key
      :end-before: minio-notify-webhook-client-key

   This environment variable corresponds with the :mc-conf:`notify_webhook client_key <notify_webhook.client_key>` configuration setting.

.. envvar:: MINIO_NOTIFY_WEBHOOK_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: minio-notify-webhook-comment
      :end-before: minio-notify-webhook-comment

   This environment variable corresponds with the :mc-conf:`notify_webhook comment <notify_webhook.comment>` configuration setting.

.. _minio-server-config-bucket-notification-webhook:

Configuration Values
--------------------

The following section documents settings for configuring an Webhook service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-webhook` for a tutorial on using these environment variables.

.. mc-conf:: notify_webhook

   The top-level configuration key for defining an Webhook service endpoint for use
   with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an Webhook service endpoint.
   The :mc-conf:`~notify_webhook.endpoint` argument is *required* for each target.
   Specify additional optional arguments as a whitespace (``" "``)-delimited
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_webhook \ 
        endpoint="https://webhook.example.net"
        [ARGUMENT="VALUE"] ... \

   You can specify multiple Webhook service endpoints by appending ``[:name]`` to
   the top level key. For example, the following commands set two distinct Webhook
   service endpoints as ``primary`` and ``secondary`` respectively:

   .. code-block:: shell

      mc admin config set notify_webhook:primary \ 
         endpoint="https://webhook1.example.net"
         [ARGUMENT=VALUE ...]

      mc admin config set notify_webhook:secondary \
         endpoint="https://webhook2.example.net
         [ARGUMENT=VALUE ...]

   The :mc-conf:`notify_webhook` configuration key supports the following 
   arguments:

   .. mc-conf:: endpoint
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-endpoint
         :end-before: end-minio-notify-webhook-endpoint

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_ENDPOINT` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: auth_token
      :delimiter: " "

      *Optional*

      An authentication token of the appropriate type for the endpoint.
      Omit for endpoints which do not require authentication.

      To allow for a variety of token types, MinIO creates the request authentication header using the value *exactly as specified*.
      Depending on the endpoint, you may need to include additional information.

      For example: for a Bearer token, prepend ``Bearer``:

      .. code-block:: shell
         :class: copyable

            mc admin config set myminio notify_webhook   \
	       endpoint="https://webhook-1.example.net"  \
               auth_token="Bearer 1a2b3c4f5e"

      Modify the value according to the endpoint requirements.
      A custom authentication format could resemble the following:

      .. code-block:: shell
         :class: copyable

            mc admin config set myminio notify_webhook   \
               endpoint="https://webhook-1.example.net"  \
               auth_token="ServiceXYZ 1a2b3c4f5e"

      Consult the documenation for the desired service for more details.

      .. versionchanged:: RELEASE.2023-06-23T20-26-00Z

      MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_AUTH_TOKEN` environment variable.

   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-queue-dir
         :end-before: end-minio-notify-webhook-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_QUEUE_DIR` environment variable.

   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-queue-limit
         :end-before: end-minio-notify-webhook-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_QUEUE_LIMIT` environment variable.

   .. mc-conf:: client_cert
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-client-cert
         :end-before: end-minio-notify-webhook-client-cert

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_CLIENT_CERT` environment variable.

   .. mc-conf:: client_key
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-client-key
         :end-before: end-minio-notify-webhook-client-key

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_CLIENT_KEY` environment variable.

   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-webhook-comment
         :end-before: end-minio-notify-webhook-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_WEBHOOK_COMMENT` environment variable.