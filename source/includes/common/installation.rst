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

MinIO supports three deployment modes: 

Standalone Single-Drive
   A single MinIO server with a single storage volume or folder, also referred to as "Filesystem Mode".
   Standalone single deployments are best suited for evaluation and initial development of applications using MinIO for object storage, *or* for providing an S3 access layer to single storage volume.
   
   Standalone deployments do not provide access to the full set of MinIO's advanced S3 features and functionality - specifically those dependent on :ref:`Erasure Coding <minio-erasure-coding>`.

Standalone Multi-Drive
   A single MinIO server with *at least* four storage volumes or folders.
   A standalone multi-drive deployment supports and enables :ref:`erasure coding <minio-erasure-coding>` and its dependent features.

   Standalone multi-drive deployments can only provide drive-level availability and performance scaling.
   Use standalone multi-drive deployments for small-scale environments which do not require high availability or scalable performance characteristics.

Distributed Deployments
   One or more MinIO servers with *at least* four total storage volumes across all servers.
   A distributed deployment supports and enables :ref:`erasure coding <minio-erasure-coding>` and its dependent features.

   Distributed deployments provide drive and server-level availability and performance scaling.
   Distributed deployments are best for production environments and workloads.

   MinIO recommends a baseline topology of 4 nodes with 4 drives each for production environments.
   This topology provides continuity with the loss of up to one server *or* four drives across all servers.

.. _minio-installation-comparison:

The following table compares the key functional differences between MinIO deployments:

.. list-table::
   :header-rows: 1
   :width: 100%

   * - 
     - :guilabel:`Standalone Single-Drive`
     - :guilabel:`Standalone Multi-Drive`
     - :guilabel:`Distributed`

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