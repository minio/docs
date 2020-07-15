============================================
Quickstart: Deploy a Standalone MinIO Server
============================================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 1

Overview
--------

This tutorial uses the MinIO Operator to create a standalone MinIO server on a
local Kubernetes cluster. Standalone MinIO deployments are best suited for local
development of applications using MinIO for object storage. For a tutorial on
creating a production-grade MinIO deployment on a Kubernetes cluster, see
:doc:`/kubernetes/deploy-on-kubernetes`.  

By default, this tutorial creates a standalone MinIO deployment with the
following components:

- 1 MinIO server instance with TLS enabled.
- 4 x 100MB storage volumes
- 1 MinIO Minio Console Service instance.
- 1 MinIO Operator instance.

You should have basic familiarity with Kubernetes, its associated terminology,
and its command line tools prior to starting this tutorial. While the MinIO
documentation makes a best-effort to address Kubernetes-specific information,
you should review the official Kubernetes :kube-docs:`documentation <>` for more
complete coverage.

.. _minio-kubernetes-quickstart-prerequisites:

Prerequisites
-------------

This tutorial requires the following resources:

- The :minio-git:`minio-operator <minio-operator>` github repository.

- The `kind <https://kind.sigs.k8s.io/>`__ Kubernetes cluster deployment tool. 
  Defer to the ``kind`` 
  `Quick Start <https://kind.sigs.k8s.io/docs/user/quick-start/>`__ for
  installation instructions and related dependencies.

- A host machine where you have rights to install and run software. The 
  host machine **must** have *at least* the following available resources:

  - 10GB of free storage space.
  - 2GB of free system memory (RAM)
  - 2 or more physical CPUs. 

Procedure
---------

1) Download and Configure Prerequisites
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a\) Clone the ``minio-operator`` github repository
   Issue the following command in a terminal or shell on the host machine
   to clone the :minio-git:`minio-operator <minio-operator>` github repository. 
  
   .. include:: /includes/minio-kubernetes-operator.rst
   
   The github repository contains the MinIO Kubernetes Operator and the example
   configuration files used as part of this tutorial. 

b\) Install and configure ``kind``
   Follow the instructions on the ``kind``
   `Quick Start <https://kind.sigs.k8s.io/docs/user/quick-start/>`__ guide. 

   Once installed, use the following ``kind`` cluster configuration file to 
   create a Kubernetes cluster that can support a standalone MinIO server:

   .. code-block:: yaml
      :class: copyable

      kind: Cluster
      apiVersion: kind.x-k8s.io/v1alpha4
      nodes:
      - role: control-plane
      - role: worker

   Issue the following command in a terminal or shell on the host machine to
   create the local Kubernetes cluster:

   .. code-block:: shell
      :class: copyable

      kind create cluster --name minio-local --config.yaml

   To confirm the cluster is available, run the following command:

   .. code-block:: shell
      :class: copyable

      kubectl --cluster-info --context kind-minio-local

   Take note of the hostnames assigned to each component in the Kubernetes
   cluster. 

2) Start the MinIO Kubernetes Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following command in a terminal or shell on the host machine to 
start the MinIO Kubernetes Operator. 

.. code-block:: shell
   :class: copyable

   kubectl apply -f ~/minio-kubernetes/git/minio-operator/minio-operator.yaml

The ``minio-operator.yaml`` configuration file creates a 
``minio-operator`` deployment in the Kubernetes cluster. 

3) Configure the Storage Layer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The example MinIO server configuration used in this tutorial requires four
:kube-docs:`persistent volumes <storage/persistent-volumes/>` to start
successfully. This configuration enables features such as :ref:`erasure coding
<minio-erasure-coding>`.

Create four Kubernetes persistent volumes for use by the MinIO server instance.
MinIO recommends creating :kube-docs:`local <storage/volumes/#local>` persistent
volumes. The following template provides all required fields for creating the
required persistent volumes:

.. code-block:: yaml
   :class: copyable

   apiVersion: v1
   kind: PersistentVolume
   metadata:
     name: minioexample-pv1
   spec:
     capacity:
       storage: 10Gi # specify the maximum size of the storage device
     volumeMode: Filesystem
     accessModes:
     - ReadWriteOnce
     persistentVolumeReclaimPolicy: Retain
     storageClassName: local-storage-class
     local:
       path: /var/export1 # specify path to local volume on host
     nodeAffinity:
       required:
         nodeSelectorTerms:
         - matchExpressions:
           - key: kubernetes.io/hostname
             operator: In
             values:
             - minio-local-worker #specify hostname prefix of preferred node

Change the following configuration options as appropriate for the host 
machine configuration:

- ``spec.capacity.storage`` ( :kube-docs:`reference <concepts/storage/persistent-volumes/#capacity>`)
- ``spec.local.path`` ( :kube-api:`reference <#localvolumesource-v1-core>`)
- ``spec.nodeAffinity.required.matchExpressions.key.values`` (:kube-api:`reference <#nodeselectorrequirement-v1-core>`)

Issue the following command against each persistent volume configuration file
to create the associated resources. Replace ``<pv-filename>`` with the name
of each persistent volume configuration file.

.. code-block:: shell

   kubectl apply -f ~/minio-kubernetes/<pv-filename>.yaml

Issue the following command to check the state of the persistent volumes:

.. code-block:: shell
   :class: copyable

   kubectl get pv

The output should include the four created persistent volumes. 

4) Create the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following command in a terminal or shell to create the MinIO
standalone instance using the MinIO Kubernetes Operator:

.. code-block:: shell

   kubectl apply -f ~/minio-kubernetes/minio-operator/examples/minioinstance-standalone.yaml

Issue the following command to check the state of the minio instance:

.. code-block:: shell

   kubectl get pods

The output should include a pod running the MinIO server. 

5) Connect to the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``minioinstance-standalone.yaml`` configuration file also creates a
Kubernetes Service to manage communications to and from pods running the MinIO
service. Issue the following command to get the IP address of the service:

.. code-block:: shell

   kubectl get services

The default access key is ``minio-admin`` and the default secret key is
``minio-admin``.

You must use the IP address of the ``minio-service`` to access the MinIO
server. For example, if the IP address is  ``192.51.100.21``, enter the URL
``http://192.51.100.21:9000`` into your browser to access the MinIO server.

To connect using the ``mc`` client, issue the following command on in a 
terminal or shell:

.. code-block:: shell

   mc config host add minio http://192.51.100.21 minio-admin minio-admin

Next Steps
~~~~~~~~~~

- Perform CRUD operations on a MinIO Server (ToDo)
- 

