=================
Object Management
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. _objects:

An :ref:`object <objects>` is binary data, sometimes referred to as a Binary Large OBject (BLOB). 
Blobs can be images, audio files, spreadsheets, or even binary executable code. 
Object Storage platforms like MinIO provide dedicated tools and capabilities for storing, retrieving, and searching for blobs. 

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

With the example structure, an administrator would create the ``/images``, ``/videos`` and ``articles`` buckets.
Client applications would write objects to those buckets using the full "path" to that object, including all intermediate :term:`prefixes <prefix>`.

MinIO supports multiple levels of nested directories and objects using prefixes to support even the most dynamic object storage workloads.
Neither clients nor administrators would manually create the intermediate prefixes, as MinIO automatically infers them from the object name.

Object Organization and Planning
--------------------------------

Administrators typically control the creation and configuration of buckets, though client applications may have access to the necessary APIs depending on their configured :ref:`policies <minio-policy>`
Client applications can then use :ref:`S3-compatible SDKs <minio-drivers>` to create, list, retrieve, and delete objects on the MinIO deployment.
Depending on the combination of policy restrictions in place, client operations drive the organization of data within a given bucket or prefix without requiring administrators to create any indexes or schemas in advance.

MinIO has no hard :ref:`thresholds <minio-server-limits>` on the number of buckets, objects, or prefixes on a given deployment.
However, the relative performance of the hardware and networking underlying the MinIO deployment may create a practical limit to the number of objects in a given prefix or bucket.
For example, a deployment using slower spinning disks on a 10GbE network is unlikely to exhibit good listing performance on a bucket or prefix with tens of millions of objects.
Generally speaking, very flat hierarchies of data tend to exacerbate existing performance limitations of the hardware/network infrastructure.

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

For buckets with versioning disabled or suspended, creating an object at a given namespace (``BUCKET/PREFIX/OBJECT.EXT``) overwrites the object permanently.
Delete operations remove the object with no possibility of recovery ("hard delete").

For buckets with versioning enabled, write operations on an existing object create a new version of that object using the write payload. 
Delete operations produce a 0-byte "Delete Marker" as the latest version of the object ("soft delete").

Client GET, HEAD, or LIST requests against a versioned object by default return only the latest object version.
MinIO omits objects with a Delete Marker from the response, such that the client effectively interprets the object as "deleted."

Clients can make an explicit request to include versioning data to return a list of all object versions, including delete markers.
Clients can also delete specific object versions to restore a previous version, including the deletion of a "Delete Marker" to "restore" an object.

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
- Delete operations which specify the version ID of a locked object result in an locking error

You *must* enable object locking during bucket creation.
Enabling bucket creation also enables :ref:`versioning <minio-bucket-versioning>`.

MinIO Object Locking provides key data retention compliance and meets SEC17a-4(f), FINRA 4511(C), and CFTC 1.31(c)-(d) requirements as per `Cohasset Associates <https://min.io/cohasset?ref=docs>`__.

See :ref:`minio-object-locking` for more complete documentation.

Object Lifecycle Management
---------------------------

MinIO Object Lifecycle Management allows creating rules for time or date based automatic transition or expiry of objects. 
For object transition, MinIO automatically moves the object to a configured remote storage tier. 
For object expiry, MinIO automatically deletes the object.

MinIO applies lifecycle management rules on :ref:`versioned and unversioned buckets <minio-bucket-versioning>` using the same behavior as normal client operations.
You can specify transition or lifecycle rules that handle either or both the latest object versions and prior object versions.

MinIO lifecycle management is built for behavior and syntax compatibility with :s3-docs:`AWS S3 Lifecycle Management <object-lifecycle-mgmt.html>`. 
For example, you can export S3 lifecycle management rules and import them into MinIO or vice-versa. 
MinIO uses JSON to describe lifecycle management rules, and conversion to or from XML may be required. 

See :ref:`minio-lifecycle-management` for more complete documentation.

.. toctree::
   :titlesonly:
   :hidden:

   /administration/object-management/object-versioning
   /administration/object-management/object-retention
   /administration/object-management/object-lifecycle-management