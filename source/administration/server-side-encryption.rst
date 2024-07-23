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

MinIO Server-Side Encryption (SSE) protects objects as part of write operations, allowing clients to take advantage of server processing power to secure objects at the storage layer (encryption-at-rest). 
SSE also provides key functionality to regulatory and compliance requirements around secure locking and erasure.

MinIO SSE uses the :kes-docs:`MinIO Key Encryption Service (KES) <>` and an external Key Management Service (KMS) for performing secured cryptographic operations at scale. 
MinIO also supports client-managed key management, where the application takes full responsibility for creating and managing encryption keys for use with MinIO SSE. 

MinIO SSE is feature and API compatible with :s3-docs:`AWS Server-Side Encryption <server-side-encryption.html>` and supports the following encryption strategies:

.. tab-set::

   .. tab-item:: SSE-KMS *Recommended*
      :sync: sse-kms

      MinIO supports enabling automatic SSE-KMS encryption of all objects written to a bucket using a specific External Key (EK) stored on the external |KMS|. 
      Clients can override the bucket-default |EK| by specifying an explicit key as part of the write operation.

      For buckets without automatic SSE-KMS encryption, clients can specify an |EK| as part of the write operation instead.

      MinIO encrypts backend data as part of enabling server-side encryption.
      You cannot disable SSE-KMS encryption once enabled.

      SSE-KMS provides more granular and customizable encryption compared to SSE-S3 and SSE-C and is recommended over the other supported encryption methods.

      For a tutorial on enabling SSE-KMS in a local (non-production) MinIO Deployment, see :ref:`minio-encryption-sse-kms-quickstart`. 
      For production MinIO deployments, use one of the following guides:

      - :kes-docs:`AWS Secrets Manager <integrations/aws-secrets-manager/>`
      - :kes-docs:`Azure Key Vault <integrations/azure-keyvault/>`
      - :kes-docs:`Entrust KeyControl <integrations/entrust-keycontrol/>`
      - :kes-docs:`Fortanix SDKMS <integrations/fortanix-sdkms/>`
      - :kes-docs:`Google Cloud Secret Manager <integrations/google-cloud-secret-manager/>`
      - :kes-docs:`HashiCorp Vault Keystore <integrations/hashicorp-vault-keystore/>`
      - :kes-docs:`Thales CipherTrust Manager (formerly Gemalto KeySecure) <integrations/thales-ciphertrust/>`

   .. tab-item:: SSE-S3
      :sync: sse-s3

      MinIO supports enabling automatic SSE-S3 encryption of all objects
      written to a bucket using an |EK| stored on the external |KMS|. MinIO
      SSE-S3 supports *one* |EK| for the entire deployment.

      For buckets without automatic SSE-S3 encryption, clients can request
      SSE encryption as part of the write operation instead.

      MinIO encrypts backend data as part of enabling server-side encryption.
      You cannot disable SSE-KMS encryption once enabled.

      For a tutorial on enabling SSE-s3 in a local (non-production) MinIO
      Deployment, see :ref:`minio-encryption-sse-s3-quickstart`. For
      production MinIO deployments, use one of the following guides:

      - :kes-docs:`AWS Secrets Manager <integrations/aws-secrets-manager/>`
      - :kes-docs:`Azure Key Vault <integrations/azure-keyvault/>`
      - :kes-docs:`Entrust KeyControl <integrations/entrust-keycontrol/>`
      - :kes-docs:`Fortanix SDKMS <integrations/fortanix-sdkms/>`
      - :kes-docs:`Google Cloud Secret Manager <integrations/google-cloud-secret-manager/>`
      - :kes-docs:`HashiCorp Vault Keystore <integrations/hashicorp-vault-keystore/>`
      - :kes-docs:`Thales CipherTrust Manager (formerly Gemalto KeySecure) <integrations/thales-ciphertrust/>`

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

.. toctree::
   :titlesonly:
   :hidden:

   /administration/server-side-encryption/server-side-encryption-sse-kms
   /administration/server-side-encryption/server-side-encryption-sse-s3
   /administration/server-side-encryption/server-side-encryption-sse-c
