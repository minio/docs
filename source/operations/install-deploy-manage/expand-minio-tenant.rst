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

MinIO Kubernetes Operator
~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure on this page *requires* a valid installation of the MinIO Kubernetes Operator and assumes the local host has a matching installation of the MinIO Kubernetes Operator.
This procedure assumes the latest stable Operator, version |operator-version-stable|.

See :ref:`deploy-operator-kubernetes` for complete documentation on deploying the MinIO Operator.


Available Worker Nodes
~~~~~~~~~~~~~~~~~~~~~~

MinIO deploys additional :mc:`minio server <minio.server>` pods as part of the new Tenant pool.
The Kubernetes cluster *must* have sufficient available worker nodes on which to schedule the new pods.

The MinIO Operator provides configurations for controlling pod affinity and anti-affinity to direct scheduling to specific workers.

Persistent Volumes
~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-admonitions.rst
   :start-after: start-exclusive-drive-access
   :end-before: end-exclusive-drive-access

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

Procedure (Operator Console)
----------------------------

The MinIO Operator Console supports expanding a MinIO Tenant by adding additional pools.


1) Expand the MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~

#. From the Operator Console view, select the Tenant to open the summary view, then select :guilabel:`Pools`.
   Select :guilabel:`Expand Tenant`.

#. Specify the following information for the new pool:

   .. list-table::
      :header-rows: 1
      :widths: 30 70
      :width: 100%

      * - Field
        - Description

      * - Number of Servers
        - The number of servers to deploy in the new Tenant Pool across the Kubernetes cluster.
     
      * - Volume Size
        - The capacity of each volume in the new Tenant Pool.
     
      * - Volumes per Server
        - The number of volumes for each server in the new Tenant Pool.

      * - Storage Class
        - Specify the Kubernetes Storage Class the Operator uses when generating Persistent Volume Claims for the Tenant.
     
#. Select :guilabel:`Create`.


2) Validate the Expanded MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the :guilabel:`Pools` tab, select the new Pool to confirm its details.
