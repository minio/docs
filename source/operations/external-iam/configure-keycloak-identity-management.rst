.. _minio-authenticate-using-keycloak:

=================================================
Configure MinIO for Authentication using Keycloak
=================================================

.. default-domain:: minio


.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

This procedure configures MinIO to use `Keycloak <https://www.keycloak.org/>`__ as an external IDentity Provider (IDP) for authentication of users via the OpenID Connect (OIDC) protocol.

This page has procedures for configuring OIDC for MinIO deployments in Kubernetes and Baremetal infrastructures.

Select the tab corresponding to your infrastructure to switch between instruction sets.

.. tab-set::
   :class: parent-tab

   .. tab-item:: Kubernetes
      :sync: k8s

      For MinIO Tenants deployed using the :ref:`MinIO Kubernetes Operator <minio-kubernetes>`, this procedure covers:

      - Configure Keycloak for use with MinIO authentication and authorization
      - Configure a new or existing MinIO Tenant to use Keycloak as the OIDC provider
      - Create policies to control access of Keycloak-authenticated users
      - Log into the MinIO Tenant Console using SSO and a Keycloak-managed identity
      - Generate temporary S3 access credentials using the ``AssumeRoleWithWebIdentity`` Security Token Service (STS) API

   .. tab-item:: Baremetal
      :sync: baremetal

      For MinIO deployments on baremetal infrastructure, this procedure covers:

      - Configure Keycloak for use with MinIO authentication and authorization
      - Configure a new or existing MinIO cluster to use Keycloak as the OIDC provider
      - Create policies to control access of Keycloak-authenticated users
      - Log into the MinIO Console using SSO and a Keycloak-managed identity
      - Generate temporary S3 access credentials using the ``AssumeRoleWithWebIdentity`` Security Token Service (STS) API

This procedure was written and tested against Keycloak ``21.0.0``. 
The provided instructions may work against other Keycloak versions.
This procedure assumes you have prior experience with Keycloak and have reviewed `their documentation <https://www.keycloak.org/documentation>`__ for guidance and best practices in deploying, configuring, and managing the service.

Prerequisites
-------------

Keycloak Deployment and Realm Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure assumes an existing Keycloak deployment to which you have administrative access.
Specifically, you must have permission to create and configure Realms, Clients, Client Scopes, Realm Roles, Users, and Groups on the Keycloak deployment.

.. tab-set::
   :class: hidden

   .. tab-item:: Kubernetes
      :sync: k8s

      For Keycloak deployments within the same Kubernetes cluster as the MinIO Tenant, this procedure assumes bidirectional access between the Keycloak and MinIO pods/services.
      For Keycloak deployments external to the Kubernetes cluster, this procedure assumes an existing Ingress, Load Balancer, or similar Kubernetes network control component that manages network access to and from the MinIO Tenant.


   .. tab-item:: Baremetal
      :sync: baremetal

      The MinIO deployment must have bidirectional access to the target OIDC service.

Ensure each user identity intended for use with MinIO has the appropriate :ref:`claim <minio-external-identity-management-openid-access-control>` configured such that MinIO can associate a :ref:`policy <minio-policy>` to the authenticated user.
An OpenID user with no assigned policy has no permission to access any action or resource on the MinIO cluster.


Access to MinIO Cluster
~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::
   :class: hidden

   .. tab-item:: Kubernetes
      :sync: k8s

      You must have access to the MinIO Operator Console web UI.
      You can either expose the MinIO Operator Console service using your preferred Kubernetes routing component, or use temporary port forwarding to expose the Console service port on your local machine.

   .. tab-item:: Baremetal
      :sync: baremetal

      This procedure uses :mc:`mc` for performing operations on the MinIO cluster. 
      Install ``mc`` on a machine with network access to the cluster.
      See the ``mc`` :ref:`Installation Quickstart <mc-install>` for instructions on downloading and installing ``mc``.

      This procedure assumes a configured :mc:`alias <mc alias>` for the MinIO cluster. 

.. _minio-external-identity-management-keycloak-configure:

Configure MinIO for Keycloak Identity Management
------------------------------------------------

.. tab-set::

   .. tab-item:: Kubernetes
      :sync: k8s

      .. include:: /includes/k8s/steps-configure-keycloak-identity-management.rst

   .. tab-item:: Baremetal
      :sync: baremetal

      .. include:: /includes/baremetal/steps-configure-keycloak-identity-management.rst

Enable the Keycloak Admin REST API
----------------------------------

MinIO supports using the Keycloak Admin REST API for checking if an authenticated user exists *and* is enabled on the Keycloak realm.
This functionality allows MinIO to more quickly remove access from previously authenticated Keycloak users.
Without this functionality, the earliest point in time that MinIO could disable access for a disabled or removed user is when the last retrieved authentication token expires.

This procedure assumes an existing MinIO deployment configured with Keycloak as an external identity manager.

1) Create the Necessary Client Scopes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Navigate to the :guilabel:`Client scopes` view and create a new scope:

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - :guilabel:`Name`
     - Set to a recognizable name for the scope (``minio-admin-API-access``)
   * - :guilabel:`Mappers`
     - Select :guilabel:`Configure a new mapper`
   * - :guilabel:`Audience`
     - Set the :guilabel:`Name` to any recognizable name for the mapping (``minio-admin-api-access-mapper``)
   * - :guilabel:`Included Client Audience`
     - Set to ``security-admin-console``.

Navigate to :guilabel:`Clients` and select the MinIO client

1. From :guilabel:`Service account roles`, select :guilabel:`Assign role` and assign the ``admin`` role
2. From :guilabel:`Client scopes`, select :guilabel:`Add client scope` and add the previously created scope

Navigate to :guilabel:`Settings` and ensure :guilabel:`Authentication flow` includes ``Service accounts roles``.

2) Validate Admin API Access
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can validate the functionality by using the Admin REST API with the MinIO client credentials to retrieve a bearer token and user data:

1. Retrieve the bearer token:

   .. code-block:: shell
      :class: copyable

      curl -d "client_id=minio" \
           -d "client_secret=secretvalue" \
           -d "grant_type=password" \
           http://keycloak-url:port/admin/realms/REALM/protocol/openid-connect/token

2. Use the value returned as the ``access_token`` to access the Admin API:

   .. code-block:: shell
      :class: copyable

      curl -H "Authentication: Bearer ACCESS_TOKEN_VALUE" \
           http://keycloak-url:port/admin/realms/REALM/users/UUID

   Replace ``UUID`` with the unique ID for the user which you want to retrieve.
   The response should resemble the following:

   .. code-block:: json
      
      {
         "id": "954de141-781b-4eaf-81bf-bf3751cdc5f2",
         "createdTimestamp": 1675866684976,
         "username": "minio-user-1",
         "enabled": true,
         "totp": false,
         "emailVerified": false,
         "firstName": "",
         "lastName": "",
         "attributes": {
            "policy": [
               "readWrite"
            ]
         },
         "disableableCredentialTypes": [],
         "requiredActions": [],
         "notBefore": 0,
         "access": {
            "manageGroupMembership": true,
            "view": true,
            "mapRoles": true,
            "impersonate": true,
            "manage": true
         }
      }

   MinIO would revoke access for an authenticated user if the returned value has ``enabled: false`` or ``null`` (user was removed from Keycloak).

3) Enable Keycloak Admin Support on MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports multiple methods for configuring Keycloak Admin API Support:

- Using a terminal/shell and the :mc:`mc idp openid` command
- Using environment variables set prior to starting MinIO

.. tab-set::

   .. tab-item:: CLI

      You can use the :mc-cmd:`mc idp openid update` command to modify the configuration settings for an existing Keycloak service.
      You can alternatively include the following configuration settings when setting up Keycloak for the first time.
      The command takes all supported :ref:`OpenID Configuration Settings <minio-open-id-config-settings>`:

      .. code-block:: shell
         :class: copyable

         mc idp openid update ALIAS KEYCLOAK_IDENTIFIER \
            vendor="keycloak" \
            keycloak_admin_url="https://keycloak-url:port/admin"
            keycloak_realm="REALM"

      - Replace ``KEYCLOAK_IDENTIFIER`` with the name of the configured Keycloak IDP.
        You can use :mc-cmd:`mc idp openid ls` to view all configured IDP configurations on the MinIO deployment
        
      - Specify the Keycloak admin URL in the :mc-conf:`keycloak_admin_url <identity_openid.keycloak_admin_url>` configuration setting

      - Specify the Keycloak Realm name in the :mc-conf:`keycloak_realm <identity_openid.keycloak_realm>`

   .. tab-item:: Environment Variables

      Set the following :ref:`environment variables <minio-server-envvar-external-identity-management-openid>` in the appropriate configuration location, such as ``/etc/default/minio``.

      The following example code sets the minimum required environment variables related to enabling the Keycloak Admin API for an existing Keycloak configuration.
      Replace the suffix ``_PRIMARY_IAM`` with the unique identifier for the target Keycloak configuration.

      .. code-block:: shell
         :class: copyable

         MINIO_IDENTITY_OPENID_VENDOR_PRIMARY_IAM="keycloak"
         MINIO_IDENTITY_OPENID_KEYCLOAK_ADMIN_URL_PRIMARY_IAM="https://keycloak-url:port/admin"
         MINIO_IDENTITY_OPENID_KEYCLOAK_REALM_PRIMARY_IAM="REALM"

      - Specify the Keycloak admin URL in the :envvar:`MINIO_IDENTITY_OPENID_KEYCLOAK_ADMIN_URL`
      - Specify the Keycloak Realm name in the :envvar:`MINIO_IDENTITY_OPENID_KEYCLOAK_REALM`

