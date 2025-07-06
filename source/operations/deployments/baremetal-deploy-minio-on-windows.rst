.. _deploy-minio-windows:

=======================
Deploy MinIO on Windows
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. container:: extlinks-video

   - `Object Storage Essentials <https://www.youtube.com/playlist?list=PLFOIsHSSYIK3WitnqhqfpeZ6fRFKHxIr7>`__
   
   - `How to Connect to MinIO with JavaScript <https://www.youtube.com/watch?v=yUR4Fvx0D3E&list=PLFOIsHSSYIK3Dd3Y_x7itJT1NUKT5SxDh&index=5>`__

This page documents deploying MinIO onto Microsoft Windows hosts.

MinIO officially supports Windows operating systems in the Active Support of the Microsoft Modern Lifecycle Policy.

At the time of writing, that includes:

- Windows Server 23H2 (**Recommended**)
- Windows Server 2022 LTSC 
- Windows 11 Enterprise/Workstation 23H2
- Windows 11 Enterprise/Workstation 22H2
- Windows 10 Enterprise 21H2 (LTS)
- Windows 10 IoT 21H2 (LTS)
- Windows 10 Enterprise 22H2

MinIO *may* run on older or out-of-support Windows releases, with limited support or troubleshooting from either MinIO or Microsoft.

The procedure includes guidance for deploying Single-Node Multi-Drive (SNMD) and Single-Node Single-Drive (SNSD) topologies in support of early development and evaluation environments.

MinIO does not officially support Multi-Node Multi-Drive (MNMD) "Distributed" configurations on Windows hosts.

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

Procedure
---------

1. Download the MinIO Binary
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Download the MinIO executable from the following URL:

.. code-block:: shell
   :class: copyable

   https://dl.min.io/server/minio/release/windows-amd64/minio.exe
   
The next step includes instructions for running the executable. 
You cannot run the executable from the Explorer or by double clicking the file.
Instead, you call the executable to launch the server.

2. Launch the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~


In PowerShell or the Command Prompt, navigate to the location of the executable or add the path of the ``minio.exe`` file to the system ``$PATH``.
computer.

.. tab-set::

   .. tab-item:: Multi-Drive

      For Windows hosts with multiple drives, you can specify a sequential set of drives to use for configuring MinIO in the Single-Node Multi-Drive (SNMD) topology:

      .. code-block::
         :class: copyable

         .\minio.exe server {D...G}:\minio --console-address :9001

      The :mc:`minio server` process prints its output to the system console, similar to the following:

      .. code-block:: shell

         API: http://192.0.2.10:9000  http://127.0.0.1:9000
         RootUser: minioadmin
         RootPass: minioadmin

         Console: http://192.0.2.10:9001 http://127.0.0.1:9001
         RootUser: minioadmin
         RootPass: minioadmin

         Command-line: https://min.io/docs/minio/linux/reference/minio-mc.html
            $ mc alias set myminio http://192.0.2.10:9000 minioadmin minioadmin

         Documentation: https://min.io/docs/minio/linux/index.html

         WARNING: Detected default credentials 'minioadmin:minioadmin', we recommend that you change these values with 'MINIO_ROOT_USER' and 'MINIO_ROOT_PASSWORD' environment variables.

      The process is tied to the current PowerShell or Command Prompt window.
      Closing the window stops the server and ends the process.

   .. tab-item:: Single-Drive

      Use this command to start a local MinIO instance in the ``C:\minio`` folder.
      You can replace ``C:\minio`` with another drive or folder path on the local 

      .. code-block::
         :class: copyable

         .\minio.exe server C:\minio --console-address :9001

      The :mc:`minio server` process prints its output to the system console, similar to the following:

      .. code-block:: shell

         API: http://192.0.2.10:9000  http://127.0.0.1:9000
         RootUser: minioadmin
         RootPass: minioadmin

         Console: http://192.0.2.10:9001 http://127.0.0.1:9001
         RootUser: minioadmin
         RootPass: minioadmin

         Command-line: https://min.io/docs/minio/linux/reference/minio-mc.html
            $ mc alias set myminio http://192.0.2.10:9000 minioadmin minioadmin

         Documentation: https://min.io/docs/minio/linux/index.html

         WARNING: Detected default credentials 'minioadmin:minioadmin', we recommend that you change these values with 'MINIO_ROOT_USER' and 'MINIO_ROOT_PASSWORD' environment variables.

      The process is tied to the current PowerShell or Command Prompt window.
      Closing the window stops the server and ends the process.

3. Connect your Browser to the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Access the :ref:`minio-console` by going to a browser (such as Microsoft Edge) and going to ``http://127.0.0.1:9001`` or one of the Console addresses specified in the :mc:`minio server` command's output.
For example, ``Console: http://192.0.2.10:9001 http://127.0.0.1:9001`` in the example output indicates two possible addresses to use for connecting to the Console.

While port ``9000`` is used for connecting to the API, MinIO automatically redirects browser access to the MinIO Console.

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

4. `(Optional)` Install the MinIO Client
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :ref:`MinIO Client <minio-client>` allows you to work with your MinIO deployment from Powershell.

Download the standalone MinIO client for Windows from the following link:

https://dl.min.io/client/mc/release/windows-amd64/mc.exe

Double click on the file to run it.
Or, run the following in the Command Prompt or PowerShell.

.. code-block::
   :class: copyable

   \path\to\mc.exe --help
   
Use :mc:`mc.exe alias set <mc alias set>` to quickly authenticate and connect to the MinIO deployment.

.. code-block:: shell
   :class: copyable

   mc.exe alias set local http://127.0.0.1:9000 minioadmin minioadmin
   mc.exe admin info local

The :mc:`mc.exe alias set <mc alias set>` takes four arguments:

- The name of the alias
- The hostname or IP address and port of the MinIO server
- The Access Key for a MinIO :ref:`user <minio-users>`
- The Secret Key for a MinIO :ref:`user <minio-users>`

For additional details about this command, see :ref:`alias`.

5. Next Steps
~~~~~~~~~~~~~

ToDo