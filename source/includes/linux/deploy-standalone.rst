1) Download the MinIO Server
----------------------------

The following tabs provide examples of installing MinIO onto 64-bit Linux
operating systems using RPM, DEB, or binary. The RPM and DEB packages
automatically install MinIO to the necessary system paths and create a
``systemd`` service file for running MinIO automatically. MinIO strongly
recommends using RPM or DEB installation routes.

.. tab-set::

   .. tab-item:: RPM (RHEL)
      :sync: rpm

      Use the following commands to download the latest stable MinIO RPM and
      install it.

      .. code-block:: shell
         :class: copyable
         :substitutions:

         wget |minio-rpm| -O minio.deb
         sudo dnf install minio.rpm

   .. tab-item:: DEB (Debian/Ubuntu)
      :sync: deb

      Use the following commands to download the latest stable MinIO DEB and
      install it:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         wget |minio-deb| -O minio.deb
         sudo dpkg -i minio.deb

   .. tab-item:: Binary
      :sync: binary

      Use the following commands to download the latest stable MinIO binary and
      install it to the system ``$PATH``:

      .. code-block:: shell
         :class: copyable

         wget https://dl.min.io/server/minio/release/linux-amd64/minio
         chmod +x minio
         sudo mv minio /usr/local/bin/

2) Run the MinIO Server
-----------------------

Run the :mc-cmd:`minio server` command to start the MinIO server.
Specify the path to the volume or folder to use as the storage directory.
The :mc-cmd:`minio` process must have full access (``rwx``) to the specified path and all subfolders:

The following example uses the ``~/minio-data`` folder:

.. code-block:: shell
   :class: copyable

   mkdir ~/minio-data
   minio server ~/minio-data --console-address ":9090"


The :mc:`minio server` process prints its output to the system console, similar
to the following:

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

   WARNING: Detected default credentials 'minioadmin:minioadmin', we recommend that you change these values with 'MINIO_ROOT_USER' and 'MINIO_ROOT_PASSWORD' environment variables

Open your browser to any of the listed :guilabel:`Console` addresses to open the
:ref:`MinIO Console <minio-console>` and log in with the :guilabel:`RootUser`
and :guilabel:`RootPass`. You can use the MinIO Console for performing
administration on the MinIO server.

For applications, use the :guilabel:`API` addresses to access the MinIO
server and perform S3 operations.

The following steps are optional but recommended for further securing the
MinIO deployment.