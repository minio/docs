.. _minio-external-identity-management-plugin:

=========================================
MinIO External Identity Management Plugin
=========================================

.. default-domain:: minio


.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

The MinIO Identity Management Plugin provides a REST interface for offloading authentication to an external identity manager through a webhook service.

Once enabled, client applications use the ``AssumeRoleWithCustomToken`` STS API extension to generate access tokens for MinIO.
MinIO verifies this token by making a POST request to the configured plugin endpoint and uses the returned response to determine the authentication status of the client.

Configuration Settings
----------------------

You can configure the MinIO Identity Management Plugin using the following environment variables or configuration settings:

.. tab-set::

   .. tab-item:: Environment Variables

      Specify the following :ref:`environment variables <minio-server-envvar-external-identity-management-plugin>` to each MinIO server in the deployment:

      .. code-block:: shell
         :class: copyable

         MINIO_IDENTITY_PLUGIN_URL="https://external-auth.example.net:8080/auth"               
         MINIO_IDENTITY_PLUGIN_ROLE_POLICY="consoleAdmin"
         
         # All other envvars are optional
         MINIO_IDENTITY_PLUGIN_TOKEN="Bearer TOKEN"         
         MINIO_IDENTITY_PLUGIN_ROLE_ID="external-auth-provider"
         MINIO_IDENTITY_PLUGIN_COMMENT="External Identity Management using PROVIDER"

   .. tab-item:: Configuration Settings

      Set the following configuration settings using the :mc-cmd:`mc admin config set` command:

      .. code-block:: shell
         :class: copyable

         mc admin config set identity_plugin \
            url="https://external-auth.example.net:8080/auth" \
            role_policy="consoleAdmin" \
            
            # All other config settings are optional
            token="Bearer TOKEN" \
            role_id="external-auth-provider" \
            comment="External Identity Management using PROVIDER"

Authentication and Authorization Flow
-------------------------------------

The login flow for an application is as follows:

1. Make a POST request using the :ref:`minio-sts-assumerolewithcustomtoken` API.

   The request includes a token used by the configured external identity manager for authenticating the client.

2. MinIO makes a POST call to the configured identity plugin URL using the token specified to the STS API.

3. On successful authentication, the identity manager returns a ``200 OK`` response with an ``application/json`` content-type and body with the following structure:

   .. code-block:: json

      {
         "user": "<string>",
         "maxValiditySeconds": 3600,
         "claims": "KEY=VALUE,[KEY=VALUE,...]"
      }

   .. list-table::
      :stub-columns: 1
      :widths: 30 70
      :width: 100%

      * - ``user``
        - The owner of the requested credentials

      * - ``maxValiditySeconds``
        - The maximum allowed expiry duration for the returned credentials

      * - ``claims``
        - A list of key-value pair claims associated with the requested credentials.
          MinIO reserves and ignores the ``exp``, ``parent``, and ``sub`` claims objects if present.

4. MinIO returns a response to the STS API request that includes temporary credentials for use with making authenticated requests.

If the identity manager rejects the authentication request or otherwise encounters an error, the response *must* return a ``403 FORBIDDEN`` HTTP status code with an ``application/json`` content-type and body with the following structure:

.. code-block:: json

   {
   	"reason": "<string>"
   }

The ``"reason"`` field should include the reason for the 403.

Creating Policies to Match Claims
---------------------------------

Use the :mc:`mc admin policy` command to create policies that match one or more claim values.
