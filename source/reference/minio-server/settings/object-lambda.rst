.. _minio-server-envvar-object-lambda-webhook:

===============================
Object Lambda function settings
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page describes the settings available to configure MinIO to publish data to an HTTP webhook endpoint and trigger an Object Lambda function.
See :ref:`developers-object-lambda` for more complete documentation and tutorials on using these settings.

You can establish or modify settings by defining:

- an *environment variable* on the host system prior to starting or restarting the MinIO Server.
  Refer to your operating system's documentation for how to define an environment variable.
- a *configuration setting* using :mc:`mc admin config set`.

If you define both an environment variable and the similar configuration setting, MinIO uses the environment variable value.

Some settings have only an environment variable or a configuration setting, but not both.

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-test-before-prod
   :end-before: end-minio-settings-test-before-prod


Enable
------

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_LAMBDA_WEBHOOK_ENABLE

         Specify ``"on"`` to enable the Object Lambda webhook endpoint for a handler function.

         Requires specifying :envvar:`MINIO_LAMBDA_WEBHOOK_ENDPOINT`.

	 You can specify multiple webhooks as Lambda targets by appending a unique identifier for each Object Lambda function.
         For example, the following command enables two distinct Object Lambda webhook endpoints:

         .. code-block:: shell
            :class: copyable

            export MINIO_LAMBDA_WEBHOOK_ENABLE_myfunction="on"
            export MINIO_LAMBDA_WEBHOOK_ENABLE_yourfunction="on"

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: lambda_webhook enable
         :delimiter: " "

         *Optional*

         Specify ``"on"`` to enable the Object Lambda webhook endpoint for a handler function.
	 Requires specifying :mc-conf:`~lambda_webhook.endpoint`.

	 Example:

	 .. code-block:: shell
	    :class: copyable

            mc admin config set myminio lambda_webhook:myfunction endpoint="https://example.com/" enable=on

Endpoint
--------

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_LAMBDA_WEBHOOK_ENDPOINT

         The HTTP endpoint of the lambda webhook for the handler function.

         You can specify multiple webhook endpoints as Lambda targets by appending a unique identifier for each Object Lambda function.
         For example, the following command sets two distinct Object Lambda webhook endpoints:

         .. code-block:: shell
            :class: copyable

            export MINIO_LAMBDA_WEBHOOK_ENDPOINT_myfunction="http://webhook-1.example.com"
            export MINIO_LAMBDA_WEBHOOK_ENDPOINT_yourfunction="http://webhook-2.example.com"

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: lambda_webhook endpoint
         :delimiter: " "

         *Optional*

         The HTTP endpoint of the lambda webhook for the handler function.

Auth token
----------

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_LAMBDA_WEBHOOK_AUTH_TOKEN

         Specify the opaque string or JWT authorization token to use for authenticating to the lambda webhook service.

         You can specify the token for multiple Lambda targets by appending a unique identifier for each Object Lambda function.
         For example, the following command configures a token for two distinct Object Lambda webhook endpoints:

         .. code-block:: shell
            :class: copyable

            export MINIO_LAMBDA_WEBHOOK_AUTH_TOKEN_myfunction="1a2b3c4d5e"
            export MINIO_LAMBDA_WEBHOOK_AUTH_TOKEN_yourfunction="1a2b3c4d5e"

         .. versionchanged:: RELEASE.2023-06-23T20-26-00Z

            MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: lambda_webhook auth_token
         :delimiter: " "

         *Optional*

         Specify the opaque string or JWT authorization token to use for authenticating to the lambda webhook service.

         .. versionchanged:: RELEASE.2023-06-23T20-26-00Z

            MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.         

Client cert
-----------

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_LAMBDA_WEBHOOK_CLIENT_CERT

         Specify the path to the client certificate to use for performing mTLS authentication to the lambda webhook service.

         You can specify the client cert for multiple Lambda targets by appending a unique identifier for each Object Lambda function.
         For example, the following command configures a cert for two distinct Object Lambda webhook endpoints:

         .. code-block:: shell
            :class: copyable

            export MINIO_LAMBDA_WEBHOOK_CLIENT_CERT_myfunction="/path/to/cert1"
            export MINIO_LAMBDA_WEBHOOK_CLIENT_CERT_yourfunction="/path/to/cert2"

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: lambda_webhook client_cert
         :delimiter: " "

         *Optional*
     
         Specify the path to the client certificate to use for performing mTLS authentication to the lambda webhook service.

Client key
----------

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_LAMBDA_WEBHOOK_CLIENT_KEY

         Specify the path to the private key to use for performing mTLS authentication to the lambda webhook service.

         You can specify the client key for multiple Lambda targets by appending a unique identifier for each Object Lambda function.
         For example, the following command configures a key for two distinct Object Lambda webhook endpoints:

         .. code-block:: shell
            :class: copyable

            export MINIO_LAMBDA_WEBHOOK_CLIENT_KEY_myfunction="/path/to/key1"
            export MINIO_LAMBDA_WEBHOOK_CLIENT_KEY_yourfunction="/path/to/key2"

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: lambda_webhook client_key
         :delimiter: " "

         *Optional*

         Specify the path to the private key to use for performing mTLS authentication to the lambda webhook service.
