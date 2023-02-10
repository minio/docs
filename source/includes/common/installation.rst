.. _minio-installation:

========================
Install and Deploy MinIO
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. container:: extlinks-video

   - `Installing and Running MinIO on Linux <https://www.youtube.com/watch?v=74usXkZpNt8&list=PLFOIsHSSYIK1BnzVY66pCL-iJ30Ht9t1o>`__

   - `Object Storage Essentials <https://www.youtube.com/playlist?list=PLFOIsHSSYIK3WitnqhqfpeZ6fRFKHxIr7>`__
   
   - `How to Connect to MinIO with JavaScript <https://www.youtube.com/watch?v=yUR4Fvx0D3E&list=PLFOIsHSSYIK3Dd3Y_x7itJT1NUKT5SxDh&index=5>`__

MinIO is a software-defined high performance distributed object storage server.
You can run MinIO on consumer or enterprise-grade hardware and a variety
of operating systems and architectures.

All MinIO deployments implement :ref:`Erasure Coding <minio-erasure-coding>` backends.
You can deploy MinIO using one of the following topologies: 

.. _minio-installation-comparison:

:ref:`Single-Node Single-Drive <minio-snsd>` (SNSD or "Standalone")
  Local development and evaluation with no/limited reliability

:ref:`Single-Node Multi-Drive <minio-snmd>` (SNMD or "Standalone Multi-Drive")
  Workloads with lower performance, scale, and capacity requirements

  Drive-level reliability with configurable tolerance for loss of up to 1/2 all drives

  Evaluation of multi-drive topologies and failover behavior.

:ref:`Multi-Node Multi-Drive <minio-mnmd>` (MNMD or "Distributed")
  Enterprise-grade high-performance object storage

  Multi Node/Drive level reliability with configurable tolerance for loss of up to 1/2 all nodes/drives
       
  Primary storage for AI/ML, Distributed Query, Analytics, and other Data Lake components
       
  Scalable for Petabyte+ workloads - both storage capacity and performance

.. cond:: macos

   Use MacOS-based MinIO deployments for early development and evaluation.
   MinIO strongly recommends Linux (RHEL, Ubuntu) for long-term development and production environments.

Site Replication
----------------

Site replication expands the features of bucket replication to include IAM, security tokens, access keys, and bucket features the same across all sites.

:ref:`Site replication <minio-site-replication-overview>` links multiple MinIO deployments together and keeps the buckets, objects, and Identity and Access Management (IAM) settings in sync across all connected sites.

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

.. cond:: linux

   MinIO provides builds of the MinIO server (:mc:`minio`) and the
   MinIO :abbr:`CLI (Command Line Interface)` (:mc:`mc`) for the following
   platforms. 

   - Red Hat Enterprise Linux 8.5+ (including all binary-compatible RHEL alternatives)
   - Ubuntu 18.04+

   MinIO provides builds for the following architectures:

   - AMD64
   - ARM64
   - PowerPC 64 LE
   - S390X

.. cond:: macos

   MinIO recommends non-EOL macOS versions (10.14+).

For unlisted platforms or architectures, please reach out to MinIO at 
hello@min.io for additional support and guidance. You can build MinIO from
:minio-git:`source <minio/#install-from-source>` and 
`cross-compile 
<https://golang.org/doc/install/source#bootstrapFromCrosscompiledSource>`__
for your platform and architecture combo. MinIO generally does not recommend
source-based installations in production environments.

.. cond:: linux or macos

   .. toctree::
      :titlesonly:
      :hidden:

      /operations/install-deploy-manage/deploy-minio-single-node-single-drive
      /operations/install-deploy-manage/deploy-minio-single-node-multi-drive
      /operations/install-deploy-manage/deploy-minio-multi-node-multi-drive
      /operations/install-deploy-manage/multi-site-replication
