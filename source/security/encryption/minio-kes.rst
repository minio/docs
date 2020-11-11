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

.. image:: https://raw.githubusercontent.com/minio/kes/master/.github/arch.png
   :alt: The KES server sits between the MinIO deployment and the KMS.
   :width: 90%
   :align: center

KES is designed for simplicity, scalability, and security. It requires 
minimal configuration to enable full functionality and requires only
basic familiarity with cryptography or key-management concepts.

This page contains information on deploying and configuring KES for supporting
Server-Side Encryption with MinIO. For more complete documentation on the
:mc:`kes` command line tool and the KES :mc:`~kes server` process, see the
:doc:`KES reference page </minio-cli/minio-kes-reference>`.

.. _minio-kes-getting-started:

Getting Started
---------------

The following procedure creates a MinIO Key Encryption Service (KES) server that
generates and stores keys in-memory for use with evaluating Server Side Object
Encryption with MinIO. This configuration is appropriate for local development
*only*. **Do not** use this procedure to deploy a KES server for development or
production.

1. Install the KES Server
~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/minio-kes-installation.rst

2. Generate a TLS Private Key and Certificate
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a. Issue the following command in a shell or terminal environment to generate a
   self-signed TLS private key:

   .. code-block:: shell
      :class: copyable

      openssl ecparam -genkey -name prime256v1 | openssl ec -out server.key

b. Issue the following command in a shell or terminal environment to
   use the private key and generate the x.509 Certificate:

   .. code-block:: shell
      :class: copyable

      openssl req -new -x509 -days 30 \
         -key server.key -out server.cert \
         -subj "/C=/ST=/L=/O=/CN=localhost" \
         -addext "subjectAltName = IP:127.0.0.1"

   The command output may include warnings about missing fields. You can
   safely ignore these warnings for self-signed certificates.

3. Create the Root Identity
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the ``kes tool identity new`` command to create the root identity.
This identity has full permissions to perform any action on the KES server:

.. code-block:: shell
   :class: copyable

   kes tool identity new --key=root.key --cert=root.cert root

The command automatically generates the ``root.key`` and ``root.cert``
keys in the folder from which ``kes tool identity new`` runs.

4. Start the KES server
~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`kes server` command to start the KES server:

.. code-block:: shell
   :class: copyable

   kes server \
      --key=server.key \
      --cert=server.cert \
      --root=$(kes tool identity of root.cert) \
      --auth=off

The :mc-cmd-option:`~kes server auth` flag disables strict TLS certificate
validation and allows using self-signed certificates.

5. Connect to the KES Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Set the following environment variables in a terminal or shell:

.. code-block:: shell
   :class: copyable

   export KES_CLIENT_KEY=root.key
   export KES_CLIENT_CERT=root.cert

Specify the full path to the ``root.key`` and ``root.cert`` created in 
:guilabel:`3. Create the Root Identity`.

You can create a new Customer Master Key using the 
:mc-cmd:`kes key create` command. The command uses the environment variables
as the credentials for authenticating to the KES server:

.. code-block:: shell
   :class: copyable

   kes key create -k my-master-key

KES uses the new Customer Master Key to create a Key Encryption Key (KEK). 
KES uses the KEK to generate additional cryptographic keys for performing
encryption. 

6. Configure MinIO to Connect to the KES Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This step assumes access to a host machine with the :mc:`minio` installed. If
the :mc:`minio` server process is already running, this step requires restarting
that process. 

Set the following environment variables on each host which runs a MinIO server:

.. code-block:: shell  
   :class: copyable

   export MINIO_KMS_KES_ENDPOINT=https://[IP | HOSTNAME]:7373
   export MINIO_KMS_KES_KEY_FILE=root.key
   export MINIO_KMS_KES_CERT_FILE=root.cert
   export MINIO_KMS_KES_KEY_NAME=my-master-key

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Environment Variable
     - Description

   * - :envvar:`MINIO_KMS_KES_ENDPOINT`
     - The endpoint of the KES server. :mc:`kes server` by default binds to
       port ``7373`` on all network interfaces.

   * - :envvar:`MINIO_KMS_KES_KEY_FILE`
     - The key file of the x.509 identity to use when authenticating to the
       KES server. Specify the full path to the ``root.key`` certificate
       created in :guilabel:`3. Create the Root Identity`.

   * - :envvar:`MINIO_KMS_KES_CERT_FILE`
     - The public certificate of the x.509 identity to use when authenticating 
       to the KES server. Specify the full path to the ``root.key`` certificate
       created in :guilabel:`3. Create the Root Identity`.

   * - :envvar:`MINIO_KMS_KES_KEY_NAME`
     - The name of the Customer Master Key to use for performing Server-Side
       Object Encryption. 


Next Steps
~~~~~~~~~~

ToDo: List of tutorials for performing cryptographic operations, possibly
SSE-C

KES Quick Reference
-------------------

The following table lists the high-level commands of the
:mc:`kes` command line tool:

TODO

