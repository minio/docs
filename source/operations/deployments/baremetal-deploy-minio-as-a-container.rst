.. _deploy-minio-container:

===========================
Deploy MinIO as a Container
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

This page documents deploying MinIO as a Container onto any operating system that supports containerized processes.

This documentation assumes installation of Docker, Podman, or a similar runtime which supports the standard container image format.
MinIO images use `Red Hat Universal Base Image 9 Micro <https://catalog.redhat.com/software/container-stacks/detail/609560d9e2b160d361d24f98>`__.

Functionality and performance of the MinIO container may be constrained by the base OS.

The procedure includes guidance for deploying Single-Node Multi-Drive (SNMD) and Single-Node Single-Drive (SNSD) topologies in support of early development and evaluation environments.

.. important::

   MinIO officially supports containerized Multi-Node Multi-Drive (MNMD) "Distributed" configurations on Kubernetes infrastructures through the MinIO Kubernetes Operator.

   MinIO does not support nor provide instruction for deploying distributed clusters using Docker Swarm, Docker Compose, or any other orchestrated container environment.

Considerations
--------------

Review Checklists
~~~~~~~~~~~~~~~~~

Ensure you have reviewed our published Hardware, Software, and Security checklists before attempting this procedure.

Erasure Coding Parity
~~~~~~~~~~~~~~~~~~~~~

MinIO automatically determines the default :ref:`erasure coding <minio-erasure-coding>` configuration for the cluster based on the total number of nodes and drives in the topology.
You can configure the per-object :term:`parity` setting when you set up the cluster *or* let MinIO select the default (``EC:4`` for production-grade clusters).

Parity controls the relationship between object availability and storage on disk. 
Use the MinIO `Erasure Code Calculator <https://min.io/product/erasure-code-calculator>`__ for guidance in selecting the appropriate erasure code parity level for your cluster.

While you can change erasure parity settings at any time, objects written with a given parity do **not** automatically update to the new parity settings.

Container Storage
~~~~~~~~~~~~~~~~~

This procedure assumes you mount one or more dedicated storage devices to the container to act as persistent storage for MinIO.

Data stored on ephemeral container paths is lost when the container restarts or is deleted.
Use any such paths at your own risk.

Procedure
---------

1. Start the Container

This procedure provides instructions for Podman and Docker in rootfull mode.
For rootless deployments, defer to documentation by each runtime for configuration and container startup.

For all other container runtimes, follow the documentation for that runtime and specify the equivalent options, parameters, or configurations.

.. tab-set::

   .. tab-item:: Podman

      The following command creates a folder in your home directory, then starts the MinIO container using Podman:

      .. code-block:: shell
         :class: copyable

         mkdir -p ~/minio/data

         podman run \
            -p 9000:9000 \
            -p 9001:9001 \
            --name minio \
            -v ~/minio/data:/data \
            -e "MINIO_ROOT_USER=ROOTNAME" \
            -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
            quay.io/minio/minio server /data --console-address ":9001"

      The command binds ports ``9000`` and ``9001`` to the MinIO S3 API and Web Console respectively.

      The local drive ``~/minio/data`` is mounted to the ``/data`` folder on the container.
      You can modify the :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD` variables to change the root login as needed.

      For multi-drive deployments, bind each local drive or folder it's on sequentially-numbered path on the remote.
      You can then modify the :mc:`minio server` startup to specify those paths:

      .. code-block:: shell
         :class: copyable

         mkdir -p ~/minio/data-{1..4}

         podman run \
            -p 9000:9000 \
            -p 9001:9001 \
            --name minio \
            -v /mnt/drive-1:/mnt/drive-1 \
            -v /mnt/drive-2:/mnt/drive-2 \
            -v /mnt/drive-3:/mnt/drive-3 \
            -v /mnt/drive-4:/mnt/drive-4 \
            -e "MINIO_ROOT_USER=ROOTNAME" \
            -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
            quay.io/minio/minio server http://localhost:9000/mnt/drive-{1...4} --console-address ":9001"

      For Windows hosts, specify the local folder path using Windows filesystem semantics ``C:\minio\:/data``.

   .. tab-item:: Docker

      The following command creates a folder in your home directory, then starts the MinIO container using Docker:

      .. code-block:: shell
         :class: copyable

         mkdir -p ~/minio/data

         docker run \
            -p 9000:9000 \
            -p 9001:9001 \
            --name minio \
            -v ~/minio/data:/data \
            -e "MINIO_ROOT_USER=ROOTNAME" \
            -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
            quay.io/minio/minio server /data --console-address ":9001"

      The command binds ports ``9000`` and ``9001`` to the MinIO S3 API and Web Console respectively.

      The local drive ``~/minio/data`` is mounted to the ``/data`` folder on the container.
      You can modify the :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD` variables to change the root login as needed.

      For multi-drive deployments, bind each local drive or folder it's on sequentially-numbered path on the remote.
      You can then modify the :mc:`minio server` startup to specify those paths:

      .. code-block:: shell
         :class: copyable

         mkdir -p ~/minio/data-{1..4}

         docker run \
            -p 9000:9000 \
            -p 9001:9001 \
            --name minio \
            -v /mnt/drive-1:/mnt/drive-1 \
            -v /mnt/drive-2:/mnt/drive-2 \
            -v /mnt/drive-3:/mnt/drive-3 \
            -v /mnt/drive-4:/mnt/drive-4 \
            -e "MINIO_ROOT_USER=ROOTNAME" \
            -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
            quay.io/minio/minio server http://localhost:9000/mnt/drive-{1...4} --console-address ":9001"

      For Windows hosts, specify the local folder path using Windows filesystem semantics ``C:\minio\:/data``.

2. Connect to the Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Console

      Open your browser to http://localhost:9000 to open the :ref:`MinIO Console <minio-console>` login page. 

      Log in with the :guilabel:`MINIO_ROOT_USER` and :guilabel:`MINIO_ROOT_PASSWORD`
      from the previous step.

      .. image:: /images/minio-console/console-login.png
         :width: 600px
         :alt: MinIO Console Login Page
         :align: center

      You can use the MinIO Console for general administration tasks like Identity and Access Management, Metrics and Log Monitoring, or Server Configuration. 
      Each MinIO server includes its own embedded MinIO Console.

   .. tab-item:: CLI

      Follow the :ref:`installation instructions <mc-install>` for ``mc`` on your local host.
      Run ``mc --version`` to verify the installation.

      Once installed, create an alias for the MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc alias set myminio http://localhost:9000 USERNAME PASSWORD

      Change the hostname, username, and password to reflect your deployment.


