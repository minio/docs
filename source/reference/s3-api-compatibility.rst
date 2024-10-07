====================
S3 API Compatibility
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page documents S3 APIs supported by MinIO Object Storage.
For reference documentation on any given API, see the corresponding documentation for Amazon S3.

.. important::

   MinIO strongly recommends using an :ref:`S3-Compatible SDK <minio-drivers>` for performing object storage operations.

Object APIs
-----------

- :s3-api:`CopyObject <API_CopyObject.html>`
- :s3-api:`DeleteObject <API_DeleteObject.html>`
- :s3-api:`DeleteObjects <API_DeleteObjects.html>`
- :s3-api:`DeleteObjectTagging <API_DeleteObjectTagging.html>`
- :s3-api:`GetObject <API_GetObject.html>`
- :s3-api:`GetObjectAttributes <API_GetObjectAttributes.html>`
- :s3-api:`GetObjectTagging <API_GetObjectTagging.html>`
- :s3-api:`HeadObject <API_HeadObject.html>`
- :s3-api:`ListObjects <API_ListObjects.html>`
- :s3-api:`ListObjectsV2 <API_ListObjectsV2.html>`
- :s3-api:`ListObjectVersions <API_ListObjectVersions.html>`
- :s3-api:`PutObject <API_PutObject.html>`
- :s3-api:`PutObjectTagging <API_PutObjectTagging.html>`
- :s3-api:`RestoreObject <API_RestoreObject.html>`
- :s3-api:`SelectObjectContent <API_SelectObjectContent.html>`

Object Locking
~~~~~~~~~~~~~~

- :s3-api:`GetObjectRetention <API_GetObjectRetention.html>`
- :s3-api:`PutObjectRetention <API_PutObjectRetention.html>`
- :s3-api:`GetObjectLegalHold <API_GetObjectLegalHold.html>`
- :s3-api:`PutObjectLegalHold <API_PutObjectLegalHold.html>`
- :s3-api:`GetObjectLockConfiguration <API_GetObjectLockConfiguration.html>`
- :s3-api:`PutObjectLockConfiguration <API_PutObjectLockConfiguration.html>`

Unsupported API Object Endpoints
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   GetObjectAcl
   PutObjectAcl

Multipart Uploads
~~~~~~~~~~~~~~~~~

- :s3-api:`AbortMultipartUpload <API_AbortMultipartUpload.html>`
- :s3-api:`CompleteMultipartUpload <API_CompleteMultipartUpload.html>`
- :s3-api:`CreateMultipartUpload <API_CreateMultipartUpload.html>`
- :s3-api:`ListMultipartUploads <API_ListMultipartUploads.html>`
- :s3-api:`ListParts <API_ListParts.html>`
- :s3-api:`UploadPart <API_UploadPart.html>`
- :s3-api:`UploadPartCopy <API_UploadPartCopy.html>`

Differences from S3 APIs for Multipart Uploads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- `ListMultipartUploads` requires exact object name as prefix
- `AbortMultipartUpload` is not supported with `PutBucketLifecycle`

Bucket APIs
-----------


- :s3-api:`CreateBucket <API_CreateBucket.html>`
- :s3-api:`DeleteBucket <API_DeleteBucket.html>`
- :s3-api:`DeleteBucketEncryption <API_DeleteBucketEncryption.html>`
- :s3-api:`DeleteBucketTagging <API_DeleteBucketTagging.html>`
- :s3-api:`GetBucketEncryption <API_GetBucketEncryption.html>`
- :s3-api:`GetBucketLocation <API_GetBucketLocation.html>`
- :s3-api:`GetBucketTagging <API_GetBucketTagging.html>`
- :s3-api:`GetBucketVersioning <API_GetBucketVersioning.html>`
- :s3-api:`HeadBucket <API_HeadBucket.html>`
- :s3-api:`ListBuckets <API_ListBuckets.html>`
- :s3-api:`ListDirectoryBuckets <API_ListDirectoryBuckets.html>`
- :s3-api:`PutBucketEncryption <API_PutBucketEncryption.html>`
- :s3-api:`PutBucketTagging <API_PutBucketTagging.html>`
- :s3-api:`PutBucketVersioning <API_PutBucketVersioning.html>`

Bucket Replication
~~~~~~~~~~~~~~~~~~

- :s3-api:`GetBucketReplication <API_GetBucketReplication.html>`
- :s3-api:`PutBucketReplication <API_PutBucketReplication.html>`
- :s3-api:`DeleteBucketReplication <API_DeleteBucketReplication.html>`

Bucket Lifecycle
~~~~~~~~~~~~~~~~

- :s3-api:`GetBucketLifecycle <API_GetBucketLifecycle.html>`
- :s3-api:`GetBucketLifecycleConfiguration <API_GetBucketLifecycleConfiguration.html>`
- :s3-api:`PutBucketLifecycle <API_PutBucketLifecycle.html>`
- :s3-api:`PutBucketLifecycleConfiguration <API_PutBucketLifecycleConfiguration.html>`
- :s3-api:`DeleteBucketLifecycle <API_DeleteBucketLifecycle.html>`

Bucket Notifications
~~~~~~~~~~~~~~~~~~~~

- :s3-api:`GetBucketNotification <API_GetBucketNotification.html>`
- :s3-api:`GetBucketNotificationConfiguration <API_GetBucketNotificationConfiguration.html>`
- :s3-api:`PutBucketNotification <API_PutBucketNotification.html>`
- :s3-api:`PutBucketNotificationConfiguration <API_PutBucketNotificationConfiguration.html>`

Bucket Policies
~~~~~~~~~~~~~~~

- :s3-api:`GetBucketPolicy <API_GetBucketPolicy.html>`
- :s3-api:`GetBucketPolicyStatus <API_GetBucketPolicyStatus.html>`
- :s3-api:`PutBucketPolicy <API_PutBucketPolicy.html>`
- :s3-api:`DeleteBucketPolicy <API_DeleteBucketPolicy.html>`

Unsupported API Bucket Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   GetBucketInventoryConfiguration
   PutBucketInventoryConfiguration
   DeleteBucketInventoryConfiguration
   PutBucketCors
   DeleteBucketCors
   GetBucketMetricsConfiguration
   PutBucketMetricsConfiguration
   DeleteBucketMetricsConfiguration
   PutBucketWebsite
   GetBucketLogging
   PutBucketLogging
   PutBucketAccelerateConfiguration
   DeleteBucketAccelerateConfiguration
   PutBucketRequestPayment
   DeleteBucketRequestPayment
   PutBucketAcl
   HeadBucketAcl
   GetPublicAccessBlock
   PutPublicAccessBlock
   DeletePublicAccessBlock
   GetBucketOwnershipControls
   PutBucketOwnershipControls
   DeleteBucketOwnershipControls
   GetBucketIntelligentTieringConfiguration
   PutBucketIntelligentTieringConfiguration
   ListBucketIntelligentTieringConfigurations
   DeleteBucketIntelligentTieringConfiguration
   GetBucketAnalyticsConfiguration
   PutBucketAnalyticsConfiguration
   ListBucketAnalyticsConfigurations
   DeleteBucketAnalyticsConfiguration
   CreateSession

MinIO alternatives for unsupported Bucket resources
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For calls to ``BucketACL`` or ``ObjectACL`` operations, use :ref:`Policies <minio-policy>`.
- Calls to ``BucketCORS`` operations are not needed because CORS is enabled by default on all buckets for all HTTP verbs.
- For calls to ``BucketWebsite`` operations, use ``caddy`` or ``nginx``.
- For calls to ``BucketAnalytics``, ``BucketMetrics``, or ``BucketLogging`` operations, use :ref:`Bucket Notifications <minio-bucket-notifications>`.
