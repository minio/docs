.. _minio-mc-admin-accesskey:

======================
``mc admin accesskey``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin accesskey

.. versionadded:: MinIO Client RELEASE.2024-10-08T09-37-26Z

These commands replace the MinIO IDP functionality of the :mc:`mc admin user svcacct` command and its subcommands.

Description
-----------

.. start-mc-admin-accesskey-desc

The :mc:`mc admin accesskey` command and its subcommands create and manage :ref:`Access Keys <minio-idp-service-account>` for internally managed users on a MinIO deployment.

.. end-mc-admin-accesskey-desc

Each access key is linked to a :ref:`user identity <minio-authentication-and-identity-management>` and inherits the :ref:`policies <minio-policy>` attached to its parent user *or* those groups in which the parent user has membership.
Each access key also supports an optional inline policy which further restricts access to a subset of actions and resources available to the parent user.

:mc:`mc admin user svcacct` only supports creating access keys for :ref:`MinIO-managed <minio-users>` accounts.

To create access keys for :ref:`Active Directory/LDAP-managed <minio-external-identity-management-ad-ldap>` accounts, use :mc:`mc idp ldap accesskey` and its subcommands.
To manage access keys for :ref:`OpenID Connect-managed users <minio-external-identity-management-openid>`, log into the :ref:`MinIO Console <minio-console>` and generate the access keys through the UI.

:mc:`mc admin accesskey` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc:`~mc admin accesskey create`
     - .. include:: /reference/minio-mc-admin/mc-admin-accesskey-create.rst
          :start-after: start-mc-admin-accesskey-create-desc
          :end-before: end-mc-admin-accesskey-create-desc

   * - :mc:`~mc admin accesskey disable`
     - .. include:: /reference/minio-mc-admin/mc-admin-accesskey-disable.rst
          :start-after: start-mc-admin-accesskey-disable-desc
          :end-before: end-mc-admin-accesskey-disable-desc

   * - :mc:`~mc admin accesskey edit`
     - .. include:: /reference/minio-mc-admin/mc-admin-accesskey-edit.rst
          :start-after: start-mc-admin-accesskey-edit-desc
          :end-before: end-mc-admin-accesskey-edit-desc

   * - :mc:`~mc admin accesskey enable`
     - .. include:: /reference/minio-mc-admin/mc-admin-accesskey-enable.rst
          :start-after: start-mc-admin-accesskey-enable-desc
          :end-before: end-mc-admin-accesskey-enable-desc

   * - :mc:`~mc admin accesskey info`
     - .. include:: /reference/minio-mc-admin/mc-admin-accesskey-info.rst
          :start-after: start-mc-admin-accesskey-info-desc
          :end-before: end-mc-admin-accesskey-info-desc

   * - :mc:`~mc admin accesskey ls`
     - .. include:: /reference/minio-mc-admin/mc-admin-accesskey-list.rst
          :start-after: start-mc-admin-accesskey-list-desc
          :end-before: end-mc-admin-accesskey-list-desc

   * - :mc:`~mc admin accesskey rm`
     - .. include:: /reference/minio-mc-admin/mc-admin-accesskey-remove.rst
          :start-after: start-mc-admin-accesskey-remove-desc
          :end-before: end-mc-admin-accesskey-remove-desc


.. toctree::
   :titlesonly:
   :hidden:

   /reference/minio-mc-admin/mc-admin-accesskey-create
   /reference/minio-mc-admin/mc-admin-accesskey-disable
   /reference/minio-mc-admin/mc-admin-accesskey-edit
   /reference/minio-mc-admin/mc-admin-accesskey-enable
   /reference/minio-mc-admin/mc-admin-accesskey-info
   /reference/minio-mc-admin/mc-admin-accesskey-list
   /reference/minio-mc-admin/mc-admin-accesskey-remove

