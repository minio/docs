========================================
Deploy MinIO KES on a Kubernetes Cluster
========================================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2

MinIO KES is a stateless and distributed key-management system for
high-performance applications. KES provides a bridge between applications
running in containerized deployments, like Kubernetes, and centralized Key
Mannagement Systems (KMS) like Hashicorp Vault or Amazon Web Services (AWS) KMS. This
tutorial covers the information necessary for using the MinIO Kubernetes
Operator (``minio-operator``) to deploy MinIO KES instances on a Kubernetes
Cluster. 

You should have basic familiarity with the Kubernetes ecosystem and your
preferred KMS backend prior to starting this tutorial. Defer to the official
documentation for :kube-docs:`Kubernetes` and your preferred KMS backend for
more complete learning resource. While the MinIO docs make a best-effort
to cover third-party concepts and configurations, you should not depend on 
this tutorial as the only source of information on third-party products.

For more complete documentation on MinIO KES, see <future page>.

Prerequisites
-------------

This tutorial requires the following resources:

Kubernetes Cluster
   You should have access to a running Kubernetes cluster. 

   The Kubernetes cluster 

- The Kubernetes cluster must have at least one running
  :minio-git:`minio-operator <minio-operator>` instance. See
  <future minio-operator deployment proc> for installation instructions.

  The Kubernetes cluster should have *at least* **one** node with enough
  resources to launch additional pods.

- The ``minio-operator`` has TLS configured and enabled. See
  <future minio-operator security config docs> for configuration instructions.

- An x.509 Certificate and corresponding private key for MinIO KES to use 
  for mTLS authentication and authorization. 

- A supported Key Management System backend. MinIO KES supports the following KMS providers:

  - `Hashicorp Vault <https://www.vaultproject.io/?ref=minio>`__
  - `Amazon Web Services KMS <https://aws.amazon.com/kms/?ref=minio>`__
  - `Gemalto SafeNet KeySecure <https://www.netapp.com/us/products/storage-security-systems/key-management/keysecure-k460.aspx?ref=minio>`__

Procedure
---------

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
