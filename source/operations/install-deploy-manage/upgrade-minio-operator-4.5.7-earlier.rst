:orphan:

================================
Upgrade Legacy MinIO Operators
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1


MinIO supports the following upgrade paths for older versions of the MinIO Operator:

.. list-table::
   :header-rows: 1
   :widths: 40 40
   :width: 100%

   * - Current Version
     - Supported Upgrade Target

   * - 4.2.3 to 4.5.7
     - 4.5.8
   
   * - 4.0.0 through 4.2.2
     - 4.2.3

   * - 3.X.X
     - 4.2.2

To upgrade from Operator to |operator-version-stable| from version 4.5.7 or earlier, you must first upgrade to version 4.5.8.
Depending on your current version, you may need to do one or more intermediate upgrades to reach v4.5.8.

.. _minio-k8s-upgrade-minio-operator-to-5.0.15:

Upgrade MinIO Operator 4.5.8 and Later to 5.0.15
------------------------------------------------

.. admonition:: Prerequisites
   :class: note

   This procedure requires the following:

   - You have an existing MinIO Operator deployment running 4.5.8 or later
   - Your Kubernetes cluster runs 1.21.0 or later
   - Your local host has ``kubectl`` installed and configured with access to the Kubernetes cluster

This procedure upgrades the MinIO Operator from any 4.5.8 or later release to 5.0.15

Tenant Custom Resource Definition Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following changes apply for Operator v5.0.0 or later:

- The ``.spec.s3`` field is replaced by the ``.spec.features`` field.
- The ``.spec.credsSecret`` field is replaced by the ``.spec.configuration`` field.

  The ``.spec.credsSecret`` should hold all the environment variables for the MinIO deployment that contain sensitive information and should not show in ``.spec.env``.
  This change impacts the Tenant :abbr:`CRD (CustomResourceDefinition)` and only impacts users editing a tenant YAML directly, such as through Helm or Kustomize.
- Both the **Log Search API** (``.spec.log``) and **Prometheus** (``.spec.prometheus``) deployments have been removed.
  However, existing deployments are left running as standalone deployments / statefulsets with no connection to the Tenant CR.
  Deleting the Tenant :abbr:`CRD (Custom Resource Definition)` does **not** cascade to the log or Prometheus deployments.

  .. important::

     MinIO recommends that you create a yaml file to manage these deployments going forward.

Log Search and Prometheus
~~~~~~~~~~~~~~~~~~~~~~~~~

The latest releases of Operator remove Log Search and Prometheus from included Operator tools.
The following steps back up the existing yaml files, perform some clean up, and provide steps to continue using either or both of these functions.

#. Back up Prometheus and Log Search yaml files.

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

#. Remove ``.metadata.ownerReferences`` for all backed up files for all tenants.

#. *(Optional)* To continue using Log Search API and Prometheus, add the following variables to the tenant's yaml specification file under ``.spec.env``

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

Procedure
~~~~~~~~~

.. tab-set::

   .. tab-item:: Upgrade using Kustomize

      The following procedure upgrades the MinIO Operator using Kustomize.

      For Operator versions 5.0.1 to 5.0.14 installed with the MinIO Kubernetes Plugin, follow the Kustomize instructions to upgrade to 5.0.15 or later.
      If you installed the Operator using :ref:`Helm <minio-k8s-deploy-operator-helm>`, use the :guilabel:`Upgrade using Helm` instructions instead.

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
               "image": "minio/operator:v|operator-version-stable|",
               "imagePullPolicy": "IfNotPresent",
               "name": "minio-operator"
            }

         If your local host does not have the ``jq`` utility installed, you can run the first part of the command and locate the ``spec.containers`` section of the output.

      #. Upgrade Operator with Kustomize

         The following command upgrades Operator to version |operator-version-stable|:

         .. code-block:: shell
            :class: copyable

            kubectl apply -k github.com/minio/operator

         In the sample output below, ``configured``at the end of the line indicates where a new change was applied from the updated CRD:

         .. code-block:: shell

            namespace/minio-operator configured
            customresourcedefinition.apiextensions.k8s.io/miniojobs.job.min.io configured
            customresourcedefinition.apiextensions.k8s.io/policybindings.sts.min.io configured
            customresourcedefinition.apiextensions.k8s.io/tenants.minio.min.io configured
            serviceaccount/console-sa unchanged
            serviceaccount/minio-operator unchanged
            clusterrole.rbac.authorization.k8s.io/console-sa-role unchanged
            clusterrole.rbac.authorization.k8s.io/minio-operator-role unchanged
            clusterrolebinding.rbac.authorization.k8s.io/console-sa-binding unchanged
            clusterrolebinding.rbac.authorization.k8s.io/minio-operator-binding unchanged
            configmap/console-env unchanged
            secret/console-sa-secret configured
            service/console unchanged
            service/operator unchanged
            service/sts unchanged
            deployment.apps/console configured
            deployment.apps/minio-operator configured


      #. Validate the Operator upgrade

         You can check the new Operator version with the same ``kubectl`` command used previously:

         .. code-block:: shell
            :class: copyable

            kubectl get pod -l 'name=minio-operator' -n minio-operator -o json | jq '.items[0].spec.containers'

      #. *(Optional)* Connect to the Operator Console

         .. include:: /includes/common/common-k8s-connect-operator-console-no-plugin.rst

      #. Retrieve the Operator Console JWT for login

	 .. include:: /includes/common/common-k8s-operator-console-jwt.rst


   .. tab-item:: Upgrade using Helm

      The following procedure upgrades an existing MinIO Operator Installation using Helm.

      If you installed the Operator using Kustomize, use the :guilabel:`Upgrade using Kustomize` instructions instead.

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

         .. include:: /includes/common/common-k8s-connect-operator-console-no-plugin.rst

      #. Retrieve the Operator Console JWT for login

         .. include:: /includes/common/common-k8s-operator-console-jwt.rst

.. _minio-k8s-upgrade-minio-operator-to-4.5.8:

Upgrade MinIO Operator 4.2.3 through 4.5.7 to 4.5.8
---------------------------------------------------

Prerequisites
~~~~~~~~~~~~~

This procedure requires the following:

- You have an existing MinIO Operator deployment running 4.2.3 through 4.5.7
- Your Kubernetes cluster runs 1.19.0 or later
- Your local host has ``kubectl`` installed and configured with access to the Kubernetes cluster

Procedure
~~~~~~~~~

This procedure upgrades MinIO Operator release 4.2.3 through 4.5.7 to release 4.5.8.
You can then upgrade from release 4.5.8 to |operator-version-stable|.

1. *(Optional)* Update each MinIO Tenant to the latest stable MinIO Version.

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

      {
         "env": [
            {
               "name": "CLUSTER_DOMAIN",
               "value": "cluster.local"
            }
         ],
         "image": "minio/operator:v4.5.1",
         "imagePullPolicy": "IfNotPresent",
         "name": "minio-operator"
      }

#. Download the Latest Stable Version of the MinIO Kubernetes Plugin

   .. include:: /includes/k8s/install-minio-kubectl-plugin.rst

#. Run the initialization command to upgrade the Operator

   Use the ``kubectl minio init`` command to upgrade the existing MinIO Operator installation

   .. code-block:: shell
      :class: copyable

      kubectl minio init

#. Validate the Operator upgrade

   You can check the Operator version by reviewing the object specification for an Operator Pod using a previous step.

   .. include:: /includes/common/common-k8s-connect-operator-console.rst

.. _minio-k8s-upgrade-minio-operator-4.2.2-procedure:

Upgrade MinIO Operator 4.0.0 through 4.2.2 to 4.2.3
---------------------------------------------------

Prerequisites
~~~~~~~~~~~~~

This procedure assumes that:

- You have an existing MinIO Operator deployment running any release from 4.0.0 through 4.2.2
- Your Kubernetes cluster runs 1.19.0 or later
- Your local host has ``kubectl`` installed and configured with access to the Kubernetes cluster

Procedure
~~~~~~~~~

This procedure covers the necessary steps to upgrade a MinIO Operator deployment running any release from 4.0.0 through 4.2.2 to 4.2.3.
You can then perform :ref:`minio-k8s-upgrade-minio-operator-procedure` to complete the upgrade to |operator-version-stable|.

There is no direct upgrade path for 4.0.0 - 4.2.2 installations to |operator-version-stable|.

1. *(Optional)* Update each MinIO Tenant to the latest stable MinIO Version.

   Upgrading MinIO regularly ensures your Tenants have the latest features and performance improvements.
   Test upgrades in a lower environment such as a Dev or QA Tenant, before applying to your production Tenants.

   See :ref:`minio-k8s-upgrade-minio-tenant` for a procedure on upgrading MinIO Tenants.

#. Check the Security Context for each Tenant Pool

   Use the following command to validate the specification for each managed MinIO Tenant:

   .. code-block:: shell
      :class: copyable

      kubectl get tenants <TENANT-NAME> -n <TENANT-NAMESPACE> -o yaml
   
   If the ``spec.pools.securityContext`` field does not exist for a Tenant, the tenant pods likely run as root.
   
   As part of the 4.2.3 and later series, pods run with a limited permission set enforced as part of the Operator upgrade.
   However, Tenants running pods as root may fail to start due to the security context mismatch.
   You can set an explicit Security Context that allows pods to run as root for those Tenants:

   .. code-block:: yaml
      :class: copyable

      securityContext:
        runAsUser: 0
        runAsGroup: 0
        runAsNonRoot: false
        fsGroup: 0

   You can use the following command to edit the tenant and apply the changes:

   .. code-block:: shell

      kubectl edit tenants <TENANT-NAME> -n <TENANT-NAMESPACE>
      # Modify the securityContext as needed

   See :kube-docs:`Pod Security Standards <concepts/security/pod-security-standards/>` for more information on Kubernetes Security Contexts.

#. Upgrade to Operator 4.2.3

   Download the MinIO Kubernetes Plugin 4.2.3 and use it to upgrade the Operator.
   Open https://github.com/minio/operator/releases/tag/v4.2.3 in a browser and download the binary that corresponds to your local host OS.

   For example, Linux hosts running an Intel or AMD processor can run the following commands:

   .. code-block:: shell
      :class: copyable

      wget https://github.com/minio/operator/releases/download/v4.2.3/kubectl-minio_4.2.3_linux_amd64 -o kubectl-minio_4.2.3
      chmod +x kubectl-minio_4.2.3
      ./kubectl-minio_4.2.3 init

#. Validate all Tenants and Operator pods

   Check the Operator and MinIO Tenant namespaces to ensure all pods and services started successfully.

   For example:

   .. code-block:: shell
      :class: copyable

      kubectl get all -n minio-operator
      kubectl get pods -l "v1.min.io/tenant" --all-namespaces

#. Upgrade to |operator-version-stable|

   Follow the :ref:`minio-k8s-upgrade-minio-operator-procedure` procedure to upgrade to the latest stable Operator version.

Upgrade MinIO Operator 3.0.0 through 3.0.29 to 4.2.2
----------------------------------------------------

Prerequisites
~~~~~~~~~~~~~

This procedure assumes that:

- You have an existing MinIO Operator deployment running 3.X.X
- Your Kubernetes cluster runs 1.19.0 or later
- Your local host has ``kubectl`` installed and configured with access to the Kubernetes cluster

Procedure
~~~~~~~~~

This procedure covers the necessary steps to upgrade a MinIO Operator deployment running any release from 3.0.0 through 3.2.9 to 4.2.2.
You can then perform :ref:`minio-k8s-upgrade-minio-operator-4.2.2-procedure`, followed by :ref:`minio-k8s-upgrade-minio-operator-procedure`.

There is no direct upgrade path from a 3.X.X series installation to |operator-version-stable|.

1. (Optional) Update each MinIO Tenant to the latest stable MinIO Version.

   Upgrading MinIO regularly ensures your Tenants have the latest features and performance improvements.

   Test upgrades in a lower environment such as a Dev or QA Tenant, before applying to your production Tenants.

   See :ref:`minio-k8s-upgrade-minio-tenant` for a procedure on upgrading MinIO Tenants.

#. Validate the Tenant ``tenant.spec.zones`` values

   Use the following command to validate the specification for each managed MinIO Tenant:

   .. code-block:: shell
      :class: copyable

      kubectl get tenants <TENANT-NAME> -n <TENANT-NAMESPACE> -o yaml

   - Ensure each ``tenant.spec.zones`` element has a ``name`` field set to the name for that zone.
     Each zone must have a unique name for that Tenant, such as ``zone-0`` and ``zone-1`` for the first and second zones respectively.

   - Ensure each ``tenant.spec.zones`` has an explicit ``securityContext`` describing the permission set with which pods run in the cluster.

   The following example tenant YAML fragment sets the specified fields:

   .. code-block:: yaml
      
      image: "minio/minio:$(LATEST-VERSION)"
      ...
      zones:
      - servers: 4
        name: "zone-0"
        volumesPerServer: 4
        volumeClaimTemplate:
           metadata:
           name: data
           spec:
           accessModes:
              - ReadWriteOnce
           resources:
              requests:
                 storage: 1Ti
        securityContext:
           runAsUser: 0
           runAsGroup: 0
           runAsNonRoot: false
           fsGroup: 0
      - servers: 4
        name: "zone-1"
        volumesPerServer: 4
        volumeClaimTemplate:
           metadata:
           name: data
           spec:
           accessModes:
              - ReadWriteOnce
           resources:
              requests:
                 storage: 1Ti
        securityContext:
           runAsUser: 0
           runAsGroup: 0
           runAsNonRoot: false
           fsGroup: 0

   You can use the following command to edit the tenant and apply the changes:

   .. code-block:: shell

      kubectl edit tenants <TENANT-NAME> -n <TENANT-NAMESPACE>

#. Upgrade to Operator 4.2.2

   Download the MinIO Kubernetes Plugin 4.2.2 and use it to upgrade the Operator.
   Open https://github.com/minio/operator/releases/tag/v4.2.2 in a browser and download the binary that corresponds to your local host OS.
   For example, Linux hosts running an Intel or AMD processor can run the following commands:

   .. code-block:: shell
      :class: copyable

      wget https://github.com/minio/operator/releases/download/v4.2.3/kubectl-minio_4.2.2_linux_amd64 -o kubectl-minio_4.2.2
      chmod +x kubectl-minio_4.2.2

      ./kubectl-minio_4.2.2 init

#. Validate all Tenants and Operator pods

   Check the Operator and MinIO Tenant namespaces to ensure all pods and services started successfully.

   For example:

   .. code-block:: shell
      :class: copyable

      kubectl get all -n minio-operator

      kubectl get pods -l "v1.min.io/tenant" --all-namespaces

#. Upgrade to 4.2.3

   Follow the :ref:`minio-k8s-upgrade-minio-operator-4.2.2-procedure` procedure to upgrade to Operator 4.2.3.
   You can then upgrade to |operator-version-stable|.
