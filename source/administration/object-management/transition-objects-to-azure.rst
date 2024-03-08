.. _minio-lifecycle-management-transition-to-azure:

======================================
Transition Objects from MinIO to Azure
======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The procedure on this page creates a new object lifecycle management rule that
transition objects from a MinIO bucket to a remote storage tier on the
:abbr:`Azure (Microsoft Azure)` storage backend. This procedure supports use
cases like moving aged data to low-cost public cloud storage solutions after a
certain time period or calendar date.

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
<minio-lifecycle-management-transition-to-azure-permissions>` for configuring
and applying transition operations.

.. _minio-lifecycle-management-transition-to-azure-permissions:

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

.. _minio-lifecycle-management-transition-to-azure-permissions-remote:

Required Azure Permissions
~~~~~~~~~~~~~~~~~~~~~~~~~~

Object transition lifecycle management rules require additional permissions on
the remote storage tier. Specifically, MinIO requires the 
:abbr:`Azure (Microsoft Azure)` credentials provide read, write, list, and
delete permissions for the remote storage account and container.

Refer to the `Azure RBAC
<https://docs.microsoft.com/en-us/azure/role-based-access-control/>`__
documentation for more complete guidance on configuring the required
permissions.

Remote Storage Account and Container Must Exist
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create the remote :azure-docs:`Azure storage account <storage/common/storage-account-overview>` and container *prior* to configuring lifecycle management tiers or rules using that resource as the target.
When :azure-docs:`creating the Azure storage account <storage/common/storage-account-create>`, ensure the storage account corresponds to either Standard or Premium blob storage with the locally redundant storage (LRS) redundancy option.
The Azure Go SDK API used by MinIO does not support any other redundancy options.

If you set a Storage Account :azure-docs:`default access tier <storage/blobs/access-tiers-online-manage>`, MinIO uses that default *if* you do not specify a :mc-cmd:`storage class <mc ilm tier add --storage-class>` when defining the remote tier.
Ensure you document the settings of both your Azure storage account and MinIO tiering configuration to avoid any potential confusion, misconfiguration, or other unexpected outcomes.

For more information on Azure storage accounts, see :azure-docs:`Storage accounts <storage/common/storage-account-overview#types-of-storage-accounts>`.

Considerations
--------------

Exclusive Access to Remote Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-transition-bucket-access-desc
   :end-before: end-transition-bucket-access-desc

.. important::

   MinIO does *not* support changing the account name associated to an Azure
   remote tier. Azure storage backends are tied to the account, such that
   changing the account would change the storage backend and prevent access
   to any objects transitioned to the original account/backend.

   Please contact `MinIO Support <https://min.io/pricing?ref=docs>`__ if you need
   situation-specific guidance around configuring Azure remote tiers.

Availability of Remote Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-transition-data-loss-desc
   :end-before: end-transition-data-loss-desc

Procedure
---------

1) Configure User Accounts and Policies for Lifecycle Management
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. |permissions| replace:: :ref:`permissions <minio-lifecycle-management-transition-to-azure-permissions>`

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-create-transition-user-desc
   :end-before: end-create-transition-user-desc

2) Configure the Remote Storage Tier
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc ilm tier add` command to add a new remote storage tier:

.. code-block:: shell
   :class: copyable

   mc ilm tier add azure TARGET TIER_NAME \
      --account-name ACCOUNT \
      --account-key KEY \
      --bucket CONTAINER \
      --endpoint ENDPOINT \
      --prefix PREFIX \
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
       the remote tier.
   
   * - :mc-cmd:`TIER_NAME <mc ilm tier add TIER_NAME>`
     - The name to associate with the new :abbr:`Azure (Microsoft Azure)` blob
       remote storage tier. Specify the name in all-caps, e.g. ``AZURE_TIER``.
       This value is required in the next step.

   * - :mc-cmd:`ACCOUNT <mc ilm tier add --account-name>`
     - The :azure-docs:`Storage Account <storage/common/storage-account-overview>` to use as the remote storage resource.

       You cannot change this account name after creating the tier.

   * - :mc-cmd:`KEY <mc ilm tier add --account-key>`
     - The corresponding shared account key for the specified ``ACCOUNT``.

       The account key must have an assigned Azure policy with the required :ref:`permissions
       <minio-lifecycle-management-transition-to-azure-permissions-remote>`.

       See :azure-docs:`Managing storage account access keys <storage/common/storage-account-keys-manage>` for more information.

   * - :mc-cmd:`CONTAINER <mc ilm tier add --bucket>`
     - The name of the container on the :abbr:`Azure (Microsoft Azure)` storage
       backend to which MinIO transitions objects.

   * - :mc-cmd:`ENDPOINT <mc ilm tier add --endpoint>`
     - (Optional) The full URL of the Azure blob storage backend to which MinIO transitions objects.  Defaults
       to ``https://ACCOUNT.blob.core.windows.net`` if not specified.

   * - :mc-cmd:`PREFIX <mc ilm tier add --prefix>`
     - The optional container prefix within which MinIO transitions objects.

       MinIO stores all transitioned objects in the specified ``BUCKET`` under a
       unique per-deployment prefix value. Omit this argument to use only that
       value for isolating and organizing data within the remote storage.

       MinIO recommends specifying this optional prefix for remote storage tiers
       which contain other data, including transitioned objects from other MinIO
       deployments. This prefix should provide a clear reference back to the
       source MinIO deployment to facilitate ease of operations related to
       diagnostics, maintenance, or disaster recovery.

   * - :mc-cmd:`STORAGE_CLASS <mc ilm tier add --storage-class>`
     - The Azure access tier MinIO applies to objects transitioned to the Azure container.

       MinIO tiering behavior depends on the remote storage returning objects immediately (milliseconds to seconds) upon request.
       MinIO therefore *cannot* support remote storage which requires rehydration, wait periods, or manual intervention.

       The following Azure access tiers meet MinIO's requirements as a remote tier:

       - ``Hot``
       - ``Cool``

       For more information, see :azure-docs:`Hot, cool, and archive access tiers for blob data <storage/blobs/access-tiers-overview.html>`.

3) Create and Apply the Transition Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-create-transition-rule-desc
   :end-before: end-create-transition-rule-desc


4) Verify the Transition Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc ilm rule ls` command to review the configured transition rules:

.. code-block:: shell
   :class: copyable

   mc ilm rule ls ALIAS/PATH --transition

- Replace :mc-cmd:`ALIAS <mc ilm rule ls ALIAS>` with the :mc:`alias <mc alias>`
  of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc ilm rule ls ALIAS>` with the name of the bucket for
  which to retrieve the configured lifecycle management rules.
