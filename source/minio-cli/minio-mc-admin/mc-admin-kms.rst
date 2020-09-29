================
``mc admin kms``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin kms

Description
-----------

.. start-mc-admin-kms-desc

The :mc-cmd:`mc admin kms` command performs management operations on
a supported Key Management Service (KMS).

.. end-mc-admin-kms-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only


Syntax
------

:mc-cmd:`mc admin kms` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin kms key status TARGET KEYNAME

:mc-cmd:`mc admin kms` supports the following:

.. mc-cmd:: TARGET

   The :mc-cmd:`alias <mc alias>` of a configured MinIO server from which
   the command returns the KMS status.

.. mc-cmd:: KEYNAME

   The name of the speciific key to return.

