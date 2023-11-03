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

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Environment Variable File Path
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_CONFIG_ENV_FILE
      
         Specifies the full path to the file the MinIO server process uses for loading environment variables.
         
         For ``systemd``-managed files, set this value to the path of the environment file (``/etc/default/minio``) to direct MinIO to reload changes to that file when using :mc-cmd:`mc admin service restart` to restart the deployment.

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option
      
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

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Domain
~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_DOMAIN

         Set to the Fully Qualified Domain Name (FQDN) MinIO accepts Bucket DNS (Virtual Host)-style requests on.

         For example, setting ``MINIO_DOMAIN=minio.example.net`` directs MinIO to accept an incoming connection request to the ``data`` bucket at ``data.minio.example.net``.

         If this setting is omitted, the default is to only accept path-style requests. For example, ``minio.example.net/data``.

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

.. _minio-scanner-speed-options:

Scanner Speed
~~~~~~~~~~~~~

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

Batch Replication
-----------------

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_BATCH_REPLICATION_WORKERS

         *Optional*

         Specifying the maximum number of parallel processes to use when performing the batch application job.

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option


Data Compression
----------------

The following section documents settings for enabling data compression for objects.
See :ref:`minio-data-compression` for tutorials on using these configuration settings.

All of the settings in this section fall under the following top-level key:

.. mc-conf:: compression

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

Set to ``on`` to encrypt objects after compressing them.
Defaults to ``off``.

.. admonition:: Encrypting compressed objects may compromise security
   :class: warning

   MinIO strongly recommends against encrypting compressed objects.
   If you require encryption, carefully evaluate the risk of potentially leaking information about the contents of encrypted objects.

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

Set to ``on`` to enable data compression for new objects.
Defaults to ``off``.

Enabling or disabling data compression does not change existing objects.

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

Specify a comment to associate with the data compression configuration.

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

Comma-separated list of the file extensions to compress.
Setting a new list of file extensions replaces the previously configured list.
Defaults to ``".txt, .log, .csv, .json, .tar, .xml, .bin"``.

.. admonition:: Default excluded files
   :class: note

   Some types of files cannot be significantly reduced in size.
   MinIO will *not* compress these, even if specified in an :mc-conf:`~compression.extensions` argument.
   See :ref:`Excluded types <minio-data-compression-excluded-types>` for details.

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

Comma-separated list of the MIME types to compress.
Setting	a new list of types replaces the previously configured list.
Defaults to ``"text/*, application/json, application/xml, binary/octet-stream"``.

.. admonition:: Default excluded files
   :class: note

   Some	types of files cannot be significantly reduced in size.
   MinIO will *not* compress these, even if specified in an :mc-conf:`~compression.mime_types` argument.
   See :ref:`Excluded types <minio-data-compression-excluded-types>` for details.
