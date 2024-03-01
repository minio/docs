.. _minio-tenant-chart-values:

==================
Tenant Helm Charts
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO publishes `Helm Charts <https://github.com/minio/operator/tree/v|operator-version-stable|/helm>`__ for the :ref:`MinIO Operator <minio-operator-chart-values>` and Tenants.
You can use these charts to deploy the MinIO Operator and managed Tenants through Helm.

The following page documents the ``values.yaml`` chart for a MinIO Tenant.

.. _minio-tenant-chart-operator-values:


MinIO Tenant Chart
------------------

.. tab-set::

   .. tab-item:: Reference

      .. autoyaml:: /source/includes/k8s/tenant-values.yaml

   .. tab-item:: YAML

      .. literalinclude:: /includes/k8s/tenant-values.yaml