.. _minio-operator-chart-values:

===================
Operator and Tenant Helm Charts
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO publishes `Helm Charts <https://github.com/minio/operator/tree/v5.0.10/helm>`__ for the MinIO Operator and Tenants.
You can use these charts to deploy the MinIO Operator and managed Tenants through Helm.

The following page documents the ``values.yaml`` for each chart.

.. _minio-operator-chart-operator-values:

MinIO Operator Chart
--------------------

.. tab-set::
   
   .. tab-item:: Reference

      .. autoyaml:: /source/includes/k8s/operator-values.yaml

   .. tab-item:: YAML

      .. literalinclude:: /includes/k8s/operator-values.yaml

.. _minio-operator-chart-tenant-values:

MinIO Tenant Chart
------------------

.. tab-set::

   .. tab-item:: Reference

      .. autoyaml:: /source/includes/k8s/tenant-values.yaml

   .. tab-item:: YAML

      .. literalinclude:: /includes/k8s/tenant-values.yaml