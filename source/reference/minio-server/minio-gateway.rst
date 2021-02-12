=============
MinIO Gateway
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. _minio-gateway:

MinIO Gateway
-------------

Syntax
~~~~~~

.. mc:: minio gateway

Starts the MinIO Gateway process. 

The command has the following syntax:

.. code-block:: shell
   :class: copyable

   minio gateway [FLAGS] SUBCOMMAND [ARGUMENTS]

:mc:`minio gateway` supports the following flags:

.. mc-cmd:: address
   :option:

   *Optional* Binds the MinIO Gateway to a specific network address and port
   number. Specify the address and port as ``ADDRESS:PORT``, where ``ADDRESS``
   is an IP address or hostname and ``PORT`` is a valid and open port on the
   host system.

   To change the port number for all IP addresses or hostnames configured
   on the host machine, specify ``:PORT`` where ``PORT`` is a valid
   and open port on the host.

.. mc-cmd:: certs-dir, -S
   :option:

   *Optional* Specifies the path to the folder containing certificates the
   MinIO Gateway process uses for configuring TLS/SSL connectivity.

   Omit to use the default directory paths:

   - Linux/OSX: ``${HOME}/.minio/certs`` 
   - Windows: ``%%USERPROFILE%%\.minio\certs``.

   See :ref:`minio-TLS` for more information on TLS/SSL connectivity.

.. mc-cmd:: quiet
   :option:

   *Optional* Disables startup information.

.. mc-cmd:: anonymous
   :option:

   *Optional* Hides sensitive information from logging.

.. mc-cmd:: json
   :option:

   *Optional* Outputs server logs and startup information in ``JSON``
   format.

:mc:`minio gateway` supports the following subcommands:

.. mc-cmd:: nas
   :fullpath:

   Creates a MinIO Gateway process configured for Network-Attached Storage
   (NAS).

.. mc-cmd:: azure
   :fullpath:

   Creates a MinIO Gateway process configured for Microsoft Azure Blob Storage.

.. mc-cmd:: s3
   :fullpath:

   Creates a MinIO Gateway process configured for Amazon Simple Storage Service
   (S3).

.. mc-cmd:: hdfs
   :fullpath:

   Creates a MinIO Gateway process configured for Hadoop Distributed File
   System (HDFS).

.. mc-cmd:: gcs
   :fullpath:

   Creates a MinIO Gateway process configured for Google Cloud Storage.