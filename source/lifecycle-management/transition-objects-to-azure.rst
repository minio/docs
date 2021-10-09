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

Use the :mc:`mc alias` command to create an alias for the source MinIO cluster.
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
delete permissions for the remote bucket.

Refer to the `Azure RBAC
<https://docs.microsoft.com/en-us/azure/role-based-access-control/>`__
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

Exclusive Bucket Access
~~~~~~~~~~~~~~~~~~~~~~~

MinIO retains the minimum object metadata required to
support retrieving objects transitioned to a remote tier. MinIO therefore
*requires* exclusive access to the data on the remote storage tier. Object
retrieval assumes no external mutation, migration, or deletion of stored
objects.

MinIO also ignores any objects in the remote bucket or bucket prefix not
explicitly managed by MinIO. 

.. important::

   MinIO does *not* support changing the account name associated to an Azure
   remote tier. Azure storage backends are tied to the account, such that
   changing the account would change the storage backend and prevent access
   to any objects transitioned to the original account/backend.

   Please contact `MinIO Support <https://min.io/pricing?ref=docs>`__ if you need
   situation-specific guidance around configuring Azure remote tiers.

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

Use the :mc-cmd:`mc admin tier add` command to add a new remote storage tier:

.. code-block:: shell
   :class: copyable

   mc admin tier add azure TARGET TIER_NAME \
      --endpoint https://HOSTNAME
      --bucket BUCKET \
      --prefix PREFIX
      --account-name ACCOUNT \
      --account-key KEY \
      --region REGION


The example above uses the following arguments:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Argument
     - Description
   
   * - :mc-cmd:`TARGET <mc admin tier add TARGET>`
     - The :mc:`alias <mc alias>` of the MinIO deployment on which to configure
       the remote tier.
   
   * - :mc-cmd:`TIER_NAME <mc admin tier add TIER_NAME>`
     - The name to associate with the new :abbr:`Azure (Microsoft Azure)` blob
       remote storage tier. This value is required in the next step.

   * - :mc-cmd:`HOSTNAME <mc admin tier add endpoint>`
     - The URL endpoint for the :abbr:`Azure (Microsoft Azure)` storage
       backend.

   * - :mc-cmd:`BUCKET <mc admin tier add bucket>`
     - The name of the bucket on the :abbr:`Azure (Microsoft Azure)` storage
       backend to which MinIO transitions objects.

   * - :mc-cmd:`PREFIX <mc admin tier add prefix>`
     - The optional bucket prefix within which MinIO transitions objects.
       Omit this argument to transition objects to the bucket root.

   * - :mc-cmd:`ACCOUNT <mc admin tier add account-name>`
     - The account name MinIO uses to access the bucket. The account name
       *must* correspond to an :abbr:`Azure (Microsoft Azure)` user with the
       required :ref:`permissions
       <minio-lifecycle-management-transition-to-azure-permissions-remote>`.

       You cannot change this account name after creating the tier.

   * - :mc-cmd:`KEY <mc admin tier add account-key>`
     - The corresponding key for the specified ``ACCOUNT``.

   * - :mc-cmd:`REGION <mc admin tier add region>`
     - The :abbr:`Azure (Microsoft Azure)` blob storage region of the specified
       ``BUCKET``. You can safely omit this option if the ``HOSTNAME`` includes
       the region.

3) Create and Apply the Transition Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-create-transition-rule-desc
   :end-before: end-create-transition-rule-desc


3) Verify the Transition Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc ilm list` command to review the configured transition
rules:

.. code-block:: shell
   :class: copyable

   mc ilm list ALIAS/PATH --transition

- Replace :mc-cmd:`ALIAS <mc ilm list TARGET>` with the :mc:`alias <mc alias>`
  of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc ilm list TARGET>` with the name of the bucket for
  which to retrieve the configured lifecycle management rules.
