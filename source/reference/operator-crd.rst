.. _minio-operator-crd:

================================
MinIO Custom Resource Definition
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


The MinIO Operator installs a :kube-docs:`Custom Resource Definition (CRD) <concepts/extend-kubernetes/api-extension/custom-resources>` that describes a MinIO Tenant object.
The Operator uses this CRD for provisioning and managing Tenant resources within a Kubernetes cluster.

This page documents the CRD reference for use in customizing Operator-deployed Tenants.
This documentation assumes familiarity with all referenced Kubernetes concepts, utilities, and procedures.

.. include:: /includes/k8s/ext-tenant-crd.md
   :parser: myst_parser.sphinx_