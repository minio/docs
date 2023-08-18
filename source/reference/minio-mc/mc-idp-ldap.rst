.. _minio-mc-idp-ldap:

===============
``mc idp ldap``
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc idp ldap

.. versionadded:: RELEASE.2023-05-26T23-31-54Z

   :mc-cmd:`mc idp ldap` and its subcommands replace ``mc admin idp ldap``.

Description
-----------

.. start-mc-idp-ldap-desc

The :mc-cmd:`mc idp ldap` commands allow you to manage configurations to 3rd party :ref:`Active Directory or LDAP Identity and Access Management (IAM) integrations <minio-external-identity-management-ad-ldap>`.

.. end-mc-idp-ldap-desc

The :mc-cmd:`mc idp ldap` commands are an alternative to using environment variables when :ref:`setting up an AD/LDAP connection <minio-authenticate-using-ad-ldap-generic>`. They are only supported against MinIO deployments.

See :ref:`minio-external-identity-management-ad-ldap` for a tutorial on using these commands.

.. note::

   MinIO :ref:`AD/LDAP environment variables <minio-server-envvar-external-identity-management-ad-ldap>` override their corresponding configuration settings as modified or set by this command.

The :mc-cmd:`mc idp ldap` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc idp ldap add`
     - .. include:: /reference/minio-mc/mc-idp-ldap-add.rst
          :start-after: start-mc-idp-ldap-add-desc
          :end-before: end-mc-idp-ldap-add-desc

   * - :mc-cmd:`mc idp ldap disable`
     - .. include:: /reference/minio-mc/mc-idp-ldap-disable.rst
          :start-after: start-mc-idp-ldap-disable-desc
          :end-before: end-mc-idp-ldap-disable-desc

   * - :mc-cmd:`mc idp ldap enable`
     - .. include:: /reference/minio-mc/mc-idp-ldap-enable.rst
          :start-after: start-mc-idp-ldap-enable-desc
          :end-before: end-mc-idp-ldap-enable-desc

   * - :mc-cmd:`mc idp ldap info`
     - .. include:: /reference/minio-mc/mc-idp-ldap-info.rst
          :start-after: start-mc-idp-ldap-info-desc
          :end-before: end-mc-idp-ldap-info-desc

   * - :mc-cmd:`mc idp ldap ls`
     - .. include:: /reference/minio-mc/mc-idp-ldap-ls.rst
          :start-after: start-mc-idp-ldap-ls-desc
          :end-before: end-mc-idp-ldap-ls-desc

   * - :mc-cmd:`mc idp ldap policy` subcommands
     - .. include:: /reference/minio-mc/mc-idp-ldap-policy.rst
          :start-after: start-mc-idp-ldap-policy-desc
          :end-before: end-mc-idp-ldap-policy-desc

   * - :mc-cmd:`mc idp ldap rm`
     - .. include:: /reference/minio-mc/mc-idp-ldap-rm.rst
          :start-after: start-mc-idp-ldap-rm-desc
          :end-before: end-mc-idp-ldap-rm-desc

   * - :mc-cmd:`mc idp ldap update`
     - .. include:: /reference/minio-mc/mc-idp-ldap-update.rst
          :start-after: start-mc-idp-ldap-update-desc
          :end-before: end-mc-idp-ldap-update-desc


.. toctree::
   :titlesonly:
   :hidden:

   /reference/minio-mc/mc-idp-ldap-add
   /reference/minio-mc/mc-idp-ldap-disable
   /reference/minio-mc/mc-idp-ldap-enable
   /reference/minio-mc/mc-idp-ldap-info
   /reference/minio-mc/mc-idp-ldap-ls
   /reference/minio-mc/mc-idp-ldap-rm
   /reference/minio-mc/mc-idp-ldap-update

