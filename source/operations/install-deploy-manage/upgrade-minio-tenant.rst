.. _minio-k8s-upgrade-minio-tenant:

======================
Upgrade a MinIO Tenant
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1


The following procedures upgrade a single MinIO Tenant, using either Kustomize or Helm.
MinIO recommends you test upgrades in a lower environment such as a Dev or QA Tenant, before upgrading production Tenants.

.. important::

   For Tenants using a MinIO Image older than :minio-release:`RELEASE.2024-03-30T09-41-56Z` running with :ref:`AD/LDAP <minio-ldap-config-settings>` enabled, you **must** read through the release notes for :minio-release:`RELEASE.2024-04-18T19-09-19Z` before starting this procedure.
   You must take the extra steps documented in the linked release as part of the upgrade procedure.

.. _minio-upgrade-tenant-plugin:
.. _minio-upgrade-tenant-kustomize:

Upgrade a Tenant using Kustomize
--------------------------------

The following procedure upgrades a MinIO Tenant using Kustomize and the ``kubectl`` CLI.
If you deployed the Tenant using :ref:`Helm <deploy-tenant-helm>`, use the :ref:`minio-upgrade-tenant-helm` procedure instead.

To upgrade a Tenant with Kustomize:

#. In a convenient directory, save the current Tenant configuration to a file using ``kubectl get``:

    .. code-block:: shell
       :class: copyable

       kubectl get tenant/my-tenant -n my-tenant-ns -o yaml > my-tenant-base.yaml

    Replace ``my-tenant`` and ``my-tenant-ns`` with the name and namespace of the Tenant to upgrade.
    
    Edit the file to remove the following lines:

    - ``creationTimestamp:``
    - ``resourceVersion:``
    - ``uid:``
    - ``selfLink:`` (if present)

    For example, remove the highlighted lines:

    .. code-block:: shell
       :emphasize-lines: 2, 6, 7

       metadata:
         creationTimestamp: "2024-05-29T21:22:20Z"
         generation: 1
         name: my-tenant
         namespace: my-tenant-ns
         resourceVersion: "4699"
         uid: d5b8e468-3bed-4aa3-8ddb-dfe1ee0362da

#. In the same directory, create a ``kustomization.yaml`` file with contents resembling the following:

   .. code-block:: shell
      :class: copyable

      apiVersion: kustomize.config.k8s.io/v1beta1
      kind: Kustomization

      resources:
      - my-tenant-base.yaml

      patches:
      - path: upgrade-minio-tenant.yaml

   Replace ``my-tenant-base.yaml`` with the name of the file containing the ``kubectl get`` output from the previous step.


#. Also in the same directory, create a ``upgrade-minio-tenant.yaml`` file with contents resembling the following:

   .. code-block:: shell
      :class: copyable

      apiVersion: minio.min.io/v2
      kind: Tenant

      metadata:
        name: my-tenant
        namespace: my-tenant-ns

      spec:
        image: minio/minio:RELEASE.2024-05-28T17-19-04Z

   The name of this file must match the ``patches.path`` filename specified in your ``kustomization.yaml`` file.
   If you create this file with a different name, ensure you update the corresponding filename in  ``kustomize.yaml``.
   
   Replace ``my-tenant`` and ``my-tenant-ns`` with the name and namespace of the Tenant to upgrade.
   Specify the MinIO version to upgrade to in ``image:``.

 
- Apply the updated configuration to the Tenant with ``kubectl apply``:

  .. code-block:: shell
     :class: copyable

     kubectl apply -f ./

  The output resembles the following:

  .. code-block:: shell

     tenant.minio.min.io/my-tenant configured


.. _minio-upgrade-tenant-helm:

Upgrade the Tenant using the MinIO Helm Chart
---------------------------------------------

This procedure upgrades an existing MinIO Tenant using Helm Charts.

If you deployed the Tenant using Kustomize, use the :ref:`minio-upgrade-tenant-kustomize` procedure instead.

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
