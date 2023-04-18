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

.. metric:: minio_bucket_objects_version_distribution

   Distribution of number of versions per object in a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_bucket_usage_object_total

   Total number of objects in a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_bucket_usage_total_bytes

   Total bucket size in bytes in a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_bucket_quota_total_bytes

   Total bucket quota size in bytes.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

Replication Metrics
~~~~~~~~~~~~~~~~~~~

These metrics are only populated for MinIO clusters with 
:ref:`minio-bucket-replication-serverside` enabled.

.. metric:: minio_bucket_replication_failed_bytes

   Total number of bytes that failed at least once to replicate for a given bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label

.. metric:: minio_bucket_replication_latency

   Replication latency in milliseconds.

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

.. _minio-metrics-and-alerts-capacity:

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

.. _minio-metrics-and-alerts-lifecycle-management:

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

.. metric:: minio_node_ilm_transition_active_tasks
   
   Number of active ILM transition tasks

.. metric:: minio_node_ilm_expiry_pending_tasks

   Total number of pending :ref:`object expiration <minio-lifecycle-management-expiration>` tasks

.. metric:: minio_node_ilm_expiry_active_tasks

   Total number of active :ref:`object expiration <minio-lifecycle-management-expiration>` tasks

.. metric:: minio_node_ilm_versions_scanned
   
   Total number of object versions checked for ilm actions since server start

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

.. metric:: minio_node_disk_free_inodes
   
   Total free inodes.

.. metric:: minio_node_disk_latency_us
   
   Average last minute latency in µs for drive API storage operations. 

.. metric:: minio_node_disk_offline_total
   
   Total drives offline. 

.. metric:: minio_node_disk_online_total
   
   Total drives online.

.. metric:: minio_node_disk_total
   
   Total drives.

.. metric:: minio_heal_objects_errors_total

   Objects for which healing failed in current self healing run

.. metric:: minio_heal_objects_heal_total

   Objects healed in current self healing run

.. metric:: minio_heal_objects_total

   Objects scanned in current self healing run

.. metric:: minio_heal_time_last_activity_nano_seconds

   Time elapsed (in nano seconds) since last self healing activity. This is set
   to -1 until initial self heal

Notification Queue Metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. metric:: minio_audit_target_queue_length

   Total number of unsent audit messages in the queue.

.. metric:: minio_audit_total_messages

   Total number of audit messages sent since last server start.

.. metric:: minio_audit_failed_messages

   Total number of audit messages which failed to send since last server start.

.. metric:: minio_notify_current_send_in_progress

   Total number of notification messages in progress to configured targets.

.. metric:: minio_notify_target_queue_length

   Total number of unsent notification messages in the queue.

.. _minio-metrics-and-alerts-scanner:

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

.. metric:: minio_usage_last_activity_nano_seconds
   
   Time elapsed since last scan activity. 
   This is set to ``0`` until first scan cycle.

S3 Metrics
~~~~~~~~~~

.. metric:: minio_bucket_traffic_sent_bytes

   Total number of bytes of S3 traffic sent per bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_bucket_traffic_received_bytes

   Total number of bytes of S3 traffic received per bucket.
   You can identify the bucket using the ``{ bucket="STRING" }`` label.

.. metric:: minio_s3_requests_incoming_total
   
   Volatile number of total incoming S3 requests.

.. metric:: minio_s3_requests_canceled_total
   
   Total number S3 requests that were canceled from the client while processing.

.. metric:: minio_s3_requests_inflight_total

   Total number of S3 requests currently in flight.

.. metric:: minio_s3_requests_total

   Total number of S3 requests.

.. metric:: minio_s3_requests_rejected_auth_total
   
   Total number S3 requests rejected for auth failure.

.. metric:: minio_s3_requests_rejected_header_total
   
   Total number S3 requests rejected for invalid header.

.. metric:: minio_s3_requests_rejected_invalid_total
   
   Total number S3 invalid requests.
   
.. metric:: minio_s3_requests_rejected_timestamp_total
   
   Total number S3 requests rejected for invalid timestamp.

.. metric:: minio_s3_requests_waiting_total
   
   Number of S3 requests in the waiting queue.

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

IAM Metrics
~~~~~~~~~~~

.. metric:: minio_node_iam_last_sync_duration_millis
   
   Last successful IAM data sync duration in milliseconds. 

.. metric:: minio_node_iam_since_last_sync_millis
   
   Time (in milliseconds) since last successful IAM data sync. 
   
   This value starts at zero and only increments after the the first sync after server start. 

.. metric:: minio_node_iam_sync_failures
   
   Number of failed IAM data syncs since server start. 

.. metric:: minio_node_iam_sync_successes
   
   Number of successful IAM data syncs since server start. 

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

Internal Metrics
~~~~~~~~~~~~~~~~

.. metric:: minio_inter_node_traffic_received_bytes

   Total number of bytes received from other peer nodes.

.. metric:: minio_inter_node_traffic_sent_bytes

   Total number of bytes sent to the other peer nodes.

.. metric:: minio_inter_node_traffic_dial_avg_time

   Average time of internodes TCP dial calls.

.. metric:: minio_inter_node_traffic_dial_errors

   Total number of internode TCP dial timeouts and errors.

.. metric:: minio_inter_node_traffic_errors_total

   Total number of failed internode calls.

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

Key Management System (KMS) Metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. metric:: minio_cluster_kms_online
   
   Reports whether the KMS is online (1) or offline (0).

.. metric:: minio_cluster_kms_request_error
   
   Number of KMS requests that failed due to some error. (HTTP 4xx status code).

.. metric:: minio_cluster_kms_request_failure
   
   Number of KMS requests that failed due to some internal failure. (HTTP 5xx status code).

.. metric:: minio_cluster_kms_request_success
   
   Number of KMS requests that succeeded.

.. metric:: minio_cluster_kms_uptime
   
   The time the KMS has been up and running in seconds.

Software and Process Metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. metric:: minio_software_commit_info

   Git commit hash for the MinIO release.

.. metric:: minio_software_version_info

   MinIO Release tag for the server

.. metric:: minio_node_go_routine_total

   Total number of go routines running.

.. metric:: minio_node_process_starttime_seconds

   Start time for MinIO process per node, time in seconds since Unix epoch.

.. metric:: minio_node_process_uptime_seconds

   Uptime for MinIO process per node in seconds.

.. metric:: minio_node_process_cpu_total_seconds
   
   Total user and system CPU time spent in seconds.
   
.. metric:: minio_node_process_resident_memory_bytes
   
   Resident memory size in bytes.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/monitoring/collect-minio-metrics-using-prometheus
   /operations/monitoring/monitor-and-alert-using-influxdb
