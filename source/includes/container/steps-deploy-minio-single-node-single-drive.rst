1) Pull the Latest Stable Image of MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/container/common-deploy.rst
   :start-after: start-common-deploy-pull-latest-minio-image
   :end-before: end-common-deploy-pull-latest-minio-image

2) Create the Environment Variable File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-deploy.rst
   :start-after: start-common-deploy-create-environment-file-single-drive 
   :end-before: end-common-deploy-create-environment-file-single-drive

.. include:: /includes/common/common-deploy.rst
   :start-after: start-common-deploy-create-unique-root-credentials 
   :end-before: end-common-deploy-create-unique-root-credentials

3) Create and Run the Container
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Select the container management interface of your choice for the relevant command syntax.

.. tab-set::

   .. tab-item:: Podman

      Copy the command to a text file for further modification.

      .. code-block:: shell
         :class: copyable

         podman run -dt                                  \
           -p 9000:9000 -p 9001:9001                     \
           -v PATH:/mnt/data                             \
           -v /etc/default/minio:/etc/config.env         \
           -e "MINIO_CONFIG_ENV_FILE=/etc/config.env"    \
           --name "minio_local"                          \
           minio server --console-address ":9001"

      Specify any other :podman-docs:`options <markdown/podman-run.1.html>` to ``podman run`` as necessary for your local environment.

   .. tab-item:: Docker

      Copy the command to a text file for further modification.

      .. code-block:: shell
         :class: copyable

         docker run -dt                                  \
           -p 9000:9000 -p 9001:9001                     \
           -v PATH:/mnt/data                             \
           -v /etc/default/minio:/etc/config.env         \
           -e "MINIO_CONFIG_ENV_FILE=/etc/config.env"    \
           --name "minio_local"                          \
           minio server --console-address ":9001"

      Specify any other `options <https://docs.docker.com/engine/reference/commandline/run/>`__ to ``docker run`` as necessary for your local environment.

      For running Docker in Rootless mode, you may need to set the following additional Docker CLI options:

      Linux
         ``--user $(id -u):$(id -g)`` - directs the container to run as the currently logged in user.
      
      Windows
         ``--security-opt "credentialspec=file://path/to/file.json"`` - directs the container to run using a Windows `Group Managed Service Account <https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/manage-serviceaccounts>`_.

The following table describes each line of the command and provides additional configuration instructions:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Line
     - Description

   * - | ``podman run -dt``
       | ``docker run -dt``
     - Directs Podman/Docker to create and start the container as a detached (``-d``) background process with a pseudo-TTY (``-t``).
       This allows the container to run in the background with an open TTY for bash-like access.

   * - ``-p 9000:9000 -p 9001:9001``
     - Binds the ports ``9000`` and ``9001`` on the local machine to the same ports on the container.
       This allows access to the container through the local machine.

   * - ``-v PATH:/data/minio``
     - Binds the storage volume ``PATH`` on the local machine to the ``/data`` path on the container.
       Replace this value with the full path to a storage volume or folder on the local machine.
       For example:

       Linux or macOS
         ``~/minio/data/``
       
       Windows
         ``C:\minio\data``

   * - ``-v /etc/default/minio:/etc/config.env``
     - Mounts the environment file created in the previous step to the ``/etc/config.env`` path on the Container.
       For Windows hosts, specify the Windows-style path ``-v C:\minio\config:/etc/config.env``.
         
       The MinIO Server uses this environment file for configuration.
         
   * - ``-e "MINIO_CONFIG_ENV_FILE=/etc/config.env"``
     - Sets a MinIO environment variable pointing to the container-mounted path of the environment file.

   * - ``--name "minio_local"``
     - Sets a custom name for the container. 
       Omit this value to allow Podman/Docker to automatically generate a container name.
       You can replace this value to best reflect your requirements.

   * - ``minio server --console-address ":9001"``
     - Starts the MinIO server using the ``minio:minio`` image pulled from an earlier step.
       The :mc-cmd:`minio server --console-address ":9001" <minio server --console-address>` option directs the server to set a static port for the MinIO Console Web Interface.
       This option is *required* for containerized environments.

       If you modify this value, ensure you set the proper port mapping using the ``-p`` flag to Podman/Docker to ensure traffic forwarding between the local host and the container.

Once you have applied any further customizations to the command, run it in your preferred terminal or shell environment.
The command should return a unique ID for the created container.

4) Validate the Container Status
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/container/common-deploy.rst
   :start-after: start-common-deploy-validate-container-status
   :end-before: end-common-deploy-validate-container-status

.. code-block:: shell

   Status:         1 Online, 0 Offline. 
   API: http://10.0.2.100:9000  http://127.0.0.1:9000       
   RootUser: myminioadmin 
   RootPass: minio-secret-key-change-me 
   Console: http://10.0.2.100:9001 http://127.0.0.1:9001    
   RootUser: myminioadmin 
   RootPass: minio-secret-key-change-me 

   Command-line: https://docs.min.io/community/minio-object-store/reference/minio-mc.html
      $ mc alias set myminio http://10.0.2.100:9000 myminioadmin minio-secret-key-change-me

   Documentation: https://docs.min.io/community/minio-object-store/operations/deployments/baremetal-deploy-minio-as-a-container.html

.. admonition:: Container Networks May Not Be Accessible Outside of the Host

   The ``API`` and ``CONSOLE`` blocks may include the network interfaces for the container.
   Clients outside of the container network cannot access the MinIO API or Console using these addresses.

   External access requires using a network address for the container host machine and assumes the host firewall allows access to the related ports (``9000`` and ``9001`` in the examples).

5) Connect to the MinIO Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/container/common-deploy.rst
   :start-after: start-common-deploy-connect-to-minio-service
   :end-before: end-common-deploy-connect-to-minio-service
