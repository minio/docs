===================
``mc admin update``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc admin update

Description
-----------

.. start-mc-admin-update-desc

The :mc-cmd:`mc admin update` command updates all MinIO servers in the
deployment. The command also supports using a private mirror server for
environments where the deployment does not have public internet access.

.. end-mc-admin-update-desc

:mc-cmd:`mc admin update` affects *all* MinIO servers in the target deployment
at the same time. The update procedure interrupts in-progress API operations on
the MinIO deployment. Exercise caution before issuing an update command on
production environments.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Examples
--------

.. include:: /includes/play-alias-available.rst
   :start-after: myminio-alias
   :end-before: end-myminio-alias

.. code-block:: shell
   :class: copyable

   mc admin update myminio

Syntax
------

:mc-cmd:`mc admin update` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin update ALIAS [MIRROR_URL]

:mc-cmd:`mc admin update` supports the following arguments:

.. mc-cmd:: ALIAS

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment to update. 

   If the specified ``ALIAS`` corresponds to a distributed MinIO
   deployment, :mc-cmd:`mc admin update` updates *all* MinIO servers
   in the deployment at the same time. The command does not perform a 
   rolling upgrade or similar zero or near-zero downtime upgrade procedure.

   Use :mc-cmd:`mc alias list` to review the configured aliases and their
   corresponding MinIO deployment endpoints.

.. mc-cmd:: MIRROR_URL
   
   The mirror URL of the ``minio`` server binary to use for updating MinIO
   servers in the :mc-cmd:`~mc admin update ALIAS` deployment.

