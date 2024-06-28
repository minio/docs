===============================
``mc admin prometheus metrics``
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin prometheus metrics

Description
-----------

.. start-mc-admin-prometheus-metrics-desc

The :mc:`mc admin prometheus metrics` command prints Prometheus metrics for a cluster.

.. end-mc-admin-prometheus-metrics-desc

For more complete documentation on using MinIO with Prometheus, see :ref:`How to monitor MinIO server with Prometheus <minio-metrics-collect-using-prometheus>`

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command prints cluster metrics from the deployment at :term:`alias` ``myminio``:

      .. code-block:: shell
         :class: copyable

         mc admin prometheus metrics myminio cluster

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin prometheus metrics  \
                                           ALIAS    \
                                           [TYPE]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc:`alias <mc alias>` of a configured MinIO deployment for which the command prints metrics.

.. mc-cmd:: TYPE
   :optional:

   The type of metrics to print.

      .. versionchanged:: RELEASE.2023-10-07T15-07-38Z

         ``resource`` metrics added

      Valid values are:

      - ``bucket``
      - ``cluster``
      - ``node``
      - ``resource``

      If not specified, the command returns cluster metrics.
      Cluster metrics include rollups of certain node metrics.
      The output includes additional information about each metric, such as if its value is a ``counter`` or ``gauge``.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Example
-------

Print bucket metrics
~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin prometheus metrics` to print bucket metrics for a MinIO deployment:

.. code-block:: shell
   :class: copyable

      mc admin prometheus metrics ALIAS bucket

- Replace ``ALIAS`` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

The output resembles the following:

.. code-block:: shell

   # HELP minio_bucket_objects_size_distribution Distribution of object sizes in the bucket, includes label for the bucket name
   # TYPE minio_bucket_objects_size_distribution gauge
   minio_bucket_objects_size_distribution{bucket="mybucket",range="BETWEEN_1024B_AND_1_MB",server="127.0.0.1:9000"} 0
   minio_bucket_objects_size_distribution{bucket="mybucket",range="BETWEEN_1024_B_AND_64_KB",server="127.0.0.1:9000"} 0
   minio_bucket_objects_size_distribution{bucket="mybucket",range="BETWEEN_10_MB_AND_64_MB",server="127.0.0.1:9000"} 0
   minio_bucket_objects_size_distribution{bucket="mybucket",range="BETWEEN_128_MB_AND_512_MB",server="127.0.0.1:9000"} 0
   minio_bucket_objects_size_distribution{bucket="mybucket",range="BETWEEN_1_MB_AND_10_MB",server="127.0.0.1:9000"} 0
   minio_bucket_objects_size_distribution{bucket="mybucket",range="BETWEEN_256_KB_AND_512_KB",server="127.0.0.1:9000"} 0
   minio_bucket_objects_size_distribution{bucket="mybucket",range="BETWEEN_512_KB_AND_1_MB",server="127.0.0.1:9000"} 0
   minio_bucket_objects_size_distribution{bucket="mybucket",range="BETWEEN_64_KB_AND_256_KB",server="127.0.0.1:9000"} 0
   minio_bucket_objects_size_distribution{bucket="mybucket",range="BETWEEN_64_MB_AND_128_MB",server="127.0.0.1:9000"} 0
   minio_bucket_objects_size_distribution{bucket="mybucket",range="GREATER_THAN_512_MB",server="127.0.0.1:9000"} 0
   minio_bucket_objects_size_distribution{bucket="mybucket",range="LESS_THAN_1024_B",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_objects_version_distribution Distribution of object sizes in the bucket, includes label for the bucket name
   # TYPE minio_bucket_objects_version_distribution gauge
   minio_bucket_objects_version_distribution{bucket="mybucket",range="BETWEEN_1000_AND_10000",server="127.0.0.1:9000"} 0
   minio_bucket_objects_version_distribution{bucket="mybucket",range="BETWEEN_100_AND_1000",server="127.0.0.1:9000"} 0
   minio_bucket_objects_version_distribution{bucket="mybucket",range="BETWEEN_10_AND_100",server="127.0.0.1:9000"} 0
   minio_bucket_objects_version_distribution{bucket="mybucket",range="BETWEEN_2_AND_10",server="127.0.0.1:9000"} 0
   minio_bucket_objects_version_distribution{bucket="mybucket",range="GREATER_THAN_10000",server="127.0.0.1:9000"} 0
   minio_bucket_objects_version_distribution{bucket="mybucket",range="SINGLE_VERSION",server="127.0.0.1:9000"} 0
   minio_bucket_objects_version_distribution{bucket="mybucket",range="UNVERSIONED",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_proxied_delete_tagging_requests_failures Number of  failures in DELETE tagging proxy requests to replication target
   # TYPE minio_bucket_replication_proxied_delete_tagging_requests_failures counter
   minio_bucket_replication_proxied_delete_tagging_requests_failures{server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_proxied_delete_tagging_requests_total Number of DELETE tagging requests proxied to replication target
   # TYPE minio_bucket_replication_proxied_delete_tagging_requests_total counter
   minio_bucket_replication_proxied_delete_tagging_requests_total{bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_proxied_get_requests_failures Number of failures in GET requests proxied to replication target
   # TYPE minio_bucket_replication_proxied_get_requests_failures counter
   minio_bucket_replication_proxied_get_requests_failures{server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_proxied_get_requests_total Number of GET requests proxied to replication target
   # TYPE minio_bucket_replication_proxied_get_requests_total counter
   minio_bucket_replication_proxied_get_requests_total{bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_proxied_get_tagging_requests_failures Number of failures in GET tagging proxy requests to replication target
   # TYPE minio_bucket_replication_proxied_get_tagging_requests_failures counter
   minio_bucket_replication_proxied_get_tagging_requests_failures{server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_proxied_get_tagging_requests_total Number of GET tagging requests proxied to replication target
   # TYPE minio_bucket_replication_proxied_get_tagging_requests_total counter
   minio_bucket_replication_proxied_get_tagging_requests_total{bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_proxied_head_requests_failures Number of failures in HEAD requests proxied to replication target
   # TYPE minio_bucket_replication_proxied_head_requests_failures counter
   minio_bucket_replication_proxied_head_requests_failures{server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_proxied_head_requests_total Number of HEAD requests proxied to replication target
   # TYPE minio_bucket_replication_proxied_head_requests_total counter
   minio_bucket_replication_proxied_head_requests_total{bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_proxied_put_tagging_requests_failures Number of failures in PUT tagging proxy requests to replication target
   # TYPE minio_bucket_replication_proxied_put_tagging_requests_failures counter
   minio_bucket_replication_proxied_put_tagging_requests_failures{server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_proxied_put_tagging_requests_total Number of PUT tagging requests proxied to replication target
   # TYPE minio_bucket_replication_proxied_put_tagging_requests_total counter
   minio_bucket_replication_proxied_put_tagging_requests_total{bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_received_bytes Total number of bytes replicated to this bucket from another source bucket
   # TYPE minio_bucket_replication_received_bytes counter
   minio_bucket_replication_received_bytes{bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_replication_received_count Total number of objects received by this bucket from another source bucket
   # TYPE minio_bucket_replication_received_count gauge
   minio_bucket_replication_received_count{bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_requests_4xx_errors_total Total number of S3 requests with (4xx) errors on a bucket
   # TYPE minio_bucket_requests_4xx_errors_total counter
   minio_bucket_requests_4xx_errors_total{api="getbucketobjectlockconfig",bucket="mybucket",server="127.0.0.1:9000"} 1
   # HELP minio_bucket_requests_inflight_total Total number of S3 requests currently in flight on a bucket
   # TYPE minio_bucket_requests_inflight_total gauge
   minio_bucket_requests_inflight_total{api="getbucketlocation",bucket="mybucket",server="127.0.0.1:9000"} 0
   minio_bucket_requests_inflight_total{api="getbucketobjectlockconfig",bucket="mybucket",server="127.0.0.1:9000"} 0
   minio_bucket_requests_inflight_total{api="headbucket",bucket="mybucket",server="127.0.0.1:9000"} 0
   minio_bucket_requests_inflight_total{api="listobjectsv2",bucket="mybucket",server="127.0.0.1:9000"} 0
   minio_bucket_requests_inflight_total{api="putobject",bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_requests_total Total number of S3 requests on a bucket
   # TYPE minio_bucket_requests_total counter
   minio_bucket_requests_total{api="getbucketlocation",bucket="mybucket",server="127.0.0.1:9000"} 2
   minio_bucket_requests_total{api="getbucketobjectlockconfig",bucket="mybucket",server="127.0.0.1:9000"} 1
   minio_bucket_requests_total{api="headbucket",bucket="mybucket",server="127.0.0.1:9000"} 2
   minio_bucket_requests_total{api="listobjectsv2",bucket="mybucket",server="127.0.0.1:9000"} 1
   minio_bucket_requests_total{api="putobject",bucket="mybucket",server="127.0.0.1:9000"} 1
   # HELP minio_bucket_traffic_received_bytes Total number of S3 bytes received for this bucket
   # TYPE minio_bucket_traffic_received_bytes gauge
   minio_bucket_traffic_received_bytes{bucket="mybucket",server="127.0.0.1:9000"} 178
   # HELP minio_bucket_traffic_sent_bytes Total number of S3 bytes sent for this bucket
   # TYPE minio_bucket_traffic_sent_bytes gauge
   minio_bucket_traffic_sent_bytes{bucket="mybucket",server="127.0.0.1:9000"} 1232
   # HELP minio_bucket_usage_deletemarker_total Total number of delete markers
   # TYPE minio_bucket_usage_deletemarker_total gauge
   minio_bucket_usage_deletemarker_total{bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_usage_object_total Total number of objects
   # TYPE minio_bucket_usage_object_total gauge
   minio_bucket_usage_object_total{bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_usage_total_bytes Total bucket size in bytes
   # TYPE minio_bucket_usage_total_bytes gauge
   minio_bucket_usage_total_bytes{bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_bucket_usage_version_total Total number of versions (includes delete marker)
   # TYPE minio_bucket_usage_version_total gauge
   minio_bucket_usage_version_total{bucket="mybucket",server="127.0.0.1:9000"} 0
   # HELP minio_usage_last_activity_nano_seconds Time elapsed (in nano seconds) since last scan activity
   # TYPE minio_usage_last_activity_nano_seconds gauge
   minio_usage_last_activity_nano_seconds{server="127.0.0.1:9000"} 5.6046668864e+10
