=================
Object Management
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. _objects:

An :ref:`object <objects>` is binary data, such as images, audio files, spreadsheets, or even binary executable code. 
The term "Binary Large Object" or "blob" is sometimes associated to object storage, although blobs can be anywhere from a few bytes to several terabytes in size.
Object Storage platforms like MinIO provide dedicated tools and capabilities for storing, listing, and retrieving objects using a standard S3-compatible API. 

.. _buckets:

MinIO Object Storage uses :ref:`buckets <buckets>` to organize objects. 
A bucket is similar to a folder or directory in a filesystem, where each bucket can hold an arbitrary number of objects.

The structure of objects on the MinIO server might look similar to the
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

With the example structure, an administrator would create the ``/images``, ``/videos`` and ``/articles`` buckets.
Client applications write objects to those buckets using the full "path" to that object, including all intermediate :term:`prefixes <prefix>`.

MinIO supports multiple levels of nested directories and objects using prefixes to support even the most dynamic object storage workloads.
MinIO automatically infers the intermediate prefixes, such as ``/articles/john.doe`` from the full object path using ``/`` as a delimiter. 
Clients and administrators should not create these prefixes manually.

Neither clients nor administrators would manually create the intermediate prefixes, as MinIO automatically infers them from the object name.

Object Organization and Planning
--------------------------------

Administrators typically control the creation and configuration of buckets.
Client applications can then use :ref:`S3-compatible SDKs <minio-drivers>` to create, list, retrieve, and delete objects on the MinIO deployment.
Client's therefore drive the overall hierarchy of data within a given bucket or prefix, where Administrators can exercise control using :ref:`policies <minio-policy>` to grant or deny access to an action or resource.

MinIO has no hard :ref:`thresholds <minio-server-limits>` on the number of buckets, objects, or prefixes on a given deployment.
The relative performance of the hardware and networking underlying the MinIO deployment may create a practical limit to the number of objects in a given prefix or bucket.
Specifically, hardware using slower drives or network infrastructures tend to exhibit poor performance in buckets or prefixes with a flat hierarchy of objects.

Consider the following points as general guidance for client applications workload patterns:

- Deployments with modest or budget-focused hardware should architect their workloads to target 10,000 objects per prefix as a baseline. 
  Increase this target based on benchmarking and monitoring of real world workloads up to what the hardware can meaningfully handle. 
- Deployments with high-performance or enterprise-grade :ref:`hardware <deploy-minio-distributed-recommendations>` can typically handle prefixes with millions of objects or more.

|SUBNET| Enterprise accounts can utilize yearly architecture reviews as part of the deployment and maintenance strategy to ensure long-term performance and success of your MinIO-dependent projects.

For a deeper discussion on the benefits of limiting prefix contents, see the article on :s3-docs:`optimizing S3 performance <optimizing-performance.html>`.

Object Versioning
----------------- 

MinIO supports keeping multiple "versions" of an object in a single bucket. 

.. image:: /images/retention/minio-versioning-multiple-versions.svg
   :alt: Object with Multiple Versions
   :align: center

The specific client behavior on write, list, get, or delete operations on a bucket depends on the versioning state of that bucket:

.. list-table::
   :stub-columns: 1
   :header-rows: 1
   :widths: 20 40 40
   :width: 100%

   * - Operation
     - Versioning Enabled
     - Versioning Disabled | Suspended

   * - ``PUT`` (Write)
     - Create a new full version of the object as the "latest" and assign a unique version ID
     - Create the object with overwrite on namespace match.

   * - ``GET`` (Read)
     - Retrieve the latest version of the object by default

       Supports retrieving a specific object by version ID.
     - Retrieve the object

   * - ``LIST`` (Read)
     - Retrieve the latest version of objects at the specified bucket or prefix

       Supports retrieving all objects with their associated version ID.
     - Retrieve all objects at the specified bucket or prefix

   * - ``DELETE`` (Write)
     - Creates a 0-byte "Delete Marker" for the object as "latest" (soft delete)

       Supports deleting a specific object by version ID (hard delete).
       You cannot undo hard-delete operations.
     - Deletes the object

See :ref:`minio-bucket-versioning` for more complete documentation.

Object Retention
----------------

MinIO Object Locking ("Object Retention") enforces Write-Once Read-Many (WORM) immutability to protect :ref:`versioned objects <minio-bucket-versioning>` from deletion. 
MinIO supports both :ref:`duration based object retention <minio-object-locking-retention-modes>` and :ref:`indefinite Legal Hold retention <minio-object-locking-legalhold>`.

.. image:: /images/retention/minio-object-locking.svg
   :alt: 30 Day Locked Objects
   :align: center
   :width: 600px

Delete operations against a WORM-locked object depend on the specific operation:

- Delete operations which do not specify a version ID result in the creation of a "Delete Marker"
- Delete operations which specify the version ID of a locked object result in a WORM locking error

You can only enable object locking when first creating a bucket.
Enabling bucket locking also enables :ref:`versioning <minio-bucket-versioning>`.

MinIO Object Locking provides key data retention compliance and meets SEC17a-4(f), FINRA 4511(C), and CFTC 1.31(c)-(d) requirements as per `Cohasset Associates <https://min.io/cohasset?ref=docs>`__.

See :ref:`minio-object-locking` for more complete documentation.

Object Lifecycle Management
---------------------------

MinIO Object Lifecycle Management allows creating rules for time or date based automatic transition or expiry of objects. 
For object transition, MinIO automatically moves the object to a configured remote storage tier. 
For object expiry, MinIO automatically deletes the object.

MinIO applies lifecycle management rules on :ref:`versioned and unversioned buckets <minio-bucket-versioning>` using the same behavior as normal client operations.
You can specify transition or lifecycle rules that handle the latest object versions, non-current object versions, or both.

MinIO lifecycle management is built for behavior and syntax compatibility with :s3-docs:`AWS S3 Lifecycle Management <object-lifecycle-mgmt.html>`. 
MinIO uses JSON to describe lifecycle management rules.
Conversion to or from XML may be required for importing rules created on S3 or similar compatible platforms. 

See :ref:`minio-lifecycle-management` for more complete documentation.

.. toctree::
   :titlesonly:
   :hidden:

   /administration/object-management/object-versioning
   /administration/object-management/object-retention
   /administration/object-management/object-lifecycle-management