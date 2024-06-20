.. Descriptions for External Identity Management using an LDAP Provider   
   Used in the following files:                                                                
   - /source/reference/minio-mc/mc-idp-ldap-add.rst
   - /source/reference/minio-mc/mc-idp-ldap-update.rst

   Does not include ALIAS, as the example differs between add and update

.. start-minio-ad-ldap-params

.. mc-cmd:: server_addr
   :required:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-server-addr
      :end-before: end-minio-ad-ldap-server-addr

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SERVER_ADDR` environment variable.

.. mc-cmd:: lookup_bind_dn
   :required:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-lookup-bind-dn
      :end-before: end-minio-ad-ldap-lookup-bind-dn

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN` environment variable.

.. mc-cmd:: lookup_bind_password
   :required:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-lookup-bind-password
      :end-before: end-minio-ad-ldap-lookup-bind-password

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD` environment variable.

.. mc-cmd:: user_dn_attributes
   :optional:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-user-dn-attributes
      :end-before: end-minio-ad-ldap-user-dn-attributes

.. mc-cmd:: user_dn_search_base_dn
   :required:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-user-dn-search-base-dn
      :end-before: end-minio-ad-ldap-user-dn-search-base-dn

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN` environment variable.

.. mc-cmd:: user_dn_search_filter
   :required:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-user-dn-search-filter
      :end-before: end-minio-ad-ldap-user-dn-search-filter

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER` environment variable.

.. mc-cmd:: comment
   :optional:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-comment
      :end-before: end-minio-ad-ldap-comment

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_COMMENT` environment variable.

.. mc-cmd:: enabled
   :optional:

   Set to ``false`` to disable the AD/LDAP configuration.

   If ``false``, applications cannot generate STS credentials or otherwise authenticate to MinIO using the configured provider.

   Defaults to ``true`` or "enabled".

.. mc-cmd:: group_search_base_dn
   :optional:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-group-search-base-dn
      :end-before: end-minio-ad-ldap-group-search-base-dn

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN` environment variable.

.. mc-cmd:: group_search_filter
   :optional:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-group-search-filter
      :end-before: end-minio-ad-ldap-group-search-filter

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER` environment variable.

.. mc-cmd:: server_insecure
   :optional:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-server-insecure
      :end-before: end-minio-ad-ldap-server-insecure

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SERVER_INSECURE` environment variable.

.. mc-cmd:: server_starttls
   :optional:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-server-starttls
      :end-before: end-minio-ad-ldap-server-starttls

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SERVER_STARTTLS` environment variable.

.. mc-cmd:: srv_record_name
   :optional:

   .. versionadded:: RELEASE.2022-12-12T19-27-27Z

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-srv_record_name
      :end-before: end-minio-ad-ldap-srv_record_name

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_SRV_RECORD_NAME` environment variable.

.. mc-cmd:: tls_skip_verify
   :optional:

   .. include:: /includes/common-minio-external-auth.rst
      :start-after: start-minio-ad-ldap-tls-skip-verify
      :end-before: end-minio-ad-ldap-tls-skip-verify

   This parameter corresponds with the :envvar:`MINIO_IDENTITY_LDAP_TLS_SKIP_VERIFY` environment variable.

.. end-minio-ad-ldap-params

.. Descriptions for adding LDAP access keys
   Used in the following files:                                                                
   - /source/reference/minio-mc/mc-idp-ldap-accesskey.rst
   - /source/reference/minio-mc/mc-idp-ldap-accesskey-info.rst
   - /source/reference/minio-mc/mc-idp-ldap-accesskey-rm.rst
   - /source/reference/minio-mc/mc-idp-ldap-accesskey-ls.rst

.. start-minio-ad-ldap-accesskey-creation

This command works against :ref:`access keys <minio-id-access-keys>` created by an AD/LDAP user after authenticating to MinIO.

Create AD/LDAP service accounts with the :mc-cmd:`mc idp ldap accesskey create` command.

Authenticated users can manage their own long-term Access Keys using the :ref:`MinIO Console <minio-console-user-access-keys>`.
MinIO supports using :ref:`AssumeRoleWithLDAPIdentity <minio-sts-assumerolewithldapidentity>` to generate temporary access keys using the :ref:`Security Token Service <minio-security-token-service>`.

.. end-minio-ad-ldap-accesskey-creation