.. _minio-server-envvar-bucket-notification-webhook-service:
.. _minio-server-envvar-bucket-notification-webhook:
.. _minio-server-config-bucket-notification-webhook:

=====================================
Webhook Service Notification Settings
=====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring an Webhook service as a target for :ref:`Bucket Notifications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-webhook` for a tutorial on using these settings.

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-test-before-prod
   :end-before: end-minio-settings-test-before-prod

Multiple Webhook Service Targets
--------------------------------

You can specify multiple Webhook service endpoints by appending a unique identifier ``_ID`` for each set of related Webhook settings on to the top level key. 
For example, the following commands set two distinct Webhook service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell
         :class: copyable
      
         set MINIO_NOTIFY_WEBHOOK_ENABLE_PRIMARY="on"
         set MINIO_NOTIFY_WEBHOOK_ENDPOINT_PRIMARY="https://webhook1.example.net"
      
         set MINIO_NOTIFY_WEBHOOK_ENABLE_SECONDARY="on"
         set MINIO_NOTIFY_WEBHOOK_ENDPOINT_SECONDARY="https://webhook1.example.net"

   .. tab-item:: Configuration Settings
      :sync: config

      .. code-block:: shell
   
         mc admin config set notify_webhook:primary \ 
            endpoint="https://webhook1.example.net"
            [ARGUMENT=VALUE ...]
   
         mc admin config set notify_webhook:secondary \
            endpoint="https://webhook2.example.net
            [ARGUMENT=VALUE ...]

Settings
--------

Enable
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_WEBHOOK_ENABLE

      Specify ``on`` to enable publishing bucket notifications to a Webhook service endpoint.

      Defaults to ``off``.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_webhook

      The top-level configuration key for defining an Webhook service endpoint for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.
   
      Use :mc-cmd:`mc admin config set` to set or update an Webhook service endpoint.
      The :mc-conf:`~notify_webhook.endpoint` argument is *required* for each target.
      Specify additional optional arguments as a whitespace (``" "``)-delimited list.
   
      .. code-block:: shell
         :class: copyable
   
         mc admin config set notify_webhook \ 
           endpoint="https://webhook.example.net"
           [ARGUMENT="VALUE"] ... \

Endpoint
~~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_WEBHOOK_ENDPOINT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_webhook endpoint
         :delimiter: " "

Specify the URL for the webhook service.

.. include:: /includes/linux/minio-server.rst
   :start-after: start-notify-target-online-desc
   :end-before: end-notify-target-online-desc

Auth Token
~~~~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_WEBHOOK_AUTH_TOKEN

      An authentication token of the appropriate type for the endpoint.
      Omit for endpoints which do not require authentication.
   
      To allow for a variety of token types, MinIO creates the request authentication header using the value *exactly as specified*.
      Depending on the endpoint, you may need to include additional information.
   
      For example, for a Bearer token, prepend ``Bearer``:
   
      .. code-block:: shell
         :class: copyable
   
         set MINIO_NOTIFY_WEBHOOK_AUTH_TOKEN_myendpoint="Bearer 1a2b3c4f5e"
   
      Modify the value according to the endpoint requirements.
      A custom authentication format could resemble the following:
   
      .. code-block:: shell
         :class: copyable
   
         set MINIO_NOTIFY_WEBHOOK_AUTH_TOKEN_xyz="ServiceXYZ 1a2b3c4f5e"
   
      Consult the documentation for the desired service for more details.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_webhook auth_token
         :delimiter: " "
   
         An authentication token of the appropriate type for the endpoint.
         Omit for endpoints which do not require authentication.
   
         To allow for a variety of token types, MinIO creates the request authentication header using the value *exactly as specified*.
         Depending on the endpoint, you may need to include additional information.
   
         For example, for a Bearer token, prepend ``Bearer``:
   
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
   
         Consult the documentation for the desired service for more details.
   
         .. versionchanged:: RELEASE.2023-06-23T20-26-00Z
   
         MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

Queue Directory
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_WEBHOOK_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_webhook queue_dir
         :delimiter: " "

Specify the directory path to enable MinIO's persistent event store for undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the webhook service is offline and replays the stored events when connectivity resumes.

Queue Limit
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_WEBHOOK_QUEUE_LIMIT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_webhook queue_limit
         :delimiter: " "

Specify the maximum limit for undelivered messages. 
Defaults to ``100000``.

Client Certificate
~~~~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_WEBHOOK_CLIENT_CERT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_webhook client_cert
         :delimiter: " "

Specify the path to the client certificate to use for performing mTLS authentication to the webhook service.

Client Key
~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_WEBHOOK_CLIENT_KEY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_webhook client_key
         :delimiter: " "

Specify the path to the client private key to use for performing mTLS authentication to the webhook service.

Comment
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_WEBHOOK_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_webhook comment
         :delimiter: " "

Specify a comment to associate with the Webhook configuration.