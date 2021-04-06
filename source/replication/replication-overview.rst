.. _minio-bucket-replication:

==================
Bucket Replication
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports server-side and client-side replication of objects between source
and destination buckets. MinIO offers both active-passive (one-way) and
active-active (two-way) flavors of the following replication types:

:ref:`Server-Side Bucket Replication <minio-bucket-replication-serverside>`
  Configure per-bucket rules for automatically synchronizing objects between
  buckets within the same MinIO cluster *or* between two independent MinIO
  Clusters. MinIO applies rules as part of object write operations 
  (e.g. ``PUT``) and automatically synchronizes new objects *and* object
  mutations, such as new object versions or changes to object metadata.
  
  MinIO server-side bucket replication only supports MinIO clusters for the
  remote replication target.

:ref:`Client-side Bucket Replication <minio-bucket-replication-clientside>`
  Use the :mc-cmd:`mc mirror` process to synchronize objects between buckets
  within the same S3-compatible cluster *or* between two independent
  S3-compatible clusters. Client-side replication using :mc-cmd:`mc mirror`
  supports MinIO-to-S3 and similar replication configurations.

.. _minio-bucket-replication-serverside:

Server-Side Bucket Replication
------------------------------

MinIO server-side bucket replication is an automatic bucket-level configuration
that synchronizes objects between a source and destination bucket. MinIO
server-side replication *requires* the source and destination bucket be MinIO
clusters. The source and destination bucket *may* be the same MinIO cluster *or*
two independent MinIO clusters.

For each write operation to the bucket, MinIO checks all configured replication
rules for the bucket and applies the matching rule with highest configured
priority. MinIO synchronizes new objects *and* object mutations, such as 
new object versions or changes to object metadata. This includes
metadata operations such as enabling or modifying object locking or
retention settings.

MinIO server-side bucket replication is functionally similar to Amazon S3
replication while adding the following MinIO-only features:

- Source and destination bucket names can match, supporting site-to-site
  use cases such as Splunk or Veeam BC/DR. 

- Replicate object locking and retention settings from source to destination.

- Simplified implementation than S3 bucket replication configuration, removing
  the need to configure settings like AccessControlTranslation, Metrics, and 
  SourceSelectionCriteria.

- Active-Active (Two-Way) replication of objects between source and destination
  buckets.

.. toctree::
   :hidden:
   :titlesonly:

   /replication/enable-server-side-one-way-bucket-replication
   /replication/enable-server-side-two-way-bucket-replication
   

.. _minio-bucket-replication-clientside:

Client-Side Bucket Replication
------------------------------

The :mc:`mc` command :mc-cmd:`mc mirror` supports watching a source bucket
and automatically replicating objects to a destination bucket. 

