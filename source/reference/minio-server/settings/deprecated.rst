.. _minio-server-envvar-deprecated:

===================
Deprecated Settings
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page covers deprecated settings that control core behavior of the MinIO process. 

Settings on this page may be removed at any time.
Users should migrate to the recommended replacement at the earliest opportunity.

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

Environment Variables
---------------------

The following *environment variables* are deprecated.
They are listed here for historical reference only.

.. envvar:: MINIO_SECRET_KEY

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   The secret key for the :ref:`root <minio-users-root>` user.

   This environment variable is *deprecated* in favor of the :envvar:`MINIO_ROOT_PASSWORD` environment variable.

   .. warning::

      If :envvar:`MINIO_SECRET_KEY` is unset, :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments.
      MinIO strongly recommends specifying a unique, long, and random :envvar:`MINIO_ACCESS_KEY` value for all environments.

.. envvar:: MINIO_ACCESS_KEY

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   The access key for the :ref:`root <minio-users-root>` user.

         This environment variable is *deprecated* in favor of the :envvar:`MINIO_ROOT_USER` environment variable.

   .. warning::

      If :envvar:`MINIO_ACCESS_KEY` is unset, :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments.
      MinIO strongly recommends specifying a unique, long, and random :envvar:`MINIO_ACCESS_KEY` value for all environments.

.. envvar:: MINIO_ACCESS_KEY_OLD

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   To perform root credential rotation, modify the :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD` environment variables.

.. envvar:: MINIO_SECRET_KEY_OLD

   .. deprecated:: RELEASE.2021-04-22T15-44-28Z

   To perform root credential rotation, modify the :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD` environment variables.