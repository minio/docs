
.. _deploy-operator-gke:

=================================================
Deploy MinIO Operator on Azure Kubernetes Service
=================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

`Azure Kubernetes Engine <https://azure.microsoft.com/en-us/products/kubernetes-service/#overview>`__ (AKS) is a highly available, secure, and fully managed Kubernetes service from Microsoft Azure.
The MinIO Kubernetes Operator supports deploying MinIO Tenants onto AKS infrastructure using the MinIO Operator Console, the :mc:`kubectl minio` CLI tool, or `kustomize <https://kustomize.io/>`__ for :minio-git:`YAML-defined deployments <operator/tree/master/examples/kustomization>`.

:minio-web:`Through the AKS Marketplace <product/multicloud-azure-kubernetes-service>`
   MinIO maintains an `AKS Marketplace listing <https://azuremarketplace.microsoft.com/en-us/marketplace/apps/minio.minio-object-storage_v1dot1>`__ through which you can register your AKS cluster with |subnet|.
   Any MinIO tenant you deploy through Marketplace-connected clusters can take advantage of SUBNET registration, including 24/7 access to MinIO engineers.

This page documents deploying the MinIO Operator through the CLI using Kustomize.
For instructions on deploying the MinIO Operator through the AKS Marketplace, see :minio-web:`Deploy MinIO through AKS <multicloud-azure-kubernetes-service/deploy>`

This documentation assumes familiarity with all referenced Kubernetes and Azure Kubernetes Service concepts, utilities, and procedures. 
While this documentation *may* provide guidance for configuring or deploying Kubernetes-related or Azure Kubernetes Service-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

Prerequisites
-------------

Existing AKS Cluster
~~~~~~~~~~~~~~~~~~~~

This procedure assumes an existing :abbr:`AKS (Azure Kubernetes Service)` cluster onto which you can deploy the MinIO Operator.

The Operator by default deploys pods and services with two replicas each and pod anti-affinity.
The AKS cluster should therefore have at least two nodes available for scheduling Operator pods and services.
While these nodes *may* be the same nodes intended for use by MinIO Tenants, co-locating Operator and Tenant pods may increase the risk of service interruptions due to the loss of any one node.

``kubectl`` Access to the AKS Cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure your host machine has a ``kubectl`` installation compatible with the target AKS cluster.
For guidance on connecting ``kubectl`` to AKS, see :aks-docs:`Install kubectl and configure cluster access <tutorial-kubernetes-deploy-cluster?tabs=azure-cli#connect-to-cluster-using-kubectl>`.

Procedure
---------

The following steps deploy Operator using Kustomize and a ``kustomization.yaml`` file from the MinIO Operator GitHub repository.

.. include:: /includes/common/common-install-operator-kustomize.rst
