..start-kes-download-desc

Download the binary of the latest stable KES release (|kes-stable|) from :minio-git:`github.com/minio/kes <kes/releases/>`.

Select the tab corresponding to the architecture for your MacOS hardware.
The command downloads the |kes-stable| binary for that architecture, sets it to executable, and adds it to your system PATH.

.. tab-set::
   
   .. tab-item:: ARM64 (Apple Silicon)

      .. code-block:: shell
         :class: copyable
         :substitutions:

         curl -O https://github.com/minio/kes/releases/download/v|kes-stable|/kes-darwin-arm64
         chmod +x ./kes-darwin-arm64
         sudo mv ./kes-darwin-arm64 /usr/local/bin/kes

   .. tab-item:: AMD64 (Intel)

      .. code-block:: shell
         :class: copyable
         :substitutions:

         curl -O https://github.com/minio/kes/releases/download/v|kes-stable|/kes-darwin-amd64
         chmod +x ./kes-darwin-amd64
         sudo mv ./kes-darwin-amd64 /usr/local/bin/kes

.. end-kes-download-desc

.. start-kes-start-server-desc

Run the following command in a terminal or shell to start the KES server as a foreground process.

.. code-block:: shell
   :class: copyable

   kes server --mlock --auth --config=~/minio-kes-vault/kes-server-config.yaml

Defer to the documentation for your MacOS Operating System version for instructions on running a process in the background.

.. end-kes-start-server-desc

.. start-kes-minio-start-server-desc

Run the following command in a terminal or shell to start the MinIO server as a foreground process.

.. code-block:: shell
   :class: copyable

   export MINIO_CONFIG_ENV_FILE=/etc/default/minio
   minio server --console-address :9090

.. end-kes-minio-start-server-desc

