========================================
Enforce Security for MinIO in Kubernetes
========================================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2

Overview
--------

This page covers multiple procedures for configuring MinIO security features
using the MinIO Kubernetes Operator.

You should have basic familiarity with Kubernetes, its associated terminology,
and its command line tools prior to starting any of the documented procedures.
While the MinIO documentation makes a best-effort to address Kubernetes-specific
information, you should review the official Kubernetes :kube-docs:`documentation
<>` for more complete coverage.

.. _minio-kubernetes-enforce-security-prerequisites:

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

Enable TLS
----------

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

Configure Root Access to MinIO Servers
--------------------------------------

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

Another Deployment-Level Security Feature
-----------------------------------------

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
