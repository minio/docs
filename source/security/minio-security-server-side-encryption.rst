=============================
Server-Side Object Encryption
=============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

MinIO supports Server-Side Encryption (SSE) of objects, where the MinIO
stores objects on disk in an encrypted format. Only clients with access
to the correct secret key can decrypt and read the object. 

MinIO supports two types of SSE encryption:

SSE-C
   The server uses a secret key provided by the client to perform
   encryption and decryption. SSE-C requires TLS connectivity between
   clients and the MinIO server.

SSE-S3
   The server uses a secret key managed by a Key Management System (KMS)
   to perform encryption and decryption. SSE-S3 requires a compatible KMS
   provider accessible by the MinIO server.

Encryption Process Overview
---------------------------

The MinIO server uses three distinct keys when encrypting or decrypting an
object:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Key
     - Description

   * - External Key (EK) 
     - An external secret key used to generate additional encryption keys. 

       For SSE-C, the EK is the client-supplied secret key.

       For SSE-S3, the EK is the KMS-supplied secret key.

   * - Key Encryption Key (KEK)
     - A unique secret key deterministically generated on-demand using the EK.
       MinIO never stores the KEK on disk.

   * - Object Encryption Key (OEK) 
     - A randomly generated per-object key used to encrypt or decrypt the
       object. MinIO encrypts the OEK using the KEK and stores the encrypted
       OEK as metadata with the object.

SSE Encryption Types
--------------------

SSE with Client Provided Keys (SSE-C)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SSE-C allows S3 clients to specify an Encryption Key (EK) for encrypting or
decrypting an object stored on the MinIO server. The S3 client sends the secret
key as part of the HTTP request. For read requests with the correct secret key,
the MinIO server sends the *decrypted* object to the client applications. SSE-C
therefore *requires* TLS between the client and server to ensure end-to-end
security and protection of the secret key and any unencrypted data. While the
MinIO server never stores the client EK to disk, the client EK resides in system
RAM during the encryption or decryption process.

MinIO does not assume or require that S3 clients send a unique EK. However,
if clients use a single EK for multiple objects or buckets, the loss or
compromise of that EK *also* results in the loss or compromise of all data
encrypted with that EK.

Key Rotation
````````````

S3 clients can rotate the client EK of an existing object using an S3 ``COPY``
operation. The ``COPY`` source and destination *must* be the same, while the
request headers must contain both the current and the new client EK. For
example, the following request headers support rotating the client EK for an
object:

.. code-block:: shell
   :class: copyable

    X-Amz-Server-Side-Encryption-Customer-Key: Base64 encoded new key.
    X-Amz-Copy-Source-Server-Side-Encryption-Customer-Key: Base64 encoded current key.

Such a special COPY request is also known as S3 SSE-C key rotation.

SSE with KMS Provided Keys (SSE-S3)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SSE-S3 allows S3 clinets to encrypt or decrypt an object at the MinIO server
using an external Key Management Service (KMS). The MinIO server requires
the KMS provide the following services:

- ``GenerateKey``: The MinIO server specifies the ID of a master key to the
  KMS. The KMS then uses the master key to generate a new data key and
  returns the plain data key and the master-key encrypted data key.

- ``DecryptKey``: The MinIO server specifies the ID of a master key to the KMS
  along with an encrypted data key. The KMS uses the master key to decrypt
  the data key and return the plain data key.

The MinIO server requests a new data key from the KMS for each uploaded 
object and uses that data key as the Encryption Key (EK). MinIO stores
the encrypted EK and the master key ID as part of the object metadata.
While the MinIO server never stores the plain EK to disk, the EK resides
in system RAM during the encryption or decryption process.

Key Rotation
````````````

The MinIO server supports key rotation for SSE-S3 encrypted objects. The MinIO
server decrypts the Object Encryption Key (OEK) using the current encrypted data
key and the master key ID of the object metadata. If this succeeds, the server
requests a new data key from the KMS using the master key ID of the current
MinIO KMS configuration and re-wraps the OEK with a new KEK derived from the new
data key / EK.

<Diagram to come>

Only the root MinIO user can perform an SSE-S3 key rotation using the Admin-API via
the ``mc`` client. Refer to the ``mc admin guide`` <todo>

Secure Erasure and Locking
``````````````````````````

The MinIO server requires an available KMS to en/decrypt SSE-S3 encrypted
objects. Therefore it is possible to erase or lock some or all encrypted
objects. For example in case of a detected attack or other emergency situations
the following actions can be taken:

- Seal the KMS such that it cannot be accessed by MinIO server anymore. That
  will lock all SSE-S3 encrypted objects protected by master keys stored on the
  KMS. All these objects can not be decrypted as long as the KMS is sealed.

- Seal/Unmount one/some master keys. That will lock all SSE-S3 encrypted objects
  protected by these master keys. All these objects can not be decrypted as long
  as the key(s) are sealed.

- Delete one/some master keys. From a security standpoint, this is equal to
  erasing all SSE-S3 encrypted objects protected by these master keys. All these
  objects are lost forever as they cannot be decrypted. Especially deleting all
  master keys at the KMS is equivalent to secure erasing all SSE-S3 encrypted
  objects.

