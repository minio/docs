===================================================
Deploy MinIO Console Server on a Kubernetes Cluster
===================================================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2

MinIO Console Server (MCS) is a graphical user interface for administrating
MinIO servers. This tutorial covers the information necessary for using the
MinIO Kubernetes Operator (``minio-operator``) to deploy MinIO MCS instances on
a Kubernetes Cluster. 

You should have basic familiarity with the Kubernetes ecosystem prior to
starting this tutorial. Defer to the official documentation for
:kube-docs:`Kubernetes` for more complete learning resources. While the MinIO
docs make a best-effort to cover third-party concepts and configurations, you
should not depend on this tutorial as the only source of information on
third-party products.

For more complete documentation on MinIO MCS, see <future page>.

Prerequisites
-------------

This tutorial requires the following resources:

Kubernetes Cluster
   You should have access to a running Kubernetes cluster. 

   The Kubernetes cluster should have *at least* **one** node with enough
   resources to launch additional pods.

MinIO Kubernetes Operator
   The Kubernetes cluster must have at least one running
   :minio-git:`minio-operator <minio-operator>` instance. See <future
   minio-operator deployment proc> for installation instructions. 
   
   The MinIO operator *must* have TLS configured and enabled. See <future
   security config docs> for configuration instructions.

MinIO Deployment
   For a tutorial on deploying MinIO on Kubernetes, see
   :doc:`/kubernetes/deploy-on-kubernetes`.

   For a shorter tutorial for local development only, see
   :doc:`/kubernetes/quickstart`.

   The MinIO deployment must have at least one MinIO user with administrative
   privileges for the MCS instance to use for authentication and authorization.
   See <future security docs> for more information on configuring MinIO users.

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
