============
Introduction
============

MinIO is a High Performance Object Storage released under Apache License v2.0.
It is API compatible with Amazon S3 cloud storage service. Use MinIO to build
high performance infrastructure for machine learning, analytics and application
data workloads.

What Is Object Storage?
-----------------------

Applications create, update, retrieve, and delete data as part of normal 
operations. MinIO provides a complete solution for managing the storage 
and access of that data as :ref:`objects <minio-object>`. Applications group
objects into one or more :ref:`buckets <minio-bucket>`. 

MinIO is fully compatible with the Amazon Web Services Simple Storage Service
(AWS S3) API. Applications using the AWS S3 API can seamlessly transition to
using a MinIO deployment for managing their application's object storage with
minimal code changes. 

Erasure Coding
--------------

MinIO Erasure Coding guarantees object retrieval as long as the deployment
has at least half of its drives operational. Specifically, the deployment
can lose `(n/2)-1` drives and still service create, retrieval, update, and 
delete operations.

For example, consider a deployment with 12 data drives. MinIO splits the
12 drive set into 6 data drives and 6 parity drives. As long as *at least* 7
drives are online, the MinIO server can guarantee retrieval of any stored
object. 

For more information on MinIO Erasure Coding, see
:ref:`minio-erasure-coding`.

Bitrot Protection
-----------------

MinIO Bitrot Protection heals objects that have degraded due to 
disk corruption. When applications request a specific object, MinIO 
automatically checks for corruption and applies a healing algorithm to 
reconstruct the object. 

For more information on MinIO Bitrot Protection, see 
:ref:`minio-bitrot-protection`.


.. toctree::
   :hidden:
   :titlesonly:

   /introduction/buckets.rst
   /introduction/objects.rst
   /introduction/deployment-topologies.rst
   /introduction/erasure-coding.rst
   /introduction/bitrot-protection.rst