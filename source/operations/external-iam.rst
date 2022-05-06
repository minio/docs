.. _minio-external-identity-management:

============================
External Identity Management
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO supports offloading identity management onto one of the following supported IDentity Providers (IDP):

- :ref:`OpenID Connect <minio-external-iam-oidc>`
- :ref:`Active Directory / LDAP <minio-external-iam-ad-ldap>`

.. admonition:: MinIO Supports At Most One Configured IDentity Provider
   :class: important

   Configuring an external IDP disables the :ref:`MinIO internal IDP
   <minio-internal-idp>` and prevents the configuration of any other
   external IDP.

   The external :abbr:`IDP (IDentity Provider)` must have *at least* one
   configured user identity with the required :ref:`policy claims
   <minio-external-identity-management-ad-ldap-access-control>`. If no such user
   exists, the MinIO server is effectively inaccessible outside of using the
   :ref:`root <minio-users-root>` user.

.. _minio-external-iam-oidc:

OpenID Connect (OIDC)
---------------------

MinIO supports using an OpenID Connect (OIDC) compatible IDentity Provider (IDP)
such as Okta, KeyCloak, Dex, Google, or Facebook for external management of user
identities. Configuring an external :abbr:`IDP (IDentity Provider)` enables
Single-Sign On workflows, where applications authenticate against the external
:abbr:`IDP (IDentity Provider)` before accessing MinIO.

MinIO uses :ref:`Policy Based Access Control (PBAC) <minio-access-management>`
to define the actions and resources to which an authenticated user has access.
MinIO supports creating and managing :ref:`policies <minio-policy>` which an
externally managed user can claim. 

For identities managed by the external OpenID Connect (OIDC) compatible
provider, MinIO uses a `JSON Web Token claim
<https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ to identify the
:ref:`policy <minio-policy>` to assign to the authenticated user. 

See :ref:`minio-external-identity-management-openid-access-control` for more information on mapping MinIO policies to an OIDC-managed identity.

MinIO by default looks for a ``policy`` claim and reads a list of one or more
policies to assign. MinIO attempts to match existing policies to those
specified in the JWT claim. If none of the specified policies exist on the MinIO
deployment, MinIO denies authorization for any and all operations issued
by that user. For example, consider a claim with the following key-value
assignment:

.. code-block:: shell

   policy="readwrite_data,read_analytics,read_logs"

The specified policy claim directs MinIO to attach the policies with names
matching ``readwrite_data``, ``read_analytics``, and ``read_logs`` to the
authenticated user.

You can set a custom policy claim using the 
:envvar:`MINIO_IDENTITY_OPENID_CLAIM_NAME` environment variable
*or* by using :mc-cmd:`mc admin config set` to set the 
:mc-conf:`identity_openid claim_name <identity_openid.claim_name>` setting.

You can use a `JWT Debugging tool <https://jwt.io/>`__ to decode the returned
JWT token and validate that the user attributes include the specified claim. See
`RFC 7519: JWT Claim
<https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ for more
information on JWT claims. Defer to the documentation for your preferred OIDC
provider for instructions on configuring user claims.

.. _minio-external-iam-ad-ldap:

Active Directory / LDAP
-----------------------

MinIO supports using an Active Directory or LDAP (AD/LDAP) service for external
management of user identities. Configuring an external IDentity Provider (IDP)
enables Single-Sign On (SSO) workflows, where applications authenticate against
the external IDP before accessing MinIO.

Querying the Active Directory / LDAP Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO queries the configured Active Directory / LDAP server to verify the
credentials specified by the application and optionally return a list of groups
in which the user has membership. MinIO supports two modes for performing
these queries:

- :ref:`minio-external-identity-management-ad-ldap-lookup-bind` - Use a special
  read-only account for querying the LDAP server.

- :ref:`minio-external-identity-management-ad-ldap-username-bind` - Use the 
  credentials specified by the application to login to the LDAP server. 

MinIO recommends using Lookup-Bind mode as the preferred method for verifying
AD/LDAP credentials. Username-Bind mode is a legacy method retained
for backwards compatibility only.

.. _minio-external-identity-management-ad-ldap-lookup-bind:

Lookup-Bind Mode
++++++++++++++++

In Lookup-Bind mode, MinIO uses a read-only AD/LDAP account with the minimum
privileges required to authenticate to the AD/LDAP server and perform user and
group lookups.

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
      :ref:`minio-authenticate-using-openid-generic` tutorial includes complete
      instructions on setting these values.

   .. tab-item:: Configuration Setting

      - :mc-conf:`identity_ldap lookup_bind_dn <identity_ldap.lookup_bind_dn>`
      - :mc-conf:`identity_ldap lookup_bind_password <identity_ldap.lookup_bind_password>`
      - :mc-conf:`identity_ldap user_dn_search_base_dn <identity_ldap.user_dn_search_base_dn>`
      - :mc-conf:`identity_ldap user_dn_search_filter <identity_ldap.user_dn_search_filter>`

      See the :mc-conf:`identity_ldap` reference documentation for more
      information on these settings. The
      :ref:`minio-authenticate-using-openid-generic` tutorial includes complete
      instructions on setting these variables.

Lookup-Bind is incompatible and mutually exclusive with
:ref:`minio-external-identity-management-ad-ldap-username-bind`.

.. _minio-external-identity-management-ad-ldap-username-bind:

Username-Bind Mode
++++++++++++++++++

In Username-Bind mode, MinIO uses the AD/LDAP credentials provided by the client
attempting authentication to login to the AD/LDAP server and perform and group
lookups.

Username-Bind mode is preserved for compatibility only. MinIO recommends
using :ref:`minio-external-identity-management-ad-ldap-lookup-bind` wherever possible.

The following tabs provide a reference of the environment variables and
configuration settings required for enabling Username-Bind mode.

.. tab-set::
   
   .. tab-item:: Environment Variable

      - :envvar:`MINIO_IDENTITY_LDAP_USERNAME_FORMAT`

      See the :ref:`minio-server-envvar-external-identity-management-ad-ldap`
      reference documentation for more information on this variable.

   .. tab-item:: Configuration Setting

      - :mc-conf:`identity_ldap username_format <identity_ldap.username_format>`

      See the :mc-conf:`identity_ldap` reference documentation for more
      information on this setting.

Username-bind is incompatible and mutually exclusive with
:ref:`minio-external-identity-management-ad-ldap-lookup-bind`.

.. _minio-external-identity-management-ad-ldap-access-control:

Access Control for AD/LDAP-Managed Identities
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO uses :ref:`Policy Based Access Control (PBAC) <minio-access-management>`
to define the actions and resources to which an authenticated user has access.
When using an Active Directory/LDAP server for identity management
(authentication), MinIO maintains control over access (authorization) 
through PBAC. 

When a user successfully authenticates to MinIO using their AD/LDAP
credentials, MinIO searches for all :ref:`policies <minio-policy>` which
are explicitly associated to that user's Distinguished Name (DN). 
Specifically, the policy must be assigned to a user with a matching DN
using the :mc-cmd:`mc admin policy set` command. 

MinIO also supports querying for the user's AD/LDAP group membership. MinIO
attempts to match existing policies to the DN for each of the user's groups. The
authenticated users complete set of permissions consists of its explicitly
assigned and group-inherited policies. See
:ref:`minio-external-identity-management-ad-ldap-access-control-group-lookup`
for more information.

MinIO uses deny-by-default behavior where a user with no explicitly assigned or
group-inherited policies cannot access any resource on the MinIO deployment.

MinIO provides :ref:`built-in policies <minio-policy-built-in>` for basic access
control. You can create new policies using the :mc:`mc admin policy` command.

.. _minio-external-identity-management-ad-ldap-access-control-group-lookup:

Group Lookup
++++++++++++

MinIO supports querying the Active Directory / LDAP server for a list of groups in which the authenticated user has membership. MinIO attempts to match existing :ref:`policies <minio-policy>` to each group DN and assigns each matching policy to the authenticated user.

The following tabs provide a reference of the environment variables and
configuration settings required for enabling group lookups:

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

   /operations/external-iam/*