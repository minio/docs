..start-kes-download-desc

Download the binary of the latest stable KES release (|kes-stable|) from :minio-git:`github.com/minio/kes <kes/releases/>`.

Select the tab corresponding to the architecture for your MacOS hardware.
The command downloads the |kes-stable| binary for that architecture, sets it to executable, and adds it to your system PATH.

.. tab-set::
   
   .. tab-item:: ARM64 (Apple Silicon)

      .. code-block:: shell
         :class: copyable
         :substitutions:

         curl -O https://github.com/minio/kes/releases/download/|kes-stable|/kes-darwin-arm64
         chmod +x ./kes-darwin-arm64
         sudo mv ./kes-darwin-arm64 /usr/local/bin/kes

   .. tab-item:: AMD64 (Intel)

      .. code-block:: shell
         :class: copyable
         :substitutions:

         curl -O https://github.com/minio/kes/releases/download/|kes-stable|/kes-darwin-amd64
         chmod +x ./kes-darwin-amd64
         sudo mv ./kes-darwin-amd64 /usr/local/bin/kes

.. end-kes-download-desc

