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

Environment Variables
---------------------

The :ref:`MinIO Operator <minio-operator-installation>` uses the following environment variables during startup to set configuration settings.
Configure these variables on the machine running the kubectl plugin.

.. envvar:: MINIO_OPERATOR_CERTIFICATES_VERSION

   Specifies the certificate API version to use.

   Valid values are ``v1`` or ``v1beta1``.

   When not specified, the default is the API Kubernetes provides.

.. envvar:: MINIO_OPERATOR_RUNTIME

   Specify the type of runtime to use.

   Valid values are ``EKS``, ``Rancher``, or ``OpenShift``.
   Leave blank if none of the options apply.

   When set as ``EKS``, the :envvar:`MINIO_OPERATOR_CSR_SIGNER_NAME` must be ``beta.eks.amazonaws.com/app-serving``.

.. envvar:: MINIO_OPERATOR_CSR_SIGNER_NAME

   Override the default signer for certificate signing requests (CSRs).

   When not specified, the default value is ``kubernetes.io/kubelet-serving``.

.. envvar:: OPERATOR_CERT_PASSWD
   
   *Optional*

   The password Operator should use to decrypt the private key in the TLS certificate for Operator.

.. envvar:: MINIO_OPERATOR_DEPLOYMENT_NAME

   Specifies the namespace to create and use for Operator

   When not specified, the default value is ``minio-operator``.

.. envvar:: OPERATOR_STS_ENABLED

   Toggle STS Service ``on`` or ``off``.

   When not specified, the default value is ``off``.

.. envvar:: MINIO_CONSOLE_DEPLOYMENT_NAME

   The name to use for the Operator Console.

   When not specified, the default value is ``operator``.

.. envvar:: OPERATOR_CONSOLE_TLS_ENABLE

   Toggle Console TLS service ``on`` or ``off``.

   When not specified, the default value is ``off``.

.. envvar:: WATCHED_NAMESPACE

   A comma-separated list of the namespace(s) Operator should watch for tenants.
   
   When not specified, the default value is ``""`` to watch all namespaces.

.. toctree::
   :titlesonly:
   :hidden:

   /reference/kubectl-minio-plugin/kubectl-minio-init
   /reference/kubectl-minio-plugin/kubectl-minio-proxy
   /reference/kubectl-minio-plugin/kubectl-minio-tenant
   /reference/kubectl-minio-plugin/kubectl-minio-delete
   /reference/kubectl-minio-plugin/kubectl-minio-version
