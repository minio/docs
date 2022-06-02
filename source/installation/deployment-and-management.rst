.. _minio-installation:

=========================
Deployment and Management
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO is a software-defined high performance distributed object storage server.
You can run MinIO on consumer or enterprise-grade hardware and a variety
of operating systems and architectures.

.. _minio-installation-comparison:

MinIO supports three deployment topologies: 

Single-Node Single-Drive (SNSD)
  A single MinIO server with a single storage volume or folder. 
  |SNSD| deployments are best suited for evaluation and initial development of applications using MinIO for object storage.
  This topology was previously referred to as :guilabel:`Standalone Mode`.

  Starting with :minio-release:`RELEASE.2022-06-02T02-11-04Z`, |SNSD| deployments implement a zero-parity erasure coding backend and include support for the following erasure-coding dependent features:

  - Versioning
  - Object Locking / Retention

  This topology is incompatible with the older filesystem-style behavior where MinIO acted as a simple S3 API layer while allowing POSIX-style access to managed files.

Single-Node Multi-Drive (SNMD)
  A single MinIO server with four or more storage volumes. 
  |SNMD| deployments provide drive-level reliability and failover only.

Multi-Node Multi-Drive (MNMD or "Distributed")
  Multiple MinIO servers with at least four drives across all servers. 
  The distributed |MNMD| topology supports production-grade object storage with drive and node-level availability and resiliency.

For tutorials on deploying or expanding a distributed MinIO deployment, see:

- :ref:`deploy-minio-distributed`
- :ref:`expand-minio-distributed`

For instructions on deploying MinIO in Kubernetes, see 
:docs-k8s:`Deploy a MinIO Tenant using the MinIO Kubernetes Plugin 
<tenant-management/deploy-minio-tenant.html>`

For tutorials on deploying a standalone MinIO deployment, see:

- :ref:`deploy-minio-standalone`
- :ref:`deploy-minio-standalone-container`

.. _minio-installation-platform-support:

Platform Support
----------------

MinIO provides builds of the MinIO server (:mc:`minio`) and the
MinIO :abbr:`CLI (Command Line Interface)` (:mc:`mc`) for the following
platforms. 

.. list-table::
   :stub-columns: 1
   :widths: 20 80
   :width: 100%

   * - Linux
     - MinIO recommends RHEL8+ or Ubuntu 18.04+.
   
       MinIO provides builds for the following architectures:

       - AMD64
       - ARM64
       - PowerPC 64 LE
       - S390X

   * - macOS
     - MinIO recommends non-EOL macOS versions (10.14+).

   * - Microsoft Windows
     - MinIO recommends non-EOL Windows versions (Windows 10, Windows Server 
       2016+). Support for running :ref:`distributed MinIO deployments 
       <deploy-minio-distributed>` is *experimental* on Windows OS.


For unlisted platforms or architectures, please reach out to MinIO at 
hello@min.io for additional support and guidance. You can build MinIO from
:minio-git:`source <minio/#install-from-source>` and 
`cross-compile 
<https://golang.org/doc/install/source#bootstrapFromCrosscompiledSource>`__
for your platform and architecture combo. MinIO generally does not recommend
source-based installations in production environments.

.. _minio-preexisting-data:

Pre-Existing Data
-----------------

Standalone Deployments
~~~~~~~~~~~~~~~~~~~~~~

When deploying a new MinIO server instance, you can choose a storage location that contains existing data only for standlone deployments.
For standalone deployments, MinIO adds the existing data as buckets and objects as part of starting the server.

.. important::
   
   Files at the root of the starting path do not display in MinIO.
   Existing data must be in folders in the starting path.
   Top level folders become MinIO buckets.

Distributed Deployments
~~~~~~~~~~~~~~~~~~~~~~~

Once you start a standalone server, you can create or delete buckets and objects either with :ref:`MinIO Console <minio-console>`, the :ref:`mc client <minio-client>`, or directly in the file system.

For a distributed MinIO deployment, the starting path must be empty.

Once you start a distributed server, MinIO does not support manipulating the data directly on the storage location outside of the S3 API.
Manipulating files directly on the storage locations can result in data corruption or data loss.

For example, you cannot navigate to the storage location using a file explorer program and add or remove files.

Instead, use the :ref:`MinIO Client <minio-client>`, the :ref:`MinIO Console <minio-console>`, or one of the MinIO :ref:`Software Development Kits <minio-drivers>` to work with the buckets and objects for distributed deployments.


.. toctree::
   :titlesonly:
   :hidden:

   /installation/deploy-minio-distributed
   /installation/expand-minio-distributed
   /installation/deploy-minio-single-node-single-drive
   /installation/upgrade-minio
   /installation/restore-minio
   /installation/decommission-pool