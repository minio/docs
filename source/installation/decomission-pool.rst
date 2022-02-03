.. _minio-decommissioning:

==========================
Decommission a Server Pool
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Starting with RELEASE, MinIO supports decommissioning and removing a
:ref:`server pools <minio-intro-server-pool>` from a deployment. Decommissioning
is designed for removing an older server pool whose hardware is no longer
sufficient or performant compared to the pools in the deployment. MinIO
automatically migrates data from the decommissioned pool to the remaining pools
in the deployment based on the ratio of free space available in each pool.

A decommissioned pool can *only* service read operations (e.g. ``GET``,
``LIST``, ``HEAD``). MinIO routes all write operations to the remaining
"active" pools in the deployment. Versioned objects maintain their ordering
throughout the migration process.

The procedure on this page decommissions and removes a server pool from
a :ref:`distributed <deploy-minio-distributed>` MinIO deployment with
*at least* two server pools.

.. admonition:: Decommissioning is Permanent
   :class: important

   Once MinIO begins decommissioning a pool, it marks that pool as *permanently*
   inactive ("draining"). Cancelling or otherwise interrupting the 
   decommissioning procedure does **not** restore the pool to an active
   state. 

   Decommissioning is a major administrative operation that requires care
   in planning and execution, and is not a trivial or 'daily' task. 

   `MinIO SUBNET <https://min.io/pricing?jmp=docs>`__ users can
   `log in <https://subnet.min.io/>`__ and create a new issue related to
   decommissioning. Coordination with MinIO Engineering via SUBNET can ensure
   successful decommissioning, including performance testing and health
   diagnostics.

   Community users can seek support on the `MinIO Community Slack
   <https://minio.slack.com>`__. Community Support is best-effort only and has
   no SLAs around responsiveness.

.. _minio-decommissioning-prereqs:

Prerequisites
-------------

Networking and Firewalls
~~~~~~~~~~~~~~~~~~~~~~~~

Each node should have full bidirectional network access to every other node in
the deployment. For containerized or orchestrated infrastructures, this may
require specific configuration of networking and routing components such as
ingress or load balancers. Certain operating systems may also require setting
firewall rules. For example, the following command explicitly opens the default
MinIO server API port ``9000`` on servers using ``firewalld``:

.. code-block:: shell
   :class: copyable

   firewall-cmd --permanent --zone=public --add-port=9000/tcp
   firewall-cmd --reload

If you set a static :ref:`MinIO Console <minio-console>` port (e.g. ``:9001``)
you must *also* grant access to that port to ensure connectivity from external
clients.

MinIO **strongly recomends** using a load balancer to manage connectivity to the
cluster. The Load Balancer should use a "Least Connections" algorithm for
routing requests to the MinIO deployment, since any MinIO node in the deployment
can receive, route, or process client requests. 

The following load balancers are known to work well with MinIO:

- `NGINX <https://www.nginx.com/products/nginx/load-balancing/>`__
- `HAProxy <https://cbonte.github.io/haproxy-dconv/2.3/intro.html#3.3.5>`__

Configuring firewalls or load balancers to support MinIO is out of scope for
this procedure.

Deployment Must Have Sufficient Storage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The decommissioning process migrates objects from the target pool to other
pools in the deployment. The total available storage on the deployment
*must* exceed the total storage of the decommissioned pool.

For example, consider a deployment with the following distribution of
used and free storage:

.. list-table::
   :stub-columns: 1
   :widths: 30 30 30
   :width: 100%

   * - Pool 1
     - 100TB Used
     - 200TB Total

   * - Pool 2
     - 100TB Used
     - 200TB Total

   * - Pool 3
     - 100TB Used
     - 200TB Total

Decommissioning Pool 1 requires distributing the 100TB of used storage
across the remaining pools. Pool 2 and Pool 3 each have 100TB of unused
storage space and can safely absorb the data stored on Pool 1. 

However, if Pool 1 were full (e.g. 200TB of used space), decommissioning would
completely fill the remaining pools and potentially prevent any further write
operations.

Decommissioning Does Not Support Tiering
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO does not support decommissioning pools in deployments with
:ref:`tiering <minio-lifecycle-management-tiering>` configured. The MinIO
server rejects decommissioning attempts if any bucket in the deployment
has a tiering configuration.

Considerations
--------------

Decommissioning Ignores Delete Markers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO does *not* migrate objects whose only remaining version is a 
:ref:`delete markers <minio-bucket-versioning-delete>`. This avoids creating
empty metadata on the remaining server pools for objects already considered
fully deleted.

Decommissioning is Resumable
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO resumes decommissioning if interrupted by deployment restarts, 
failed decommissioning attempts, or manual pausing of decommissioning.

Decommissioning Requires Downtime
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Removing a decommissioned server pool requires restarting *all* MinIO
nodes in the deployment at around the same time. This results in a 
brief period of downtime. S3 SDKs typically include retry logic, such that
application impact should be minimal. You can plan for a maintenance period
during which you perform this procedure to provide additional buffer.