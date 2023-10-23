.. _deploy-tenant-helm:

======================================
Deploy a MinIO Tenant with Helm Charts
======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

Helm is a tool for automating the deployment of applications to Kubernetes clusters.
A `Helm chart <https://helm.sh/docs/topics/charts/>`__ is a set of YAML files, templates, and other files that define the deployment details.
The following procedure uses a Helm Chart to deploy a Tenant managed by the MinIO Operator.

This procedure requires the Kubernetes cluster have a valid :ref:`Operator <deploy-operator-kubernetes>` deployment.
You cannot use the MinIO Operator Tenant chart to deploy a Tenant independent of the Operator.

.. important::


   The MinIO Operator Tenant Chart is *distinct* from the community-managed :github:`MinIO Chart <minio/tree/master/helm/minio>`.

   The Community Helm Chart is community built, maintained, and supported.
   MinIO does not guarantee support for any given bug, feature request, or update referencing that chart.

   The Operator Tenant Chart is officially maintained and supported by MinIO.
   MinIO strongly recommends the official Helm Chart for Operator and Tenants for production environments.

Prerequisites
-------------

You must meet the following requirements to install a MinIO Tenant with Helm:

- An existing Kubernetes cluster
- The ``kubectl`` CLI tool on your local host with version matching the cluster.
- `Helm <https://helm.sh/docs/intro/install/>`__ version 3.8 or greater.
- `yq <https://github.com/mikefarah/yq/#install>`__ version 4.18.1 or greater.
- An existing :ref:`MinIO Operator installation <deploy-operator-kubernetes>`.

This procedure assumes your Kubernetes cluster access grants you broad administrative permissions.

For more about Tenant installation requirements, including supported Kubernetes versions and TLS certificates, see the :ref:`Tenant deployment prerequisites <deploy-minio-distributed-prereqs-storage>`.

This procedure assumes familiarity the with referenced Kubernetes concepts and utilities.
While this documentation may provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

.. _deploy-tenant-helm-repo:

Deploy a MinIO Tenant using Helm Charts
---------------------------------------

The following procedure deploys a MinIO Tenant using the MinIO Operator Chart Repository.
This method supports a simplified installation path compared to the :ref:`local chart installation <deploy-tenant-helm-local>`.
You can modify the Operator deployment after installation.

.. important::

   Do not use the ``kubectl krew`` or similar methods to update or manage the MinIO Tenant installation.
   If you use Helm charts to deploy the Tenant, you must use Helm to manage that deployment.

#. Validate the Operator Repository Contents

   Use ``helm search`` to check the latest available chart version in the Operator Repo:

   .. code-block:: shell
      :class: copyable

      helm search repo minio-operator

   The response should resemble the following:

   .. code-block:: shell
      :class: copyable

      NAME                            CHART VERSION   APP VERSION     DESCRIPTION                    
      minio-operator/minio-operator   4.3.7           v4.3.7          A Helm chart for MinIO Operator
      minio-operator/operator         5.0.10          v5.0.10         A Helm chart for MinIO Operator
      minio-operator/tenant           5.0.10          v5.0.10         A Helm chart for MinIO Operator

   The ``minio-operator/minio-operator`` is a legacy chart and should **not** be installed under normal circumstances.

   If your ``minio-operator/operator`` version is behind the latest available chart, upgrade the operator *first*.

#. Deploy the Helm Chart

   Use the ``helm install`` command to deploy the Tenant Chart.

   If you need to override values in the default :ref:`values <minio-operator-chart-tenant-values>` file, you can use the ``--set`` operation for any single key-value.
   Alternatively, specify your own ``values.yaml`` using the ``--f`` parameter to override multiple values at once:

   .. code-block:: shell
      :class: copyable

      helm install \
        --namespace MINIO_TENANT_NAMESPACE \
        --name MINIO_TENANT_NAME \
        MINIO_TENANT_NAME minio-operator/tenant

#. Validate the Tenant installation

   Check the contents of the specified namespace to ensure all pods and services have started successfully.

   .. code-block:: shell
      :class: copyable

      kubectl get all -n MINIO_TENANT_NAMESPACE

   All pods and services should have a READY state before proceeding.

#. Expose the Tenant Console port

   Use ``kubectl port-forward`` to temporarily forward traffic from the MinIO pod to your local machine:

   .. code-block:: shell
      :class: copyable

      kubectl --namespace MINIO_TENANT_NAMESPACE port-forward svc/MINIO_TENANT_NAME-console 9443:9443
   
   .. note::
      
      To configure long term access to the pod, configure :kube-docs:`Ingress <concepts/services-networking/ingress/>` or similar network control components within Kubernetes to route traffic to and from the pod.
      Configuring Ingress is out of the scope for this documentation.

#. Login to the MinIO Console

   Access the Tenant's :ref:`minio-console` by navigating to ``http://localhost:9443`` in a browser.
   Log in to the Console with the default credentials ``myminio | minio123``.
   If you modified these credentials in the ``values.yaml`` specify those values instead.

#. Expose the Tenant MinIO S3 API port

   To test the MinIO Client :mc:`mc` from your local machine, forward the MinIO port and create an alias.

   * Forward the Tenant's MinIO port:

     .. code-block:: shell
        :class: copyable

        kubectl port-forward svc/minio 9000 -n tenant-ns

   * Create an alias for the Tenant service:

     .. code-block:: shell
        :class: copyable

        mc alias set myminio https://localhost:9000 minio minio123 --insecure

   You can use :mc:`mc mb` to create a bucket on the Tenant:
   
   .. code-block:: shell
      :class: copyable

      mc mb myminio/mybucket --insecure

   If you deployed your MinIO Tenant using TLS certificates minted by a trusted Certificate Authority (CA) you can omit the ``--insecure`` flag.

.. _deploy-tenant-helm-local:

Deploy a Tenant using a Local Helm Chart
----------------------------------------

The following procedure deploys a Tenant using a local copy of the Helm Charts.
This method may support easier pre-configuration of the Tenant compared to the :ref:`repo-based installation  <deploy-tenant-helm-repo>`

#. Download the Helm charts

   On your local host, download the Tenant Helm charts to a convenient directory:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      curl -O https://raw.githubusercontent.com/minio/operator/master/helm-releases/tenant-|operator-version-stable|.tgz

   Each chart contains a ``values.yaml`` file you can customize to suit your needs.
   For example, you may wish to change the MinIO root user credentials or the Tenant name.
   For more about customizations, see `Helm Charts <https://helm.sh/docs/topics/charts/>`__.

#. The following Helm command creates a MinIO Tenant using the standard chart:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      helm install \
      --namespace tenant-ns \
      --create-namespace \
      tenant-ns tenant-|operator-version-stable|.tgz

   To deploy more than one Tenant, create a Helm chart with the details of the new Tenant and repeat the deployment steps.
   Redeploying the same chart updates the previously deployed Tenant.

#. Expose the Tenant Console port

   Use ``kubectl port-forward`` to temporarily forward traffic from the MinIO pod to your local machine:

   .. code-block:: shell
      :class: copyable

      kubectl --namespace tenant-ns port-forward svc/myminio-console 9443:9443
   
   .. note::
      
      To configure long term access to the pod, configure :kube-docs:`Ingress <concepts/services-networking/ingress/>` or similar network control components within Kubernetes to route traffic to and from the pod.
      Configuring Ingress is out of the scope for this documentation.

#. Login to the MinIO Console

   Access the Tenant's :ref:`minio-console` by navigating to ``http://localhost:9443`` in a browser.
   Log in to the Console with the default credentials ``myminio | minio123``.

#. Expose the Tenant MinIO port

   To test the MinIO Client :mc:`mc` from your local machine, forward the MinIO port and create an alias.

   * Forward the Tenant's MinIO port:

     .. code-block:: shell
        :class: copyable

        kubectl port-forward svc/myminio-hl 9000 -n tenant-ns

   * Create an alias for the Tenant service:

     .. code-block:: shell
        :class: copyable

        mc alias set myminio https://localhost:9000 minio minio123 --insecure

     This example uses the non-TLS ``myminio-hl`` service, which requires :std:option:`--insecure <mc.--insecure>`.

     If you have a TLS cert configured, omit ``--insecure`` and use ``svc/minio`` instead.

   You can use :mc:`mc mb` to create a bucket on the Tenant:
   
     .. code-block:: shell
        :class: copyable

	mc mb myminio/mybucket --insecure