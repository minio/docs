.. _minio-server-envvar-root:

===============
`root` Settings
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page covers settings that control root access for the MinIO process. 

You can define settings by defining 

- an *environment variable* prior to starting or restarting the MinIO Server.
- a *configuration setting* using :mc:`mc admin config set`.
- a *configuration setting* using the :ref:`MinIO Console's <minio-console-settings>` :guilabel:`Administrator > Settings` pages.
  
If you define both an environment variable and the similar configuration setting, MinIO uses the environment variable value.

Some settings can only be defined by either an environment variable or by a configuration setting.

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

.. versionadded:: MinIO Server RELEASE.2023-05-04T21-44-30Z

Specify ``on`` to enable and ``off`` to disable the :ref:`root <minio-users-root>` user account.
Disabling the root service account also disables all service accounts associated with root, excluding those used by site replication.
Defaults to ``on``.

Ensure you have at least one other admin user, such as one with the :userpolicy:`consoleAdmin` policy, before disabling the root account.
If you do not have another admin user, disabling the root account locks administrative access to the deployment.

You can use this variable to temporarily override the configuration setting and re-enable root access to the deployment.

To reset after an unintentional lock, set :envvar:`MINIO_API_ROOT_ACCESS` ``on`` to override this setting and temporarily re-enable the root account.
You can then change this setting to ``on`` *or* make the necessary user/policy changes to ensure normal administrative access through other non-root accounts.
