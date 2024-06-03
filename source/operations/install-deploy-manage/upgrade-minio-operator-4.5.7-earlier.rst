:orphan:

.. _minio-k8s-upgrade-minio-operator-to-4.5.8:

================================
Upgrade MinIO Operator to v4.5.8
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1


To upgrade from Operator to |operator-version-stable| from version 4.5.7 or earlier, you must first upgrade to version 4.5.8.
Depending on your current version, you may need to do one or more intermediate upgrades to reach v4.5.8.

The following table lists the upgrade paths for older versions of MinIO Operator:

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
