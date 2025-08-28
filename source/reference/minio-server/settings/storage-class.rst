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

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-test-before-prod
   :end-before: end-minio-settings-test-before-prod

.. _minio-ec-storage-class-standard:

Standard Storage Class
----------------------

.. note::

   *MinIO Storage Classes* are distinct from *AWS Storage Classes*.

   AWS Storage Classes refer to the specific storage tier on which to store a given object, such as ``hot`` or ``glacier`` storage.
   MinIO Storage Classes affect the erasure code parity setting used and relate to :ref:`minio-availability-resiliency` of objects.

   For tiering from one type of storage to another, such as for cost management purposes, see :ref:`minio-lifecycle-management-tiering`.

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_STORAGE_CLASS_STANDARD

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: storage_class standard
         :delimiter: " "

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

Reduced Redundancy Storage Class
--------------------------------

.. note::

   *MinIO Storage Classes* are distinct from *AWS Storage Classes*.

   AWS Storage Classes refer to the specific storage tier on which to store a given object, such as ``hot`` or ``glacier`` storage.
   MinIO Storage Classes affect the erasure code parity setting used and relate to :ref:`minio-availability-resiliency` of objects.

   For tiering from one type of storage to another, such as for cost management purposes, see :ref:`minio-lifecycle-management-tiering`.

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_STORAGE_CLASS_RRS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: storage_class rrs
         :delimiter: " "

The :ref:`parity level <minio-ec-parity>` for objects written with the ``REDUCED`` storage class.

MinIO references the ``x-amz-storage-class`` header in request metadata for determining which storage class to assign an object. 
The specific syntax or method for setting headers depends on your preferred method for interfacing with the MinIO server.

Specify the value using ``EC:M`` notation, where ``M`` refers to the number of parity blocks to create for the object.

This value **must be** less than or equal to :envvar:`MINIO_STORAGE_CLASS_STANDARD`.

You cannot set this value for deployments with an erasure set size less than 2.
Defaults to ``EC:1`` for deployments with erasure set size greater than 1.
Defaults to ``EC:0`` for deployments of erasure set size of 1.

Parity Retention Optimization
-----------------------------

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_STORAGE_CLASS_OPTIMIZE

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: storage_class optimize
         :delimiter: " "

MinIO by default automatically "upgrades" parity for an object if the destination erasure set maintains write quorum *but* has one or more drives offline.
This behavior helps ensure that the given object maintains the same availability as objects written to the healthy erasure set.

Specify ``capacity`` to this setting to direct MinIO to not create any additional parity for the object.
This prioritizes the overall capacity of the cluster at the cost of potentially reduced object availability in the event more drives in that erasure set fail.

Comment
-------

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_STORAGE_CLASS_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Adds a comment to the storage class settings.
