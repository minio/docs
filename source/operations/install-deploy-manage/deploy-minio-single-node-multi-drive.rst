=====================================
Deploy MinIO: Single-Node Multi-Drive
=====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

The procedures on this page cover deploying MinIO in :guilabel:`Standalone Mode` with multiple local volumes or folders.
This deployment supports and enables :ref:`erasure coding <minio-erasure-coding>` and its dependent features.

For extended development or production environments, *or* to access :ref:`advanced MinIO functionality <minio-installation-comparison>` deploy MinIO in :guilabel:`Distributed Mode`. 
See :ref:`deploy-minio-distributed` for more information.

Prerequisites
-------------

.. _deploy-minio-standalone-multidrive:

Local JBOD Storage with Sequential Mounts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. |deployment| replace:: deployment

.. include:: /includes/common-installation.rst
   :start-after: start-local-jbod-single-node-desc
   :end-before: end-local-jbod-single-node-desc

.. admonition:: Network File System Volumes Break Consistency Guarantees
   :class: note

   MinIO's strict **read-after-write** and **list-after-write** consistency
   model requires local disk filesystems.

   MinIO cannot provide consistency guarantees if the underlying storage
   volumes are NFS or a similar network-attached storage volume. 

   For deployments that *require* using network-attached storage, use
   NFSv4 for best results.

Deploy Standalone Multi-Drive MinIO
-----------------------------------

The following procedure deploys MinIO in :guilabel:`Standalone Mode` consisting
of a single MinIO server and a single drive or storage volume. Standalone
deployments are best suited for evaluation and initial development environments.

.. admonition:: Network File System Volumes Break Consistency Guarantees
   :class: note

   MinIO's strict **read-after-write** and **list-after-write** consistency
   model requires local disk filesystems (``xfs``, ``ext4``, etc.).

   MinIO cannot provide consistency guarantees if the underlying storage
   volumes are NFS or a similar network-attached storage volume. 

   For deployments that *require* using network-attached storage, use
   NFSv4 for best results.

1) Download the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. cond:: linux

   .. include:: /includes/linux/common-installation.rst
      :start-after: start-install-minio-binary-desc
      :end-before: end-install-minio-binary-desc

.. cond:: macos

   .. include:: /includes/macos/common-installation.rst
      :start-after: start-install-minio-binary-desc
      :end-before: end-install-minio-binary-desc

2) Download and Run MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. cond:: linux

   .. include:: /includes/linux/common-installation.rst
      :start-after: start-run-minio-binary-desc
      :end-before: end-run-minio-binary-desc

.. cond:: macos

   .. include:: /includes/macos/common-installation.rst
      :start-after: start-run-minio-binary-desc
      :end-before: end-run-minio-binary-desc

3) Add TLS Certificates
~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports enabling :ref:`Transport Layer Security (TLS) <minio-TLS>` 1.2+
automatically upon detecting a x.509 private key (``private.key``) and public
certificate (``public.crt``) in the MinIO ``certs`` directory:

.. cond:: linux

   .. code-block:: shell

      ${HOME}/.minio/certs

.. cond:: macos

   .. code-block:: shell

      ${HOME}/.minio/certs

.. cond:: windows

   .. code-block:: shell

      ``%%USERPROFILE%%\.minio\certs``

You can override the certificate directory using the 
:mc-cmd:`minio server --certs-dir` commandline argument.

4) Run the MinIO Server with Non-Default Credentials
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following command to start the :mc:`minio server` with non-default
credentials. The table following this command breaks down each portion of the
command:

.. code-block:: shell
   :class: copyable

   export MINIO_ROOT_USER=minio-admin
   export MINIO_ROOT_PASSWORD=minio-secret-key-CHANGE-ME
   #export MINIO_SERVER_URL=https://minio.example.net

   minio server /mnt/disk-{1...4} --console-address ":9090"

The example command breaks down as follows:

.. list-table::
   :widths: 40 60
   :width: 100%

   * - :envvar:`MINIO_ROOT_USER`
     - The access key for the :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string. 

   * - :envvar:`MINIO_ROOT_PASSWORD`
     - The corresponding secret key to use for the 
       :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string.

   * - :envvar:`MINIO_SERVER_URL`
     - The URL hostname the MinIO Console uses for connecting to the MinIO 
       server. This variable is *required* if specifying TLS certificates
       which **do not** contain the IP address of the MinIO Server host
       as a :rfc:`Subject Alternative Name <5280#section-4.2.1.6>`. 
       Specify a hostname covered by one of the TLS certificate SAN entries.

You may specify other :ref:`environment variables 
<minio-server-environment-variables>` as required by your deployment.

5) Open the MinIO Console
~~~~~~~~~~~~~~~~~~~~~~~~~

Open your browser to the DNS name or IP address corresponding to the 
container and the :ref:`MinIO Console <minio-console>` port. For example,
``https://127.0.0.1:9090``.

Log in with the :guilabel:`MINIO_ROOT_USER` and :guilabel:`MINIO_ROOT_PASSWORD`
from the previous step.

.. image:: /images/minio-console/minio-console.png
   :width: 600px
   :alt: MinIO Console Dashboard displaying Monitoring Data
   :align: center

You can use the MinIO Console for general administration tasks like
Identity and Access Management, Metrics and Log Monitoring, or 
Server Configuration. Each MinIO server includes its own embedded MinIO
Console.

Applications should use the ``https://HOST-ADDRESS:9000`` to perform S3
operations against the MinIO server.

.. _deploy-minio-standalone-multidrive-container:

Deploy Standalone Multi-Drive MinIO in a Container
--------------------------------------------------

The following procedure deploys a single MinIO container with multiple drives.

The procedure uses `Podman <https://podman.io/>`__ for running the MinIO
container in rootfull mode. Configuring for rootless mode is out of scope for
this procedure.

.. admonition:: Network File System Volumes Break Consistency Guarantees
   :class: note

   MinIO's strict **read-after-write** and **list-after-write** consistency
   model requires local disk filesystems (``xfs``, ``ext4``, etc.).

   MinIO cannot provide consistency guarantees if the underlying storage
   volumes are NFS or a similar network-attached storage volume. 

   For deployments that *require* using network-attached storage, use
   NFSv4 for best results.

1) Create a Configuration File to store Environment Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO reads configuration values from environment variables. MinIO supports
reading these environment variables from  ``/run/secrets/config.env``. Save
the ``config.env`` file as a :podman-docs:`Podman secret <secret.html>` and
specify it as part of running the container.

Create a file ``config.env`` using your preferred text editor and enter the
following environment variables:

.. code-block:: shell
   :class: copyable

   export MINIO_ROOT_USER=minio-admin
   export MINIO_ROOT_PASSWORD=minio-secret-key-CHANGE-ME
   #export MINIO_SERVER_URL=https://minio.example.net

Create the Podman secret using the ``config.env`` file:

.. code-block:: shell
   :class: copyable

   sudo podman secret create config.env config.env

The following table details each environment variable set in ``config.env``:

.. list-table::
   :widths: 40 60
   :width: 100%

   * - :envvar:`MINIO_ROOT_USER`
     - The access key for the :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string. 

   * - :envvar:`MINIO_ROOT_PASSWORD`
     - The corresponding secret key to use for the 
       :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string.

   * - :envvar:`MINIO_SERVER_URL`
     - The URL hostname the MinIO Console uses for connecting to the MinIO 
       server. This variable is *required* if specifying TLS certificates
       which **do not** contain the IP address of the MinIO Server host
       as a :rfc:`Subject Alternative Name <5280#section-4.2.1.6>`. 
       Specify a hostname covered by one of the TLS certificate SAN entries.

You may specify other :ref:`environment variables 
<minio-server-environment-variables>` as required by your deployment.

2) Add TLS Certificates
~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports enabling :ref:`Transport Layer Security (TLS) <minio-TLS>` 1.2+
automatically upon detecting a x.509 private key (``private.key``) and public
certificate (``public.crt``) in the MinIO ``certs`` directory:

Create a Podman secret pointing to the x.509 
``private.key`` and ``public.crt`` to use for the container.

.. code-block:: shell
   :class: copyable

   sudo podman secret create private.key /path/to/private.key
   sudo podman secret create public.crt /path/to/public.crt

You can optionally skip this step to deploy without TLS enabled. MinIO
strongly recommends *against* non-TLS deployments outside of early development.

3) Run the MinIO Container
~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following command to start the MinIO server in a container:

.. code-block:: shell
   :class: copyable

   sudo podman run -p 9000:9000 -p 9090:9090 \
     -v /mnt/disk-1:/mnt/disk-1 \
     -v /mnt/disk-2:/mnt/disk-2 \
     -v /mnt/disk-3:/mnt/disk-3 \
     -v /mnt/disk-4:/mnt/disk-4 \
     --secret private.key \
     --secret public.crt \
     --secret config.env \
     minio/minio server /mnt/disk-{1...4} \
     --console-address ":9090" \
     --certs-dir "/run/secrets/"

The example command breaks down as follows:

.. list-table::
   :widths: 40 60
   :width: 100%

   * - ``-p 9000:9000, -p 9090:9090``
     - Exposes the container internal port ``9000`` and ``9090`` through 
       the node port ``9000`` and ``9090`` respectively.

       Port ``9000`` is the default MinIO server listen port. 

       Port ``9090`` is the :ref:`MinIO Console <minio-console>` listen port
       specified by the ``--console-address`` argument.

   * - ``-v /mnt/disk-n:/mnt/disk-n``
     - Mounts a local volume to the container at the specified path.    
       The ``/mnt/disk-{1...4}`` uses MinIO expansion notation to denote a sequential series of drives between 1 and 4 inclusive.

   * - ``--secret ...``
     - Mounts a secret to the container. The specified secrets correspond to
       the following:

       - The x.509 private and public key the MinIO server process uses for
         enabling TLS.
  
       - The ``config.env`` file from which MinIO looks for configuration
         environment variables.

   * - ``/data``
     - The path to the container volume in which the ``minio`` server stores
       all information related to the deployment. 

       See :mc-cmd:`minio server DIRECTORIES` for more information on
       configuring the backing storage for the :mc:`minio server` process.

   * - ``--console-address ":9090"``
     - The static port on which the embedded MinIO Console listens for incoming
       connections.

       Omit to allow MinIO to select a dynamic port for the MinIO Console. 
       With dynamic port selection, browsers opening the root node hostname 
       ``https://minio1.example.com:9000`` are automatically redirected to the
       Console.

   * - ``--cert /run/secrets/``
     - Directs the MinIO server to use the ``/run/secrets/`` folder for 
       retrieving x.509 certificates to use for enabling TLS.

4) Open the MinIO Console
~~~~~~~~~~~~~~~~~~~~~~~~~

Open your browser to the DNS name or IP address corresponding to the 
container and the :ref:`MinIO Console <minio-console>` port. For example,
``https://127.0.0.1:9090``.

Log in with the :guilabel:`MINIO_ROOT_USER` and :guilabel:`MINIO_ROOT_PASSWORD`
from the previous step.

.. image:: /images/minio-console/minio-console.png
   :width: 600px
   :alt: MinIO Console Dashboard displaying Monitoring Data
   :align: center

You can use the MinIO Console for general administration tasks like
Identity and Access Management, Metrics and Log Monitoring, or 
Server Configuration. Each MinIO server includes its own embedded MinIO
Console.

Applications should use the ``https://HOST-ADDRESS:9000`` to perform S3
operations against the MinIO server.
