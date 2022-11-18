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

MinIO also publishes a `Grafana Dashboard <https://grafana.com/grafana/dashboards/13502>`_ for visualizing collected metrics. 
For more complete documentation on configuring a Prometheus-compatible data source for Grafana, see :prometheus-docs:`Grafana Support for Prometheus <visualization/grafana/>`.

.. _minio-metrics-and-alerts-available-metrics:

Available Metrics
-----------------

MinIO publishes the following metrics, where each metric includes a label for
the MinIO server which generated that metric.

Object and Bucket Metrics
~~~~~~~~~~~~~~~~~~~~~~~~~

.. metric:: minio_bucket_objects_size_distribution

   Distribution of object sizes in a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_bucket_usage_object_total

   Total number of objects in a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_bucket_usage_total_bytes

   Total bucket size in bytes in a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

Replication Metrics
~~~~~~~~~~~~~~~~~~~

These metrics are only populated for MinIO clusters with 
:ref:`minio-bucket-replication-serverside` enabled.

.. metric:: minio_bucket_replication_failed_bytes

   Total number of bytes that failed at least once to replicate for a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label

.. metric:: minio_bucket_replication_pending_bytes

   Total number of bytes pending to replicate for a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label

.. metric:: minio_bucket_replication_received_bytes

   Total number of bytes replicated to this bucket from another source bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_bucket_replication_sent_bytes

   Total number of bytes replicated to the target bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_bucket_replication_pending_count

   Total number of replication operations pending for a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_bucket_replication_failed_count

   Total number of replication operations failed for a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

Capacity Metrics
~~~~~~~~~~~~~~~~

.. metric:: minio_cluster_capacity_raw_free_bytes

   Total free capacity online in the cluster.

.. metric:: minio_cluster_capacity_raw_total_bytes

   Total capacity online in the cluster.

.. metric:: minio_cluster_capacity_usable_free_bytes

   Total free usable capacity online in the cluster.

.. metric:: minio_cluster_capacity_usable_total_bytes

   Total usable capacity online in the cluster.

.. metric:: minio_node_disk_free_bytes

   Total storage available on a specific drive for a node in the MinIO deployment.
   You can identify the drive and node using the ``{ disk="/path/to/disk",server="STRING"}`` labels respectively.

.. metric:: minio_node_disk_total_bytes

   Total storage on a specific drive for a node in the MinIO deployment. 
   You can identify the drive and node using the ``{ disk="/path/to/disk",server="STRING"}`` labels respectively.

.. metric:: minio_node_disk_used_bytes

   Total storage used on a specific drive for a node in a MinIO deployment. 
   You can identify the drive and node using the ``{ disk="/path/to/disk",server="STRING"}`` labels respectively.

Lifecycle Management Metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. metric:: minio_cluster_ilm_transitioned_bytes

   Total number of bytes transitioned using :ref:`tiering/transition lifecycle management rules <minio-lifecycle-management-tiering>`


.. metric:: minio_cluster_ilm_transitioned_objects

   Total number of objects transitioned using :ref:`tiering/transition lifecycle management rules <minio-lifecycle-management-tiering>`

.. metric:: minio_cluster_ilm_transitioned_versions

   Total number of non-current object versions transitioned using :ref:`tiering/transition lifecycle management rules <minio-lifecycle-management-tiering>`

.. metric:: minio_node_ilm_transition_pending_tasks

   Total number of pending :ref:`object transition <minio-lifecycle-management-tiering>` tasks

.. metric:: minio_node_ilm_expiry_pending_tasks

   Total number of pending :ref:`object expiration <minio-lifecycle-management-expiration>` tasks

.. metric:: minio_node_ilm_expiry_active_tasks

   Total number of active :ref:`object expiration <minio-lifecycle-management-expiration>` tasks

Node and Drive Health Metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. metric:: minio_cluster_disk_online_total

   The total number of drives online

.. metric:: minio_cluster_disk_offline_total

   The total number of drives offline

.. metric:: minio_cluster_disk_total

   The total number of drives

.. metric:: minio_cluster_nodes_offline_total

   Total number of MinIO nodes offline.

.. metric:: minio_cluster_nodes_online_total

   Total number of MinIO nodes online.

.. metric:: minio_heal_objects_error_total

   Objects for which healing failed in current self healing run

.. metric:: minio_heal_objects_heal_total

   Objects healed in current self healing run

.. metric:: minio_heal_objects_total

   Objects scanned in current self healing run

.. metric:: minio_heal_time_last_activity_nano_seconds

   Time elapsed (in nano seconds) since last self healing activity. This is set
   to -1 until initial self heal

Scanner Metrics
~~~~~~~~~~~~~~~

.. metric:: minio_node_scanner_bucket_scans_finished

   Total number of bucket scans finished since server start.

.. metric:: minio_node_scanner_bucket_scans_started

   Total number of bucket scans started since server start.

.. metric:: minio_node_scanner_directories_scanned

   Total number of directories scanned since server start.

.. metric:: minio_node_scanner_objects_scanned

   Total number of unique objects scanned since server start.

.. metric:: minio_node_scanner_versions_scanned

   Total number of object versions scanned since server start.

.. metric:: minio_node_syscall_read_total

   Total number of read SysCalls to the kernel. ``/proc/[pid]/io syscr``

.. metric:: minio_node_syscall_write_total

   Total number of write SysCalls to the kernel. ``/proc/[pid]/io syscw``

S3 Metrics
~~~~~~~~~~

.. metric:: minio_bucket_traffic_sent_bytes

   Total number of bytes of S3 traffic sent per bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_bucket_traffic_received_bytes

   Total number of bytes of S3 traffic received per bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_s3_requests_inflight_total

   Total number of S3 requests currently in flight.

.. metric:: minio_s3_requests_total

   Total number of S3 requests.

.. metric:: minio_s3_time_ttfb_seconds_distribution

   Distribution of the time to first byte across API calls.

.. metric:: minio_s3_traffic_received_bytes

   Total number of S3 bytes received.

.. metric:: minio_s3_traffic_sent_bytes

   Total number of S3 bytes sent.

.. metric:: minio_s3_requests_errors_total

   Total number of S3 requests with 4xx and 5xx errors.

.. metric:: minio_s3_requests_4xx_errors_total

   Total number of S3 requests with 4xx errors.

.. metric:: minio_s3_requests_5xx_errors_total

   Total number of S3 requests with 5xx errors.

Internal Metrics
~~~~~~~~~~~~~~~~

.. metric:: minio_inter_node_traffic_received_bytes

   Total number of bytes received from other peer nodes.

.. metric:: minio_inter_node_traffic_sent_bytes

   Total number of bytes sent to the other peer nodes.

.. metric:: minio_node_file_descriptor_limit_total

   Limit on total number of open file descriptors for the MinIO Server process.

.. metric:: minio_node_file_descriptor_open_total

   Total number of open file descriptors by the MinIO Server process.

.. metric:: minio_node_io_rchar_bytes

   Total bytes read by the process from the underlying storage system including
   cache, ``/proc/[pid]/io rchar``

.. metric:: minio_node_io_read_bytes

   Total bytes read by the process from the underlying storage system, 
   ``/proc/[pid]/io read_bytes``

.. metric:: minio_node_io_wchar_bytes

   Total bytes written by the process to the underlying storage system including 
   page cache, ``/proc/[pid]/io wchar``

.. metric:: minio_node_io_write_bytes

   Total bytes written by the process to the underlying storage system, 
   ``/proc/[pid]/io write_bytes``

Software and Process Metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. metric:: minio_software_commit_info

   Git commit hash for the MinIO release.

.. metric:: minio_software_version_info

   MinIO Release tag for the server

.. metric:: minio_node_process_starttime_seconds

   Start time for MinIO process per node, time in seconds since Unix epoch.

.. metric:: minio_node_process_uptime_seconds

   Uptime for MinIO process per node in seconds.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/monitoring/collect-minio-metrics-using-prometheus
   /operations/monitoring/monitor-and-alert-using-influxdb