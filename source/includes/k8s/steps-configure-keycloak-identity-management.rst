.. |KEYCLOAK_URL| replace:: keycloak-service.keycloak-namespace.svc.cluster-domain.example
.. |MINIO_S3_URL| replace:: minio.minio-tenant.svc.cluster-domain.example
.. |MINIO_CONSOLE_URL| replace:: minio-console.minio-tenant.svc.cluster-domain.example

1) Configure or Create a Client for Accessing Keycloak
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Authenticate to the Keycloak :guilabel:`Administrative Console` and navigate to :guilabel:`Clients`.

.. include:: /includes/common/common-configure-keycloak-identity-management.rst
   :start-after: start-configure-keycloak-client
   :end-before: end-configure-keycloak-client

2) Create Client Scope for MinIO Client
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Client scopes allow Keycloak to map user attributes as part of the JSON Web Token (JWT) returned in authentication requests.
This allows MinIO to reference those attributes when assigning policies to the user.
This step creates the necessary client scope to support MinIO authorization after successful Keycloak authentication.

.. include:: /includes/common/common-configure-keycloak-identity-management.rst
   :start-after: start-configure-keycloak-client-scope
   :end-before: end-configure-keycloak-client-scope

3) Apply the Necessary Attribute to Keycloak Users/Groups
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must assign an attribute named ``policy`` to the Keycloak Users or Groups. 
Set the value to any :ref:`policy <minio-policy>` on the MinIO deployment.

.. include:: /includes/common/common-configure-keycloak-identity-management.rst
   :start-after: start-configure-keycloak-user-group-attributes
   :end-before: end-configure-keycloak-user-group-attributes

4) Configure MinIO for Keycloak Authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports multiple methods for configuring Keycloak authentication:

- Using the MinIO Operator Console
- Using the MinIO Tenant Console
- Using a terminal/shell and the :mc:`mc idp openid` command

.. tab-set::

   .. tab-item:: MinIO Operator Console

      You can use the MinIO Operator Console to configure Keycloak as the External Identity Provider for the MinIO Tenant.
      See :ref:`minio-operator-console-connect` for specific instructions.

      Select :guilabel:`Identity Provider` from the left-hand navigation bar, then select :guilabel:`OpenID`.
      Select :guilabel:`Create Configuration` to create a new configuration.

      Enter the following information into the modal:

      .. list-table::
         :stub-columns: 1
         :widths: 30 70
         :width: 100%

         * - :guilabel:`Name` 
           - Enter a unique name for the Keycloak instance 
         
         * - :guilabel:`Config URL`
           - Specify the address of the Keycloak OpenID configuration document (|KEYCLOAK_URL|)

             Ensure the ``REALM`` matches the Keycloak realm you want to use for authenticating users to MinIO

         * - :guilabel:`Client ID`
           - Specify the name of the Keycloak client created in Step 1
         
         * - :guilabel:`Client Secret`
           - Specify the secret credential value for the Keycloak client created in Step 1

         * - :guilabel:`Display Name`
           - Specify the user-facing name the MinIO Console should display as part of the Single-Sign On (SSO) workflow for the configured Keycloak service

         * - :guilabel:`Scopes` 
           - Specify the OpenID scopes to include in the JWT, such as ``preferred_username`` or ``email``
         
             You can reference these scopes using supported OpenID policy variables for the purpose of programmatic policy configurations

         * - :guilabel:`Redirect URI Dynamic`
           - Toggle to ``on``
         
             Substitutes the MinIO Console address used by the client as part of the Keycloak redirect URI.
             Keycloak returns authenticated users to the Console using the provided URI.
             
             For MinIO Console deployments behind a reverse proxy, load balancer, or similar network control plane, you can instead use the :envvar:`MINIO_BROWSER_REDIRECT_URL` variable to set the redirect address for Keycloak to use.

      Select :guilabel:`Save` to apply the configuration.

   .. tab-item:: MinIO Tenant Console

      You can use the MinIO Tenant Console to configure Keycloak as the External Identity Provider for the MinIO Tenant.

      Access the Console service using the NodePort, Ingress, or Load Balancer endpoint.
      You can use the following command to review the Console configuration:

      .. code-block:: shell
         :class: copyable

         kubectl describe svc/TENANT_NAME-console -n TENANT_NAMESPACE

      Replace ``TENANT_NAME`` and ``TENANT_NAMESPACE`` with the name of the MinIO Tenant and it's Namespace, respectively.

      .. include:: /includes/common/common-configure-keycloak-identity-management.rst
         :start-after: start-configure-keycloak-minio-console
         :end-before: end-configure-keycloak-minio-console

      Select :guilabel:`Save` to apply the configuration.

   .. tab-item:: CLI

      .. include:: /includes/common/common-configure-keycloak-identity-management.rst
         :start-after: start-configure-keycloak-minio-cli
         :end-before: end-configure-keycloak-minio-cli

Restart the MinIO deployment for the changes to apply.

Check the MinIO logs and verify that startup succeeded with no errors related to the OIDC configuration.

If you attempt to log in with the Console, you should now see an (SSO) button using the configured :guilabel:`Display Name`.

Specify a configured user and attempt to log in.
MinIO should automatically redirect you to the Keycloak login entry.
Upon successful authentication, Keycloak should redirect you back to the MinIO Console using either the originating Console URL *or* the :guilabel:`Redirect URI` if configured.

5) Generate Application Credentials using the Security Token Service (STS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


.. include:: /includes/common/common-configure-keycloak-identity-management.rst
   :start-after: start-configure-keycloak-sts
   :end-before: end-configure-keycloak-sts

Next Steps
~~~~~~~~~~

Applications should implement the :ref:`STS AssumeRoleWithWebIdentity <minio-sts-assumerolewithwebidentity>` flow using their :ref:`SDK <minio-drivers>` of choice.
When STS credentials expire, applications should have logic in place to regenerate the JWT token, STS token, and MinIO credentials before retrying and continuing operations.

Alternatively, users can generate :ref:`access keys <minio-id-access-keys>` through the MinIO Console for the purpose of creating long-lived API-key like access using their Keycloak credentials.
