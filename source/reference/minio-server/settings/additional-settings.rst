.. _minio-server-envvar-additional-settings:

===================
Additional Settings
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page covers additional settings that configure other options for the MinIO Server process.

Environment Variables
---------------------

Batch Replication
~~~~~~~~~~~~~~~~~

.. envvar:: MINIO_BATCH_REPLICATION_WORKERS

  *Optional*

  Enable parallel workers by specifying the maximum number of processes to use when performing the batch application job.

Data Compression
~~~~~~~~~~~~~~~~

The following section documents settings for enabling data compression for objects.
See :ref:`minio-data-compression` for tutorials on using these configuration settings.

.. envvar:: MINIO_COMPRESSION_ALLOW_ENCRYPTION

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-data-compression-allow_encryption-desc
      :end-before: end-minio-data-compression-allow_encryption-desc

   This environment variable corresponds with the :mc-conf:`compression allow_encryption <compression.allow_encryption>` configuration setting.

.. envvar:: MINIO_COMPRESSION_ENABLE

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-data-compression-enable-desc
      :end-before: end-minio-data-compression-enable-desc

   This environment variable corresponds with the :mc-conf:`compression enable <compression.enable>` configuration setting.

.. envvar:: MINIO_COMPRESSION_EXTENSIONS

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-data-compression-extensions-desc
      :end-before: end-minio-data-compression-extensions-desc

   This environment variable corresponds with the :mc-conf:`compression extensions <compression.extensions>` configuration setting.

.. envvar:: MINIO_COMPRESSION_MIME_TYPES

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-data-compression-mime_types-desc
      :end-before: end-minio-data-compression-mime_types-desc

   This environment variable corresponds with the :mc-conf:`compression mime_types <compression.mime_types>` configuration setting.

Configuration Values
--------------------

Data Compression
~~~~~~~~~~~~~~~~

The following section documents settings for enabling data compression for objects.
See :ref:`minio-data-compression` for tutorials on using these configuration settings.

.. mc-conf:: compression

   The top-level configuration key for enabling :ref:`minio-data-compression`.

   Use :mc-cmd:`mc admin config set` to set or update the configuration.
   Specify optional arguments as a whitespace (``" "``)-delimited list.

   .. code-block:: shell
      :class: copyable

      mc admin config set compression           \
                          [ARGUMENT=VALUE] ...  \

   Enabling data compression compresses the following types of data by default:

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-data-compression-default-desc
      :end-before: end-minio-data-compression-default-desc

   The :mc-conf:`compression` configuration key supports the following arguments:

   .. mc-conf:: allow_encryption
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-data-compression-allow_encryption-desc
         :end-before: end-minio-data-compression-allow_encryption-desc

      This configuration setting corresponds with the :envvar:`MINIO_COMPRESSION_ALLOW_ENCRYPTION` environment variable.

   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-data-compression-comment-desc
         :end-before: end-minio-data-compression-comment-desc

   .. mc-conf:: enable
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-data-compression-enable-desc
         :end-before: end-minio-data-compression-enable-desc

      This configuration setting corresponds with the :envvar:`MINIO_COMPRESSION_ENABLE` environment variable.

   .. mc-conf:: extensions
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-data-compression-extensions-desc
         :end-before: end-minio-data-compression-extensions-desc

      This configuration setting corresponds with the :envvar:`MINIO_COMPRESSION_EXTENSIONS` environment variable.

   .. mc-conf:: mime_types
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-data-compression-mime_types-desc
         :end-before: end-minio-data-compression-mime_types-desc

      This configuration setting corresponds with the :envvar:`MINIO_COMPRESSION_MIME_TYPES` environment variable.