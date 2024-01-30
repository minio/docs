.. _minio-server-envvar-external-identity-management-plugin:

=========================================
MinIO Identity Management Plugin Settings
=========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for enabling external identity management using the MinIO Identity Management Plugin. 
See :ref:`minio-external-identity-management-plugin` for a tutorial on using these settings.

Examples
--------

When setting up the MinIO Identity Management Plugin, you must define at a minimum all of the *required* settings.
The examples here represent the minimum required settings.

.. tab-set::
   
   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell
   
         MINIO_IDENTITY_PLUGIN_URL="https://authservice.example.net:8080/auth"
         MINIO_IDENTITY_PLUGIN_ROLE_POLICY="ConsoleUser"

   .. tab-item:: Configuration Settings
      :sync: config

      .. mc-conf:: identity_plugin

      Use :mc:`mc admin config set` to create or update the identity plugin configuration. 
      The ``identity_plugin url`` argument is required. 
      Specify additional optional arguments as a whitespace (" ")-delimited list.

      .. code-block:: shell

         mc admin config set identity_plugin                  \
            url="https://external-auth.example.net:8080/auth" \
            role_policy="consoleAdmin"                        \
            [ARGUMENT=VALUE] ... 

Settings
--------

URL
~~~

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
~~~~~~~~~~~

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
~~~~~~

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
~~~~~

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
~~~~~~~

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
~~~~~~~

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