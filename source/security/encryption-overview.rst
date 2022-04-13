.. _minio-encryption-overview:

===========================
Data and Network Encryption
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. |EK| replace:: :abbr:`EK (External Key)`
.. |SSE| replace:: :abbr:`SSE (Server-Side Encryption)`
.. |KMS| replace:: :abbr:`KMS (Key Management System)`

MinIO supports end-to-end encryption of objects over-the-wire (network 
encryption) and on read/write (at-rest). 

Server-Side Object Encryption (SSE)
-----------------------------------

MinIO supports :ref:`Server-Side Object Encryption (SSE) <minio-sse>` of
objects, where MinIO uses a secret key to encrypt and store objects on disk
(encryption at-rest).

.. tab-set::

   .. tab-item:: SSE-KMS (*Recommended*)
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

   .. tab-item:: SSE-S3
      :sync: sse-s3

      MinIO supports enabling automatic SSE-S3 encryption of all objects
      written to a bucket using an |EK| stored on the external |KMS|. MinIO
      SSE-S3 supports *one* |EK| for the entire deployment.

      For buckets without automatic SSE-S3 encryption, clients can request
      SSE encryption as part of the write operation instead.

   .. tab-item:: SSE-C
      :sync: sse-c

      Clients specify an |EK| as part of the write operation for an object.
      MinIO uses the specified |EK| to perform SSE-S3. 

      SSE-C does not support bucket-default encryption settings and requires
      clients perform all key management operations.

MinIO SSE requires :ref:`minio-tls`.

Network Encryption
------------------

MinIO supports :ref:`Transport Layer Security (TLS) <minio-tls>` encryption of
incoming and outgoing traffic. MinIO recommends all
MinIO servers run with TLS enabled to ensure end-to-end security of
client-server or server-server transmissions.

TLS is the successor to Secure Socket Layer (SSL) encryption. SSL is fully
`deprecated <https://tools.ietf.org/html/rfc7568>`__ as of June 30th, 2018. 
MinIO uses only supported (non-deprecated) TLS protocols (TLS 1.2 and later).

See :ref:`minio-tls` for more complete documentation.

.. toctree::
   :titlesonly:
   :hidden:

   /security/server-side-encryption/minio-server-side-encryption.rst
   /security/network-encryption/minio-tls.rst

