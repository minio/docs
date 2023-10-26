.. _minio-server-envvar-core:

=============
Core Settings
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page covers settings that control core behavior of the MinIO process. 

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

Common Settings
---------------

Volumes
~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_VOLUMES

         The directories or drives the :mc:`minio server` process uses as the storage backend.

         Functionally equivalent to setting :mc-cmd:`minio server DIRECTORIES`.
         Use this value when configuring MinIO to run using an environment file.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Environment Variable File Path
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_CONFIG_ENV_FILE
      
         Specifies the full path to the file the MinIO server process uses for loading environment variables.
         
         For ``systemd``-managed files, setting this value to the environment file allows MinIO to reload changes to that file on using :mc-cmd:`mc admin service restart` to restart the deployment.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.
      
Workers for Expiration
~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_ILM_EXPIRY_WORKERS

         Specifies the number of workers to make available to expire objects configured with ILM rules for expiration.
         When not set, MinIO defaults to using up to half of the available processing cores available.

   .. tab-item:: Configuration Setting
      :sync: config

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Domain
~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_DOMAIN

         Set to the Fully Qualified Domain Name (FQDN) MinIO accepts Bucket DNS (Virtual Host)-style requests on.

         For example, setting ``MINIO_DOMAIN=minio.example.net`` directs MinIO to accept an incoming connection request the ``data`` bucket at ``data.minio.example.net``.

         If this setting is omitted, the default is to only accept path-style requests. For example, ``minio.example.net/data``.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Scanner Speed
~~~~~~~~~~~~~

.. _minio-scanner-speed-options:

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_SCANNER_SPEED

   .. tab-item:: Configuration Setting
      :sync: config
  
      .. mc-conf:: scanner speed
         :delimiter: " "

Manage the maximum wait period for the scanner when balancing MinIO read/write performance to scanner processes.
   
.. include:: /includes/common/scanner.rst
   :start-after: start-scanner-speed-values
   :end-before: end-scanner-speed-values

This configuration setting corresponds with the :envvar:`MINIO_SCANNER_SPEED` environment variable.

Batch Replication
-----------------

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_BATCH_REPLICATION_WORKERS

         *Optional*

         Enable parallel workers by specifying the maximum number of processes to use when performing the batch application job.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Data Compression
----------------

The following section documents settings for enabling data compression for objects.
See :ref:`minio-data-compression` for tutorials on using these configuration settings.

Allow Encryption
~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_COMPRESSION_ALLOW_ENCRYPTION

   .. tab-item:: Configuration Setting
      :sync: config
  
      .. mc-conf:: compression allow_encryption
         :delimiter: " "

*Optional*

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-data-compression-allow_encryption-desc
   :end-before: end-minio-data-compression-allow_encryption-desc

Enable Compression
~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_COMPRESSION_ENABLE

   .. tab-item:: Configuration Setting
      :sync: config
  
      .. mc-conf:: compression enable
         :delimiter: " "

*Optional*

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-data-compression-enable-desc
   :end-before: end-minio-data-compression-enable-desc

Comments
~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      This setting does not have an environment variable option.
      Use the configuration variable instead.

   .. tab-item:: Configuration Setting
      :selected:

      .. envvar:: compression comment

*Optional*

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-data-compression-comment-desc
   :end-before: end-minio-data-compression-comment-desc

Compression Extensions
~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_COMPRESSION_EXTENSIONS

   .. tab-item:: Configuration Setting
      :sync: config
  
      .. mc-conf:: compression extensions
         :delimiter: " "

*Optional*

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-data-compression-extensions-desc
   :end-before: end-minio-data-compression-extensions-desc

Compression MIME Types
~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_COMPRESSION_MIME_TYPES

   .. tab-item:: Configuration Variable
      :sync: config
  
      .. mc-conf:: compression mime_types
         :delimiter: " "

*Optional*

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-data-compression-mime_types-desc
   :end-before: end-minio-data-compression-mime_types-desc
