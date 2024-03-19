======================
``mc support upload``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support upload

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Description
-----------

.. start-mc-support-upload-desc

:mc:`mc support upload` copies a file from the local file system to a SUBNET ticket.

.. end-mc-support-upload-desc

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Syntax
------
      
The :mc:`mc support profile` command has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] support profile     \
                            ALIAS       \
                            FILE        \
                            [--comment] \
                            [--issue]

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.

.. mc-cmd:: FILE
   :required:

   The path to the file to upload to SUBNET.

.. mc-cmd:: --comment
   :optional:

   Include a message to the issue when uploading the file.

.. mc-cmd:: --issue
   :optional:

   Specify the issue number to which to add the file.
   If not specified, the file uploads to the generic issue number ``0``.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Upload a file to an issue
~~~~~~~~~~~~~~~~~~~~~~~~~

This command uploads the file ``./trace.log`` from the local file system to the SUBNET issue number 10001 for the deployment with alias ``minio1``.

.. code-block:: shell
   :class: copyable

   mc support upload --issue 10 myminio ./trace.log 


Upload a file to an issue with a comment for MinIO Engineers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This command uploads the file ``./trace.log`` from the local file system to the SUBNET issue number 10001 for the deployment with alias ``minio1``.
The command also includes a comment available to MinIO Engineers about the file.

.. code-block:: shell
   :class: copyable

   mc support upload --issue 10 --comment "here is the requested trace log" myminio ./trace.log