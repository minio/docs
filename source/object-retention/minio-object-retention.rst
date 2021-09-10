.. _minio-object-retention:

======================
MinIO Object Retention
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

By default, each new write operation to a unique object name results in
overwriting that object. You can configure MinIO to instead create
:ref:`versions <minio-bucket-versioning>` of each object mutation, preserving
the full history of that object. MinIO also supports 
:ref:`Write-Once Read-Many (WORM) locking <minio-object-locking>` versioned
objects to ensure complete immutability for a specified duration *or* until the
lock is explicitly lifted.

Both versioning and object locking features are available only with
:ref:`distributed MinIO deployments <minio-installation-comparison>`. 

.. card:: Bucket Versioning
   :link: minio-bucket-versioning
   :link-type: ref

   MinIO keeps each mutation to an object as a full "version" of that object. 

   .. image:: /images/retention/minio-versioning-multiple-versions.svg
      :width: 600px
      :alt: Bucket with multiple versions of an object
      :align: center

   Clients by default retrive the latest version of an object and can
   explicitly list and retrieve any other version in the object's history.

.. card:: WORM Object Locking
   :link: minio-object-locking
   :link-type: ref

   MinIO enforces Write-Once Read Many (WORM) immutability on versioned objects.
   Clients cannot delete a WORM-locked object until the configured locking
   rules expire or are explicitly lifted.
   
   .. image:: /images/retention/minio-object-locking.svg
      :width: 600px
      :alt: Bucket with multiple versions of an object
      :align: center

   MinIO supports setting bucket-default or per-object WORM locking rules with
   either duration-based or indefinite lock expirations. MinIO object locking is
   feature-compatible with AWS S3 object locking.

.. toctree::
   :titlesonly:
   :hidden:

   Object Versioning </concepts/bucket-versioning>
   Object Locking </object-retention/minio-object-locking>