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

The following table lists the upgrade paths from previous versions of the MinIO Operator:

.. list-table::
   :header-rows: 1
   :widths: 40 40
   :width: 100%

   * - Current Version
     - Supported Upgrade Target

   * - 4.5.8 or later
     - |operator-version-stable| 

   * - 4.2.3 to 4.5.7
     - 4.5.8
   
   * - 4.0.0 through 4.2.2
     - 4.2.3

   * - 3.X.X
     - 4.2.2

.. _minio-k8s-upgrade-minio-operator-procedure:

Upgrade MinIO Operator 4.5.8 and Later to |operator-version-stable|
-------------------------------------------------------------------

.. admonition:: Prerequisites
   :class: note

   This procedure requires the following:

   - You have an existing MinIO Operator deployment running 4.5.8 or later
   - Your Kubernetes cluster runs 1.19.0 or later
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
      kubectl -n $NAMESPACE get svc $TENANT_NAME-log-search-api -o yaml > $TENANT_NAME-log-search-api.yaml
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
        value: http://<TENANT_NAME>-prometheus-hl-svc:9090

   - Replace ``<TENANT_NAME>`` in the ``name`` or ``value`` lines with the name of your tenant.

Upgrade Operator to |operator-version-stable|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

      {
         "env": [
            {
               "name": "CLUSTER_DOMAIN",
               "value": "cluster.local"
            }
         ],
         "image": "minio/operator:v4.5.8",
         "imagePullPolicy": "IfNotPresent",
         "name": "minio-operator"
      }

3. Download the latest stable version of the MinIO Kubernetes Plugin

   .. include:: /includes/k8s/install-minio-kubectl-plugin.rst

4. Run the initialization command to upgrade the Operator

   Use the :mc-cmd:`kubectl minio init` command to upgrade the existing MinIO Operator installation

   .. code-block:: shell
      :class: copyable

      kubectl minio init

5. Validate the Operator upgrade

   You can check the Operator version by reviewing the object specification for an Operator Pod using a previous step.
   .. include:: /includes/common/common-k8s-connect-operator-console.rst

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

This procedure upgrades the MinIO Operator from any 4.2.3 or later release to |operator-version-stable|.

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

   Use the :mc-cmd:`kubectl minio init` command to upgrade the existing MinIO Operator installation

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
