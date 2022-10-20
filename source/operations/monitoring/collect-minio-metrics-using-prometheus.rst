.. _minio-metrics-collect-using-prometheus:

========================================
Monitoring and Alerting using Prometheus
========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO publishes cluster and node metrics using the :prometheus-docs:`Prometheus Data Model <data_model/>`.
The procedure on this page documents the following:

- Configuring a Prometheus service to scrape and display metrics from a MinIO deployment
- Configuring an Alert Rule on a MinIO Metric to trigger an AlertManager action

.. admonition:: Prerequisites
   :class: note

   This procedure requires the following:

   - An existing Prometheus deployment with backing :prometheus-docs:`Alert Manager <alerting/latest/overview/>`

   - An existing MinIO deployment with network access to the Prometheus deployment

   - An :mc:`mc` installation on your local host configured to :ref:`access <alias>` the MinIO deployment

.. cond:: k8s

   The MinIO Operator supports deploying a :ref:`per-tenant Prometheus instance <create-tenant-configure-section>` configured to support metrics and visualizations.
   This includes automatically configuring the Tenant to enable the :ref:`Tenant Console historical metric view <minio-console-metrics>`.

   You can still use this procedure to configure an external Prometheus service for supporting monitoring and alerting for a MinIO Tenant.
   You must configure all necessary network control components, such as Ingress or a Load Balancer, to facilitate access between the Tenant and the Prometheus service.
   This procedure assumes your local host machine can access the Tenant via :mc:`mc`.

Configure Prometheus to Collect and Alert using MinIO Metrics
-------------------------------------------------------------

1) Generate the Scrape Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin prometheus generate` command to generate the scrape configuration for use by Prometheus in making scraping requests:

.. code-block:: shell
   :class: copyable

   mc admin prometheus generate ALIAS

Replace :mc-cmd:`ALIAS <mc admin prometheus generate TARGET>` with the :mc:`alias <mc alias>` of the MinIO deployment.

The command returns output similar to the following:

.. code-block:: yaml
   :class: copyable

   scrape_configs:
   - job_name: minio-job 
     bearer_token: TOKEN
     metrics_path: /minio/v2/metrics/cluster
     scheme: https
     static_configs:
     - targets: [minio.example.net]

- Set the ``job_name`` to a value associated to the MinIO deployment.

  Use a unique value to ensure isolation of the deployment metrics from any others collected by that Prometheus service.

- MinIO deployments started with :envvar:`MINIO_PROMETHEUS_AUTH_TYPE` set to ``"public"`` can omit the ``bearer_token`` field.

- Set the ``scheme`` to http for MinIO deployments not using TLS.

- Set the ``targets`` array with a hostname that resolves to the MinIO deployment.

  This can be any single node, or a load balancer/proxy which handles connections to the MinIO nodes.

2) Restart Prometheus with the Updated Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Append the ``scrape_configs`` job generated in the previous step to the configuration file:

.. code-block:: yaml
   :class: copyable

   global:
      scrape_interval: 15s
   
   scrape_configs:
      - job_name: minio-job
        bearer_token: TOKEN
        metrics_path: /minio/v2/metrics/cluster
        scheme: https
        static_configs:
        - targets: [minio.example.net]

Start the Prometheus cluster using the configuration file:

.. code-block:: shell
   :class: copyable

   prometheus --config.file=prometheus.yaml

3) Analyze Collected Metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Prometheus includes a :prometheus-docs:`expression browser <prometheus/latest/getting_started/#using-the-expression-browser>`. 
You can execute queries here to analyze the collected metrics.

The following query examples return metrics collected by Prometheus:

.. code-block:: shell
   :class: copyable

   minio_cluster_disk_online_total{job="minio-job"}[5m]
   minio_cluster_disk_offline_total{job="minio-job"}[5m]
   
   minio_bucket_usage_object_total{job="minio-job"}[5m]

   minio_cluster_capacity_usable_free_bytes{job="minio-job"}[5m]

See :ref:`minio-metrics-and-alerts-available-metrics` for a complete list of published metrics.

4) Configure an Alert Rule using MinIO Metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must configure :prometheus-docs:`Alert Rules <prometheus/latest/configuration/alerting_rules/>` on the Prometheus deployment to trigger alerts based on collected MinIO metrics.

The following example alert rule files provide a baseline of alerts for a MinIO deployment.
You can modify or otherwise use these examples as guidance in building your own alerts.

.. code-block:: yaml
   :class: copyable

   groups:
   - name: minio-alerts
     rules:
     - alert: NodesOffline
       expr: avg_over_time(minio_cluster_nodes_offline_total{job="minio-job"}[5m]) > 0
       for: 10m
       labels:
         severity: warn
       annotations:
         summary: "Node down in MinIO deployment"
         description: "Node(s) in cluster {{ $labels.instance }} offline for more than 5 minutes"

     - alert: DisksOffline
       expr: avg_over_time(minio_cluster_disk_offline_total{job="minio-job"}[5m]) > 0
       for: 10m
       labels:
         severity: warn
       annotations:
         summary: "Disks down in MinIO deployment"
         description: "Disks(s) in cluster {{ $labels.instance }} offline for more than 5 minutes"

Specify the path to the alert file to the Prometheus configuration as part of the ``rule_files`` key:

.. code-block:: yaml

   global:
     scrape_interval: 5s

   rule_files:
   - minio-alerting.yml

Once triggered, Prometheus sends the alert to the configured AlertManager service.

5) (Optional) Configure MinIO Console to Query Prometheus
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Console also supports displaying time-series and historical data by querying a :prometheus-docs:`Prometheus <prometheus/latest/getting_started/>` service configured to scrape data from the MinIO deployment. 

.. image:: /images/minio-console/console-metrics.png
   :width: 600px
   :alt: MinIO Console displaying Prometheus-backed Monitoring Data
   :align: center

To enable historical data visualization in MinIO Console, set the following environment variables on each node in the MinIO deployment:

- Set :envvar:`MINIO_PROMETHEUS_URL` to the URL of the Prometheus service
- Set :envvar:`MINIO_PROMETHEUS_JOB_ID` to the unique job ID assigned to the collected metrics

Restart the MinIO deployment and visit the :ref:`Monitoring <minio-console-monitoring>` pane to see the historical data views.
