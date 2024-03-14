====================
``mc admin service``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin service

Description
-----------

.. start-mc-admin-service-desc

The :mc-cmd:`mc admin service` command can restart or unfreeze MinIO servers.

.. end-mc-admin-service-desc

:mc-cmd:`mc admin service` affects *all* MinIO servers in the target deployment
at the same time. The command interrupts in-progress API operations on
the MinIO deployment. Use caution when issuing this command to a deployment.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Examples
--------

Restart MinIO Servers in Target Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: myminio-alias
   :end-before: end-myminio-alias

.. code-block:: shell
   :class: copyable

   mc admin service restart myminio

Resume S3 Calls on a Target Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: myminio-alias
   :end-before: end-myminio-alias

.. code-block:: shell
   :class: copyable

   mc admin service unfreeze myminio

Syntax
------

:mc-cmd:`mc admin service` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin service COMMAND [ARGUMENTS]

:mc-cmd:`mc admin service` supports the following commands:

.. mc-cmd:: restart

   Restarts MinIO servers.
   If needed, the command provides some guidance based on status about potential next steps you may need to take on each node.
   For example, if hard drives are hung, the command may suggest restarting the node's operating system.

   :mc-cmd:`mc admin service restart` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin service restart ALIAS

   Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment.
   :mc-cmd:`~mc admin service restart` restarts *all* MinIO servers in the
   deployment.

.. mc-cmd:: unfreeze

   Restart S3 API calls on a MinIO cluster.

   :mc-cmd:`mc admin service unfreeze` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin service unfreeze ALIAS

   Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment.

