.. _minio-mc-admin-rebalance:

======================
``mc admin rebalance``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin rebalance

Permission
----------

This command requires that the user performing it have the :policy-action:`admin:Rebalance` :ref:`policy action <minio-policy>` for the deployment.

Description
-----------

.. start-mc-admin-rebalance-desc

The :mc-cmd:`mc admin rebalance` command starts, stops, or monitors a rebalancing operation on a MinIO deployment.
Rebalancing redistributes objects across all pools in the deployment.

.. end-mc-admin-rebalance-desc

MinIO does not automatically rebalance objects when adding a new server pool.
Instead, MinIO :ref:`writes new objects <minio-writing-files>` to the pool with relatively more free space compared to the other available pools on the deployment.
Triggering a manual rebalancing procedure prompts MinIO to scan the entire deployment and move objects as necessary to achieve a similar available free space across all pools.

This is an expensive and time consuming operation.
Consider only running a rebalance procedure during light or no use of the deployment.
If write operations do occur during a rebalance operation, they process in parallel and write to a pool not actively in rebalancing.

`MinIO SUBNET <https://min.io/pricing?jmp=docs>`__ users can `log in <https://subnet.min.io/>`__ and create a new issue to discuss appropriate rebalancing strategies for deployments.

Follow the progress of an ongoing rebalance operation using the following command:

.. code-block:: shell
   :class: copyable

   mc admin trace --call rebalance ALIAS

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only


The :mc-cmd:`mc admin rebalance` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc admin rebalance start`
     - Starts a rebalance operation on a MinIO deployment.

   * - :mc-cmd:`mc admin rebalance status`
     - Outputs the current status of an in-progress rebalance operation.

   * - :mc-cmd:`mc admin rebalance stop`
     - Stops an in-progress rebalance operation.


Syntax
------

.. mc-cmd:: start
   :fullpath:

   Start a rebalance operation for a MinIO deployment.

   .. tab-set::

      .. tab-item:: EXAMPLES

         Consider a MinIO deployment with two pools with an assigned alias of ``minio1``.
         One pool has 250 GB of free space while the other pool has 3 TB of free space.

         The :mc:`mc admin rebalance` command shifts objects from the pool with less free space to the pool with more free space so that there is roughly equal free space on both pools.

         .. code-block:: shell
            :class: copyable

            mc admin rebalance start minio1

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin rebalance start ALIAS

         - Replace ALIAS with the :ref:`alias <alias>` of a MinIO deployment to rebalance.

.. mc-cmd:: status
   :fullpath:

   Queries the deployment with an active rebalance process and returns information about the status of the rebalance process.

   The status returns the ID of the rebalance operation, the time of the operation, and details for each pool on the deployment.
   For each pool, the status shows the pool ID, the pool's rebalance status, the percentage of used space, and rebalance progress for the pool.

   .. tab-set::

      .. tab-item:: EXAMPLE

         .. code-block:: shell
            :class: copyable

            mc admin rebalance status minio1

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell

            mc [GLOBALFLAGS] admin rebalance ALIAS
      
         - Replace ALIAS with the :ref:`alias <alias>` of the MinIO deployment.

.. mc-cmd:: stop
   :fullpath:

   Ends an in-progress rebalance job on the specified deployment.

   .. admonition:: Stopping a rebalance job on previous versions of MinIO may cause data loss
      :class: warning

      A bug in MinIO prior to :minio-release:`RELEASE.2024-08-17T01-24-54Z` can overwrite objects while stopping a in-progress rebalance operation. 
      Interrupting rebalance on these older versions may result in data loss.

   .. tab-set::
      
      .. tab-item:: EXAMPLES
         
         .. code-block:: shell
            :class: copyable

            mc admin rebalance stop minio1
        
      .. tab-item:: SYNTAX
         
         The command has the following syntax:

         .. code-block:: shell
            
            mc [GLOBALFLAGS] admin rebalance stop ALIAS

         - Replace ALIAS with the :ref:`alias <alias>` of the MinIO deployment.

Global Flags
------------

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Behavior
--------

Back Up Cluster Settings First
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc admin cluster bucket export` and :mc:`mc admin cluster iam export` commands to take a snapshot of the bucket metadata and IAM configurations respectively prior to starting decommissioning.
You can use these snapshots to restore bucket/IAM settings to recover from user or process errors as necessary.

Rebalancing Ignores Expired Objects and Trailing ``DeleteMarker``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with :minio-release:`RELEASE.2023-06-23T20-26-00Z`, rebalancing ignores object versions which have expired based on the configured :ref:`lifecycle rules <minio-lifecycle-management-expiration>` for the parent bucket.

Rebalancing also ignores objects where the only remaining version is a :ref:`delete marker <minio-bucket-versioning-delete>`.
This avoids inter-pool :abbr:`I/O (Input/Output)` for objects already considered fully deleted.

MinIO relies on the :ref:`scanner <minio-concepts-scanner>` to capture and remove those expired objects or trailing ``DeleteMarker`` objects.

