.. _minio-server-envvar-external-access-management-plugin:

=======================================
MinIO Access Management Plugin Settings
=======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents settings for enabling external authorization management using the MinIO Access Management Plugin.
See :ref:`minio-external-access-management-plugin` for a tutorial on using these settings.

Examples
--------

When setting up the MinIO Access Management plugin, you must define at minimum all *required* settings.
The examples here represent the minimum required setting.

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell

         MINIO_POLICY_PLUGIN_URL="https://authzservice.example.net:8080/authz"

   .. tab-item:: Configuration Settings
      :sync: config

      .. mc-conf:: policy_plugin

      Use the :mc:`mc admin config set` command to create or update the access management plugin configuration.
      The ``policy_plugin url`` argument is required.
      Specify additional optional arguments as a whitespace (" ")-delimited list.
      

      .. code-block:: shell

         mc admin config set policy_plugin                     \
            url="https://authzservice.example.net:8080/authz"  \
            [ARGUMENT=VALUE] ...

Settings
--------

URL
~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_POLICY_PLUGIN_URL

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: policy_plugin url
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-access-management-plugin-url
   :end-before: end-minio-access-management-plugin-url

Auth Token
~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_POLICY_PLUGIN_AUTH_TOKEN

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: policy_plugin auth_token
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-access-management-plugin-auth-token
   :end-before: end-minio-access-management-plugin-auth-token

HTTP2
~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_POLICY_PLUGIN_ENABLE_HTTP2

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: policy_plugin enable_http2
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-access-management-plugin-enable-http2
   :end-before: end-minio-access-management-plugin-enable-http2

Comment
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_POLICY_PLUGIN_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: policy_plugin comment
         :delimiter: " "

.. include:: /includes/common-minio-external-auth.rst
   :start-after: start-minio-access-management-plugin-comment
   :end-before: end-minio-access-management-plugin-comment