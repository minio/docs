.. _minio-mc-encrypt-set:

==================
``mc encrypt set``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc encrypt set

Syntax
------

.. start-mc-encrypt-set-desc

The :mc:`mc encrypt set` encrypt command sets or updates the default
bucket :ref:`Server-Side Encryption (SSE) mode <minio-sse>`. MinIO automatically
encrypts objects written to that bucket using the specified SSE mode.

.. end-mc-encrypt-set-desc

:mc:`mc encrypt set` only supports :ref:`SSE-KMS <minio-encryption-sse-kms>`
and :ref:`SSE-S3 <minio-encryption-sse-s3>`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command sets the default 
      :ref:`SSE-KMS encryption key <minio-encryption-sse-kms>` for the bucket
      ``mydata`` on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc encrypt set sse-kms "minio-encryption-key" myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] encrypt set  ENCRYPTION [KMSKEY] ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ENCRYPTION
   
      Specify the server-side encryption type to use as the default SSE mode.
      Supports the following values:

      - ``sse-kms`` - Encrypt objects using the key specified in 
        :mc-cmd:`~mc encrypt set KMSKEY`. MinIO
        must have access to the specified key on the external KMS to
        successfully encrypt or decrypt objects protected using SSE-KMS.

      - ``sse-s3`` - Encrypt objects using the key specified to
        :envvar:`MINIO_KMS_KES_KEY_NAME`. MinIO must have access to the
        specified key on the external KMS to successfully encrypt or decrypt
        objects protected using SSE-S3.

.. mc-cmd:: KMSKEY

   Specify the KMS Master Key to use for performing SSE object encryption. This
   option only applies if :mc-cmd:`~mc encrypt set ENCRYPTION` is
   ``sse-kms``. 
   
   Omit this option to direct MinIO to use the 
   :envvar:`MINIO_KMS_KES_KEY_NAME`.

.. mc-cmd:: ALIAS

   The full path to the bucket on which to set the default SSE mode. Specify the
   :ref:`alias <alias>` of the MinIO deployment as the prefix to the TARGET
   path. For example:

   .. code-block:: shell

      mc encrypt set ENCRYPTION [KMSKEY] play/mybucket

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Enable Automatic Server-Side Bucket Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Example

      The following commands assumes that:
      
      - The MinIO server configuration supports
        :ref:`SSE-KMS <minio-encryption-sse-kms>`

      - The root has an encryption key ``minio-encryption-key``.

      .. code-block:: shell
         :class: copyable

          mc encrypt set sse-kms minio-encryption-key myminio/data

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable

         mc encrypt set ENCRYPTION KMSKEY TARGET

      - Replace ``ENCRYPTION`` with ``sse-kms`` or ``sse-s3`` depending
        on the preferred encryption mode.

      - Replace ``KMSKEY`` with the name of the encryption key on the
        configured root KMS. This argument has no effect with ``sse-s3``.

      - Replace ``TARGET`` with the :ref:`alias <alias>` of the
        MinIO deployment on which to configure automatic server-side bucket
        encryption.

Behavior
--------

:mc:`mc encrypt set` makes no assumptions about the MinIO server's current
encryption state. Specifying default encryption settings which the 
server cannot support may result in undesired behavior.

Setting or modifying the default server-side encryption settings does *not*
automatically encrypt or decrypt the existing bucket contents. 
If the bucket contents *must* have consistent encryption, use the
:mc:`mc mv` command with :mc-cmd:`~mc mv --enc-kms`, :mc-cmd:`~mc mv --enc-s3`, or :mc-cmd:`~mc mv --enc-c` to specify the type of encryption to use for the moved contents.
This manually modifies the encryption settings or encrypted state of the bucket contents *before* changing the bucket default. 
