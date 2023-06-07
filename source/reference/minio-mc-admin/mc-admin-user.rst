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

The :mc:`mc admin user` command and its subcommands manage :ref:`MinIO users <minio-internal-idp>`.

.. end-mc-admin-user-desc

Clients *must* authenticate to the MinIO deployment with the access key and secret key associated to a user on the deployment.
MinIO users constitute a key component in MinIO Identity and Access Management.

To manage users who authenticate using a 3rd party IDP, use the command for the appropriate provider:

- For AD/LDAP, use :mc:`mc idp ldap`
- For OpenID Connect (OIDC) compatible providers, use :mc:`mc idp openid`

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

   * - :mc:`~mc admin user ls`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-list.rst
          :start-after: start-mc-admin-user-list-desc
          :end-before: end-mc-admin-user-list-desc

   * - :mc:`~mc admin user rm`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-remove.rst
          :start-after: start-mc-admin-user-remove-desc
          :end-before: end-mc-admin-user-remove-desc

   * - :mc-cmd:`sts info <mc admin user sts info>`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-sts-info.rst
          :start-after: start-mc-admin-sts-info-desc
          :end-before: end-mc-admin-sts-info-desc

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
   /reference/minio-mc-admin/mc-admin-user-sts-info
   /reference/minio-mc-admin/mc-admin-user-svcacct
