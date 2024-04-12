.. _minio-concepts-scanner:

==============
Object Scanner
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------


MinIO uses the built-in scanner to actively check objects and to take any scheduled actions.
Such actions may include:

- calculating data usage on drives
- applying configured :ref:`lifecycle management rules <minio-lifecycle-management>`
- checking objects for missing or corrupted data or parity shards and performing healing

Scanner performance typically depends on the available node resources, the size of the cluster, and the complexity of bucket hierarchy (objects and prefixes).
For example, a cluster that starts with 100TB of data that then grows to 200TB of data may require more time to scan the entire namespace of buckets and objects given the same hardware and workload.
As the cluster or workload increases, scanner performance decreases as it yields more frequently to ensure priority of normal S3 operations.

.. include:: /includes/common/scanner.rst
   :start-after: start-scanner-speed-config
   :end-before: end-scanner-speed-config

Consider regularly checking cluster metrics, capacity, and resource usage to ensure the cluster hardware is scaling alongside cluster and workload growth:

- :ref:`minio-metrics-and-alerts`



Scanner Metrics
---------------