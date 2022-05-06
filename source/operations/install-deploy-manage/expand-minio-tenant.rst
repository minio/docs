.. _minio-k8s-expand-minio-tenant:

=====================
Expand a MinIO Tenant
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1


This procedure documents expanding the available storage capacity of an existing MinIO tenant by deploying an additional pool of MinIO pods in the Kubernetes infrastructure.

Prerequisites
-------------

MinIO Kubernetes Operator and Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedures on this page *requires* a valid installation of the MinIO Kubernetes Operator and assumes the local host has a matching installation of the MinIO Kubernetes Operator.
This procedure assumes the latest stable Operator and Plugin version |operator-version-stable|.

See :ref:`deploy-operator-kubernetes` for complete documentation on deploying the MinIO Operator.

.. include:: /includes/k8s/install-minio-kubectl-plugin.rst

Available Worker Nodes
~~~~~~~~~~~~~~~~~~~~~~

MinIO deploys additional :mc:`minio server <minio.server>` pods as part of the new Tenant pool.
The Kubernetes cluster *must* have sufficient available worker nodes on which to schedule the new pods.

The MinIO Operator provides configurations for controlling pod affinity and anti-affinity to direct scheduling to specific workers.

Locally Attached Drives
~~~~~~~~~~~~~~~~~~~~~~~

MinIO *strongly recommends* using locally attached drives on each node intended to support the new tenant pool to ensure optimal performance.
MinIO’s strict read-after-write and list-after-write consistency model requires local disk filesystems (xfs, ext4, etc.). 

MinIO automatically generates :kube-docs:`Persistent Volume Claims (PVC) <concepts/storage/persistent-volumes/#persistentvolumeclaims>` as part of deploying a MinIO Tenant. 
The Operator generates one PVC for each volume in the new pool.

This procedure uses the MinIO :minio-git:`DirectPV <directpv>` driver to automatically provision Persistent Volumes from locally attached drives to support the generated PVC. 
See the :minio-git:`DirectPV Documentation <directpv/blob/master/README.md>` for installation and configuration instructions.

For clusters which cannot deploy MinIO DirectPV, :kube-docs:`Local Persistent Volumes <concepts/storage/volumes/#local>`.

The following tabs provide example YAML objects for a local persistent volume and a supporting :kube-docs:`StorageClass <concepts/storage/storage-classes/>`:

.. tab-set::
   
   .. tab-item:: Local Persistent Volume

      The following YAML describes a :kube-docs:`Local Persistent Volume <concepts/storage/volumes/#local>`:

      .. include:: /includes/k8s/deploy-tenant-requirements.rst
         :start-after: start-local-persistent-volume
         :end-before: end-local-persistent-volume

      Replace values in brackets ``<VALUE>`` with the appropriate value for the local drive.

   .. tab-item:: Storage Class

      The following YAML describes a :kube-docs:`StorageClass <concepts/storage/storage-classes/>` that meets the requirements for a MinIO Tenant:

      .. include:: /includes/k8s/deploy-tenant-requirements.rst
         :start-after: start-storage-class
         :end-before: end-storage-class

      The storage class *must* have ``volumeBindingMode: WaitForFirstConsumer``.
      Ensure all Persistent Volumes provisioned to support the MinIO Tenant use this storage class.

Procedure (CLI)
---------------

1) Expand the MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant expand` command to create the MinIO
Tenant.

The following example expands a MinIO Tenant with a Pool consisting of
4 Nodes with 4 locally-attached drives of 1Ti each:

.. code-block:: shell
   :class: copyable

   kubectl minio tenant expand minio-tenant-1   \
     --servers                 4                \
     --volumes                 16               \
     --capacity                16Ti             \
     --storage-class           local-storage    \
     --namespace               minio-tenant-1

The following table explains each argument specified to the command:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Argument
     - Description

   * - :mc-cmd:`minio-tenant-1 <kubectl minio tenant expand TENANT_NAME>`
     - The name of the MinIO Tenant which the command expands with the new pool.

   * - :mc-cmd:`~kubectl minio tenant expand --servers`
     - The number of ``minio`` servers to deploy in the new Tenant Pool across
       the Kubernetes cluster.

   * - :mc-cmd:`~kubectl minio tenant expand --volumes`
     - The number of volumes in the new Tenant Pool. :mc:`kubectl minio`
       determines the number of volumes per server by dividing ``volumes`` by
       ``servers``.

   * - :mc-cmd:`~kubectl minio tenant expand --capacity`
     - The total capacity of the Tenant Pool. :mc:`kubectl minio` determines the
       capacity of each volume by dividing ``capacity`` by ``volumes``.

   * - :mc-cmd:`~kubectl minio tenant expand --storage-class`
     - The Kubernetes ``StorageClass`` to use when creating each PVC.

   * - :mc-cmd:`~kubectl minio tenant expand --namespace`
     - The Kubernetes namespace of the existing MinIO Tenant to which to add
       the new Tenant pool.

2) Validate the Expanded MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant info` command to return a summary of 
the MinIO Tenant, including the new Pool:

.. code-block:: shell
   :class: copyable

   kubectl minio tenant info minio-tenant-1 \
     --namespace minio-tenant-1
