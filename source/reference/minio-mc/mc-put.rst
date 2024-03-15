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

Unlike other commands that can upload files, such as :mc:`mc cp` or :mc:`mc mirror`, ``mc put`` is a simpler call.
``mc put`` only does the one-way function of uploading the file so that it avoids the potential performance costs of other commands.

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
                          [--encrypt-key value]    \
                          [--encrypt value]        \
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

.. mc-cmd:: --encrypt
   :optional:

   Specify the key to use for decrypting and encrypting the uploaded object.

   Requires that you also specify the key to use with the :mc-cmd:`~mc put --encrypt-key` flag.

   Alternatively, set the :envvar:`MC_ENCRYPT` environment variable.

.. mc-cmd:: --encrypt-key
   :optional:
   
   Specify the key to use for decrypting and encrypting the uploaded object.

   Requires that you also pass the :mc-cmd:`~mc put --encrypt` flag set to ``TRUE``.

   Alternatively, set the :envvar:`MC_ENCRYPT_KEY` environment variable.

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

The following command uploads the file ``logo.png`` from the local file system to the ``business`` bucket on the ``minio`` deployment with the object name of ``company-logo.png``.

.. code-block:: shell
   :class: copyable

   mc put images/collateral/logo.png minio/business/company-logo.png

Upload a File 8 Parts in Parallel with a Specified Part Size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command uploads 8 parts of a file in parallel with parts of 20MiB each.

.. code-block:: shell
   :class: copyable

   mc put ~/videos/collateral/splash-page.mp4 minio/business --parallel 8 --part-size 20MiB
