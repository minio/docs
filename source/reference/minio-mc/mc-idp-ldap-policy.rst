.. _minio-mc-idp-ldap-policy:

======================
``mc idp ldap policy``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc idp ldap policy

.. versionadded:: RELEASE.2023-05-26T23-31-54Z

   :mc-cmd:`mc idp ldap policy` and its subcommands replace ``mc admin idp ldap policy``.

Description
-----------

.. start-mc-idp-ldap-policy-desc

The :mc-cmd:`mc idp ldap policy` commands show the mapping relationships between policies and the associated groups or users. 

.. end-mc-idp-ldap-policy-desc

The :mc-cmd:`mc idp ldap policy` commands are only supported against MinIO deployments.

The :mc-cmd:`mc idp ldap policy` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc idp ldap policy attach`
     - .. include:: /reference/minio-mc/mc-idp-ldap-policy-attach.rst
          :start-after: start-mc-idp-ldap-policy-attach-desc
          :end-before: end-mc-idp-ldap-policy-attach-desc

   * - :mc-cmd:`mc idp ldap policy detach`
     - .. include:: /reference/minio-mc/mc-idp-ldap-policy-detach.rst
          :start-after: start-mc-idp-ldap-policy-detach-desc
          :end-before: end-mc-idp-ldap-policy-detach-desc

   * - :mc-cmd:`mc idp ldap policy entities`
     - .. include:: /reference/minio-mc/mc-idp-ldap-policy-entities.rst
          :start-after: start-mc-idp-ldap-policy-entities-desc
          :end-before: end-mc-idp-ldap-policy-entities-desc

.. toctree::
   :titlesonly:
   :hidden:

   /reference/minio-mc/mc-idp-ldap-policy-attach
   /reference/minio-mc/mc-idp-ldap-policy-detach
   /reference/minio-mc/mc-idp-ldap-policy-entities
