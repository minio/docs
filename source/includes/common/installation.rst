.. _minio-installation:

========================
Install and Deploy MinIO
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO is a software-defined high performance distributed object storage server.
You can run MinIO on consumer or enterprise-grade hardware and a variety
of operating systems and architectures.

MinIO supports three deployment topologies: 

Single-Node Single-Drive (SNSD or "Standalone")
  A single MinIO server with a single storage volume or folder. 
  |SNSD| deployment provides failover protections. Drive-level reliability and failover depends on the underlying storage volume.

  |SNSD| deployments are best suited for evaluation and initial development of applications using MinIO for object storage.

  |SNSD| deployments implement a zero-parity erasure coding backend and include support for the following erasure-coding dependent features:

  - :ref:`Versioning <minio-bucket-versioning>`
  - :ref:`Object Locking / Retention <minio-object-retention>`

Single-Node Multi-Drive (SNMD or "Standalone Multi-Drive")
  A single MinIO server with four or more storage volumes. 
  |SNMD| deployments provide drive-level reliability and failover only.

Multi-Node Multi-Drive (MNMD or "Distributed")
  Multiple MinIO servers with at least four drives across all servers. 
  The distributed |MNMD| topology supports production-grade object storage with drive and node-level availability and resiliency.

  For tutorials on deploying or expanding a distributed MinIO deployment, see:

  - :ref:`deploy-minio-distributed`
  - :ref:`expand-minio-distributed`

.. _minio-installation-comparison:

The following table compares the key functional differences between MinIO deployments:

.. list-table::
   :header-rows: 1
   :width: 100%

   * - 
     - :guilabel:`Single-Node Single-Drive`
     - :guilabel:`Single-Node Multi-Drive`
     - :guilabel:`Multi-Node Multi-Drive`

   * - Site-to-Site Replication
     - Client-Side via :mc:`mc mirror`
     - :ref:`Server-Side Replication <minio-bucket-replication>`
     - :ref:`Server-Side Replication <minio-bucket-replication>`

   * - Versioning
     - No
     - :ref:`Object Versioning <minio-bucket-versioning>`
     - :ref:`Object Versioning <minio-bucket-versioning>`

   * - Retention
     - No
     - :ref:`Write-Once Read-Many Locking <minio-bucket-locking>`
     - :ref:`Write-Once Read-Many Locking <minio-bucket-locking>`

   * - High Availability / Redundancy
     - Drive Level Only (RAID and similar)
     - Drive Level only with :ref:`Erasure Coding <minio-erasure-coding>`
     - Drive and Server-Level with :ref:`Erasure Coding <minio-erasure-coding>`

   * - Scaling
     - No
     - :ref:`Server Pool Expansion <expand-minio-distributed>`
     - :ref:`Server Pool Expansion <expand-minio-distributed>`.

Site Replication
----------------

Site replication expands the features of bucket replication to include IAM, security tokens, service accounts, and bucket features the same across all sites.

:ref:`Site replication <minio-site-replication-overview>` links multiple MinIO deployments together and keeps the buckets, objects, and Identify and Access Management (IAM) settings in sync across all connected sites.

.. include:: /includes/common-replication.rst
   :start-after: start-mc-admin-replicate-what-replicates
   :end-before: end-mc-admin-replicate-what-replicates


What Does Not Replicate?
~~~~~~~~~~~~~~~~~~~~~~~~

Not everything replicates across sites.

.. include:: /includes/common-replication.rst
   :start-after: start-mc-admin-replicate-what-does-not-replicate
   :end-before: end-mc-admin-replicate-what-does-not-replicate

.. _minio-installation-platform-support:

Platform Support
----------------

MinIO provides builds of the MinIO server (:mc:`minio`) and the
MinIO :abbr:`CLI (Command Line Interface)` (:mc:`mc`) for the following
platforms. 

.. cond:: linux

   - Red Hat Enterprise Linux 8.5+ (including all binary-compatible RHEL alternatives)
   - Ubuntu 18.04+

   MinIO provides builds for the following architectures:

   - AMD64
   - ARM64
   - PowerPC 64 LE
   - S390X

.. cond:: macos

   MinIO recommends non-EOL macOS versions (10.14+).

.. cond:: windows

   MinIO recommends non-EOL Windows versions (Windows 10, Windows Server 2016+). 
   Support for running :ref:`distributed MinIO deployments <deploy-minio-distributed>` is *experimental* on Windows OS.


For unlisted platforms or architectures, please reach out to MinIO at 
hello@min.io for additional support and guidance. You can build MinIO from
:minio-git:`source <minio/#install-from-source>` and 
`cross-compile 
<https://golang.org/doc/install/source#bootstrapFromCrosscompiledSource>`__
for your platform and architecture combo. MinIO generally does not recommend
source-based installations in production environments.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/install-deploy-manage/deploy-minio-single-node-single-drive
   /operations/install-deploy-manage/deploy-minio-single-node-multi-drive
   /operations/install-deploy-manage/deploy-minio-multi-node-multi-drive
   /operations/install-deploy-manage/multi-site-replication