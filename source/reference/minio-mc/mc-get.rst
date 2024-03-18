==========
``mc get``
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc get

.. versionadded:: mc RELEASE.2024-02-24T01-33-20Z

Syntax
------

.. start-mc-get-desc

The :mc:`mc get` command downloads an object from a target S3 deployment to the local file system.

.. end-mc-get-desc

``mc get`` provides a simplified interface for downloading files compared to :mc:`mc cp` or :mc:`mc mirror`.
``mc get`` uses a one-way download function that trades efficiency for the power and complexity of the other commands.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following downloads the file ``logo.png`` from an s3 source to the local file system at path ``~/images/collateral/``.

      .. code-block:: shell
         :class: copyable

         mc get minio/marketing/logo.png ~/images/collateral


   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] get                      \
                          SOURCE                   \
                          TARGET                   \
                          [--encrypt-key value]    \
                          [--encrypt value] 

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: SOURCE
   :required:

   The full path to the :ref:`alias <minio-mc-alias>`, bucket, prefix (if used), and object to download.

.. mc-cmd:: TARGET
   :required:

   The destination path on the local file system where the command should place the downloaded file.

.. mc-cmd:: --encrypt
   :optional:

   Specify the key to use for decrypting and encrypting the downloaded object.

   Requires that you also specify the key to use with the :mc-cmd:`~mc put --encrypt-key` flag.

   Alternatively, set the :envvar:`MC_ENCRYPT` environment variable.

.. mc-cmd:: --encrypt-key
   :optional:
   
   Specify the key to use for decrypting and encrypting the downloaded object.

   Requires that you also pass the :mc-cmd:`~mc put --encrypt` flag set to ``TRUE``.

   Alternatively, set the :envvar:`MC_ENCRYPT_KEY` environment variable.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
