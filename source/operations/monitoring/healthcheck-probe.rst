.. _minio-healthcheck-api:

===============
Healthcheck API
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO exposes unauthenticated endpoints for probing node uptime and cluster
:ref:`high availability <minio-ec-parity>` for simple healthchecks. These
endpoints return an HTTP status code indicating whether the underlying
resource is healthy or satisfies read/write quorum. MinIO exposes no other data
through these endpoints.

Node Liveness
-------------

Use the following endpoint to test if a MinIO server is online:

.. code-block:: shell
   :class: copyable

   curl -I https://minio.example.net:9000/minio/health/live

Replace ``https://minio.example.net:9000`` with the DNS hostname of the
MinIO server to check.

A response code of ``200 OK`` indicates the MinIO server is 
online and functional. Any other HTTP codes indicate an issue with reaching
the server, such as a transient network issue or potential downtime.

The healthcheck probe alone cannot determine if a MinIO server is offline - only that the current host machine cannot reach the server.
Consider configuring a Prometheus :ref:`alert <minio-metrics-and-alerts>` using the :ref:`metrics v3 <minio-metrics-and-alerts>` ``minio_cluster_health_nodes_offline_count`` or :ref:`v2 <minio-metrics-v2>` ``minio_cluster_nodes_offline_total`` metrics to detect whether one or more MinIO nodes are offline.

.. _minio-cluster-write-quorum:

Cluster Write Quorum
--------------------

Use the following endpoint to test if a MinIO cluster has 
:ref:`write quorum <minio-ec-parity>`:

.. code-block:: shell
   :class: copyable

   curl -I https://minio.example.net:9000/minio/health/cluster

Replace ``https://minio.example.net:9000`` with the DNS hostname of a node
in the MinIO cluster to check. For clusters using a load balancer to manage
incoming connections, specify the hostname for the load balancer.

A response code of ``200 OK`` indicates that the MinIO cluster has
sufficient MinIO servers online to meet write quorum. A response code of
``503 Service Unavailable`` indicates the cluster does not currently have
write quorum.

The healthcheck probe alone cannot determine if a MinIO server is offline or
processing write operations normally - only whether enough MinIO servers are
online to meet write quorum  requirements based on the configured 
:ref:`erasure code parity <minio-ec-parity>`. Consider configuring a Prometheus
:ref:`alert <minio-metrics-and-alerts>` using one of the following
metrics to detect potential issues or errors on the MinIO cluster:

- ``minio_cluster_nodes_offline_total`` to alert if one or more
  MinIO nodes are offline.

- ``minio_node_drive_free_bytes`` to alert if the cluster is running
  low on free drive space.

Cluster Read Quorum
--------------------

Use the following endpoint to test if a MinIO cluster has 
:ref:`read quorum <minio-ec-parity>`:

.. code-block:: shell
   :class: copyable

   curl -I https://minio.example.net:9000/minio/health/cluster/read

Replace ``https://minio.example.net:9000`` with the DNS hostname of a node
in the MinIO cluster to check. For clusters using a load balancer to manage
incoming connections, specify the hostname for the load balancer.

A response code of ``200 OK`` indicates that the MinIO cluster has
sufficient MinIO servers online to meet read quorum. A response code of
``503 Service Unavailable`` indicates the cluster does not currently have
read quorum.

The healthcheck probe alone cannot determine if a MinIO server is offline or
processing read operations normally - only whether enough MinIO servers are
online to meet read quorum requirements based on the configured 
:ref:`erasure code parity <minio-ec-parity>`. Consider configuring a Prometheus
:ref:`alert <minio-metrics-and-alerts>` using the
``minio_cluster_nodes_offline_total`` metric to detect whether one or more
MinIO nodes are offline.

Cluster Maintenance Check
-------------------------

Use the following endpoint to test if the MinIO cluster can maintain
both :ref:`read <minio-ec-parity>` and :ref:`write <minio-ec-parity>`
if the specified MinIO server is taken down for maintenance:

.. code-block:: shell
   :class: copyable

   curl -I https://minio.example.net:9000/minio/health/cluster?maintenance=true

Replace ``https://minio.example.net:9000`` with the DNS hostname of a node
in the MinIO cluster to check. For clusters using a load balancer to manage
incoming connections, specify the hostname for the load balancer.

A response code of ``200 OK`` indicates that the MinIO cluster has
sufficient MinIO servers online to meet write quorum. A response code of
``412 Precondition Failed`` indicates the cluster will lose quorum if the
MinIO server goes offline.

The healthcheck probe alone cannot determine if a MinIO server is offline - only
whether enough MinIO servers will be online after taking the node down for
maintenance to meet read and write quorum requirements based on the configured
:ref:`erasure code parity <minio-ec-parity>`. Consider configuring a Prometheus
:ref:`alert <minio-metrics-and-alerts>` using the ``minio_cluster_nodes_offline_total`` metric to detect whether one or more
MinIO nodes are offline.
