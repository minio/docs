.. _minio-metrics-v2:

=================
Metrics version 2
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 3


MinIO publishes cluster and node metrics using the :prometheus-docs:`Prometheus Data Model <concepts/data_model/>`.
You can use any scraping tool to pull metrics data from MinIO for further analysis and alerting.

Version 2 Endpoints
-------------------

Metrics version 2 provides metrics organized into three categories:

- :ref:`Cluster Metrics <minio-available-cluster-metrics>`
- :ref:`Bucket Metrics <minio-available-bucket-metrics>`
- :ref:`Resource Metrics <minio-available-resource-metrics>`

Each v2 endpoint returns all metrics for its category.
For example, scraping the following endpoint returns all cluster metrics:

.. code-block:: shell
   :class: copyable

   http://HOSTNAME:PORT/minio/v2/metrics/cluster

The base endpoint alone, ``/minio/v2/metrics/``, returns cluster metrics.

For more flexible scraping and a wider range of metrics, use :ref:`metrics version 3. <minio-metrics-and-alerts>`
   Existing deployments can continue to use version 2 :ref:`metrics <minio-metrics-v2>` and :ref:`Grafana dashboards <minio-grafana>`.


MinIO Grafana dashboard
-----------------------

MinIO publishes two :ref:`Grafana Dashboards <minio-grafana>` for visualizing v2 metrics.
For more complete documentation on configuring a Prometheus-compatible data source for Grafana, see the :prometheus-docs:`Prometheus documentation on Grafana Support <visualization/grafana/>`.


Available version 2 metrics
---------------------------

The following sections describe the version 2 endpoints and metrics.

.. tab-set::

   .. tab-item:: Cluster Metrics

      You can scrape :ref:`cluster-level metrics <minio-available-cluster-metrics>` using the following URL endpoint:

      .. code-block:: shell
         :class: copyable

         http://HOSTNAME:PORT/minio/v2/metrics/cluster

      Replace ``HOSTNAME:PORT`` with the :abbr:`FQDN (Fully Qualified Domain Name)` and port of the MinIO deployment.
      For deployments with a load balancer managing connections between MinIO nodes, specify the address of the load balancer.


   .. tab-item:: Bucket Metrics

      .. versionchanged:: MinIO RELEASE.2023-07-21T21-12-44Z

         Bucket metrics have moved to use their own, separate endpoint.

      .. versionchanged:: RELEASE.2023-08-31T15-31-16Z

         You can scrape :ref:`bucket-level metrics <minio-available-bucket-metrics>` using the following URL endpoint:

      .. versionchanged:: RELEASE.2025-03-12T17-29-24Z

         v2 metrics have a limit of 100 buckets for performance reasons.
         For metrics across a higher number of buckets, use :ref:`v3 metrics <minio-metrics-and-alerts-available-metrics>` instead.
     
      .. code-block:: shell
         :class: copyable

         http://HOSTNAME:PORT/minio/v2/metrics/bucket

      Replace ``HOSTNAME:PORT`` with the :abbr:`FQDN (Fully Qualified Domain Name)` and port of the MinIO deployment.
      For deployments with a load balancer managing connections between MinIO nodes, specify the address of the load balancer.


   .. tab-item:: Resource Metrics

      .. versionadded:: RELEASE.2023-10-07T15-07-38Z 

      You can scrape :ref:`resource metrics <minio-available-resource-metrics>` using the following URL endpoint:

      .. code-block:: shell
         :class: copyable

         http://HOSTNAME:PORT/minio/v2/metrics/resource

      Replace ``HOSTNAME:PORT`` with the :abbr:`FQDN (Fully Qualified Domain Name)` and port of the MinIO deployment.
      For deployments with a load balancer managing connections between MinIO nodes, specify the address of the load balancer.


- :ref:`Cluster Metrics <minio-available-cluster-metrics>`
- :ref:`Bucket Metrics <minio-available-bucket-metrics>`
- :ref:`Resource Metrics <minio-available-resource-metrics>`

.. _minio-available-cluster-metrics:

.. include:: /includes/common-metrics-cluster.md
   :parser: myst_parser.sphinx_

.. _minio-available-bucket-metrics:

   .. versionchanged:: RELEASE.2025-03-12T17-29-24Z

      v2 metrics have a limit of 100 buckets for performance reasons.
      For metrics across a higher number of buckets, use :ref:`v3 metrics <minio-metrics-and-alerts-available-metrics>` instead.


.. include:: /includes/common-metrics-bucket.md
   :parser: myst_parser.sphinx_

.. _minio-available-resource-metrics:

.. include:: /includes/common-metrics-resource.md
   :parser: myst_parser.sphinx_

