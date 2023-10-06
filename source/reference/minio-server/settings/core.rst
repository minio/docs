.. _minio-server-envvar-core:

=============
Core Settings
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page covers settings that control core behavior of the MinIO process. 

Environment Variables
---------------------

.. envvar:: MINIO_VOLUMES

   The directories or drives the :mc:`minio server` process uses as the storage backend.

   Functionally equivalent to setting :mc-cmd:`minio server DIRECTORIES`.
   Use this value when configuring MinIO to run using an environment file.

.. envvar:: MINIO_CONFIG_ENV_FILE

   Specifies the full path to the file the MinIO server process uses for loading environment variables.
   
   For ``systemd``-managed files, setting this value to the environment file allows MinIO to reload changes to that file on using :mc-cmd:`mc admin service restart` to restart the deployment.

.. envvar:: MINIO_ILM_EXPIRY_WORKERS

   Specifies the number of workers to make available to expire objects configured with ILM rules for expiration.
   When not set, MinIO defaults to using up to half of the available processing cores available.

.. envvar:: MINIO_DOMAIN

   Set to the Fully Qualified Domain Name (FQDN) MinIO accepts Bucket DNS (Virtual Host)-style requests on.

   For example, setting ``MINIO_DOMAIN=minio.example.net`` directs MinIO to accept an incoming connection request the ``data`` bucket at ``data.minio.example.net``.

   If this setting is omitted, the default is to only accept path-style requests. For example, ``minio.example.net/data``.

.. _minio-scanner-speed-options:

.. envvar:: MINIO_SCANNER_SPEED

   Manage the maximum wait period for the scanner when balancing MinIO read/write performance to scanner processes.
   
   .. include:: /includes/common/scanner.rst
      :start-after: start-scanner-speed-values
      :end-before: end-scanner-speed-values

Configuration Settings
----------------------

.. mc-conf:: api

   The top-level configuration key for modifying API-related operations.

   .. mc-conf:: root_access

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-root-api-access
         :end-before: end-minio-root-api-access

      This configuration setting corresponds with the :envvar:`MINIO_API_ROOT_ACCESS` environment variable.
      To reset after an unintentional lock, set :envvar:`MINIO_API_ROOT_ACCESS` ``on`` to override this setting and temporarily re-enable the root account.
      You can then change this setting to ``on`` *or* make the necessary user/policy changes to ensure normal administrative access through other non-root accounts.

.. mc-conf:: scanner

   Configuration settings that affect the scanner process.
   MinIO utilizes the scanner for :ref:`bucket replication <minio-bucket-replication>`, :ref:`site replication <minio-site-replication-overview>`, and :ref:`lifecycle management <minio-lifecycle-management>` tasks.

   .. mc-conf:: speed

      This configuration setting corresponds with the :envvar:`MINIO_SCANNER_SPEED` environment variable.

      .. include:: /includes/common/scanner.rst
         :start-after: start-scanner-speed-values
         :end-before: end-scanner-speed-values

