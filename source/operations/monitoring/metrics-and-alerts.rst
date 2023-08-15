.. _minio-metrics-and-alerts-endpoints:
.. _minio-metrics-and-alerts-alerting:
.. _minio-metrics-and-alerts:

==================
Metrics and Alerts
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO publishes cluster and node metrics using the :prometheus-docs:`Prometheus Data Model <data_model/>`.
You can use any scraping tool to pull metrics data from MinIO for further analysis and alerting.

MinIO provides a scraping endpoint for cluster-level metrics:

.. code-block:: shell
   :class: copyable

   http://minio.example.net:9000/minio/v2/metrics/cluster

Replace ``http://minio.example.net`` with the hostname of any node in the MinIO deployment. 
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
For more complete documentation on configuring a Prometheus-compatible data source for Grafana, see :prometheus-docs:`Grafana Support for Prometheus <visualization/grafana/>`.

.. _minio-metrics-and-alerts-available-metrics:

Available Metrics
-----------------

MinIO publishes a number of metrics at the cluster, node, or bucket levels.
Each metric includes a label for the MinIO server which generated that metric.

.. versionchanged:: MinIO RELEASE.2023-07-21T21-12-44Z

   Bucket metrics have moved to use their own, separate endpoint.

.. include:: /operations/monitoring/metrics.md
   :parser: myst_parser.sphinx_

.. 
  Replication Metrics
  ~~~~~~~~~~~~~~~~~~~
  These metrics are only populated for MinIO clusters with 
  :ref:`minio-bucket-replication-serverside` enabled.

..
  .. metric:: minio_bucket_replication_failed_bytes
     Total number of bytes that failed at least once to replicate for a given bucket.
     You can identify the bucket using the ``{ bucket="STRING" }`` label

..
  .. metric:: minio_bucket_replication_pending_bytes  
     Total number of bytes pending to replicate for a given bucket.
     You can identify the bucket using the ``{ bucket="STRING" }`` label

.. 
   .. metric:: minio_bucket_replication_pending_count
     Total number of replication operations pending for a given bucket.
     You can identify the bucket using the ``{ bucket="STRING" }`` label.


..
   .. metric:: minio_node_ilm_expiry_active_tasks

   Total number of active :ref:`object expiration <minio-lifecycle-management-expiration>` tasks


..
  Node and Drive Health Metrics
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

..
  .. metric:: minio_node_storage_class_standard_parity
     The configured value of :envvar:`MINIO_STORAGE_CLASS_STANDARD`.
  
     Use this to alert for changes to the Standard :ref:`erasure parity <minio-erasure-coding>`.
  
  .. metric:: minio_node_storage_class_rrs_parity
     The configured value of :envvar:`MINIO_STORAGE_CLASS_RRS`.
  
     Use this to alert for changes to the Reduced :ref:`erasure parity <minio-erasure-coding>`.

..
  .. _minio-metrics-and-alerts-scanner:
  IAM Plugin Metrics
  ~~~~~~~~~~~~~~~~~~
  .. note::
     The metrics in this section require that you have configured the :ref:`MinIO External Identity Management Plugin <minio-external-identity-management-plugin>`.
  
  .. metric:: minio_node_iam_plugin_authn_service_last_succ_seconds
     Time (in seconds) since last successful request to the external IDP service.
     
  .. metric:: minio_node_iam_plugin_authn_service_last_fail_seconds
     Time (in seconds) since last failed request to the external IDP service.
  
  .. metric:: minio_node_iam_plugin_authn_service_total_requests_minute
     Total requests count to the external IDP service in the last full minute.
  
  .. metric:: minio_node_iam_plugin_authn_service_failed_requests_minute
     Count of the failed requests to the external IDP service in the last full minute.
  
  .. metric:: minio_node_iam_plugin_authn_service_succ_avg_rtt_ms_minute
     Average round trip time (RTT) of successful requests to the IDP service in the last full minute.
  
  .. metric:: minio_node_iam_plugin_authn_service_succ_max_rtt_ms_minute
     Maximum round trip time (RTT) of successful requests to the IDP service in the last full minute.
  
  
..
  Lock Metrics
  ~~~~~~~~~~~~
  .. metric:: minio_locks_total
     Total number of current locks on the peer.
  
  .. metric:: minio_locks_write_total
     Number of current WRITE locks on the peer.
  
  .. metric:: minio_locks_read_total
     Number of current READ locks on the peer.

.. 
  Webhook Metrics
  ~~~~~~~~~~~~~~~
  .. metric:: minio_cluster_webhook_failed_messages
     Number of messages that failed to send.
  
  .. metric:: minio_cluster_webhook_online
     Reports whether the webhook endpoint is online (1) or offline (0). 
  
  .. metric:: minio_cluster_webhook_queue_length
     Number of messages in the webhook queue.
  
  .. metric:: minio_cluster_webhook_total_messages
     Number of messages sent to this webhook endpoint.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/monitoring/collect-minio-metrics-using-prometheus
   /operations/monitoring/monitor-and-alert-using-influxdb
