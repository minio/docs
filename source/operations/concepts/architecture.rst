.. _minio-architecture:

=======================
Deployment Architecture
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. meta::
   :keywords: topology, architecture, deployment, production
   :description: Information on MinIO Deployment architecture and topology in production environments

This page provides an overview of MinIO deployment architectures from a production perspective.
For information on specific hardware or software configurations, see:

- :ref:`Hardware checklists <minio-hardware-checklist>`
- :ref:`Security Checklist <minio-security-checklist>`
- :ref:`Software Checklist <minio-software-checklists>`
- :ref:`Thresholds and Limits <minio-server-limits>`

Distributed MinIO Deployments
-----------------------------

A production MinIO deployment consists of at least 4 MinIO hosts with homogeneous storage and compute resources.
   MinIO aggregates these resources together as a :ref:`pool <minio-intro-server-pool>` and presents itself as a single object storage service.

   .. figure:: /images/architecture/architecture-4-node-deploy.svg
      :figwidth: 100%
      :alt: 4 Node MinIO deployment with homogeneous storage and compute resources
      :align: center

      Each MinIO host in this pool has matching compute, storage, and network configurations

MinIO provides best performance when using direct-attached storage (DAS), such as NVMe or SSD drives attached to a PCI-E controller board on the host machine. 
   Storage controllers should present XFS-formatted drives in "Just a Bunch of Drives" (JBOD) configurations with no RAID, pooling, or other hardware/software resiliency layers.
   Caching layers, either at the drive or the controller layer, also typically lead to unpredictable performance as I/O spikes and falls as the cache fills and clears. 

   .. figure:: /images/architecture/architecture-one-node-DAS.svg
      :figwidth: 100%
      :alt: MinIO Server diagram of Direct-Attached Storage via SAS to a PCI-E Storage Controller
      :align: center

      Each SSD connects via SAS to a PCI-E-attached storage controller operating in HBA mode

MinIO automatically groups drives in the pool into :ref:`erasure sets <minio-ec-erasure-set>`. 
   Erasure sets provide the foundation component of MinIO availability and resiliency. 
   MinIO stripes erasure sets across the nodes in the pool to maintain even distribution of erasure set drives.
   MinIO then shards objects into data and parity blocks based on the deployment :ref:`parity <minio-ec-parity>` and distributes them across an erasure set.

   Erasure sets provide the foundation component of MinIO :ref:`availability and resiliency <minio_availability-resiliency>`.
   For a more complete discussion of MinIO redundancy and healing, see :ref:`minio-erasure-coding`.

   .. figure:: /images/architecture/architecture-erasure-set-shard.svg
      :figwidth: 100%
      :alt: Diagram of object being sharded into 4 data and 4 parity blocks, distributed across 8 drives
      :align: center

      MinIO shards the object into 4 data and 4 parity blocks, distributing them across the drives in the erasure set. 

MinIO uses a deterministic algorithm to select the erasure set for a given object.
   For each unique object namespace ``BUCKET/PREFIX/[PREFIX/...]/OBJECT.EXTENSION``, MinIO always selects the same erasure set for read/write operations.
   MinIO handles all routing within pools and erasure sets, making the select/read/write process entirely transparent to applications.

   .. figure:: /images/architecture/architecture-erasure-set-retrieve-object.svg
      :figwidth: 100%
      :alt: Diagram of object retrieval from only data shards
      :align: center

      MinIO reconstructs objects from data or parity shards transparently before returning the object to the requesting client.

Each MinIO server has a complete picture of the distributed topology, such that an application can connect and direct operations against any node in the deployment.
   The MinIO node automatically handles routing internal requests to other nodes in the deployment *and* returning the final response to the client.

   Applications typically should not manage those connections, as any changes to the deployment topology would require application updates.
   Production environments should instead deploy a load balancer or similar network control plane component to manage connections to the MinIO deployment.
   For example, you can deploy an NGINX load balancer to perform "least connections" or "round robin" load balancing against the available nodes in the deployment.

   .. figure:: /images/architecture/architecture-load-balancer-8-node.svg
      :figwidth: 100%
      :alt: Diagram of an 8-node MinIO deployment behind a load balancer
      :align: center

      The load balancer routes the request to any node in the deployment.
      The node which receives the requests handles any internode requests thereafter.

You can expand a MinIO deployment's available storage through :ref:`pool expansion <expand-minio-distributed>`.
   Each pool consists of an independent group of nodes with their own erasure sets.
   MinIO must query each pool to determine the correct erasure set to which it directs read and write operations, such that each additional pool adds increased internode traffic per call.
   The pool which contains the correct erasure set then responds to the operation, remaining entirely transparent to the application.

   If you modify the MinIO topology through pool expansion, you can update your applications by modifying the load balancer to include the new nodes.
   This ensures even distribution of requests across all pools, while applications continue using the single load balancer URL for MinIO operations.

   .. figure:: /images/architecture/architecture-load-balancer-multi-pool.svg
      :figwidth: 100%
      :alt: Diagram of a multi-pool minio deployment behind a load balancer
      :align: center

      The PUT request requires checking each pool for the correct erasure set.
      Once identified, MinIO shards the object and distributes the data and parity across the set.

Client applications can use any S3-compatible SDK or library to interact with the MinIO deployment.
   MinIO publishes it's own :ref:`drivers <minio-drivers>` specifically intended for use with S3-compatible deployments.
   Regardless of the driver, the S3 API uses HTTP methods like GET and POST for all operations.
   Neither MinIO nor S3 implements proprietary wire protocols or other low-level interfaces for normal operations.

   .. figure:: /images/architecture/architecture-multiple-clients.svg
      :figwidth: 100%
      :alt: Diagram of multiple S3-compatible clients using SDKs to connect to MinIO

      Clients using a variety of S3-compatible SDKs can perform operations against the same MinIO deployment.

   MinIO uses a strict implementation of the S3 API, including requiring clients to sign all operations using AWS :s3-api:`Signature V4 <sig-v4-authenticating-requests.html>` or the legacy Signature V2.
   AWS signature calculation uses the client-provided headers, such that any modification to those headers by load balancers, proxies, security programs, or other components can result in signature mismatch errors.
   Ensure any such intermediate components support pass-through of unaltered headers from client to server.

   The complexity of signature calculation typically makes interfacing via CURL or similar REST clients difficult or impractical. 
   MinIO recommends using S3-compatible drivers which perform the signature calculation automatically as part of operations.

Replicated MinIO Deployments
----------------------------

MinIO :ref:`site replication <minio-site-replication-overview>` provides support synchronizing distinct independent deployments.
   You can deploy peer sites in different racks, datacenters, or geographic regions to support functions like :abbr:`BC/DR (Business Continuity / Disaster Recovery)` or geo-local read/write performance in a globally distributed MinIO object store.

   .. figure:: /images/architecture/architecture-multi-site.svg
      :figwidth: 100%
      :alt: Diagram of a multi-site deployment with three MinIO peer site

      A MinIO multi-site deployment with three peers.
      Write operations on one peer replicate to all other peers in the configuration automatically.

Each peer site consists of an independent set of MinIO hosts, ideally having matching pool configurations.
   The architecture of each peer site should closely match to ensure consistent performance and behavior between sites.
   All peer sites must use the same primary identity provider, and during initial configuration only one peer site can have any data.

   .. figure:: /images/architecture/architecture-multi-site-setup.svg
      :figwidth: 100%
      :alt: Diagram of a multi-site deployment during initial setup

      The initial setup of a MinIO multi-site deployment.
      The first peer site replicates all required information to other peers in the configuration.
      Adding new peers uses the same sequence for synchronizing data.

Replication performance primarily depends on the network latency between each peer site.
   With geographically distributed peer sites, high latency between sites can result in significant replication lag.
   This can compound with workloads that are near or at the deployment's overall performance capacity, as the replication process itself requires 

   .. figure:: /images/architecture/architecture-multi-site-latency.svg
      :figwidth: 100%
      :alt: Diagram of a multi-site deployment with latency between sites

      In this peer configuration, the latency between Site A and it's peer sites is 100ms.
      The earliest point in time in which the object fully synchronizes to all sites is at least 110ms.

Deploying a global load balancer or similar network appliance with support for site-to-site failover protocols is critical to the functionality of multi-site deployments.
   The load balancer should support a health probe/check setting to detect the failure of one site and automatically redirect applications to any remaining healthy peer.

   .. figure:: /images/architecture/architecture-load-balancer-multi-site.svg
      :figwidth: 100%
      :alt: Diagram of a multi-site deployment with a failed site

      One of the peer sites has failed completely.
      The load balancer automatically routes requests to the remaining healthy peer site.

   The load balancer should meet the same requirements as single-site deployments regarding connection balancing and header preservation.
   Once all data synchronizes, you can restore normal connectivity to that site.
   Depending on the amount of replication lag, latency between sites, and overall workload IO, you may need to temporarily stop write operations to allow the sites to completely catch up.tions to other sites in the deployment.

MinIO replication can automatically heal a site that has partial data loss due to transient or sustained downtime. 
   If a peer site completely fails, you can remove that site from the configuration entirely.
   The load balancer configuration should also remove that site to avoid routing client requests to the offline site.

   You can then restore the peer site, either after repairing the original hardware or replacing it entirely, by adding it back to the site replication configuration.
   MinIO automatically begins resynchronizing content.

   .. figure:: /images/architecture/architecture-load-balancer-multi-site-healing.svg
      :figwidth: 100%
      :alt: Diagram of a multi-site deployment with a healing site

      The peer site has recovered and reestablished connectivity with its healthy peers.
      MinIO automatically works through the replication queue to catch the site back up.

   Once all data synchronizes, you can restore normal connectivity to that site.
   Depending on the amount of replication lag, latency between sites and overall workload IO, you may need to temporarily stop write operations to allow the sites to completely catch up.