MinIO uses an update-then-restart methodology for upgrading a deployment to a newer release:

1. Update the container MinIO image with the newer release.
2. Restart the container.

This procedure does not require taking downtime and is non-disruptive to ongoing operations.

Considerations
--------------

Upgrades Are Non-Disruptive
~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO's upgrade-then-restart procedure does *not* require taking downtime or scheduling a maintenance period.
MinIO restarts are fast, such that restarting all server processes in parallel typically completes in a few seconds. 
MinIO operations are atomic and strictly consistent, such that applications using MinIO or S3 SDKs can rely on the built-in :aws-docs:`transparent retry <general/latest/gr/api-retries.html>` without further client-side logic.
This ensures upgrades are non-disruptive to ongoing operations.

Check Release Notes
~~~~~~~~~~~~~~~~~~~

MinIO publishes :minio-git:`Release Notes <minio/releases>` for your reference as part of identifying the changes applied in each release.
Review the associated release notes between your current MinIO version and the newer release so you have a complete view of any changes.

Pay particular attention to any releases that are *not* backwards compatible.
You cannot trivially downgrade from any such release.

Procedure
---------

You can run the ``podman container inspect`` or ``docker inspect`` command to inspect the container and validate the current container image:

.. code-block:: shell
   :class: copyable

   # For docker, use docker inspect
   podman container inspect --format='{{.Config.Image}}' CONTAINER_NAME

The following output indicates the container was created using the most recent stable image tag:

.. code-block:: shell

   quay.io/minio/minio:latest

Use the :ref:`minio-upgrade-latest-tag` steps to upgrade your container.

The following output indicates the container was created using a specific image tag:

.. code-block:: shell

   quay.io/minio/minio:RELEASE.2023-07-21T21-12-44Z      

Use the :ref:`minio-upgrade-specific-tag` steps to upgrade your container.

.. _minio-upgrade-latest-tag:

Upgrade Containers using Latest Image Tag
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Update your image registry

   Pull the latest stable MinIO image for the configured image repository:

   .. code-block:: shell
      :class: copyable

      # For docker, use docker pull
      podman pull quay.io/minio/minio:latest

#. Restart the container

   You must restart the container to load the new image binary for use by MinIO:

   .. code-block:: shell
      :class: copyable

      # For docker, use docker restart
      podman container restart CONTAINER_NAME

#. Validate the Upgrade

   Use the :mc:`mc admin info` command to check that the MinIO container is online, operational, and reflects the installed MinIO version.

#. Update MinIO Client

   You should upgrade your :mc:`mc` binary to match or closely follow the MinIO server release. 
   You can use the :mc:`mc update` command to update the binary to the latest stable release:

   .. code-block:: shell
      :class: copyable

      mc update

.. _minio-upgrade-specific-tag:

Upgrade Containers using Specific Image Tag
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Update your local image registry

   Pull the desired image you want to use for updating the container.
   The following example uses the latest stable version of MinIO:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      # For docker, use docker pull
      podman pull quay.io/minio/minio:|minio-tag|

#. Modify the container start script or configuration

   Specify the new MinIO tag to the container start script or configuration.
   For Docker, this might be the Compose file used to start MinIO.
   For Podman, this might be a YAML file used to create the container or pod.

   Ensure the ``image: <VALUE>`` matches the newly pulled image tag.

#. Restart or re-create the container

   If you started the container using CLI commands, you may need to completely stop, remove, and re-create the container. 
   Use a script to perform this procedure to minimize potential downtime.

   For Docker, this might require running ``docker compose restart``.

#. Validate the Upgrade

   Use the :mc:`mc admin info` command to check that the MinIO container is online, operational, and reflects the installed MinIO version.

#. Update MinIO Client

   You should upgrade your :mc:`mc` binary to match or closely follow the MinIO server release. 
   You can use the :mc:`mc update` command to update the binary to the latest stable release:

   .. code-block:: shell
      :class: copyable

      mc update
   



