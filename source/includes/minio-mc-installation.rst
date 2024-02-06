.. tab-set::

   .. tab-item:: Linux

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
         
      **ARM64**

      .. code-block:: shell
         :class: copyable

         curl https://dl.min.io/client/mc/release/linux-arm64/mc \
           --create-dirs \
           -o ~/minio-binaries/mc

         chmod +x $HOME/minio-binaries/mc
         export PATH=$PATH:$HOME/minio-binaries/

         mc --help

      .. admonition:: Install from the MinIO Download Page
         :class: note

         MinIO does not officially publish its binaries to common Linux repositories or package managers (Ubuntu, RHEL, Archlinux/AUR).
         The only official source of MinIO binaries is the `MinIO Download Page <https://dl.min.io/client/mc/release/>`__.

         MinIO does not recommend installation through a package manager, as upstream repositories may install the incorrect package or a renamed package.

         All documentation assumes the installation of the *official* ``mc`` client binary through the download page *only*, with no changes to binary naming.

   .. tab-item:: macOS

      .. code-block:: shell
         :class: copyable

         brew install minio/stable/mc
         mc --help


   .. tab-item:: Windows

      Open the following file in a browser:
      
      https://dl.min.io/client/mc/release/windows-amd64/mc.exe

      Execute the file by double clicking on it, *or* by running the
      following in the command prompt or powershell:

      .. code-block:: powershell

         \path\to\mc.exe --help

   .. tab-item:: Source

      Installation from source is intended for developers and advanced users
      and requires a working Golang environment. See 
      `How to install Golang <https://golang.org/doc/install>`__.

      Run the following commands in a terminal environment to install ``mc``
      from source:

      .. code-block:: shell
         :class: copyable

         go install github.com/minio/mc@latest

      :mc:`mc update` does not support source-based installations.


