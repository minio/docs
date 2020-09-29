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

The :mc-cmd:`mc admin service` command can restart or stop MinIO servers.

.. end-mc-admin-service-desc

:mc-cmd:`mc admin service` affects *all* MinIO servers in the target deployment
at the same time. The command interrupts in-progress API operations on
the MinIO deployment. Exercise caution before issuing an update command on
production environments.


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

Stop MinIO Servers in Target Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: myminio-alias
   :end-before: end-myminio-alias

.. code-block:: shell
   :class: copyable

   mc admin service stop myminio

Syntax
------

:mc-cmd:`mc admin service` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin service COMMAND [ARGUMENTS]

:mc-cmd:`mc admin service` supports the following commands:

.. mc-cmd:: restart

   Restarts MinIO servers.

   :mc-cmd:`mc admin service restart` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin service restart TARGET

   Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment.
   :mc-cmd:`~mc admin service restart` restarts *all* MinIO servers in the
   deployment.

.. mc-cmd:: stop

   Stops MinIO servers.

   :mc-cmd:`mc admin service stop` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin service stop TARGET

   Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment.
   :mc-cmd:`~mc admin service stop` stops *all* MinIO servers in the
   deployment.

