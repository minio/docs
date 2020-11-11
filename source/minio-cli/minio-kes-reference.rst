======================================
MinIO Key Encryption Service (``kes``)
======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes

Overview
--------

The MinIO Key Encryption Service (KES) is a stateless and distributed
key-management system for high-performance applications. KES provides
a bridge between applications running in bare-metal or orchestrated
environments to centralised KMS solutions. 

KES is designed for simplicity, scalability, and security. It requires 
minimal configuration to enable full functionality and requires only
basic familiarity with cryptography or key-management concepts.

This page contains conceptual and reference information on using KES for
performing cryptographic key operations and general data encryption/decryption.
For documentation on deploying KES to support MinIO Server-Side Encryption
(SSE-S3), see :ref:`minio-kes`.

.. _minio-kes-installation:

Installation
------------

.. include:: /includes/minio-kes-installation.rst

.. _minio-kes-access-control:

KES Access Control
------------------

KES uses mutual TLS authentication (mTLS) for performing both authentication and
authorization of clients making requests to the KES server. 

Authentication
~~~~~~~~~~~~~~
   
Both the client and server present their x.509 certificate and
corresponding private key to their peer. The server only accepts the
connection if the client certificate is valid and authentic:

- A "valid" certificate is well-formed and current (i.e. not expired). 
   
  mTLS also mTLS also requires the following `Extended Key Usage
  <https://tools.ietf.org/html/rfc5280#section-4.2.1.12>`__ extensions for 
  the client and server. Specifically:

  - The client certificate *must* include Client Authentication
     (``extendedKeyUsage = clientAuth``)
  
  - The server certificate *must* include Server Authentication
     (``extendedKeyUsage = serverAuth``)

- An "authentic" certificate is issued by a trusted Certificate Authority
  (CA). Both client and server *must* include the peer certificate CA 
  in their local system trust store.

  You can start the KES server with the :mc-cmd-option:`kes server auth`
  option to perform mTLS with untrusted certificates during testing or early
  development. However, untrusted certificates present a security
  vulnerability and may open the KES server to access by unknown parties.
  MinIO strongly recommends only allowing trusted certificates in production
  environments.

Once authenticated, the KES server proceeds to check if the client
is *authorized* to perform the requested operation.

.. _minio-kes-authorization:

Authorization
~~~~~~~~~~~~~
   
KES uses Policy-Based Access Control (PBAC) for determining what operations
a given client has permission to perform. Each policy consists of
one or more identities, where each identity corresponds to the
SHA-256 hash of an x.509 certificate. The server only allows the
client to perform the requested operation if *all* of the following
are true:

- A policy on the KES server contains the client identity.

- The policy explicitly allows the requested operation.

If no such policy exists on the KES server *or* if the policy does not
explicitly allow the requested operation, the KES server denies the
client's request. For more complete documentation on policies, 
see :ref:`minio-kes-policy`.

.. _minio-kes-policy:

KES Policies
~~~~~~~~~~~~

KES uses policy-based access control (PBAC), where a policy describes the
operations which an authenticated client may perform. 

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
         - <SHA-256 HASH>

- Each element in the :kesconf:`policy.policyname.paths` array represents an 
  :ref:`API endpoint <minio-kes-endpoints>` to which the policy grants access.

- Each element in the :kesconf:`policy.policyname.identities` array represents
  the SHA-256 hash of an x.509 certificate presented by a client.

  Use the :mc-cmd:`kes tool identity of` command to compute the identity hash
  of a client's x.509 certificate. 

Policies and identities have a one-to-many relationship, where one policy can
contain many identities. *However*, a given identity can associate to at most
one policy at a time.

The KES server provides two methods for configuring policies:

- The :kesconf:`policy` section of the KES
  :ref:`configuration file <minio-kes-config>` lists the persistent
  policies for the KES server.

- The :mc:`kes policy` command supports creating *ephemeral* policies for the
  KES server. The :mc:`kes identity` command supports *ephemeral* modification
  of the identities associated to policies on the KES server.  
  
  Policies created or modified using either :mc:`kes policy` or 
  :mc:`kes identity` disappear after restarting the KES server.

.. important::

   Each KES server has its own configuration file from which it derives all
   persistent policies. With distributed KES deployments, each server has its
   own independent and distinct policy-identity set based on its configuration
   file. This may allow for an identity to associate to different policies
   depending on which KES server a client connects to.

   Exercise caution in allowing KES servers to contain differing policies, 
   as it may result in inconsistent client encryption behavior between
   servers. MinIO strongly recommends synchronizing changes to configuration
   files in distributed KES deployments.

<TODO: Tutorial on adding/removing identities to the KES server>

.. _minio-kes-root:

KES Root Identity
~~~~~~~~~~~~~~~~~

The KES ``root`` identity has super-administrator access to all
:ref:`minio-kes-endpoints` and can perform any action on any resource on the KES
server.

The KES server :mc:`kes` requires specifying a ``root`` identity on startup
via either the :mc-cmd-option:`kes server root` commandline option *or*
the :kesconf:`root` server configuration field.

KES computes a SHA-256 hash of an authenticated client's x.509 certificate
to determine which policies to assign to the client. For the ``root``
identity, the client's x.509 certificate *must* match that specified to the
:mc:`kes` server.

To effectively disable the ``root`` account, specify a value for which the
SHA-256 hash of an x.509 certificate could *never* match. For example:

.. tabs::

   .. tab:: Command Line

      - ``kes server --root=_``

      - ``kes server --root=disabled``

   .. tab:: Configuration File

      - ``root: _``

      - ``root: disabled``


Exercise caution when storing or transmitting the ``root`` x.509 certificate and
private key, as any client with access to these credentials can perform
super-administrator actions on the KES server.

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

.. _minio-kes-supported-kms:

Supported Key Management Systems
--------------------------------

MinIO Key Encryption Service (KES) stores any Secret keys it generates on
an external Key Management System (KMS).

The following table lists all supported KMS:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - KMS
     - Description

   * - Filesystem
     - Stores Secret keys directly on the filesystem.

       Use Filesystem KMS only for local development or initial evaluation
       of KES. *Never* use Filesystem KMS for production.

.. _minio-kes-config:

KES Configuration File
----------------------

The KES configuration file is a ``YAML`` document containing information for
running the KES server. Use 
:mc-cmd-option:`kes server config` to specify the path to the configuration file 
on startup. 

General Configuration
~~~~~~~~~~~~~~~~~~~~~

.. kesconf:: address

   The network addresses and port on which :mc:`kes server` binds to on startup.
   Specify a string as ``IP:PORT``:

   - To specify only a custom IP address, omit ``:PORT``.

   - To specify only a custom port, omit ``IP``.

   Defaults to port ``7373`` on all network addresses on the host machine.

.. kesconf:: root

   Specify ``disabled`` to disable the :ref:`root <minio-kes-root>` identity
   on the KES server. The ``root`` identity has super administrator access to
   the KES server.

   If omitted, the :mc:`kes server` *requires* specifying an x.509 certificate
   using the :mc-cmd-option:`~kes server root` command line option.

TLS Configuration
~~~~~~~~~~~~~~~~~

The following section describes TLS-related configuration for the KES server:

.. code-block:: yaml

   tls:
      key: <string>
      cert: <string>

.. kesconf:: tls

   The root field for TLS-related configuration.

.. kesconf:: tls.key

   The path to the TLS private ``.key`` file KES uses when establishing
   TLS-secured communications.

   Ensure the Certificate Authority used to sign the private key exists in the
   host OS system trusted certificate store. Defer to the host operating
   system documentation for adding Certificate Authorities to the certificate
   store.

   To direct KES to accept invalid certificates, include the
   :mc-cmd-option:`kes server auth` option when starting the KES server.

.. kesconf:: tls.cert

   The path to the TLS public certificate ``.cert`` file KES uses when
   establishing TLS-secured communications.

   Ensure the Certificate Authority used to sign the private key exists in the
   host OS system trusted certificate store. Defer to the host operating
   system documentation for adding Certificate Authorities to the certificate
   store.

   To direct KES to accept invalid certificates, include the
   :mc-cmd-option:`kes server auth` option when starting the KES server.

Cache Configuration
~~~~~~~~~~~~~~~~~~~

The following section describes cache-related configuration for
controlling how often the KES server fetches keys from an external KMS.

.. code-block:: yaml

   cache:
      expiry:
         any: <string>
         unused: <string>

.. kesconf:: cache

   The root field for cache-related configuration.

.. kesconf:: cache.expiry

   The root field for cache expiry configuration.

.. kesconf:: cache.expiry.any

   The duration between clearing the in-memory cache of Customer Master Keys 
   (CMK) retrieved by KES. Specify a string as ``##h##m##s``:

   - ``30s`` sets a cache expiry of 30 seconds.
   - ``1m0s`` sets a cache expiry of 1 minute.
   - ``2m30s`` sets a cache expiry of 2 minutes and 30 seconds.

   Lower values trade higher security for more frequent outgoing network
   requests to the external KMS. Higher values may provide increased performance
   at the cost of security due to long-cached CMK.

   For example, a ``30s`` expiry allows KES to go up to 30 seconds
   without making a request to the external KMS. However, if the CMK is disabled
   or deleted during that time period, KES continues to encrypt and decrypt
   data using that CMK until the next refresh.

   The following table provides guidance for setting the cache value:

   .. list-table::
      :header-rows: 1
      :widths: 40 60
      :width: 50%

      * - Security Goal
        - Value

      * - *Liberal*
        - ``5m0s``
      
      * - *Moderate*
        - ``1m0s``

      * - *Conservative*
        - ``30s``

.. kesconf:: cache.expiry.unused

   The duration after which KES considers a cached Customer Master Key as
   unused and removes that key from the cache. Specify a string as ``##h##m##s``:

   - ``30s`` sets a cache expiry of 30 seconds.
   - ``1m0s`` sets a cache expiry of 1 minute.
   - ``2m30s`` sets a cache expiry of 2 minutes and 30 seconds.

   The following table provides guidance for setting the cache value:

   .. list-table::
      :header-rows: 1
      :widths: 40 60
      :width: 50%

      * - Security Goal
        - Value

      * - *Liberal*
        - ``30s``
      
      * - *Moderate*
        - ``20s``

      * - *Conservative*
        - ``5s``

Logging Configuration
~~~~~~~~~~~~~~~~~~~~~

The following section describes logging-related configuration for the KES
server:

.. code-block:: yaml

   log:
      error: <string>
      audit: <string>

.. kesconf:: log

   The root field for log-related configuration.

.. kesconf:: log.error

   Enables or disables error logging to ``STDERR``.

   - Specify ``on`` to enable error logging. 

   - Specify ``off`` to disable error logging.

   Defaults to ``on``.

.. kesconf:: log.audit

   Enables or disables audit logging to ``STDOUT``.

   - Specify ``on`` to enable audit logging.

   - Specify ``off`` to disable audit logging.

   Defaults to ``off``.

   The KES server emits an audit event for every client request. Each
   event describes the complete request-response pair and includes information
   about the requesting client. The audit information *never* contains
   plaintext cryptographic keys. 

   KES server may produce many audit events depending on the number of MinIO
   servers or other clients making requests to the server.

Policy Configuration
~~~~~~~~~~~~~~~~~~~~

The following section describes policy-related configuration for the KES server.
Policies are a component of :ref:`KES access control 
<minio-kes-access-control>`.

Policies listed in this section are *persistent* through KES server restarts.
Policies created using :mc:`kes policy` are *ephemeral* and are removed after
KES server restart. To make a policy created or modified through 
:mc:`kes policy` persistent. add that policy to this section of the 
KES configuration file:

.. code-block:: yaml

   policy:
      policyname:
         paths: <array>
         identities: <array>

.. kesconf:: policy

   The root field for policy-related configuration.

.. kesconf:: policy.policyname

   The name of the policy. Replace the field ``policyname`` with a string
   for the policy name. The policy name *must* be unique among all other
   ``policyname`` objects specified to :kesconf:`policy`.

.. kesconf:: policy.policyname.paths

   An array of :ref:`KES API Endpoints <minio-kes-endpoints>` which
   the specified :kesconf:`policy.policyname.identities` can access.

   Each endpoint *must* be a glob pattern in the following form:

   .. code-block:: shell

      <APIVERSION>/<API>/<operation>/[<argument>/<argument>/]

   For example, the following endpoint pattern allows complete access to key
   creation via the ``/v1/key/create`` endpoint:

.. kesconf:: policy.policyname.identities

   An array of identities associated to the policy. An :ref:`identity
   <minio-kes-authorization>` consists of the SHA-256 hash of an x.509
   certificate. Use :mc-cmd:`kes tool identity of` to compute the identity of
   each x.509 certificate you want to associate to the policy and specify that
   value to the array.

   KES grants clients authenticating with an x.509 certificate identity in the
   array access to the KES API endpoints listed in the
   :kesconf:`~policy.policyname.paths`.

   A given unique identity can associate to no more than *one* policy on the
   KES server.

Filesystem KMS Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section describes Filesystem KMS-related configuration for the
KES server.

Configuring the KES server for Filesystem KMS directs KES to store
generated Customer Master Keys (CMK) on-disk. Filesystem KMS is appropriate
for local development and evaluation of KES *only* and should *never* be used
for production environments.

.. code-block:: yaml

   keys:
      fs:
         path: <string>

.. kesconf:: keys
   :noindex:

   The root field for KMS-related configuration.

.. kesconf:: keys.fs

   The root field for Filesystem KMS-related configuration.

.. kesconf:: keys.fs.path

   The filesystem path to the directory on disk where KES stores any
   generated CMK.

Hashicorp Vault Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section describes Hashicorp Vault-related configuration for
the KES server.

For more complete documentation on configuring KES for connecting to a 
Hashicorp Vault KMS, see <TODO>.

.. code-block:: yaml

   keys:
      vault:
         endpoint: https://[IP|HOSTNAME]
         approle:
            id: "<string>"
            secret: "<string>"
            retry: <string>
         status:
            ping: <string>
         tls:
            ca: <string>

.. kesconf:: keys
   :noindex:

   The root field for KMS-related configuration.

.. kesconf:: keys.vault

   The root field for Hashicorp Vault-related configuration. 

.. kesconf:: keys.vault.endpoint

   Specify the URL endpoint of the Hashicorp Vault server.

.. kesconf:: keys.vault.prefix

   Specify the prefix under which the KES server looks for secret keys. 
   Required if the Vault ``AppRole`` capabilities specifies a prefix for keys
   generated by that ``AppRole``.

.. kesconf:: keys.vault.approle

   Contains information related to Hashicorp Vault 
   `AppRole Authentication <https://www.vaultproject.io/docs/auth/approle>`__.

   KES authenticates to Hashicorp Vault using the ``AppRole`` ID and secret. 
   The specified ``AppRole`` *must* grant KES ``create``, ``read``, and
   ``delete`` capabilities on Vault. Defer to Vault documentation for
   more complete guidance on configuring ``AppRole`` ID and permission.

.. kesconf:: keys.vault.approle.id

   Specify the ID of the Vault ``AppRole`` with which KES authenticates.

.. kesconf:: keys.vault.approle.secret

   Specify the corresponding secret ID for the specified 
   :kesconf:`keys.vault.approle.id`.

.. kesconf:: keys.vault.approle.retry

   The duration KES waits before attempting to reconnect to the Vault server.
   Specify a string as ``##h##m##s``.

.. kesconf:: keys.vault.status

   Contains information related to retrieving the status of the Vault server.

.. kesconf:: keys.vault.status.ping

   The duration KES waits between requesting status information onn the Vault
   server. Specify a string as ``##h##m##s``.

.. kesconf:: keys.vault.tls

   Contains information related to the TLS Certificate Authority used by the
   vault server. KES may require this for self-signed certificates *or*
   for certificates signed by a non-global Certificate Authority.

.. kesconf:: keys.vault.tls.ca

   Specify the full path to the Certificate Authority ``*.crt`` file used to 
   sign the Vault TLS certificates. 
   

Thales CipherTrust / Gemalto KeySecure Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section describes Thales CipherTrust (formerly Gemalto
KeySecure)-related configuration for the KES server.

For more complete documentation on configuring KES for connecting to a 
CipherTrust KMS, see :doc:`/security/encryption/sse-s3-thales`.

.. code-block:: yaml

   keys:
      gemalto:
         keysecure:
            endpoint: : https://[IP|HOSTNAME]
            credentials:
               token: "<string>"
               domain: "<string>"
               retry: "<string>"
            tls:
               ca: <string>

.. kesconf:: keys.gemalto.keysecure

   The root field for Thales CipherTrust / Gemalto KeySecure configuration.

.. kesconf:: keys.gemalto.keysecure.endpoint

   *Required*

   The URL endpoint of the CipherTrust/KeySecure server.

.. kesconf:: keys.gemalto.keysecure.credentials.token

   *Required*

   A refresh token generated by the CipherTrust/KeySecure server.
   KES uses refresh tokens for generating short-lived authentication 
   tokens.

.. kesconf:: keys.gemalto.keysecure.credentials.domain

   The domain of the CipherTrust/KeySecure server. Omit to default to the
   root domain.

.. kesconf:: keys.gemalto.keysecure.credentials.retry

   The duration KES waits before attempting to reconnect to the
   CipherTrust/KeySecure server. Specify a string as ``##h##m##s``.

.. kesconf:: keys.gemalto.keysecure.tls.ca

   The Certificate Authority which issued the CipherTrust/KeySecure TLS
   certificates. 

   If you cannot provide the CipherTrust/KeySecure CA, start the
   KES server with :mc-cmd:`--auth off <kes server auth>` to disable
   x.509 certificate validation. MinIO strongly recommends *against*
   starting KES without certificate validation in production environments.

.. toctree::
   :titlesonly:
   :hidden:
   :glob:

   /minio-cli/kes/*