.. _minio-external-identity-management:

============================
External Identity Management
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO supports multiple external identity managers through the following IDentity Providers (IDP):

- :ref:`OpenID Connect-Compatible <minio-external-iam-oidc>`
- :ref:`Active Directory / LDAP <minio-external-iam-ad-ldap>`

The following tutorials provide specific guidance for select IDP software:

- :ref:`Configure MinIO Authentication with KeyCloak <minio-authenticate-using-keycloak>`

Users can authenticate against MinIO using their externally managed credentials and the related :ref:`minio-security-token-service` API.
Once authenticated, MinIO attempts to associate the user with one or more configured :ref:`policies <minio-policy>`.
A user with no associated policies has no permissions on the MinIO deployment.

.. _minio-external-iam-oidc:

OpenID Connect (OIDC)
---------------------

MinIO supports using an OpenID Connect (OIDC) compatible IDentity Provider (IDP) such as Okta, KeyCloak, Dex, Google, or Facebook for external management of user identities. 
Configuring an external :abbr:`IDP (IDentity Provider)` enables Single-Sign On workflows, where applications authenticate against the external :abbr:`IDP (IDentity Provider)` before accessing MinIO.

MinIO uses :ref:`Policy Based Access Control (PBAC) <minio-access-management>` to define the actions and resources to which an authenticated user has access.
MinIO supports creating and managing :ref:`policies <minio-policy>` which an externally managed user can claim. 

For identities managed by the external OpenID Connect (OIDC) compatible provider, MinIO uses a `JSON Web Token claim <https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ to identify the :ref:`policy <minio-policy>` to assign to the authenticated user. 

MinIO by default looks for a ``policy`` claim and reads a list of one or more policies to assign. MinIO attempts to match existing policies to those specified in the JWT claim. 
If none of the specified policies exist on the MinIO deployment, MinIO denies authorization for any and all operations issued by that user. 
For example, consider a claim with the following key-value assignment:

.. code-block:: shell

   policy="readwrite_data,read_analytics,read_logs"

The specified policy claim directs MinIO to attach the policies with names matching ``readwrite_data``, ``read_analytics``, and ``read_logs`` to the authenticated user.


You can set a custom policy claim using the 
:envvar:`MINIO_IDENTITY_OPENID_CLAIM_NAME` environment variable
*or* by using :mc-cmd:`mc admin config set` to set the 
:mc-conf:`identity_openid claim_name <identity_openid.claim_name>` setting.

See :ref:`minio-external-identity-management-openid-access-control` for more information on mapping MinIO policies to an OIDC-managed identity.

You can use a `JWT Debugging tool <https://jwt.io/>`__ to decode the returned JWT token and validate that the user attributes include the specified claim. 
See `RFC 7519: JWT Claim <https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ for more information on JWT claims. 
Defer to the documentation for your preferred OIDC provider for instructions on configuring user claims.

.. _minio-external-iam-ad-ldap:

Active Directory / LDAP
-----------------------

MinIO supports using an Active Directory or LDAP (AD/LDAP) service for external
management of user identities. Configuring an external IDentity Provider (IDP)
enables Single-Sign On (SSO) workflows, where applications authenticate against
the external IDP before accessing MinIO.

.. _minio-external-identity-management-ad-ldap-lookup-bind:

Querying the Active Directory / LDAP Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO queries the configured Active Directory / LDAP server to verify the credentials specified by the application and optionally return a list of groups in which the user has membership.
This process, called Lookup-Bind mode, uses an AD/LDAP user with minimal permissions, only sufficient to authenticate with the AD/LDAP server for user and group lookups.


The following tabs provide a reference of the environment variables and
configuration settings required for enabling Lookup-Bind mode. 

.. tab-set::

   .. tab-item:: Environment Variable

      - :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN`
      - :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD`
      - :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN`
      - :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER`

      See the :ref:`minio-server-envvar-external-identity-management-ad-ldap`
      reference documentation for more information on these variables. The
      :ref:`minio-authenticate-using-ad-ldap-generic` tutorial includes complete
      instructions on setting these values.

   .. tab-item:: Configuration Setting

      - :mc-conf:`identity_ldap lookup_bind_dn <identity_ldap.lookup_bind_dn>`
      - :mc-conf:`identity_ldap lookup_bind_password <identity_ldap.lookup_bind_password>`
      - :mc-conf:`identity_ldap user_dn_search_base_dn <identity_ldap.user_dn_search_base_dn>`
      - :mc-conf:`identity_ldap user_dn_search_filter <identity_ldap.user_dn_search_filter>`

      See the :mc-conf:`identity_ldap` reference documentation for more
      information on these settings. The
      :ref:`minio-authenticate-using-ad-ldap-generic` tutorial includes complete
      instructions on setting these variables.

.. _minio-external-identity-management-ad-ldap-access-control:

Access Control for AD/LDAP-Managed Identities
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO uses :ref:`Policy Based Access Control (PBAC) <minio-access-management>` to define the actions and resources to which an authenticated user has access.
When using an Active Directory/LDAP server for identity management (authentication), MinIO maintains control over access (authorization) through PBAC. 

When a user successfully authenticates to MinIO using their AD/LDAP credentials, MinIO searches for all :ref:`policies <minio-policy>` which are explicitly associated to that user's Distinguished Name (DN). 
Specifically, the policy must be assigned to a user with a matching DN using the :mc:`mc idp ldap policy attach` command. 

MinIO also supports querying for the user's AD/LDAP group membership. 
MinIO attempts to match existing policies to the DN for each of the user's groups. 
The authenticated users complete set of permissions consists of its explicitly assigned and group-inherited policies. 
See :ref:`minio-external-identity-management-ad-ldap-access-control-group-lookup` for more information.

MinIO uses deny-by-default behavior where a user with no explicitly assigned or group-inherited policies cannot access any resource on the MinIO deployment.

MinIO provides :ref:`built-in policies <minio-policy-built-in>` for basic access control.
You can create new policies using the :mc:`mc admin policy create` command.

.. _minio-external-identity-management-ad-ldap-access-control-group-lookup:

Group Lookup
++++++++++++

MinIO supports querying the Active Directory / LDAP server for a list of groups in which the authenticated user has membership. 
MinIO attempts to match existing :ref:`policies <minio-policy>` to each group DN and assigns each matching policy to the authenticated user.

The following tabs provide a reference of the environment variables and configuration settings required for enabling group lookups:

.. tab-set::

   .. tab-item:: Environment Variable

      - :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN`
      - :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER`

      See the :ref:`minio-server-envvar-external-identity-management-ad-ldap`
      reference documentation for more information on these variables. The
      :ref:`minio-authenticate-using-ad-ldap-generic` tutorial includes complete
      instructions on setting these values.

   .. tab-item:: Configuration Setting


      - :mc-conf:`identity_ldap group_search_base_dn <identity_ldap.group_search_base_dn>`
      - :mc-conf:`identity_ldap group_search_filter <identity_ldap.group_search_filter>`

      See the :mc-conf:`identity_ldap` reference documentation for more
      information on these settings. The
      :ref:`minio-authenticate-using-ad-ldap-generic` tutorial includes complete
      instructions on setting these variables.

.. toctree::
   :glob:
   :hidden:

   /operations/external-iam/*
