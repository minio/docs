.. _minio-decommissioning:

==========================
Decommission a Server Pool
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Starting with :minio-release:`RELEASE.2022-01-25T19-56-04Z`, MinIO supports
decommissioning and removing a :ref:`server pools <minio-intro-server-pool>`
from a deployment. Decommissioning is designed for removing an older server pool
whose hardware is no longer sufficient or performant compared to the pools in
the deployment. MinIO automatically migrates data from the decommissioned pool
to the remaining pools in the deployment based on the ratio of free space
available in each pool.

During the decommissioning process, MinIO routes read operations (e.g. ``GET``,
``LIST``, ``HEAD``) normally. MinIO routes write operations (e.g. ``PUT``,
versioned ``DELETE``) to the remaining "active" pools in the deployment.
Versioned objects maintain their ordering throughout the migration process.

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

MinIO resumes decommissioning if interrupted by transient issues such as
deployment restarts or network failures.

For manually cancelled or failed decommissioning attempts, MinIO 
resumes only after you manually re-initiate the decommissioning operation.

The pool remains in the decommissioning state *regardless* of the interruption.
A pool can *never* return to active status after decommissioning begins.

Decommissioning Requires Downtime
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Removing a decommissioned server pool requires restarting *all* MinIO
nodes in the deployment at around the same time. This results in a 
brief period of downtime. S3 SDKs typically include retry logic, such that
application impact should be minimal. You can plan for a maintenance period
during which you perform this procedure to provide additional buffer.

.. _minio-decommissioning-server-pool:

Decommission a Server Pool
--------------------------

1) Review the MinIO Deployment Topology
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :mc-cmd:`mc admin decommission` command returns a list of all
pools in the MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin decommission status myminio

The command returns output similar to the following:

.. code-block:: shell

   ┌─────┬────────────────────────────────────────────────────────────────┬──────────────────────────────────┬────────┐
   │ ID  │ Pools                                                          │ Capacity                         │ Status │
   │ 1st │ https://minio-{01...04}.example.com:9000/mnt/disk{1...4}/minio │  10 TiB (used) / 10  TiB (total) │ Active │
   │ 2nd │ https://minio-{05...08}.example.com:9000/mnt/disk{1...4}/minio │  60 TiB (used) / 100 TiB (total) │ Active │
   │ 3rd │ https://minio-{09...12}.example.com:9000/mnt/disk{1...4}/minio │  40 TiB (used) / 100 TiB (total) │ Active │
   └─────┴────────────────────────────────────────────────────────────────┴──────────────────────────────────┴────────┘

The example deployment above has three pools. Each pool has four servers
with four drives each.

Identify the target pool for decommissioning and review the current capacity.
The remaining pools in the deployment *must* have sufficient total
capacity to migrate all object stored in the decommissioned pool.

In the example above, the deployment has 210TiB total storage with 110TiB used.
The first pool (``minio-{01...04}``) is the decommissioning target, as it was
provisioned when the MinIO deployment was created and is completely full. The
remaining newer pools can absorb all objects stored on the first pool without
significantly impacting total available storage.

2) Start the Decommissioning Process
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. admonition:: Decommissioning is Permanent
   :class: warning

   Once MinIO begins decommissioning a pool, it marks that pool as *permanently*
   inactive ("draining"). Cancelling or otherwise interrupting the 
   decommissioning procedure does **not** restore the pool to an active
   state. 

   Review and validate that you are decommissioning the correct pool
   *before* running the following command.

Use the :mc-cmd:`mc admin decommission start` command to begin decommissioning
the target pool. Specify the :ref:`alias <alias>` of the deployment and the
full description of the pool to decommission, including all hosts, disks, and file paths.

.. code-block:: shell
   :class: copyable

   mc admin decommission start myminio/ https://minio-{01...04}.example.net:9000/mnt/disk{1...4}/minio

The example command begins decommissioning the matching server pool on the
``myminio`` deployment.

During the decommissioning process, MinIO continues routing read operations
(``GET``, ``LIST``, ``HEAD``) operations to the pool for those objects not
yet migrated. MinIO routes all new write operations (``PUT``) to the
remaining pools in the deployment.

Load balancers, reverse proxy, or other network control components which
manage connections to the deployment do not need to modify their configurations
at this time.

3) Monitor the Decommissioning Process
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin decommission status` command to monitor the 
decommissioning process. 

.. code-block:: shell
   :class: copyable

   mc admin decommission status myminio

The command returns output similar to the following:

.. code-block:: shell

   ┌─────┬────────────────────────────────────────────────────────────────┬──────────────────────────────────┬──────────┐
   │ ID  │ Pools                                                          │ Capacity                         │ Status   │
   │ 1st │ https://minio-{01...04}.example.com:9000/mnt/disk{1...4}/minio │  10 TiB (used) / 10  TiB (total) │ Draining │
   │ 2nd │ https://minio-{05...08}.example.com:9000/mnt/disk{1...4}/minio │  60 TiB (used) / 100 TiB (total) │ Active   │
   │ 3rd │ https://minio-{09...12}.example.com:9000/mnt/disk{1...4}/minio │  40 TiB (used) / 100 TiB (total) │ Active   │
   └─────┴────────────────────────────────────────────────────────────────┴──────────────────────────────────┴──────────┘

You can retrieve more detailed information by specifying the description of
the server pool to the command:

.. code-block:: shell
   :class: copyable

   mc admin decommission status myminio https://minio-{01...04}.example.com:9000/mnt/disk{1...4}/minio

The command returns output similar to the following:

.. code-block:: shell

   Decommissioning rate at 100MiB/sec [1TiB/10TiB]
   Started: 30 minutes ago

:mc-cmd:`mc admin decommission status` marks the :guilabel:`Status` as
:guilabel:`Complete` once decommissioning is completed. You can move on to
the next step once decommissioning is completed.

If :guilabel:`Status` reads as failed, you can re-run the
:mc-cmd:`mc admin decommission start` command to resume the process. 
For persistent failures, use :mc-cmd:`mc admin console` or review
the ``systemd`` logs (e.g. ``journalctl -u minio``) to identify more specific
errors.

4) Remove the Decommissioned Pool from the Deployment Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once decommissioning completes, you can safely remove the pool from the
deployment configuration. Modify the startup command for each remaining MinIO
server in the deployment and remove the decommissioned pool.

The ``.deb`` or ``.rpm`` packages install a 
`systemd <https://www.freedesktop.org/wiki/Software/systemd/>`__ service file to 
``/etc/systemd/system/minio.service``. For binary installations, this
procedure assumes the file was created manually as per the 
:ref:`deploy-minio-distributed` procedure.

The ``minio.service`` file uses an environment file located at 
``/etc/default/minio`` for sourcing configuration settings, including the
startup. Specifically, the ``MINIO_VOLUMES`` variable sets the startup
command:

.. code-block:: shell
   :class: copyable

   cat /etc/default/minio | grep "MINIO_VOLUMES"

The command returns output similar to the following:

.. code-block:: shell

   MINIO_VOLUMES="https://minio-{1...4}.example.net:9000/mnt/disk{1...4}/minio https://minio-{5...8}.example.net:9000/mnt/disk{1...4}/minio https://minio-{9...12}.example.net:9000/mnt/disk{1...4}/minio"

Edit the environment file and remove the decommissioned pool from the 
``MINIO_VOLUMES`` value.

5) Update Network Control Plane
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Update any load balancers, reverse proxies, or other network control planes
to remove the decommissioned server pool from the connection configuration for
the MinIO deployment.

Specific instructions for configuring network control plane components is
out of scope for this procedure.

6) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Stop the MinIO server nodes in the decommissioned pool at the same time.

.. code-block:: shell
   :class: copyable

   sudo systemctl stop minio

Restart the remaining MinIO server nodes in the deployment at the same time:

.. code-block:: shell
   :class: copyable

   sudo systemctl restart minio

The :mc-cmd:`mc admin service restart` command does not reload variables
from the environment file and is insufficient for this step.

Use ``systemctl status``, ``journalctl -f -u minio``, and 
:mc-cmd:`mc admin console` to monitor the deployment startup.

Once the deployment is online, use :mc-cmd:`mc admin info` to confirm the
uptime of all remaining servers in the deployment.
