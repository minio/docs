.. _minio-server-envvar-iam:

===========================================
Settings for Identity and Access Management
===========================================

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

Active Directory / LDAP Identity Management
-------------------------------------------

Environment Variables
~~~~~~~~~~~~~~~~~~~~~

The following section documents environment variables for enabling external identity management using an Active Directory or LDAP service.
See :ref:`minio-authenticate-using-ad-ldap-generic` for a tutorial on using these variables.

.. envvar:: MINIO_IDENTITY_LDAP_SERVER_ADDR

   *Required*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-server-addr
      :end-before: end-minio-ad-ldap-server-addr

   This environment variable corresponds with the :mc-cmd:`mc idp ldap add server_addr` parameter.

.. envvar:: MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN

   *Required*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-lookup-bind-dn
      :end-before: end-minio-ad-ldap-lookup-bind-dn

   This environment variable corresponds with the :mc-cmd:`mc idp ldap add lookup_bind_dn` parameter.

.. envvar:: MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-lookup-bind-password
      :end-before: end-minio-ad-ldap-lookup-bind-password
      
   This environment variable corresponds with the :mc-cmd:`~mc idp ldap add lookup_bind_password` parameter.

.. envvar:: MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-user-dn-search-base-dn
      :end-before: end-minio-ad-ldap-user-dn-search-base-dn
      
   This environment variable corresponds with the :mc-cmd:`~mc idp ldap add user_dn_search_base_dn` parameter.

.. envvar:: MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-user-dn-search-filter
      :end-before: end-minio-ad-ldap-user-dn-search-filter
      
   This environment variable corresponds with the :mc-cmd:`~mc idp ldap add user_dn_search_filter` parameter.

.. envvar:: MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-group-search-filter
      :end-before: end-minio-ad-ldap-group-search-filter
      
   This environment variable corresponds with the :mc-cmd:`~mc idp ldap add group_search_filter` parameter.

.. envvar:: MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-group-search-base-dn
      :end-before: end-minio-ad-ldap-group-search-base-dn
      
   This environment variable corresponds with the :mc-cmd:`~mc idp ldap add group_search_base_dn` parameter.

.. envvar:: MINIO_IDENTITY_LDAP_TLS_SKIP_VERIFY

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-tls-skip-verify
      :end-before: end-minio-ad-ldap-tls-skip-verify

   This environment variable corresponds with the :mc-cmd:`~mc idp ldap add tls_skip_verify` parameter.

.. envvar:: MINIO_IDENTITY_LDAP_SERVER_INSECURE

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-server-insecure
      :end-before: end-minio-ad-ldap-server-insecure

   This environment variable corresponds with the :mc-cmd:`~mc idp ldap add server_insecure` parameter.

.. envvar:: MINIO_IDENTITY_LDAP_SERVER_STARTTLS

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-server-starttls
      :end-before: end-minio-ad-ldap-server-starttls

   This environment variable corresponds with the :mc-cmd:`~mc idp ldap add server_starttls` parameter.

.. envvar:: MINIO_IDENTITY_LDAP_SRV_RECORD_NAME

   .. versionadded:: RELEASE.2022-12-12T19-27-27Z

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-srv_record_name
      :end-before: end-minio-ad-ldap-srv_record_name

   This environment variable corresponds with the :mc-cmd:`~mc idp ldap add srv_record_name` parameter.

.. envvar:: MINIO_IDENTITY_LDAP_COMMENT

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-comment
      :end-before: end-minio-ad-ldap-comment

   This environment variable corresponds with the :mc-cmd:`~mc idp ldap add comment` parameter.

.. _minio-ldap-config-settings:

Configuration Values
~~~~~~~~~~~~~~~~~~~~

The following section documents settings for enabling external identity management using an Active Directory or LDAP service using :mc:`mc admin config`.

.. admonition:: :mc:`mc idp ldap` commands are preferred
   :class: note

   .. versionadded:: RELEASE.2023-05-26T23-31-54Z

      MinIO recommends using the :mc:`mc idp ldap` commands for LDAP management operations.
      These commands offer better validation and additional features, while providing the same settings as the :mc-conf:`identity_ldap` configuration key.
      See :ref:`minio-authenticate-using-ad-ldap-generic` for a tutorial on using :mc:`mc idp ldap`.

      The :mc-conf:`identity_ldap` configuration key remains available for existing scripts and other tools.

.. mc-conf:: identity_ldap

   The top-level key for configuring
   :ref:`external identity management using Active Directory or LDAP 
   <minio-external-identity-management-ad-ldap>`.

   Use the :mc-cmd:`mc admin config set` command to set or update the 
   AD/LDAP configuration. The following arguments are *required*:

   - :mc-conf:`~identity_ldap.server_addr`
   - :mc-conf:`~identity_ldap.lookup_bind_dn`
   - :mc-conf:`~identity_ldap.lookup_bind_password`
   - :mc-conf:`~identity_ldap.user_dn_search_base_dn`
   - :mc-conf:`~identity_ldap.user_dn_search_filter`

   .. code-block:: shell
      :class: copyable

      mc admin config set identity_ldap \
         enabled="true" \
         server_addr="ad-ldap.example.net/" \
         lookup_bind_dn="cn=miniolookupuser,dc=example,dc=net" \
         lookup_bind_dn_password="userpassword" \
         user_dn_search_base_dn="dc=example,dc=net" \
         user_dn_search_filter="(&(objectCategory=user)(sAMAccountName=%s))"

   The :mc-conf:`identity_ldap` configuration key supports the following
   arguments:

   .. mc-conf:: server_addr
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-server-addr
         :end-before: end-minio-ad-ldap-server-addr

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SERVER_ADDR` environment variable.

   .. mc-conf:: lookup_bind_dn
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-lookup-bind-dn
         :end-before: end-minio-ad-ldap-lookup-bind-dn

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN` environment variable.

   .. mc-conf:: lookup_bind_password
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-lookup-bind-password
         :end-before: end-minio-ad-ldap-lookup-bind-password
         
      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD` environment variable.

   .. mc-conf:: user_dn_search_base_dn
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-user-dn-search-base-dn
         :end-before: end-minio-ad-ldap-user-dn-search-base-dn
         
      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN` environment variable.

   .. mc-conf:: user_dn_search_filter
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-user-dn-search-filter
         :end-before: end-minio-ad-ldap-user-dn-search-filter
         
      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER` environment variable.

   .. mc-conf:: enabled
      :delimiter: " "

      *Optional*

      Set to ``false`` to disable the AD/LDAP configuration.

      If ``false``, applications cannot generate STS credentials or otherwise authenticate to MinIO using the configured provider.

      Defaults to ``true`` or "enabled".

   .. mc-conf:: group_search_filter
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-group-search-filter
         :end-before: end-minio-ad-ldap-group-search-filter
         
      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER` environment variable.

   .. mc-conf:: group_search_base_dn
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-group-search-base-dn
         :end-before: end-minio-ad-ldap-group-search-base-dn
         
      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN` environment variable.

   .. mc-conf:: tls_skip_verify
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-tls-skip-verify
         :end-before: end-minio-ad-ldap-tls-skip-verify

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_TLS_SKIP_VERIFY` environment variable.

   .. mc-conf:: server_insecure
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-server-insecure
         :end-before: end-minio-ad-ldap-server-insecure

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SERVER_INSECURE` environment variable.

   .. mc-conf:: server_starttls
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-server-starttls
         :end-before: end-minio-ad-ldap-server-starttls

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SERVER_STARTTLS` environment variable.

   .. mc-conf:: srv_record_name
      :delimiter: " "

      .. versionadded:: RELEASE.2022-12-12T19-27-27Z

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-srv_record_name
         :end-before: end-minio-ad-ldap-srv_record_name

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SRV_RECORD_NAME` environment variable.

   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-ad-ldap-comment
         :end-before: end-minio-ad-ldap-comment

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_LDAP_COMMENT` environment variable.   
   
.. _minio-server-envvar-external-identity-management-openid:

OpenID Identity Management
--------------------------

Environment Variables
~~~~~~~~~~~~~~~~~~~~~

The following section documents environment variables for enabling external identity management using an OpenID Connect (OIDC)-compatible provider. 
See :ref:`minio-external-identity-management-openid` for a tutorial on using these variables.

.. envvar:: MINIO_IDENTITY_OPENID_CONFIG_URL

   *Required*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-config-url
      :end-before: end-minio-openid-config-url
   
   This environment variable corresponds with the :mc-conf:`identity_openid config_url <identity_openid.config_url>` configuration setting.

.. envvar:: MINIO_IDENTITY_OPENID_CLIENT_ID

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-client-id
      :end-before: end-minio-openid-client-id
   
   This environment variable corresponds with the :mc-conf:`identity_openid client_id <identity_openid.client_id>` configuration setting.

.. envvar:: MINIO_IDENTITY_OPENID_CLIENT_SECRET

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-client-secret
      :end-before: end-minio-openid-client-secret
   
   This environment variable corresponds with the :mc-conf:`identity_openid client_secret <identity_openid.client_secret>` configuration setting.

.. envvar:: MINIO_IDENTITY_OPENID_ROLE_POLICY

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-role-policy
      :end-before: end-minio-openid-role-policy
   
   This environment variable corresponds with the :mc-conf:`identity_openid role_policy <identity_openid.role_policy>` configuration setting.
   This variable is mutually exclusive with the :envvar:`MINIO_IDENTITY_OPENID_CLAIM_NAME` environment variable.

.. envvar:: MINIO_IDENTITY_OPENID_CLAIM_NAME

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-claim-name
      :end-before: end-minio-openid-claim-name
   
   This environment variable corresponds with the :mc-conf:`identity_openid claim_name <identity_openid.claim_name>` configuration setting.
   This variable is mutually exclusive with the :envvar:`MINIO_IDENTITY_OPENID_ROLE_POLICY` environment variable.


.. envvar:: MINIO_IDENTITY_OPENID_CLAIM_PREFIX

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-claim-prefix
      :end-before: end-minio-openid-claim-prefix
   
   This environment variable corresponds with the :mc-conf:`identity_openid claim_prefix <identity_openid.claim_prefix>` configuration setting.

.. envvar:: MINIO_IDENTITY_OPENID_DISPLAY_NAME

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-display-name
      :end-before: end-minio-openid-display-name

.. envvar:: MINIO_IDENTITY_OPENID_SCOPES

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-scopes
      :end-before: end-minio-openid-scopes
   
   This environment variable corresponds with the :mc-conf:`identity_openid scopes <identity_openid.scopes>` configuration setting.

.. envvar:: MINIO_IDENTITY_OPENID_REDIRECT_URI

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-redirect-uri
      :end-before: end-minio-openid-redirect-uri

   This environment variable corresponds with the :mc-conf:`identity_openid redirect_uri <identity_openid.redirect_uri>` configuration setting.

.. envvar:: MINIO_IDENTITY_OPENID_REDIRECT_URI_DYNAMIC

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-redirect-uri-dynamic
      :end-before: end-minio-openid-redirect-uri-dynamic

   This environment variable corresponds with the :mc-conf:`identity_openid redirect_uri_dynamic <identity_openid.redirect_uri_dynamic>` configuration setting.
   
.. envvar:: MINIO_IDENTITY_OPENID_CLAIM_USERINFO

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-claim-userinfo
      :end-before: end-minio-openid-claim-userinfo

   This environment variable corresponds with the :mc-conf:`identity_openid claim_userinfo <identity_openid.claim_userinfo>` configuration setting.

.. envvar:: MINIO_IDENTITY_OPENID_VENDOR

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-vendor
      :end-before: end-minio-openid-vendor

   This environment variable corresponds with the :mc-conf:`identity_openid vendor <identity_openid.vendor>` configuration setting.

.. envvar:: MINIO_IDENTITY_OPENID_KEYCLOAK_REALM

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-keycloak-realm
      :end-before: end-minio-openid-keycloak-realm

   This environment variable corresponds with the :mc-conf:`identity_openid keycloak_realm <identity_openid.keycloak_realm>` configuration setting.

   Requires :envvar:`MINIO_IDENTITY_OPENID_VENDOR` set to ``keycloak``.

.. envvar:: MINIO_IDENTITY_OPENID_KEYCLOAK_ADMIN_URL

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-keycloak-admin-url
      :end-before: end-minio-openid-keycloak-admin-url

   This environment variable corresponds with the :mc-conf:`identity_openid keycloak_admin_url <identity_openid.keycloak_admin_url>` configuration setting.

   Requires :envvar:`MINIO_IDENTITY_OPENID_VENDOR` set to ``keycloak``.


.. envvar:: MINIO_IDENTITY_OPENID_COMMENT

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-openid-comment
      :end-before: end-minio-openid-comment
   
   This environment variable corresponds with the :mc-conf:`identity_openid comment <identity_openid.comment>` configuration setting.

.. _minio-open-id-config-settings:

Configuration Values
~~~~~~~~~~~~~~~~~~~~

The following section documents settings for enabling external identity
management using an OpenID Connect (OIDC)-compatible provider. 
See :ref:`minio-external-identity-management-openid` for a tutorial on using these
configuration settings.

.. mc-conf:: identity_openid

   The top-level configuration key for configuring
   :ref:`external identity management using OpenID <minio-external-identity-management-openid>`.

   Use :mc-cmd:`mc admin config set` to set or update the OpenID configuration.
   The :mc-conf:`~identity_openid.config_url` argument is *required*. Specify
   additional optional arguments as a whitespace (``" "``)-delimited list.

   .. code-block:: shell
      :class: copyable

      mc admin config set identity_openid \ 
        config_url="https://openid-provider.example.net/.well-known/openid-configuration"
        [ARGUMENT="VALUE"] ... \

   The :mc-conf:`identity_openid` configuration key supports the following 
   arguments:

   .. mc-conf:: config_url
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-config-url
         :end-before: end-minio-openid-config-url

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CONFIG_URL` environment variable.

   .. mc-conf:: enabled
      :delimiter: " "

      *Optional*

      Set to ``false`` to disable the OpenID configuration.

      Applications cannot generate STS credentials or otherwise authenticate to MinIO using the configured provider if set to ``false``.

      Defaults to ``true`` or "enabled".

   .. mc-conf:: client_id
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-client-id
         :end-before: end-minio-openid-client-id

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CLIENT_ID` environment variable.

   .. mc-conf:: client_secret
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-client-secret
         :end-before: end-minio-openid-client-secret

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CLIENT_SECRET` environment variable.
      
   .. mc-conf:: role_policy
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-role-policy
         :end-before: end-minio-openid-role-policy

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_ROLE_POLICY` environment variable.
      This setting is mutually exclusive with the :mc-conf:`identity_openid claim_name <identity_openid.claim_name>` configuration setting.
   
   .. mc-conf:: claim_name
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-claim-name
         :end-before: end-minio-openid-claim-name

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CLAIM_NAME` environment variable.
      This setting is mutually exclusive with the :mc-conf:`identity_openid role_policy <identity_openid.role_policy>` configuration setting.

   .. mc-conf:: claim_prefix
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-claim-prefix
         :end-before: end-minio-openid-claim-prefix

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CLAIM_PREFIX` environment variable.

   .. mc-conf:: display_name
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-display-name
         :end-before: end-minio-openid-display-name

   .. mc-conf:: scopes
      :delimiter: " "

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-scopes
         :end-before: end-minio-openid-scopes

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_SCOPES` environment variable.
      
   .. mc-conf:: redirect_uri
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-redirect-uri
         :end-before: end-minio-openid-redirect-uri

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_REDIRECT_URI` environment variable.

   .. mc-conf:: redirect_uri_dynamic
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-redirect-uri-dynamic
         :end-before: end-minio-openid-redirect-uri-dynamic

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_REDIRECT_URI_DYNAMIC` environment variable.

   .. mc-conf:: claim_userinfo
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-claim-userinfo
         :end-before: end-minio-openid-claim-userinfo

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_CLAIM_USERINFO` environment variable.

   .. mc-conf:: vendor
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-vendor
         :end-before: end-minio-openid-vendor

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_VENDOR` environment variable.

   .. mc-conf:: keycloak_realm
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-keycloak-realm
         :end-before: end-minio-openid-keycloak-realm

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_KEYCLOAK_REALM` environment variable.

      Requires :mc-conf:`identity_openid.vendor` set to ``keycloak``.

   .. mc-conf:: keycloak_admin_url
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-keycloak-admin-url
         :end-before: end-minio-openid-keycloak-admin-url

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_KEYCLOAK_ADMIN_URL` environment variable.

      Requires :mc-conf:`identity_openid.vendor` set to ``keycloak``.


   .. mc-conf:: comment
      :delimiter: " "

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-openid-comment
         :end-before: end-minio-openid-comment

      This configuration setting corresponds with the :envvar:`MINIO_IDENTITY_OPENID_COMMENT` environment variable.

.. _minio-server-envvar-external-identity-management-plugin:

MinIO Identity Management Plugin
--------------------------------

Environment Variables
~~~~~~~~~~~~~~~~~~~~~

.. envvar:: MINIO_IDENTITY_PLUGIN_URL
   
   *Required*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-identity-management-plugin-url
      :end-before: end-minio-identity-management-plugin-url

.. envvar:: MINIO_IDENTITY_PLUGIN_ROLE_POLICY

   *Required*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-identity-management-role-policy
      :end-before: end-minio-identity-management-role-policy

.. envvar:: MINIO_IDENTITY_PLUGIN_TOKEN

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-identity-management-auth-token
      :end-before: end-minio-identity-management-auth-token

.. envvar:: MINIO_IDENTITY_PLUGIN_ROLE_ID

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-identity-management-role-id
      :end-before: end-minio-identity-management-role-id

.. envvar:: MINIO_IDENTITY_PLUGIN_COMMENT

   *Optional*

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-identity-management-comment
      :end-before: end-minio-identity-management-comment

.. _minio-identity-management-plugin-settings:

Configuration Values
~~~~~~~~~~~~~~~~~~~~

The following section documents settings for enabling external identity management using the MinIO Identity Management Plugin with :mc:`mc admin config`.
See :ref:`minio-external-identity-management-plugin` for a tutorial on using these configuration settings.

.. mc-conf:: identity_plugin

   The top-level configuration key for enabling :ref:`minio-external-identity-management-plugin`.

   Use :mc-cmd:`mc admin config set` to set or update the configuration.
   The :mc-conf:`~identity_plugin.url` and :mc-conf:`~identity_plugin.role_policy` arguments are *required*.
   Specify additional optional arguments as a whitespace (``" "``)-delimited list.

   .. code-block:: shell
      :class: copyable

      mc admin config set identity_plugin \
        url="https://external-auth.example.net:8080/auth" \
        role_policy="consoleAdmin" \
        [ARGUMENT=VALUE] ... \

   The :mc-conf:`identity_plugin` configuration key supports the following arguments:

   .. mc-conf:: url
      :delimiter: " "
   
      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-identity-management-plugin-url
         :end-before: end-minio-identity-management-plugin-url


   .. mc-conf:: role_policy
      :delimiter: " "

      *Required*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-identity-management-role-policy
         :end-before: end-minio-identity-management-role-policy

   .. mc-conf:: enabled
      :delimiter: " "

      *Optional*

      Set to ``false`` to disable the identity provider configuration.

      Applications cannot generate STS credentials or otherwise authenticate to MinIO using the configured provider if set to ``false``.

      Defaults to ``true`` or "enabled".

   .. mc-conf:: token
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-identity-management-auth-token
         :end-before: end-minio-identity-management-auth-token

   .. mc-conf:: role_id
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-identity-management-role-id
         :end-before: end-minio-identity-management-role-id

   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-minio-external-auth.rst
         :start-after: start-minio-identity-management-comment
         :end-before: end-minio-identity-management-comment