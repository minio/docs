.. start-common-deploy-pull-latest-minio-image

Select the tab for either Podman or Docker to see instructions for pulling the MinIO container image.
The instructions include examples for both quay.io and DockerHub:

.. tab-set::

   .. tab-item:: Podman

      quay.io
         .. code-block:: shell
            :class: copyable

            podman pull quay.io/minio/minio

      DockerHub
         .. code-block:: shell
            :class: copyable

            podman pull docker://minio/minio

   .. tab-item:: Docker

      quay.io
         .. code-block:: shell
            :class: copyable

            docker pull quay.io/minio/minio

      DockerHub
         .. code-block:: shell
            :class: copyable

            docker pull docker://minio/minio

.. end-common-deploy-pull-latest-minio-image

.. start-common-deploy-validate-container-status

.. tab-set::

   .. tab-item:: Podman

      Run the following command to retrieve logs from the container.
      Replace the container name with the value specified to ``--name`` in the previous step.

      .. code-block:: shell
         :class: copyable

         podman logs minio

      The command should return output similar to the following:

   .. tab-item:: Docker

      Run the following command to retrieve logs from the container.
      Replace the container name with the value specified to ``--name`` in the previous step.

      .. code-block:: shell
         :class: copyable

         docker logs minio

      The command should return output similar to the following:

.. end-common-deploy-validate-container-status

.. start-common-deploy-connect-to-minio-service

.. tab-set::

   .. tab-item:: MinIO Web Console

      You can access the MinIO Web Console by entering http://localhost:9001 in your preferred browser.
      Any traffic to the MinIO Console port on the local host redirects to the container.

      Log in with the :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD` configured in the environment file specified to the container.

      .. image:: /images/minio-console/console-bucket-none.png
         :width: 600px
         :alt: MinIO Console displaying Buckets view in a fresh installation.
         :align: center

      You can use the MinIO Console for general administration tasks like Identity and Access Management, Metrics and Log Monitoring, or Server Configuration. Each MinIO server includes its own embedded MinIO Console.

      If your local host firewall permits external access to the Console port, other hosts on the same network can access the Console using the IP or hostname for your local host.

   .. tab-item:: MinIO CLI (mc)

      You can access the MinIO deployment over a Terminal or Shell using the :ref:`MinIO Client <minio-client>` (:mc:`mc`).
      See :ref:`MinIO Client Installation Quickstart <mc-install>` for instructions on installing :mc:`mc`.

      Create a new :mc:`alias <mc alias set>` corresponding to the MinIO deployment. 
      Use a hostname or IP address for your local machine along with the S3 API port ``9000`` to access the MinIO deployment.
      Any traffic to that port on the local host redirects to the container.

      .. code-block:: shell
         :class: copyable

         mc alias set http://localhost:9000 myminioadmin minio-secret-key-change-me

      Replace ``myminioadmin`` and ``minio-secret-key-change-me`` with the :envvar:`MINIO_ROOT_USER` and :envvar:`MINIO_ROOT_PASSWORD` values in the environment file specified to the container.

      The command should return success if the container is running and accessible at the specified port.

      You can then interact with the container using any :mc:`mc` command.
      If your local host firewall permits external access to the MinIO S3 API port, other hosts on the same network can access the MinIO deployment using the IP or hostname for your local host.

.. end-common-deploy-connect-to-minio-service

.. start-common-prereq-container-management-interface

This procedure assumes you have a working `Podman <https://podman.io/getting-started/installation.html>`_ installation configured to run in "Rootfull" mode.

"Rootless" modes may not provide sufficient permissions to run KES with the necessary security settings.
See the relevant :podman-git:`"rootless" documentation <blob/main/docs/tutorials/rootless_tutorial.md>` for more information.

.. end-common-prereq-container-management-interface