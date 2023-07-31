.. _minio-availability-resiliency:

===========================
Availability and Resiliency
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. meta::
   :keywords: availability, resiliency, healing, recovery, distributed
   :description: Information on MinIO Availability and Resiliency features in production environments

This page provides an overview of MinIO's availability and resiliency design and features from a production perspective.

.. note::

   The contents of this page are intended as a best-effort guide to understanding MinIO's intended design and philosophy behind availability and resiliency. 
   It cannot replace the functionality of |subnet|, which allows for coordinating with MinIO Engineering when planning your MinIO deployments.

   Community users can seek support on the `MinIO Community Slack <https://slack.min.io>`__. 
   Community Support is best-effort only and has no SLAs around responsiveness.

Distributed MinIO Deployments
-----------------------------

MinIO implements :ref:`erasure coding <minio-erasure-coding>` as the core component in providing availability and resiliency during drive or node-level failure events.
   MinIO partitions each object into data and :ref:`parity <minio-ec-parity>` shards and distributes those shards across a single :ref:`erasure set <minio-ec-erasure-set>`.

   .. figure:: /images/availability/availability-erasure-sharding.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of erasure coded object partitioned into twelve data shards and four parity shards

      This small one-node deployment has 16 drives in one erasure set.
      Assuming default :ref:`parity <minio-ec-parity>` of ``EC:4``, MinIO partitions the object into 4 (four) parity shards and 12 (twelve) data shards.
      MinIO distributes these shards evenly across each drive in the erasure set.

MinIO uses a deterministic algorithm to select the erasure set for a given object.
   For each unique object namespace ``BUCKET/PREFIX/[PREFIX/...]/OBJECT.EXTENSION``, MinIO always selects the same erasure set for read/write operations.
   This includes all :ref:`versions <minio-bucket-versioning>` of that same object.

   .. figure:: /images/availability/availability-erasure-set-selection.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of erasure set selection based on object namespace

      MinIO calculates the destination erasure set using the full object namespace.

MinIO requires :ref:`read and write quorum <minio-read-quorum>` to perform read and write operations against an erasure set.
   The quorum depends on the configured parity for the deployment.
   Read quorum always equals the configured parity, such that MinIO can perform read operations against any erasure set that has not lost more drives than parity.

   .. figure:: /images/availability/availability-erasure-sharding-degraded.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of degraded erasure set, where two parity shards replace two data shards

      This node has two failed drives.
      MinIO uses parity shards to replace the lost data shards automatically and serves the reconstructed object to the requesting client.

   With the default parity of ``EC:4``, the deployment can tolerate the loss of 4 (four) drives per erasure set and still serve read operations.

Write quorum depends on the configured parity and the size of the erasure set.
   If parity is less than 1/2 (half) the number of erasure set drives, write quorum equals parity and functions similarly to read quorum.

   MinIO automatically increases the parity of objects written to a degraded erasure set to ensure that object can meet the same :abbr:`SLA (Service Level Agreement)` as objects in healthy erasure sets.
   The parity upgrade behavior provides an additional layer of risk mitigation, but cannot replace the long-term solution of repairing or replacing damaged drives to bring the erasure set back to full healthy status.

   .. figure:: /images/availability/availability-erasure-sharding-degraded-write.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of degraded erasure set, where two drives have failed

      This node has two failed drives.
      MinIO writes the object with an upgraded parity of ``EC:6`` to ensure this object meets the same SLA as other objects.

   With the default parity of ``EC:4``, the deployment can tolerate the loss of 4 drives per erasure set and still serve write operations.

If parity equals 1/2 (half) the number of erasure set drives, write quorum equals parity + 1 (one) to avoid data inconsistency due to "split brain" scenarios.
   For example, if exactly half the drives in the erasure set become isolated due to a network fault, MinIO would consider quorum lost as it cannot establish a N+1 group of drives for the write operation.

   .. figure:: /images/availability/availability-erasure-sharding-split-brain.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of erasure set where half the drives have failed

      This node has 50% drive failure.
      If parity is ``EC:8``, this erasure set cannot meet write quorum and MinIO rejects write operations to that set.
      Since the erasure set still maintains read quorum, read operations to existing objects can still succeed.

An erasure set which permanently loses more drives than the configured parity has suffered data loss. 
   For maximum parity configurations, the erasure set goes into "read only" mode if drive loss equals parity.
   For the maximum erasure set size of 16 and maximum parity of 8, this would require the loss of 9 drives for data loss to occur.

   .. figure:: /images/availability/availability-erasure-sharding-degraded-set.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of completely degraded erasure set

      This erasure set has lost more drives than the configured parity of ``EC:4`` and has therefore lost both read and write quorum.
      MinIO cannot recover any data stored on this erasure set.

   Transient or temporary drive failures, such as due to a failed storage controller or connecting hardware, may recover back to normal operational status within the erasure set.

MinIO further mitigates the risk of erasure set failure by "striping" erasure set drives symmetrically across each node in the pool.
   MinIO automatically calculates the optimal erasure set size based on the number of nodes and drives, where the maximum set size is 16 (sixteen).
   It then selects one drive per node going across the pool for each erasure set, circling around if the erasure set stripe size is greater than the number of nodes.
   This topology provides resiliency to the loss of a single node, or even a storage controller on that node.

   .. figure:: /images/availability/availability-erasure-sharding-striped.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of a sixteen node by eight drive per node cluster, consisting of eight sixteen drive erasure sets striped evenly across each node.

      In this 16 x 8 deployment, MinIO would calculate 8 erasure sets of 16 drives each.
      It allocates one drive per node across the available nodes to fill each erasure set.
      If there were 8 nodes, MinIO would need to select 2 drives per node for each erasure set.
   
   In the above topology, the pool has 8 erasure sets of 16 drives each striped across 16 nodes.
   Each node would have one drive allocated per erasure set.
   While losing one node would technically result in the loss of 8 drives, each erasure set would only lose one drive each.
   This maintains quorum despite the node downtime.

Each erasure set is independent of all others in the same pool.
   If one erasure set becomes completely degraded, MinIO can still perform read/write operations on other erasure sets.

   .. figure:: /images/availability/availability-erasure-set-failure.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of a MinIO multi-pool deployment with one failed erasure set in a pool

      One pool has a degraded erasure set.
      While MinIO can no longer serve read/write operations to that erasure set, it can continue to serve operations on healthy erasure sets in that pool.

   However, the lost data may still impact workloads which rely on the assumption of 100% data availability.
   Furthermore, each erasure set is fully independent of the other such that you cannot restore data to a completely degraded erasure set using other erasure sets.
   You must use :ref:`Site <minio-site-replication-overview>` or :ref:`Bucket <minio-bucket-replication>` replication to create a :abbr:`BC/DR (Business Continuity / Disaster Recovery)`-ready remote deployment for restoring lost data.

For multi-pool MinIO deployments, each pool requires at least one erasure set maintaining read/write quorum to continue performing operations.
   If one pool loses all erasure sets, MinIO can no longer determine whether a given read/write operation would have routed to that pool.
   MinIO therefore stops all I/O to the deployment, even if other pools remain operational.

   .. figure:: /images/availability/availability-pool-failure.svg
      :figwidth: 100%
      :align: center
      :alt: Diagram of a MinIO multi-pool deployment with one failed pool.

      One pool in this deployment has completely failed.
      MinIO can no longer determine which pool or erasure set to route I/O to.
      Continued operations could produce an inconsistent state where an object and/or it's versions reside in different erasure sets.
      MinIO therefore halts all :abbr:`I/O (Input/Output)` in the deployment until the pool recovers.

   To restore access to the deployment, administrators must restore the pool to normal operations.
   This may require formatting disks, replacing hardware, or replacing nodes depending on the severity of the failure.
   See :ref:`minio-restore-hardware-failure` for more complete documentation.

   Use replicated remotes to restore the lost data to the deployment.
   All data stored on the healthy pools remain safe on disk.

Replicated MinIO Deployments
----------------------------

MinIO implements :ref:`site replication <minio-site-replication-overview>` as the primary measure for ensuring Business Continuity and Disaster Recovery (BC/DR) in the case of both small and large scale data loss in a MinIO deployment.
   .. figure:: /images/availability/availability-multi-site-setup.svg
      :figwidth: 100%
      :alt: Diagram of a multi-site deployment during initial setup

      Each peer site is deployed to an independent datacenter to provide protection from large-scale failure or disaster.
      If one datacenter goes completely offline, clients can fail over to the other site.

MinIO replication can automatically heal a site that has partial or total data loss due to transient or sustained downtime. 
   .. figure:: /images/availability/availability-multi-site-healing.svg
      :figwidth: 100%
      :alt: Diagram of a multi-site deployment while healing

      Datacenter 2 was down and Site B requires resynchronization.
      The Load Balancer handles routing operations to Site A in Datacenter 1.
      Site A continuously replicates data to Site B.

   Once all data synchronizes, you can restore normal connectivity to that site.
   Depending on the amount of replication lag, latency between sites and overall workload :abbr:`I/O (Input / Output)`, you may need to temporarily stop write operations to allow the sites to completely catch up.

   If a peer site completely fails, you can remove that site from the configuration entirely.
   The load balancer configuration should also remove that site to avoid routing client requests to the offline site.

   You can then restore the peer site, either after repairing the original hardware or replacing it entirely, by :ref:`adding it back to the site replication configuration <minio-expand-site-replication>`.
   MinIO automatically begins resynchronizing existing data while continuously replicating new data.

Sites can continue processing operations during resynchronization by proxying ``GET/HEAD`` requests to healthy peer sites
   .. figure:: /images/availability/availability-multi-site-proxy.svg
      :figwidth: 100%
      :alt: Diagram of a multi-site deployment while healing

      Site B does not have the requested object, possibly due to replication lag.
      It proxies the ``GET`` request to Site A.
      Site A returns the object, which Site B then returns to the requesting client.

   The client receives the results from first peer site to return *any* version of the requested object.

   ``PUT`` and ``DELETE`` operations synchronize using the regular replication process.
   ``LIST`` operations do not proxy and require clients to issue them exclusively against healthy peers.



