.. _minio-baremetal:

====================
MinIO for Bare Metal
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO is a high performance distributed object storage server, designed for
large-scale private cloud infrastructure. MinIO fully supports deployment onto
bare-metal hardware with or without containerization for process management.

Standalone Installation
-----------------------

Standalone MinIO deployments consist of a single ``minio`` server process with
one or more disks. Standalone deployments are best suited for local development
environments.

1) Install the ``minio`` Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Install the :program:`minio` server onto the host machine. Select the tab that
corresponds to the host machine operating system or environment:

.. include:: /includes/minio-server-installation.rst

2) Add TLS/SSL Certificates (Optional)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable TLS/SSL connectivity to the MinIO server by specifying a private key
(``.key``) and public certificate (``.crt``) to the MinIO ``certs`` directory:

- For Linux/MacOS: ``${HOME}/.minio/certs``

- For Windows: ``%%USERPROFILE%%\.minio\certs``

The MinIO server automatically enables TLS/SSL connectivity if it detects
the required certificates in the ``certs`` directory.

.. note::

   The MinIO documentation makes a best-effort to provide generally applicable
   and accurate information on TLS/SSL connectivity in the context of MinIO
   products and services, and is not intended as a complete guide to the larger
   topic of TLS/SSL certificate creation and management.

3) Run the ``minio`` Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following command to start the :program:`minio` server. The following
example assumes the host machine has *at least* four disks, which is the minimum
required number of disks to enable :ref:`erasure coding <minio-erasure-coding>`:

.. code-block:: shell
   :class: copyable

   export MINIO_ACCESS_KEY=minio-admin
   export MINIO_SECRET_KEY=minio-secret-key-CHANGE-ME
   minio server /mnt/disk{1...4}/data

The example command breaks down as follows:

.. list-table::
   :widths: 40 60
   :width: 100%

   * - :envvar:`MINIO_ACCESS_KEY`
     - The access key for the :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string. 

   * - :envvar:`MINIO_SECRET_KEY`
     - The corresponding secret key to use for the 
       :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string.

   * - ``/mnt/disk{1...4}/data``
     - The path to each disk on the host machine. 

       ``/data`` is an optional folder in which the ``minio`` server stores
       all information related to the deployment. 

       See :mc-cmd:`minio server DIRECTORIES` for more information on
       configuring the backing storage for the :mc:`minio server` process.

The command uses MinIO expansion notation ``{x...y}`` to denote a sequential
series. Specifically, ``/mnt/disk{1...4}/data`` expands to:
  
- ``/mnt/disk1/data``
- ``/mnt/disk2/data``
- ``/mnt/disk3/data``
- ``/mnt/disk4/data``

4) Connect to the Server
~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc alias set` command from a machine with connectivity to
the host running the ``minio`` server. See :ref:`mc-install` for documentation
on installing :program:`mc`.

.. code-block:: shell
   :class: copyable

   mc alias set mylocalminio 192.0.2.10:9000 minioadmin minio-secret-key-CHANGE-ME

Replace the IP address and port with one of the ``minio`` servers endpoints.

See :ref:`minio-mc-commands` for a list of commands you can run on the 
MinIO server.

Distributed Installation
------------------------

Distributed MinIO deployments consist of multiple ``minio`` servers with
one or more disks each. Distributed deployments are best suited for
staging and production environments. 

MinIO *requires* using sequentially-numbered hostnames to represent each
``minio`` server in the deployment. For example, the following hostnames support
a 4-node distributed deployment:

- ``minio1.example.com``
- ``minio2.example.com``
- ``minio3.example.com``
- ``minio4.example.com``

Create the necessary DNS hostname mappings *prior* to starting this 
procedure.

1) Install the ``minio`` Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Install the :program:`minio` server onto each host machine in the deployment.
Select the tab that corresponds to the host machine operating system or
environment:

.. include:: /includes/minio-server-installation.rst

2) Add TLS/SSL Certificates (Optional)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable TLS/SSL connectivity to the MinIO server by specifying a private key
(``.key``) and public certificate (``.crt``) to the MinIO ``certs`` directory:

- For Linux/MacOS: ``${HOME}/.minio/certs``

- For Windows: ``%%USERPROFILE%%\.minio\certs``

The MinIO server automatically enables TLS/SSL connectivity if it detects
the required certificates in the ``certs`` directory.

.. note::

   The MinIO documentation makes a best-effort to provide generally applicable
   and accurate information on TLS/SSL connectivity in the context of MinIO
   products and services, and is not intended as a complete guide to the larger
   topic of TLS/SSL certificate creation and management.

3) Run the ``minio`` Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following command on each host machine in the deployment. The
following example assumes that:

- The deployment has four host machines with sequential hostnames
  (i.e. ``minio1.example.com``, ``minio2.example.com``).

- Each host machine has *at least* four disks mounted at ``/data``. 4 disks is
  the minimum required for :ref:`erasure coding
  <minio-erasure-coding>`.

.. code-block:: shell
   :class: copyable

   export MINIO_ACCESS_KEY=minio-admin
   export MINIO_SECRET_KEY=minio-secret-key-CHANGE-ME
   minio server https://minio{1...4}.example.com/mnt/disk{1...4}/data

The example command breaks down as follows:

.. list-table::
   :widths: 40 60
   :width: 100%

   * - :envvar:`MINIO_ACCESS_KEY`
     - The access key for the :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string. 

   * - :envvar:`MINIO_SECRET_KEY`
     - The corresponding secret key to use for the 
       :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string.

   * - ``https://minio{1...4}.example.com/``
     - The DNS hostname of each server in the distributed deployment. 

   * - ``/mnt/disk{1...4}/data``
     - The path to each disk on the host machine. 

       ``/data`` is an optional folder in which the ``minio`` server stores
       all information related to the deployment. 

       See :mc-cmd:`minio server DIRECTORIES` for more information on
       configuring the backing storage for the :mc:`minio server` process.

The command uses MinIO expansion notation ``{x...y}`` to denote a sequential
series. Specifically:

-  The hostname ``https://minio{1...4}.example.com`` expands to:

   - ``https://minio1.example.com``
   - ``https://minio2.example.com``
   - ``https://minio3.example.com``
   - ``https://minio4.example.com``

- ``/mnt/disk{1...4}/data`` expands to
  
  - ``/mnt/disk1/data``
  - ``/mnt/disk2/data``
  - ``/mnt/disk3/data``
  - ``/mnt/disk4/data``

4) Connect to the Server
~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc alias set` command from a machine with connectivity to any
hostname running the ``minio`` server. See :ref:`mc-install` for documentation
on installing :program:`mc`.

.. code-block:: shell
   :class: copyable

   mc alias set mylocalminio minio1.example.net minioadmin minio-secret-key-CHANGE-ME

See :ref:`minio-mc-commands` for a list of commands you can run on the 
MinIO server. 

Docker Installation
-------------------

Stable MinIO
~~~~~~~~~~~~

The following ``docker`` command creates a container running the latest stable
version of the ``minio`` server process: 

.. code-block:: shell
   :class: copyable

   docker run -p 9000:9000 \
   -e "MINIO_ACCESS_KEY=ROOT_ACCESS_KEY" \
   -e "MINIO_SECRET_KEY=SECRET_ACCESS_KEY_CHANGE_ME" \
   -v /mnt/disk1:/disk1 \
   -v /mnt/disk2:/disk2 \
   -v /mnt/disk3:/disk3 \
   -v /mnt/disk4:/disk4 \
   minio/minio server /disk{1...4}

The command uses the following options:

- ``-e MINIO_ACCESS_KEY`` and ``-e MINIO_SECRET_KEY`` for configuring the
   :ref:`root <minio-users-root>` user credentials.

- ``-v /mnt/disk<int>:/disk<int>`` for configuring each disk the ``minio``
   server uses.

Bleeding Edge MinIO
~~~~~~~~~~~~~~~~~~~

*Do not use bleeding-edge deployments of MinIO in production environments*

The following ``docker`` command creates a container running the latest
bleeding-edge version of the ``minio`` server process:

.. code-block:: shell
   :class: copyable

   docker run -p 9000:9000 \
   -e "MINIO_ACCESS_KEY=ROOT_ACCESS_KEY" \
   -e "MINIO_SECRET_KEY=SECRET_ACCESS_KEY_CHANGE_ME" \
   -v /mnt/disk1:/disk1 \
   -v /mnt/disk2:/disk2 \
   -v /mnt/disk3:/disk3 \
   -v /mnt/disk4:/disk4 \
   minio/minio:edge server /disk{1...4}

The command uses the following options:

- ``MINIO_ACCESS_KEY`` and ``MINIO_SECRET_KEY`` for configuring the
   :ref:`root <minio-users-root>` user credentials.

- ``-v /mnt/disk<int>:/disk<int>`` for configuring each disk the ``minio`` 
   server uses. 

Deployment Recommendations
--------------------------

Minimum Nodes per Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For all production deployments, MinIO recommends a *minimum* of 4 nodes per
cluster. MinIO deployments with *at least* 4 nodes can tolerate the loss of up
to half the nodes *or* half the disks in the deployment while maintaining
read and write availability. 

For example, assuming a 4-node deployment with 4 drives per node, the 
cluster can tolerate the loss of:

- Any two nodes, *or*
- Any 8 drives.

The minimum recommendation reflects MinIO's experience with assisting enterprise
customers in deploying on a variety of IT infrastructures while
maintaining the desired SLA/SLO. While MinIO may run on less than the
minimum recommended topology, any potential cost savings come at the risk of
decreased reliability.

Recommended Hardware
~~~~~~~~~~~~~~~~~~~~

For MinIO's recommended hardware, please see 
`MinIO Reference Hardware <https://min.io/product/reference-hardware>`__.

Bare Metal Infrastructure
~~~~~~~~~~~~~~~~~~~~~~~~~

A distributed MinIO deployment can only provide as much availability as the
bare metal infrastructure on which it is deployed. In particular, consider the
following potential failure points which could result in cluster downtime
when configuring your bare metal infrastructure:

- Shared networking resources (switches, routers, ISP).
- Shared power resources.
- Shared physical location (rack, datacenter, region).

MinIO deployments using virtual machines or containerized environments should
also consider the following:

- Shared physical hardware (CPU, Memory, Storage)
- Shared orchestration management layer (Kubernetes, Docker Swarm)

FreeBSD
-------

MinIO does not provide an official FreeBSD binary. FreeBSD maintains an
`upstream release <https://www.freshports.org/www/minio>`__ you can
install using `pkg <https://github.com/freebsd/pkg>`__:

.. code-block:: shell
   :class: copyable

   pkg install minio
   sysrc minio_enable=yes
   sysrc minio_disks=/path/to/disks
   service minio start