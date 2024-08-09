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
                          [--enc-c string]         \
                          [--version-id, --vid value]

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

.. block include of enc-c

.. include:: /includes/common-minio-sse.rst
   :start-after: start-minio-mc-sse-c-only
   :end-before: end-minio-mc-sse-options

.. mc-cmd:: --version-id, --vid
   :optional:
   
   Retrieve a specific version of the object.
   Pass the version ID of the object to retrieve.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Retrieve an object from MinIO to the local file system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command retrieves the file ``myobject.csv`` from the bucket ``mybucket`` at the alias ``myminio`` and places it on the local file system at the path ``/my/local/folder``.

.. code-block:: shell
   :class: copyable

   mc get myminio/mybucket/myobject.csv /my/local/folder 

Retrieve an encrypted object from MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command retrieves an encrypted file and places it at a local folder path.

.. code-block:: shell
   :class: copyable

   mc get --enc-c "play/mybucket/object=MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDA" play/mybucket/object path-to/object 