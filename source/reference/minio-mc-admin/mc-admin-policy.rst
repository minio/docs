===================
``mc admin policy``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin policy

.. versionchanged:: mc RELEASE.2023-03-20T17-17-53Z

   The following commands are deprecated:
   
   - ``mc admin policy add`` use :mc:`mc admin policy create` instead
   - ``mc admin policy set`` use :mc:`mc admin policy attach` instead
   - ``mc admin policy unset`` use :mc:`mc admin policy detach` instead
   - ``mc admin policy update`` use :mc:`~mc admin policy attach` or :mc:`~mc admin policy detach` instead

   The following command is added:

   - :mc-cmd:`mc admin policy entities`

Description
-----------

.. start-mc-admin-policy-desc

The :mc:`mc admin policy` commands manage policies for use with :ref:`MinIO Policy-Based Access Control <minio-policy>` (PBAC). 
MinIO PBAC uses IAM-compatible policy JSON documents to define rules for accessing resources on a MinIO server.

.. end-mc-admin-policy-desc

For complete documentation on MinIO PBAC, including policy document JSON structure and syntax, see :ref:`minio-policy`.

Subcommands
-----------

:mc:`mc admin policy` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc admin policy attach`
     - .. include:: /reference/minio-mc-admin/mc-admin-policy-attach.rst
          :start-after: start-mc-admin-policy-attach-desc
          :end-before: end-mc-admin-policy-attach-desc

   * - :mc:`~mc admin policy create`
     - .. include:: /reference/minio-mc-admin/mc-admin-policy-create.rst
          :start-after: start-mc-admin-policy-create-desc
          :end-before: end-mc-admin-policy-create-desc

   * - :mc:`~mc admin policy detach`
     - .. include:: /reference/minio-mc-admin/mc-admin-policy-detach.rst
          :start-after: start-mc-admin-policy-detach-desc
          :end-before: end-mc-admin-policy-detach-desc

   * - :mc:`~mc admin policy entities`
     - .. include:: /reference/minio-mc-admin/mc-admin-policy-entities.rst
          :start-after: start-mc-admin-policy-entities-desc
          :end-before: end-mc-admin-policy-entities-desc

   * - :mc:`~mc admin policy info`
     - .. include:: /reference/minio-mc-admin/mc-admin-policy-info.rst
          :start-after: start-mc-admin-policy-info-desc
          :end-before: end-mc-admin-policy-info-desc

   * - :mc:`~mc admin policy list`
     - .. include:: /reference/minio-mc-admin/mc-admin-policy-list.rst
          :start-after: start-mc-admin-policy-list-desc
          :end-before: end-mc-admin-policy-list-desc

   * - :mc:`~mc admin policy remove`
     - .. include:: /reference/minio-mc-admin/mc-admin-policy-remove.rst
          :start-after: start-mc-admin-policy-remove-desc
          :end-before: end-mc-admin-policy-remove-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc-admin/mc-admin-policy-attach
   /reference/minio-mc-admin/mc-admin-policy-create
   /reference/minio-mc-admin/mc-admin-policy-detach
   /reference/minio-mc-admin/mc-admin-policy-entities
   /reference/minio-mc-admin/mc-admin-policy-info
   /reference/minio-mc-admin/mc-admin-policy-list
   /reference/minio-mc-admin/mc-admin-policy-remove