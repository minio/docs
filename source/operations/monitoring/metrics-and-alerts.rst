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
For more complete documentation on configuring a Prometheus-compatible data source for Grafana, see the :prometheus-docs:`Prometheus documentation on Grafana Support <visualization/grafana/>`.

.. _minio-metrics-and-alerts-available-metrics:

Available Metrics
-----------------

MinIO publishes a number of metrics at the cluster, node, or bucket levels.
Each metric includes a label for the MinIO server which generated that metric.

.. versionchanged:: MinIO RELEASE.2023-07-21T21-12-44Z

   Bucket metrics have moved to use their own, separate endpoint.

- :ref:`Cluster Metrics <minio_available_cluster_metrics>`
- :ref:`Node Metrics <minio_available_node_metrics>`
- :ref:`Bucket Metrics <minio_available_bucket_metrics>`

.. _minio_available_cluster_metrics:

Cluster Metrics
~~~~~~~~~~~~~~~

Each metric includes the following labels:

- Server that generated the metric.
- Server that calculated the metric.

These metrics can be obtained from any MinIO server once per collection.

Audit Metrics
+++++++++++++

``minio_audit_failed_messages``
  Total number of messages that failed to send since start.

``minio_audit_target_queue_length``
  Number of unsent messages in queue for target.

``minio_audit_total_messages``
  Total number of messages sent since start.

Cluster Capacity Metrics
++++++++++++++++++++++++

``minio_cluster_capacity_raw_free_bytes``
  Total free capacity online in the cluster.

``minio_cluster_capacity_raw_total_bytes``
  Total capacity online in the cluster.

``minio_cluster_capacity_usable_free_bytes``
  Total free usable capacity online in the cluster.

``minio_cluster_capacity_usable_total_bytes``
  Total usable capacity online in the cluster.

Cluster Usage Metrics
+++++++++++++++++++++

``minio_cluster_objects_size_distribution``
  Distribution of object sizes across a cluster.

``minio_cluster_objects_version_distribution``
  Distribution of object sizes across a cluster.

``minio_cluster_usage_object_total``
  Total number of objects in a cluster.

``minio_cluster_usage_total_bytes``
  Total cluster usage in bytes.

``minio_cluster_usage_version_total``
  Total number of versions (includes delete marker) in a cluster.

``minio_cluster_usage_deletemarker_total``
  Total number of delete markers in a cluster.

``minio_cluster_usage_total_bytes``
  Total cluster usage in bytes.

``minio_cluster_buckets_total``
  Total number of buckets in the cluster.

Drive Metrics
+++++++++++++

``minio_cluster_disk_offline_total``
  Total drives offline.

``minio_cluster_disk_online_total``
  Total drives online.

``minio_cluster_disk_total``
  Total drives.

ILM Metrics
+++++++++++

``minio_cluster_ilm_transitioned_bytes``
  Total bytes transitioned to a tier.

``minio_cluster_ilm_transitioned_objects``
  Total number of objects transitioned to a tier.

``minio_cluster_ilm_transitioned_versions``
  Total number of versions transitioned to a tier.

``minio_node_ilm_expiry_active_tasks``
  Total number of active :ref:`object expiration <minio-lifecycle-management-expiration>` tasks.


Key Management Metrics
++++++++++++++++++++++

``minio_cluster_kms_online``  
  Reports whether the KMS is online (1) or offline (0).

``minio_cluster_kms_request_error``
  Number of KMS requests that failed due to some error. 
  (HTTP 4xx status code).

``minio_cluster_kms_request_failure``
  Number of KMS requests that failed due to some internal failure. 
  (HTTP 5xx status code).

``minio_cluster_kms_request_success``
  Number of KMS requests that succeeded.

``minio_cluster_kms_uptime``
  The time the KMS has been up and running in seconds.

Cluster Health Metrics
++++++++++++++++++++++

``minio_cluster_nodes_offline_total``
  Total number of MinIO nodes offline.

``minio_cluster_nodes_online_total``
  Total number of MinIO nodes online.

``minio_cluster_write_quorum``
  Maximum write quorum across all pools and sets.

``minio_cluster_health_status``
  Get current cluster health status.

``minio_heal_objects_errors_total``
  Objects for which healing failed in current self healing run.

``minio_heal_objects_heal_total``
  Objects healed in current self healing run.

``minio_heal_objects_total``
  Objects scanned in current self healing run.

``minio_heal_time_last_activity_nano_seconds``
  Time elapsed (in nano seconds) since last self healing activity.

``minio_minio_update_percent``
  Total percentage cache usage.

``minio_software_commit_info``
  Git commit hash for the MinIO release.

``minio_software_version_info``
  MinIO Release tag for the server.

``minio_usage_last_activity_nano_seconds``
  Time elapsed (in nano seconds) since last scan activity.

Inter Node Metrics
++++++++++++++++++

``minio_inter_node_traffic_dial_avg_time``
  Average time of internodes TCP dial calls.

``minio_inter_node_traffic_dial_errors``
  Total number of internode TCP dial timeouts and errors.

``minio_inter_node_traffic_errors_total``
  Total number of failed internode calls.

``minio_inter_node_traffic_received_bytes``
  Total number of bytes received from other peer nodes.

``minio_inter_node_traffic_sent_bytes``
  Total number of bytes sent to the other peer nodes.

S3 Request Metrics
++++++++++++++++++

``minio_s3_requests_4xx_errors_total``
  Total number S3 requests with (4xx) errors.

``minio_s3_requests_5xx_errors_total``
  Total number S3 requests with (5xx) errors.

``minio_s3_requests_canceled_total``
  Total number S3 requests canceled by the client.

``minio_s3_requests_errors_total``
  Total number S3 requests with (4xx and 5xx) errors.

``minio_s3_requests_incoming_total``
  Volatile number of total incoming S3 requests.

``minio_s3_requests_inflight_total``
  Total number of S3 requests currently in flight.

``minio_s3_requests_rejected_auth_total``
  Total number S3 requests rejected for auth failure.

``minio_s3_requests_rejected_header_total``
  Total number S3 requests rejected for invalid header.

``minio_s3_requests_rejected_invalid_total``
  Total number S3 invalid requests.

``minio_s3_requests_rejected_timestamp_total``
  Total number S3 requests rejected for invalid timestamp.

``minio_s3_requests_total``
  Total number S3 requests.

``minio_s3_requests_waiting_total``
  Number of S3 requests in the waiting queue.

``minio_s3_requests_ttfb_seconds_distribution``
  Distribution of the time to first byte across API calls.

``minio_s3_traffic_received_bytes``
  Total number of s3 bytes received.

``minio_s3_traffic_sent_bytes``
  Total number of s3 bytes sent.

Lock Metrics
++++++++++++

``minio_locks_total``
  Total number of current locks on the peer.
  
``minio_locks_write_total``
  Number of current WRITE locks on the peer.
  
``minio_locks_read_total``
  Number of current READ locks on the peer.

Webhook Metrics
+++++++++++++++

``minio_cluster_webhook_failed_messages``
  Number of messages that failed to send.
  
``minio_cluster_webhook_online``
  Reports whether the webhook endpoint is online (1) or offline (0). 
  
``minio_cluster_webhook_queue_length``
  Number of messages in the webhook queue.
  
``minio_cluster_webhook_total_messages``
  Number of messages sent to this webhook endpoint.


.. _minio_available_node_metrics:

Node Metrics
~~~~~~~~~~~~

Each metric includes the following labels:

- Server that generated the metric.
- Server that calculated the metric.
  
These metrics can be obtained from any MinIO server once per collection.

Drive Metrics
+++++++++++++

``minio_node_disk_free_bytes``
  Total storage available on a drive.

``minio_node_disk_free_inodes``
  Total free inodes.

``minio_node_disk_latency_us``
  Average last minute latency in µs for drive API storage operations.

``minio_node_disk_offline_total``
  Total drives offline.

``minio_node_disk_online_total``
  Total drives online.

``minio_node_disk_total``
  Total drives.

``minio_node_disk_total_bytes``
  Total storage on a drive.

``minio_node_disk_used_bytes``
  Total storage used on a drive.

File Metrics
++++++++++++

``minio_node_file_descriptor_limit_total``
  Limit on total number of open file descriptors for the MinIO Server process.

``minio_node_file_descriptor_open_total``
  Total number of open file descriptors by the MinIO Server process.

Go Metrics
++++++++++

``minio_node_go_routine_total``
  Total number of go routines running.

Access Management (IAM) Metrics
+++++++++++++++++++++++++++++++

``minio_node_iam_last_sync_duration_millis``
  Last successful IAM data sync duration in milliseconds.

``minio_node_iam_since_last_sync_millis``
  Time (in milliseconds) since last successful IAM data sync.

``minio_node_iam_sync_failures``
  Number of failed IAM data syncs since server start.

``minio_node_iam_sync_successes``
  Number of successful IAM data syncs since server start.

Lifecycle Management (ILM) Metrics
++++++++++++++++++++++++++++++++++

``minio_node_ilm_expiry_pending_tasks``
  Number of pending ILM expiry tasks in the queue.

``minio_node_ilm_transition_active_tasks``
  Number of active ILM transition tasks.

``minio_node_ilm_transition_pending_tasks``
  Number of pending ILM transition tasks in the queue.

``minio_node_ilm_versions_scanned``
  Total number of object versions checked for ilm actions since server start.

I/O Metrics
+++++++++++

``minio_node_io_rchar_bytes``
  Total bytes read by the process from the underlying storage system including cache, ``/proc/[pid]/io`` rchar.

``minio_node_io_read_bytes``
  Total bytes read by the process from the underlying storage system, ``/proc/[pid]/io`` read_bytes.

``minio_node_io_wchar_bytes``
  Total bytes written by the process to the underlying storage system including page cache, ``/proc/[pid]/io`` wchar.

``minio_node_io_write_bytes``
  Total bytes written by the process to the underlying storage system, ``/proc/[pid]/io`` write_bytes.

Process Metrics
+++++++++++++++

``minio_node_process_cpu_total_seconds``
  Total user and system CPU time spent in seconds.

``minio_node_process_resident_memory_bytes``
  Resident memory size in bytes.

``minio_node_process_starttime_seconds``
  Start time for MinIO process per node, time in seconds since Unix epoc.

``minio_node_process_uptime_seconds``
  Uptime for MinIO process per node in seconds.

Scanner Metrics
+++++++++++++++

``minio_node_scanner_bucket_scans_finished``
  Total number of bucket scans finished since server start.

``minio_node_scanner_bucket_scans_started``
  Total number of bucket scans started since server start.

``minio_node_scanner_directories_scanned``
  Total number of directories scanned since server start.

``minio_node_scanner_objects_scanned``
  Total number of unique objects scanned since server start.

``minio_node_scanner_versions_scanned``
  Total number of object versions scanned since server start.

Read and Write Metrics
++++++++++++++++++++++

``minio_node_syscall_read_total``
  Total read SysCalls to the kernel. 
  ``/proc/[pid]/io`` syscr.

``minio_node_syscall_write_total``
  Total write SysCalls to the kernel. 
  ``/proc/[pid]/io`` syscw.

Notification Metrics
++++++++++++++++++++

``minio_notify_current_send_in_progress``
  Number of concurrent async Send calls active to all targets.

``minio_notify_target_queue_length``
  Number of unsent notifications in queue for target.

IAM Plugin Metrics
++++++++++++++++++
  
.. note::
  
   The metrics in this section require that you have configured the :ref:`MinIO External Identity Management Plugin <minio-external-identity-management-plugin>`.
  
``minio_node_iam_plugin_authn_service_last_succ_seconds``
  Time (in seconds) since last successful request to the external IDP service.
     
``minio_node_iam_plugin_authn_service_last_fail_seconds``
  Time (in seconds) since last failed request to the external IDP service.
  
``minio_node_iam_plugin_authn_service_total_requests_minute``
  Total requests count to the external IDP service in the last full minute.
  
``minio_node_iam_plugin_authn_service_failed_requests_minute``
  Count of the failed requests to the external IDP service in the last full minute.
  
``minio_node_iam_plugin_authn_service_succ_avg_rtt_ms_minute``
  Average round trip time (RTT) of successful requests to the IDP service in the last full minute.
  
``minio_node_iam_plugin_authn_service_succ_max_rtt_ms_minute``
  Maximum round trip time (RTT) of successful requests to the IDP service in the last full minute.


.. _minio_available_bucket_metrics:

Bucket Metrics
~~~~~~~~~~~~~~

Each bucket metric includes the following labels:

- The server that calculated the metric. 
- The server that generated the metric. 
- The bucket the metric is for.

These metrics can be obtained from any MinIO server once per collection.

Distribution Metrics
++++++++++++++++++++

``minio_bucket_objects_size_distribution``
  Distribution of object sizes in the bucket, includes label for the bucket name.

``minio_bucket_objects_version_distribution``
  Distribution of object sizes in a bucket, by number of versions.

``minio_bucket_quota_total_bytes``
  Total bucket quota size in bytes.

Replication Metrics
+++++++++++++++++++

.. note::

   The metrics for bucket replication only populate for MinIO clusters with :ref:`minio-bucket-replication-serverside` enabled.

``minio_bucket_replication_failed_count``
  Total number of objects which failed replication.

``minio_bucket_replication_latency_ms`` 
  Replication latency in milliseconds.

``minio_bucket_replication_received_bytes``
  Total number of bytes replicated to this bucket from another source bucket.

``minio_bucket_replication_sent_bytes``
  Total number of bytes replicated to the target bucket.

``minio_bucket_replication_failed_bytes``
   Total number of bytes that failed at least once to replicate for a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

``minio_bucket_replication_pending_bytes``
  Total number of bytes pending to replicate for a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

``minio_bucket_replication_pending_count``
  Total number of replication operations pending for a given bucket.
  You can identify the bucket using the ``{ bucket="STRING" }`` label.

Traffic Metrics
+++++++++++++++

``minio_bucket_traffic_received_bytes``
  Total number of S3 bytes received for this bucket.

``minio_bucket_traffic_sent_bytes``
  Total number of S3 bytes sent for this bucket.

Usage Metrics
+++++++++++++

``minio_bucket_usage_object_total``
  Total number of objects.

``minio_bucket_usage_version_total``
  Total number of versions (includes delete marker).

``minio_bucket_usage_deletemarker_total``
  Total number of delete markers.

``minio_bucket_usage_total_bytes``
  Total bucket size in bytes.

Requests Metrics
++++++++++++++++

``minio_bucket_requests_4xx_errors_total``
  Total number of S3 requests with (4xx) errors on a bucket.

``minio_bucket_requests_5xx_errors_total``
  Total number of S3 requests with (5xx) errors on a bucket.

``minio_bucket_requests_inflight_total``
  Total number of S3 requests currently in flight on a bucket.

``minio_bucket_requests_total``
  Total number of S3 requests on a bucket.

``minio_bucket_requests_canceled_total``
  Total number S3 requests canceled by the client.

``minio_bucket_requests_ttfb_seconds_distribution``
  Distribution of time to first byte across API calls per bucket.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/monitoring/collect-minio-metrics-using-prometheus
   /operations/monitoring/monitor-and-alert-using-influxdb
