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

      See :ref:`minio-tenant-chart-values` for more complete documentation on the available Chart fields.