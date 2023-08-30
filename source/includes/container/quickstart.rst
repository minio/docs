.. _quickstart-container:

=========================
Quickstart for Containers
=========================

.. default-domain:: minio

.. container:: extlinks-video

   - `Installing and Running MinIO on Docker: Overview <https://youtu.be/mg9NRR6Js1s?ref=docs>`__
   - `Installing and Running MinIO on Docker: Installation Lab <https://youtu.be/Z0FtabDUPtU?ref=docs>`__
   - `Object Storage Essentials <https://www.youtube.com/playlist?list=PLFOIsHSSYIK3WitnqhqfpeZ6fRFKHxIr7>`__
   
   - `How to Connect to MinIO with JavaScript <https://www.youtube.com/watch?v=yUR4Fvx0D3E&list=PLFOIsHSSYIK3Dd3Y_x7itJT1NUKT5SxDh&index=5>`__

.. |OS| replace:: Docker or Podman

This procedure deploys a :ref:`Single-Node Single-Drive <minio-installation-comparison>` MinIO server onto |OS| for early development and evaluation of MinIO Object Storage and its S3-compatible API layer. 

For instructions on deploying to production environments, see :ref:`deploy-minio-distributed`.

Prerequisites
-------------

- `Podman <https://podman.io/getting-started/installation.html>`_ or `Docker <https://docs.docker.com/get-docker/>`_ installed.
- Read, write, and delete access to the folder or drive used for the persistent volume.

Procedure
---------
   
#. Start the container
   
   Select a container type to view instructions to create the container.
   Instructions are available for either GNU/Linux and MacOS or for Windows.

   .. dropdown:: Podman (Rootfull or Rootless)
      :name: podman-root-rootless
   
      These steps work for both rootfull and rootless containers.

      .. tab-set::
   
         .. tab-item:: GNU/Linux or MacOS
   
            .. code-block:: shell
               :class: copyable

               mkdir -p ~/minio/data

               podman run \
                  -p 9000:9000 \
                  -p 9090:9090 \
                  -v ~/minio/data:/data \
                  -e "MINIO_ROOT_USER=ROOTNAME" \
                  -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
                  quay.io/minio/minio server /data --console-address ":9090"
   
            The example above works this way:
   
            - ``podman run`` starts the container.
              The process is attached to the terminal session and ends when exiting the terminal.
            - ``-p`` binds a local port to a container port.
            - ``-v`` sets a file path as a persistent volume location for the container to use.
              When MinIO writes data to ``/data``, that data mirrors to the local path ``~/minio/data``, allowing it to persist between container restarts.
              You can set any file path to which the user has read, write, and delete permissions to use.
            - ``-e`` sets the environment variables :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD`, respectively.
              These set the :ref:`root user credentials <minio-users-root>`.
              Change the example values to use for your container.
   
         .. tab-item:: Windows
   
            .. code-block:: shell
               :class: copyable
   
               podman run \
                  -p 9000:9000 \
                  -p 9090:9090 \
                  -v D:\minio\data:/data \
                  -e "MINIO_ROOT_USER=ROOTNAME" \
                  -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
                  quay.io/minio/minio server /data --console-address ":9090"
   
            The example above works this way:
   
            - ``podman run`` starts the container.
            - ``-p`` binds a local port to a container port.
            - ``-v`` sets a file path as a persistent volume location for the container to use.
              When MinIO writes data to ``/data``, that data mirrors to the local path ``D:\minio\data``, allowing it to persist between container restarts.
              You can set any file path to which the user has read, write, and delete permissions to use.
            - ``-e`` sets the environment variables :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD`, respectively.
              These set the :ref:`root user credentials <minio-users-root>`.
              Change the example values to use for your container.
   
   .. dropdown:: Docker (Rootfull)
      :name: docker-rootfull
   
      .. tab-set::
   
         .. tab-item:: GNU/Linux or MacOS
   
            .. code-block:: shell
               :class: copyable
   
               mkdir -p ~/minio/data
   
               docker run \
                  -p 9000:9000 \
                  -p 9090:9090 \
                  --name minio \
                  -v ~/minio/data:/data \
                  -e "MINIO_ROOT_USER=ROOTNAME" \
                  -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
                  quay.io/minio/minio server /data --console-address ":9090"
         
            The example above works this way:
   
            - ``mkdir`` creates a new local directory at ``~/minio/data`` in your home directory.
            - ``docker run`` starts the MinIO container.
            - ``-p`` binds a local port to a container port.
            - ``-name`` creates a name for the container.
            - ``-v`` sets a file path as a persistent volume location for the container to use.
              When MinIO writes data to ``/data``, that data mirrors to the local path ``~/minio/data``, allowing it to persist between container restarts.
              You can replace ``~/minio/data`` with another local file location to which the user has read, write, and delete access.
            - ``-e`` sets the environment variables :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD`, respectively.
              These set the :ref:`root user credentials <minio-users-root>`.
              Change the example values to use for your container.
                 
         .. tab-item:: Windows
   
            .. code-block:: shell
               :class: copyable
   
               docker run \
                  -p 9000:9000 \
                  -p 9090:9090 \
                  --name minio1 \
                  -v D:\minio\data:/data \
                  -e "MINIO_ROOT_USER=ROOTUSER" \
                  -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
                  quay.io/minio/minio server /data --console-address ":9090"
               
            The example above works this way:
   
            - ``docker run`` starts the MinIO container.
            - ``-p`` binds a local port to a container port.
            - ``-v`` sets a file path as a persistent volume location for the container to use.
              When MinIO writes data to ``/data``, that data mirrors to the local path ``D:\minio\data``, allowing it to persist between container restarts.
              You can replace ``D:\minio\data`` with another local file location to which the user has read, write, and delete access.
            - ``-e`` sets the environment variables :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD`, respectively.
              These set the :ref:`root user credentials <minio-users-root>`.
              Change the example values to use for your container.
            
   .. dropdown:: Docker (Rootless)
      :name: docker-rootless
   
      .. tab-set::
   
         .. tab-item:: GNU/Linux or MacOS
   
            .. code-block:: shell
               :class: copyable
   
               mkdir -p ${HOME}/minio/data
   
               docker run \
                  -p 9000:9000 \
                  -p 9090:9090 \
                  --user $(id -u):$(id -g) \
                  --name minio1 \
                  -e "MINIO_ROOT_USER=ROOTUSER" \
                  -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
                  -v ${HOME}/minio/data:/data \
                  quay.io/minio/minio server /data --console-address ":9090"
         
            The example above works this way:
   
            - ``mkdir`` creates a new local directory at ``~/minio/data`` in your home directory.
            - ``docker run`` starts the MinIO container.
            - ``-p`` binds a local port to a container port.
            - ``-user`` sets the username for the container to the policies for the current user and user group.
            - ``-name`` creates a name for the container.
            - ``-v`` sets a file path as a persistent volume location for the container to use.
              When MinIO writes data to ``/data``, that data actually writes to the local path ``~/minio/data`` where it can persist between container restarts.
              You can replace ``${HOME}/minio/data`` with another location in the user's home directory to which the user has read, write, and delete access.
            - ``-e`` sets the environment variables :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD`, respectively.
              These set the :ref:`root user credentials <minio-users-root>`.
              Change the example values to use for your container.
                 
         .. tab-item:: Windows

            Prerequisite:

            - Windows `Group Managed Service Account <https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/manage-serviceaccounts>`_ already defined.
   
            .. code-block:: shell
               :class: copyable
   
               docker run \
                  -p 9000:9000 \
                  -p 9090:9090 \
                  --name minio1 \
                  --security-opt "credentialspec=file://path/to/file.json"
                  -e "MINIO_ROOT_USER=ROOTUSER" \
                  -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
                  -v D:\data:/data \
                  quay.io/minio/minio server /data --console-address ":9090"
   
            The example above works this way:
   
            - ``docker run`` starts the MinIO container.
            - ``-p`` binds a local port to a container port.
            - ``-name`` creates a name for the container.
            - ``--security-opt`` grants access to the container via a ``credentialspec`` file for a `Group Managed Service Account (gMSA) <https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/gmsa-run-container>`_ 
            - ``-v`` sets a file path as a persistent volume location for the container to use.
              When MinIO writes data to ``/data``, that data actually writes to the local path ``D:\data`` where it can persist between container restarts.
              You can replace ``D:\data`` with another local file location to which the user has read, write, and delete access.
            - ``-e`` sets the environment variables :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD`, respectively.
              These set the :ref:`root user credentials <minio-users-root>`.
              Change the example values to use for your container.

#. Connect your Browser to the MinIO Server

   Access the :ref:`minio-console` by going to a browser and going to ``http://127.0.0.1:9000`` or one of the Console addresses specified in the :mc:`minio server` command's output.
   For example, :guilabel:`Console: http://192.0.2.10:9090 http://127.0.0.1:9090` in the example output indicates two possible addresses to use for connecting to the Console.

   While port ``9000`` is used for connecting to the API, MinIO automatically redirects browser access to the MinIO Console.

   Log in to the Console with the credentials you defined in the :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD` environment variables.

   .. image:: /images/minio-console/console-login.png
      :width: 600px
      :alt: MinIO Console displaying login screen
      :align: center

   You can use the MinIO Console for general administration tasks like Identity and Access Management, Metrics and Log Monitoring, or Server Configuration. 
   Each MinIO server includes its own embedded MinIO Console.

   .. image:: /images/minio-console/minio-console.png
      :width: 600px
      :alt: MinIO Console displaying bucket start screen
      :align: center

   For more information, see the :ref:`minio-console` documentation.

#. `(Optional)` Install the MinIO Client

   The :ref:`MinIO Client <minio-client>` allows you to work with your MinIO volume from the commandline.

   Select your operating system for instructions.

   .. dropdown:: GNU/Linux

      The :ref:`MinIO Client <minio-client>` allows you to work with your MinIO server from the commandline.

      Download the :mc:`mc` client and install it to a location on your system ``PATH`` such as 
      ``/usr/local/bin``. You can alternatively run the binary from the download location.

      .. code-block:: shell
         :class: copyable
         
         wget https://dl.min.io/client/mc/release/linux-amd64/mc
         chmod +x mc
         sudo mv mc /usr/local/bin/mc
   
      Use :mc:`mc alias set` to create a new alias associated to your local deployment.
      You can run :mc:`mc` commands against this alias:

      .. code-block:: shell
         :class: copyable
      
         mc alias set local http://127.0.0.1:9000 {MINIO_ROOT_USER} {MINIO_ROOT_PASSWORD}
         mc admin info local

      Replace ``{MINIO_ROOT_USER}`` and ``{MINIO_ROOT_PASSWORD}`` with the credentials you defined for the container with the ``-e`` flags.
      
      The :mc:`mc alias set` takes four arguments:
   
      - The name of the alias
      - The hostname or IP address and port of the MinIO server
      - The Access Key for a MinIO :ref:`user <minio-users>`
      - The Secret Key for a MinIO :ref:`user <minio-users>`

      For additional details about this command, see :ref:`alias`.

   .. dropdown:: MacOS

      The :ref:`MinIO Client <minio-client>` allows you to work with your MinIO volume from the commandline.
      
      .. tab-set::
      
         .. tab-item:: Homebrew
      
            Run the following command to install the latest stable MinIO Client package using `Homebrew <https://brew.sh>`_.
      
            .. code-block:: shell
               :class: copyable
      
               brew install minio/stable/mc

         .. tab-item:: Binary (arm64)
      
            Run the following commands to install the latest stable MinIO Client package using a binary package for Apple chips.

            .. code-block:: shell
               :class: copyable

               curl -O https://dl.min.io/client/mc/release/darwin-arm64/mc
               chmod +x mc
               sudo mv mc /usr/local/bin/mc

         .. tab-item:: Binary (amd64)
                       
            Run the following commands to install the latest stable MinIO Client package using a binary package for Intel chips.

            .. code-block:: shell
               :class: copyable

               curl -O https://dl.min.io/client/mc/release/darwin-amd64/mc
               chmod +x mc
               sudo mv mc /usr/local/bin/mc
      
      Use :mc:`mc alias set` to quickly authenticate and connect to the MinIO deployment.
      
      .. code-block:: shell
         :class: copyable
      
         mc alias set local http://127.0.0.1:9000 {MINIO_ROOT_USER} {MINIO_ROOT_PASSWORD}
         mc admin info local
      
      Replace ``{MINIO_ROOT_USER}`` and ``{MINIO_ROOT_PASSWORD}`` with the credentials you defined for the container with the ``-e`` flags.

      The :mc:`mc alias set` takes four arguments:
   
      - The name of the alias
      - The hostname or IP address and port of the MinIO server
      - The Access Key for a MinIO :ref:`user <minio-users>`
      - The Secret Key for a MinIO :ref:`user <minio-users>`

      For additional details about this command, see :ref:`alias`.
      
   .. dropdown:: Windows
   
      Download the standalone MinIO server for Windows from the following link:
   
      https://dl.min.io/client/mc/release/windows-amd64/mc.exe
   
      Double click on the file to run it.
      Or, run the following in the Command Prompt or PowerShell.
      
      .. code-block::
         :class: copyable
   
         \path\to\mc.exe --help
         
      Use :mc:`mc alias set` to quickly authenticate and connect to the MinIO deployment.
   
      .. code-block:: shell
         :class: copyable
   
         mc.exe alias set local http://127.0.0.1:9000 {MINIO_ROOT_USER} {MINIO_ROOT_PASSWORD}
         mc.exe admin info local
   
      Replace ``{MINIO_ROOT_USER}`` and ``{MINIO_ROOT_PASSWORD}`` with the credentials you defined for the container with the ``-e`` flags.
      
      The :mc:`mc alias set` takes four arguments:
   
      - The name of the alias
      - The hostname or IP address and port of the MinIO server
      - The Access Key for a MinIO :ref:`user <minio-users>`
      - The Secret Key for a MinIO :ref:`user <minio-users>`

      For additional details about this command, see :ref:`alias`.

.. rst-class:: section-next-steps

Next Steps
----------

- :ref:`Connect your applications to MinIO <minio-drivers>`
- :ref:`Configure Object Retention <minio-object-retention>`
- :ref:`Configure Security <minio-authentication-and-identity-management>`
- :ref:`Deploy MinIO in a Distrbuted Environment <deploy-minio-distributed>`