=================
``mc admin user``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user

Description
-----------

.. start-mc-admin-user-desc                                                                    

The :mc:`mc admin user` command manages users on a MinIO deployment.
Clients *must* authenticate to the MinIO deployment with the access key and secret key associated to a user on the deployment.
MinIO users constitute a key component in MinIO Identity and Access Management.

.. end-mc-admin-user-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only



Subcommands
-----------

:mc:`mc admin user` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc admin user add`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-add.rst
          :start-after: start-mc-admin-user-add-desc
          :end-before: end-mc-admin-user-add-desc

   * - :mc:`~mc admin user disable`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-disable.rst
          :start-after: start-mc-admin-user-disable-desc
          :end-before: end-mc-admin-user-disable-desc

   * - :mc:`~mc admin user enable`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-enable.rst
          :start-after: start-mc-admin-user-enable-desc
          :end-before: end-mc-admin-user-enable-desc

   * - :mc:`~mc admin user info`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-info.rst
          :start-after: start-mc-admin-user-info-desc
          :end-before: end-mc-admin-user-info-desc

   * - :mc:`~mc admin user list`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-list.rst
          :start-after: start-mc-admin-user-list-desc
          :end-before: end-mc-admin-user-list-desc

   * - :mc:`~mc admin user remove`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-remove.rst
          :start-after: start-mc-admin-user-remove-desc
          :end-before: end-mc-admin-user-remove-desc

   * - :mc:`~mc admin user sts`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-sts.rst
          :start-after: start-mc-admin-user-sts-desc
          :end-before: end-mc-admin-user-sts-desc

   * - :mc:`~mc admin user svcacct`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-svcacct.rst
          :start-after: start-mc-admin-user-svcacct-desc
          :end-before: end-mc-admin-user-svcacct-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc-admin/mc-admin-user-add
   /reference/minio-mc-admin/mc-admin-user-disable
   /reference/minio-mc-admin/mc-admin-user-enable
   /reference/minio-mc-admin/mc-admin-user-info
   /reference/minio-mc-admin/mc-admin-user-list
   /reference/minio-mc-admin/mc-admin-user-remove
   /reference/minio-mc-admin/mc-admin-user-sts
   /reference/minio-mc-admin/mc-admin-user-svcacct
