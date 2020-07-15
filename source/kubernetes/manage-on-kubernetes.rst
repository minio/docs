====================================
Expand MinIO in a Kubernetes Cluster
====================================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2

Overview
--------

This tutorial uses the MinIO Kubernetes Operator to expand an existing 
distributed MinIO deployment in your Kubernetes cluster. Specifically, 
this tutorial covers:

- Adding additional MinIO server instances to the deployment, *and*
- Adding additional drives to a MinIO server instance.

This tutorial includes instructions for modifying the deployment configuration
for your specific requirements.

You should have basic familiarity with Kubernetes, its associated terminology,
and its command line tools prior to starting this tutorial. While the MinIO
documentation makes a best-effort to address Kubernetes-specific information,
you should review the official Kubernetes :kube-docs:`documentation <>` for more
complete coverage.

.. _minio-kubernetes-expand-minio-prerequisites:

Prerequisites
-------------

This tutorial requires the following resources:

- The :minio-git:`minio-operator <minio-operator>` github repository.

- An existing Kubernetes cluster with a distributed MinIO deployment.

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

