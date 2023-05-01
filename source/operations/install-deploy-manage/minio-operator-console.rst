.. _minio-operator-console:

======================
MinIO Operator Console
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The Operator Console provides a rich user interface for deploying and 
managing MinIO Tenants on Kubernetes infrastructure. Installing the 
MinIO :ref:`Kubernetes Operator <deploy-operator-kubernetes>` automatically
installs and configures the Operator Console.

.. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

This page summarizes the functions available with the MinIO Operator Console.

.. _minio-operator-console-connect:

Connect to the Operator Console
-------------------------------

.. include:: /includes/common/common-k8s-connect-operator-console.rst

Tenant Management
-----------------

The MinIO Operator Console supports deploying, managing, and monitoring MinIO Tenants on the Kubernetes cluster.

.. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

You can :ref:`deploy a MinIO Tenant <minio-k8s-deploy-minio-tenant>` through the Operator Console.

The Operator Console automatically detects MinIO Tenants deployed on the cluster when provisioned through:

- Operator Console
- :ref:`MinIO Kubernetes Plugin <minio-k8s-deploy-minio-tenant-commandline>`
- Helm
- Kustomize

Select a listed tenant to open an in-browser view of that tenant's MinIO Console. 
You can use this view to directly manage, modify, expand, upgrade, and delete the tenant through the Operator UI.

.. versionadded:: Operator 5.0.0

   You can download a Log Report for a tenant from the Pods summary screen.

   The report downloads as ``<tenant-name>-report.zip``.
   The ZIP archive contains status, events, and log information for each pool on the deployment.
   The archive also includes a summary yaml file describing the deployment.

   |subnet| users relying on the commercial license should register the MinIO tenants to their SUBNET account, which can be done through the Operator Console.

Tenant Registration
-------------------

|subnet| users relying on the commercial license should register the MinIO tenants to their SUBNET account, which can be done through the Operator Console.

.. image:: /images/k8s/operator-console-register.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console Register Screen

#. Select the :guilabel:`Register` tab
#. Enter the :guilabel:`API Key` 
   
   You can obtain the key from |SUBNET| through the Console by selecting :guilabel:`Get from SUBNET`.

Review Your MinIO License
-------------------------

To review which license you are using and the features available through different license options, select the :guilabel:`License` tab.

MinIO supports two licenses: `AGPLv3 Open Source <https://opensource.org/licenses/AGPL-3.0>`__ or a `MinIO Commercial License <https://min.io/pricing?ref=docs>`__.
Subscribers to |SUBNET| use MinIO under a commercial license.

You can also :guilabel:`Subscribe` from the License screen.