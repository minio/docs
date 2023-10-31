.. _minio-server-envvar-object-lambda-webhook:

===============================
Object Lambda Function Settings
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents environment variables for configuring MinIO to publish data to an HTTP webhook endpoint and trigger an Object Lambda function.
See :ref:`developers-object-lambda` for more complete documentation and tutorials on using these environment variables.

You can specify multiple webhook endpoints as Lambda targets by appending a unique identifier ``_FUNCTIONNAME`` for each Object Lambda function.
For example, the following command sets two distinct Object Lambda webhook endpoints:

.. code-block:: shell
   :class: copyable

   export MINIO_LAMBDA_WEBHOOK_ENABLE_myfunction="on"
   export MINIO_LAMBDA_WEBHOOK_ENDPOINT_myfunction="http://webhook-1.example.net"
   export MINIO_LAMBDA_WEBHOOK_ENABLE_yourfunction="on"
   export MINIO_LAMBDA_WEBHOOK_ENDPOINT_yourfunction="http://webhook-2.example.net"

Environment Variables
---------------------

.. envvar:: MINIO_LAMBDA_WEBHOOK_ENABLE

   Specify ``"on"`` to enable the Object Lambda webhook endpoint for a handler function.

   Requires specifying :envvar:`MINIO_LAMBDA_WEBHOOK_ENDPOINT`.

.. envvar:: MINIO_LAMBDA_WEBHOOK_ENDPOINT

   The HTTP endpoint of the lambda webhook for the handler function.

.. envvar:: MINIO_LAMBDA_WEBHOOK_AUTH_TOKEN

   Specify the opaque string or JWT authorization token to use for authenticating to the lambda webhook service.

   .. versionchanged:: RELEASE.2023-06-23T20-26-00Z

      MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

.. envvar:: MINIO_LAMBDA_WEBHOOK_CLIENT_CERT

   Specify the path to the client certificate to use for performing mTLS authentication to the lambda webhook service.

.. envvar:: MINIO_LAMBDA_WEBHOOK_CLIENT_KEY

   Specify the path to the private key to use for performing mTLS authentication to the lambda webhook service.
