.. _minio-installation:

===============================
Deploy and Manage MinIO Tenants
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

The MinIO Kubernetes Operator supports deploying and managing MinIO Tenants onto your Kubernetes cluster through the Operator Console web interface.


The following tutorials provide steps for tenant management via the Operator Console and Kustomize:

.. list-table::
   :stub-columns: 1
   :widths: 40 60
   :width: 100%

   * - :ref:`minio-k8s-deploy-minio-tenant`
     - Deploy a new MinIO Tenant onto the Kubernetes cluster.

   * - :ref:`minio-k8s-modify-minio-tenant`
     - Modify the configuration or topology settings of a MinIO Tenant.

   * - :ref:`minio-k8s-upgrade-minio-tenant`
     - Upgrade the MinIO Server version used by a MinIO Tenant.

   * - :ref:`minio-k8s-expand-minio-tenant`
     - Increase the available storage capacity of an existing MinIO Tenant.

   * - :ref:`minio-k8s-delete-minio-tenant`
     - Delete an existing MinIO Tenant.

   * - :ref:`minio-site-replication-overview`
     - Configure two or more MinIO Tenants as peers for MinIO Site Replication

.. toctree::
   :titlesonly:
   :hidden:

   /operations/install-deploy-manage/deploy-minio-tenant
   /operations/install-deploy-manage/modify-minio-tenant
   /operations/install-deploy-manage/upgrade-minio-tenant
   /operations/install-deploy-manage/multi-site-replication
   /operations/install-deploy-manage/minio-operator-console
