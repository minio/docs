=====================
MinIO Server Features
=====================

MinIO’s enterprise class features represent the standard in the object storage
space. From the AWS S3 API to S3 Select and our implementations of inline
erasure coding and security, our code is widely admired and frequently copied by
some of the biggest names in technology and business.

The following table lists MinIO features and their corresponding documentation:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Feature
     - Description

   * - :doc:`Bucket Notifications </minio-features/bucket-notifications>`
     - MinIO Bucket Notifications allows you to automatically publish
       notifications to one or more configured notification targets when
       specific events occur in a bucket. 

   * - :doc:`Bucket Versioning </minio-features/bucket-versioning>`
     - MinIO Bucket Versioning supports keeping multiple "versions" of an 
       object in a single bucket. Write operations which would normally
       overwrite an existing object instead result in the creation of a new
       versioned object.

.. toctree::
   :titlesonly:
   :hidden:

   /minio-features/bucket-notifications
   /minio-features/bucket-versioning
   /minio-features/erasure-coding