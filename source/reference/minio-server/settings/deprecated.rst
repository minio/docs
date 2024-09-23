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

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-test-before-prod
   :end-before: end-minio-settings-test-before-prod

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

.. envvar:: MINIO_SERVER_URL

   .. deprecated:: RELEASE.2024-05-10T01-41-38Z

   The `fully qualified domain name <https://en.wikipedia.org/wiki/Fully_qualified_domain_name>`__ (FQDN) the MinIO Console uses for connecting to the MinIO Server.

   For the Console to function correctly, the MinIO server URL *must* be the FQDN of the host, resolveable, and reachable.

   If the specified value does not resolve to the MinIO server, logins via the MinIO Console fail and return a network error after a wait period.
   Older versions of the Console may return a generic 'Invalid Login' error instead.
   Unset the value *or* address the FQDN resolution issue to allow Console logins to proceed.
   This setting may be required if:

   - The MinIO Server uses a TLS certificate that does not include the host local IP(s) in the certificate Subject Alternative Name (SAN).

   or

   - The Console must use a specific hostname to connect or reference the MinIO Server, such as due to a reverse proxy or similar configuration.
