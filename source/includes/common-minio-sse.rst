.. start-sse-dek

MinIO generates a Data Encryption Key (DEK) using the |EK|. 
Specifically, :minio-git:`MinIO Key Encryption Service (KES) <kes>` requests a new cryptographic key from the KMS using the |EK| as the "root" key. 

KES returns both the plain-text *and* an |EK|-encrypted representation of the DEK. 
MinIO stores the encrypted representation as part of the object metadata.

.. end-sse-dek

.. start-sse-kek

MinIO uses a deterministic algorithm to generate a 256-bit unique Key Encryption Key (KEK). 
The key-derivation algorithm uses a pseudo-random function that takes the plain-text |DEK|, a randomly generated initialization vector, and a context consisting of values like the bucket and object name.

MinIO generates the KEK at the time of each cryptographic encryption or decryption operation and *never* stores the KEK to a drive.

.. end-sse-kek

.. start-sse-oek

MinIO generates a random 256-bit unique Object Encryption Key (OEK) and uses that key to encrypt the object. 
MinIO never stores the plaintext representation of the OEK on a drive. 
The plaintext OEK resides in RAM during cryptographic operations.

.. end-sse-oek

.. start-minio-mc-sse-options

.. mc-cmd:: --enc-kms

   Encrypt or decrypt objects using server-side :ref:`SSE-KMS encryption <minio-sse>` with client-managed keys.
   
   The parameter accepts a key-value pair formatted as ``KEY=VALUE``

   .. list-table::
      :stub-columns: 1
      :widths: 30 70
      :width: 100%

      * - ``KEY``
        - The full path to the object as ``alias/bucket/path/object.ext``.

          You can specify only the top-level path to use a single encryption key for all operations in that path.

      * - ``VALUE``
        - Specify an existing data key on the external KMS.
        
          See the :mc-cmd:`mc admin kms key create` reference for creating data keys.

   For example:

   .. code-block:: shell

      --enc-kms "myminio/mybucket/prefix/object.obj=mybucketencryptionkey"

   You can specify multiple encryption keys by repeating the parameter.

   Specify the path to a prefix to apply encryption to all matching objects at that path:

   .. code-block:: shell

      --enc-kms "myminio/mybucket/prefix/mybucketencryptionkey"

.. mc-cmd:: --enc-s3
   :optional:

   Encrypt or decrypt objects using server-side :ref:`SSE-S3 encryption <minio-sse>` with KMS-managed keys.
   Specify the full path to the object as ``alias/bucket/prefix/object``.

   For example:

   .. code-block:: shell

      --enc-s3 "myminio/mybucket/prefix/object.obj"

   You can specify the parameter multiple times to denote different object(s) to encrypt:

   .. code-block:: shell

      --enc-s3 "myminio/mybucket/foo/fooobject.obj" --enc-s3 "myminio/mybucket/bar/barobject.obj"

   Specify the path to a prefix to apply encryption to all matching objects at that path:

   .. code-block:: shell

      --enc-s3 "myminio/mybucket/foo"

.. start-minio-mc-sse-c-only

.. mc-cmd:: --enc-c
   :optional:

   Encrypt or decrypt objects using server-side :ref:`SSE-C encryption <minio-sse>` with client-managed keys.
   
   The parameter accepts a key-value pair formatted as ``KEY=VALUE``

   .. list-table::
      :stub-columns: 1
      :widths: 30 70
      :width: 100%

      * - ``KEY``
        - The full path to the object as ``alias/bucket/path/object.ext``.

          You can specify only the top-level path to use a single encryption key for all operations in that path.

      * - ``VALUE``
        - Specify either a 32-byte RawBase64-encoded key *or* a 64-byte hex-encoded key for use with SSE-C encryption.
          
          Raw Base64 encoding **rejects** ``=``-padded keys.
          Omit the padding or use a Base64 encoder that supports RAW formatting.

   - ``KEY`` - the full path to the object as ``alias/bucket/path/object``.
   - ``VALUE`` - the 32-byte RAW Base64-encoded data key to use for encrypting object(s).

   For example:

   .. code-block:: shell

      # RawBase64-Encoded string "mybucket32byteecryptionkeyssec"
      --enc-c "myminio/mybucket/prefix/object.obj=bXlidWNrZXQzMmJ5dGVlbmNyeXB0aW9ua2V5c3NlYwo"

   You can specify multiple encryption keys by repeating the parameter.

   Specify the path to a prefix to apply encryption to all matching objects at that path:

   .. code-block:: shell

      --enc-c "myminio/mybucket/prefix/=bXlidWNrZXQzMmJ5dGVlbmNyeXB0aW9ua2V5c3NlYwo"

   .. note::

      MinIO strongly recommends against using SSE-C encryption in production workloads.
      Use SSE-KMS via the ``--enc-kms`` or SSE-S3 via ``--enc-s3`` parameters instead.

.. end-minio-mc-sse-options