.. _minio-k8s-upgrade-minio-tenant:

======================
Upgrade a MinIO Tenant
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Prerequisites
-------------

MinIO Kubernetes Operator and Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedures on this page *requires* a valid installation of the MinIO Kubernetes Operator and assumes the local host has a matching installation of the MinIO Kubernetes Operator.
This procedure assumes the latest stable Operator and Plugin, version |operator-version-stable|.

See :ref:`deploy-operator-kubernetes` for complete documentation on deploying the MinIO Operator.

Install the Plugin
~~~~~~~~~~~~~~~~~~

.. include:: /includes/k8s/install-minio-kubectl-plugin.rst


Procedure (CLI)
---------------

This procedure documents upgrading pods running on a MinIO Tenant.

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
