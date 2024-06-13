.. _minio-k8s-upgrade-minio-operator:

======================
Upgrade MinIO Operator
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

You can upgrade the MinIO Operator at any time without impacting your managed MinIO Tenants.

As part of the upgrade process, the Operator may update and restart Tenants to support changes to the MinIO Custom Resource Definition (CRD). 
These changes require no action on the part of any operator or administrator, and do not impact Tenant operations.

This page describes how to upgrade from Operator 5.0.15 to |operator-version-stable|.
See :ref:`minio-k8s-upgrade-minio-operator-to-5.0.15` for instructions on upgrading to Operator 5.0.15 before starting this procedure.


.. admonition:: Operator 6.0.0 Deprecates the Operator Console

   Starting with Operator 6.0.0, the MinIO Operator Console is deprecated and removed.

   You can continue to manage and deploy MinIO Tenants using standard Kubernetes approaches such as Kustomize or Helm.

.. _minio-k8s-upgrade-minio-operator-procedure:

Upgrade MinIO Operator 5.0.15 to |operator-version-stable|
----------------------------------------------------------

.. important::

   Operator 6.0.0 deprecates the MinIO Operator Console and removes the related resources from the MinIO Operator CRD.
   This includes removal of Operator Console resources such as services and pods.

   Use either Kustomization or Helm for managing Tenants moving forward.

.. tab-set::

   .. tab-item:: Upgrade using Kustomize

      The following procedure upgrades the MinIO Operator using Kustomize.
      For deployments using Operator 5.0.0 through 5.0.14, follow the :ref:`minio-k8s-upgrade-minio-operator-to-5.0.15` procedure before performing this upgrade.

      If you installed the Operator using :ref:`Helm <minio-k8s-deploy-operator-helm>`, use the :guilabel:`Upgrade using Helm` instructions instead.

      .. container:: procedure

         #. *(Optional)* Update each MinIO Tenant to the latest stable MinIO Version.

            Upgrading MinIO regularly ensures your Tenants have the latest features and performance improvements.
            Test upgrades in a lower environment such as a Dev or QA Tenant, before applying to your production Tenants.
            See :ref:`minio-k8s-upgrade-minio-tenant` for a procedure on upgrading MinIO Tenants.

         #. Verify the existing Operator installation.
            Use ``kubectl get all -n minio-operator`` to verify the health and status of all Operator pods and services.

            If you installed the Operator to a custom namespace, specify that namespace as ``-n <NAMESPACE>``.

            You can verify the currently installed Operator version by retrieving the object specification for an operator pod in the namespace.
            The following example uses the ``jq`` tool to filter the necessary information from ``kubectl``:

            .. code-block:: shell
               :class: copyable

               kubectl get pod -l 'name=minio-operator' -n minio-operator -o json | jq '.items[0].spec.containers'

            The output resembles the following:

            .. code-block:: json
               :emphasize-lines: 8-10
               :substitutions:

               {
                  "env": [
                     {
                        "name": "CLUSTER_DOMAIN",
                        "value": "cluster.local"
                     }
                  ],
                  "image": "minio/operator:v5.0.15",
                  "imagePullPolicy": "IfNotPresent",
                  "name": "minio-operator"
               }

            If your local host does not have the ``jq`` utility installed, you can run the first part of the command and locate the ``spec.containers`` section of the output.

         #. Upgrade Operator with Kustomize

            The following command upgrades Operator to version |operator-version-stable|:

            .. code-block:: shell
               :class: copyable

               kubectl apply -k github.com/minio/operator

            In the sample output below, ``configured`` indicates where a new change was applied from the updated CRD:

            .. code-block:: shell

               namespace/minio-operator unchanged
               customresourcedefinition.apiextensions.k8s.io/miniojobs.job.min.io configured
               customresourcedefinition.apiextensions.k8s.io/policybindings.sts.min.io configured
               customresourcedefinition.apiextensions.k8s.io/tenants.minio.min.io configured
               serviceaccount/minio-operator unchanged
               clusterrole.rbac.authorization.k8s.io/minio-operator-role configured
               clusterrolebinding.rbac.authorization.k8s.io/minio-operator-binding unchanged
               service/operator unchanged
               service/sts unchanged
               deployment.apps/minio-operator configured

         #. Validate the Operator upgrade

            You can check the new Operator version with the same ``kubectl`` command used previously:

            .. code-block:: shell
               :class: copyable

               kubectl get pod -l 'name=minio-operator' -n minio-operator -o json | jq '.items[0].spec.containers'

   .. tab-item:: Upgrade using Helm

      The following procedure upgrades an existing MinIO Operator Installation using Helm.

      If you installed the Operator using Kustomize, use the :guilabel:`Upgrade using Kustomize` instructions instead.

      .. container:: procedure

         #. *(Optional)* Update each MinIO Tenant to the latest stable MinIO Version.

            Upgrading MinIO regularly ensures your Tenants have the latest features and performance improvements.
            Test upgrades in a lower environment such as a Dev or QA Tenant, before applying to your production Tenants.
            See :ref:`minio-k8s-upgrade-minio-tenant` for a procedure on upgrading MinIO Tenants.

         #. Verify the existing Operator installation.

            Use ``kubectl get all -n minio-operator`` to verify the health and status of all Operator pods and services.

            If you installed the Operator to a custom namespace, specify that namespace as ``-n <NAMESPACE>``.

            Use the ``helm list`` command to view the installed charts in the namespace:

            .. code-block:: shell
               :class: copyable

               helm list -n minio-operator

            The result should resemble the following:

            .. code-block:: shell
               :class: copyable

               NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
               operator        minio-operator  1               2023-11-01 15:49:54.539724775 -0400 EDT deployed        operator-5.0.x v5.0.x   

         #. Update the Operator Repository

            Use ``helm repo update minio-operator`` to update the MinIO Operator repo.
            If you set a different alias for the MinIO Operator repository, specify that in the command instead of ``minio-operator``.
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

            Helm uses the latest chart to upgrade the MinIO Operator:

            .. code-block:: shell
               :class: copyable

               helm upgrade -n minio-operator \
               operator minio-operator/operator

            If you installed the MinIO Operator to a different namespace, specify that in the ``-n`` argument.

            If you used a different installation name from ``operator``, replace the value above with the installation name.

            The command results should return success with a bump in the ``REVISION`` value.

         #. Validate the Operator upgrade

            You can check the new Operator version with the same ``kubectl`` command used previously:

            .. code-block:: shell
               :class: copyable

               kubectl get pod -l 'name=minio-operator' -n minio-operator -o json | jq '.items[0].spec.containers'
