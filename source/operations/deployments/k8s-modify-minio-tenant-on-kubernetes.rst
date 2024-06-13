.. _minio-k8s-modify-minio-tenant:
.. _minio-k8s-modify-minio-tenant-security:

=====================
Modify a MinIO Tenant
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

You can modify tenants after deployment to change mutable configuration settings.
See :ref:`minio-operator-crd` for a complete description of available settings in the MinIO Custom Resource Definition.

The method for modifying the Tenant depends on how you deployed the tenant:

.. tab-set::

   .. tab-item:: Kustomize
      :sync: kustomize

      For Kustomize-deployed Tenants, you can modify the base Kustomization resources and apply them using ``kubectl apply -k`` against the directory containing the ``kustomization.yaml`` object.

      .. code-block:: shell

         kubectl apply -k ~/kustomization/TENANT-NAME/

      Modify the path to the Kustomization directory to match your local configuration.

   .. tab-item:: Helm
      :sync: helm

      For Helm-deployed Tenants, you can modify the base ``values.yaml`` and upgrade the Tenant using the chart:

      .. code-block:: shell

         helm upgrade TENANT-NAME minio-operator/tenant -f values.yaml -n TENANT-NAMESPACE

      The command above assumes use of the MinIO Operator Chart repository.
      If you installed the Chart manually or by using a different repository name, specify that chart or name in the command.

      Replace ``TENANT-NAME`` and ``TENANT-NAMESPACE`` with the name and namespace of the Tenant, respectively.
      You can use ``helm list -n TENANT-NAMESPACE`` to validate the Tenant name.

Add Trusted Certificate Authorities
   The MinIO Tenant validates the TLS certificate presented by each connecting client against the host system's trusted root certificate store.
   The MinIO Operator can attach additional third-party Certificate Authorities (CA) to the Tenant to allow validation of client TLS certificates signed by those CAs.

   To customize the trusted CAs mounted to each Tenant MinIO pod, enable the :guilabel:`Custom Certificates` switch.
   Select the :guilabel:`Add CA Certificate +` button to add third party CA certificates.

   If the MinIO Tenant cannot match an incoming client's TLS certificate issuer against either the container OS's trust store *or* an explicitly attached CA, MinIO rejects the connection as invalid.


Manage Tenant Pools
-------------------

Specify Runtime Class
~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: Console 0.23.1

When adding a new pool or modifying an existing pool for a tenant, you can specify the :kube-docs:`Runtime Class Name <concepts/containers/runtime-class/>` for pools to use.

.. Following link is intended for K8s only

Decommission a Tenant Server Pool
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO Operator 4.4.13 and later support decommissioning a server pool in a Tenant.
Specifically, you can follow the :minio-docs:`Decommission a Server pool <minio/linux/operations/install-deploy-manage/decommission-server-pool.html>` procedure to remove the pool from the tenant, then edit the tenant YAML to drop the pool from the StatefulSet.
When removing the Tenant pool, ensure the ``spec.pools.[n].name`` fields have values for all remaining pools.

.. include:: /includes/common-installation.rst
   :start-after: start-pool-order-must-not-change
   :end-before: end-pool-order-must-not-change
