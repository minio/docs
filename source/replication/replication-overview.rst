.. _minio-replication-overview:

====================
Replication overview
====================

Replication duplicates objects from one MinIO location to another MinIO location.
This provides a means for data backup and recovery or for geographic distribution across regions.

MinIO supports two levels of replication:

#. :ref:`Bucket Replication <minio-bucket-replication>`
#. :ref:`Site Replication <minio-site-replication-overview>`

.. note::

   MinIO also provides the :mc-cmd:`mc mirror` command.
   ``mc mirror`` is similar to bucket replication with the difference that bucket replication is between two MinIO locations.
   ``mc mirror`` duplicates objects between any two S3-compliant locations.

Bucket Replication
------------------

Bucket replication duplicates the content of a specific bucket from one MinIO location to another MinIO location.
The target location can be within a MinIO deployment or across deployments.

Bucket replication can be either ``active-active`` or ``active-passive``.

Active-active bucket replication is two-way replication where changes on either bucket are made to both buckets.

:ref:`Active-passive bucket replication <minio-bucket-replication-serverside-oneway>` is one-way replication where only changes on the origin bucket are made to the target bucket.
With active-passive bucket repliction, changes made on the target bucket do not replicate to the origin bucket.


Site Replication
----------------

:ref:`Site replication <minio-site-replication-overview>` links multiple MinIO deployments together and keeps the objects and IAM settings in sync across all connected sites.

Site replication is similar in some ways to active-active bucket replication.

However, instead of replicating a single bucket, site replication duplicates an entire MinIO deployment to one or more other deployments.
After enabling site replication, changes made on any of the peer sites replicate to each of the other sites for all buckets and objects on the sites.

Not everything replicates.
Each site maintains its own lifecycle settings and its own notifications.
This allows different teams, perhaps in different regions, to manage the data for their local site separately from other teams.

.. toctree::
   :titlesonly:
   :hidden:

   /replication/bucket-replication-overview
   /replication/site-replication-overview