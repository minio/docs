.. _minio-erasure-coding:

==============
Erasure Coding
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO Erasure Coding is a data redundancy and availability feature that allows MinIO deployments to automatically reconstruct objects on-the-fly despite the loss of multiple drives or nodes in the cluster. 
Erasure Coding provides object-level healing with significantly less overhead than adjacent technologies such as RAID or replication. 

MinIO partitions each new object into data and parity shards, where parity shards support reconstruction of missing or corrupted data shards. 
MinIO writes these shards to a single :ref:`erasure set <minio-ec-erasure-set>` in the deployment.
MinIO can use either data or parity shards to reconstruct an object, as long as the erasure set has :ref:`read quorum <minio-read-quorum>`.
For example, MinIO can use parity shards local to the node receiving a request instead of specifically filtering only those nodes or drives containing data shards.

Since erasure set drives are striped across the server pool, a given node contains only a portion of data or parity shards for each object.
MinIO can therefore tolerate the loss of multiple drives or nodes in the deployment depending on the configured parity and deployment topology.

.. image:: /images/erasure-code.jpg
   :width: 600px
   :alt: MinIO Erasure Coding example
   :align: center

At maximum parity, MinIO can tolerate the loss of up to half the drives per erasure set (:math:`(N / 2) - 1`) and still perform read and write operations. 
MinIO defaults to 4 parity shards per object with tolerance for the loss of 4 drives per erasure set. 
For more complete information on selecting erasure code parity, see :ref:`minio-ec-parity`.

Use the MinIO `Erasure Code Calculator <https://min.io/product/erasure-code-calculator?ref=docs>`__ when planning and designing your MinIO deployment to explore the effect of erasure code settings on your intended topology.

.. _minio-ec-erasure-set:

Erasure Sets
------------

An *Erasure Set* is a group of drives onto which MinIO writes erasure coded objects.
MinIO randomly and uniformly distributes the data and parity shards of a given object across the erasure set drives, where a given drive has no more than one block of either type per object (no overlap).
 
MinIO automatically calculates the number and size of Erasure Sets ("stripe size") based on the total number of nodes and drives in the :ref:`Server Pool <minio-intro-server-pool>`, where the minimum stripe size is 2 and the maximum stripe size is 16.
All erasure sets in a given pool have the same stripe size, and MinIO never modifies nor allows modification of stripe size after initial configuration.
The algorithm for selecting stripe size takes into account the total number of nodes in the deployment, such that the selected stripe allows for uniform distribution of erasure set drives across all nodes in the pool.

Erasure set stripe size dictates the maximum possible :ref:`parity <minio-ec-parity>` of the deployment.
Use the MinIO `Erasure Coding Calculator <https://min.io/product/erasure-code-calculator>`__ to explore the possible erasure set size and distributions for your planned topology.
MinIO strongly recommends architecture reviews via |SUBNET| as part of your provisioning and deployment process to ensure long term success and stability.
As a general guide, plan your topologies to have an even number of nodes and drives where both the nodes and drives have a common denominator of 16.

.. _minio-ec-parity:

Erasure Code Parity (``EC:N``)
------------------------------

MinIO uses a Reed-Solomon algorithm to split objects into data and parity shards based on the :ref:`Erasure Set <minio-ec-erasure-set>` size in the deployment.
For a given erasure set of size ``M``, MinIO splits objects into ``N`` parity shards and ``M-N`` data shards. 

MinIO uses the ``EC:N`` notation to refer to the number of parity shards (``N``) in the deployment. 
MinIO defaults to ``EC:4`` or 4 parity shards per object. 
MinIO uses the same ``EC:N`` value for all erasure sets and :ref:`server pools <minio-intro-server-pool>` in the deployment.

.. _minio-read-quorum:
.. _minio-write-quorum:

MinIO can tolerate the loss of up to ``N`` drives per erasure set and continue performing read and write operations ("quorum"). 
If ``N`` is equal to exactly 1/2 the drives in the erasure set, MinIO write quorum requires :math:`N + 1` drives to avoid data inconsistency ("split-brain").

Setting the parity for a deployment is a balance between availability and total usable storage. 
Higher parity values increase resiliency to drive or node failure at the cost of usable storage, while lower parity provides maximum storage with reduced tolerance for drive/node failures. 
Use the MinIO `Erasure Code Calculator <https://min.io/product/erasure-code-calculator?ref=docs>`__ to explore the effect of parity on your planned cluster deployment.

The following table lists the outcome of varying erasure code parity levels on a MinIO deployment consisting of 1 node and 16 1TB drives:

.. list-table:: Outcome of Parity Settings on a 16 Drive MinIO Cluster
   :header-rows: 1
   :widths: 20 20 20 20 20
   :width: 100%

   * - Parity
     - Total Storage
     - Storage Ratio
     - Minimum Drives for Read Operations
     - Minimum Drives for Write Operations

   * - ``EC: 4`` (Default)
     - 12 Tebibytes
     - 0.750
     - 12
     - 12

   * - ``EC: 6``
     - 10 Tebibytes
     - 0.625
     - 10
     - 10

   * - ``EC: 8``
     - 8 Tebibytes
     - 0.500
     - 8
     - 9

.. _minio-ec-storage-class:

Storage Classes
~~~~~~~~~~~~~~~

MinIO supports redundancy storage classes with Erasure Coding to allow applications to specify per-object :ref:`parity <minio-ec-parity>`. 
Each storage class specifies a ``EC:N`` parity setting to apply to objects created with that class. 

MinIO storage classes for erasure coding are *distinct* from Amazon Web Services :s3-docs:`storage classes <storage-class-intro.html>` used for tiering. 
MinIO erasure coding storage classes define *parity settings per object*, while AWS storage classes define *storage tiers per object*. 

.. note:: 
   For transitioning objects between storage classes for tiering purposes in MinIO, refer to the documentation on :ref:`lifecycle management <minio-lifecycle-management-tiering>`.

MinIO provides the following two storage classes:

.. tab-set::

   .. tab-item:: STANDARD

      The ``STANDARD`` storage class is the default class for all objects.
      MinIO sets the ``STANDARD`` parity based on the number of volumes in the Erasure Set:

      .. list-table::
         :header-rows: 1
         :widths: 30 70
         :width: 100%

         * - Erasure Set Size
           - Default Parity (EC:N)

         * - 5 or Fewer 
           - EC:2

         * - 6 - 7
           - EC:3

         * - 8 or more 
           - EC:4

      You can override the default ``STANDARD`` parity using either:

      - The :envvar:`MINIO_STORAGE_CLASS_STANDARD` environment variable, *or*
      - The :mc:`mc admin config` command to modify the ``storage_class.standard`` configuration setting.

      The maximum value is half of the total drives in the :ref:`Erasure Set <minio-ec-erasure-set>`. 
      The minimum value is ``2``.

      ``STANDARD`` parity *must* be greater than or equal to ``REDUCED_REDUNDANCY``. 
      If ``REDUCED_REDUNDANCY`` is unset, ``STANDARD`` parity *must* be greater than 2.

   .. tab-item:: REDUCED_REDUNDANCY

      The ``REDUCED_REDUNDANCY`` storage class allows creating objects with lower parity than ``STANDARD``. 
      ``REDUCED_REDUNDANCY`` requires *at least* 5 drives in the MinIO deployment. 
      
      MinIO sets the ``REDUCED_REDUNDANCY`` parity to ``EC:2`` by default.
      You can override ``REDUCED_REDUNDANCY`` storage class parity using either:

      - The :envvar:`MINIO_STORAGE_CLASS_RRS` environment variable, *or*
      - The :mc:`mc admin config` command to modify the ``storage_class.rrs`` configuration setting.

      ``REDUCED_REDUNDANCY`` parity *must* be less than or equal to ``STANDARD``.

MinIO references the ``x-amz-storage-class`` header in request metadata for determining which storage class to assign an object. 
The specific syntax or method for setting headers depends on your preferred method for interfacing with the MinIO server.

- For the :mc:`mc` command line tool, certain commands include a specific option for setting the storage class. 
  For example, the :mc:`mc cp` command has the :mc-cmd:`~mc cp storage-class` option for specifying the storage class to assign to the object being copied.

- For MinIO SDKs, the ``S3Client`` object has specific methods for setting request headers. 
  For example, the ``minio-go`` SDK ``S3Client.PutObject`` method takes a ``PutObjectOptions`` data structure as a parameter.
  The ``PutObjectOptions`` data structure includes the ``StorageClass`` option for specifying the storage class to assign to the object being   created.


.. _minio-ec-bitrot-protection:

Bit Rot Protection
------------------

.. TODO- ReWrite w/ more detail.

Silent data corruption or bit rot is a serious problem faced by data drives resulting in data getting corrupted without the user’s knowledge. 
The corruption of data occurs when the electrical charge on a portion of the drive disperses or changes with no notification to or input from the user.
Many events can lead to such a silent corruption of stored data.
For example, ageing drives, current spikes, bugs in drive firmware, phantom writes, misdirected reads/writes, driver errors, accidental overwrites, or a random cosmic ray can each lead to a bit change.
Whatever the cause, the result is the same - compromised data.

MinIO’s optimized implementation of the :minio-git:`HighwayHash algorithm <highwayhash/blob/master/README.md>` ensures that it captures and heals corrupted objects on the fly. 
Integrity is ensured from end to end by computing a hash on READ and verifying it on WRITE from the application, across the network, and to the memory or drive. 
The implementation is designed for speed and can achieve hashing speeds over 10 GB/sec on a single core on Intel CPUs.
