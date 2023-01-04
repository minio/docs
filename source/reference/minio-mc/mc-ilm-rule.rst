===============
``mc ilm rule``
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm rule

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z

   The following commands have moved to subcommands under :mc-cmd:`mc ilm rule`:

   - :mc-cmd:`mc ilm add`
   - :mc-cmd:`mc ilm edit`
   - :mc-cmd:`mc ilm export`
   - :mc-cmd:`mc ilm import`
   - :mc-cmd:`mc ilm ls`
   - :mc-cmd:`mc ilm rm`


Description
-----------

.. start-mc-ilm-rule-desc

The :mc:`mc ilm rule` command and its subcommands configure the rules used to transition objects between storage tiers in MinIO's Lifecycle Management. 

.. end-mc-ilm-rule-desc

Before creating rules with this command, use :mc-cmd:`mc ilm tier` and its subcommands to create the tier or tiers of other object storage locations where objects move.

For more information, see the overview of :ref:`lifecycle management <minio-lifecycle-management>`.


Subcommands
-----------

:mc-cmd:`mc ilm rule` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc ilm rule add`
     - .. include:: /reference/minio-mc/mc-ilm-rule-add.rst
          :start-after: start-mc-ilm-rule-add-desc
          :end-before: end-mc-ilm-rule-add-desc

   * - :mc:`~mc ilm rule edit`
     - .. include:: /reference/minio-mc/mc-ilm-rule-edit.rst
          :start-after: start-mc-ilm-rule-edit-desc
          :end-before: end-mc-ilm-rule-edit-desc

   * - :mc:`~mc ilm rule export`
     - .. include:: /reference/minio-mc/mc-ilm-rule-export.rst
          :start-after: start-mc-ilm-rule-export-desc
          :end-before: end-mc-ilm-rule-export-desc

   * - :mc:`~mc ilm rule import`
     - .. include:: /reference/minio-mc/mc-ilm-rule-import.rst
          :start-after: start-mc-ilm-rule-import-desc
          :end-before: end-mc-ilm-rule-import-desc

   * - :mc:`~mc ilm rule ls`
     - .. include:: /reference/minio-mc/mc-ilm-rule-ls.rst
          :start-after: start-mc-ilm-rule-ls-desc
          :end-before: end-mc-ilm-rule-ls-desc

   * - :mc:`~mc ilm rule rm`
     - .. include:: /reference/minio-mc/mc-ilm-rule-rm.rst
          :start-after: start-mc-ilm-rule-rm-desc
          :end-before: end-mc-ilm-rule-rm-desc

.. _minio-mc-ilm-rule-permissions:

Permissions
-----------

MinIO requires the following permissions scoped to to the bucket or buckets for which you create lifecycle management rules.

- :policy-action:`s3:PutLifecycleConfiguration`
- :policy-action:`s3:GetLifecycleConfiguration`

For example, the following policy provides permission for configuring object
transition lifecycle management rules on any bucket in the cluster:.

.. literalinclude:: /extra/examples/LifecycleManagementAdmin.json
   :language: json
   :class: copyable

Transition Permissions
~~~~~~~~~~~~~~~~~~~~~~

Object transition lifecycle management rules require additional permissions
on the remote storage tier. Specifically, MinIO requires the remote
tier credentials provide read, write, list, and delete permissions.

For example, if the remote storage tier implements AWS IAM policy-based
access control, the following policy provides the necessary permission
for transitioning objects into and out of the remote tier:

.. literalinclude:: /extra/examples/LifecycleManagementUser.json
   :language: json
   :class: copyable

Modify the ``Resource`` for the bucket into which MinIO tiers objects.

Defer to the documentation for the supported tiering targets for more complete
information on configuring users and permissions to support MinIO tiering:

- :aws-docs:`Amazon S3 Permissions <service-authorization/latest/reference/list_amazons3.html#amazons3-actions-as-permissions>`
- `Google Cloud Storage Access Control <https://cloud.google.com/storage/docs/access-control>`__
- `Authorizing access to data in Azure storage <https://docs.microsoft.com/en-us/azure/storage/common/storage-auth?toc=/azure/storage/blobs/toc.json>`__

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-ilm-rule-add
   /reference/minio-mc/mc-ilm-rule-edit
   /reference/minio-mc/mc-ilm-rule-export
   /reference/minio-mc/mc-ilm-rule-import
   /reference/minio-mc/mc-ilm-rule-ls
   /reference/minio-mc/mc-ilm-rule-rm