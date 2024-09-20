.. _minio-metrics-collect-using-prometheus:

========================================
Monitoring and alerting using Prometheus
========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. container:: extlinks-video

   - `Monitoring with MinIO and Prometheus: Overview <https://youtu.be/A3vCDaFWNNs?ref=docs>`__
   - `Monitoring with MinIO and Prometheus: Lab <https://youtu.be/Oix9iXndSUY?ref=docs>`__

MinIO publishes metrics using the :prometheus-docs:`Prometheus Data Model <concepts/data_model/#data-model>`.
The procedure on this page documents the following:

- Configure a Prometheus service to scrape and display metrics from a MinIO deployment
- Configure an Alert Rule on a MinIO Metric to trigger an AlertManager action

.. admonition:: Prerequisites
   :class: note

   This procedure requires the following:

   - An existing :prometheus-docs:`Prometheus deployment <prometheus/latest/installation/>` with backing :prometheus-docs:`Alert Manager <alerting/latest/overview/>`

   - An existing MinIO deployment with network access to the Prometheus deployment

   - An :mc:`mc` installation on your local host configured to :ref:`access <alias>` the MinIO deployment

.. admonition:: Metrics Version 2 Deprecated
   :class: note

   Starting with MinIO Server :minio-release:`RELEASE.2024-07-15T19-02-30Z` and MinIO Client :mc-release:`RELEASE.2024-07-11T18-01-28Z`, metrics version 3 replaces the deprecated :ref:`metrics version 2 <minio-metrics-v2>`.


Collect and alert on metrics
----------------------------

Generate the scrape configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin prometheus generate --api-version v3 <mc admin prometheus generate --api-version>` to generate a scrape configuration for each :ref:`type of metric <minio-metrics-and-alerts-available-metrics>` you want to scrape with Prometheus.

For example, the following command scrapes all version 3 audit metrics for the MinIO cluster:

.. code-block:: shell
   :class: copyable

   mc admin prometheus generate ALIAS audit --api-version v3

Replace :mc-cmd:`ALIAS <mc admin prometheus generate ALIAS>` with the :mc:`alias <mc alias>` of the MinIO deployment.

The command returns output similar to the following:

.. code-block:: yaml
   :class: copyable

   scrape_configs:
   - job_name: minio-job
     bearer_token: TOKEN
     metrics_path: /minio/metrics/v3
     scheme: https
     static_configs:
     - targets: [minio.example.net]

To scrape multiple types of metrics, run :mc-cmd:`mc admin prometheus generate --api-version v3 <mc admin prometheus generate --api-version>` for each type and add the ``job_name`` section to the ``scrape_configs`` in your Prometheus configuration.

The following example scrapes audit and system metrics every 60 seconds:

.. code-block:: yaml
   :class: copyable

   global:
     scrape_interval: 60s

   scrape_configs:
   - job_name: minio-job-audit
     bearer_token: TOKEN
     metrics_path: /minio/metrics/v3/audit
     scheme: https
     static_configs:
     - targets: [minio.example.net]

   - job_name: minio-job-system
     bearer_token: TOKEN
     metrics_path: /minio/metrics/v3/system
     scheme: https
     static_configs:
     - targets: [minio.example.net]

If needed, edit the generated configuration for your environment.
Common changes include:

- Set an appropriate ``scrape_interval`` value to ensure each scraping operation completes before the next one begins.
  The recommended value is 60 seconds.

  Some deployments require a longer scrape interval due to the number of metrics being scraped.
  To reduce the load on your MinIO and Prometheus servers, choose the longest interval that meets your monitoring requirements.

  You can specify a ``scrape_interval`` for each job in its ``job_name`` section, or all jobs in a separate ``global`` section.

- Set the ``job_name`` to a value associated to the MinIO deployment.

  Use a unique value for each job to ensure isolation of the deployment metrics from any others collected by that Prometheus service.

- MinIO deployments started with :envvar:`MINIO_PROMETHEUS_AUTH_TYPE` set to ``"public"`` can omit the ``bearer_token`` field.

- Set the ``scheme`` to http for MinIO deployments not using TLS.

- Set the ``targets`` array with a hostname that resolves to the MinIO deployment.

  This can be any single node, or a load balancer/proxy which handles connections to the MinIO nodes.

  .. cond:: k8s

     For Prometheus deployments in the same cluster as the MinIO Tenant, you can specify the service DNS name for the ``minio`` service.

     For Prometheus deployments external to the cluster, you must specify an ingress or load balancer endpoint configured to route connections to and from the MinIO Tenant.

Restart Prometheus with the updated configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Add the desired ``scrape_configs`` jobs to your Prometheus configuration file and start the Prometheus cluster:

.. code-block:: shell
   :class: copyable

   prometheus --config.file=prometheus.yaml


Analyze collected metrics
~~~~~~~~~~~~~~~~~~~~~~~~~

Prometheus includes an :prometheus-docs:`expression browser <prometheus/latest/getting_started/#using-the-expression-browser>`. 
You can execute queries here to analyze the collected metrics.

The following query examples return metrics collected by Prometheus every five minutes for a scrape job named ``minio-job``:

.. code-block:: shell
   :class: copyable

   minio_system_drive_used_bytes{job-"minio-job"}[5m]
   minio_system_drive_used_inodes{job-"minio-job"}[5m]

   minio_cluster_usage_buckets_total_bytes{job-"minio-job"}[5m]
   minio_cluster_usage_buckets_objects_count{job-"minio-job"}[5m]

   minio_api_requests_total{job-"minio-job"}[5m]
   minio_api_requests_errors_total{job-"minio-job"}[5m]


Configure an alert rule
~~~~~~~~~~~~~~~~~~~~~~~

To trigger alerts based on metrics, configure :prometheus-docs:`Alert Rules <prometheus/latest/configuration/alerting_rules/>` on the Prometheus deployment.

The following example alert provides a baseline of alerts for a MinIO deployment.
You can modify or use these examples as guidance for building your own alerts.

.. code-block:: yaml
   :class: copyable

   groups:
   - name: minio-alerts
     rules:
     - alert: NodesOffline
       expr: avg_over_time(minio_cluster_health_nodes_offline_count{job="minio-job"}[5m]) > 0
       for: 10m
       labels:
         severity: warn
       annotations:
         summary: "Node down in MinIO deployment"
         description: "Node(s) in cluster {{ $labels.instance }} offline for more than 5 minutes"

     - alert: DisksOffline
       expr: avg_over_time(minio_system_drive_offline_count{job="minio-job"}[5m]) > 0
       for: 10m
       labels:
         severity: warn
       annotations:
         summary: "Disks down in MinIO deployment"
         description: "Disks(s) in cluster {{ $labels.instance }} offline for more than 5 minutes"

In the Prometheus configuration, specify the path to the alert file in the ``rule_files`` key:

.. code-block:: yaml

   rule_files:
   - minio-alerting.yml

Once triggered, Prometheus sends the alert to the configured AlertManager service.
