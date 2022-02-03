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

MinIO supports two deployment modes: :guilabel:`Standalone` and 
:guilabel:`Distributed`:

Standalone Deployments
   A single MinIO server with a single storage volume or folder. Standalone
   deployments are best suited for evaluation and initial development of
   applications using MinIO for object storage, *or* for providing an S3 access
   layer to single storage volume. Standalone deployments do not provide access
   to the full set of MinIO's advanced S3 features and functionality.

Distributed Deployments
   One or more MinIO servers with *at least* four total storage volumes across
   all servers. Distributed deployments are best for production environments and
   workloads and support all of MinIO's core and advanced S3 features and
   functionality.

   MinIO recommends a baseline topology of 4 nodes with 4 drives each 
   for production environments.

.. _minio-installation-comparison:

The following table compares the key functional differences between
:guilabel:`Standalone` and :guilabel:`Distributed` MinIO deployments:

.. list-table::
   :header-rows: 1
   :widths: 20 40 40 
   :width: 100%

   * - 
     - :guilabel:`Standalone`
     - :guilabel:`Distributed`

   * - Site-to-Site Replication
     - Client-Side via :mc:`mc mirror`
     - :ref:`Server-Side Replication <minio-bucket-replication>`

   * - Versioning
     - No
     - :ref:`Object Versioning <minio-bucket-versioning>`

   * - Retention
     - No
     - :ref:`Write-Once Read-Many Locking <minio-bucket-locking>`

   * - High Availability / Redundancy
     - Drive Level Only (RAID and similar)
     - :ref:`Erasure Coding <minio-erasure-coding>`

   * - Scaling
     - No
     - :ref:`Server Pool Expansion <expand-minio-distributed>`.

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

.. toctree::
   :titlesonly:
   :hidden:

   /installation/deploy-minio-distributed
   /installation/expand-minio-distributed
   /installation/deploy-minio-standalone
   /installation/upgrade-minio
   /installation/restore-minio
   /installation/decommission-pool