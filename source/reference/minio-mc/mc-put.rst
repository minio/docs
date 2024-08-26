==========
``mc put``
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc put

.. versionadded:: mc RELEASE.2024-02-24T01-33-20Z

Syntax
------

.. start-mc-put-desc

The :mc:`mc put` uploads an object from the local file system to a bucket on a target S3 deployment.

.. end-mc-put-desc

``mc put`` provides a simplified interface for uploading files compared to :mc:`mc cp` or :mc:`mc mirror`.
``mc put`` uses a one-way upload function that trades efficiency for the power and complexity of the other commands.


.. tab-set::

   .. tab-item:: EXAMPLE

      The following uploads the file ``logo.png`` from the local file system at path ``~/images/collateral/`` to a bucket called ``marketing`` on the MinIO deployment with the alias of ``minio``.

      .. code-block:: shell
         :class: copyable

         mc put ~/images/collateral/logo.png minio/marketing


   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] put                      \
                          TARGET                   \
                          [--enc-kms value]        \
                          [--enc-s3 value]         \
                          [--enc-c value]          \
                          [--if-not-exists]        \
                          [--parallel, -P integer] \
                          [--part-size, -s string]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The full path to the :ref:`alias <minio-mc-alias>` or prefix where the command should run.
   The TARGET *must* contain an :ref:`alias <alias>` and ``bucket`` name.

   The TARGET may also contain the following optional components:
   - PREFIX where the object should upload to
   - OBJECT-NAME to use in place of the file names

   Valid TARGETs could take any of the following forms:
   - ``ALIAS/BUCKET``
   - ``ALIAS/BUCKET/PREFIX``
   - ``ALIAS/BUCKET/OBJECT-NAME``
   - ``ALIAS/BUCKET/PREFIX/OBJECT-NAME``

.. block include of enc-c , enc-s3, and enc-kms

.. include:: /includes/common-minio-sse.rst
   :start-after: start-minio-mc-sse-options
   :end-before: end-minio-mc-sse-options


.. mc-cmd:: --parallel, --P
   :optional:

   For multi-part uploads, specify the number of parts of the object to upload in parallel.

   If not defined, defaults to a value of ``4``.

.. mc-cmd:: --part-size, -s
   :optional:

   Specify the size to use for each part of a multi-part upload.

   If not defined, defaults to a value of ``16MiB``.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Upload a File and Specify the Object Name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command uploads the file ``logo.png`` from the local file system to the ``business`` bucket on the ``minio`` deployment, uploading it on the destination as ``company-logo.png``.

.. code-block:: shell
   :class: copyable

   mc put images/collateral/logo.png minio/business/company-logo.png

Upload a Multipart Object in Parallel with a Specified Part Size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command uploads a file in chunks of 20MiB each and uploads 8 parts of the file in parallel.
8 parts are uploaded in succession until all parts of the object have uploaded.

.. code-block:: shell
   :class: copyable

   mc put ~/videos/collateral/splash-page.mp4 minio/business --parallel 8 --part-size 20MiB
