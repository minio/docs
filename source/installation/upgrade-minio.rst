.. _minio-upgrade:

==========================
Upgrade a MinIO Deployment
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. admonition:: Test Upgrades Before Applying To Production
   :class: important

   MinIO **strongly discourages** performing blind updates to production
   clusters.  You should *always* test upgrades in a lower environment
   (dev/QA/staging) *before* applying upgrades to production deployments.

   Exercise particular caution if upgrading to a 
   :minio-git:`release <minio/releases>` that has backwards breaking changes.
   MinIO always includes warnings in release notes if a given version does
   *not* support downgrades.

   For MinIO deployments that are significantly behind latest stable 
   (6+ months), consider using 
   `MinIO SUBNET <https://min.io/pricing?ref=docs>`__ for additional support
   and guidance during the upgrade procedure.

Use the :mc-cmd:`mc admin update` command to update a :ref:`Standalone
<deploy-minio-standalone>` or :ref:`Distributed <deploy-minio-distributed>`
MinIO deployment to the latest stable :minio-git:`release <minio/releases>`.

.. code-block:: shell
   :class: copyable

   mc admin update ALIAS

Replace :mc-cmd:`ALIAS <mc admin update ALIAS>` with the
:mc-cmd:`alias <mc alias>` of the MinIO deployment.

:mc-cmd:`mc admin update` affects *all* MinIO servers in the target deployment
at the same time. The update procedure interrupts in-progress API operations on
the MinIO deployment. Exercise caution before issuing an update command on
production environments.

You can specify a custom URL for updating the MinIO deployment using a specific
MinIO server binary:

.. code-block:: shell
   :class: copyable

   mc admin update ALIAS https://minio-mirror.example.com/minio

You should upgrade your :mc:`mc` binary to match or closely follow the
MinIO server release. You can use the :mc:`mc update` command to update the
binary to the latest stable release:

.. code-block:: shell
   :class: copyable

   mc update