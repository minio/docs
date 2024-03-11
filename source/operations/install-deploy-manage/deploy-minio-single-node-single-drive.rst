.. _minio-snsd:

======================================
Deploy MinIO: Single-Node Single-Drive
======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The procedures on this page cover deploying MinIO in a Single-Node Single-Drive (SNSD) configuration for early development and evaluation.
|SNSD| deployments use a zero-parity erasure coded backend that provides no added reliability or availability beyond what the underlying storage volume implements.
These deployments are best suited for local testing and evaluation, or for small-scale data workloads that do not have availability or performance requirements.

.. cond:: container

   For extended development or production environments in orchestrated environments, use the MinIO Kubernetes Operator to deploy a Tenant on multiple worker nodes.

.. cond:: linux

   For extended development or production environments, deploy MinIO in a :ref:`Multi-Node Multi-Drive (Distributed) <minio-mnmd>` topology

.. important::

   :minio-release:`RELEASE.2022-10-29T06-21-33Z` fully removes the `deprecated Gateway/Filesystem <https://blog.min.io/deprecation-of-the-minio-gateway/>`__ backends.
   MinIO returns an error if it starts up and detects existing Filesystem backend files.

   To migrate from an FS-backend deployment, use :mc:`mc mirror` or :mc:`mc cp` to copy your data over to a new MinIO |SNSD| deployment.
   You should also recreate any necessary users, groups, policies, and bucket configurations on the |SNSD| deployment.

.. _minio-snsd-pre-existing-data:

Pre-Existing Data
-----------------

MinIO startup behavior depends on the the contents of the specified storage volume or path.
The server checks for both MinIO-internal backend data and the structure of existing folders and files.
The following table lists the possible storage volume states and MinIO behavior:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Storage Volume State
     - Behavior

   * - Empty with **no** files, folders, or MinIO backend data
       
     - MinIO starts in |SNSD| mode and creates the zero-parity backend

   * - Existing |SNSD| zero-parity objects and MinIO backend data
     - MinIO resumes in |SNSD| mode

   * - Existing filesystem folders, files, but **no** MinIO backend data
     - MinIO returns an error and does not start

   * - Existing filesystem folders, files, and legacy "FS-mode" backend data
     - MinIO returns an error and does not start

       .. versionchanged:: RELEASE.2022-10-29T06-21-33Z

Prerequisites
-------------

Storage Requirements
~~~~~~~~~~~~~~~~~~~~

The following requirements summarize the :ref:`minio-hardware-checklist-storage` section of MinIO's hardware recommendations:

Use Local Storage
   Direct-Attached Storage (DAS) has significant performance and consistency advantages over networked storage (:abbr:`NAS (Network Attached Storage)`, :abbr:`SAN (Storage Area Network)`, :abbr:`NFS (Network File Storage)`).
   MinIO strongly recommends flash storage (NVMe, SSD) for primary or "hot" data.

Use XFS-Formatting for Drives
   MinIO strongly recommends provisioning XFS formatted drives for storage.
   MinIO uses XFS as part of internal testing and validation suites, providing additional confidence in performance and behavior at all scales.

Persist Drive Mounting and Mapping Across Reboots
   Use ``/etc/fstab`` to ensure consistent drive-to-mount mapping across node reboots.

   Non-Linux Operating Systems should use the equivalent drive mount management tool.

Memory Requirements
~~~~~~~~~~~~~~~~~~~

.. versionchanged:: RELEASE.2024-01-28T22-35-53Z

   MinIO pre-allocates 2GiB of system memory at startup.

MinIO recommends a *minimum* of 32GiB of memory per host.
See :ref:`minio-hardware-checklist-memory` for more guidance on memory allocation in MinIO.

.. _deploy-minio-standalone:

Deploy Single-Node Single-Drive MinIO
-------------------------------------

The following procedure deploys MinIO consisting of a single MinIO server and a single drive or storage volume.

.. admonition:: Network File System Volumes Break Consistency Guarantees
   :class: note

   MinIO's strict **read-after-write** and **list-after-write** consistency
   model requires local drive filesystems.

   MinIO cannot provide consistency guarantees if the underlying storage
   volumes are NFS or a similar network-attached storage volume. 

.. cond:: linux

   .. include:: /includes/linux/steps-deploy-minio-single-node-single-drive.rst

.. cond:: macos

   .. include:: /includes/macos/steps-deploy-minio-single-node-single-drive.rst

.. cond:: container

   .. include:: /includes/container/steps-deploy-minio-single-node-single-drive.rst

.. cond:: windows

   .. include:: /includes/windows/steps-deploy-minio-single-node-single-drive.rst
