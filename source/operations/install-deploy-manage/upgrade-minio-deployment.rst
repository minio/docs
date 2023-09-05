.. _minio-upgrade:

==========================
Upgrade a MinIO Deployment
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. admonition:: Test Upgrades In a Lower Environment
   :class: important

   Your unique deployment topology, workload patterns, or overall environment requires testing of any MinIO upgrades in a lower environment (Dev/QA/Staging) *before* applying those upgrades to Production deployments, or any other environment containing critical data.
   Performing "blind" updates to production environments is done at your own risk.

   For MinIO deployments that are significantly behind latest stable (6+ months), consider using |SUBNET| for additional support and guidance during the upgrade procedure.

.. cond:: linux

   .. include:: /includes/linux/steps-upgrade-minio-deployment.rst

.. cond:: container

   .. include:: /includes/container/steps-upgrade-minio-deployment.rst

.. cond:: windows

   .. include:: /includes/windows/steps-upgrade-minio-deployment.rst

.. cond:: macos

   .. include:: /includes/macos/steps-upgrade-minio-deployment.rst