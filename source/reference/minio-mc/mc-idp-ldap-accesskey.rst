.. _minio-mc-idp-ldap-accesskey:

=========================
``mc idp ldap accesskey``
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc idp ldap accesskey

.. versionadded:: RELEASE.2023-10-30T18-43-32Z

Description
-----------

.. start-mc-idp-ldap-accesskey-desc

The :mc-cmd:`mc idp ldap accesskey` commands allow you to list, delete, or display information about LDAP access key pairs. 

.. end-mc-idp-ldap-accesskey-desc

The :mc-cmd:`mc idp ldap accesskey` commands are only supported against MinIO deployments.

.. include:: /includes/common-minio-ad-ldap-params.rst
   :start-after: start-minio-ad-ldap-accesskey-creation
   :end-before: end-minio-ad-ldap-accesskey-creation

The :mc-cmd:`mc idp ldap accesskey` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc idp ldap accesskey create`
     - .. include:: /reference/minio-mc/mc-idp-ldap-accesskey-create.rst
          :start-after: start-mc-idp-ldap-accesskey-create-desc
          :end-before: end-mc-idp-ldap-accesskey-create-desc

   * - :mc-cmd:`mc idp ldap accesskey ls`
     - .. include:: /reference/minio-mc/mc-idp-ldap-accesskey-ls.rst
          :start-after: start-mc-idp-ldap-accesskey-ls-desc
          :end-before: end-mc-idp-ldap-accesskey-ls-desc

   * - :mc-cmd:`mc idp ldap accesskey rm`
     - .. include:: /reference/minio-mc/mc-idp-ldap-accesskey-rm.rst
          :start-after: start-mc-idp-ldap-accesskey-rm-desc
          :end-before: end-mc-idp-ldap-accesskey-rm-desc

   * - :mc-cmd:`mc idp ldap accesskey info`
     - .. include:: /reference/minio-mc/mc-idp-ldap-accesskey-info.rst
          :start-after: start-mc-idp-ldap-accesskey-info-desc
          :end-before: end-mc-idp-ldap-accesskey-info-desc

.. toctree::
   :titlesonly:
   :hidden:

   /reference/minio-mc/mc-idp-ldap-accesskey-ls
   /reference/minio-mc/mc-idp-ldap-accesskey-rm
   /reference/minio-mc/mc-idp-ldap-accesskey-info
