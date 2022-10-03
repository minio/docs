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

Use the :mc-cmd:`kubectl minio proxy` command to temporarily forward 
traffic between the local host machine and the MinIO Operator Console:

.. code-block:: shell
   :class: copyable

   kubectl minio proxy

The command returns output similar to the following:

.. code-block:: shell

   Starting port forward of the Console UI.

   To connect open a browser and go to http://localhost:9090

   Current JWT to login: TOKEN

Open your browser to the specified URL and enter the JWT Token into the 
login page.

Tenant Management
-----------------

The MinIO Operator Console supports deploying, managing, and monitoring 
MinIO Tenants on the Kubernetes cluster.

.. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

You can :ref:`deploy a MinIO Tenant <minio-k8s-deploy-minio-tenant>` through the 
Operator Console.

The Operator Console automatically detects any MinIO Tenants 
deployed on the cluster, whether provisioned through the Operator Console 
or through the :ref:`MinIO Kubernetes Plugin <minio-k8s-deploy-minio-tenant-commandline>`.

Select a listed tenant to open an in-browser view of that tenant's MinIO Console. 
You can use this view to directly manage, modify, expand, upgrade, and delete the tenant through the Operator UI.

Tenant Registration
-------------------

.. versionchanged:: 0.19.5

   You can register your MinIO tenants with your |SUBNET| account using the Operator Console.

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