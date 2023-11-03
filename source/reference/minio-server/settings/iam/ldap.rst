.. _minio-server-envvar-external-identity-management-ad-ldap:
.. _minio-ldap-config-settings:

================================
Active Directory / LDAP Settings
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for enabling external identity management using an Active Directory or LDAP service.
See :ref:`minio-authenticate-using-ad-ldap-generic` for a tutorial on using these settings.

.. important:: 

   New in version ``RELEASE.2023-05-26T23-31-54Z``: 

   :mc:`mc idp ldap` commands are preferred over using configuration settings to configure MinIO to use Active Directory or LDAP for identity management.

   MinIO recommends using the :mc:`mc idp ldap` commands for LDAP management operations. 
   These commands offer better validation and additional features, while providing the same settings as the ``identity_ldap`` configuration key. 
   See :ref:`minio-authenticate-using-ad-ldap-generic` for a tutorial on using :mc:`mc idp ldap`.

The ``identity_ldap`` configuration settings remains available for existing scripts and other tools.

Examples
--------

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

      .. mc-conf:: identity_ldap
         
      The following settings are required when defining LDAP using :mc:`mc admin config set`:

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
--------

Server Address
~~~~~~~~~~~~~~

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

      .. mc-conf:: identity_ldap server_addr
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-server-addr
   :end-before: end-minio-ad-ldap-server-addr

Lookup Bind DN
~~~~~~~~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_ldap lookup_bind_dn
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-lookup-bind-dn
   :end-before: end-minio-ad-ldap-lookup-bind-dn

Lookup Bind Password
~~~~~~~~~~~~~~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_ldap lookup_bind_password
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-lookup-bind-password
   :end-before: end-minio-ad-ldap-lookup-bind-password
         
User DN Search Base DN
~~~~~~~~~~~~~~~~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_ldap user_dn_search_base_dn
         :delimiter: " "


.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-user-dn-search-base-dn
   :end-before: end-minio-ad-ldap-user-dn-search-base-dn
         
User DN Search Filter
~~~~~~~~~~~~~~~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_ldap user_dn_search_filter
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-user-dn-search-filter
   :end-before: end-minio-ad-ldap-user-dn-search-filter
         
Enabled
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      This setting does not have an environment variable option.
      Use the configuration setting instead.

   .. tab-item:: Configuration Setting
      :selected:

      .. mc-conf:: identity_ldap enabled
         :delimiter: " "

Set to ``false`` to disable the AD/LDAP configuration.

If ``false``, applications cannot generate STS credentials or otherwise authenticate to MinIO using the configured provider.

Defaults to ``true`` or "enabled".

Group Search Filter
~~~~~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER

   .. tab-item:: Configuration Setting
      :sync: config
   
      .. mc-conf:: identity_ldap group_search_filter
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-group-search-filter
   :end-before: end-minio-ad-ldap-group-search-filter
         
Group Search Base DN
~~~~~~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_ldap group_search_base_dn
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-group-search-base-dn
   :end-before: end-minio-ad-ldap-group-search-base-dn
         
TLS Skip Verify
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_TLS_SKIP_VERIFY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_ldap tls_skip_verify
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-tls-skip-verify
   :end-before: end-minio-ad-ldap-tls-skip-verify

Server Insecure
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_SERVER_INSECURE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_ldap server_insecure
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-server-insecure
   :end-before: end-minio-ad-ldap-server-insecure

Server Start TLS
~~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_SERVER_STARTTLS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_ldap server_starttls
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-server-starttls
   :end-before: end-minio-ad-ldap-server-starttls

SRV Record Name
~~~~~~~~~~~~~~~

*Optional*

.. versionadded:: RELEASE.2022-12-12T19-27-27Z

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_SRV_RECORD_NAME

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_ldap srv_record_name
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-srv_record_name
   :end-before: end-minio-ad-ldap-srv_record_name

Comment
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_IDENTITY_LDAP_COMMENT
      
   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: identity_ldap identity_ldap comment
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-ad-ldap-comment
   :end-before: end-minio-ad-ldap-comment