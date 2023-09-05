.. _minio-installation:

========================
Install and Deploy MinIO
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. container:: extlinks-video

   - `Installing and Running MinIO: Overview <https://youtu.be/mg9NRR6Js1s?ref=docs>`__
   - `Installing and Running MinIO: Installation Lab <https://youtu.be/Z0FtabDUPtU?ref=docs>`__
   - `Installing and Running MinIO: Docker Compose Overview <https://youtu.be/FtJA3TmjaJQ?ref=docs>`__
   - `Installing and Running MinIO: Docker Compose Lab: <https://youtu.be/tRlEctAwkk8?ref=docs>`__

MinIO is a software-defined high performance distributed object storage server.
You can run MinIO on consumer or enterprise-grade hardware and a variety of operating systems and architectures.

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

This documentation provides instructions for |SNSD| and |SNMD| for supporting local development and evaluation of MinIO on a single host machine **only**. 
For |MNMD| deployments, use the MinIO Kubernetes Operator to deploy and manage MinIO tenants in a containerized and orchestrated environment.

.. _minio-installation-platform-support:

Platform Support
----------------

MinIO provides container images at the following repositories:

- https://hub.docker.com/r/minio/minio
- https://quay.io/repository/minio/minio?tab=info

.. versionchanged:: RELEASE.2022-12-02T19-19-22Z

   These images include the :ref:`MinIO Client <minio-client>` command line tool built in for container-level debugging.
   However, to regularly interact with a container MinIO install, :ref:`install the MinIO Client <mc-install>` on your computer and define an :mc:`alias <mc alias set>` to the container instead.

Use of MinIO images from any other repository, host, or organization is at your own risk.

The :ref:`Single-Node Single-Drive <minio-snsd>` and :ref:`Single-Node Multi-Drive <minio-snmd>` tutorials provide instructions for the `Docker <https://www.docker.com/>`__ and :podman-docs:`Podman <>` container managers.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/install-deploy-manage/deploy-minio-single-node-single-drive
   /operations/install-deploy-manage/deploy-minio-single-node-multi-drive
