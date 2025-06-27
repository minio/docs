1. Set the OpenID Configuration Settings

   You can configure the :abbr:`OIDC (OpenID Connect)` provider using either
   environment variables *or* server runtime configuration settings. Both
   methods require starting/restarting the MinIO deployment to apply changes. The
   following tabs provide a quick reference of all required and optional
   environment variables and configuration settings respectively:

   .. tab-set::

      .. tab-item:: Environment Variables

         MinIO supports specifying the :abbr:`OIDC (OpenID Connect)` provider
         settings using :ref:`environment variables
         <minio-server-envvar-external-identity-management-openid>`. The 
         :mc:`minio server` process applies the specified settings on its next
         startup. For distributed deployments, specify these settings across all
         nodes in the deployment using the *same* values consistently.

         The following example code sets *all* environment variables related to
         configuring an :abbr:`OIDC (OpenID Connect)` provider for external
         identity management. The minimum *required* variable is 
         :envvar:`MINIO_IDENTITY_OPENID_CONFIG_URL`:

         .. code-block:: shell
            :class: copyable

            export MINIO_IDENTITY_OPENID_CONFIG_URL="https://openid-provider.example.net/.well-known/openid-configuration"
            export MINIO_IDENTITY_OPENID_CLIENT_ID="<string>"
            export MINIO_IDENTITY_OPENID_CLIENT_SECRET="<string>"
            export MINIO_IDENTITY_OPENID_CLAIM_NAME="<string>"
            export MINIO_IDENTITY_OPENID_CLAIM_PREFIX="<string>"
            export MINIO_IDENTITY_OPENID_SCOPES="<string>"
            export MINIO_IDENTITY_OPENID_REDIRECT_URI="<string>"
            export MINIO_IDENTITY_OPENID_COMMENT="<string>"

         Replace the ``MINIO_IDENTITY_OPENID_CONFIG_URL`` with the URL endpoint of
         the :abbr:`OIDC (OpenID Connect)` provider discovery document. 

         For complete documentation on these variables, see
         :ref:`minio-server-envvar-external-identity-management-openid`

      .. tab-item:: Configuration Settings

         MinIO supports specifying the :abbr:`OIDC (OpenID Connect)` provider
         settings using :mc-conf:`configuration settings <identity_openid>`. The 
         :mc:`minio server` process applies the specified settings on its next
         startup. For distributed deployments, the :mc:`mc admin config`
         command applies the configuration to all nodes in the deployment.

         The following example code sets *all* configuration settings related to
         configuring an :abbr:`OIDC (OpenID Connect)` provider for external
         identity management. The minimum *required* setting is 
         :mc-conf:`identity_openid config_url <identity_openid.config_url>`:

         .. code-block:: shell
            :class: copyable

            mc admin config set ALIAS/ identity_openid \
               config_url="https://openid-provider.example.net/.well-known/openid-configuration" \
               client_id="<string>" \
               client_secret="<string>" \
               claim_name="<string>" \
               claim_prefix="<string>" \
               scopes="<string>" \
               redirect_uri="<string>" \
               comment="<string>"

         Replace the ``config_url`` with the URL endpoint of the 
         :abbr:`OIDC (OpenID Connect)` provider discovery document. 

         For more complete documentation on these settings, see
         :mc-conf:`identity_openid`.

#. Restart the MinIO Deployment

   You must restart the MinIO deployment to apply the configuration changes. 
   Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

   .. code-block:: shell
      :class: copyable

      mc admin service restart ALIAS

   Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
   restart.

#. Use the MinIO Console to Log In with OIDC Credentials

   The MinIO Console supports the full workflow of authenticating to the
   :abbr:`OIDC (OpenID Connect)` provider, generating temporary credentials using
   the MinIO :ref:`minio-sts-assumerolewithwebidentity` Security Token Service
   (STS) endpoint, and logging the user into the MinIO deployment.

   Starting in :minio-release:`RELEASE.2021-07-08T01-15-01Z`, the MinIO Console is
   embedded in the MinIO server. You can access the Console by opening the root URL
   for the MinIO cluster. For example, ``https://minio.example.net:9000``.

   From the Console, click :guilabel:`BUTTON` to begin the OpenID authentication
   flow.

   Once logged in, you can perform any action for which the authenticated
   user is :ref:`authorized 
   <minio-external-identity-management-openid-access-control>`. 

   You can also create :ref:`access keys <minio-idp-service-account>` for
   supporting applications which must perform operations on MinIO. Access Keys
   are long-lived credentials which inherit their privileges from the parent user.
   The parent user can further restrict those privileges while creating the service
   account. 

#. Generate S3-Compatible Temporary Credentials using OIDC Credentials

   MinIO requires clients authenticate using :s3-api:`AWS Signature Version 4
   protocol <sig-v4-authenticating-requests.html>` with support for the deprecated
   Signature Version 2 protocol. Specifically, clients must present a valid access
   key and secret key to access any S3 or MinIO administrative API, such as
   ``PUT``, ``GET``, and ``DELETE`` operations.

   Applications can generate temporary access credentials as-needed using the 
   :ref:`minio-sts-assumerolewithwebidentity` Security Token Service (STS)
   API endpoint and the JSON Web Token (JWT) returned by the 
   :abbr:`OIDC (OpenID Connect)` provider.

   The application must provide a workflow for logging into the 
   :abbr:`OIDC (OpenID Connect)` provider and retrieving the 
   JSON Web Token (JWT) associated to the authentication session. Defer to the
   provider documentation for obtaining and parsing the JWT token after successful
   authentication. MinIO provides an example Go application 
   :minio-git:`web-identity.go <minio/blob/master/docs/sts/web-identity.go>` with
   an example of managing this workflow.

   Once the application retrieves the JWT token, use the 
   ``AssumeRoleWithWebIdentity`` endpoint to generate the temporary credentials:

   .. code-block:: shell
      :class: copyable

      POST https://minio.example.net?Action=AssumeRoleWithWebIdentity
      &WebIdentityToken=TOKEN
      &Version=2011-06-15
      &DurationSeconds=86400
      &Policy=Policy

   - Replace the ``TOKEN`` with the JWT token returned in the previous step.
   - Replace the ``DurationSeconds`` with the duration in seconds until the temporary credentials expire. The example above specifies a period of ``86400`` seconds, or 24 hours.
   - Replace the ``Policy`` with an inline URL-encoded JSON :ref:`policy <minio-policy>` that further restricts the permissions associated to the temporary credentials. 
   
     Omit to use the policy associated to the OpenID user :ref:`policy claim <minio-external-identity-management-openid-access-control>`.

   The API response consists of an XML document containing the
   access key, secret key, session token, and expiration date. Applications
   can use the access key and secret key to access and perform operations on
   MinIO.

   See the :ref:`minio-sts-assumerolewithwebidentity` for reference documentation.