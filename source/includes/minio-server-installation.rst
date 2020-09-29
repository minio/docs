.. tabs::

   .. tab:: Linux

      The following commands add a *temporary* extension to your system
      PATH for running the ``minio`` utility. Defer to your operating system
      instructions for making permanent modifications to your system PATH.

      Alternatively, execute ``minio`` by navigating to the download folder and
      running ``./minio --help``

      **64-bit Intel**

      .. code-block:: shell
         :class: copyable

         curl https://dl.min.io/server/minio/release/linux-amd64/minio \
           --create-dirs \
           -o $HOME/minio-binaries/minio

         chmod +x $HOME/minio-binaries/minio
         export PATH=$PATH:$HOME/minio-binaries/

         minio --help

      **64-bit PPC**

      .. code-block:: shell
         :class: copyable

         curl https://dl.min.io/server/minio/release/linux-ppc64le/minio \
           --create-dirs \
           -o $HOME/minio-binaries/minio

         chmod +x $HOME/minio-binaries/minio
         export PATH=$PATH:$HOME/minio-binaries/

         minio --help

   .. tab:: macOS


      **Homebrew**

      .. code-block:: shell
         :class: copyable

         brew install minio/stable/minio
         minio --help

      **Binary Download**

      .. code-block:: shell
         :class: copyable

         curl https://dl.min.io/server/minio/release/darwin-amd64/minio \
           --create-dirs \
           -o $HOME/minio-binaries/minio

         chmod +x $HOME/minio-binaries/minio
         export PATH=$PATH:$HOME/minio-binaries/


   .. tab:: Windows

      Open the following file in a browser:
      
      https://dl.min.io/server/minio/release/windows-amd64/minio.exe

      Execute the file by double clicking on it, *or* by running the
      following in the command prompt or powershell:

      .. code-block:: powershell

         \path\to\mc.exe --help

   .. tab:: Source

      Installation from source is intended for developers and advanced users
      and requires a working Golang environment. See 
      `How to install Golang <https://golang.org/doc/install>`__.

      Run the following commands in a terminal environment to install ``minio``
      from source:

      .. code-block:: shell
         :class: copyable

         go get -d github.com/minio/minio
         cd ${GOPATH}/src/github.com/minio/minio
         make

      To update a source-based installation, use ``go get -u``. 
      :mc-cmd:`minio update` does not support source-based installations.


