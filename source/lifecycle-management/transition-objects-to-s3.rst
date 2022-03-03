.. _minio-lifecycle-management-transition-to-s3:

===================================
Transition Objects from MinIO to S3
===================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The procedure on this page creates a new object lifecycle management rule that
transition objects from a MinIO bucket to a remote storage tier on the Amazon
Web Services S3 storage backend *or* an S3-compatible service. This procedure
supports use cases such as tiering objects to low-cost or archival storage after
a certain time period or calendar date.

.. todo: diagram

Requirements
------------

Install and Configure ``mc``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses :mc:`mc` for performing operations on the MinIO cluster.
Install :mc:`mc` on a machine with network access to both source and destination
clusters. See the ``mc`` :ref:`Installation Quickstart <mc-install>` for
instructions on downloading and installing ``mc``.

Use the :mc:`mc alias` command to create an alias for the source MinIO cluster.
Alias creation requires specifying an access key for a user on the source and
destination clusters. The specified users must have :ref:`permissions
<minio-lifecycle-management-transition-to-s3-permissions>` for configuring and
applying transition operations.

.. _minio-lifecycle-management-transition-to-s3-permissions:

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

.. _minio-lifecycle-management-transition-to-s3-permissions-remote:

Required S3 Permissions
~~~~~~~~~~~~~~~~~~~~~~~

Object transition lifecycle management rules require additional permissions
on the remote storage tier. Specifically, MinIO requires the remote
tier credentials provide read, write, list, and delete permissions for the
remote bucket.

For example, the following policy provides the necessary permission
for transitioning objects into and out of the remote tier:

.. literalinclude:: /extra/examples/LifecycleManagementUser.json
   :language: json
   :class: copyable

Modify the ``Resource`` for the bucket into which MinIO tiers objects.

Refer to the :aws-docs:`Amazon S3 Permissions 
<service-authorization/latest/reference/list_amazons3.html#amazons3-actions-as-permissions>` 
documentation for more complete guidance on configuring the required
permissions.

Considerations
--------------

Lifecycle Management Object Scanner
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO uses a scanner process to check objects against all configured
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

.. |permissions| replace:: :ref:`permissions <minio-lifecycle-management-transition-to-s3-permissions>`

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-create-transition-user-desc
   :end-before: end-create-transition-user-desc

2) Configure the Remote Storage Tier
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin tier add` command to add an Amazon S3 service as the
new remote storage tier:

.. code-block:: shell
   :class: copyable

   mc admin tier add --s3 TARGET TIER_NAME \
      --endpoint https://HOSTNAME \
      --bucket BUCKET \
      --prefix PREFIX
      --access-key ACCESS_KEY \
      --secret-key SECRET_KEY \
      --region REGION \
      --storage-class STORAGE_CLASS

The example above uses the following arguments:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Argument
     - Description
   
   * - :mc-cmd:`TARGET <mc admin tier add TARGET>`
     - The :mc:`alias <mc alias>` of the MinIO deployment on which to configure
       the S3 remote tier.
   
   * - :mc-cmd:`TIER_NAME <mc admin tier add TIER_NAME>`
     - The name to associate with the new S3 remote storage tier. Specify the
       name in all-caps, e.g. ``S3_TIER``. This value is required in the next
       step.

   * - :mc-cmd:`HOSTNAME <mc admin tier add --endpoint>`
     - The URL endpoint for the S3 storage backend.

   * - :mc-cmd:`BUCKET <mc admin tier add --bucket>`
     - The name of the bucket on the S3 storage backend to which MinIO
       transitions objects.

   * - :mc-cmd:`PREFIX <mc admin tier add --prefix>`
     - The optional bucket prefix within which MinIO transitions objects.

       MinIO stores all transitioned objects in the specified ``BUCKET`` under a
       unique per-deployment prefix value. Omit this argument to use only that
       value for isolating and organizing data within the remote storage.

       MinIO recommends specifying this optional prefix for remote storage tiers
       which contain other data, including transitioned objects from other MinIO
       deployments. This prefix should provide a clear reference back to the
       source MinIO deployment to faciliate ease of operations related to
       diagnostics, maintenance, or disaster recovery.

   * - :mc-cmd:`ACCESS_KEY <mc admin tier add --access-key>`
     - The S3 access key MinIO uses to access the bucket. The
       access key *must* correspond to an IAM user with the 
       required 
       :ref:`permissions 
       <minio-lifecycle-management-transition-to-s3-permissions-remote>`.

   * - :mc-cmd:`SECRET_KEY <mc admin tier add --secret-key>`
     - The corresponding secret key for the specified ``ACCESS_KEY``.

   * - :mc-cmd:`REGION <mc admin tier add --region>`
     - The AWS S3 region of the specified ``BUCKET``. You can safely omit this
       option if the ``HOSTNAME`` includes the region.

   * - :mc-cmd:`STORAGE_CLASS <mc admin tier add --storage-class>`
     - The S3 storage class to which MinIO transitions objects. Specify
       one of the following supported storage classes:

       - ``STANDARD``
       - ``REDUCED``

3) Create and Apply the Transition Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-create-transition-rule-desc
   :end-before: end-create-transition-rule-desc


4) Verify the Transition Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc ilm ls` command to review the configured transition
rules:

.. code-block:: shell
   :class: copyable

   mc ilm ls ALIAS/PATH --transition

- Replace :mc-cmd:`ALIAS <mc ilm ls ALIAS>` with the :mc:`alias <mc alias>`
  of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc ilm ls ALIAS>` with the name of the bucket for
  which to retrieve the configured lifecycle management rules.
