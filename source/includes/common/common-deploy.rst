.. start-common-deploy-create-environment-file-single-drive

Create an environment variable file at ``/etc/default/minio``.
For Windows hosts, specify a Windows-style path similar to ``C:\minio\config``.
The MinIO Server container can use this file as the source of all :ref:`environment variables <minio-server-environment-variables>`.

The following example provides a starting environment file:

.. code-block:: shell
   :class: copyable

   # MINIO_ROOT_USER and MINIO_ROOT_PASSWORD sets the root account for the MinIO server.
   # This user has unrestricted permissions to perform S3 and administrative API operations on any resource in the deployment.
   # Omit to use the default values 'minioadmin:minioadmin'.
   # MinIO recommends setting non-default values as a best practice, regardless of environment

   MINIO_ROOT_USER=myminioadmin
   MINIO_ROOT_PASSWORD=minio-secret-key-change-me

   # MINIO_VOLUMES sets the storage volume or path to use for the MinIO server.

   MINIO_VOLUMES="/mnt/data"

   # MINIO_SERVER_URL sets the hostname of the local machine for use with the MinIO Server
   # MinIO assumes your network control plane can correctly resolve this hostname to the local machine

   # Uncomment the following line and replace the value with the correct hostname for the local machine.

   #MINIO_SERVER_URL="http://minio.example.net:9000"

Include any other environment variables as required for your local deployment.

.. end-common-deploy-create-environment-file-single-drive

.. start-common-deploy-create-environment-file-multi-drive

Create an environment variable file at ``/etc/default/minio``.
For Windows hosts, specify a Windows-style path similar to ``C:\minio\config``.
The MinIO Server container can use this file as the source of all :ref:`environment variables <minio-server-environment-variables>`.

The following example provides a starting environment file:

.. code-block:: shell
   :class: copyable

   # MINIO_ROOT_USER and MINIO_ROOT_PASSWORD sets the root account for the MinIO server.
   # This user has unrestricted permissions to perform S3 and administrative API operations on any resource in the deployment.
   # Omit to use the default values 'minioadmin:minioadmin'.
   # MinIO recommends setting non-default values as a best practice, regardless of environment.

   MINIO_ROOT_USER=myminioadmin
   MINIO_ROOT_PASSWORD=minio-secret-key-change-me

   # MINIO_VOLUMES sets the storage volumes or paths to use for the MinIO server.
   # The specified path uses MinIO expansion notation to denote a sequential series of drives between 1 and 4, inclusive.
   # All drives or paths included in the expanded drive list must exist *and* be empty or freshly formatted for MinIO to start successfully.

   MINIO_VOLUMES="/data-{1...4}"

   # MINIO_SERVER_URL sets the hostname of the local machine for use with the MinIO Server.
   # MinIO assumes your network control plane can correctly resolve this hostname to the local machine.

   # Uncomment the following line and replace the value with the correct hostname for the local machine.

   #MINIO_SERVER_URL="http://minio.example.net"

Include any other environment variables as required for your local deployment.
.. end-common-deploy-create-environment-file-multi-drive

.. start-common-deploy-connect-to-minio-deployment

.. tab-set::

   .. tab-item:: MinIO Console

      You can access the MinIO Console by entering any of the hostnames or IP addresses from the MinIO server ``Console`` block in your preferred browser, such as http://localhost:9090.

      Log in with the :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD` configured in the environment file specified to the container.

      .. image:: /images/minio-console/console-bucket-none.png
         :width: 600px
         :alt: MinIO Console displaying Buckets view in a fresh installation
         :align: center

      You can use the MinIO Console for general administration tasks like Identity and Access Management, Metrics and Log Monitoring, or Server Configuration. Each MinIO server includes its own embedded MinIO Console.

      If your local host firewall permits external access to the Console port, other hosts on the same network can access the Console using the IP or hostname for your local host.

   .. tab-item:: MinIO CLI (mc)

      You can access the MinIO deployment over a Terminal or Shell using the :ref:`MinIO Client <minio-client>` (:mc:`mc`).
      See :ref:`MinIO Client Installation Quickstart <mc-install>` for instructions on installing :mc:`mc`.

      Create a new :mc:`alias <mc alias set>` corresponding to the MinIO deployment. 
      Specify any of the hostnames or IP addresses from the MinIO Server ``API`` block, such as http://localhost:9000.

      .. code-block:: shell
         :class: copyable

         mc alias set http://localhost:9000 myminioadmin minio-secret-key-change-me

      Replace ``myminioadmin`` and ``minio-secret-key-change-me`` with the :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD` values in the environment file specified to the container.

      You can then interact with the container using any :mc:`mc` command.
      If your local host firewall permits external access to the MinIO S3 API port, other hosts on the same network can access the MinIO deployment using the IP or hostname for your local host.

.. end-common-deploy-connect-to-minio-deployment
