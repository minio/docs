.. _minio-lifecycle-management-transition-to-gcs:

====================================
Transition Objects from MinIO to GCS
====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The procedure on this page creates a new object lifecycle management rule that
transition objects from a MinIO bucket to a remote storage tier on the Google
Cloud Storage backend. This procedure supports use cases like moving aged data
to low-cost public cloud storage solutions after a certain time period or
calendar date.

.. todo: diagram

Requirements
------------

Install and Configure ``mc``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses :mc:`mc` for performing operations on the MinIO cluster.
Install :mc:`mc` on a machine with network access to both source and destination
clusters. See the ``mc`` :ref:`Installation Quickstart <mc-install>` for
instructions on downloading and installing ``mc``.

Use the :mc:`mc alias set` command to create an alias for the source MinIO cluster.
Alias creation requires specifying an access key for a user on the source and
destination clusters. The specified users must have :ref:`permissions
<minio-lifecycle-management-transition-to-gcs-permissions>` for configuring and
applying transition operations.

.. _minio-lifecycle-management-transition-to-gcs-permissions:

Required MinIO Permissions
~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO requires the following permissions scoped to the bucket or buckets 
for which you are creating lifecycle management rules.

- :policy-action:`s3:PutLifecycleConfiguration`
- :policy-action:`s3:GetLifecycleConfiguration`

MinIO also requires the following administrative permissions on the cluster
in which you are creating remote tiers for object transition lifecycle
management rules:

- :policy-action:`admin:SetTier`
- :policy-action:`admin:ListTier`

For example, the following policy provides permission for configuring object
transition lifecycle management rules on any bucket in the cluster:.

.. literalinclude:: /extra/examples/LifecycleManagementAdmin.json
   :language: json
   :class: copyable

.. _minio-lifecycle-management-transition-to-gcs-permissions-remote:

Required GCS Permissions
~~~~~~~~~~~~~~~~~~~~~~~~

Object transition lifecycle management rules require additional permissions on
the remote storage tier. Specifically, MinIO requires the 
:abbr:`GCS (Google Cloud Storage)` credentials provide read, write, list, and 
delete permissions for the remote bucket.

Refer to the `GCS IAM permissions
<https://cloud.google.com/storage/docs/access-control/iam-permissions>`__
documentation for more complete guidance on configuring the required
permissions.

Remote Bucket Must Exist
~~~~~~~~~~~~~~~~~~~~~~~~

Create the remote GCS bucket *prior* to configuring lifecycle management tiers or rules using that bucket as the target.

If you set a default GCS :gcs-docs:`storage class <storage-classes>`, MinIO uses that default *if* you do not specify a :mc-cmd:`storage class <mc ilm tier add --storage-class>` when defining the remote tier.
Ensure you document the settings of both your GCS bucket and MinIO tiering configuration to avoid any potential confusion, misconfiguration, or other unexpected outcomes.

Considerations
--------------

Lifecycle Management Object Scanner
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO uses a :ref:`scanner process <minio-concepts-scanner>` to check objects against all configured
lifecycle management rules. Slow scanning due to high IO workloads or
limited system resources may delay application of lifecycle management
rules. See :ref:`minio-lifecycle-management-scanner` for more information.

Exclusive Access to Remote Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-transition-bucket-access-desc
   :end-before: end-transition-bucket-access-desc

Availability of Remote Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-transition-data-loss-desc
   :end-before: end-transition-data-loss-desc

Procedure
---------

1) Configure User Accounts and Policies for Lifecycle Management
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. |permissions| replace:: :ref:`permissions <minio-lifecycle-management-transition-to-gcs-permissions>`

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-create-transition-user-desc
   :end-before: end-create-transition-user-desc

2) Configure the Remote Storage Tier
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc ilm tier add` command to add a new Google Cloud Storage
service as the remote storage tier:

.. code-block:: shell
   :class: copyable

   mc ilm tier add gcs TARGET TIER_NAME \
      --bucket BUCKET \
      --prefix PREFIX \
      --credentials-file CREDENTIALS \
      --storage-class STORAGE_CLASS

The example above uses the following arguments:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Argument
     - Description

   * - :mc-cmd:`TARGET <mc ilm tier add TARGET>`
     - The :mc:`alias <mc alias>` of the MinIO deployment on which to configure
       the :abbr:`GCS (Google Cloud Storage)` remote tier.
   
   * - :mc-cmd:`TIER_NAME <mc ilm tier add TIER_NAME>`
     - The name to associate with the new :abbr:`GCS (Google Cloud Storage)` 
       remote storage tier. Specify the name in all-caps, e.g. ``GCS_TIER``.
       This value is required in the next step.

   * - :mc-cmd:`BUCKET <mc ilm tier add --bucket>`
     - The name of the bucket on the :abbr:`GCS (Google Cloud Storage)` storage
       backend to which MinIO transitions objects.

   * - :mc-cmd:`PREFIX <mc ilm tier add --prefix>`
     - The optional bucket prefix within which MinIO transitions objects.

       MinIO stores all transitioned objects in the specified ``BUCKET`` under a
       unique per-deployment prefix value. Omit this argument to use only that
       value for isolating and organizing data within the remote storage.

       MinIO recommends specifying this optional prefix for remote storage tiers
       which contain other data, including transitioned objects from other MinIO
       deployments. This prefix should provide a clear reference back to the
       source MinIO deployment to facilitate ease of operations related to
       diagnostics, maintenance, or disaster recovery.

   * - :mc-cmd:`CREDENTIALS <mc ilm tier add --credentials-file>`
     - The `credential file
       <https://cloud.google.com/docs/authentication/getting-started>`__ for a
       user on the remote GCS tier. The specified user credentials *must*
       correspond to a GCS user with the required
       :ref:`permissions 
       <minio-lifecycle-management-transition-to-gcs-permissions-remote>`.

   * - :mc-cmd:`STORAGE_CLASS <mc ilm tier add --storage-class>`
     - The :abbr:`GCS (Google Cloud Storage)` storage class MinIO applies to objects transitioned to the GCS bucket.

       MinIO tiering behavior depends on the remote storage returning objects immediately (milliseconds to seconds) upon request.
       MinIO therefore *cannot* support remote storage which requires rehydration, wait periods, or manual intervention.

       The following GCS storage classes meet MinIO's requirements as a remote tier:

       - ``STANDARD``
       - ``NEARLINE``
       - ``COLDLINE``

       For more information, see :gcs-docs:`GCS storage class <storage-classes>`.


3) Create and Apply the Transition Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-create-transition-rule-desc
   :end-before: end-create-transition-rule-desc


4) Verify the Transition Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc ilm rule ls` command to review the configured transition
rules:

.. code-block:: shell
   :class: copyable

   mc ilm rule ls ALIAS/PATH --transition

- Replace :mc-cmd:`ALIAS <mc ilm rule ls ALIAS>` with the :mc:`alias <mc alias>`
  of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc ilm rule ls ALIAS>` with the name of the bucket for
  which to retrieve the configured lifecycle management rules.
