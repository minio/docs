.. _minio-encryption-sse-c:

=======================================================
Server-Side Encryption with Client-Managed Keys (SSE-C)
=======================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. |EK|  replace:: :abbr:`EK (External Key)`
.. |DEK| replace:: :abbr:`DEK (Data Encryption Key)`
.. |KEK| replace:: :abbr:`KEK (Key Encryption Key)`
.. |OEK| replace:: :abbr:`OEK (Object Encryption Key)`
.. |SSE| replace:: :abbr:`SSE (Server-Side Encryption)`
.. |KMS| replace:: :abbr:`KMS (Key Management Service)`
.. |KES| replace:: :abbr:`KES (Key Encryption Service)`

MinIO Server-Side Encryption (SSE) protects objects as part of write operations,
allowing clients to take advantage of server processing power to secure objects
at the storage layer (encryption-at-rest). SSE also provides key functionality
to regulatory and compliance requirements around secure locking and erasure.

The procedure on this page configures and enables Server-Side Encryption
with Client-Managed Keys (SSE-C). MinIO SSE-C supports client-driven
encryption of objects *before* writing the object to disk. Clients must
specify the correct key to decrypt objects for read operations.

MinIO SSE-C is functionally compatible with Amazon
:s3-docs:`Server-Side Encryption with Customer-Provided Keys
<ServerSideEncryptionCustomerKeys.html>`. 

.. _minio-encryption-sse-c-erasure-locking:

Secure Erasure and Locking
--------------------------

SSE-C protects objects using an |EK| specified by the client as part
of the write operation. Assuming the client-side key management
supports disabling or deleting these keys:

- Disabling the |EK| temporarily locks any objects encrypted using that
   |EK| by rendering them unreadable. You can later enable the |EK| to
   resume normal read operations on those objects.

- Deleting the |EK| renders all objects encrypted by that |EK|
   *permanently* unreadable. If the client-side KMS does not support
   backups of the |EK|, this process is *irreversible*.

The scope of a single |EK| depends on the number of write operations
which specified that |EK| when requesting SSE-C encryption. 

Considerations
--------------

SSE-C is Incompatible with Bucket Replication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SSE-C encrypted objects are not compatible with MinIO 
:ref:`bucket replication <minio-bucket-replication>`. Use
:ref:`SSE-KMS <minio-encryption-sse-kms>` or
:ref:`SSE-S3 <minio-encryption-sse-s3>` to ensure encrypted
objects are compatible with bucket replication.

SSE-C Overrides SSE-S3 and SSE-KMS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Encrypting an object using SSE-C prevents MinIO from applying 
:ref:`SSE-KMS <minio-encryption-sse-kms>` or
:ref:`SSE-S3 <minio-encryption-sse-s3>` encryption to that object.

Quickstart
----------

MinIO SSE-C requires the client to perform all key creation and storage
operations.

This procedure uses :mc:`mc` for performing operations on the source MinIO
deployment. Install :mc:`mc` on a machine with network access to the source
deployment. See the ``mc`` :ref:`Installation Quickstart <mc-install>` for
instructions on downloading and installing ``mc``.

The SSE-C key *must* be a 256-bit base64-encoded string. The client
application is responsible for generation and storage of the encryption key.
MinIO does *not* store SSE-C encryption keys and cannot decrypt SSE-C
encrypted objects without the client-managed key.

1) Generate the Encryption Key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generate the 256-bit base64-encoded string for use as the encryption key.

The following example generates a string that meets the encryption key
requirements. The resulting string is appropriate for non-production
environments:

.. code-block:: shell
   :class: copyable

   cat /dev/urandom | head -c 32 | base64 -

Defer to your organizations requirements for generating cryptographically
secure encryption keys.

Copy the encryption key for use in the next step.

2) Encrypt an Object using SSE-C
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports the following AWS S3 headers for specifying SSE-C encryption:

- ``X-Amz-Server-Side-Encryption-Customer-Algorithm`` set to ``AES256``.

- ``X-Amz-Server-Side-Encryption-Customer-Key`` set to the encryption key value.

- ``X-Amz-Server-Side-Encryption-Customer-Key-MD5`` to the 128-bit MD5 digest of 
  the encryption key.

The MinIO :mc:`mc` commandline tool S3-compatible SDKs include specific syntax
for setting headers. Certain :mc:`mc` commands like :mc:`mc cp` include specific
arguments for enabling SSE-S3 encryption:

.. code-block:: shell
   :class: copyable

   mc cp ~/data/mydata.json ALIAS/BUCKET/mydata.json \
      --encrypt-key "ALIAS/BUCKET/=c2VjcmV0ZW5jcnlwdGlvbmtleWNoYW5nZW1lMTIzNAo="

- Replace :mc-cmd:`ALIAS <mc encrypt set ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment on which you want to write
  the SSE-C encrypted object.

- Replace :mc-cmd:`BUCKET <mc encrypt set ALIAS>`  with the full path to the
  bucket or bucket prefix to which you want to write the SSE-C encrypted object.

3) Copy an SSE-C Encrypted Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports the following AWS S3 headers for copying an SSE-C encrypted
object to another S3-compatible service:

- ``X-Amz-Copy-Source-Server-Side-Encryption-Algorithm`` set to ``AES256``

- ``X-Amz-Copy-Source-Server-Side-Encryption-Key`` set to the encryption key 
  value. The copy operation will fail if the specified key does not match
  the key used to SSE-C encrypt the object.

- ``X-Amz-Copy-Source-Server-Side-Encryption-Key-MD5`` set to the 128-bit MD5
  digest of the encryption key.

The MinIO :mc:`mc` commandline tool S3-compatible SDKs include specific syntax
for setting headers. Certain :mc:`mc` commands like :mc:`mc cp` include specific
arguments for enabling SSE-S3 encryption:

.. code-block:: shell
   :class: copyable

   mc cp SOURCE/BUCKET/mydata.json TARGET/BUCKET/mydata.json  \
      --encrypt-key "SOURCE/BUCKET/=c2VjcmV0ZW5jcnlwdGlvbmtleWNoYW5nZW1lMTIzNAo=" \
      --encrypt-key "TARGET/BUCKET/=c2VjcmV0ZW5jcnlwdGlvbmtleWNoYW5nZW1lMTIzNAo="

- Replace :mc-cmd:`SOURCE/BUCKET <mc encrypt set ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment from which you are reading the
  encrypted object and the full path to the
  bucket or bucket prefix from which you want to read the SSE-C encrypted
  object.

- Replace :mc-cmd:`TARGET/BUCKET <mc encrypt set ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment from which you are writing the
  encrypted object and the full path to the
  bucket or bucket prefix to which you want to write the SSE-C encrypted
  object.
