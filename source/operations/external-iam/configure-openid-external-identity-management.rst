.. _minio-authenticate-using-openid-generic:

===============================================
Configure MinIO for Authentication using OpenID
===============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

MinIO supports using an OpenID Connect (OIDC) compatible IDentity Provider (IDP) such as Okta, KeyCloak, Dex, Google, or Facebook for external management of user identities. 
The procedure on this page provides instructions for:

.. cond:: k8s

   - Configuring a MinIO Tenant to use an external OIDC provider.
   - Accessing the Tenant Console using OIDC Credentials.
   - Using the MinIO ``AssumeRoleWithWebIdentity`` Security Token Service (STS) API to generate temporary credentials for use by applications.

.. cond:: linux or container or macos or windows

   - Configuring a MinIO cluster for an external OIDC provider.
   - Logging into the cluster using the MinIO Console and OIDC credentials.
   - Using the MinIO ``AssumeRoleWithWebIdentity`` Security Token Service (STS) API to generate temporary credentials for use by applications.

This procedure is generic for OIDC compatible providers. 
Defer to the documentation for the OIDC provider of your choice for specific instructions or procedures on authentication and JWT retrieval.

Prerequisites
-------------

.. cond:: k8s

   MinIO Kubernetes Operator
   ~~~~~~~~~~~~~~~~~~~~~~~~~

   .. include:: /includes/k8s/common-operator.rst
      :start-after: start-requires-operator-plugin
      :end-before: end-requires-operator-plugin

OpenID-Connect (OIDC) Compatible IDentity Provider
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure assumes an existing OIDC provider such as Okta, KeyCloak, Dex, Google, or Facebook. 
Instructions on configuring these services are out of scope for this procedure.

.. cond:: k8s

   - For OIDC services within the same Kubernetes cluster as the MinIO Tenant, you can use Kubernetes service names to allow the MinIO Tenant to establish connectivity to the OIDC service.

   - For OIDC services external to the Kubernetes cluster, you must ensure the cluster supports routing communications between Kubernetes services and pods and the external network.
     This may require configuration or deployment of additional Kubernetes network components and/or enabling access to the public internet.

Ensure each user identity intended for use with MinIO has the appropriate :ref:`claim <minio-external-identity-management-openid-access-control>` configured such that MinIO can associate a :ref:`policy <minio-policy>` to the authenticated user.
An OpenID user with no assigned policy has no permission to access any action or resource on the MinIO cluster.

.. cond:: k8s

   MinIO Tenant
   ~~~~~~~~~~~~

   This procedure assumes your Kubernetes cluster has sufficient resources to  :ref:`deploy a new MinIO Tenant <minio-k8s-deploy-minio-tenant>`.

   You can also use this procedure as guidance for modifying an existing MinIO Tenant to enable OIDC Identity Management.

.. cond:: linux or container or macos or windows

   MinIO Deployment
   ~~~~~~~~~~~~~~~~

   This procedure assumes an existing MinIO cluster running the :minio-git:`latest stable MinIO version <minio/releases/latest>`. 
   Defer to the :ref:`minio-installation` for more complete documentation on new MinIO deployments.

   This procedure *may* work as expected for older versions of MinIO.

.. cond:: linux or container or macos or windows

   Install and Configure ``mc`` with Access to the MinIO Cluster
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   This procedure uses :mc:`mc` for performing operations on the MinIO cluster. 
   Install ``mc`` on a machine with network access to the cluster.
   See the ``mc`` :ref:`Installation Quickstart <mc-install>` for instructions on downloading and installing ``mc``.

   This procedure assumes a configured :mc:`alias <mc alias>` for the MinIO cluster. 

.. Lightly modeled after the SSE tutorials

.. cond:: k8s

   .. _minio-external-identity-management-openid-configure:

   .. include:: /includes/k8s/steps-configure-openid-external-identity-management.rst


.. Doing this the quick and dirty way. Need to revise later to be proper full includes via stepfiles

.. cond:: linux or container or macos or windows

   .. _minio-external-identity-management-openid-configure:

   Procedure
   ---------

   1) Set the OpenID Configuration Settings
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

   2) Restart the MinIO Deployment
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   You must restart the MinIO deployment to apply the configuration changes. 
   Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

   .. code-block:: shell
      :class: copyable

      mc admin service restart ALIAS

   Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
   restart.

   3) Use the MinIO Console to Log In with OIDC Credentials
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

   4) Generate S3-Compatible Temporary Credentials using OIDC Credentials
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
