.. _deploy-operator-gke:

=================================================
Deploy MinIO Operator on Google Kubernetes Engine
=================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

`Google  Kubernetes Engine <https://cloud.google.com/kubernetes-engine?ref=minio-docs>`__ (GKE) offers a highly automated secure and fully managed Kubernetes platform.
The MinIO Kubernetes Operator supports deploying MinIO Tenants onto GKE infrastructure using the MinIO Operator Console, the :mc:`kubectl minio` CLI tool, or `kustomize <https://kustomize.io/>`__ for :minio-git:`YAML-defined deployments <operator/tree/master/examples/kustomization>`.

:minio-web:`Through the GKE Marketplace <product/multicloud-google-kubernetes-service>`
   MinIO maintains an `GKE Marketplace listing <https://console.cloud.google.com/marketplace/product/minio-inc-public/minio-enterprise?pli=1&project=peak-essence-171622>`__ through which you can register your GKE cluster with |subnet|.
   Any MinIO tenant you deploy through Marketplace-connected clusters can take advantage of SUBNET registration, including 24/7 direct access to MinIO engineers.

Using the MinIO ``kubectl`` Plugin
   MinIO provides a ``kubectl`` plugin for installing and managing the MinIO Operator and Tenants through a terminal or shell (CLI) environment.
   You can manually register these tenants with |subnet| at any time.

This page documents deploying the MinIO Operator through the CLI using the ``kubectl minio`` plugin.
For instructions on deploying the MinIO Operator through the GKE Marketplace, see :minio-web:`Deploy MinIO through GKE <product/multicloud-google-kubernetes-service/deploy>`

This documentation assumes familiarity with all referenced Kubernetes and Google Kubernetes Engine concepts, utilities, and procedures. 
While this documentation *may* provide guidance for configuring or deploying Kubernetes-related or Google Kubernetes Engine-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

Prerequisites
-------------

Existing GKE Cluster
~~~~~~~~~~~~~~~~~~~~

This procedure assumes an existing :abbr:`GKE (Google Kubernetes Engine)` cluster onto which you can deploy the MinIO Operator.

The Operator by default deploys pods and services with two replicas each and pod anti-affinity.
The GKE cluster should therefore have at least two nodes available for scheduling Operator pods and services.
While these nodes *may* be the same nodes intended for use by MinIO Tenants, co-locating Operator and Tenant pods may increase the risk of service interruptions due to the loss of any one node.

``kubectl`` Access to the GKE Cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure your host machine has a ``kubectl`` installation compatible with the target GKE cluster.
For guidance on connecting ``kubectl`` to GKE, see :gke-docs:`Install kubectl and configure cluster access <how-to/cluster-access-for-kubectl>`.

Procedure
---------

.. include:: /includes/common/common-install-operator-kubectl-plugin-install-init.rst
.. include:: /includes/common/common-install-operator-kubectl-validate-open-console.rst

.. toctree::
   :titlesonly:
   :hidden:

   /operations/install-deploy-manage/upgrade-minio-operator
