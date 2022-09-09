.. _deploy-minio-distributed:
.. _minio-mnmd:

====================================
Deploy MinIO: Multi-Node Multi-Drive
====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

A distributed MinIO deployment consists of 4 or more drives/volumes managed by
one or more :mc:`minio server` process, where the processes manage pooling the
compute and storage resources into a single aggregated object storage resource.
Each MinIO server has a complete picture of the distributed topology, such that
an application can connect to any node in the deployment and perform S3
operations.

Distributed deployments implicitly enable :ref:`erasure coding
<minio-erasure-coding>`, MinIO's data redundancy and availability feature that
allows deployments to automatically reconstruct objects on-the-fly despite the
loss of multiple drives or nodes in the cluster. Erasure coding provides
object-level healing with less overhead than adjacent technologies such as RAID
or replication. 

Depending on the configured :ref:`erasure code parity <minio-ec-parity>`, a
distributed deployment with ``m`` servers and ``n`` disks per server can
continue serving read and write operations with only ``m/2`` servers or
``m*n/2`` drives online and accessible.

Distributed deployments also support the following features:

- :ref:`Server-Side Object Replication <minio-bucket-replication-serverside>`
- :ref:`Write-Once Read-Many Locking  <minio-bucket-locking>`
- :ref:`Object Versioning <minio-bucket-versioning>`

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

Sequential Hostnames
~~~~~~~~~~~~~~~~~~~~

MinIO *requires* using expansion notation ``{x...y}`` to denote a sequential
series of MinIO hosts when creating a server pool. MinIO therefore *requires*
using sequentially-numbered hostnames to represent each
:mc:`minio server` process in the deployment. 

Create the necessary DNS hostname mappings *prior* to starting this procedure.
For example, the following hostnames would support a 4-node distributed
deployment:

- ``minio1.example.com``
- ``minio2.example.com``
- ``minio3.example.com``
- ``minio4.example.com``

You can specify the entire range of hostnames using the expansion notation
``minio{1...4}.example.com``.

Configuring DNS to support MinIO is out of scope for this procedure.

.. _deploy-minio-distributed-prereqs-storage:

Local JBOD Storage with Sequential Mounts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. |deployment| replace:: deployment

.. include:: /includes/common-installation.rst
   :start-after: start-local-jbod-desc
   :end-before: end-local-jbod-desc

.. admonition:: Network File System Volumes Break Consistency Guarantees
   :class: note

   MinIO's strict **read-after-write** and **list-after-write** consistency
   model requires local disk filesystems.

   MinIO cannot provide consistency guarantees if the underlying storage
   volumes are NFS or a similar network-attached storage volume. 

   For deployments that *require* using network-attached storage, use
   NFSv4 for best results.

Considerations
--------------

Homogeneous Node Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO strongly recommends selecting substantially similar hardware
configurations for all nodes in the deployment. Ensure the hardware (CPU,
memory, motherboard, storage adapters) and software (operating system, kernel
settings, system services) is consistent across all nodes. 

Deployment may exhibit unpredictable performance if nodes have heterogeneous
hardware or software configurations. Workloads that benefit from storing aged
data on lower-cost hardware should instead deploy a dedicated "warm" or "cold"
MinIO deployment and :ref:`transition <minio-lifecycle-management-tiering>`
data to that tier.

Erasure Coding Parity
~~~~~~~~~~~~~~~~~~~~~

MinIO :ref:`erasure coding <minio-erasure-coding>` is a data redundancy and
availability feature that allows MinIO deployments to automatically reconstruct
objects on-the-fly despite the loss of multiple drives or nodes in the cluster.
Erasure Coding provides object-level healing with less overhead than adjacent
technologies such as RAID or replication. Distributed deployments implicitly
enable and rely on erasure coding for core functionality.

Erasure Coding splits objects into data and parity blocks, where parity blocks
support reconstruction of missing or corrupted data blocks. The number of parity
blocks in a deployment controls the deployment's relative data redundancy.
Higher levels of parity allow for higher tolerance of drive loss at the cost of
total available storage.

MinIO defaults to ``EC:4`` , or 4 parity blocks per 
:ref:`erasure set <minio-ec-erasure-set>`. You can set a custom parity
level by setting the appropriate 
:ref:`MinIO Storage Class environment variable 
<minio-server-envvar-storage-class>`. Consider using the MinIO
`Erasure Code Calculator <https://min.io/product/erasure-code-calculator>`__ for
guidance in selecting the appropriate erasure code parity level for your
cluster.

Capacity-Based Planning
~~~~~~~~~~~~~~~~~~~~~~~

MinIO generally recommends planning capacity such that
:ref:`server pool expansion <expand-minio-distributed>` is only required after
2+ years of deployment uptime. 

For example, consider an application suite that is estimated to produce 10TB of
data per year. The MinIO deployment should provide *at minimum*:

``10TB + 10TB + 10TB  = 30TB`` 

MinIO recommends adding buffer storage to account for potential growth in 
stored data (e.g. 40TB of total usable storage). As a rule-of-thumb, more
capacity initially is preferred over frequent just-in-time expansion to meet
capacity requirements.

Since MinIO :ref:`erasure coding <minio-erasure-coding>` requires some
storage for parity, the total **raw** storage must exceed the planned **usable**
capacity. Consider using the MinIO `Erasure Code Calculator
<https://min.io/product/erasure-code-calculator>`__ for guidance in planning
capacity around specific erasure code settings.

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

- All hosts have four locally-attached disks with sequential mount-points:

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
