.. _quickstart-macos:

=======================
Quickstart for Mac OSX
=======================

.. default-domain:: minio

.. |OS| replace:: MacOS

Use the procedures on this page to deploy MinIO in :guilabel:`Standalone Mode` on a single local |OS| harddrive as a single MinIO server process (what we call "filesystem mode") with a :ref:`subset of S3 features<minio-installation-comparison>`.
The MinIO server provides an S3 access layer to the drive or volume with no :ref:`erasure coding <minio-erasure-coding>` or associated features.

Use :guilabel:`Standalone Mode` for early development and evaluation environments.
For instructions on deploying to production environments, see :ref:`deploy-minio-distributed`.

Prerequisites
-------------

- Read, write, and execute permissions for the user's home directory
- Familiarity with using the Terminal

Procedure
---------

#. Install the MinIO Server

   .. tab-set::
   
      .. tab-item:: Binary
         
         Open a Terminal, then use the following commands to download the standalone MinIO server for MacOS and make it executable.

         .. grid:: 2

            .. grid-item-card:: Apple Silicon

               .. code-block:: shell
                  :class: copyable

                  curl -O https://dl.min.io/server/minio/release/darwin-arm64/minio
                  chmod +x minio   
                 
            .. grid-item-card:: Intel
            
               .. code-block:: shell
                  :class: copyable

                  curl -O https://dl.min.io/server/minio/release/darwin-amd64/minio
                  chmod +x minio

      .. tab-item:: Homebrew

         Open a Terminal and run the following command to install the latest stable MinIO package using `Homebrew <https://brew.sh>`_.

         .. code-block:: shell
            :class: copyable

            brew install minio/stable/minio

         .. important::

            If you previously installed the MinIO server using ``brew install minio``, then we recommend that you reinstall from ``minio/stable/minio`` instead.

            .. code-block:: shell
               :class: copyable

               brew uninstall minio
               brew install minio/stable/minio

#. Launch the :mc:`minio server`

   From the Terminal, use this command to start a local MinIO instance in the ``~/data`` folder.
   If desired, you can replace ``~/data`` with another location to which the user has read, write, and delete access for the MinIO instance.

   .. code-block:: shell
      :class: copyable

      ~/minio server ~/data

   If you installed with Homebrew, do not include the ``~/`` at the beginning of the command.

   The :mc:`minio server` process prints its output to the system console, similar to the following:

   .. code-block:: shell

      API: http://192.0.2.10:9000  http://127.0.0.1:9000
      RootUser: minioadmin
      RootPass: minioadmin

      Console: http://192.0.2.10:9001 http://127.0.0.1:9001
      RootUser: minioadmin
      RootPass: minioadmin

      Command-line: https://docs.min.io/docs/minio-client-quickstart-guide
         $ mc alias set myminio http://192.0.2.10:9000 minioadmin minioadmin

      Documentation: https://docs.min.io

      WARNING: Detected default credentials 'minioadmin:minioadmin', we recommend that you change these values with 'MINIO_ROOT_USER' and 'MINIO_ROOT_PASSWORD' environment variables.

#. Connect your Browser to the MinIO Server

   Access the :ref:`minio-console` by going to a browser (such as Safari) and going to ``https://127.0.0.1:9000`` or one of the Console addresses specified in the :mc:`minio server` command's output.
   For example, :guilabel:`Console: http://192.0.2.10:9001 http://127.0.0.1:9001` in the example output indicates two possible addresses to use for connecting to the Console.

   While port ``9000`` is used for connecting to the API, MinIO automatically redirects browser access to the MinIO Console.

   Log in to the Console with the ``RootUser`` and ``RootPass`` user credentials displayed in the output.
   These default to ``minioadmin | minioadmin``.

   .. image:: /images/minio-console-login.png
      :width: 600px
      :alt: MinIO Console displaying login screen
      :align: center

   You can use the MinIO Console for general administration tasks like Identity and Access Management, Metrics and Log Monitoring, or Server Configuration. 
   Each MinIO server includes its own embedded MinIO Console.

   .. image:: /images/minio-console-buckets.png
      :width: 600px
      :alt: MinIO Console displaying bucket start screen
      :align: center

   For more information, see the :ref:`minio-console` documentation.

#. `(Optional)` Install the MinIO Client

   The :ref:`MinIO Client <minio-client>` allows you to work with your MinIO volume from the commandline.

   .. tab-set::

      .. tab-item:: Binary

         Download the standalone MinIO server for MacOS and make it executable.

         .. grid:: 2

            .. grid-item-card:: Apple Silicon
           
               .. code-block:: shell
                  :class: copyable

                  curl -O https://dl.min.io/client/mc/release/darwin-arm64/mc
                  chmod +x mc
                  sudo mv mc /usr/local/bin/mc
   
            .. grid-item-card:: Intel
                        
               .. code-block:: shell
                  :class: copyable

                  curl -O https://dl.min.io/client/mc/release/darwin-amd64/mc
                  chmod +x mc
                  sudo mv mc /usr/local/bin/mc

         To use the command, run 
         
         .. code-block:: shell
            
            mc {command} {flag}

      .. tab-item:: Homebrew

         Run the following commands to install the latest stable MinIO Client package using `Homebrew <https://brew.sh>`_.

         .. code-block:: shell
            :class: copyable

            brew install minio/stable/mc

         To use the command, run 
         
         .. code-block::
            
            mc {command} {flag}

   Use :mc-cmd:`mc alias set` to quickly authenticate and connect to the MinIO deployment.

   .. code-block:: shell
      :class: copyable

      mc alias set local http://127.0.0.1:9000 minioadmin minioadmin
      mc admin info local

   The :mc-cmd:`mc alias set` takes four arguments:

   - The name of the alias
   - The hostname or IP address and port of the MinIO server
   - The Access Key for a MinIO :ref:`user <minio-users>`
   - The Secret Key for a MinIO :ref:`user <minio-users>`

   For additional details about this command, see :ref:`alias`.

Next Steps
----------

- :ref:`Connect your applications to MinIO <minio-drivers>`
- :ref:`Configure Object Retention <minio-object-retention>`
- :ref:`Configure Security <minio-authentication-and-identity-management>`
- :ref:`Deploy MinIO for Production Environments <deploy-minio-distributed>`
