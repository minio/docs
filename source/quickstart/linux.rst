.. _quickstart-linux:

====================
Quickstart for Linux
====================

.. default-domain:: minio

.. |OS| replace:: Linux

This procedure deploys a :ref:`Standalone <minio-installation-comparison>` MinIO server onto |OS| for early development and evaluation of MinIO Object Storage and it's S3-compatible API layer. 

For instructions on deploying to production environments, see :ref:`deploy-minio-distributed`.

Prerequisites
-------------

- Read, Write and Execute permissions on your local user folder (e.g. ``~/minio``).
- Permission to install binaries to the system ``PATH`` (e.g. access to ``/usr/local/bin``).
- Familiarity with the Linux terminal or shell (Bash, ZSH, etc.).
- A 64-bit Linux OS (e.g. RHEL 8, Ubuntu LTS releases).

Procedure
---------

#. **Install the MinIO Server**

   .. include:: /includes/common-installation.rst
      :start-after: start-install-minio-binary-desc
      :end-before: end-install-minio-binary-desc

#. **Launch the MinIO Server**

   Run the following command from the system terminal or shell to start a local MinIO instance using the ``~/minio`` folder. You can replace this path with another folder path on the local machine:

   .. code-block:: shell
      :class: copyable

      mkdir ~/minio
      minio server ~/minio --console-address :9090

   The ``mkdir`` command creates the folder explicitly at the specified path.

   The ``minio server`` command starts the MinIO server. The path argument
   ``~/minio`` identifies the folder in which the server operates.

   The :mc:`minio server` process prints its output to the system console, similar to the following:

   .. code-block:: shell

      API: http://192.0.2.10:9000  http://127.0.0.1:9000
      RootUser: minioadmin
      RootPass: minioadmin

      Console: http://192.0.2.10:9090 http://127.0.0.1:9090
      RootUser: minioadmin
      RootPass: minioadmin

      Command-line: https://docs.min.io/docs/minio-client-quickstart-guide
         $ mc alias set myminio http://192.0.2.10:9000 minioadmin minioadmin

      Documentation: https://docs.min.io

      WARNING: Detected default credentials 'minioadmin:minioadmin', we recommend that you change these values with 'MINIO_ROOT_USER' and 'MINIO_ROOT_PASSWORD' environment variables.

#. **Connect Your Browser to the MinIO Server**

   Open http://127.0.0.1:9000 in a web browser to access the :ref:`MinIO Console <minio-console>`. 
   You can alternatively enter any of the network addresses specified as part of the server command output.
   For example, :guilabel:`Console: http://192.0.2.10:9090 http://127.0.0.1:9090` in the example output indicates two possible addresses to use for connecting to the Console.

   While the port ``9000`` is used for connecting to the API, MinIO automatically redirects browser access to the MinIO Console.

   Log in to the Console with the ``RootUser`` and ``RootPass`` user credentials displayed in the output.
   These default to ``minioadmin | minioadmin``.

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

#. `(Optional)` **Install the MinIO Client**

   The :ref:`MinIO Client <minio-client>` allows you to work with your MinIO server from the commandline.

   Download the :mc:`mc` client and install it to a location on your system ``PATH`` such as 
   ``/usr/local/bin``. You can alternatively run the binary from the download location.

   .. code-block:: shell
      :class: copyable

      wget https://dl.min.io/client/mc/release/linux-amd64/mc
      chmod +x mc
      sudo mv mc /usr/local/bin/mc

   Use :mc-cmd:`mc alias set` to create a new alias associated to your local deployment.
   You can run :mc-cmd:`mc` commands against this alias:

   .. code-block:: shell
      :class: copyable

      mc alias set local http://127.0.0.1:9000 minioadmin minioadmin
      mc admin info local

   The :mc-cmd:`mc alias set` takes four arguments:

   - The name of the alias
   - The hostname or IP address and port of the MinIO server
   - The Access Key for a MinIO :ref:`user <minio-users>`
   - The Secret Key for a MinIO :ref:`user <minio-users>`

   The example above uses the :ref:`root user <minio-users-root>`.

Next Steps
----------

- :ref:`Connect your applications to MinIO <minio-drivers>`
- :ref:`Configure Object Retention <minio-object-retention>`
- :ref:`Configure Security <minio-authentication-and-identity-management>`
- :ref:`Deploy MinIO for Production Environments <deploy-minio-distributed>`
