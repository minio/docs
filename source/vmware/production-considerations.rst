.. _minio-vmware-production-considerations:

================================================
Production Considerations for MinIO on vSphere 7
================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

This page documents considerations for deploying production-grade
MinIO Tenants on vSphere 7 Update 1.

Recommended Topology
--------------------

DIAGRAM: 4-Node 8-Drive + Clients
   - Cover Network layer (switches)
   - Cover Load Balancer (vCenter seems to create one for the user)
   - Application access patterns?


Server Hardware
---------------

MinIO is hardware agnostic and runs on a variety of hardware architectures
ranging from ARM-based embedded systems to high-end x64 and POWER9 servers.

The following recommendations match MinIO's 
`Reference Hardware <https://min.io/product/reference-hardware>`__ for 
large-scale data storage:

.. list-table::
   :stub-columns: 1
   :widths: 20 80
   :width: 100%

   * - Processor
     - Dual Intel Xeon Scalable Gold CPUs with 8 cores per socket. 
       
       MinIO generally recommends at least N CPUs for every X TB of total zone
       storage.

   * - Memory
     - 128GB of Memory for every X TB of total zone storage.

   * - Network
     - Minimum of 25GbE NIC and supporting network infrastructure between nodes.

       MinIO can make maximum use of drive throughput, which can fully saturate
       network links between MinIO nodes or clients. Large clusters may require
       100GbE network infrastructure to fully utilize MinIO's per-node 
       performance potential.

   * - Drives
     - SATA/SAS HDDs with a minimum of 8 drives per server. 


Networking
----------

ToDO: 

- Be as prescriptive as possible on when to push for 25GbE, 50GbE, 100GbE.
- Guidance on how to identify network bottlenecks?

Security
--------

- Enable MinIO PBAC
- Configure IDP (via VMware!)

- TLS Guidance?

Erasure Coding Parity
---------------------

Depends a bit on pending EC PR. ToDo:

- High level description of Parity w.r.t. read/write quorum/resilience
- Table of EC Parity vs Storage vs Read Quorum vs Write Quorum
- Recommended default (EC:4)
- Simple example on how to change (`mc admin config set storage_class standard=EC:4` + `mc admin service restart`)
