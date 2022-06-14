:orphan:

.. _minio-kubectl-plugin:

=======================
MinIO Kubernetes Plugin
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

.. admonition:: Current Stable Version is |operator-version-stable|
   :class: note

   This reference documentation reflects |operator-version-stable| of the 
   MinIO Kubernetes Operator and :mc:`kubectl minio` plugin. 

The :mc:`kubectl minio` plugin brings native support for deploying MinIO tenants to Kubernetes clusters using the ``kubectl`` CLI. 
Use :mc:`kubectl minio` to deploy a MinIO tenant with little to no interaction with ``YAML`` configuration files.

.. image:: /images/minio-k8s.svg
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: Kubernetes Orchestration with the MinIO Operator facilitates automated deployment of MinIO clusters.

Installing :mc:`kubectl minio` implies installing the
:minio-git:`MinIO Kubernetes Operator <operator>`.

.. _minio-plugin-installation:

.. mc:: kubectl minio

Installation
------------

The MinIO Kubernetes Plugin requires Kubernetes 1.19.0 or later.

The following code downloads the latest stable version |operator-version-stable| of the MinIO Kubernetes Plugin and installs it to the system ``$PATH``.


.. tab-set::

   .. tab-item:: krew

      This procedure uses the Kubernetes krew plugin manager for installing the MinIO Kubernetes Operator and Plugin.

      See the ``krew`` `installation documentation <https://krew.sigs.k8s.io/docs/user-guide/setup/install/>`__ for specific instructions.

      .. code-block:: shell
         :class: copyable

         kubectl krew update
         kubectl krew install minio

   .. tab-item:: shell

      .. code-block:: shell
         :substitutions:
         :class: copyable

         wget https://github.com/minio/operator/releases/download/v|operator-version-stable|/kubectl-minio_|operator-version-stable|_linux_amd64 -O kubectl-minio
         chmod +x kubectl-minio
         mv kubectl-minio /usr/local/bin/

You can access the plugin using the :mc:`kubectl minio` command. Run 
the following command to verify installation of the plugin:

.. code-block:: shell
   :class: copyable

   kubectl minio version


Subcommands
-----------

:mc:`kubectl minio` has the following subcommands:

- :mc:`~kubectl minio init`
- :mc:`~kubectl minio proxy`
- :mc:`~kubectl minio tenant`
- :mc:`~kubectl minio delete`
- :mc:`~kubectl minio version`

.. toctree::
   :titlesonly:
   :hidden:

   /reference/kubectl-minio-plugin/kubectl-minio-init
   /reference/kubectl-minio-plugin/kubectl-minio-proxy
   /reference/kubectl-minio-plugin/kubectl-minio-tenant
   /reference/kubectl-minio-plugin/kubectl-minio-delete
   /reference/kubectl-minio-plugin/kubectl-minio-version
