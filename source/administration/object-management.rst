=================
Object Management
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. _objects:

An :ref:`object <objects>` is binary data, sometimes referred to as a Binary
Large OBject (BLOB). Blobs can be images, audio files, spreadsheets, or even
binary executable code. Object Storage platforms like MinIO provide dedicated
tools and capabilities for storing, retrieving, and searching for blobs. 

.. _buckets:

MinIO Object Storage uses :ref:`buckets <buckets>` to organize objects. 
A bucket is similar to a folder or directory in a filesystem, where each
bucket can hold an arbitrary number of objects. MinIO buckets provide the 
same functionality as AWS S3 buckets.

For example, consider an application that hosts a web blog. The application
needs to store a variety of blobs, including rich multimedia like videos and
images. The structure of objects on the MinIO server might look similar to the
following:

.. code-block:: text

   / #root
   /images/
      2020-01-02-MinIO-Diagram.png
      2020-01-03-MinIO-Advanced-Deployment.png
      MinIO-Logo.png
   /videos/
      2020-01-04-MinIO-Interview.mp4
   /articles/
      /john.doe/
         2020-01-02-MinIO-Object-Storage.md
         2020-01-02-MinIO-Object-Storage-comments.json
      /jane.doe/
         2020-01-03-MinIO-Advanced-Deployment.png
         2020-01-02-MinIO-Advanced-Deployment-comments.json
         2020-01-04-MinIO-Interview.md

MinIO supports multiple levels of nested directories and objects to support 
even the most dynamic object storage workloads.

Object Versioning
-----------------

MinIO supports keeping multiple "versions" of an object in a single bucket. 
Write operations which would normally overwrite an existing object instead result in the creation of a new versioned object. 

.. image:: /images/retention/minio-versioning-multiple-versions.svg
   :alt: Object with Multiple Versions
   :align: center

MinIO versioning protects from unintended overwrites and deletions while providing support for "undoing" a write operation.

See :ref:`minio-bucket-versioning` for more complete documentation.

Object Retention
----------------

MinIO Object Locking ("Object Retention") enforces Write-Once Read-Many (WORM) immutability to protect :ref:`versioned objects <minio-bucket-versioning>` from deletion. 
MinIO supports both :ref:`duration based object retention <minio-object-locking-retention-modes>` and :ref:`indefinite Legal Hold retention <minio-object-locking-legalhold>`.

.. image:: /images/retention/minio-object-locking.svg
   :alt: 30 Day Locked Objects
   :align: center
   :width: 600px

See :ref:`minio-object-locking` for more complete documentation.

MinIO Object Locking provides key data retention compliance and meets SEC17a-4(f), FINRA 4511(C), and CFTC 1.31(c)-(d) requirements as per `Cohasset Associates <https://min.io/cohasset?ref=docs>`__.

Object Lifecycle Management
---------------------------

MinIO Object Lifecycle Management allows creating rules for time or date
based automatic transition or expiry of objects. For object transition,
MinIO automatically moves the object to a configured remote storage
tier. For object expiry, MinIO automatically deletes the object.

MinIO lifecycle management is built for behavior and syntax compatibility with 
:s3-docs:`AWS S3 Lifecycle Management <object-lifecycle-mgmt.html>`. For
example, you can export S3 lifecycle management rules and import them into
MinIO or vice-versa. MinIO uses JSON to describe lifecycle management rules,
and conversion to or from XML may be required. 

See :ref:`minio-lifecycle-management` for more complete documentation.

.. toctree::
   :titlesonly:
   :hidden:

   /administration/object-management/object-versioning
   /administration/object-management/object-retention
   /administration/object-management/object-lifecycle-management