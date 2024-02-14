.. _minio-server-envvar-storage-class:
.. _minio-ec-storage-class:

=====================
Erasure Code Settings
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page covers settings that configure the :ref:`Erasure Code <minio-erasure-coding>` :ref:`parity <minio-ec-parity>` to use for objects written to the MinIO cluster.
This impacts how MinIO uses the space on the drive(s) and how MinIO can recover objects stored on lost drives or similar issues.

.. note::

   *MinIO Storage Classes* are distinct from *AWS Storage Classes*.

   AWS Storage Classes refer to the specific storage tier on which to store a given object, such as ``hot`` or ``glacier`` storage.
   MinIO Storage Classes affect the erasure code parity setting used and relate to :ref:`minio-availability-resiliency` of objects.

   For tiering from one type of storage to another, such as for cost management purposes, see :ref:`minio-lifecycle-management-tiering`.

Define any of these environment variables in the host system prior to starting or restarting the MinIO process.
Refer to your operating system's documentation for how to define an environment variable.

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-test-before-prod
   :end-before: end-minio-settings-test-before-prod

Environment Variables
---------------------

.. note::

   These settings do not have configuration setting options for use with :mc:`mc admin config set`.

.. envvar:: MINIO_STORAGE_CLASS_STANDARD

   The :ref:`parity level <minio-ec-parity>` for the deployment.
   MinIO shards objects written with the default ``STANDARD`` storage class using this parity value.

   MinIO references the ``x-amz-storage-class`` header in request metadata for determining which storage class to assign an object. 
   The specific syntax or method for setting headers depends on your preferred method for interfacing with the MinIO server.

   Specify the value using ``EC:M`` notation, where ``M`` refers to the number of parity blocks to create for the object.

   The following table lists the default values based on the :ref:`erasure set size <minio-ec-erasure-set>` of the initial server pool in the deployment:

   .. list-table::
      :header-rows: 1
      :widths: 30 70
      :width: 100%

      * - Erasure Set Size
        - Default Parity (EC:N)

      * - 1
        - EC:0

      * - 2-3
        - EC:1

      * - 4-5
        - EC:2

      * - 6 - 7
        - EC:3

      * - 8 - 16
        - EC:4

   The minimum supported value is ``0``, which indicates no erasure coding protections.
   These deployments rely entirely on the storage controller or resource for availability / resiliency. 
   
   The maximum value depends on the erasure set size of the initial server pool in the deployment, where the upper bound is  :math:`\frac{\text{ERASURE_SET_SIZE}}{\text{2}}`.
   For example, a deployment with erasure set stripe size of 16 has a maximum standard parity of 8.

   You can change this value after startup to any value between ``0`` and the upper bound for the erasure set size.
   MinIO only applies the changed parity to newly written objects.
   Existing objects retain the parity value in place at the time of their creation.

.. envvar:: MINIO_STORAGE_CLASS_RRS

   The :ref:`parity level <minio-ec-parity>` for objects written with the ``REDUCED`` storage class.

   MinIO references the ``x-amz-storage-class`` header in request metadata for determining which storage class to assign an object. 
   The specific syntax or method for setting headers depends on your preferred method for interfacing with the MinIO server.

   Specify the value using ``EC:M`` notation, where ``M`` refers to the number of parity blocks to create for the object.

   This value **must be** less than or equal to :envvar:`MINIO_STORAGE_CLASS_STANDARD`.

   You cannot set this value for deployments with an erasure set size less than 2.
   Defaults to ``EC:1`` for deployments with erasure set size greater than 1.
   Defaults to ``EC:0`` for deployments of erasure set size of 1.

.. envvar:: MINIO_STORAGE_CLASS_COMMENT

   Adds a comment to the storage class settings.
