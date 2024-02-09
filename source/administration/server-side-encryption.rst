.. _minio-sse:
.. _minio-encryption-overview:

=================================
Server-Side Encryption of Objects
=================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. |EK| replace:: :abbr:`EK (External Key)`
.. |SSE| replace:: :abbr:`SSE (Server-Side Encryption)`
.. |KMS| replace:: :abbr:`KMS (Key Management System)`

MinIO Server-Side Encryption (SSE) protects objects as part of write operations,
allowing clients to take advantage of server processing power to secure objects
at the storage layer (encryption-at-rest). SSE also provides key functionality
to regulatory and compliance requirements around secure locking and erasure.

MinIO SSE uses the :minio-git:`MinIO Key Encryption Service (KES) <kes>` and an
external Key Management Service (KMS) for performing secured cryptographic
operations at scale. MinIO also supports client-managed key management, where
the application takes full responsibility for creating and managing encryption
keys for use with MinIO SSE. 

MinIO SSE is feature and API compatible with 
:s3-docs:`AWS Server-Side Encryption <server-side-encryption.html>` and
supports the following encryption strategies:

.. tab-set::

   .. tab-item:: SSE-KMS *Recommended*
      :sync: sse-kms

      MinIO supports enabling automatic SSE-KMS encryption of all objects
      written to a bucket using a specific External Key (EK) stored on the
      external |KMS|. Clients can override the bucket-default |EK| by specifying
      an explicit key as part of the write operation.

      For buckets without automatic SSE-KMS encryption, clients can specify
      an |EK| as part of the write operation instead.

      SSE-KMS provides more granular and customizable encryption compared to
      SSE-S3 and SSE-C and is recommended over the other supported encryption
      methods.

      For a tutorial on enabling SSE-KMS in a local (non-production) MinIO
      Deployment, see :ref:`minio-encryption-sse-kms-quickstart`. For
      production MinIO deployments, use one of the following guides:

      - :kes-docs:`Azure Key Vault <integrations/azure-keyvault/>`
      - :kes-docs:`AWS SecretsManager <integrations/aws-secrets-manager/>`
      - :kes-docs:`Fortanix SDKMS <integrations/fortanix-sdkms/>`
      - :kes-docs:`Google Cloud SecretManager <integrations/google-cloud-secret-manager/>`
      - :kes-docs:`Hashicorp KeyVault <integrations/hashicorp-vault-keystore/>`
      - :kes-docs:`Thales Digital Identity and Security (formerly Gemalto) <integrations/thales-ciphertrust/>`

   .. tab-item:: SSE-S3
      :sync: sse-s3

      MinIO supports enabling automatic SSE-S3 encryption of all objects
      written to a bucket using an |EK| stored on the external |KMS|. MinIO
      SSE-S3 supports *one* |EK| for the entire deployment.

      For buckets without automatic SSE-S3 encryption, clients can request
      SSE encryption as part of the write operation instead.

      For a tutorial on enabling SSE-s3 in a local (non-production) MinIO
      Deployment, see :ref:`minio-encryption-sse-s3-quickstart`. For
      production MinIO deployments, use one of the following guides:

      - :kes-docs:`Azure Key Vault <integrations/azure-keyvault/>`
      - :kes-docs:`AWS SecretsManager <integrations/aws-secrets-manager/>`
      - :kes-docs:`Fortanix SDKMS <integrations/fortanix-sdkms/>`
      - :kes-docs:`Google Cloud SecretManager <integrations/google-cloud-secret-manager/>`
      - :kes-docs:`Hashicorp KeyVault <integrations/hashicorp-vault-keystore/>`
      - :kes-docs:`Thales Digital Identity and Security (formerly Gemalto) <integrations/thales-ciphertrust/>`

   .. tab-item:: SSE-C
      :sync: sse-c

      Clients specify an |EK| as part of the write operation for an object.
      MinIO uses the specified |EK| to perform SSE-S3. 

      SSE-C does not support bucket-default encryption settings and requires
      clients perform all key management operations.

MinIO SSE requires enabling :ref:`minio-tls`. 

.. _minio-encryption-sse-secure-erasure-locking:

Secure Erasure and Locking
--------------------------

MinIO requires access to the Encryption Key (EK) *and* external Key Management
System (KMS) used as part of SSE operations to decrypt an object. You can use
this dependency to securely erase and lock objects from access by disabling
access to the EK or KMS used for encryption.

General strategies include, but are not limited to:

- Seal the |KMS| such that it cannot be accessed by MinIO server anymore. This
  locks all SSE-KMS or SSE-S3 encrypted objects protected by any |EK| stored on
  the KMS. The encrypted objects remain unreadable as long as the KMS remains
  sealed.

- Seal/Unmount an |EK|. This locks all SSE-KMS or SSE-S3 encrypted objects
  protected by that EK. The encrypted objects remain unreadable as long
  as the CMK(s) remains sealed.

- Delete an |EK|. This renders all SSE-KMS or SSE-S3 encrypted objects protected
  by that EK as permanently unreadable. The combination of deleting an EK and
  deleting the data may fulfill regulatory requirements around secure deletion
  of data.

  Deleting an |EK| is typically irreversible. Exercise extreme caution
  before intentionally deleting a master key.

For more information, see:

- :ref:`SSE-KMS Secure Erasure and Locking 
  <minio-encryption-sse-kms-erasure-locking>`

- :ref:`SSE-S3 Secure Erasure and Locking
  <minio-encryption-sse-s3-erasure-locking>`

- :ref:`SSE-C Secure Erasure and Locking
  <minio-encryption-sse-c-erasure-locking>`

Encryption Internals
--------------------

.. note:: 

   The following section describes MinIO internal logic and functionality.
   This information is purely educational and is not necessary for 
   configuring or implementing any MinIO feature.

.. _minio-encryption-sse-content-encryption:

Content Encryption
~~~~~~~~~~~~~~~~~~

The MinIO server uses an authenticated encryption scheme 
(:ref:`AEAD <minio-encryption-sse-primitives>`) to en/decrypt and authenticate
the object content. The AEAD is combined with some state to build a 
**Secure Channel**. A Secure Channel is a cryptographic construction that
ensures confidentiality and integrity of the processed data. In particular, the
Secure Channel splits the plaintext content into fixed size chunks and
en/decrypts each chunk separately using an unique key-nonce combination.

The following text diagram illustrates Secure Channel Construction of an
encrypted object:

The Secure Channel splits the object content into chunks of a fixed size of
``65536`` bytes. The last chunk may be smaller to avoid adding additional
overhead and is treated specially to prevent truncation attacks. The nonce
value is ``96`` bits long and generated randomly per object / multi-part part.
The Secure Channel supports plaintexts up to ``65536 * 2^32 = 256 TiB``.

For S3 multi-part operations, each object part is en/decrypted with the Secure
Channel Construction scheme shown above. For each part, MinIO generates a secret
key derived from the Object Encryption Key (OEK) and the part number using a
pseudo-random function (:ref:`PRF <minio-encryption-sse-primitives>`), such that
``key = PRF(OEK, part_id)``.

.. _minio-encryption-sse-primitives:

Cryptographic Primitives
~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO server uses the following cryptographic primitive implementations:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - 
     - Primitives

   * - Pseudo-Random Functions (PRF) 
     - HMAC-SHA-256 

   * - :ref:`AEAD <minio-encryption-sse-content-encryption>` 
     - ``ChaCha20-Poly1305`` by default. 
     
       ``AES-256-GCM`` for x86-64 CPUs with the AES-NI extension.

.. toctree::
   :titlesonly:
   :hidden:

   /administration/server-side-encryption/server-side-encryption-sse-kms
   /administration/server-side-encryption/server-side-encryption-sse-s3
   /administration/server-side-encryption/server-side-encryption-sse-c
