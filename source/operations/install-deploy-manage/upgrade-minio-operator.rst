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

This page describes how to upgrade from Operator 4.5.8 or later to |operator-version-stable|.
To upgrade from Operator 4.5.7 or earlier, see :ref:`Upgrade MinIO Operator to a Previous Version <minio-k8s-upgrade-minio-operator-4.5.7-earlier>`.

.. _minio-k8s-upgrade-minio-operator-procedure:

Upgrade MinIO Operator 4.5.8 and Later to |operator-version-stable|
-------------------------------------------------------------------

.. admonition:: Prerequisites
   :class: note

   This procedure requires the following:

   - You have an existing MinIO Operator deployment running 4.5.8 or later
   - Your Kubernetes cluster runs 1.21.0 or later
   - Your local host has ``kubectl`` installed and configured with access to the Kubernetes cluster

This procedure upgrades the MinIO Operator from any 4.5.8 or later release to |operator-version-stable|.

Tenant Custom Resource Definition Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following changes apply for Operator v5.0.0 or later:

- The ``.spec.s3`` field is replaced by the ``.spec.features`` field.
- The ``.spec.credsSecret`` field is replaced by the ``.spec.configuration`` field.

  The ``.spec.credsSecret`` should hold all the environment variables for the MinIO deployment that contain sensitive information and should not show in ``.spec.env``.
  This change impacts the Tenant :abbr:`CRD <CustomResourceDefinition>` and only impacts users editing a tenant YAML directly, such as through Helm or Kustomize.
- Both the **Log Search API** (``.spec.log``) and **Prometheus** (``.spec.prometheus``) deployments have been removed.
  However, existing deployments are left running as standalone deployments / statefulsets with no connection to the Tenant CR.
  Deleting the Tenant :abbr:`CRD (Custom Resource Definition)` does **not** cascade to the log or Prometheus deployments.

  .. important::

     MinIO recommends that you create a yaml file to manage these deployments going forward.

Log Search and Prometheus
~~~~~~~~~~~~~~~~~~~~~~~~~

The latest releases of Operator remove Log Search and Prometheus from included Operator tools.
The following steps back up the existing yaml files, perform some clean up, and provide steps to continue using either or both of these functions.

1. Back up Prometheus and Log Search yaml files.

   .. code-block:: shell
      :class: copyable

      export TENANT_NAME=myminio
      export NAMESPACE=mynamespace
      kubectl -n $NAMESPACE get secret $TENANT_NAME-log-secret -o yaml > $TENANT_NAME-log-secret.yaml
      kubectl -n $NAMESPACE get cm $TENANT_NAME-prometheus-config-map -o yaml > $TENANT_NAME-prometheus-config-map.yaml
      kubectl -n $NAMESPACE get sts $TENANT_NAME-prometheus -o yaml > $TENANT_NAME-prometheus.yaml
      kubectl -n $NAMESPACE get sts $TENANT_NAME-log -o yaml > $TENANT_NAME-log.yaml
      kubectl -n $NAMESPACE get deployment $TENANT_NAME-log-search-api -o yaml > $TENANT_NAME-log-search-api.yaml
      kubectl -n $NAMESPACE get svc $TENANT_NAME-log-hl-svc -o yaml > $TENANT_NAME-log-hl-svc.yaml
      kubectl -n $NAMESPACE get svc $TENANT_NAME-log-search-api -o yaml > $TENANT_NAME-log-search-api-svc.yaml
      kubectl -n $NAMESPACE get svc $TENANT_NAME-prometheus-hl-svc -o yaml > $TENANT_NAME-prometheus-hl-svc.yaml

   - Replace ``myminio`` with the name of the tenant on the operator deployment you are upgrading.
   - Replace ``mynamespace`` with the namespace for the tenant on the operator deployment you are upgrading.

   Repeat for each tenant.

2. Remove ``.metadata.ownerReferences`` for all backed up files for all tenants.

3. *(Optional)* To continue using Log Search API and Prometheus, add the following variables to the tenant's yaml specification file under ``.spec.env``

   Use the following command to edit a tenant:

   .. code-block:: shell
      :class: copyable

      kubectl edit tenants <TENANT-NAME> -n <TENANT-NAMESPACE>

   - Replace ``<TENANT-NAME>`` with the name of the tenant to modify.
   - Replace ``<TENANT-NAMESPACE>`` with the namespace of the tenant you are modifying.

   Add the following values under ``.spec.env`` in the file:

   .. code-block:: yaml
      :class: copyable

      - name: MINIO_LOG_QUERY_AUTH_TOKEN
        valueFrom:
          secretKeyRef:
            key: MINIO_LOG_QUERY_AUTH_TOKEN
            name: <TENANT_NAME>-log-secret
      - name: MINIO_LOG_QUERY_URL
        value: http://<TENANT_NAME>-log-search-api:8080
      - name: MINIO_PROMETHEUS_JOB_ID
        value: minio-job
      - name: MINIO_PROMETHEUS_URL
        value: http://<TENANT_NAME>-prometheus-hl-svc:9001

   - Replace ``<TENANT_NAME>`` in the ``name`` or ``value`` lines with the name of your tenant.

Upgrade Operator to |operator-version-stable|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Upgrade using Kustomize

      The following procedure upgrades the MinIO Operator using Kustomize.

      If you installed the Operator using :ref:`Helm <minio-k8s-deploy-operator-helm>`, use the :guilabel:`Upgrade using Helm` instructions instead.

      1. *(Optional)* Update each MinIO Tenant to the latest stable MinIO Version.
      
         Upgrading MinIO regularly ensures your Tenants have the latest features and performance improvements.
         Test upgrades in a lower environment such as a Dev or QA Tenant, before applying to your production Tenants.
         See :ref:`minio-k8s-upgrade-minio-tenant` for a procedure on upgrading MinIO Tenants.

      2. Verify the existing Operator installation.
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
               "image": "minio/operator:v|operator-version-stable|",
               "imagePullPolicy": "IfNotPresent",
               "name": "minio-operator"
            }


      3. Do Kustomize thing


      5. Validate the Operator upgrade

         You can check the Operator version by reviewing the object specification for an Operator Pod using a previous step.

         .. include:: /includes/common/common-k8s-connect-operator-console.rst


   .. tab-item:: Upgrade using Helm

      The following procedure upgrades an existing MinIO Operator Installation using Helm.

      If you installed the Operator using Kustomize, use the :guilabel:`Upgrade using Kustomize` instructions instead.

      1. *(Optional)* Update each MinIO Tenant to the latest stable MinIO Version.
      
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

         Helm uses the latest chart to upgrade the MinIO Operator:

         .. code-block:: shell
            :class: copyable

            helm upgrade -n minio-operator \
              operator minio-operator/operator

         If you installed the MinIO Operator to a different namespace, specify that to the ``-n`` argument.

         If you used a different installation name from ``operator``, replace the value above with the installation name.

         The command results should return success with a bump in the ``REVISION`` value.

      #. Validate the Operator upgrade

         You can check the Operator version by reviewing the object specification for an Operator Pod using a previous step.

         .. include:: /includes/common/common-k8s-connect-operator-console.rst

