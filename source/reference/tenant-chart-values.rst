.. _minio-tenant-chart-values:

==================
Tenant Helm Charts
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO publishes |helm-charts| for the |helm-operator-chart| and |helm-tenant-chart|.
You can use these charts to deploy the MinIO Operator and managed Tenants through Helm.

The following page documents the ``values.yaml`` chart for a MinIO Tenant.
For documentation on the chart for a MinIO Operator, see :ref:`minio-operator-chart-values`

.. _minio-tenant-chart-operator-values:


MinIO Tenant Chart
------------------

.. tab-set::

   .. tab-item:: Reference

      .. autoyaml:: /source/includes/k8s/tenant-values.yaml

   .. tab-item:: YAML

      .. literalinclude:: /includes/k8s/tenant-values.yaml