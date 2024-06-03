You can install the MinIO plugin using either the Kubernetes Krew plugin manager or manually by downloading and installing the plugin binary to your local host:

.. tab-set::

   .. tab-item:: Krew Plugin Manager

      Krew is a ``kubectl`` plugin manager developed by the `Kubernetes SIG CLI group <https://github.com/kubernetes-sigs>`__.
      See the ``krew`` `installation documentation <https://krew.sigs.k8s.io/docs/user-guide/setup/install/>`__ for specific instructions.
      You can use the Krew plugin for Linux, macOS, and Windows operating systems.

      You can use Krew to install the MinIO ``kubectl`` plugin using the following commands:

      .. code-block:: shell
         :class: copyable

         kubectl krew update
         kubectl krew install minio

      If you want to update the MinIO plugin with Krew, use the following command:

      .. code-block:: shell
         :class: copyable

         kubectl krew upgrade minio

   .. tab-item:: Manual (Linux, MacOS)

      You can download the MinIO ``kubectl`` plugin to your local system path.
      The ``kubectl`` CLI automatically discovers and runs compatible plugins.

      The following code downloads the most recent version of the MinIO Kubernetes plugin and installs it to the system path:

      .. code-block:: shell
         :substitutions:
         :class: copyable

         curl https://github.com/minio/operator/releases/download/v5.0.14/kubectl-minio_5.0.14_linux_amd64 -o kubectl-minio
         chmod +x kubectl-minio
         mv kubectl-minio /usr/local/bin/

      The ``mv`` command above may require ``sudo`` escalation depending on the permissions of the authenticated user.

      Run the following command to verify installation of the plugin:

      .. code-block:: shell
         :class: copyable

         kubectl minio version

      The output should display the Operator version as 5.0.14.

   .. tab-item:: Manual (Windows)

      You can download the MinIO ``kubectl`` plugin to your local system path.
      The ``kubectl`` CLI automatically discovers and runs compatible plugins.

      The following PowerShell command downloads the most recent version of the MinIO Kubernetes plugin and installs it to the system path:

      .. code-block:: powershell
         :substitutions:
         :class: copyable

         Invoke-WebRequest -Uri "https://github.com/minio/operator/releases/download/v5.0.14/kubectl-minio_5.0.14_windows_amd64.exe" -OutFile "C:\kubectl-plugins\kubectl-minio.exe"

      Ensure the path to the plugin folder is included in the Windows PATH.

      Run the following command to verify installation of the plugin:

      .. code-block:: shell
         :class: copyable

         kubectl minio version

      The output should display the Operator version as 5.0.14.
