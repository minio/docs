.. _minio-server-envvar-external-identity-management-openid:
.. _minio-open-id-config-settings:

===================================
OpenID Identity Management Settings
===================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for enabling external identity management using an OpenID Connect (OIDC)-compatible provider. 
See :ref:`minio-external-identity-management-openid` for a tutorial on using these settings.

Examples
--------

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell
         :class: copyable

         MINIO_IDENTITY_OPENID_CONFIG_URL="https://openid-provider.example.net/.well-known/openid-configuration"

   .. tab-item:: Configuration Settings
      :sync: config

      .. mc-conf:: identity_openid

      Use :mc-cmd:`mc admin config set` to set or update the OpenID configuration.
      The :mc-conf:`~identity_openid.config_url` argument is *required*. 
      Specify additional optional arguments as a whitespace (``" "``)-delimited list.

      .. code-block:: shell
         :class: copyable

         mc admin config set identity_openid                                               \
           config_url="https://openid-provider.example.net/.well-known/openid-configuration" \
           [ARGUMENT="VALUE"] ... 

Settings
--------

Config URL
~~~~~~~~~~

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
~~~~~~~

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
~~~~~~~~~

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
~~~~~~~~~~~~~

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
~~~~~~~~~~~

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
~~~~~~~~~~

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
~~~~~~~~~~~~

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
~~~~~~~~~~~~

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
~~~~~~

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
~~~~~~~~~~~~

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
~~~~~~~~~~~~~~~~~~~~

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
~~~~~~~~~

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
~~~~~~

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
~~~~~~~~~~~~~~

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
~~~~~~~~~~~~~~~~~~

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
~~~~~~~

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