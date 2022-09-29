You can install the MinIO Kubernetes plugin by downloading and installing the plugin binary to your local host:

.. tab-set::

   .. tab-item:: Linux, MacOS

      You can download the MinIO ``kubectl`` plugin to your local system path.
      The ``oc`` CLI automatically discovers and runs compatible plugins.

      The following code downloads the latest stable version |operator-version-stable| of the MinIO Kubernetes plugin and installs it to the system path:

      .. code-block:: shell
         :substitutions:
         :class: copyable

         curl https://github.com/minio/operator/releases/download/v|operator-version-stable|/kubectl-minio_|operator-version-stable|_linux_amd64 -o kubectl-minio
         chmod +x kubectl-minio
         mv kubectl-minio /usr/local/bin/

      The ``mv`` command above may require ``sudo`` escalation depending on the permissions of the authenticated user.

      Run the following command to verify installation of the plugin:

      .. code-block:: shell
         :class: copyable

         oc minio version

      The output should display the Operator version as |operator-version-stable|.

   .. tab-item:: Windows

      You can download the MinIO ``kubectl`` plugin to your local system path.
      The ``oc`` CLI automatically discovers and runs compatible plugins.

      The following PowerShell command downloads the latest stable version |operator-version-stable| of the MinIO Kubernetes plugin and installs it to the system path:

      .. code-block:: powershell
         :substitutions:
         :class: copyable

         Invoke-WebRequest -Uri "https://github.com/minio/operator/releases/download/v|operator-version-stable|/kubectl-minio_|operator-version-stable|_windows_amd64.exe" -OutFile "C:\kubectl-plugins\kubectl-minio.exe"

      Ensure the path to the plugin folder is included in the Windows PATH.

      Run the following command to verify installation of the plugin:

      .. code-block:: shell
         :class: copyable

         oc minio version

      The output should display the Operator version as |operator-version-stable|.