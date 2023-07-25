.. _minio-erasure-coding:

==============
Erasure Coding
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. meta::
   :keywords: erasure coding, healing, availability, resiliency
   :description: Information on MinIO Erasure Coding

This page provides an overview of MinIO's implementation of Erasure Coding.
For information on how MinIO uses Erasure Coding for availability in distributed deployments, see :ref:`minio_availability-resiliency`.

.. note::

   |subnet| provides 24/7 direct-to-engineering consultation during planning, implementation, and active stages of your production deployments.
   SUBNET customers should open an issue to have MinIO engineering review the architecture and deployment strategies against your goals to ensure long-term success of your workloads.

   Any and all MinIO resources outside of |subnet| are intended as best-effort only with no guarantees of responsiveness or success.
   
.. _minio-ec-basics:

Erasure Coding Basics
---------------------

   .. note::
      
      The diagrams in this section present a simplified view of MinIO erasure coding operations and are not intended to represent the complexities of MinIO's full erasure coding implementation.

MinIO implements Erasure Coding as a core component in providing data redundancy and availability.
   Erasure Coding involves partitioning an object into **data** and **parity** shards.

   .. figure:: /images/erasure/erasure-coding-shard.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of an object being sharded using MinIO's Reed-Solomon Erasure Coding algorithm.

      A client writes an object to MinIO.
      MinIO automatically partitions the object into data and parity shards.

An object's :term:`Parity` dictates how many parity shards MinIO creates for an object.
   MinIO uses the :term:`erasure set size <erasure set>` and configured parity for the deployment to determine the number of parity and data shards to create for each object, where:

   :math:`N (ERASURE\ SET\ SIZE) = K (DATA) + M (PARITY)`

   .. figure:: /images/erasure/erasure-coding-shard-ec6.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of an object written with EC:6 to an erasure set with 16 drives

   This deployment has an erasure set size of ``16`` and a parity of ``EC:6``. 
   Based on the formula, MinIO creates ``10`` data shards and ``6`` parity shards for each object.

MinIO can use any parity shard to reconstruct any data shard.
   .. figure:: /images/erasure/erasure-coding-shard-reconstruction.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of MinIO using parity shards to reconstruct data shards

      An object has lost two data shards.
      MinIO uses any two of the available parity shards to reconstruct the data shards.
      Even a single remaining parity shard would be sufficient to reconstruct both missing data shards.

MinIO requires a minimum of ``K`` Data *or* Parity shards to **read** the object.
   The value ``K`` constitutes the **read quorum** for the deployment.
   Alternatively, the object can tolerate the loss of no more than ``M`` shards at any time while remaining readable.

   .. figure:: /images/erasure/erasure-coding-shard-read-quorum.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of an object maintaining read quorum with only 10 total shards remaining

      An object has 10 data shards and 6 parity shards for a total of 16 shards.
      It has lost 3 data and 3 parity shards for a total of 6 shards lost and 10 remaining.
      The loss of any further shards would result in losing read quorum.

   An object that has lost read quorum is effectively "lost" and may be recovered through other means such as :ref:`replication resynchronization <minio-bucket-replication-resynchronize>`.

MinIO similarly requires successful creation of at least ``K`` data shards to **write** the object.
   The value ``K`` constitutes the **write quorum** for the deployment.
   A deployment could lose write quorum due to having insufficient online drives, insufficient drive space, or network issues between nodes.

   .. figure:: /images/erasure/erasure-coding-shard-write-quorum.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of an object maintaining write quorum with only 10 shards remaining.

      MinIO creates 16 shards for an object with parity of ``EC:6``.
      Due to drive errors, only 10 drives remain online for MinIO to use for write operations.
      This meets write quorum, but the loss of any further drives would result in write failure for newer objects.

   If Parity (``EC:M``) is exactly 1/2 the number of drives in the erasure set, **write quorum** is ``K+1``.
   This extra shard prevents data inconsistency due to `"split-brain" <https://en.wikipedia.org/wiki/Split-brain_(computing)>`__-types of failure states.

.. _minio-ec-erasure-set:

Erasure Set and Distribution
----------------------------

An **Erasure Set** is a group of up to sixteen drives for which MinIO can read or write erasure coded objects.
   .. figure:: /images/erasure/erasure-coding-erasure-set.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of erasure set covering 4 nodes and 16 drives

      The above example deployment consists of 4 nodes with 4 drives each.
      MinIO initializes with a single erasure set consisting of all 16 drives across all four nodes.

Erasure set stripe size dictates the maximum possible :ref:`parity <minio-ec-parity>` of the deployment.
   .. figure:: /images/erasure/erasure-coding-possible-parity.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of possible erasure set parity settings

      The above example deployment has an erasure set of 16 drives. 
      This can support parity between ``EC:0`` and 1/2 the erasure set drives, or ``EC:8``.

   Deployments with a small number of nodes or drives can support a limited number of parity drives, up to a maximum of 1/2 the number of drives in the set.

   Erasure Sets have a minimum size of 2 and a maximum size of 16.

MinIO automatically calculates the number and size of erasure sets when initializing a :ref:`server pool <minio-intro-server-pool>`.
You cannot change the set size for a pool after its initial setup.

Use the MinIO `Erasure Coding Calculator <https://min.io/product/erasure-code-calculator>`__ to explore the possible erasure set size and distributions for your planned topology.
Where possible, use an even number of nodes and drives per node to simplify topology planning and conceptualization of drive/erasure-set distribution.

.. _minio-ec-parity:

Erasure Parity and Storage Efficiency
-------------------------------------

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

Bitrot Protection
-----------------

Silent data corruption or bit rot is a serious problem faced by data drives resulting in data getting corrupted without the user’s knowledge. 
The corruption of data occurs when the electrical charge on a portion of the drive disperses or changes with no notification to or input from the user.
Many events can lead to such a silent corruption of stored data.
For example, ageing drives, current spikes, bugs in drive firmware, phantom writes, misdirected reads/writes, driver errors, accidental overwrites, or a random cosmic ray can each lead to a bit change.
Whatever the cause, the result is the same - compromised data.

MinIO’s optimized implementation of the :minio-git:`HighwayHash algorithm <highwayhash/blob/master/README.md>` ensures that it captures and heals corrupted objects on the fly. 
Integrity is ensured from end to end by computing a hash on READ and verifying it on WRITE from the application, across the network, and to the memory or drive. 
The implementation is designed for speed and can achieve hashing speeds over 10 GB/sec on a single core on Intel CPUs.