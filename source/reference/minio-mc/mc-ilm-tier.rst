===============
``mc ilm tier``
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm tier

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z

   :mc-cmd:`mc ilm tier` replaces ``mc admin tier``.

Description
-----------

.. start-mc-ilm-tier-desc

The :mc:`mc ilm tier` command and its subcommands configure a remote supported S3-compatible service for MinIO :ref:`Lifecycle Management: Object Transition ("Tiering") <minio-lifecycle-management-expiration>`. 

.. end-mc-ilm-tier-desc

After creating one or more tiers with this command, use :mc-cmd:`mc ilm rule` and its subcommands to create the rules that move objects to other storage.

For more information, see the overview of :ref:`lifecycle management <minio-lifecycle-management>`.

Subcommands
-----------

:mc-cmd:`mc ilm tier` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc ilm tier add`
     - .. include:: /reference/minio-mc/mc-ilm-tier-add.rst
          :start-after: start-mc-ilm-tier-add-desc
          :end-before: end-mc-ilm-tier-add-desc

   * - :mc:`~mc ilm tier check`
     - .. include:: /reference/minio-mc/mc-ilm-tier-check.rst
          :start-after: start-mc-ilm-tier-check-desc
          :end-before: end-mc-ilm-tier-check-desc

   * - :mc:`~mc ilm tier info`
     - .. include:: /reference/minio-mc/mc-ilm-tier-info.rst
          :start-after: start-mc-ilm-tier-info-desc
          :end-before: end-mc-ilm-tier-info-desc

   * - :mc:`~mc ilm tier ls`
     - .. include:: /reference/minio-mc/mc-ilm-tier-ls.rst
          :start-after: start-mc-ilm-tier-ls-desc
          :end-before: end-mc-ilm-tier-ls-desc

   * - :mc:`~mc ilm tier rm`
     - .. include:: /reference/minio-mc/mc-ilm-tier-rm.rst
          :start-after: start-mc-ilm-tier-rm-desc
          :end-before: end-mc-ilm-tier-rm-desc

   * - :mc:`~mc ilm tier update`
     - .. include:: /reference/minio-mc/mc-ilm-tier-update.rst
          :start-after: start-mc-ilm-tier-update-desc
          :end-before: end-mc-ilm-tier-update-desc


.. _minio-mc-ilm-tier-permissions:

Required Permissions
--------------------

To create tiers for object transition, MinIO requires the following administrative permissions on the cluster:

- :policy-action:`admin:SetTier`
- :policy-action:`admin:ListTier`

For example, the following policy provides permission for configuring object transition lifecycle management rules on any bucket in the cluster:

.. literalinclude:: /extra/examples/LifecycleManagementAdmin.json
   :language: json
   :class: copyable

Transition Permissions
~~~~~~~~~~~~~~~~~~~~~~

Object transition lifecycle management rules require additional permissions on the remote storage tier. 
Specifically, MinIO requires the remote tier credentials provide read, write, list, and delete permissions.
If the remote bucket is versioned, the ``s3:DeleteObjectVersion`` permission is also required.

For example, if the remote storage tier implements AWS IAM policy-based access control, the following policy provides the necessary permissions for transitioning versioned objects into and out of the remote tier:

.. literalinclude:: /extra/examples/LifecycleManagementUser.json
   :language: json
   :class: copyable

Modify the ``Resource`` for the bucket into which MinIO tiers objects.

Defer to the documentation for the supported tiering targets for more complete information on configuring users and permissions to support MinIO tiering:

- :aws-docs:`Amazon S3 Permissions <service-authorization/latest/reference/list_amazons3.html#amazons3-actions-as-permissions>`
- `Google Cloud Storage Access Control <https://cloud.google.com/storage/docs/access-control>`__
- `Authorizing access to data in Azure storage <https://docs.microsoft.com/en-us/azure/storage/common/storage-auth?toc=/azure/storage/blobs/toc.json>`__


.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-ilm-tier-add
   /reference/minio-mc/mc-ilm-tier-check
   /reference/minio-mc/mc-ilm-tier-info
   /reference/minio-mc/mc-ilm-tier-ls
   /reference/minio-mc/mc-ilm-tier-rm
   /reference/minio-mc/mc-ilm-tier-update
