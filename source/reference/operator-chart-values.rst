.. _minio-operator-chart-values:

====================
Operator Helm Charts
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO publishes |helm-charts| for the |helm-operator-chart| and |helm-tenant-chart|.
You can use these charts to deploy the MinIO Operator and managed Tenants through Helm.

The following page documents the ``values.yaml`` chart for the MinIO Operator.
For documentation on the chart for a MinIO Tenant, see :ref:`minio-tenant-chart-values`

.. _minio-operator-chart-operator-values:

MinIO Operator Chart
--------------------

.. tab-set::
   
   .. tab-item:: Reference

      .. autoyaml:: /source/includes/k8s/operator-values.yaml

   .. tab-item:: YAML

      .. literalinclude:: /includes/k8s/operator-values.yaml
