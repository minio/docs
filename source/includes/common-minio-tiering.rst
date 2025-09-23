.. start-create-transition-rule-desc

Use the :mc:`mc ilm rule add` command to create a new transition rule
for the bucket. The following example configures transition after the
specified number of calendar days:

.. code-block:: shell
   :class: copyable

   mc ilm rule add ALIAS/BUCKET \
   --transition-tier TIERNAME \
   --transition-days DAYS \
   --noncurrent-transition-days NONCURRENT_DAYS
   --noncurrent-transition-tier TIERNAME

The example above specifies the following arguments:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Argument
     - Description

   * - :mc-cmd:`ALIAS <mc ilm rule add ALIAS>`
     - Specify the :mc:`alias <mc alias>` of the MinIO deployment for which
       you are creating the lifecycle management rule.

   * - :mc-cmd:`BUCKET <mc ilm rule add ALIAS>`
     - Specify the full path to the bucket for which you are
       creating the lifecycle management rule.

   * - :mc-cmd:`TIERNAME <mc ilm rule add --transition-tier>`
     - The remote storage tier to which MinIO transitions objects. 
       Specify the remote storage tier name created in the previous step.

       If you want to transition noncurrent object versions to a distinct
       remote tier, specify a different tier name for 
       :mc-cmd:`~mc ilm rule add --noncurrent-transition-tier`.

   * - :mc-cmd:`DAYS <mc ilm rule add --transition-days>`
     - The number of calendar days after which MinIO marks an object as 
       eligible for transition. Specify the number of days as an integer,
       e.g. ``30`` for 30 days.

   * - :mc-cmd:`NONCURRENT_DAYS <mc ilm rule add --noncurrent-transition-days>`
     - The number of calendar days after which MinIO marks a noncurrent
       object version as eligible for transition. MinIO specifically measures
       the time since an object *became* non-current instead of the object
       creation time. Specify the number of days as an integer,
       e.g. ``90`` for 90 days.
       
       Omit this value to ignore noncurrent object versions.

       This option has no effect on non-versioned buckets.

     
.. end-create-transition-rule-desc

.. start-create-transition-user-desc

This step creates users and policies on the MinIO deployment for supporting
lifecycle management operations. You can skip this step if the deployment
already has users with the necessary |permissions|.

The following example uses ``Alpha`` as a placeholder :mc:`alias <mc alias>` for
the MinIO deployment. Replace this value with the appropriate alias for the
MinIO deployment on which you are configuring lifecycle management rules.
Replace the password ``LongRandomSecretKey`` with a long, random, and secure
secret key as per your organizations best practices for password generation.

.. code-block:: shell
   :class: copyable

   wget -O - https://docs.min.io/community/minio-object-store/examples/LifecycleManagementAdmin.json | \
   mc admin policy create Alpha LifecycleAdminPolicy /dev/stdin
   mc admin user add Alpha alphaLifecycleAdmin LongRandomSecretKey
   mc admin policy attach Alpha LifecycleAdminPolicy --user=alphaLifecycleAdmin

This example assumes that the specified
aliases have the necessary permissions for creating policies and users
on the deployment. See :ref:`minio-users` and :ref:`MinIO Policy Based Access Control <minio-policy>` for more
complete documentation on MinIO users and policies respectively.

.. end-create-transition-user-desc

.. start-transition-bucket-access-desc

MinIO *requires* exclusive access to the transitioned data on the remote storage tier.
Object metadata on the "hot" MinIO source is strongly linked to the object data on the "warm/cold" remote tier.
MinIO cannot retrieve object data without access to the remote, nor can the remote be used to restore lost metadata on the source.

All access to the transitioned objects *must* occur through MinIO via S3 API operations only.
Manually modifying a transitioned object - whether the metadata on the "hot" MinIO tier *or* the object data on the remote "warm/cold" tier - may result in loss of that object data.

MinIO ignores any objects in the remote bucket or bucket prefix not explicitly managed by the MinIO deployment. 
Automatic transition and transparent object retrieval depend on the following assumptions:

- No external mutation, migration, or deletion of objects on the remote storage. 
- No lifecycle management rules (e.g. transition or expiration) on the remote 
  storage bucket.

MinIO stores all transitioned objects in the remote storage bucket or resource under a unique per-deployment prefix value. 
This value is not intended to support identifying the source deployment from the backend. 
MinIO supports an additional optional human-readable prefix when configuring the remote target, which may facilitate operations related to diagnostics, maintenance, or disaster recovery. 

MinIO recommends specifying this optional prefix for remote storage tiers which contain other data, including transitioned objects from other MinIO deployments.
This tutorial includes the necessary syntax for setting this prefix.

.. end-transition-bucket-access-desc

.. start-transition-data-loss-desc

MinIO tiering behavior depends on the remote storage returning objects immediately (milliseconds to seconds) upon request.
MinIO therefore *cannot* support remote storage which requires rehydration, wait periods, or manual intervention.

MinIO creates metadata for each transitioned object that identifies its location on the remote storage. 
Applications cannot trivially identify and access a transitioned object independent of MinIO.
Availability of the transitioned data therefore depends on the same core
protections that :ref:`erasure coding <minio-erasure-coding>` and distributed
deployment topologies provide for all objects on the MinIO deployment. Using
object transition does not provide any additional business continuity or
disaster recovery benefits.

Workloads that require :abbr:`BC/DR (Business Continuity/Disaster Recovery)`
protections should implement MinIO :ref:`Server-Side replication
<minio-bucket-replication-serverside>`. Replication ensures objects remains
preserved on the remote replication site, such that you can resynchronize from
the remote in the event of partial or total data loss. See
:ref:`minio-replication-behavior-resync` for more complete documentation on
using replication to recover after partial or total data loss.

.. end-transition-data-loss-desc
