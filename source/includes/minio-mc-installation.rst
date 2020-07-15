.. tabs::

   .. tab:: Docker

      **Stable**

      .. code-block:: shell
         :class: copyable

         docker pull minio/mc
         docker run minio/mc admin info play

      **Edge**

      *Do not use bleeding-edge deployments of MinIO in production environments*

      .. code-block:: shell
         :class: copyable

         docker pull minio/mc:edge
         docker run minio/mc:edge admin info server play


   .. tab:: Linux

      The following commands add a *temporary* extension to your system
      PATH for running the ``mc`` utility. Defer to your operating system
      instructions for making permanent modifications to your system PATH.

      Alternatively, execute ``mc`` by navigating to the parent folder and
      running ``./mc --help``

      **64-bit Intel**

      .. code-block:: shell
         :class: copyable

         curl https://dl.min.io/client/mc/release/linux-amd64/mc \
           --create-dirs \
           -o $HOME/minio-binaries/mc

         chmod +x $HOME/minio-binaries/mc
         export PATH=$PATH:$HOME/minio-binaries/

         mc --help

      **64-bit PPC**

      .. code-block:: shell
         :class: copyable

         curl https://dl.min.io/client/mc/release/linux-ppc64le/mc \
           --create-dirs \
           -o ~/minio-binaries/mc

         chmod +x $HOME/minio-binaries/mc
         export PATH=$PATH:$HOME/minio-binaries/

         mc --help

   .. tab:: macOS

      .. code-block:: shell
         :class: copyable

         brew install minio/stable/mc
         mc --help


   .. tab:: Windows

      Open the following file in a browser:
      
      https://dl.min.io/client/mc/release/windows-amd64/mc.exe

      Execute the file by double clicking on it, *or* by running the
      following in the command prompt or powershell:

      .. code-block:: powershell

         \path\to\mc.exe --help

   .. tab:: Source

      Source installation is intended for developers and advanced users. The
      :mc-cmd:`mc admin update` command does not support updating source-based
      installations.

      Source installation requires a working Golang environment. 
      See `How to install Golang <https://golang.org/doc/install>`__

      .. code-block:: shell
         :class: copyable

         go get -d github.com/minio/mc
         cd ${GOPATH}/src/github.com/minio/mc
         make

:command:`mc` includes the https://play.min.io MinIO server for testing
and development under the ``play`` alias. If the host machine has access to
the public internet, you can use the ``play`` alias for testing and development
purposes. For example, the following lists all buckets on 
``https://play.min.io``:

.. code-block:: shell
   :class: copyable

   mc ls play

The ``play`` alias is strictly for testing and development. Any S3-compatible
tool can view and interact with data on ``play``. You should only store data on
``play`` that is safe for public interaction. 
