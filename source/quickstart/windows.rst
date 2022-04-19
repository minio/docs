.. _quickstart-windows:

======================
Quickstart for Windows
======================

.. default-domain:: minio

.. |OS| replace:: Windows

This procedure deploys a :ref:`Standalone <minio-installation-comparison>` MinIO server onto |OS| for early development and evaluation of MinIO Object Storage and it's S3-compatible API layer. 

Standalone deployments (also called "filesystem mode") support a :ref:`subset of MinIO features <minio-installation-comparison>` where redundancy or availability are dependent entirely on the underlying drive or volume.

For instructions on deploying to production environments, see :ref:`deploy-minio-distributed`.

Prerequisites
-------------

- Read, write, and execute permissions for the preferred local directory or file path
- Familiarity with using the Command Prompt or PowerShell

Procedure
---------

#. Install the MinIO Server

   Download the MinIO executable from the following URL:

   .. code-block:: shell
      :class: copyable

      https://dl.min.io/server/minio/release/windows-amd64/minio.exe
      
   The next step includes instructions for running the executable. 
   You cannot run the executable from the Explorer or by double clicking the file.
   Instead, you call the executable to launch the server.

#. Launch the :mc:`minio server`

   In PowerShell or the Command Prompt, navigate to the location of the executable or add the path of the ``minio.exe`` file to the system ``$PATH``.
   
   Use this command to start a local MinIO instance in the ``C:\minio`` folder.
   You can replace ``C:\minio`` with another drive or folder path on the local computer.

   .. code-block::
      :class: copyable

      .\minio.exe server C:\minio --console-address :9090

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
   
   The process is tied to the current PowerShell or Command Prompt window.
   Closing the window stops the server and ends the process.

#. Connect your Browser to the MinIO Server

   Access the :ref:`minio-console` by going to a browser (such as Microsoft Edge) and going to ``http://127.0.0.1:9000`` or one of the Console addresses specified in the :mc:`minio server` command's output.
   For example, :guilabel:`Console: http://192.0.2.10:9090 http://127.0.0.1:9090` in the example output indicates two possible addresses to use for connecting to the Console.

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

   Download the standalone MinIO server for Windows from the following link:

   https://dl.min.io/client/mc/release/windows-amd64/mc.exe

   Double click on the file to run it.
   Or, run the following in the Command Prompt or PowerShell.
   
   .. code-block::
      :class: copyable

      \path\to\mc.exe --help
      
   Use :mc-cmd:`mc.exe alias set <mc alias set>` to quickly authenticate and connect to the MinIO deployment.

   .. code-block:: shell
      :class: copyable

      mc.exe alias set local http://127.0.0.1:9000 minioadmin minioadmin
      mc.exe admin info local

   The :mc-cmd:`mc.exe alias set <mc alias set>` takes four arguments:

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
