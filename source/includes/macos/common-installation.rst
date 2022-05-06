.. start-install-minio-binary-desc

.. tab-set::
   
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

      .. tab-item:: Binary - arm64
         
         Open a Terminal, then use the following commands to download the standalone MinIO server for MacOS and make it executable.

            .. code-block:: shell
               :class: copyable

               curl -O https://dl.min.io/server/minio/release/darwin-arm64/minio
               chmod +x minio   

      .. tab-item:: Binary - amd64
         
         Open a Terminal, then use the following commands to download the standalone MinIO server for MacOS and make it executable.

            .. code-block:: shell
               :class: copyable

               curl -O https://dl.min.io/server/minio/release/darwin-amd64/minio
               chmod +x minio

.. end-install-minio-binary-desc

.. start-run-minio-binary-desc

From the Terminal, use the :mc:`minio server` to start a local MinIO instance in the ``~/data`` folder.
If desired, you can replace ``~/data`` with another location to which the user has read, write, and delete access for the MinIO instance.

.. code-block:: shell
   :class: copyable

   ~/.minio server ~/data --console-address :9090

If you installed with Homebrew, do not include the ``~/`` at the beginning of the command.

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

.. end-run-minio-binary-desc