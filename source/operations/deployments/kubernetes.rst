.. _minio-kubernetes:

==========================
Deploy MinIO on Kubernetes
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO is a Kubernetes-native high performance object store with an S3-compatible API. 
The MinIO Kubernetes Operator supports deploying MinIO Tenants onto private and public cloud infrastructures ("Hybrid" Cloud).

All documentation assumes familiarity with referenced Kubernetes concepts, utilities, and procedures. 
While MinIO documentation *may* provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

MinIO Operator Architecture
---------------------------

.. todo: image of architecture

MinIO Operator
~~~~~~~~~~~~~~

The MinIO Operator is a first-party Kubernetes-native operator that manages the deployment of MinIO Tenants onto Kubernetes infrastructure.

The Operator provides MinIO-centric functionality around Tenant management, including support for configuring all core MinIO features. 

You can interact with the Operator through the MinIO :kube-docs:`Custom Resource Definition (CRD) <concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions>`, or through the Operator Console UI.

The CRD provides a highly customizable entry point for using tools like Kustomize for deploying Tenants.
You can also use the MinIO Operator Console, a rich web-based UI that has complete support for deploying and configuring MinIO Tenants.


MinIO Operator Console
~~~~~~~~~~~~~~~~~~~~~~

The Operator Console provides a rich user interface for deploying and managing MinIO Tenants on Kubernetes infrastructure. 

.. screenshot temporarily removed
   .. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

The MinIO Operator Console supports deploying, managing, and monitoring MinIO Tenants on the Kubernetes cluster.

.. screenshot temporarily removed
   .. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

Tenant Registration
-------------------

|subnet| users must register Tenants to associate them with the MinIO Commercial License.
You can register Tenants through the Operator

#. Select the :guilabel:`Register` tab
#. Enter the :guilabel:`API Key` 
   
   You can obtain the key from |SUBNET| through the Console by selecting :guilabel:`Get from SUBNET`.

.. screenshot temporarily removed
   .. image:: /images/k8s/operator-console-register.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console Register Screen

#. Select the :guilabel:`Register` tab
#. Enter the :guilabel:`API Key` 
   
   You can obtain the key from |SUBNET| through the Console by selecting :guilabel:`Get from SUBNET`.

.. toctree::
   :titlesonly:
   :hidden:
   
   /operations/deployments/k8s-minio-operator
   /operations/deployments/k8s-minio-tenants