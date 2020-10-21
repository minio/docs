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

MinIO servers require KES for performing Server-Side Encryption (SSE) of objects
using Key Management Services (KMS). Applications *may* use KES to support
cryptographic key operations independent of MinIO. 

This page documents conceptual information about MinIO KES. For documentation
on the :mc:`kes` command line tool, see the
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

.. _minio-kes-iam:

KES Identity and Access Management
----------------------------------

The KES server configuration includes one or more
:ref:`policies <minio-kes-policy>` that associate x.509 identities
to the API endpoints which those identities can access. Client's *must*
present an x.509 certificate when connecting to the KES server.

KES Identity
~~~~~~~~~~~~

This section to contain information on creating x.509 certificates for use
with KES.

.. _minio-kes-policy:

KES Policies
~~~~~~~~~~~~

The KES server provides two methods for configuring policies:

- The :kesconf:`policy` section of the KES
  :ref:`configuration file <minio-kes-config>` lists the persistent
  policies for the KES server.

- The :mc:`kes policy` command supports creating *ephemeral* policies for the
  KES server. The :mc:`kes identity` command supports *ephemeral* modification
  of the identities associated to policies on the KES server.  
  
  Policies created or modified using either :mc:`kes policy` or 
  :mc:`kes identity` disappear after restarting the KES server.

The following ``YAML`` document provides an example of the :kesconf:`policy`
section of the KES server configuration document. The policy ``minio-sse`` 
includes the appropriate :ref:`API endpoints <minio-kes-endpoints>` for 
supporting MinIO Server-Side Encryption:

.. code-block:: yaml
   :class: copyable

   policy:
      minio-sse:
         paths:
         - /v1/key/create/*
         - /v1/key/generate/*
         - /v1/key/decrypt/*
         - /v1/key/delete/*
         identities:
         - HASH

Each element in the :kesconf:`policy.policyname.paths` array represents an 
:ref:`API endpoint <minio-kes-endpoints>` to which the policy grants access.

Each element in the :kesconf:`policy.policyname.identities` array represents
the hash of an x.509 certificate generated using the 
:mc:`kes tool identity of` command line operation.

.. _minio-kes-iam-root:

KES Root Identity
~~~~~~~~~~~~~~~~~

The KES ``root`` identity has super-administrator access to all
:ref:`minio-kes-endpoints` and can perform any action on any resource on the KES
server.

All KES identities consist of an x.509 certificate pair (private ``*.key`` and
public ``*.cert``). Exercise caution when storing or transmitting the ``root``
x.509 certificates, as any client with access to these certificates can
perform super-administrator actions on the KES server.

The KES server disables the ``root`` identity by default. To create the
``root`` identity, either:

- Start the KES server with the :mc-cmd-option:`~kes server root` option, *or*

- Specify :kesconf:`root : disabled <root>` in the KES server configuration
  document.

.. _minio-kes-endpoints:

KES API Endpoints
-----------------

The following section lists the available KES API endpoints as a quick
reference. For more complete documentation on syntax and usage for each
endpoint, see the :minio-git:`KES Wiki </kes/wiki/Server-API>`.

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Endpoint
     - Description

   * - ``/version``
     - Returns the version of the KES server.

   * - ``/v1/key/create``
     - Creates a cryptographic key on the KES server.

       To restrict access to a specific key prefix, specify that prefix as
       an argument to the API. For example, the following endpoint pattern
       allows creating keys with the prefix ``myapp``:

       .. code-block:: shell

          /v1/key/create/myapp-*

   * - ``/v1/key/import``
     - Imports a cryptographic key into the KES server.

   * - ``/v1/key/delete``
     - Deletes a cryptographic key on the KES server.

       Deleting a cryptographic key prevents decrypting any data encrypted
       with that key, rendering that data permanently unreadable. Consider
       restricting access to this endpoint to only those clients which require
       it.

   * - ``/v1/key/generate``
     - Generates a Data Encryption Key (DEK) on the KES server. 
       Client's can use the DEK for performing Server-Side Object Encryption.

   * - ``/v1/key/encrypt``
     - Encrypts a plaintext value using a Data Encryption Key.

   * - ``/v1/key/decrypt``
     - Decrypts a ciphertext value using a Data Encryption Key.

   * - ``/v1/policy/write``
     - Adds a new :ref:`policy <minio-kes-policy>` to the KES server.

   * - ``/v1/policy/read``
     - Retrieves an existing :ref:`policy <minio-kes-policy>` from the KES
       server.

   * - ``/v1/policy/list``
     - Lists all :ref:`policies <minio-kes-policy>` on the KES server.

   * - ``/v1/policy/delete``
     - Deletes a :ref:`policy <minio-kes-policy>` from the KES server.

   * - ``/v1/identity/assign``
     - Assigns an x.509 identity to a :ref:`policy <minio-kes-policy>` on the
       KES server.

   * - ``/v1/identity/list``
     - Lists all x.509 identities associated to a 
       :ref:`policy <minio-kes-policy>` on the KES server.

   * - ``/v1/identity/forget``
     - Remove an x.509 identity associated to a :ref:`policy <minio-kes-policy>`
       on the KES server.

   * - ``/v1/log/audit/trace``
     - Returns a stream of audit log events produced by the KES server.

   * - ``/v1/log/log/error/trace``
     - Returns a stream of error events produced by the KES server.