.. _minio-replication-overview:

====================
Replication Overview
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Replication duplicates objects from one MinIO location to another MinIO location.
This provides a means for data backup and recovery or for geographic distribution across regions.

MinIO supports two types of replication:

#. :ref:`Bucket Replication <minio-bucket-replication>`
#. :ref:`Site Replication <minio-site-replication-overview>`

You can use one or the other, but not both types of replication.

.. note::

   MinIO also provides the :mc-cmd:`mc mirror` command.
   ``mc mirror`` is similar to bucket replication with the difference that bucket replication is between two MinIO locations.
   ``mc mirror`` duplicates objects between any two S3-compliant locations.

Bucket Replication
------------------

Bucket replication duplicates the content of a specific bucket from one MinIO location to another MinIO location.
The target location can be within a MinIO deployment or across deployments.

Bucket replication can be either ``active-active`` or ``active-passive``.

Active-active bucket replication is two-way replication where changes on either bucket duplicate to the other bucket.

:ref:`Active-passive bucket replication <minio-bucket-replication-serverside-oneway>` is one-way replication where only changes on the origin bucket are made to the target bucket.
With active-passive bucket repliction, changes made on the target bucket do not replicate to the origin bucket.


Site Replication
----------------

Site replication expands the features of bucket replication to include IAM, security tokens, service accounts, and bucket features the same across all sites.

:ref:`Site replication <minio-site-replication-overview>` links multiple MinIO deployments together and keeps the buckets, objects, and Identify and Access Management (IAM) settings in sync across all connected sites.

.. include:: /includes/common-replication.rst
   :start-after: start-mc-admin-replicate-what-replicates
   :end-before: end-mc-admin-replicate-what-replicates


What Does Not Replicate?
~~~~~~~~~~~~~~~~~~~~~~~~

Not everything replicates across sites.

.. include:: /includes/common-replication.rst
   :start-after: start-mc-admin-replicate-what-does-not-replicate
   :end-before: end-mc-admin-replicate-what-does-not-replicate


.. toctree::
   :titlesonly:
   :hidden:

   /replication/bucket-replication-overview
   /replication/site-replication-overview