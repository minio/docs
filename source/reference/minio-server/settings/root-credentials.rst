.. _minio-server-envvar-root:

=============
Root Settings
=============

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

.. envvar:: MINIO_ROOT_USER

   The access key for the :ref:`root <minio-users-root>` user.

   .. warning::

      If :envvar:`MINIO_ROOT_USER` is unset,
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments.
      MinIO strongly recommends specifying a unique, long, and random :envvar:`MINIO_ROOT_USER` value for all environments.

Root Password
-------------

.. envvar:: MINIO_ROOT_PASSWORD

   The secret key for the :ref:`root <minio-users-root>` user.

   .. warning::

      If :envvar:`MINIO_ROOT_PASSWORD` is unset,
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments.
      MinIO strongly recommends specifying a unique, long, and random :envvar:`MINIO_ROOT_PASSWORD` value for all environments.

Root Access
-----------

.. envvar:: MINIO_API_ROOT_ACCESS

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-root-api-access
      :end-before: end-minio-root-api-access

   This environment variable corresponds with the :mc-conf:`api root_access <api.root_access>` configuration setting.
   You can use this variable to temporarily override the configuration setting and re-enable root access to the deployment.

.. mc-conf:: api root-access
   :delimiter: " "

   The top-level configuration key for modifying API-related operations.

   .. mc-conf:: root_access

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-root-api-access
         :end-before: end-minio-root-api-access

      This configuration setting corresponds with the :envvar:`MINIO_API_ROOT_ACCESS` environment variable.
      To reset after an unintentional lock, set :envvar:`MINIO_API_ROOT_ACCESS` ``on`` to override this setting and temporarily re-enable the root account.
      You can then change this setting to ``on`` *or* make the necessary user/policy changes to ensure normal administrative access through other non-root accounts.

Access Key
----------

.. envvar:: MINIO_ACCESS_KEY

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   The access key for the :ref:`root <minio-users-root>` user.

   This environment variable is *deprecated* in favor of the :envvar:`MINIO_ROOT_USER` environment variable.

   .. warning::

      If :envvar:`MINIO_ACCESS_KEY` is unset, :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments.
      MinIO strongly recommends specifying a unique, long, and random :envvar:`MINIO_ACCESS_KEY` value for all environments.

Secret Key
----------

.. envvar:: MINIO_SECRET_KEY

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   The secret key for the :ref:`root <minio-users-root>` user.

   This environment variable is *deprecated* in favor of the :envvar:`MINIO_ROOT_PASSWORD` environment variable.

   .. warning::

      If :envvar:`MINIO_SECRET_KEY` is unset, :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments.
      MinIO strongly recommends specifying a unique, long, and random :envvar:`MINIO_ACCESS_KEY` value for all environments.

Deprecated Settings
-------------------

.. envvar:: MINIO_ACCESS_KEY_OLD

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   To perform root credential rotation, modify the :envvar:`MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD` environment variables.

.. envvar:: MINIO_SECRET_KEY_OLD

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   To perform root credential rotation, modify the :envvar:`MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD` environment variables.