:orphan:
.. _minio-metrics-v2:

=================
Metrics Version 2
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 3

.. admonition:: Metrics Version 2 Deprecated
   :class: note

   Starting with MinIO Server :minio-release:`RELEASE.2024-07-15T19-02-30Z` and MinIO Client :mc-release:`RELEASE.2024-07-11T18-01-28Z`, :ref:`metrics version 3 <minio-metrics-and-alerts>` replaces the deprecated metrics version 2.

The following sections describe the deprecated endpoints and metrics.

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

.. include:: /includes/common-metrics-bucket.md
   :parser: myst_parser.sphinx_

.. _minio-available-resource-metrics:

.. include:: /includes/common-metrics-resource.md
   :parser: myst_parser.sphinx_

