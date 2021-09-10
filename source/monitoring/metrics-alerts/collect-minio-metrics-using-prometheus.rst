.. _minio-metrics-collect-using-prometheus:

======================================
Collect MinIO Metrics Using Prometheus
======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO leverages `Prometheus <https://prometheus.io/>`__ for metrics and alerts.
MinIO publishes Prometheus-compatible scraping endpoints for cluster and
node-level metrics. See :ref:`minio-metrics-and-alerts-endpoints` for more
information.

The procedure on this page documents scraping the MinIO metrics
endpoints using a Prometheus instance, including deploying and configuring
a simple Prometheus server for collecting metrics. 

This procedure is not a replacement for the official
:prometheus-docs:`Prometheus Documentation <>`. Any specific guidance
related to configuring, deploying, and using Prometheus is made on a best-effort
basis.

Requirements
------------

Install and Configure ``mc`` with Access to the MinIO Cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses :mc:`mc` for performing operations on the MinIO
deployment. Install ``mc`` on a machine with network access to the
deployment. See the ``mc`` :ref:`Installation Quickstart <mc-install>` for
more complete instructions.

Prometheus Service
~~~~~~~~~~~~~~~~~~

This procedure provides instruction for deploying Prometheus for rapid local
evaluation and development. All other environments should have an existing
Prometheus or Prometheus-compatible service with access to the MinIO cluster. 

Procedure
---------

1) Generate the Bearer Token
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO by default requires authentication for requests made to the metrics
endpoints. While step is not required for MinIO deployments started with 
:envvar:`MINIO_PROMETHEUS_AUTH_TYPE` set to ``"public"``, you can still use the
command output for retrieving a Prometheus ``scrape_configs`` entry.

Use the :mc-cmd:`mc admin prometheus generate` command to generate a
JWT bearer token for use by Prometheus in making authenticated scraping
requests:

.. code-block:: shell
   :class: copyable

   mc admin prometheus generate ALIAS

Replace :mc-cmd:`ALIAS <mc admin prometheus generate TARGET>` with the
:mc:`alias <mc alias>` of the MinIO deployment.

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

The ``targets`` array can contain the hostname for any node in the deployment.
For clusters with a load balancer managing connections between MinIO nodes,
specify the address of the load balancer.

Specify the output block to the 
:prometheus-docs:`scrape_config 
<prometheus/latest/configuration/configuration/#scrape_config>` section of
the Prometheus configuration. 

2) Configure and Run Prometheus
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Follow the Prometheus :prometheus-docs:`Getting Started 
<prometheus/latest/getting_started/#downloading-and-running-prometheus>` guide
to download and run Prometheus locally.

Append the ``scrape_configs`` job generated in the previous step to the
configuration file:

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

Prometheus includes a 
:prometheus-docs:`expression browser 
<prometheus/latest/getting_started/#using-the-expression-browser>`. You can
execute queries here to analyze the collected metrics.

The following query examples return metrics collected by Prometheus:

.. code-block:: shell
   :class: copyable

   minio_cluster_disk_online_total{job="minio-job"}[5m]
   minio_cluster_disk_offline_total{job="minio-job"}[5m]
   
   minio_bucket_usage_object_total{job="minio-job"}[5m]

   minio_cluster_capacity_usable_free_bytes{job="minio-job"}[5m]

See :ref:`minio-metrics-and-alerts-available-metrics` for a complete
list of published metrics.

4) Visualize Collected Metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :minio-git:`MinIO Console <console>` supports visualizing collected metrics
from Prometheus. Specify the URL of the Prometheus service to the
:envvar:`MINIO_PROMETHEUS_URL` environment variable to each MinIO server
in the deployment:

.. code-block:: shell
   :class: copyable

   export MINIO_PROMETHEUS_URL="https://prometheus.example.net"

If you set a custom ``job_name`` for the Prometheus scraping job, you must also
set :envvar:`MINIO_PROMETHEUS_JOB_ID` to match that job name.

Restart the deployment using :mc-cmd:`mc admin service restart` to apply the
changes.

The MinIO Console uses the metrics collected by the ``minio-job`` scraping
job to populate the Dashboard metrics:

.. image:: /images/minio-console-dashboard.png
   :width: 600px
   :alt: MinIO Console Dashboard displaying Monitoring Data
   :align: center

MinIO also publishes a `Grafana Dashboard
<https://grafana.com/grafana/dashboards/13502>`_ for visualizing collected
metrics. For more complete documentation on configuring a Prometheus data source
for Grafana, see :prometheus-docs:`Grafana Support for Prometheus
<visualization/grafana/>`.

Prometheus includes a :prometheus-docs:`graphing interface
<prometheus/latest/getting_started/#using-the-graphing-interface>` for
visualizing collected metrics. 
