.. _minio-metrics-influxdb:

======================================
Monitoring and Alerting using InfluxDB
======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO publishes cluster and node metrics using the :prometheus-docs:`Prometheus Data Model <concepts/data_model/>`.
`InfluxDB <https://www.influxdata.com/?ref=minio>`__ supports scraping MinIO metrics data for monitoring and alerting.

The procedure on this page documents the following:

- Configuring an InfluxDB service to scrape and display metrics from a MinIO deployment
- Configuring an Alert on a MinIO metric 

.. admonition:: Prerequisites
   :class: note

   This procedure requires the following:

   - An existing InfluxDB deployment configured with one or more :influxdb-docs:`notification endpoints <notification-endpoints/>`
   - An existing MinIO deployment with network access to the InfluxDB deployment
   - An :mc:`mc` installation on your local host configured to :ref:`access <alias>` the MinIO deployment

   These instructions use :ref:`version 2 metrics. <minio-metrics-v2>`
   For more about metrics API versions, see :ref:`Metrics and alerts. <minio-metrics-and-alerts>`

.. cond:: k8s

   This procedure assumes all necessary network control components, such as Ingress or Load Balancers, to facilitate access between the MinIO Tenant and the InfluxDB service.

Configure InfluxDB to Collect and Alert using MinIO Metrics
-----------------------------------------------------------

.. important::

   This procedure specifically uses the InfluxDB UI to create a scraping endpoint. 
   
   The InfluxDB UI does not provide the same level of configuration as using `Telegraf <https://docs.influxdata.com/telegraf/v1.24/>`__ and the corresponding `Prometheus plugin <https://github.com/influxdata/telegraf/blob/release-1.24/plugins/inputs/prometheus/README.md>`__.
   Specifically:

   - You cannot enable authenticated access to the MinIO metrics endpoint via the InfluxDB UI
   - You cannot set a tag for collected metrics (e.g. ``url_tag``) for uniquely identifying the metrics for a given MinIO deployment

   .. cond:: k8s

      The Telegraf Prometheus plugin also supports Kubernetes-specific features, such as scraping the ``minio`` service for a given MinIO Tenant.

   Configuring Telegraf is out of scope for this procedure. 
   You can use this procedure as general guidance for configuring Telegraf to scrape MinIO metrics.

.. container:: procedure

   1. Configure Public Access to MinIO Metrics

      Set the :envvar:`MINIO_PROMETHEUS_AUTH_TYPE` environment variable to ``"public"`` for all nodes in the MinIO deployment.
      You can then restart the deployment to allow public access to MinIO metrics.

      You can validate the change by attempting to ``curl`` the metrics endpoint:

      .. code-block:: shell
         :class: copyable

         curl https://HOSTNAME/minio/v2/metrics/cluster

      Replace ``HOSTNAME`` with the URL of the load balancer or reverse proxy through which you access the MinIO deployment.
      You can alternatively specify any single node as ``HOSTNAME:PORT``, specifying the MinIO server API port in addition to the node hostname.

      The response body should include a list of collected MinIO metrics.

   #. Log into the InfluxDB UI and Create a Bucket

      Select the :influxdb-docs:`Organization <organizations/view-orgs/>` under which you want to store MinIO metrics.

      Create a :influxdb-docs:`New Bucket <organizations/buckets/create-bucket/>` in which to store metrics for the MinIO deployment.

   #. Create a new Scraping Source

      Create a :influxdb-docs:`new InfluxDB Scraper <write-data/no-code/scrape-data/manage-scrapers/create-a-scraper/>`.

      Specify the full URL to the MinIO deployment, including the metrics endpoint:

      .. code-block:: shell
         :class: copyable

         https://HOSTNAME/minio/v2/metrics/cluster

      Replace ``HOSTNAME`` with the URL of the load balancer or reverse proxy through which you access the MinIO deployment.
      You can alternatively specify any single node as ``HOSTNAME:PORT``, specifying the MinIO server API port in addition to the node hostname.

   #. Validate the Data

      Use the :influxdb-docs:`DataExplorer <query-data/execute-queries/data-explorer/>` to visualize the collected MinIO data.

      For example, you can set a filter on ``minio_cluster_capacity_usable_total_bytes`` and ``minio_cluster_capacity_usable_free_bytes`` to compare the total usable against total free space on the MinIO deployment.

   #. Configure a Check

      Create a :influxdb-docs:`new Check <https://docs.influxdata.com/influxdb/v2.4/monitor-alert/checks/create/>` on a MinIO metric.

      The following example check rules provide a baseline of alerts for a MinIO deployment.
      You can modify or otherwise use these examples for guidance in building your own checks.

      - Create a :guilabel:`Threshold Check` named ``MINIO_NODE_DOWN``. 
      
        Set the filter for the ``minio_cluster_nodes_offline_total`` key.
        
        Set the :guilabel:`Thresholds` to :guilabel:`WARN` when the value is greater than :guilabel:`1`

      - Create a :guilabel:`Threshold Check` named ``MINIO_QUORUM_WARNING``.

        Set the filter for the ``minio_cluster_drive_offline_total`` key.

        Set the :guilabel:`Thresholds` to :guilabel:`CRITICAL` when the value is one less than your configured :ref:`Erasure Code Parity <minio-erasure-coding>` setting.

        For example, a deployment using EC:4 should set this value to ``3``.

      Configure your :influxdb-docs:`Notification endpoints <monitor-alert/notification-endpoints/>` and :influxdb-docs:`Notification rules <monitor-alert/notification-rules/>` such that checks of each type trigger an appropriate response.

