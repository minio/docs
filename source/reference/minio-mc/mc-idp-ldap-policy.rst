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

The :mc-cmd:`mc idp ldap policy` commands allow you to view the mapping relationships between policies and the associated groups or users. The :mc-cmd:`mc idp ldap policy` commands are only supported against MinIO deployments.


.. end-mc-idp-ldap-policy-desc


The :mc-cmd:`mc idp ldap policy` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc idp ldap policy attach`
     - Attach a policy to an entity

   * - :mc-cmd:`mc idp ldap policy detach`
     - Detach a policy from an entity

   * - :mc-cmd:`mc idp ldap policy entities`
     - List policy entity mappings

.. toctree::
   :titlesonly:
   :hidden:

   /reference/minio-mc/mc-idp-ldap-policy-attach
   /reference/minio-mc/mc-idp-ldap-policy-detach
   /reference/minio-mc/mc-idp-ldap-policy-entities
