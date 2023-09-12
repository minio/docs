.. _minio-grafana:

===================================
Monitor a MinIO Server with Grafana 
===================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2
   
`Grafana <https://grafana.com/>`__ allows you to query, visualize, alert on and understand your metrics no matter where they are stored. 
Create, explore, and share dashboards with your team and foster a data driven culture.

Prerequisites
-------------

- An existing :prometheus-docs:`Prometheus deployment <prometheus/latest/installation/>` with backing :prometheus-docs:`Alert Manager <alerting/latest/overview/>`
- An existing MinIO deployment with network access to the Prometheus deployment
- `Grafana installed <https://grafana.com/grafana/download>`__

MinIO Grafana Dashboard
-----------------------

MinIO provides two official Grafana Dashboards you can download from the Grafana Dashboard portal.

1. :ref:`MinIO Server metrics <minio-server-grafana-metrics>`
2. :ref:`MinIO Bucket metrics <minio-buckets-grafana-metrics>`

To track changes to the Grafana dashboard, introspect the JSON files for the `server <https://github.com/minio/minio/blob/master/docs/metrics/prometheus/grafana/minio-dashboard.json>`__ or `bucket <https://github.com/minio/minio/blob/master/docs/metrics/prometheus/grafana/minio-bucket.json>`__ dashboards in the MinIO Server GitHub repository.

.. _minio-server-grafana-metrics:

MinIO Server Metrics Dashboard
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Visualize MinIO metrics with the official MinIO Grafana dashboard for the MinIO Server available on the `Grafana dashboard portal <https://grafana.com/grafana/dashboards/13502-minio-dashboard/>`__.

MinIO provides a Grafana Dashboard for MinIO Server metrics.
For specifics on the dashboard's configuration, see the `JSON file on GitHub <https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/grafana/minio-dashboard.json>`__.

.. image:: /images/grafana-minio.png
   :width: 600px
   :alt: A sample of the MinIO Grafana dashboard showing many different captured metrics on a MinIO Server.
   :align: center

.. _minio-buckets-grafana-metrics:

MinIO Bucket Metrics Dashboard
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Visualize MinIO bucket metrics with the official MinIO Grafana dashboard for buckets available on the `Grafana dashboard portal <https://grafana.com/grafana/dashboards/19237-minio-bucket-dashboard/>`__.

Bucket metrics can be viewed in the Grafana dashboard using the `bucket JSON file on GitHub <https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/grafana/minio-bucket.json>`__.

.. image:: /images/grafana-bucket.png
   :width: 600px
   :alt: A sample of the MinIO Grafana dashboard showing many different captured metrics for MinIO buckets.
   :align: center

.. _minio-buckets-grafana-metrics:

MinIO Cluster Replication Metrics Dashboard
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Visualize MinIO bucket metrics with the official MinIO Grafana dashboard for cluster replication available on the `Grafana dashboard portal <https://grafana.com/grafana/dashboards/15305-minio-cluster-replication-dashboard/>`__.

Cluster replication metrics can be viewed in the Grafana dashboard using the `cluster replication JSON file on GitHub <https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/grafana/minio-replication.json>`__.

.. image:: /images/grafana-replication.png
   :width: 600px
   :alt: A sample of the MinIO Grafana dashboard showing many different captured metrics for cluster replication.
   :align: center
