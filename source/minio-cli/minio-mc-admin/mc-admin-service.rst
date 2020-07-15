====================
``mc admin service``
====================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 1

.. mc:: mc admin service

Description
-----------

.. start-mc-admin-service-desc

The :mc-cmd:`mc admin service` command can restart or stop MinIO servers.

.. end-mc-admin-service-desc

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

Behavior
--------

Simultaneous Restart or Stop
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:mc-cmd:`mc admin service restart` and :mc-cmd:`mc admin service stop`
affect *all* MinIO servers in the target deployment at the same time.
The commands do not perform a rolling restart or similar zero or near-zero
downtime restart procedure. Use :mc-cmd:`mc alias list` to review the currently
configured aliases and their corresponding endpoints.

.. important::
   
   ``mc admin service restart`` and ``mc admin service stop`` interrupts
   in-progress API operations on the MinIO deployment. Exercise caution before
   issuing either command in production environments.


MinIO Deployments Only
~~~~~~~~~~~~~~~~~~~~~~

:mc-cmd:`mc admin service` is intended for use with MinIO servers only. MinIO
provides no guarantees or support for using :mc-cmd:`mc admin service` 
with other S3-compatible services.

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