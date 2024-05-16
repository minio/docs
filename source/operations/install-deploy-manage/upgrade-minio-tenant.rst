.. _minio-k8s-upgrade-minio-tenant:

======================
Upgrade a MinIO Tenant
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. _minio-upgrade-tenant-kustomize:

Upgrade the Tenant using Kustomize
----------------------------------

This procedure upgrades an existing MinIO Tenant using Kustomize.


.. _minio-upgrade-tenant-helm:

Upgrade the Tenant using the MinIO Helm Chart
---------------------------------------------

This procedure upgrades an existing MinIO Tenant using Helm Charts.

If you deployed the Tenant using the :ref:`MinIO Kubernetes Plugin <minio-k8s-deploy-minio-tenant>`, use the :ref:`minio-upgrade-tenant-plugin` procedure instead.

1. Verify the existing MinIO Tenant installation.

   Use ``kubectl get all -n TENANT_NAMESPACE`` to verify the health and status of all Tenant pods and services.

   Use the ``helm list`` command to view the installed charts in the namespace:

   .. code-block:: shell
      :class: copyable

      helm list -n TENANT_NAMESPACE

   The result should resemble the following:

   .. code-block:: shell


      NAME            NAMESPACE         REVISION        UPDATED                                 STATUS          CHART           APP VERSION
      CHART_NAME      TENANT_NAMESPACE  1               2023-11-01 15:49:58.810412732 -0400 EDT deployed        tenant-5.0.x   v5.0.x

#. Update the Operator Repository 

   Use ``helm repo update minio-operator`` to update the MinIO Operator repo.
   If you set a different alias for the MinIO Operator repository, specify that to the command.
   You can use ``helm repo list`` to review your installed repositories.

   Use ``helm search`` to check the latest available chart version after updating the Operator Repo:

   .. code-block:: shell
      :class: copyable

      helm search repo minio-operator

   The response should resemble the following:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      NAME                            CHART VERSION   APP VERSION     DESCRIPTION                    
      minio-operator/minio-operator   4.3.7           v4.3.7          A Helm chart for MinIO Operator
      minio-operator/operator         |operator-version-stable|          v|operator-version-stable|         A Helm chart for MinIO Operator
      minio-operator/tenant           |operator-version-stable|          v|operator-version-stable|         A Helm chart for MinIO Operator

   The ``minio-operator/minio-operator`` is a legacy chart and should **not** be installed under normal circumstances.

#. Run ``helm upgrade``

   Helm uses the latest chart to upgrade the Tenant:

   .. code-block:: shell
      :class: copyable

      helm upgrade -n minio-tenant \
        CHART_NAME minio-operator/tenant

   The command results should return success with a bump in the ``REVISION`` value.

#. Validate the Tenant Upgrade

   Check that all services and pods are online and functioning normally.
