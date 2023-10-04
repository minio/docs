.. _minio-server-limits:

=====================
Thresholds and Limits
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page reflects limits and thresholds that apply to MinIO.

Refer to the :ref:`hardware <minio-hardware-checklist>` and :ref:`software <minio-software-checklists>` for related recommendations and requirements.

S3 API Limits
-------------

.. list-table::
   :header-rows: 1
   :widths: 60 40
   :width: 90%

   * - Item
     - Specification 

   * - Maximum object size
     - 50 TiB

   * - Minimum object size
     - 0 B

   * - Maximum object size per PUT operation
     - | 5 TiB for non-multipart upload
       | 50 TiB for multipart upload

   * - Maximum number of parts per upload
     - 10,000

   * - Part size range
     - 5 MiB to 5 GiB. Last part can be 0 B to 5 GiB

   * - Maximum number of parts returned per list parts request
     - 10,000

   * - Maximum number of objects returned per list objects request
     - 1,000

   * - Maximum number of multipart uploads returned per list multipart uploads request
     - 1,000

   * - Maximum length for bucket names
     - 63

   * - Maximum length for object names
     - 1024

   * - Maximum length for each ``/`` separated object name segment
     - 255

Erasure Code Limits
-------------------

.. list-table::
   :header-rows: 1
   :widths: 60 40
   :width: 90%

   * - Item
     - Specification 

   * - Maximum number of servers per cluster
     - no limit

   * - Minimum number of servers
     - 1

   * - Minimum number of drives per server when server count is 1
     - 1 (for |SNSD| deployments, which do not provide additional reliability or availability)

   * - Minimum number of drives per server when server count is 2 or more
     - 1

   * - Maximum number of drives per server
     - no limit

   * - Read quorum
     - :math:`N/2`

   * - Write quorum
     - :math:`(N/2)+1`


Unsupported S3 Bucket APIs
--------------------------

MinIO does not support the following API calls available in S3.
These APIs are either redundant or only provide functionality within AWS S3.

- ``BucketACL``, ``ObjectACL`` (use :ref:`Policies <minio-policy>`)
- ``BucketCORS`` (CORS enabled by default on all buckets for all HTTP verbs)
- ``BucketWebsite`` (use ``caddy`` or ``nginx``)
- ``BucketAnalytics``, ``BucketMetrics``, ``BucketLogging`` (use :ref:`Bucket Notifications <minio-bucket-notifications>`)
- ``BucketRequestPayment``

Object Name Limitations
-----------------------

Filesystem and Operating System Restrictions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Object Names in MinIO are restricted primarily by the local operating system and filesystem.
Windows and some other operating systems restrict file systems with certain special characters, such as ``^``, ``*``, ``|``, ``\``, ``/``, ``&``, ``"``, or ``;``.

The above list is not exhaustive and may not apply to your operating system and filesystem combination.

Consult your operating system vendor or filesystem documentation for a comprehensive list for your situation.

MinIO recommends using LInux operating system with an XFS based filesystem for production workloads.

Conflicting Objects
~~~~~~~~~~~~~~~~~~~

Objects cannot have a conflicting object as its parent.
Applications must assign non-conflicting, unique keys.

MinIO does not support a situation where an object's name is also the name of the prefix for a child object. 
For the following example operations, the second PUT operation fails because of a naming conflict with the object created by the first.

.. code-block::
   
   PUT <bucketname>/a/b/1.txt
   PUT <bucketname>/a/b

.. code-block::
   
   PUT <bucketname>/a/b
   PUT <bucketname>/a/b/1.txt
