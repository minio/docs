=====================================
MinIO Object Storage for Hybrid Cloud
=====================================

.. default-domain:: minio

Welcome to the MinIO Object Storage documentation for Hybrid Cloud 
deployments!

MinIO is a Kubernetes-native object store designed to provide high performance
with an S3-compatible API. Administrators leveraging Kubernetes orchestration 
can deploy multi-tenant MinIO object storage within private and public cloud 
infrastructures (the "Hybrid Cloud"). Developers can rely on S3-compatibility 
when migrating applications from single-cloud or legacy infrastructures to 
MinIO-backed hybrid cloud object storage.

DIAGRAM

MinIO offers the following first-party Kubernetes Extensions. MinIO 
requires Kubernetes 1.17.0 or later:

- The :ref:`MinIO Operator <minio-operator>` adds a Custom Resource 
  Definition that supports deploying MinIO Tenants onto Kubernetes Clusters.

- The :ref:`MinIO Plugin <minio-kubectl-plugin>` adds extends the Kubernetes
  command line tool :kube-docs:`kubectl <reference/kubectl/overview/>`. 
  :mc:`kubectl minio` supports deploying and managing MinIO Tenants on 
  Kubernetes clusters.

This documentation assumes familiarity with all referenced Kubernetes
concepts, utilities, and procedures. While this documentation *may* 
provide guidance for configuring or deploying Kubernetes-related resources 
on a best-effort basis, it is not a replacement for the official
:kube-docs:`Kubernetes Documentation <>`.

Getting Started
---------------

Use the :doc:`/tutorials/deploy-minio-tenant` guide to create a 
MinIO Tenant for early development and evaluation of MinIO Object Storage 
in Kubernetes.

Once you have a MinIO Tenant, use the 
:doc:`/tutorials/connect-your-application` guide to create the required 
resources for connecting applications internal and external to the 
Kubernetes cluster to MinIO Tenants.

Inside a MinIO Tenant
---------------------

A MinIO Tenant is a :kube-docs:`StatefulSet 
<concepts/workloads/controllers/statefulset/>` object that represents a 
MinIO deployment. Each Tenant consists of 
:kube-docs:`Pods <concepts/workloads/pods/>` and 
:kube-docs:`Services <concepts/services-networking/service/>` that are 
automatically deployed and managed by the 
:ref:`MinIO Kubernetes Operator <minio-operator>`.

The following diagram describes the individual components within a 
MinIO Deployment and their logical groupings:

DIAGRAM

.. todo

   Diagram should showcase a single pool 4-node 8 drive cluster. 
   Ideally should provide groupings for each Erasure Set.

Erasure Set
   A set of drives that support MinIO :ref:`Erasure Coding
   <minio-erasure-coding>`. Erasure coding provides high availability,
   reliability, and redundancy of data stored on the Tenant.

Server Pool
   A set of pods running the ``minio server`` process which pool their drives 
   for supporting object storage and retrieval requests. A MinIO Tenant can 
   have an unlimited number of Pools, where each new Pool expands the total 
   available storage on the cluster.

.. toctree::
   :titlesonly:
   :hidden:

   /core-concepts/core-concepts
   /tutorials/deploy-minio-tenant
   /tutorials/manage-minio-tenant
   /tutorials/connect-your-application
   /security/security
   /reference/production-recommendations


