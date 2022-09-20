.. _minio-restore-hardware-failure-site:

=====================
Site Failure Recovery
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO can make the loss of an entire site, while significant, a relatively minor incident.
Site recovery depends on the replication option you use for the site.

.. list-table:: 
   :widths: 25 75
   :width: 100%

   * - Site Replication
     - Total restoration of IAM configurations, bucket configurations, and data from the healthy peer site(s)
   * - Bucket Replication
     - Data restoration of objects and metadata from a healthy remote location for each bucket configured for replication
   * - :mc:`mc mirror`
     - Data restoration of objects only from a healthy remote location with no versioning

Site Replication
----------------

:ref:`Site replication <minio-site-replication-overview>` keeps two or more MinIO deployments in sync with IAM policies, buckets, bucket configurations, objects, and object metadata.
If a peer site fails, such as due to a major disaster or long power outage, you can use the remaining healthy site(s) to restore the :ref:`replicable data <minio-site-replication-what-replicates>`.

The following procedure can restore data in scenarios where :ref:`site replication <minio-site-replication-overview>` was active prior to the site loss.

1. Deploy a new MinIO site using the same ``root`` credentials as used on other deployments in the site replication configuration

   You can use the original hardware, if still available, but you must first wipe any remaining data before creating the new site.
2. Configure the new site with the same Identity Provider (IDp) as the other site(s)
3. :ref:`Expand the existing site replication <minio-expand-site-replication>` by adding the newly deployed site
4. Remove the lost site from the site replication configuration

Site replication healing automatically adds IAM settings, buckets, bucket configurations, and objects from the existing site(s) to the new site with no further action required.

You cannot configure site replication if any bucket replication rules remain in place on other healthy sites.
Bucket replication is mutually exclusive with site replication.
  
If you are switching from using bucket replication to using site replication, you must first remove all bucket replication rules from the healthy site prior to setting up site replication.

Active Bucket Replication Resynchronization
-------------------------------------------

For scenarios where :ref:`bucket replication <minio-bucket-replication>` was in place prior to the failure, you can use :mc:`mc replicate resync` to restore data to a new site.
Create a new site to replace the failed deployment, then synchronize the data from an existing, healthy, bucket replication-enabled deployment to the new site.

1. Deploy a new MinIO site
2. Set up IAM and users as needed
3. On the site with data, create a new ``remote target`` using the :mc-cmd:`mc admin bucket remote add` command and record the ARN from the output
4. From the site with the data, use the :mc-cmd:`mc replicate resync start` command with the ARN from the previous command to rebuild the bucket on the new site
5. Wait for re-synchronization to complete (us :mc-cmd:`mc replicate resync status` to check)
6. Set up bucket replication rule(s) from the new MinIO site to the existing target bucket(s)
7. `(Optional)` Delete the bucket replication rules from the target deployment(s) to restore an active-passive replication scenario

Passive Bucket Replication Resynchronization
--------------------------------------------

:ref:`Bucket replication <minio-bucket-replication>` can directly restore the site contents by performing a replication from the target bucket(s) to a new MinIO site.

As a passive process, bucket replication may not perform as quickly as desired for a site recovery scenario.

Using bucket replication relies on the standard replication scanner queue, which does not take priority over other processes.
For recovery procedures with stricter SLA/SLO, use the active bucket replication process with :mc:`mc replicate resync` command as described above.

Bucket replication rules copy the object, its version ID, versions, and other metadata to the target bucket.
MinIO can restore the object with all of these attributes to a new MinIO site if bucket replication had already been in use prior to the site loss.

1. Deploy a new MinIO site
2. Set up IAM and users as needed
3. On the remaining target bucket deployment(s), create bucket replication rule(s) for each bucket to the new MinIO site
4. Wait for replication to complete
5. Set up bucket replication rule(s) from the new MinIO site to the existing target bucket(s)
6. `(Optional)` Delete the bucket replication rules from the target deployment(s) to restore an active-passive replication scenario

   Do not delete the bucket replication rules from the deployments used to recover data if you prefer to keep an active-active replication between the buckets.
   In active-active replication, changes to the objects at either location affect the objects at the other location.

Mirroring
---------

MinIO's mirroring copies an object from any S3 compatible storage system.

Mirroring only copies the latest version of each object and does not include versioning metadata, regardless of the source.
You cannot restore those attributes with this method.

Use :mc:`mc mirror` in situations where you need to restore only the latest version of an object. 
Use bucket replication or site replication where those methods were already in use if you are copying from another MinIO deployment and wish to restore the object's version history and version metadata.

1. Deploy a new MinIO site
2. Set up IAM and users as needed
3. Create buckets on the new site
4. Use the :mc:`mc cp` CLI command to copy the contents from the mirror location to the new MinIO site
