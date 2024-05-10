.. _minio-k8s-upgrade-minio-tenant:

======================
Upgrade a MinIO Tenant
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. important::

   For Tenants using :ref:`AD/LDAP <minio-ldap-config-settings>` for external authentication upgrading from a version older than :minio-release:`RELEASE.2024-03-30T09-41-56Z` **must** read through the release notes for :minio-release:`RELEASE.2024-04-18T19-09-19Z` before upgrading.
   You must take the extra steps documented in the linked release as part of the upgrade procedure.

.. _minio-upgrade-tenant-plugin:

Upgrade the Tenant using the MinIO Kubernetes Plugin
----------------------------------------------------

The following procedure upgrades the MinIO Operator using the :mc:`kubectl minio tenant upgrade` command.

If you deployed the Tenant using :ref:`Helm <deploy-tenant-helm>`, use the :ref:`minio-upgrade-tenant-helm` procedure instead.

This procedure *requires* a valid installation of the MinIO Kubernetes Operator and assumes the local host has a matching installation of the MinIO Kubernetes Operator and plugin.
This procedure assumes the latest stable Operator version |operator-version-stable|.

.. include:: /includes/k8s/install-minio-kubectl-plugin.rst

See :ref:`deploy-operator-kubernetes` for complete documentation on deploying the MinIO Operator.

.. important::

   If you are upgrading the MinIO Operator, there may be additional changes to the tenant specs required.
   Refer to the :ref:`MinIO Operator Upgrade <minio-k8s-upgrade-minio-operator>` for specifics on any changes necessary to the tenant spec.
   The required changes vary based on the Operator version you are upgrading from and to.
   
   If required changes are not made to the tenant before upgrading the Operator, your tenant may not be accessible after the upgrade.

1) Validate the Active MinIO Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant info` command to return a summary of the MinIO Tenant, including the new Pool:

.. code-block:: shell
   :class: copyable

   kubectl minio tenant info TENANT_NAME \
     --namespace TENANT_NAMESPACE  

- Replace ``TENANT_NAME`` with the name of the Tenant.
- Replace ``TENANT_NAMESPACE`` with the namespace of the Tenant.

The output includes the version of the MinIO Server used by all Pods in the Tenant.

2) Upgrade the MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant upgrade` command to upgrade the container image used by *all* MinIO Pods in the Tenant. 
MinIO upgrades *all* ``minio`` server processes at once. 
This may result in downtime until the upgrade process completes.

.. code-block:: shell
   :class: copyable

   kubectl minio tenant upgrade TENANT_NAME                      \
           --image     minio:minio:RELEASE:YYYY-MM-DDTHH-MM-SSZ  \
           --namespace TENANT_NAMESPACE

- Replace ``TENANT_NAME`` with the name of the Tenant.
- Replace ``RELEASE:YYYY-MM-DDTHH-MM-SSZ`` with the specific release to use. 
  Specify ``minio/minio`` to use the latest stable version of MinIO.
- Replace ``TENANT_NAMESPACE`` with the namespace of the Tenant.

See MinIO's `DockerHub Repository <https://hub.docker.com/r/minio/minio>`__ for a list of available release tags.

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
