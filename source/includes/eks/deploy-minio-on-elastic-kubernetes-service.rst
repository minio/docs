.. _deploy-operator-eks:

==========================================================
Deploy MinIO Operator on Amazon Elastic Kubernetes Service
==========================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

:eks-docs:`Amazon® Elastic Kubernetes Service®  <what-is-eks.html>` (EKS) is an enterprise-ready Kubernetes container platform with full-stack automated operations to manage hybrid cloud, multi-cloud, and edge deployments. 
The MinIO Kubernetes Operator supports deploying MinIO Tenants onto EKS infrastructure using the MinIO Operator Console, using the :mc:`kubectl minio` CLI tool, or by using `kustomize <https://kustomize.io/>`__ for :minio-git:`YAML-defined deployments <operator/tree/master/examples/kustomization>`.

MinIO supports the following methods for installing the MinIO Operator onto your :abbr:`EKS (Elastic Kubernetes Service)` clusters:

:minio-web:`Through the AWS Marketplace <product/multicloud-elastic-kubernetes-service>`
   MinIO maintains an `AWS Marketplace listing <https://aws.amazon.com/marketplace/pp/prodview-smchi7bcs4nn4>`__ through which you can register your EKS cluster with |subnet|.
   Any tenant you deploy through Marketplace-connected clusters can take advantage of SUBNET registration, including 24/7 direct access to MinIO engineers.

Using the MinIO ``kubectl`` Plugin
   MinIO provides a ``kubectl`` plugin for installing and managing the MinIO Operator and Tenants through a terminal or shell (CLI) environment.
   You can manually register these tenants with |subnet| at any time.

This page documents deploying the MinIO Operator through the CLI using the ``kubectl minio`` plugin.
For instructions on deploying the MinIO Operator through the AWS Marketplace, see :minio-web:`Deploy MinIO through EKS <product/multicloud-elastic-kubernetes-service/deploy>`

This documentation assumes familiarity with all referenced Kubernetes and Elastic Kubernetes Service concepts, utilities, and procedures. 
While this documentation *may* provide guidance for configuring or deploying Kubernetes-related or Elastic Kubernetes Service-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

Prerequisites
-------------

Existing EKS Cluster
~~~~~~~~~~~~~~~~~~~~

This procedure assumes an existing :abbr:`EKS (Elastic Kubernetes Service)` cluster onto which you can deploy the MinIO Operator.

The Operator by default deploys pods and services with two replicas each and pod anti-affinity.
The GKE cluster should therefore have at least two nodes available for scheduling Operator pods and services.
While these nodes *may* be the same nodes intended for use by MinIO Tenants, co-locating Operator and Tenant pods may increase the risk of service interruptions due to the loss of any one node.

``kubectl`` Access to the EKS Cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure your host machine has a ``kubectl`` installation compatible with the target EKS cluster.
For guidance on connecting ``kubectl`` to EKS, see :aws-docs:`Creating or updating a kubeconfig file for an Amazon EKS cluster <eks/latest/userguide/create-kubeconfig.html>`.

Your ``kubectl`` configuration must include authentication as a user with the correct permissions.
MinIO provides an example IAM policy for Marketplace-based installations in the MinIO Operator :minio-git:`github repository <marketplace/blob/master/eks/iam-policy.json>`. 
You can use this policy as a baseline for manual Operator installations.

Procedure
---------

.. include:: /includes/common/common-install-operator-kubectl-plugin.rst
