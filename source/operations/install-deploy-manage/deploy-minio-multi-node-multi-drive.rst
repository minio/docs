.. _deploy-minio-distributed:
.. _minio-mnmd:

====================================
Deploy MinIO: Multi-Node Multi-Drive
====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

The procedures on this page cover deploying MinIO in a Multi-Node Multi-Drive (MNMD) or "Distributed" configuration.
|MNMD| deployments provide enterprise-grade performance, availability, and scalability and are the recommended topology for all production workloads.

|MNMD| deployments support :ref:`erasure coding <minio-ec-parity>` configurations which tolerate the loss of up to half the nodes or drives in the deployment while continuing to serve read operations.
Use the MinIO `Erasure Code Calculator <https://min.io/product/erasure-code-calculator?ref=docs>`__ when planning and designing your MinIO deployment to explore the effect of erasure code settings on your intended topology.

.. _deploy-minio-distributed-prereqs:

Prerequisites
-------------

Networking and Firewalls
~~~~~~~~~~~~~~~~~~~~~~~~

Each node should have full bidirectional network access to every other node in
the deployment. For containerized or orchestrated infrastructures, this may
require specific configuration of networking and routing components such as
ingress or load balancers. Certain operating systems may also require setting
firewall rules. For example, the following command explicitly opens the default
MinIO server API port ``9000`` for servers running firewalld :

.. code-block:: shell
   :class: copyable

   firewall-cmd --permanent --zone=public --add-port=9000/tcp
   firewall-cmd --reload

All MinIO servers in the deployment *must* use the same listen port.

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
The :ref:`integrations-nginx-proxy` reference provides a baseline configuration for using NGINX as a reverse proxy with basic load balancing configured.

Sequential Hostnames
~~~~~~~~~~~~~~~~~~~~

MinIO *requires* using expansion notation ``{x...y}`` to denote a sequential series of MinIO hosts when creating a server pool. 
MinIO supports using either a sequential series of hostnames *or* IP addresses to represent each :mc:`minio server` process in the deployment.

This procedure assumes use of sequential hostnames due to the lower overhead of management, especially in larger distributed clusters.

Create the necessary DNS hostname mappings *prior* to starting this procedure.
For example, the following hostnames would support a 4-node distributed deployment:

- ``minio-01.example.com``
- ``minio-02.example.com``
- ``minio-03.example.com``
- ``minio-04.example.com``

You can specify the entire range of hostnames using the expansion notation ``minio-0{1...4}.example.com``.

.. dropdown:: Non-Sequential Hostnames or IP Addresses

   MinIO does not support non-sequential hostnames or IP addresses for distributed deployments.
   You can instead use ``/etc/hosts`` on each node to set a simple DNS scheme that supports expansion notation.
   For example:

   .. code-block:: shell

      # /etc/hosts

      198.0.2.10    minio-01.example.net
      198.51.100.3  minio-02.example.net
      198.0.2.43    minio-03.example.net
      198.51.100.12 minio-04.example.net

   The above hosts configuration supports expansion notation of ``minio-0{1...4}.example.net``, mapping the sequential hostnames to the desired IP addresses.

.. _deploy-minio-distributed-prereqs-storage:

Storage Requirements
~~~~~~~~~~~~~~~~~~~~

.. |deployment| replace:: deployment

.. include:: /includes/common-installation.rst
   :start-after: start-storage-requirements-desc
   :end-before: end-storage-requirements-desc

Memory Requirements
~~~~~~~~~~~~~~~~~~~

Starting with :minio-release:`RELEASE.2024-01-28T22-35-53Z`, MinIO pre-allocates 2GiB of system memory at startup.

MinIO recommends a *minimum* of 32GiB of memory per host.
See :ref:`minio-hardware-checklist-memory` for more guidance on memory allocation in MinIO.

Time Synchronization
~~~~~~~~~~~~~~~~~~~~

Multi-node systems must maintain synchronized time and date to maintain stable internode operations and interactions.
Make sure all nodes sync to the same time server regularly.
Operating systems vary for methods used to synchronize time and date, such as with ``ntp``, ``timedatectl``, or ``timesyncd``.

Check the documentation for your operating system for how to set up and maintain accurate and identical system clock times across nodes.

Considerations
--------------

Erasure Coding Parity
~~~~~~~~~~~~~~~~~~~~~

MinIO :ref:`erasure coding <minio-erasure-coding>` is a data redundancy and availability feature that allows MinIO deployments to automatically reconstruct objects on-the-fly despite the loss of multiple drives or nodes in the cluster.

MinIO defaults to ``EC:4``, or 4 parity blocks per :ref:`erasure set <minio-ec-erasure-set>`. 
You can set a custom parity level by setting the appropriate :ref:`MinIO Storage Class environment variable <minio-server-envvar-storage-class>`. 
Consider using the MinIO `Erasure Code Calculator <https://min.io/product/erasure-code-calculator>`__ for guidance in selecting the appropriate erasure code parity level for your cluster.

.. important::

   While you can change erasure parity settings at any time, objects written with a given parity do **not** automatically update to the new parity settings.

Capacity-Based Planning
~~~~~~~~~~~~~~~~~~~~~~~

MinIO recommends planning storage capacity sufficient to store **at least** 2 years of data before reaching 70% usage.
Performing :ref:`server pool expansion <expand-minio-distributed>` more frequently or on a "just-in-time" basis generally indicates an architecture or planning issue.

For example, consider an application suite expected to produce at least 100 TiB of data per year and a 3 year target before expansion.
By ensuring the deployment has ~500TiB of usable storage up front, the cluster can safely meet the 70% threshold with additional buffer for growth in data storage output per year.

Since MinIO :ref:`erasure coding <minio-erasure-coding>` requires some storage for parity, the total **raw** storage must exceed the planned **usable** capacity. 
Consider using the MinIO `Erasure Code Calculator <https://min.io/product/erasure-code-calculator>`__ for guidance in planning capacity around specific erasure code settings.

Recommended Operating Systems
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. cond:: linux

   This tutorial assumes all hosts running MinIO use a 
   :ref:`recommended Linux operating system <minio-installation-platform-support>`
   such as RHEL8+ or Ubuntu 18.04+. 

.. cond:: macos

   This tutorial assumes all hosts running MinIO use a non-EOL macOS version (10.14+).

.. cond:: Windows

   This tutorial assumes all hosts running MinIO use a non-EOL Windows distribution.

   Support for running distributed MinIO deployments on Windows is *experimental*.

Pre-Existing Data
~~~~~~~~~~~~~~~~~

When starting a new MinIO server in a distributed environment, the storage devices must not have existing data.

Once you start the MinIO server, all interactions with the data must be done through the S3 API.
Use the :ref:`MinIO Client <minio-client>`, the :ref:`MinIO Console <minio-console>`, or one of the MinIO :ref:`Software Development Kits <minio-drivers>` to work with the buckets and objects.

.. warning:: 
   
   Modifying files on the backend drives can result in data corruption or data loss.

.. _deploy-minio-distributed-baremetal:

Deploy Distributed MinIO
------------------------

The following procedure creates a new distributed MinIO deployment consisting
of a single :ref:`Server Pool <minio-intro-server-pool>`. 

All commands provided below use example values. Replace these values with
those appropriate for your deployment.

Review the :ref:`deploy-minio-distributed-prereqs` before starting this
procedure.

1) Install the MinIO Binary on Each Node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. cond:: linux

   .. include:: /includes/linux/common-installation.rst
      :start-after: start-install-minio-binary-desc
      :end-before: end-install-minio-binary-desc

.. cond:: macos

   .. include:: /includes/macos/common-installation.rst
      :start-after: start-install-minio-binary-desc
      :end-before: end-install-minio-binary-desc

2) Create the ``systemd`` Service File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/linux/common-installation.rst
   :start-after: start-install-minio-systemd-desc
   :end-before: end-install-minio-systemd-desc

3) Create the Service Environment File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create an environment file at ``/etc/default/minio``. The MinIO 
service uses this file as the source of all 
:ref:`environment variables <minio-server-environment-variables>` used by
MinIO *and* the ``minio.service`` file.

The following examples assumes that:

- The deployment has a single server pool consisting of four MinIO server hosts
  with sequential hostnames.

  .. code-block:: shell

     minio1.example.com   minio3.example.com
     minio2.example.com   minio4.example.com

- All hosts have four locally-attached drives with sequential mount-points:

  .. code-block:: shell

    /mnt/disk1/minio   /mnt/disk3/minio
    /mnt/disk2/minio   /mnt/disk4/minio

- The deployment has a load balancer running at ``https://minio.example.net``
  that manages connections across all four MinIO hosts.

Modify the example to reflect your deployment topology:

.. code-block:: shell
   :class: copyable

   # Set the hosts and volumes MinIO uses at startup
   # The command uses MinIO expansion notation {x...y} to denote a
   # sequential series. 
   # 
   # The following example covers four MinIO hosts
   # with 4 drives each at the specified hostname and drive locations.
   # The command includes the port that each MinIO server listens on
   # (default 9000)

   MINIO_VOLUMES="https://minio{1...4}.example.net:9000/mnt/disk{1...4}/minio"

   # Set all MinIO server options
   #
   # The following explicitly sets the MinIO Console listen address to
   # port 9001 on all network interfaces. The default behavior is dynamic
   # port selection.

   MINIO_OPTS="--console-address :9001"

   # Set the root username. This user has unrestricted permissions to
   # perform S3 and administrative API operations on any resource in the
   # deployment.
   #
   # Defer to your organizations requirements for superadmin user name.

   MINIO_ROOT_USER=minioadmin

   # Set the root password
   #
   # Use a long, random, unique string that meets your organizations
   # requirements for passwords.

   MINIO_ROOT_PASSWORD=minio-secret-key-CHANGE-ME

   # Set to the URL of the load balancer for the MinIO deployment
   # This value *must* match across all MinIO servers. If you do
   # not have a load balancer, set this value to to any *one* of the
   # MinIO hosts in the deployment as a temporary measure.
   MINIO_SERVER_URL="https://minio.example.net:9000"

You may specify other :ref:`environment variables
<minio-server-environment-variables>` or server commandline options as required
by your deployment. All MinIO nodes in the deployment should include the same
environment variables with the same values for each variable.

4) Add TLS/SSL Certificates
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-installation.rst
   :start-after: start-install-minio-tls-desc
   :end-before: end-install-minio-tls-desc

5) Run the MinIO Server Process
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following commands on each node in the deployment to start the
MinIO service:

.. include:: /includes/linux/common-installation.rst
   :start-after: start-install-minio-start-service-desc
   :end-before: end-install-minio-start-service-desc

6) Open the MinIO Console
~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-installation.rst
   :start-after: start-install-minio-console-desc
   :end-before: end-install-minio-console-desc

7) Next Steps
~~~~~~~~~~~~~

- Create an :ref:`alias <minio-mc-alias>` for accessing the deployment using
  :mc:`mc`.

- :ref:`Create users and policies to control access to the deployment 
  <minio-authentication-and-identity-management>`.
