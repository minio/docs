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