.. _minio-external-identity-management-ad-ldap:

====================================================
Active Directory / LDAP External Identity Management
====================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

MinIO supports using an Active Directory or LDAP (AD/LDAP) service for external
management of user identities. Configuring an external IDentity Provider (IDP)
enables Single-Sign On (SSO) workflows, where applications authenticate against
the external IDP before accessing MinIO.

MinIO by default denies access to all actions or resources not explicitly
allowed by a user's assigned or inherited :ref:`policies <minio-policy>`. Users
managed by an AD/LDAP provider must specify the necessary policies as part of
the user profile data. See :ref:`Access Control for AD/LDAP Managed Identities
<minio-external-identity-management-ad-ldap-access-control>` for more
information.

See :ref:`minio-authenticate-using-ad-ldap-generic` for instructions on enabling
external identity management using an AD/LDAP service.

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

Authentication and Authorization Flow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The login flow for an application using Active Directory / LDAP 
credentials is as follows:

1. Specify the AD/LDAP credentials to the MinIO Security Token Service (STS)
   :ref:`minio-sts-assumerolewithldapidentity` API endpoint.

2. MinIO verifies the provided credentials against the AD/LDAP server. 

3. MinIO checks for any :ref:`policy <minio-policy>` whose name matches the
   user Distinguished Name (DN) and assigns that policy to the authenticated
   user.

   If configured to perform group queries, MinIO also queries for a list of
   AD/LDAP groups in which the user has membership. MinIO checks for any policy
   whose name matches a returned group DN and assigns that
   policy to the authenticated user.
   
4. MinIO returns temporary credentials in the STS API response in the form of an
   access key, secret key, and session token. The credentials have permissions
   matching those policies whose name matches either the authenticated user DN
   *or* a group DN.

MinIO provides an example Go application
:minio-git:`ldap.go <minio/blob/master/docs/sts/ldap.go>` that handles the
full login flow. 

As an alternative to implementing this application flow, application owners can
log into the :minio-git:`MinIO Console <console>` using their external
user credentials and create :ref:`service accounts <minio-idp-service-account>`
for their applications. Service accounts are long-lived credentials which
inherit their privileges from the parent user. The parent user can further
restrict those privileges while creating the service account. 

Querying the Active Directory / LDAP Service
--------------------------------------------

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
~~~~~~~~~~~~~~~~

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
~~~~~~~~~~~~~~~~~~

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

Access Control for Externally Managed Identities
------------------------------------------------

MinIO uses :ref:`Policy Based Access Control (PBAC) <minio-access-management>`
to define the actions and resources to which an authenticated user has access.
MinIO supports creating and managing :ref:`policies <minio-policy>` which an
externally managed user can claim. 

For identities managed by the external Active Directory / LDAP server, 
MinIO attempts to match existing policies to the authenticated user's 
Distinguished Name (DN). 

MinIO also supports querying for the user's AD/LDAP group membership. MinIO
attempts to match existing policies to the DN for each of the user's groups. See
:ref:`minio-external-identity-management-ad-ldap-access-control-group-lookup`
for more information.

For example, consider the following user and group DNs:

.. code-block:: shell

   cn=applicationUser,cn=users,dc=example,dc=com
   cn=applicationGroup,cn=groups,dc=example,dc=com

MinIO attaches the policies with names matching the *full* DN for the user and
group to the authenticated user.

The authenticated users complete set of permissions consists of its
explicitly assigned and inherited policies. If the user DN and group DNs
do not match any policies on the MinIO deployment, MinIO denies authorization
for any and all operations issued by that user.

MinIO provides :ref:`built-in policies <minio-policy-built-in>` for basic access
control. You can create new policies using the :mc:`mc admin policy` command.
You can create new groups using the :mc:`mc admin group` command and assign
policies to that group using :mc-cmd:`mc admin policy set`.

.. _minio-external-identity-management-ad-ldap-access-control-group-lookup:

Group Lookup
~~~~~~~~~~~~

MinIO supports querying the Active Directory / LDAP server for a list of
groups in which the authenticated user has membership. MinIO 
attempts to match existing :ref:`policies <minio-policy>` to each group
DN and assigns each matching policy to the authenticated user.

The following tabs provide a reference of the environment variables and
configuration settings required for enabling group lookups:

.. tab-set::

   .. tab-item:: Environment Variable

      - :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN`
      - :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER`

      See the :ref:`minio-server-envvar-external-identity-management-ad-ldap`
      reference documentation for more information on these variables. The
      :ref:`minio-authenticate-using-openid-generic` tutorial includes complete
      instructions on setting these values.

   .. tab-item:: Configuration Setting


      - :mc-conf:`identity_ldap group_search_base_dn <identity_ldap.group_search_base_dn>`
      - :mc-conf:`identity_ldap group_search_filter <identity_ldap.group_search_filter>`

      See the :mc-conf:`identity_ldap` reference documentation for more
      information on these settings. The
      :ref:`minio-authenticate-using-openid-generic` tutorial includes complete
      instructions on setting these variables.


.. toctree::
   :titlesonly:
   :hidden:

   /security/ad-ldap-external-identity-management/configure-ad-ldap-external-identity-management.rst
   /security/ad-ldap-external-identity-management/AssumeRoleWithLDAPIdentity.rst

