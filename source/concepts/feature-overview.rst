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

   * - :doc:`Bucket Notifications </concepts/bucket-notifications>`
     - MinIO Bucket Notifications allows you to automatically publish
       notifications to one or more configured notification targets when
       specific events occur in a bucket. 

   * - :doc:`Bucket Versioning </concepts/bucket-versioning>`
     - MinIO Bucket Versioning supports keeping multiple "versions" of an 
       object in a single bucket. Write operations which would normally
       overwrite an existing object instead result in the creation of a new
       versioned object.

   * - :doc:`Erasure Coding </concepts/erasure-coding>`
     - MinIO Erasure Coding is a data redundancy and availability feature that 
       allows MinIO deployments to automatically reconstruct objects on-the-fly
       despite the loss of multiple drives or nodes on the cluster. Erasure 
       coding provides object-level healing with less overhead than adjacent 
       technologies such as RAID ro replication.

.. toctree::
   :titlesonly:
   :hidden:

   /concepts/bucket-notifications
   /concepts/bucket-versioning
   /concepts/erasure-coding