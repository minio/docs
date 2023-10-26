.. _minio-server-envvar-iam:


=======================================
Identity and Access Management Settings
=======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for configuring MinIO to work with identity and access management (IAM) solutions.
There is a section of options for each of the IAM methods MinIO supports.

- :ref:`Active Directory / LDAP <minio-server-envvar-external-identity-management-ad-ldap>`
- :ref:`OpenID <minio-server-envvar-external-identity-management-openid>`
- :ref:`MinIO Identity Management Plugin <minio-server-envvar-external-identity-management-plugin>`

.. _minio-server-envvar-external-identity-management-ad-ldap:
.. _minio-ldap-config-settings:

Active Directory / LDAP Identity Management
-------------------------------------------

The following section documents environment variables for enabling external identity management using an Active Directory or LDAP service.
See :ref:`minio-authenticate-using-ad-ldap-generic` for a tutorial on using these variables.

.. important:: 

   New in version ``RELEASE.2023-05-26T23-31-54Z``: 

   :mc:`mc idp ldap` commands are preferred over using configuration settings to configure MinIO to use Active Directory or LDAP for identity management.

   MinIO recommends using the :mc:`mc idp ldap` commands for LDAP management operations. 
   These commands offer better validation and additional features, while providing the same settings as the ``identity_ldap`` configuration key. 
   See :ref:`minio-authenticate-using-ad-ldap-generic` for a tutorial on using :mc:`mc idp ldap`.

The ``identity_ldap`` configuration settings remains available for existing scripts and other tools.

Examples
~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. code-block:: shell
         :class: copyable

         MINIO_IDENTITY_LDAP_SERVER_ADDR="ldapserver.com:636"

      .. note::

         ``srv_record_name`` automatically identifies the port.

         If your AD/LDAP server uses ``DNS SRV Records``, do *not* append the port number to your ``server_addr`` value. 
         SRV requests automatically include port numbers when returning the list of available servers.

   .. tab-item:: Configuration Setting
      :sync: config

      The following settings are required when defining LDAP using :mc:`mc config set`:

      - ``enabled``
      - ``server_addr``
      - ``lookup_bind_dn``
      - ``lookup_bind_dn_password``
      - ``user_dn_search_base_dn``
      - ``user_dn_search_filter``

      .. code-block:: shell
         :class: copyable

         mc admin config set identity_ldap                        \
            enabled="true"                                        \
            server_addr="ad-ldap.example.net/"                    \
            lookup_bind_dn="cn=miniolookupuser,dc=example,dc=net" \
            lookup_bind_dn_password="userpassword"                \
            user_dn_search_base_dn="dc=example,dc=net"            \
            user_dn_search_filter="(&(objectCategory=user)(sAMAccountName=%s))"

Settings
~~~~~~~~

Server Address
++++++++++++++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_SERVER_ADDR
      
      
         .. include:: /includes/common-minio-external-auth.rst
            :start-after: start-minio-ad-ldap-server-addr
            :end-before: end-minio-ad-ldap-server-addr
      
   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: server_addr
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-server-addr
   :end-before: end-minio-ad-ldap-server-addr

Lookup Bind DN
++++++++++++++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: lookup_bind_dn
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-lookup-bind-dn
   :end-before: end-minio-ad-ldap-lookup-bind-dn

Lookup Bind Password
++++++++++++++++++++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD


   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: lookup_bind_password
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-lookup-bind-password
   :end-before: end-minio-ad-ldap-lookup-bind-password
         
User DN Search Base DN
++++++++++++++++++++++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: user_dn_search_base_dn
         :delimiter: " "


.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-user-dn-search-base-dn
   :end-before: end-minio-ad-ldap-user-dn-search-base-dn
         
User DN Search Filter
+++++++++++++++++++++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: user_dn_search_filter
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-user-dn-search-filter
   :end-before: end-minio-ad-ldap-user-dn-search-filter
         
Enabled
+++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      This setting does not have an environment variable option.
      Use the configuration setting instead.

   .. tab-item:: Configuration Setting
      :selected:

      .. mc-conf:: enabled
         :delimiter: " "

Set to ``false`` to disable the AD/LDAP configuration.

If ``false``, applications cannot generate STS credentials or otherwise authenticate to MinIO using the configured provider.

Defaults to ``true`` or "enabled".

Group Search Filter
+++++++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER

   .. tab-item:: Configuration Setting
      :sync: config
   
      .. mc-conf:: group_search_filter
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-group-search-filter
   :end-before: end-minio-ad-ldap-group-search-filter
         
Group Search Base DN
++++++++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: group_search_base_dn
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-group-search-base-dn
   :end-before: end-minio-ad-ldap-group-search-base-dn
         
TLS Skip Verify
+++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_TLS_SKIP_VERIFY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: tls_skip_verify
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-tls-skip-verify
   :end-before: end-minio-ad-ldap-tls-skip-verify

Server Insecure
+++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_SERVER_INSECURE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: server_insecure
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-server-insecure
   :end-before: end-minio-ad-ldap-server-insecure

Server Start TLS
++++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_SERVER_STARTTLS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: server_starttls
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-server-starttls
   :end-before: end-minio-ad-ldap-server-starttls

SRV Record Name
+++++++++++++++

*Optional*

.. versionadded:: RELEASE.2022-12-12T19-27-27Z

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_SRV_RECORD_NAME

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: srv_record_name
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-srv_record_name
   :end-before: end-minio-ad-ldap-srv_record_name

Comment
+++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_COMMENT
      
   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_ldap comment
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-comment
   :end-before: end-minio-ad-ldap-comment
      
  
.. _minio-server-envvar-external-identity-management-openid:
.. _minio-open-id-config-settings:

OpenID Identity Management
--------------------------

The following section documents settings for enabling external identity management using an OpenID Connect (OIDC)-compatible provider. 
See :ref:`minio-external-identity-management-openid` for a tutorial on using these settings.

Examples
~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell
         :class: copyable

         MINIO_IDENTITY_OPENID_CONFIG_URL="https://openid-provider.example.net/.well-known/openid-configuration"

   .. tab-item:: Configuration Settings
      :sync: config

      Use :mc-cmd:`mc admin config set` to set or update the OpenID configuration.
      The :mc-conf:`~identity_openid.config_url` argument is *required*. 
      Specify additional optional arguments as a whitespace (``" "``)-delimited list.

      .. code-block:: shell
         :class: copyable

         mc admin config set identity_openid                                               \
           config_url="https://openid-provider.example.net/.well-known/openid-configuration" \
           [ARGUMENT="VALUE"] ... 

Settings
~~~~~~~~

Config URL
++++++++++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_CONFIG_URL

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid config_url
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-config-url
   :end-before: end-minio-openid-config-url

Enabled
+++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      This setting does not have an environment variable option.
      Use the Configuration Setting instead.

   .. tab-item:: Configuration Setting
      :selected:

      .. mc-conf:: identity_openid enabled
         :delimiter: " "


Set to ``false`` to disable the OpenID configuration.

Applications cannot generate STS credentials or otherwise authenticate to MinIO using the configured provider if set to ``false``.

Defaults to ``true`` or "enabled".

Client ID
+++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_CLIENT_ID

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid client_id
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-client-id
   :end-before: end-minio-openid-client-id

Client Secret
+++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar
      
      .. envvar:: MINIO_IDENTITY_OPENID_CLIENT_SECRET

   .. tab-item:: Configuration Setting
      :sync: config
      
      .. mc-conf:: identity_openid client_secret
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-client-secret
   :end-before: end-minio-openid-client-secret

Role Policy
+++++++++++

*Optional*

This setting is mutually exclusive with the ``Claim Name`` setting.

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_ROLE_POLICY

   .. tab-item:: Configuration Setting

      .. mc-conf:: identity_openid role_policy
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-role-policy
   :end-before: end-minio-openid-role-policy

Claim Name
++++++++++

*Optional*

This setting is mutually exclusive with the ``Role Policy`` setting.

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_CLAIM_NAME

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid claim_name
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-claim-name
   :end-before: end-minio-openid-claim-name

Claim Prefix
++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar
      
      .. envvar:: MINIO_IDENTITY_OPENID_CLAIM_PREFIX

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid claim_prefix
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-claim-prefix
   :end-before: end-minio-openid-claim-prefix

Display Name
++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_DISPLAY_NAME

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid display_name
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-display-name
   :end-before: end-minio-openid-display-name

Scopes
++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_SCOPES

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid scopes
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-scopes
   :end-before: end-minio-openid-scopes

Redirect URI
++++++++++++

*Optional*

.. tab-set:: 

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_REDIRECT_URI

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid redirect_uri
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-redirect-uri
   :end-before: end-minio-openid-redirect-uri

Dynamic URI Redirect
++++++++++++++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_REDIRECT_URI_DYNAMIC

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid redirect_uri_dynamic
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-redirect-uri-dynamic
   :end-before: end-minio-openid-redirect-uri-dynamic

User Info
+++++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_CLAIM_USERINFO

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid claim_userinfo
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-claim-userinfo
   :end-before: end-minio-openid-claim-userinfo

Vendor
++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_VENDOR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid vendor
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-vendor
   :end-before: end-minio-openid-vendor

Keycloak Realm
++++++++++++++

*Optional*

This setting requires that the ``OpenID Vendor`` setting be defined as ``keycloak``.

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_KEYCLOAK_REALM

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid keycloak_realm
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-keycloak-realm
   :end-before: end-minio-openid-keycloak-realm

Keycloak Admin URL
++++++++++++++++++

*Optional*

This setting requires that the ``OpenID Vendor`` setting be defined as ``keycloak``.

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_KEYCLOAK_ADMIN_URL

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid keycloak_admin_url
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-keycloak-admin-url
   :end-before: end-minio-openid-keycloak-admin-url

Comment
+++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_OPENID_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_openid comment
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-openid-comment
   :end-before: end-minio-openid-comm


MinIO Identity Management Plugin
--------------------------------

When setting up the MinIO Identity Management Plugin, you must define at a minimum all of the *required* settings.
The examples here represent the minimum required settings.

See :ref:`minio-external-identity-management-plugin` for a tutorial on using these settings.

Examples
~~~~~~~~

.. tab-set::
   
   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell
   
         MINIO_IDENTITY_PLUGIN_URL="https://authservice.example.net:8080/auth"
         MINIO_IDENTITY_PLUGIN_ROLE_POLICY="ConsoleUser"

   .. tab-item:: Configuration Settings
      :sync: config

      Use :mc:`mc admin config set` to create or update the OpenID configuration. 
      The :mc-conf:`identity_plugin config_url` argument is required. 
      Specify additional optional arguments as a whitespace (" ")-delimited list.

      .. code-block:: shell

         mc admin config set identity_plugin                  \
            url="https://external-auth.example.net:8080/auth" \
            role_policy="consoleAdmin"                        \
            [ARGUMENT=VALUE] ... 

Settings
~~~~~~~~

URL
+++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_PLUGIN_URL
   
   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_plugin url
         :delimiter: " "
      
.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-identity-management-plugin-url
   :end-before: end-minio-identity-management-plugin-url

Role Policy
+++++++++++

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_PLUGIN_ROLE_POLICY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_plugin role_policy
         :delimiter: " "
   
.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-identity-management-role-policy
   :end-before: end-minio-identity-management-role-policy

Enable
++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      
      This setting does not have an environment variable option.

   .. tab-item:: Configuration Setting
      :selected:

      .. mc-conf:: identity_plugin enabled
         :delimiter: " "

Set to ``false`` to disable the identity provider configuration.

Applications cannot generate STS credentials or otherwise authenticate to MinIO using the configured provider if set to ``false``.

Defaults to ``true`` or "enabled".

Token
+++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_PLUGIN_TOKEN

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_plugin token
         :delimiter: " "


.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-identity-management-auth-token
   :end-before: end-minio-identity-management-auth-token

Role ID
+++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_PLUGIN_ROLE_ID

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_plugin role_id
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-identity-management-role-id
   :end-before: end-minio-identity-management-role-id

Comment
+++++++

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_PLUGIN_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_plugin comment
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-identity-management-comment
   :end-before: end-minio-identity-management-comment