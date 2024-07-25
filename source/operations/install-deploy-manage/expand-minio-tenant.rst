.. _minio-k8s-expand-minio-tenant:

=====================
Expand a MinIO Tenant
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1


This procedure documents expanding the available storage capacity of an existing MinIO tenant by deploying an additional pool of MinIO pods in the Kubernetes infrastructure.

.. important::

   The MinIO Operator Console is deprecated and removed in Operator 6.0.0.

   See :ref:`minio-k8s-modify-minio-tenant` for instructions on migrating Tenants installed via the Operator Console to Kustomization.

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

Procedure
---------

The MinIO Operator supports expanding a MinIO Tenant by adding additional pools.

.. tab-set::

   .. tab-item:: Kustomization

      #. Review the Kustomization object which describes the Tenant object (``tenant.yaml``).

         The ``spec.pools`` array describes the current pool topology.

      #. Add a new document to the ``spec.pools`` array.

         The new pool must reflect your intended combination of Worker nodes, volumes per server, storage class, and affinity/scheduler settings.
         See :ref:`minio-operator-crd` for more complete documentation on Pool-related configuration settings.

      #. Apply the updated Tenant configuration

         Use the ``kubectl apply`` command to update the Tenant:

         .. code-block:: shell

            kubectl apply -k ~/kustomization/TENANT-NAME

         Modify the path to the Kustomization directory to match your local configuration.

   .. tab-item:: Helm

      #. Review the Helm ``values.yaml`` object.

         The ``tenant.pools`` array describes the current pool topology.

      #. Add a new document to the ``tenant.pools`` array.

         The new pool must reflect your intended combination of Worker nodes, volumes per server, storage class, and affinity/scheduler settings.
         See :ref:`minio-tenant-chart-values` for more complete documentation on Pool-related configuration settings.

      #. Apply the updated Tenant configuration

         Use the ``helm upgrade`` command to update the Tenant:

         .. code-block:: shell

            helm upgrade TENANT-NAME minio-operator/tenant -f values.yaml -n TENANT-NAMESPACE

         The command above assumes use of the MinIO Operator Chart repository.
         If you installed the Chart manually or by using a different repository name, specify that chart or name in the command.

         Replace ``TENANT-NAME`` and ``TENANT-NAMESPACE`` with the name and namespace of the Tenant respectively.
         You can use ``helm list -n TENANT-NAMESPACE`` to validate the Tenant name.

You can use the ``watch kubectl get all -n TENANT-NAMESPACE`` to monitor the progress of expansion.
The MinIO Operator updates services to route connections appropriately across the new nodes.
If you use customized services, routes, ingress, or similar Kubernetes network components, you may need to update those components for the new pod hostname ranges.

.. Following link is intended for K8s only
.. _minio-decommissioning:

Decommission a Tenant Server Pool
----------------------------------

Decommissioning a server pool involves three steps:

1) Run the :mc-cmd:`mc admin decommission start` command against the Tenant

2) Wait until decomissioning completes

3) Modify the Tenant YAML to remove the decomissioned pool

When removing the Tenant pool, ensure the ``spec.pools.[n].name`` fields have values for all remaining pools.

.. include:: /includes/common-installation.rst
   :start-after: start-pool-order-must-not-change
   :end-before: end-pool-order-must-not-change

.. important::

   You cannot reuse the same pool name or hostname sequence for a decomissioned pool.