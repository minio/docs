.. _minio-snmd:

=====================================
Deploy MinIO: Single-Node Multi-Drive
=====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The procedures on this page cover deploying MinIO in a Single-Node Multi-Drive (SNMD) configuration.
|SNMD| deployments provide drive-level reliability and failover/recovery with performance and scaling limitations imposed by the single node.

.. cond:: linux or macos or windows

   For production environments, MinIO strongly recommends deploying with the :ref:`Multi-Node Multi-Drive (Distributed) <minio-mnmd>` topology for enterprise-grade performance, availability, and scalability.

.. cond:: container

   For production environments, MinIO strongly recommends using the MinIO Kubernetes Operator to deploy Multi-Node Multi-Drive (MNMD) or "Distributed" Tenants.

Prerequisites
-------------

Storage Requirements
~~~~~~~~~~~~~~~~~~~~

.. |deployment| replace:: deployment

.. include:: /includes/common-installation.rst
   :start-after: start-storage-requirements-desc
   :end-before: end-storage-requirements-desc

Memory Requirements
~~~~~~~~~~~~~~~~~~~

Starting with :minio-release:`RELEASE.2024-01-28T22-35-53Z`, MinIO pre-allocates 1GiB of system memory at startup.

For development environments, you can specify the ``CI_CD=TRUE`` environment variable to reduce the allocation to 256MiB.

.. _deploy-minio-standalone-multidrive:

Deploy Single-Node Multi-Drive MinIO
------------------------------------

The following procedure deploys MinIO consisting of a single MinIO server and a multiple drives or storage volumes.

.. cond:: linux

   .. include:: /includes/linux/steps-deploy-minio-single-node-multi-drive.rst

.. cond:: macos

   .. include:: /includes/macos/steps-deploy-minio-single-node-multi-drive.rst

.. cond:: container

  .. include:: /includes/container/steps-deploy-minio-single-node-multi-drive.rst