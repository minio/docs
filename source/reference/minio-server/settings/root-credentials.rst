.. _minio-server-envvar-root:

===============
`root` Settings
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page covers settings that control root access for the MinIO process. 

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

Root User
---------

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_ROOT_USER

         The access key for the :ref:`root <minio-users-root>` user.

      .. warning::
   
         If :envvar:`MINIO_ROOT_USER` is unset, :mc:`minio` defaults to ``minioadmin``.
   
         **NEVER** use the default credentials in production environments.
         MinIO strongly recommends specifying a unique, long, and random :envvar:`MINIO_ROOT_USER` value for all environments.

   .. tab-item:: Configuration Setting
      :sync: config

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Root Password
-------------

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MINIO_ROOT_PASSWORD

         The secret key for the :ref:`root <minio-users-root>` user.

      .. warning::

         If :envvar:`MINIO_ROOT_PASSWORD` is unset, :mc:`minio` defaults to ``minioadmin``.

         **NEVER** use the default credentials in production environments.
         MinIO strongly recommends specifying a unique, long, and random :envvar:`MINIO_ROOT_PASSWORD` value for all environments.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Root Access
-----------

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_API_ROOT_ACCESS

   .. tab-item:: Configuration Setting
      :sync: config
  
      .. mc-conf:: api root-access
         :delimiter: " "

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-root-api-access
   :end-before: end-minio-root-api-access

You can use this variable to temporarily override the configuration setting and re-enable root access to the deployment.

To reset after an unintentional lock, set :envvar:`MINIO_API_ROOT_ACCESS` ``on`` to override this setting and temporarily re-enable the root account.
You can then change this setting to ``on`` *or* make the necessary user/policy changes to ensure normal administrative access through other non-root accounts.
