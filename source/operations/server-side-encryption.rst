.. _minio-sse-data-encryption:

=====================
Data Encryption (SSE)
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

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

MinIO supports the following |KMS| as the central key store:

- :ref:`HashiCorp KeyVault <minio-sse-vault>`
- :ref:`AWS SecretsManager <minio-sse-aws>`
- :ref:`Google Cloud SecretManager <minio-sse-gcp>`
- :ref:`Azure Key Vault <minio-sse-azure>`
- :minio-git:`Fortanix SDKMS <kes/wiki/Fortanix-SDKMS>`
- :minio-git:`Thales Digital Identity and Security (formerly Gemalto) <kes/wiki/Gemalto-KeySecure>`

MinIO SSE requires enabling :ref:`minio-tls`. 

Supported Encryption Types
--------------------------

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

      MinIO encrypts backend data as part of enabling server-side encryption.
      You cannot disable SSE-KMS encryption once enabled.

      SSE-KMS provides more granular and customizable encryption compared to
      SSE-S3 and SSE-C and is recommended over the other supported encryption
      methods.

      For a tutorial on enabling SSE-KMS in a local (non-production) MinIO Deployment, see :ref:`minio-encryption-sse-kms-quickstart`.

   .. tab-item:: SSE-S3
      :sync: sse-s3

      MinIO supports enabling automatic SSE-S3 encryption of all objects
      written to a bucket using an |EK| stored on the external |KMS|. MinIO
      SSE-S3 supports *one* |EK| for the entire deployment.

      For buckets without automatic SSE-S3 encryption, clients can request
      SSE encryption as part of the write operation instead.

      MinIO encrypts backend data as part of enabling server-side encryption.
      You cannot disable SSE-KMS encryption once enabled.

      For a tutorial on enabling SSE-s3 in a local (non-production) MinIO Deployment, see :ref:`minio-encryption-sse-s3-quickstart`.

   .. tab-item:: SSE-C
      :sync: sse-c

      Clients specify an |EK| as part of the write operation for an object.
      MinIO uses the specified |EK| to perform SSE-S3. 

      SSE-C does not support bucket-default encryption settings and requires
      clients perform all key management operations.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/server-side-encryption/configure-minio-kes
