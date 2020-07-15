====================================
Deploy MinIO on a Kubernetes Cluster
====================================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2

Overview
--------

This tutorial uses the MinIO Kubernetes Operator to deploy MinIO to your
Kubernetes cluster in a distributed configuration. Distributed MinIO deployments
are suitable for development, staging, and production environments. For
a tutorial on creating a more simple MinIO deployment for local development
and evaluation, see :doc:`/kubernetes/quickstart`.

By default, this tutorial creates a distributed MinIO deployment with the
following components:

- 4 MinIO server instances with TLS enabled.
- 4 x 1TB storage volumes per MinIO server instance.
- 1 MinIO KES key management instance.
- 1 MinIO Minio Console Service instance.
- 1 MinIO Operator instance.

This tutorial includes instructions for modifying the deployment configuration
for your specific requirements.

You should have basic familiarity with Kubernetes, its associated terminology,
and its command line tools prior to starting this tutorial. While the MinIO
documentation makes a best-effort to address Kubernetes-specific information,
you should review the official Kubernetes :kube-docs:`documentation <>` for more
complete coverage.

.. _minio-kubernetes-deploy-minio-prerequisites:

Prerequisites
-------------

This tutorial requires the following resources:

- The :minio-git:`minio-operator <minio-operator>` github repository.

- A Kubernetes cluster with *at least* **four** 
  :kube-docs:`node` per MinIO server instance. Each node must have *at least*
  **four** persistent volumes.

- A host machine with ``kubectl`` installed. See 
  :kube-docs:`Install and Set Up kubectl <tasks/tools/install-kubectl/>`

  The host machine should be configured such that ``kubectl`` can access the
  Kubernetes cluster. See :kube-docs:`Access Applications in a Cluster 
  <tasks/access-application-cluster>` for more information.

Considerations
--------------

.. ToDo: 

   - Document recommended resource allocation (CPU, RAM, etc.)
   - Document recommended number of MinIO pods to Nodes
   - Document recommended ratio of PV to Physical Disk

Procedure
---------

1) First Step Header
~~~~~~~~~~~~~~~~~~~~

a) First Substep
````````````````

b) Second Substep
`````````````````

2) Second Step Header
~~~~~~~~~~~~~~~~~~~~~

a) First Substep
````````````````

b) Second Substep
`````````````````

