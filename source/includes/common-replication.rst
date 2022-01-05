.. start-replication-encrypted-objects

MinIO supports replication of objects encrypted using :ref:`SSE-KMS <minio-encryption-sse-kms>` and :ref:`SSE-S3 <minio-encryption-sse-s3>`:

- For objects encrypted using SSE-KMS, MinIO *requires* that the target bucket support SSE-KMS encryption of objects using the *same key names* used to encrypt objects on the source bucket.

- For objects encrypted using :ref:`SSE-S3 <minio-encryption-sse-s3>`, MinIO *requires* that the target bucket also support SSE-S3 encryption of objects regardless of key name.

As part of the replication process, MinIO *decrypts* the object on the source bucket and transmits the unencrypted object over the network. The destination MinIO cluster then re-encrypts the object using the encryption settings from the source. MinIO therefore *strongly recommends* :ref:`enabling TLS <minio-TLS>` on both source and destination deployments to ensure the safety of objects during transmission.

MinIO does *not* support replicating client-side encrypted objects (SSE-C).

.. end-replication-encrypted-objects

.. start-replication-minio-only

MinIO server-side replication only works between MinIO clusters. Both the
source and destination clusters *must* run MinIO. 

To configure replication between arbitrary S3-compatible services,
use :mc-cmd:`mc mirror`.

.. end-replication-minio-only

.. start-replication-requires-versioning

MinIO relies on the immutability protections provided by :ref:`versioning <minio-bucket-versioning>` to support replication and resynchronization.

Use :mc-cmd:`mc version info` to validate the versioning status of both the healthy source and unhealthy target buckets. Use the :mc-cmd:`mc version enable` command to enable versioning as necessary.

.. end-replication-requires-versioning

.. start-replication-requires-object-locking

MinIO supports replicating objects held under :ref:`WORM Locking <minio-object-locking>`. Both replication buckets *must* have object locking enabled for MinIO to replicate the locked object. For active-active configuration, MinIO recommends using the *same* retention rules on both buckets to ensure consistent behavior across sites.

You must enable object locking during bucket creation as per S3 behavior. You can then configure object retention rules at any time. Configure the necessary rules on the unhealthy target bucket *prior* to beginning this procedure.

.. end-replication-requires-object-locking