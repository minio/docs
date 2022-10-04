.. _deploy-operator-openshift:

=========================================
Deploy MinIO Operator on RedHat OpenShift
=========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

Red Hat® OpenShift® is an enterprise-ready Kubernetes container platform with full-stack automated operations to manage hybrid cloud, multi-cloud, and edge deployments. 
OpenShift includes an enterprise-grade Linux operating system, container runtime, networking, monitoring, registry, and authentication and authorization solutions. 

You can deploy the MinIO Kubernetes Operator through the :openshift-docs:`Red Hat® OpenShift® Container Platform 4.7+ <welcome/index.html>`. 
You can deploy and manage MinIO Tenants through OpenShift after deploying the MinIO Operator. 
This procedure includes instructions for the following deployment paths:

- Purchase and Deploy MinIO through the `RedHat Marketplace <https://marketplace.redhat.com/en-us/products/minio-hybrid-cloud-object-storage>`__.
- Deploy MinIO through the OpenShift `OperatorHub <https://operatorhub.io/operator/minio-operator>`__

After deploying the MinIO Operator into your OpenShift cluster, you can create and manage MinIO Tenants through the :openshift-docs:`OperatorHub <operators/understanding/olm-understanding-operatorhub.html>` user interface.

This documentation assumes familiarity with all referenced Kubernetes and OpenShift concepts, utilities, and procedures. 
While this documentation *may* provide guidance for configuring or deploying Kubernetes-related or OpenShift-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>` and :openshift-docs:`OpenShift Container Platform 4.7+ Documentation <welcome/index.html>`.

Prerequisites
-------------

RedHat OpenShift 4.7+
~~~~~~~~~~~~~~~~~~~~~

The MinIO Kubernetes Operator is available starting with `OpenShift 4.7+ <https://docs.openshift.com/container-platform/4.7/welcome/index.html>`__.

Red Hat Marketplace installation requires registration of the OpenShift cluster with the Marketplace for the necessary namespaces.
See `Register OpenShift cluster with Red Hat Marketplace <https://marketplace.redhat.com/en-us/documentation/clusters>`__ for complete instructions.

For older versions of OpenShift, use the generic :ref:`deploy-operator-kubernetes` procedure.

Administrator Access
~~~~~~~~~~~~~~~~~~~~

Installation of operators through the Red Hat Marketplace and the Operator Hub is restricted to OpenShift cluster administrators (``cluster-admin`` privileges). 
This procedure requires logging into the Marketplace and/or OpenShift with an account that has those privileges.

OpenShift ``oc`` CLI
~~~~~~~~~~~~~~~~~~~~

:openshift-docs:`Download and Install <cli_reference/openshift_cli/getting-started-cli.html>` the OpenShift :abbr:`CLI (command-line interface)` ``oc`` for use in this procedure.

MinIO ``kubectl`` Plugin
~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Kubernetes Plugin provides a command line interface for the MinIO Operator.
This procedure uses the ``oc minio`` plugin as part of the installation.

.. include:: /includes/openshift/install-minio-kubectl-plugin.rst

Procedure
---------

1) Access the MinIO Operator Installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Select the tab that corresponds to your preferred installation method:

.. tab-set::

   .. tab-item:: Red Hat Marketplace

      Open the `MinIO Red Hat Marketplace listing <https://marketplace.redhat.com/en-us/products/minio-hybrid-cloud-object-storage>`__ in your browser. 
      Click :guilabel:`Login` to log in with your Red Hat Marketplace account.
      
      After logging in, click :guilabel:`Purchase` to purchase the MinIO Operator for your account. 

      After completing the purchase, click :guilabel:`Workplace` from the top navigation and select :guilabel:`My Software`. 

      .. image:: /images/openshift/minio-openshift-marketplace-my-software.png
         :align: center
         :width: 90%
         :class: no-scaled-link
         :alt: From the Red Hat Marketplace, select Workplace, then My Software

      Click :guilabel:`MinIO Hybrid Cloud Object Storage` and select :guilabel:`Install Operator` to start the Operator Installation procedure in OpenShift.

   .. tab-item:: Red Hat OperatorHub

      Log into the OpenShift Web Console as a user with ``cluster-admin`` privileges. 
      
      From the :guilabel:`Administrator` panel, select :guilabel:`Operators`, then :guilabel:`OperatorHub`.
      
      From the :guilabel:`OperatorHub` page, type "MinIO" into the :guilabel:`Filter` text entry. Select the :guilabel:`MinIO Operator` tile from the search list.
      
      .. image:: /images/openshift/minio-openshift-select-minio.png
         :align: center
         :width: 90%
         :class: no-scaled-link
         :alt: From the OperatorHub, search for MinIO, then select the MinIO Tile.

      Select the :guilabel:`MinIO Operator` tile, then click 
      :guilabel:`Install` to begin the installation.

2) Configure and Deploy the Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Install Operator` page provides a walkthrough for configuring the MinIO Operator installation. 

.. image:: /images/openshift/minio-openshift-operator-installation.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: Complete the Operator Installation Walkthrough

- For :guilabel:`Update channel`, select any of the available options.

- For :guilabel:`Installation Mode`, select :guilabel:`All namespaces on the cluster`

- For :guilabel:`Installed Namespace`, select :guilabel:`openshift-operators`

- For :guilabel:`Approval Strategy`, select the approval strategy of your choice.

See the :openshift-docs:`Operator Installation Documentation <operators/admin/olm-adding-operators-to-cluster.html#olm-installing-from-operatorhub-using-web-console_olm-adding-operators-to-a-cluster>` :guilabel:`Step 5` for complete descriptions of each displayed option.

Click :guilabel:`Install` to start the installation procedure. 
The web console displays a widget for tracking the installation progress.

.. image:: /images/openshift/minio-openshift-operator-installation-progress.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Wait for Installation to Complete.

Once installation completes, click :guilabel:`View Operator` to view the MinIO Operator page. 

3) Open the MinIO Operator Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can find the MinIO Operator Interface from the :guilabel:`Operators` left-hand navigation header.

1. Go to :guilabel:`Operators`, then :guilabel:`Installed Operators`. 

2. For the :guilabel:`Project` dropdown, select :guilabel:`openshift-operators`.

3. Select :guilabel:`MinIO Operators` from the list of installed operators. 
   The :guilabel:`Status` column must read :guilabel:`Success` to access the Operator interface.

4) Access the Operator Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Operator includes the Operator Console, a browser-based management interface for managed MinIO tenants.

You can temporarily port-forward the Operator Console to your local host machine using the ``oc minio port-forward`` command:

.. code-block:: shell
   :class: copyable

   oc minio port-forward

The command returns a JWT token and a URL you can open in your browser.

.. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Operator Dashboard

You can create a permanent routing rule by creating a :openshift-docs:`Route or Ingress <networking/understanding-networking.html#nw-ne-comparing-ingress-route_understanding-networking>` to allow access from external clients, such as your local computer browser. 

The following steps provides a summary of actions necessary to create a Route.

#. From :guilabel:`Networking`, go to :guilabel:`Routes`
#. Create a new Route in the MinIO Operator project.
   Select a recognizable route name, such as ``operator-console-route``.
#. Set the :guilabel:`Hostname` as per your organizations networking and hostname topology.
   Omit the hostname to allow OpenShift to generate it automatically
#. Set the :guilabel:`Service` to :guilabel:`console`
#. Set the :Guilabel:`Target Port` to  ``9090`` 

You can then access the Operator Console using the configured Route. 
The Operator Console still requires using the generated JWT token for access, which you can generate at any time using ``oc minio port-forward``.

6) Next Steps
~~~~~~~~~~~~~

After deploying the MinIO Operator, you can create a new MinIO Tenant.
To deploy a MinIO Tenant using OpenShift, see :ref:`deploy-minio-tenant-redhat-openshift`.

.. uncomment this block when upgrade operator procedure is complete

   .. toctree::
      :titlesonly:
      :hidden:

      /operations/install-deploy-manage/upgrade-minio-operator
