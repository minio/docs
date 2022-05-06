.. _minio-manage:

=================================
Manage Existing MinIO Deployments
=================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Management of an existing MinIO deployment typically falls into the following categories:

Expansion
   Increase the total storage capacity of the MinIO Deployment by adding a Server Pool

Upgrade
   Test and deploy the latest stable version of MinIO to take advantage of new features, fixes, and performance improvements.

Decommission
   Drain data from an older storage pool in preparation for removing it from the deployment

.. toctree::
   :titlesonly:
   :hidden:

   /operations/install-deploy-manage/expand-minio-deployment
   /operations/install-deploy-manage/upgrade-minio-deployment
   /operations/install-deploy-manage/decommission-server-pool