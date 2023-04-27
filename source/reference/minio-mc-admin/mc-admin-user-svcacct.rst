.. _minio-mc-admin-user-svcacct:

=========================
``mc admin user svcacct``
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct

Description
-----------

.. start-mc-admin-user-svcacct-desc

The :mc:`mc admin user svcacct` command and its subcommands create and manage :ref:`Access Keys <minio-idp-service-account>` on a MinIO deployment.

.. end-mc-admin-user-svcacct-desc

Each access key is linked to a :ref:`user identity <minio-authentication-and-identity-management>` and inherits the :ref:`policies <minio-policy>` attached to it's parent user *or* those groups in which the parent user has membership.
Each access key also supports an optional inline policy which further restricts access to a subset of actions and resources available to the parent user.

:mc:`mc admin user svcacct` only supports creating access keys for :ref:`MinIO-managed <minio-users>` and :ref:`Active Directory/LDAP-managed <minio-external-identity-management-ad-ldap>` accounts. 

To create access keys for :ref:`OpenID Connect-managed users <minio-external-identity-management-openid>`, log into the :ref:`MinIO Console <minio-console>` and generate the access keys through the UI.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

The :mc:`mc admin user svcacct` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc:`~mc admin user svcacct add`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-svcacct-add.rst
          :start-after: start-mc-admin-svcacct-add-desc
          :end-before: end-mc-admin-svcacct-add-desc

   * - :mc:`~mc admin user svcacct disable`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-svcacct-disable.rst
          :start-after: start-mc-admin-svcacct-disable-desc
          :end-before: end-mc-admin-svcacct-disable-desc

   * - :mc:`~mc admin user svcacct edit`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-svcacct-edit.rst
          :start-after: start-mc-admin-svcacct-edit-desc
          :end-before: end-mc-admin-svcacct-edit-desc

   * - :mc:`~mc admin user svcacct enable`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-svcacct-enable.rst
          :start-after: start-mc-admin-svcacct-enable-desc
          :end-before: end-mc-admin-svcacct-enable-desc

   * - :mc:`~mc admin user svcacct info`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-svcacct-info.rst
          :start-after: start-mc-admin-svcacct-info-desc
          :end-before: end-mc-admin-svcacct-info-desc

   * - :mc:`~mc admin user svcacct list`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-svcacct-list.rst
          :start-after: start-mc-admin-svcacct-list-desc
          :end-before: end-mc-admin-svcacct-list-desc

   * - :mc:`~mc admin user svcacct remove`
     - .. include:: /reference/minio-mc-admin/mc-admin-user-svcacct-remove.rst
          :start-after: start-mc-admin-svcacct-remove-desc
          :end-before: end-mc-admin-svcacct-remove-desc


.. toctree::
   :titlesonly:
   :hidden:

   /reference/minio-mc-admin/mc-admin-user-svcacct-add
   /reference/minio-mc-admin/mc-admin-user-svcacct-disable
   /reference/minio-mc-admin/mc-admin-user-svcacct-edit
   /reference/minio-mc-admin/mc-admin-user-svcacct-enable
   /reference/minio-mc-admin/mc-admin-user-svcacct-info
   /reference/minio-mc-admin/mc-admin-user-svcacct-list
   /reference/minio-mc-admin/mc-admin-user-svcacct-remove

