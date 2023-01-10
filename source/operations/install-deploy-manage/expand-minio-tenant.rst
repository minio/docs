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

Persistent Volumes
~~~~~~~~~~~~~~~~~~

.. cond:: not eks

   MinIO can use any Kubernetes :kube-docs:`Persistent Volume (PV) <concepts/storage/persistent-volumes>` that supports the :kube-docs:`ReadWriteOnce <concepts/storage/persistent-volumes/#access-modes>` access mode.
   MinIO's consistency guarantees require the exclusive storage access that ``ReadWriteOnce`` provides.

   For Kubernetes clusters where nodes have Direct Attached Storage, MinIO strongly recommends using the `DirectPV CSI driver <https://min.io/directpv?ref=docs>`__. 
   DirectPV provides a distributed persistent volume manager that can discover, format, mount, schedule, and monitor drives across Kubernetes nodes.
   DirectPV addresses the limitations of manually provisioning and monitoring :kube-docs:`local persistent volumes <concepts/storage/volumes/#local>`.

.. cond:: eks

   MinIO Tenants on EKS must use the :github:`EBS CSI Driver <kubernetes-sigs/aws-ebs-csi-driver>` to provision the necessary underlying persistent volumes.
   MinIO strongly recommends using SSD-backed EBS volumes for best performance.
   For more information on EBS resources, see `EBS Volume Types <https://aws.amazon.com/ebs/volume-types/>`__.

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
     - .. cond:: not eks
     
          Specify the Kubernetes Storage Class the Operator uses when generating Persistent Volume Claims for the Tenant.

          Ensure the specified storage class has sufficient available Persistent Volume resources to match each generated Persistent Volume Claim.

       .. cond:: eks

          Specify the EBS volume type to use for this tenant.
          The following list is populated based on the AWS EBS CSI driver list of supported :github:`EBS volume types <kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/parameters.md>`:

          - ``gp3`` (General Purpose SSD)
          - ``gp2`` (General Purpose SSD)
          - ``io2`` (Provisioned IOPS SSD)
          - ``io1`` (Provisioned IOPS SSD)
          - ``st1`` (Throughput Optimized HDD)
          - ``sc1`` (Cold Storage HDD)

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
