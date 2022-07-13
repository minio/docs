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
         
         Open a Terminal, then use the following commands to download the latest stable MinIO binary, set it to executable, and install it to the system ``$PATH``:

            .. code-block:: shell
               :class: copyable

               curl -O https://dl.min.io/server/minio/release/darwin-arm64/minio
               chmod +x minio
               sudo mv ./minio /usr/local/bin/

      .. tab-item:: Binary - amd64
         
         Open a Terminal, then use the following commands to download the latest stable MinIO binary, set it to executable, and install it to the system ``$PATH``:

            .. code-block:: shell
               :class: copyable

               curl -O https://dl.min.io/server/minio/release/darwin-amd64/minio
               chmod +x minio
               sudo mv ./minio /usr/local/bin/

.. end-install-minio-binary-desc

.. start-run-minio-binary-desc

From the Terminal, use the :mc:`minio server` to start a local MinIO instance in the ``~/data`` folder.
If desired, you can replace ``~/data`` with another location to which the user has read, write, and delete access for the MinIO instance.

.. code-block:: shell
   :class: copyable

   export MINIO_CONFIG_ENV_FILE=/etc/default/minio
   minio server --console-address :9090

.. code-block:: shell

   Status:         1 Online, 0 Offline. 
   API: http://192.168.2.100:9000  http://127.0.0.1:9000       
   RootUser: myminioadmin 
   RootPass: minio-secret-key-change-me 
   Console: http://192.168.2.100:9090 http://127.0.0.1:9090    
   RootUser: myminioadmin 
   RootPass: minio-secret-key-change-me 

   Command-line: https://docs.min.io/docs/minio-client-quickstart-guide
      $ mc alias set myminio http://10.0.2.100:9000 myminioadmin minio-secret-key-change-me

   Documentation: https://docs.min.io

The ``API`` block lists the network interfaces and port on which clients can access the MinIO S3 API.
The ``Console`` block lists the network interfaces and port on which clients can access the MinIO Web Console.

.. end-run-minio-binary-desc