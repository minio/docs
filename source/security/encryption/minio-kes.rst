.. _minio-kes:

============================
MinIO Key Encryption Service
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

The MinIO Key Encryption Service (KES) is a stateless and distributed
key-management system for high-performance applications. KES provides
a bridge between applications running in bare-metal or orchestrated
environments to centralised KMS solutions. 

<DIAGRAM>

KES is designed for simplicity, scalability, and security. It requires 
minimal configuration to enable full functionality and requires only
basic familiarity with cryptography or key-management concepts.

MinIO servers require KES for performing Server-Side Encryption (SSE) of objects
using Key Management Services (KMS). 

KES Server Process
------------------

.. mc:: kes server

:mc:`kes server` command starts the KES server. The :mc:`kes server` process
handles requests for creating and retrieving cryptography keys from a supported
Key Management System (KMS). 

The command has the following syntax:

.. code-block:: shell
   :class: copyable

   kes server --cert CERTIFICATE --key PRIVATEKEY --root ROOT_IDENTITY [OPTIONAL_FLAGS]

:mc:`kes server` supports the following arguments:

.. mc-cmd:: cert
   :option:

   The location of the public certificate ``.crt`` to use for
   enabling :abbr:`TLS (Transport Layer Encryption)`.

.. mc-cmd:: config
   :option:

   The path to the KES configuration file. See :ref:`minio-kes-config` for
   more information on the configuration file format and contents.

.. mc-cmd:: key
   :option:

   The location of the private key ``.key`` to use for enabling
   :abbr:`TLS (Transport Layer Encryption`). 

.. mc-cmd:: root
   :option:

   ToDo: Description

.. mc-cmd:: port
   :option:

   The port on which the :mc:`kes server` listens.

   Defaults to ``7373``. 

.. _minio-kes-config:

KES Configuration File
----------------------

ToDo: Import https://github.com/minio/kes/wiki/Configuration , need to
include instructions on how to set the config file (directory, cli option etc.)