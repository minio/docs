.. _minio-tls:

========================
Network Encryption (TLS)
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

The MinIO server supports Transport Layer Security (TLS) encryption of incoming
and outgoing traffic. MinIO recommends all MinIO servers run with TLS enabled to
ensure end-to-end security of client-server or server-server transmissions.

TLS is the successor to Secure Socket Layer (SSL) encryption. SSL is fully
`deprecated <https://tools.ietf.org/html/rfc7568>`__ as of June 30th, 2018. 
MinIO uses only supported (non-deprecated) TLS protocols (TLS 1.2 and later).

MinIO supports multiple TLS certificates, where the server uses 
`Server Name Indication (SNI)
<https://en.wikipedia.org/wiki/Server_Name_Indication>`__ to identify which
certificate to use when responding to a client request.

For example, consider a MinIO deployment reachable through the following
hostnames:

- ``https://minio.example.net``
- ``https://s3.example.net``
- ``https://minio.internal-example.net``

MinIO can have a single TLS certificate that covers all hostnames with multiple
Subject Alternative Names (SAN). However, this would reveal the
``internal-example.net`` hostname to all clients. Instead, you can specify
multiple TLS certificates to MinIO for the public and private portions of your
infrastructure to mitigate the risk of leaking internal topologies via TLS SAN.
When a client connects using a specific hostname, MinIO uses SNI to select the
appropriate TLS certificate for that hostname.

MinIO by default searches an OS-specific directory for TLS keys and
certificates. For deployments started with a custom TLS directory
:mc-cmd:`minio server --certs-dir`, use that directory instead of the
defaults.

.. tab-set::

   .. tab-item:: Linux
      :sync: linux

      MinIO looks for TLS keys in the following directory:

      .. code-block:: shell

         ${HOME}/.minio/certs

      Place the TLS certificates for the default domain (e.g.
      ``minio.example.net``) in the ``/certs`` directory, with the private key
      as ``private.key`` and public certificate as ``public.crt``.

      Create a subfolder in ``/certs`` for each additional domain for which
      MinIO should present TLS certificates. While MinIO has no requirements for
      folder names, consider creating subfolders whose name matches the domain
      to improve human readability. Place the TLS private and public key for
      that domain in the subfolder.

      For example:

      .. code-block:: shell

         ${HOME}/.minio/certs
           private.key
           public.cert
           s3-example.net/
             private.key
             public.cert
           internal-example.net/
             private.key
             public.cert

   .. tab-item:: OSX
      :sync: osx

      MinIO looks for TLS keys in the following directory:

      .. code-block:: shell

         ${HOME}/.minio/certs

      Place the TLS certificates for the default domain (e.g.
      ``minio.example.net``) in the ``/certs`` directory, with the private key
      as ``private.key`` and public certificate as ``public.crt``.

      Create a subfolder in ``/certs`` for each additional domain for which
      MinIO should present TLS certificates. While MinIO has no requirements for
      folder names, consider creating subfolders whose name matches the domain
      to improve human readability. Place the TLS private and public key for
      that domain in the subfolder.

      For example:

      .. code-block:: shell

         ${HOME}/.minio/certs
           private.key
           public.cert
           s3-example.net/
             private.key
             public.cert
           internal-example.net/
             private.key
             public.cert

   .. tab-item:: Windows
      :sync: windows

      MinIO looks for TLS keys in the following directory:

      .. code-block:: shell

         %%USERPROFILE%%\.minio\certs

      Place the TLS certificates for the default domain (e.g.
      ``minio.example.net``) in the ``\certs`` directory, with the private key
      as ``private.key`` and public certificate as ``public.crt``.

      Create a subfolder in ``\certs`` for each additional domain for which
      MinIO should present TLS certificates. While MinIO has no requirements for
      folder names, consider creating subfolders whose name matches the domain
      to improve human readability. Place the TLS private and public key for
      that domain in the subfolder.

      For example:

      .. code-block:: shell

         %%USERPROFILE%%\.minio\certs
           private.key
           public.cert
           s3-example.net\
             private.key
             public.cert
           internal-example.net\
             private.key
             public.cert

.. admonition:: MinIO Console TLS Connectivity
   :class: important

   The :ref:`MinIO Console <minio-console>` automatically connects via
   TLS if the MinIO server supports it. However, the Console *by default*
   attempts to connect using the IP address of the MinIO Server.

   The MinIO Console may fail to connect and throw login errors if this IP
   address is not included as a 
   :rfc:`Subject Alternative Name <5280#section-4.2.1.6>` in any configured 
   TLS certificate.

   Set the :envvar:`MINIO_SERVER_URL` environment variable to a resolvable 
   DNS hostname covered by one of the configured TLS SANs. This allows
   the Console to properly validate the certificate and connect to MinIO.

Supported TLS Cipher Suites
---------------------------

MinIO supports the following TLS 1.2 and 1.3 cipher suites as
supported by 
`Go <https://cs.opensource.google/go/go/+/refs/tags/go1.17.1:src/crypto/tls/cipher_suites.go;l=52>`__

.. list-table::
   :header-rows: 1
   :widths: 60 20 20
   :width: 100%

   * - Cipher
     - TLS 1.2
     - TLS 1.3

   * - ``TLS_CHACHA20_POLY1305_SHA256``
     - 
     - :octicon:`check`

   * - ``TLS_AES_128_GCM_SHA256``
     - 
     - :octicon:`check`

   * - ``TLS_AES_256_GCM_SHA384``
     - 
     - :octicon:`check`

   * - ``TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305`` 
     - :octicon:`check`
     - 

   * - ``TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305``
     - :octicon:`check`
     - 

   * - ``TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256``
     - :octicon:`check`
     - 

   * - ``TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256``
     - :octicon:`check`
     - 

   * - ``TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384``
     - :octicon:`check`
     - 

   * - ``TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384``
     - :octicon:`check`
     - 

.. admonition:: Use ECDSA/EdDSA over RSA when when generating certificates
   :class: note

   TLS certificates created using Elliptic Curve Cryptography (ECC) have lower
   computation requirements compared to RSA. Specifically, MinIO recommends
   generating ECDSA (e.g. `NIST P-256 curve
   <https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-4.pdf>`__) or EdDSA
   (e.g. :rfc:`Curve25519 <7748>`) TLS private keys/certificates wherever
   possible.

Third-Party Certificate Authorities
-----------------------------------

MinIO by default uses the Operating System's trusted certificate store for
validating TLS certificates presented by a connecting client.

For clients connecting with certificates signed by an untrusted Certificate
Authority (CA) (e.g. self-signed, private/internal, etc.), you can provide the
necessary CA key for MinIO to explicitly trust:

MinIO by default searches an OS-specific directory for Certificate Authority
certificates. For deployments started with a custom TLS directory
:mc-cmd:`minio server --certs-dir`, use that directory instead of the
defaults.

.. tab-set::

   .. tab-item:: Linux
      :sync: linux

      MinIO looks for Certificate Authority keys in the following directory:

      .. code-block:: shell

         ${HOME}/.minio/certs/CAs

   .. tab-item:: OSX

      MinIO looks for Certificate Authority keys in the following directory:

      .. code-block:: shell

         ${HOME}/.minio/certs/CAs

   .. tab-item:: Windows

      MinIO looks for Certificate Authority keys in the following directory:

      .. code-block:: shell

         %%USERPROFILE%%\.minio\certs\CAs