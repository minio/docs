.. _minio-mc-admin-user-sts:

=====================
``mc admin user sts``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user sts

Description
-----------

.. versionadded:: RELEASE.2023-02-16T19-20-11Z

.. start-mc-admin-user-sts-desc

The :mc:`mc admin user sts` command operates on credentials generated using a :ref:`Security Token Service (STS) <minio-security-token-service>` API.

.. end-mc-admin-user-sts-desc

:abbr:`STS (Security Token Service)` credentials provide temporary access to the MinIO deployment.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

The :mc:`mc admin user sts` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc admin user sts info`
     - Retrieves information on the specified STS credential, including the parent user who generated the credentials, associated policies, and expiration.

Syntax
------

.. mc-cmd:: info
   :fullpath:

   Retrieves information on the specified STS credential, such as the parent user who generated the credentials, associated policies, and expiration.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command retrieves information on the STS credentials with specified access key:

         .. code-block:: shell
            :class: copyable

            mc admin user sts info myminio/ "J123C4ZXEQN8RK6ND35I"

      .. tab-item:: SYNTAX

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin user sts info \
               [--policy]                        \
               ALIAS                             \
               STSACCESSKEY

   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of the MinIO deployment for which the STS credentials were generated.

   .. mc-cmd:: STSACCESSKEY
      :required:

      The access key for the STS credentials.

   .. mc-cmd:: --policy
      :optional:

      Prints the policy attached to the specified STS credentials in JSON format.
