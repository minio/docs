.. tabs::

   .. tab:: Linux

      The following commands add a *temporary* extension to your system
      PATH for running the ``kes`` utility. Defer to your operating system
      instructions for making permanent modifications to your system PATH.

      Alternatively, execute ``kes`` by navigating to the download folder and
      running ``./kes --help``

      **64-bit ARM64**

      .. code-block:: shell
         :class: copyable

         curl https://github.com/minio/kes/releases/latest/download/kes-linux-arm64 \
           --create-dirs \
           -o $HOME/minio-binaries/kes

         chmod +x $HOME/minio-binaries/kes
         export PATH=$PATH:$HOME/minio-binaries/

         kes --help

      **64-bit AMD64**

      .. code-block:: shell
         :class: copyable

         curl https://github.com/minio/kes/releases/latest/download/kes-linux-amd64 \
           --create-dirs \
           -o $HOME/minio-binaries/kes

         chmod +x $HOME/minio-binaries/kes
         export PATH=$PATH:$HOME/minio-binaries/

         kes --help

      **32-bit ARM**

      .. code-block:: shell
         :class: copyable

         curl https://github.com/minio/kes/releases/latest/download/kes-linux-arm \
           --create-dirs \
           -o $HOME/minio-binaries/kes

         chmod +x $HOME/minio-binaries/kes
         export PATH=$PATH:$HOME/minio-binaries/

         kes --help

   .. tab:: macOS

      .. code-block:: shell
         :class: copyable

         curl https://github.com/minio/kes/releases/latest/download/kes-darwin-amd64 \
           --create-dirs \
           -o $HOME/minio-binaries/minio

         chmod +x $HOME/minio-binaries/minio
         export PATH=$PATH:$HOME/minio-binaries/

         kes --help

   .. tab:: Windows

      Open the following URL in a browser and save the file:
      
      https://github.com/minio/kes/releases/latest/download/kes-windows-amd64.exe

      Execute the file by double clicking on it, *or* by running the
      following in the command prompt or powershell:

      .. code-block:: doscon

         C:\path\to\mc.exe --help

   .. tab:: Source

      Installation from source is intended for developers and advanced users
      and requires a working Golang environment with minimum version 
      ``GO 1.14``. See 
      `How to install Golang <https://golang.org/doc/install>`__.

      Run the following commands in a terminal environment to install ``kes``
      from source:

      .. code-block:: shell
         :class: copyable

         go get -d github.com/minio/kes/cmd/kes
         cd ${GOPATH}/src/github.com/minio/kes/cmd/kes
         make

      To update a source-based installation, use ``go get -u``. 


