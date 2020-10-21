==============
``kes server``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes server

The :mc:`kes server` command starts a MinIO Key Encryption Server (KES) server.
The :mc:`kes server` process handles requests for creating and retrieving
cryptography keys from a supported Key Management System (KMS). KES is a 
required component for enabling Server-Side Object Encryption in MinIO
deployments.

This page provides reference information for the :mc:`kes server` command.
For more complete conceptual information on KEs, see
:ref:`minio-kes`.

Server Configuration File
~~~~~~~~~~~~~~~~~~~~~~~~~

Examples
--------

The following list links to tutorials for configuring KES with supported Key
Management Services (KMS):

- Thales/Gemalto
- AWS
- GCP
- ETC.

To deploy KES for evaluation and initial development, you can also use
the :ref:`KES Getting Started Guide <minio-kes-getting-started>` to deploy
KES using the local filesystem as the backing KMS. 

Syntax
------

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

   The identity with root permissions on the KES server. Use 
   ``kes tool identity of CERTIFICATE`` to retrieve the certificate to use
   for the root identity.

.. mc-cmd:: port
   :option:

   The port on which the :mc:`kes server` listens.

   Defaults to ``7373``. 

.. mc-cmd:: auth
   :option:

   Disables strict validation of TLS certificates. Required if using
   self-signed certificates for the
   :mc-cmd-option:`~kes server key` and
   :mc-cmd-option:`~kes server cert`.
