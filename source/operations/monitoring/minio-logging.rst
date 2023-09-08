.. _minio-logging:

===================================================
Publish Server or Audit Logs to an External Service
===================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO publishes all :mc:`minio server` operations to the system console. 
Reading these logs depends on how the server process is managed. 
For example, if the server is managed through a ``systemd`` script, 
you can read the logs using ``journalctl -u SERVICENAME.service``. Replace
``SERVICENAME`` with the name of the MinIO service.

MinIO also supports publishing server logs and audit logs to an HTTP webhook.

- :ref:`Server logs <minio-logging-publish-server-logs>` contain the same
  :mc:`minio server` operations logged to the system console. Server logs
  support general monitoring and troubleshooting of operations.

- :ref:`Audit logs <minio-logging-publish-audit-logs>` are more granular
  descriptions of each operation on the MinIO deployment. Audit logging 
  supports security standards and regulations which require detailed tracking
  of operations.

MinIO publishes logs as a JSON document as a ``PUT`` request to each configured
endpoint. The endpoint server is responsible for processing each JSON document.
MinIO requires explicit configuration of each webhook endpoint and does *not*
publish logs to a webhook by default.

.. _minio-logging-publish-server-logs:

Publish Server Logs to HTTP Webhook
-----------------------------------

You can configure a new HTTP webhook endpoint to which MinIO publishes 
:mc:`minio server` logs using either environment variables *or* by setting 
runtime configuration settings. 

.. tab-set::

   .. tab-item:: Environment Variables

      MinIO supports specifying the :mc:`minio server` log HTTP webhook endpoint
      and associated configuration settings using :ref:`environment variables
      <minio-sever-envvar-logging-regular>`.

      The following example code sets *all* environment variables related to
      configuring a log HTTP webhook endpoint. The minimum *required* variables
      are:

      - :envvar:`MINIO_LOGGER_WEBHOOK_ENABLE`
      - :envvar:`MINIO_LOGGER_WEBHOOK_ENDPOINT`

      .. code-block:: shell
         :class: copyable

         set MINIO_LOGGER_WEBHOOK_ENABLE_<IDENTIFIER>="on"
         set MINIO_LOGGER_WEBHOOK_ENDPOINT_<IDENTIFIER>="https://webhook-1.example.net"
         set MINIO_LOGGER_WEBHOOK_AUTH_TOKEN_<IDENTIFIER>="TOKEN"

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the 
        HTTP webhook endpoint. Use the same ``<IDENTIFIER>`` for all environment
        variables related to the new log HTTP webhook.

        If the specified ``<IDENTIFIER>`` matches an existing log endpoint,
        the new settings *override* any existing settings for that endpoint.
        Use :mc-cmd:`mc admin config get logger_webhook <mc admin config get>`
        to review the currently configured log HTTP webhook endpoints.

      - Replace ``https://webhook-1.example.net`` with the URL of the HTTP
        webhook endpoint.

      - Replace ``TOKEN`` with a JSON Web Token (JWT) to use for authenticating
        to the webhook endpoints. Omit for endpoints which do not require
        authentication.

      Restart the MinIO server to apply the new configuration settings. You
      must specify the same environment variables and settings on 
      *all* MinIO servers in the deployment.

   .. tab-item:: Configuration Settings

      MinIO supports adding or updating log HTTP webhook endpoints on a MinIO
      deployment using the :mc-cmd:`mc admin config set` command and the
      :mc-conf:`logger_webhook` configuration key. You must restart the
      MinIO deployment to apply any new or updated configuration settings.

      The following example code sets *all* settings related to configuring
      a log HTTP webhook endpoint. The minimum *required* setting is 
      :mc-conf:`logger_webhook endpoint <logger_webhook.endpoint>`:

      .. code-block:: shell
         :class: copyable

         mc admin config set ALIAS/ logger_webhook:IDENTIFIER \
            endpoint="https://webhook-1.example.net" \
            auth_token="TOKEN" 

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the 
        HTTP webhook endpoint. Use the same ``<IDENTIFIER>`` for all environment
        variables related to the new log HTTP webhook.

        If the specified ``<IDENTIFIER>`` matches an existing log endpoint,
        the new settings *override* any existing settings for that endpoint.
        Use :mc-cmd:`mc admin config get logger_webhook <mc admin config get>`
        to review the currently configured log HTTP webhook endpoints.

      - Replace ``https://webhook-1.example.net`` with the URL of the HTTP
        webhook endpoint.

      - Replace ``TOKEN`` with a JSON Web Token (JWT) to use for authenticating
        to the webhook endpoints. Omit for endpoints which do not require
        authentication.

.. _minio-logging-publish-audit-logs:

Publish Audit Logs to HTTP Webhook
----------------------------------

You can configure a new HTTP webhook endpoint to which MinIO publishes audit
logs using either environment variables *or* by setting runtime configuration
settings:

.. tab-set::

   .. tab-item:: Environment Variables

      MinIO supports specifying the audit log HTTP webhook endpoint and
      associated configuration settings using :ref:`environment variables
      <minio-sever-envvar-logging-audit>`.

      The following example code sets *all* environment variables related to
      configuring a audit log HTTP webhook endpoint. The minimum *required*
      variables are:

      - :envvar:`MINIO_AUDIT_WEBHOOK_ENABLE`
      - :envvar:`MINIO_AUDIT_WEBHOOK_ENDPOINT`

      .. code-block:: shell
         :class: copyable

         set MINIO_AUDIT_WEBHOOK_ENABLE_<IDENTIFIER>="on"
         set MINIO_AUDIT_WEBHOOK_ENDPOINT_<IDENTIFIER>="https://webhook-1.example.net"
         set MINIO_AUDIT_WEBHOOK_AUTH_TOKEN_<IDENTIFIER>="TOKEN"
         set MINIO_AUDIT_WEBHOOK_CLIENT_CERT_<IDENTIFIER>="cert.pem"
         set MINIO_AUDIT_WEBHOOK_CLIENT_KEY_<IDENTIFIER>="cert.key"

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the 
        HTTP webhook endpoint. Use the same ``<IDENTIFIER>`` for all environment
        variables related to the new audit log HTTP webhook.

        If the specified ``<IDENTIFIER>`` matches an existing log endpoint,
        the new settings *override* any existing settings for that endpoint.
        Use :mc-cmd:`mc admin config get audit_webhook <mc admin config get>`
        to review the currently configured audit log HTTP webhook endpoints.

      - Replace ``https://webhook-1.example.net`` with the URL of the HTTP
        webhook endpoint.

      - Replace ``TOKEN`` with an authentication token of the appropriate type for the endpoint. 
        Omit for endpoints which do not require authentication.

        To allow for a variety of token types, MinIO creates the request authentication header using the value *exactly as specified*. 
        Depending on the endpoint, you may need to include additional information.

        For example: for a Bearer token, prepend ``Bearer``:

	.. code-block:: shell

           set MINIO_AUDIT_WEBHOOK_AUTH_TOKEN_myendpoint="Bearer 1a2b3c4f5e"

        Common types include:

        - Bearer
        - Basic Auth
        - JSON Web Token (JWT)
        - Password

        Consult the documenation for the desired service for more details.

      - Replace ``cert.pem`` and ``cert.key`` with the public and private key
        of the x.509 TLS certificates to present to the HTTP webhook server.
        Omit for endpoints which do not require clients to present TLS
        certificates.

      Restart the MinIO server to apply the new configuration settings. You
      must specify the same environment variables and settings on 
      *all* MinIO servers in the deployment.

   .. tab-item:: Configuration Settings

      MinIO supports adding or updating audit log HTTP webhook endpoints on a
      MinIO deployment using the :mc-cmd:`mc admin config set` command and the
      :mc-conf:`audit_webhook` configuration key. You must restart the MinIO
      deployment to apply any new or updated configuration settings.

      The following example code sets *all* settings related to configuring
      a audit log HTTP webhook endpoint. The minimum *required* setting is 
      :mc-conf:`audit_webhook endpoint <audit_webhook.endpoint>`:

      .. code-block:: shell
         :class: copyable

         mc admin config set ALIAS/ audit_webhook:IDENTIFIER \
            endpoint="https://webhook-1.example.net" \
            auth_token="TOKEN" \
            client_cert="cert.pem" \
            client_key="cert.key"

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the 
        HTTP webhook endpoint. Use the same ``<IDENTIFIER>`` for all environment
        variables related to the new audit log HTTP webhook.

        If the specified ``<IDENTIFIER>`` matches an existing log endpoint,
        the new settings *override* any existing settings for that endpoint.
        Use :mc-cmd:`mc admin config get audit_webhook <mc admin config get>`
        to review the currently configured audit log HTTP webhook endpoints.

      - Replace ``https://webhook-1.example.net`` with the URL of the HTTP
        webhook endpoint.

      - Replace ``TOKEN`` with a JSON Web Token (JWT) to use for authenticating
        to the webhook endpoints. Omit for endpoints which do not require
        authentication.

      - Replace ``cert.pem`` and ``cert.key`` with the public and private key
        of the x.509 TLS certificates to present to the HTTP webhook server.
        Omit for endpoints which do not require clients to present TLS
        certificates.

Audit Log Structure
~~~~~~~~~~~~~~~~~~~

MinIO audit logs resemble the following JSON document:

- The ``api.timeToFirstBite`` and ``api.timeToResponse`` fields are expressed
  in nanoseconds.

- For :ref:`erasure coded setups <minio-erasure-coding>` 
  ``tags.objectErasureMap`` provides per-object details on the following:

  - The :ref:`Server Pool <minio-intro-server-pool>` on which the object
    operation was performed.

  - The :ref:`erasure set <minio-ec-erasure-set>` on which the object
    operation was performed.

  - The list of drives in the erasure set which participated in the
    object operation.

.. code-block:: json

   {
      "version": "1",
      "deploymentid": "bc0e4d1e-bacc-42eb-91ad-2d7f3eacfa8d",
      "time": "2019-08-12T21:34:37.187817748Z",
      "api": {
         "name": "PutObject",
         "bucket": "testbucket",
         "object": "hosts",
         "status": "OK",
         "statusCode": 200,
         "timeToFirstByte": "366333ns",
         "timeToResponse": "16438202ns"
      },
      "remotehost": "127.0.0.1",
      "requestID": "15BA4A72C0C70AFC",
      "userAgent": "MinIO (linux; amd64) minio-go/v6.0.32 mc/2019-08-12T18:27:13Z",
      "requestHeader": {
         "Authorization": "AWS4-HMAC-SHA256 Credential=minio/20190812/us-east-1/s3/aws4_request,SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-decoded-content-length,Signature=d3f02a6aeddeb29b06e1773b6a8422112890981269f2463a26f307b60423177c",
         "Content-Length": "686",
         "Content-Type": "application/octet-stream",
         "User-Agent": "MinIO (linux; amd64) minio-go/v6.0.32 mc/2019-08-12T18:27:13Z",
         "X-Amz-Content-Sha256": "STREAMING-AWS4-HMAC-SHA256-PAYLOAD",
         "X-Amz-Date": "20190812T213437Z",
         "X-Amz-Decoded-Content-Length": "512"
      },
      "responseHeader": {
         "Accept-Ranges": "bytes",
         "Content-Length": "0",
         "Content-Security-Policy": "block-all-mixed-content",
         "ETag": "a414c889dc276457bd7175f974332cb0-1",
         "Server": "MinIO/DEVELOPMENT.2019-08-12T21-28-07Z",
         "Vary": "Origin",
         "X-Amz-Request-Id": "15BA4A72C0C70AFC",
         "X-Xss-Protection": "1; mode=block"
      },
      "tags": {
         "objectErasureMap": {
            "object": {
               "poolId": 1,
               "setId": 10,
               "disks": [
                  "http://server01/mnt/pool1/disk01",
                  "http://server02/mnt/pool1/disk02",
                  "http://server03/mnt/pool1/disk03",
                  "http://server04/mnt/pool1/disk04"
               ]
            }
         }
      }
   }
