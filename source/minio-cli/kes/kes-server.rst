==============
``kes server``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes server

The :mc:`kes server` command starts a MinIO Key Encryption Server (KES) server.
The :mc:`kes server` handles requests for creating and retrieving
cryptography keys from a supported Key Management System (KMS). KES is a 
required component for enabling Server-Side Object Encryption in MinIO
deployments.

This page provides reference information for the :mc:`kes server` command.
For more complete conceptual information on KEs, see
:ref:`minio-kes`.

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

   kes server [OPTIONS]

:mc:`kes server` supports the following arguments:

.. mc-cmd:: cert
   :option:

   Path to KES server X.509 certificate served by the KES server to clients when a :abbr: `TLS (Transport Layer Encryption)` connection is established
   enabling :abbr:`TLS (Transport Layer Encryption)`.

.. mc-cmd:: config
   :option:

   The path to the KES configuration file. See :ref:`minio-kes-config` for
   more information on the configuration file format and contents.

.. mc-cmd:: key
   :option:

   Path to the KES server private key that corresponds to the X.509 server certificate.
   :abbr:`TLS (Transport Layer Encryption`). 

.. mc-cmd:: root
   :option:

   The identity with root permissions on the KES server. 
   
   Use the :mc-cmd:`kes tool identity of` command to compute the X.509 identity
   of an arbitrary client certificate. 
   
   .. code-block:: shell

      kes tool identity of CERTIFICATE

.. mc-cmd:: auth
   :option:

   Determines whether the KES server verifies the X.509 certificate of its clients. Valid options are `{ on | off }`.
   If disabled, the KES server accepts arbitrary clients connections but still enforces policy-based access control.
   self-signed certificates for the
   :mc-cmd-option:`~kes server key` and
   :mc-cmd-option:`~kes server cert`.
