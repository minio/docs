.. _deploy-minio-distributed:

================================
Deploy MinIO in Distributed Mode
================================

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

Networking and Hostnames
~~~~~~~~~~~~~~~~~~~~~~~~

Each node should have full bidirectional network access to every other
node in the deployment. For containerized or orchestrated infrastructures,
this may require specific configuration of networking and routing 
components such as ingress or load balancers.

MinIO *requires* using sequentially-numbered hostnames to represent each
:mc:`minio server` process in the deployment. Create the necessary DNS hostname
mappings *prior* to starting this procedure. For example, the following
hostnames would support a 4-node distributed deployment:

- ``minio1.example.com``
- ``minio2.example.com``
- ``minio3.example.com``
- ``minio4.example.com``

MinIO **strongly recomends** using a load balancer to manage connectivity to
the cluster. The Load Balancer should use a Least Connections algorithm for
routing requests to the MinIO deployment. Any MinIO node in the deployment can
receive and process client requests. 

The following load balancers are known to work well with MinIO:

- `NGINX <https://www.nginx.com/products/nginx/load-balancing/>`__
- `HAProxy <https://cbonte.github.io/haproxy-dconv/2.3/intro.html#3.3.5>`__

Configuring network, load balancers, and DNS to support MinIO is out of scope
for this procedure.

Local JBOD Storage with Sequential Mounts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO strongly recommends local :abbr:`JBOD (Just a Bunch of Disks)` arrays for
best performance. RAID or similar technologies do not provide additional
resilience or availability benefits when used with distributed MinIO
deployments, and typically reduce system performance.

MinIO generally recommends ``xfs`` formatted drives for best performance. 

MinIO **requires** using sequentially-numbered drives on each node in the
deployment, where the number sequence is *duplicated* across all nodes.
For example, the following sequence of mounted drives would support a 4-drive
per node distributed deployment:

- ``/mnt/disk1``
- ``/mnt/disk2``
- ``/mnt/disk3``
- ``/mnt/disk4``

Each mount should correspond to a locally-attached drive of the same type and
size. If using ``/etc/fstab`` or a similar file-based mount configuration, 
MinIO **strongly recommends** using drive UUID or labels to assign drives to
mounts. This ensures that drive ordering cannot change after a reboot. 

MinIO limits the size used per disk to the smallest drive in the
deployment. For example, if the deployment has 15 10TB disks and 1 1TB disk,
MinIO limits the per-disk capacity to 1TB. Similarly, use the same model NVME,
SSD, or HDD drives consistently across all nodes. Mixing drive types in the
same distributed deployment can result in unpredictable performance.

.. admonition:: Network File System Volumes Break Consistency Guarantees
   :class: note

   MinIO's strict **read-after-write** and **list-after-write** consistency
   model requires local disk filesystems (``xfs``, ``ext4``, etc.).

   MinIO cannot provide consistency guarantees if the underlying storage
   volumes are NFS or a similar network-attached storage volume. 

   For deployments that *require* using network-attached storage, use
   NFSv4 for best results.

Considerations
--------------

Homogeneous Node Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO strongly recommends selecting a hardware configuration for all nodes in
the deployment. Ensure the hardware (CPU, memory, motherboard, storage adapters)
and software (operating system, kernel settings, system services) is consistent
across all nodes.

The deployment may exhibit unpredictable performance if nodes have heterogeneous
hardware or software configurations. 

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

.. _deploy-minio-distributed-baremetal:

Procedure
---------

The following procedure creates a new distributed MinIO deployment consisting
of a single :ref:`Server Pool <minio-intro-server-pool>`.

Review the :ref:`deploy-minio-distributed-prereqs` before starting this
procedure.

1) Install the MinIO Binary on Each Node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Install the :program:`minio` binary onto each node in the deployment. Visit
`https://min.io/download <https://min.io/download?ref=docs>`__ and select the
tab most relevant to your use case. Follow the displayed instructions to
install the MinIO server binary on each node. Do *not* run the process yet.

2) Add TLS/SSL Certificates
~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO enables :ref:`Transport Layer Security (TLS) <minio-TLS>` 1.2+ 
automatically upon detecting a valid x.509 certificate (``.crt``) and
private key (``.key``) in the MinIO ``certs`` directory:

- For Linux/MacOS: ``${HOME}/.minio/certs``

- For Windows: ``%%USERPROFILE%%\.minio\certs``

Ensure each node has the necessary x.509 certificates in the
``certs`` directory.

You can override the certificate directory using the 
:mc-cmd-option:`minio server certs-dir` commandline argument.

You can optionally skip this step to deploy without TLS enabled. MinIO
strongly recommends *against* non-TLS deployments outside of early development.

3) Run the MinIO Server Process
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following command on each node in the deployment. The
following example assumes that:

- The deployment has four nodes with sequential hostnames (i.e.
  ``minio1.example.com``, ``minio2.example.com``, etc.).

- Each node has 4 locally-attached disks mounted using sequential naming
  semantics  (i.e. ``/mnt/disk1/data``, ``/mnt/disk2/data``, etc.).

.. code-block:: shell
   :class: copyable

   export MINIO_ROOT_USER=minio-admin
   export MINIO_ROOT_PASSWORD=minio-secret-key-CHANGE-ME
   export MINIO_SERVER_URL=https://minio.example.net

   minio server https://minio{1...4}.example.com/mnt/disk{1...4}/data \ 
                --console-address ":9001"

The example command breaks down as follows:

.. list-table::
   :widths: 40 60
   :width: 100%

   * - :envvar:`MINIO_ROOT_USER`
     - The access key for the :ref:`root <minio-users-root>` user.

       Specify the *same* unique, random, and long string for all
       nodes in the deployment.

   * - :envvar:`MINIO_ROOT_PASSWORD`
     - The corresponding secret key to use for the 
       :ref:`root <minio-users-root>` user.

       Specify the *same* unique, random, and long string for all
       nodes in the deployment.

   * - :envvar:`MINIO_SERVER_URL`
     - The URL hostname the MinIO Console uses for connecting to the MinIO 
       server. Specify the hostname of the load balancer which manages
       connections to the MinIO deployment. 
       
       This variable is *required* if specifying TLS certificates which **do
       not** contain the IP address of the MinIO Server host as a        
       :rfc:`Subject Alternative Name <5280#section-4.2.1.6>`. The hostname
       *must* covered by one of the TLS certificate SAN entries.

   * - ``minio{1...4}.example.com/``
     - The DNS hostname of each server in the distributed deployment specified
       as a single Server Pool. 

       The command uses MinIO expansion notation ``{x...y}`` to denote a
       sequential series. Specifically, the hostname
       ``https://minio{1...4}.example.com`` expands to:
  
       - ``https://minio1.example.com``
       - ``https://minio2.example.com``
       - ``https://minio3.example.com``
       - ``https://minio4.example.com``

       The expanded set of hostnames must include all MinIO server nodes in the
       server pool. Do **not** use a space-delimited series 
       (e.g. ``"HOSTNAME1 HOSTNAME2"``), as MinIO treats these as individual
       server pools instead of grouping the hosts into one server pool.

   * - ``/mnt/disk{1...4}/data``
     - The path to each disk on the host machine. 

       ``/data`` is an optional folder in which the ``minio`` server stores
       all information related to the deployment. 

       The command uses MinIO expansion notation ``{x...y}`` to denote a
       sequential series. Specifically,  ``/mnt/disk{1...4}/data`` expands to:
      
       - ``/mnt/disk1/data``
       - ``/mnt/disk2/data``
       - ``/mnt/disk3/data``
       - ``/mnt/disk4/data``

       See :mc-cmd:`minio server DIRECTORIES` for more information on
       configuring the backing storage for the :mc:`minio server` process.

   * - ``--console-address ":9001"``
     - The static port on which the embedded :ref:`MinIO Console
       <minio-console>` listens for incoming connections.

       Omit to allow MinIO to select a dynamic port for the MinIO Console. 
       Browsers opening the root node hostname 
       ``https://minio1.example.com:9000`` are automatically redirected to the
       Console.

You may specify other :ref:`environment variables 
<minio-server-environment-variables>` as required by your deployment. 
All MinIO nodes in the deployment should include the same environment variables
with the same values for each variable.

4) Open the MinIO Console
~~~~~~~~~~~~~~~~~~~~~~~~~

Open your browser and access any of the MinIO hostnames at port ``:9001`` to
open the :ref:`MinIO Console <minio-console>` login page. For example,
``https://minio1.example.com:9001``.

Log in with the :guilabel:`MINIO_ROOT_USER` and :guilabel:`MINIO_ROOT_PASSWORD`
from the previous step.

.. image:: /images/minio-console-dashboard.png
   :width: 600px
   :alt: MinIO Console Dashboard displaying Monitoring Data
   :align: center

You can use the MinIO Console for general administration tasks like
Identity and Access Management, Metrics and Log Monitoring, or 
Server Configuration. Each MinIO server includes its own embedded MinIO
Console.

5) Next Steps
~~~~~~~~~~~~~

- Create an :ref:`alias <minio-mc-alias>` for accessing the deployment using
  :mc:`mc`.

- :ref:`Create users and policies to control access to the deployment 
  <minio-authentication-and-identity-management>`.

.. _deploy-minio-distributed-recommendations:

Deployment Recommendations
--------------------------

Minimum Nodes per Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For all production deployments, MinIO recommends a *minimum* of 4 nodes per
:ref:`server pool <minio-intro-server-pool>` with 4 drives per server. 
With the default :ref:`erasure code parity <minio-erasure-coding>` setting of
``EC:4``, this topology can continue serving read and write operations
despite the loss of up to 4 drives *or* one node.

The minimum recommendation reflects MinIO's experience with assisting enterprise
customers in deploying on a variety of IT infrastructures while maintaining the
desired SLA/SLO. While MinIO may run on less than the minimum recommended
topology, any potential cost savings come at the risk of decreased reliability.

Server Hardware
~~~~~~~~~~~~~~~

MinIO is hardware agnostic and runs on a variety of hardware architectures
ranging from ARM-based embedded systems to high-end x64 and POWER9 servers.

The following recommendations match MinIO's 
`Reference Hardware <https://min.io/product/reference-hardware>`__ for 
large-scale data storage:

.. list-table::
   :stub-columns: 1
   :widths: 20 80
   :width: 100%

   * - Processor
     - Dual Intel Xeon Scalable Gold CPUs with 8 cores per socket. 

   * - Memory
     - 128GB of Memory per pod

   * - Network
     - Minimum of 25GbE NIC and supporting network infrastructure between nodes.

       MinIO can make maximum use of drive throughput, which can fully saturate
       network links between MinIO nodes or clients. Large clusters may require
       100GbE network infrastructure to fully utilize MinIO's per-node 
       performance potential.

   * - Drives
     - SATA/SAS NVMe/SSD with a minimum of 8 drives per server. 

       Drives should be :abbr:`JBOD (Just a Bunch of Disks)` arrays with
       no RAID or similar technologies. MinIO recommends XFS formatting for
       best performance.

Networking
~~~~~~~~~~

MinIO recommends high speed networking to support the maximum possible
throughput of the attached storage (aggregated drives, storage controllers, 
and PCIe busses). The following table provides general guidelines for the 
maximum storage throughput supported by a given NIC:

.. list-table::
   :header-rows: 1
   :width: 100%
   :widths: 40 60

   * - NIC bandwidth (Gbps)
     - Estimated Aggregated Storage Throughput (GBps)

   * - 10GbE
     - 1GBps

   * - 25GbE
     - 2.5GBps
   
   * - 50GbE
     - 5GBps

   * - 100GbE
     - 10GBps

CPU Allocation
~~~~~~~~~~~~~~

MinIO can perform well with consumer-grade processors. MinIO can take advantage
of CPUs which support AVX-512 SIMD instructions for increased performance of
certain operations.

MinIO benefits from allocating CPU based on the expected per-host network
throughput. The following table provides general guidelines for allocating CPU
for use by based on the total network bandwidth supported by the host:

.. list-table::
   :header-rows: 1
   :width: 100%
   :widths: 40 60

   * - Host NIC Bandwidth
     - Recommended Pod vCPU

   * - 10GbE or less
     - 8 vCPU per pod.

   * - 25GbE
     - 16 vCPU per pod.

   * - 50GbE
     - 32 vCPU per pod.

   * - 100GbE
     - 64 vCPU per pod.



Memory Allocation
~~~~~~~~~~~~~~~~~

MinIO benefits from allocating memory based on the total storage of each host.
The following table provides general guidelines for allocating memory for use 
by MinIO server processes based on the total amount of local storage on the 
host:

.. list-table::
   :header-rows: 1
   :width: 100%
   :widths: 40 60

   * - Total Host Storage
     - Recommended Host Memory

   * - Up to 1 Tebibyte (Ti)
     - 8GiB

   * - Up to 10 Tebibyte (Ti)
     - 16GiB

   * - Up to 100 Tebibyte (Ti)
     - 32GiB
   
   * - Up to 1 Pebibyte (Pi)
     - 64GiB

   * - More than 1 Pebibyte (Pi)
     - 128GiB
       
