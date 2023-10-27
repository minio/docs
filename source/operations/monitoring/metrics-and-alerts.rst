.. _minio-metrics-and-alerts-endpoints:
.. _minio-metrics-and-alerts-alerting:
.. _minio-metrics-and-alerts:

==================
Metrics and Alerts
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 3

MinIO publishes cluster and node metrics using the :prometheus-docs:`Prometheus Data Model <concepts/data_model/>`.
You can use any scraping tool to pull metrics data from MinIO for further analysis and alerting.

MinIO provides scraping endpoints for the following metric groups:

.. tab-set::

   .. tab-item:: Cluster Metrics

      You can scrape :ref:`cluster-level metrics <minio-available-cluster-metrics>` using the following URL endpoint:

      .. code-block:: shell
         :class: copyable

         http://HOSTNAME:PORT/minio/v2/metrics/cluster

      Replace ``HOSTNAME:PORT`` with the :abbr:`FQDN (Fully Qualified Domain Name)` and port of the MinIO deployment.
      For deployments with a load balancer managing connections between MinIO nodes, specify the address of the load balancer.


   .. tab-item:: Bucket Metrics

      .. versionchanged:: RELEASE.2023-08-31T15-31-16Z

      You can scrape :ref:`bucket-level metrics <minio-available-bucket-metrics>` using the following URL endpoint:

      .. code-block:: shell
         :class: copyable

         http://HOSTNAME:PORT/minio/v2/metrics/bucket

      Replace ``HOSTNAME:PORT`` with the :abbr:`FQDN (Fully Qualified Domain Name)` and port of the MinIO deployment.
      For deployments with a load balancer managing connections between MinIO nodes, specify the address of the load balancer.


MinIO by default requires authentication for scraping the metrics endpoints.
Use the :mc-cmd:`mc admin prometheus generate` command to generate the necessary bearer tokens. 
You can alternatively disable metrics endpoint authentication by setting :envvar:`MINIO_PROMETHEUS_AUTH_TYPE` to ``public``.

.. _minio-console-metrics:

MinIO Console Metrics Dashboard
-------------------------------

The :ref:`MinIO Console <minio-console-monitoring>` provides a point-in-time metrics dashboard by default:

.. image:: /images/minio-console/console-metrics-simple.png
   :width: 600px
   :alt: MinIO Console with Point-In-Time Metrics
   :align: center

The Console also supports displaying time-series and historical data by querying a :prometheus-docs:`Prometheus <prometheus/latest/getting_started/>` service configured to scrape data from the MinIO deployment. 
Specifically, the MinIO Console uses :prometheus-docs:`Prometheus query API <prometheus/latest/querying/api/>` to retrieve stored metrics data and display the following visualizations:

- :guilabel:`Usage` - provides historical and on-demand visualization of overall usage and status
- :guilabel:`Traffic` - provides historical and on-demand visualization of network traffic
- :guilabel:`Resources` - provides historical and on-demand visualization of  resources (compute and storage)
- :guilabel:`Info` - provides point-in-time status of the deployment

.. image:: /images/minio-console/console-metrics.png
   :width: 600px
   :alt: MinIO Console displaying Prometheus-backed Monitoring Data
   :align: center

.. cond:: k8s

   The MinIO Operator supports deploying a per-tenant Prometheus instance configured to support metrics and visualization.
   
   If you deploy the Tenant with this feature disabled *but* still want the historical metric views, you can instead configure an external Prometheus service to scrape the Tenant metrics.
   Once configured, you can update the Tenant to query that Prometheus service to retrieve metric data:

.. cond:: linux or container or macos or windows
   
   To enable historical data visualization in MinIO Console, set the following environment variables on each node in the MinIO deployment:

- Set :envvar:`MINIO_PROMETHEUS_URL` to the URL of the Prometheus service
- Set :envvar:`MINIO_PROMETHEUS_JOB_ID` to the unique job ID assigned to the collected metrics

MinIO Grafana Dashboard
-----------------------

MinIO also publishes two :ref:`Grafana Dashboards <minio-grafana>` for visualizing collected metrics. 
For more complete documentation on configuring a Prometheus-compatible data source for Grafana, see the :prometheus-docs:`Prometheus documentation on Grafana Support <visualization/grafana/>`.

.. _minio-metrics-and-alerts-available-metrics:

Available Metrics
-----------------

MinIO publishes a number of metrics at the cluster, node, or bucket levels.
Each metric includes a label for the MinIO server which generated that metric.

.. versionchanged:: MinIO RELEASE.2023-07-21T21-12-44Z

   Bucket metrics have moved to use their own, separate endpoint.

- :ref:`Cluster Metrics <minio-available-cluster-metrics>`
- :ref:`Bucket Metrics <minio-available-bucket-metrics>`

.. _minio-available-cluster-metrics:

.. include:: /includes/common-metrics-cluster.md
   :parser: myst_parser.sphinx_

.. _minio-available-bucket-metrics:

.. include:: /includes/common-metrics-bucket.md
   :parser: myst_parser.sphinx_

.. toctree::
   :titlesonly:
   :hidden:

   /operations/monitoring/collect-minio-metrics-using-prometheus
   /operations/monitoring/monitor-and-alert-using-influxdb
