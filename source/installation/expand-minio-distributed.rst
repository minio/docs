.. _expand-minio-distributed:

=====================================
Expand a Distributed MinIO Deployment
=====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

A distributed MinIO deployment consists of 4 or more drives/volumes managed by
one or more :mc:`minio server` process, where the processes manage pooling the
compute and storage resources into a single aggregated object storage resource.
Each MinIO server has a complete picture of the distributed topology, such that
an application can connect to any node in the deployment and perform S3
operations.

MinIO supports expanding an existing distributed deployment by adding a new
:ref:`Server Pool <minio-intro-server-pool>`. Each Pool expands the total
available storage capacity of the cluster while maintaining the overall
:ref:`availability <minio-erasure-coding>` of the cluster. Each Pool is its
own failure domain, where the loss of one or more disks or nodes in that pool
does not effect the availability of other pools in the deployment.

The procedure on this page expands an existing 
:ref:`distributed <deploy-minio-distributed>` MinIO deployment with an
additional server pool. 

.. _expand-minio-distributed-prereqs:

Prerequisites
-------------

Networking and Hostnames
~~~~~~~~~~~~~~~~~~~~~~~~

Each node should have full bidirectional network access to every other node in
the new server pool *and* the existing pools in the deployment. For
containerized or orchestrated infrastructures, this may require specific
configuration of networking and routing components such as ingress or load
balancers.

MinIO *requires* using sequentially-numbered hostnames to represent each
:mc:`minio server` process in the server pool. Create the necessary DNS hostname
mappings *prior* to starting this procedure. For example, the following
hostnames would support a 4-node distributed server pool:

- ``minio1.example.com``
- ``minio2.example.com``
- ``minio3.example.com``
- ``minio4.example.com``

MinIO **strongly recomends** using a load balancer to manage connectivity to
the cluster. The Load Balancer should use a Least Connections algorithm for
routing requests to the MinIO deployment. Any MinIO node in the deployment can
receive and process client requests. For pool expansion, you should update the
load balancer after completing the procedure to include the new pool hostnames.

The following load balancers are known to work well with MinIO:

- `NGINX <https://www.nginx.com/products/nginx/load-balancing/>`__
- `HAProxy <https://cbonte.github.io/haproxy-dconv/2.3/intro.html#3.3.5>`__

Configuring network, load balancers, and DNS to support MinIO is out of scope
for this procedure.

Local Storage
~~~~~~~~~~~~~

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

Minimum Drives for Erasure Code Parity
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO requires each pool satisfy the deployment
:ref:`erasure code <minio-erasure-coding>` settings. Specifically,
the new pool must have *at least* 2x the number of drives as the
:ref:`Standard <minio-ec-storage-class>` parity storage class. This requirement
ensures the new server pool can satisfy the 
expected :abbr:`SLA (Service Level Agreement)` of the deployment.

For example, consider a MinIO deployment with a single 16-node server pool
using the default erasure code parity ``EC:4``. The new server pool
must *at least* 8 drives (``4*2``) to satisfy ``EC:4``.

Considerations
--------------

Homogeneous Node Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO strongly recommends selecting a hardware configuration for all nodes in
the new server pool. Ensure the hardware (CPU, memory, motherboard, storage
adapters) and software (operating system, kernel settings, system services) is
consistent across all nodes in the pool. The new pool may exhibit unpredictable
performance if nodes have heterogeneous hardware or software configurations.

Similarly, MinIO also recommends that the hardware and software configurations
for the new pool nodes are substantially similar to existing server pools. This
ensures consistent performance of operations across the cluster regardless of
which pool a given application performs operations against.

See :ref:`deploy-minio-distributed-recommendations` for more guidance on
selecting hardware for MinIO deployments.

Expansion Requires Downtime
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adding a new server pool requires restarting *all* MinIO nodes in the
deployment at around same time. This results in a brief period of downtime.
S3 SDKs typically include retry logic, such that application impact should be
minimal. You can plan for a maintenance period during which you perform this
procedure to provide additional buffer 

Capacity-Based Planning
~~~~~~~~~~~~~~~~~~~~~~~

MinIO generally recommends planning capacity such that
:ref:`server pool expansion <expand-minio-distributed>` is only required after
2+ years of deployment uptime. 

For example, consider an application suite that is estimated to produce 10TB of
data per year. The current deployment is running low on free storage and
therefore requires expansion to meet the ongoing storage demands of the
application. The new server pool should provide *at minimum*

``10TB + 10TB + 10TB  = 30TB`` 

MinIO recommends adding buffer storage to account for potential growth in stored
data (e.g. 40TB of total usable storage). The total planned *usable* storage in
the deployment would therefore be ~80TB. As a rule-of-thumb, more capacity
initially is preferred over frequent just-in-time expansion to meet capacity
requirements.

Since MinIO :ref:`erasure coding <minio-erasure-coding>` requires some
storage for parity, the total **raw** storage must exceed the planned **usable**
capacity. Consider using the MinIO `Erasure Code Calculator
<https://min.io/product/erasure-code-calculator>`__ for guidance in planning
capacity around specific erasure code settings.

Procedure
---------

The following procedure adds a :ref:`Server Pool <minio-intro-server-pool>`
to an existing MinIO deployment. Each Pool expands the total available
storage capacity of the cluster while maintaining the overall 
:ref:`availability <minio-erasure-coding>` of the cluster.

Review the :ref:`expand-minio-distributed-prereqs` before starting this
procedure.

1) Install the MinIO Binary on Each Node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Install the :program:`minio` binary onto each node in the new server pool. Visit
`https://min.io/download <https://min.io/download?ref=docs>`__ and select the
tab most relevant to your use case. Follow the displayed instructions to
install the MinIO server binary on each node. Do *not* run the process yet.

.. important:: 

   The MinIO server version **must** match across all MinIO nodes in the
   deployment. If your existing deployment has not been 
   :ref:`upgraded to the latest stable release <minio-upgrade>`, 
   you may need to retrieve a specific version from the MinIO
   `download archives <https://dl.min.io/server/minio/release/>`__.

   MinIO encourages any organization running older versions of MinIO to 
   engage with `MinIO Support <https://min.io/pricing?ref=docs>`__ to provide
   support and guidance for server expansion.

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

Issue the following command on all nodes in the deployment, including the
existing server pools. This *requires* stopping all MinIO server processes:

The following example assumes that:

- The existing deployment consists of a single server pool reachable via
  ``https://minio{1...4}.example.com``.

- The new pool consists of hostnames reachable via 
  ``https://minio{5...8}.example.com``.

- All nodes in the new pool have sequential hostnames (i.e.
  ``minio5.example.com``, ``minio6.example.com``, etc.).

- Each node has 4 locally-attached disks mounted using sequential naming
  semantics (i.e. ``/mnt/disk1/data``, ``/mnt/disk2/data``, etc.).

.. code-block:: shell
   :class: copyable

   export MINIO_ROOT_USER=minio-admin
   export MINIO_ROOT_PASSWORD=minio-secret-key-CHANGE-ME
   export MINIO_SERVER_URL=https://minio.example.net

   minio server https://minio{1...4}.example.com/mnt/disk{1...4}/data \ 
                https://minio{5...8}.example.com/mnt/disk{1...4}/data \ 
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
     - The DNS hostname of each existing MinIO server in the deployment.
       Each set of hostnames describes a single server pool in the
       deployment.

       The command uses MinIO expansion notation ``{x...y}`` to denote a
       sequential series. Specifically, the hostname
       ``https://minio{1...4}.example.com`` expands to:
  
       - ``https://minio1.example.com``
       - ``https://minio2.example.com``
       - ``https://minio3.example.com``
       - ``https://minio4.example.com``

       These hostnames should match the existing server pool hostname sets used
       to start each MinIO server in the deployment.

   * - ``minio{5...8}.example.com/``
     - The DNS hostname of each server in the new server pool.

       The command uses MinIO expansion notation ``{x...y}`` to denote a
       sequential series. Specifically, the hostname
       ``https://minio{5...8}.example.com`` expands to:
  
       - ``https://minio5.example.com``
       - ``https://minio6.example.com``
       - ``https://minio7.example.com``
       - ``https://minio8.example.com``

       The expanded set of hostnames must include all MinIO server nodes in the
       server pool. Do **not** use a space-delimited series 
       (e.g. ``"HOSTNAME1 HOSTNAME2"``), as MinIO treats these as individual
       server pools instead of grouping the hosts into one server pool.

   * - ``--console-address ":9001"``
     - The static port on which the embedded MinIO Console listens for incoming
       connections.

       Omit to allow MinIO to select a dynamic port for the MinIO Console. 
       Browsers opening the root node hostname 
       ``https://minio1.example.com:9000`` are automatically redirected to the
       Console.

You may specify other :ref:`environment variables 
<minio-server-environment-variables>` as required by your deployment. 
All MinIO nodes in the deployment should include the same environment variables
with the same values for each variable.

4) Next Steps
~~~~~~~~~~~~~

- Use the :ref:`MinIO Console <minio-console>` to monitor traffic and confirm
  cluster storage expansion.

- Update the load balancer managing connections to the MinIO deployment to
  include the new server pool hostnames