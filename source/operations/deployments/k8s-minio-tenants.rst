===========================
MinIO Tenants on Kubernetes
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

A MinIO Tenant consists of a complete set of Kubernetes resources deployed within a namespace that support the MinIO Object Storage service.

This documentation assumes a :ref:`MinIO Operator installation <deploy-minio-operator>` on the target Kubernetes infrastructure.

Prerequisites
-------------

Your Kubernetes infrastructure must meet the following pre-requisites for deploying MinIO Tenants.

MinIO Kubernetes Operator
~~~~~~~~~~~~~~~~~~~~~~~~~

The procedures on this page *requires* a valid installation of the MinIO Kubernetes Operator and assumes the local host has a matching installation of the MinIO Kubernetes Operator. 
This procedure assumes the latest stable Operator, version |operator-version-stable|.

See :ref:`deploy-operator-kubernetes` for complete documentation on deploying the MinIO Operator.

Worker Nodes with Local Storage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO **strongly recommends** deploying Tenants onto Kubernetes worker nodes with locally attached storage.

The Worker Nodes should meet MinIO's :ref:`hardware checklist <minio-hardware-checklist>` for production environments.

Avoid colocating MinIO tenants onto worker nodes hosting other high-performance softwares, and where necessary to do so ensure you configure the appropriate limits and constraints to guarantee MinIO access to the necessary compute and storage resources.

.. _deploy-minio-tenant-pv:

Persistent Volumes
~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-admonitions.rst
   :start-after: start-exclusive-drive-access
   :end-before: end-exclusive-drive-access

MinIO can typically use any Kubernetes :kube-docs:`Persistent Volume (PV) <concepts/storage/persistent-volumes>` that supports the :kube-docs:`ReadWriteOnce <concepts/storage/persistent-volumes/#access-modes>` access mode.
MinIO's consistency guarantees require the exclusive storage access that ``ReadWriteOnce`` provides.
Additionally, MinIO recommends setting a reclaim policy of ``Retain`` for the PVC :kube-docs:`StorageClass <concepts/storage/storage-classes>`.
Where possible, configure the Storage Class, CSI, or other provisioner underlying the PV to format volumes as XFS to ensure best performance.

For Kubernetes clusters where nodes have Direct Attached Storage, MinIO strongly recommends using the `DirectPV CSI driver <https://min.io/directpv?ref=docs>`__. 
DirectPV provides a distributed persistent volume manager that can discover, format, mount, schedule, and monitor drives across Kubernetes nodes.
DirectPV addresses the limitations of manually provisioning and monitoring :kube-docs:`local persistent volumes <concepts/storage/volumes/#local>`.

For Tenants deploying onto Amazon Elastic, Azure, or Google Kubernetes, select the tabs below for specific guidance on PV configuration:

.. tab-set::

   .. tab-item:: Amazon EKS

      MinIO Tenants on EKS must use the :github:`EBS CSI Driver <kubernetes-sigs/aws-ebs-csi-driver>` to provision the necessary underlying persistent volumes.
      MinIO strongly recommends using SSD-backed EBS volumes for best performance.
      MinIO strongly recommends deploying EBS-based PVs with the XFS filesystem.
      Create a StorageClass for the MinIO EBS PVs and set the ``csi.storage.k8s.io/fstype`` `parameter <https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/parameters.md>`__ to ``xfs``  .

      MinIO recommends the following :github:`EBS volume types <kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/parameters.md>`:

      - ``io2`` (Provisioned IOPS SSD) **Preferred**
      - ``io1`` (Provisioned IOPS SSD)
      - ``gp3`` (General Purpose SSD)
      - ``gp2`` (General Purpose SSD)

      For more information on EBS resources, see `EBS Volume Types <https://aws.amazon.com/ebs/volume-types/>`__.
      For more information on StorageClass Parameters, see `StorageClass Parameters <https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/parameters.md>`__.

   .. tab-item:: Google GKS

      MinIO Tenants on GKE should use the :gke-docs:`Compute Engine Persistent Disk CSI Driver <how-to/persistent-volumes/gce-pd-csi-driver>` to provision the necessary underlying persistent volumes.

      MinIO recommends the following :gke-docs:`GKE CSI Driver <how-to/persistent-volumes/gce-pd-csi-driver>` storage classes:

      - ``standard-rwo`` (Balanced Persistent SSD)
      - ``premium-rwo`` (Performance Persistent SSD)

      MinIO strongly recommends SSD-backed disk types for best performance.
      For more information on GKE disk types, see :gcp-docs:`Persistent Disks <disks>`.

   .. tab-item:: Azure AKS

      MinIO Tenants on AKS should use the :azure-docs:`Azure Disks CSI driver <azure-disk-csi>` to provision the necessary underlying persistent volumes.

      MinIO recommends the following :aks-docs:`AKS CSI Driver <azure-disk-csi>` storage classes:

      - ``managed-csi`` (Standard SSD)
      - ``managed-csi-premium`` (Premium SSD)

      MinIO strongly recommends SSD-backed disk types for best performance.
      For more information on AKS disk types, see :azure-docs:`Azure disk types <virtual-machines/disk-types>`.

Tenant Namespace
~~~~~~~~~~~~~~~~

When you use the Operator to create a tenant, the tenant *must* have its own namespace.
Within that namespace, the Operator generates the pods required by the tenant configuration.

Each Tenant pod runs three containers:

- MinIO Container that runs all of the standard MinIO functions, equivalent to basic MinIO installation on baremetal.
  This container stores and retrieves objects in the provided mount points (persistent volumes). 

- InitContainer that only exists during the launch of the pod to manage configuration secrets during startup.
  Once startup completes, this container terminates. 

- SideCar container that monitors configuration secrets for the tenant and updates them as they change.
  This container also monitors for root credentials and creates an error if it does not find root credentials. 

Starting with v5.0.6, the MinIO Operator supports custom :kube-docs:`init containers <concepts/workloads/pods/init-containers>` for additional pod initialization that may be required for your environment.

The tenant utilizes Persistent Volume Claims to talk to the Persistent Volumes that store the objects.

.. image:: /images/k8s/OperatorsComponent-Diagram.png
   :width: 600px
   :alt: A diagram of the namespaces and pods used by or maintained by the MinIO Operator.
   :align: center

.. toctree::
   :titlesonly:
   :hidden:

   /operations/deployments/k8s-deploy-minio-tenant-on-kubernetes
   /operations/deployments/k8s-deploy-minio-tenant-helm-on-kubernetes
   /operations/deployments/k8s-modify-minio-tenant-on-kubernetes
   /operations/deployments/k8s-upgrade-minio-tenant-on-kubernetes
   /operations/deployments/k8s-expand-minio-tenant-on-kubernetes
   /operations/deployments/k8s-delete-minio-tenant-on-kubernetes