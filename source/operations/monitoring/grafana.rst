.. _minio-grafana:

===================================
Monitor a MinIO Server with Grafana 
===================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2
   
`Grafana <https://grafana.com/>`__ allows you to query, visualize, alert on and understand your metrics no matter where they are stored. 

Prerequisites
-------------

- An existing :prometheus-docs:`Prometheus deployment <prometheus/latest/installation/>` with backing :prometheus-docs:`Alert Manager <alerting/latest/overview/>`
- An existing MinIO deployment with network access to the Prometheus deployment
- `Grafana installed <https://grafana.com/grafana/download>`__

.. admonition:: Grafana dashboards use metrics version 2
   :class: note

   The MinIO Grafana dashboards use :ref:`metrics version 2 <minio-metrics-v2>`.
   For more about metrics API versions, see :ref:`Metrics and alerts. <minio-metrics-and-alerts>`

   Version 3 metrics require creating your own dashboard.
   For more information about dashboards, see `the Grafana documentation. <https://grafana.com/docs/grafana/latest/dashboards/>`__

MinIO Grafana Dashboard
-----------------------

MinIO provides several official Grafana Dashboards you can download from the Grafana Dashboard portal.

1. :ref:`MinIO Server metrics <minio-server-grafana-metrics>`
2. :ref:`MinIO Bucket metrics <minio-buckets-grafana-metrics>`
3. :ref:`MinIO Replication metrics <minio-replication-grafana-metrics>`

To track changes to the Grafana dashboard, introspect the JSON files for the `server <https://github.com/minio/minio/blob/master/docs/metrics/prometheus/grafana/minio-dashboard.json>`__ or `bucket <https://github.com/minio/minio/blob/master/docs/metrics/prometheus/grafana/minio-bucket.json>`__ dashboards in the MinIO Server GitHub repository.

.. _minio-server-grafana-metrics:

MinIO Server Metrics Dashboard
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Visualize MinIO metrics with the official MinIO Grafana dashboard for the MinIO Server available on the `Grafana dashboard portal <https://grafana.com/grafana/dashboards/13502-minio-dashboard/>`__.

MinIO provides a Grafana Dashboard for MinIO Server metrics.
For specifics on the dashboard's configuration, see the `JSON file on GitHub <https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/grafana/minio-dashboard.json>`__.

For MinIO Deployments running with :ref:`Server-Side Encryption <minio-sse-data-encryption>` (SSE-KMS or SSE-S3), the dashboard includes metrics for the KMS.
These metrics include status, request error rates, and request success rates.

.. image:: /images/grafana-minio.png
   :width: 600px
   :alt: A sample of the MinIO Grafana dashboard showing many different captured metrics on a MinIO Server.
   :align: center

.. _minio-buckets-grafana-metrics:

MinIO Bucket Metrics Dashboard
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Visualize MinIO bucket metrics with the official MinIO Grafana dashboard for buckets available on the `Grafana dashboard portal <https://grafana.com/grafana/dashboards/19237-minio-bucket-dashboard/>`__.

Bucket metrics can be viewed in the Grafana dashboard using the `bucket JSON file on GitHub <https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/grafana/bucket/minio-bucket.json>`__.

.. image:: /images/grafana-bucket.png
   :width: 600px
   :alt: A sample of the MinIO Grafana dashboard showing many different captured metrics for MinIO buckets.
   :align: center

.. _minio-node-grafana-metrics:

MinIO Node Metrics Dashboard
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Node metrics can be viewed in the Grafana dashboard using the `node JSON file on GitHub <https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/grafana/node/minio-node.json>`__.

.. image:: /images/grafana-node.png
   :width: 600px
   :alt: A sample of the MinIO Grafana dashboard showing many different captured metrics for MinIO nodes.
   :align: center


.. _minio-replication-grafana-metrics:

MinIO Replication Metrics Dashboard
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Visualize MinIO bucket metrics with the official MinIO Grafana dashboard for replication available on the `Grafana dashboard portal <https://grafana.com/grafana/dashboards/15305-minio-replication-dashboard/>`__.

Cluster replication metrics can be viewed in the Grafana dashboard using the `cluster replication JSON file on GitHub <https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/grafana/replication/minio-replication-cluster.json>`__.

.. image:: /images/grafana-replication.png
   :width: 600px
   :alt: A sample of the MinIO Grafana dashboard showing many different captured metrics for replication.
   :align: center
