MinIO uses an update-then-restart methodology for upgrading a deployment to a newer release:

1. Update the MinIO binary with the newer release.
2. Restart the deployment using :mc-cmd:`mc admin service restart`.

This procedure does not require taking downtime and is non-disruptive to ongoing operations.

This page documents methods for upgrading using the update-then-restart method for both ``systemctl`` and user-managed MinIO deployments.
Deployments using Ansible, Terraform, or other management tools can use the procedures here as guidance for implementation within the existing automation framework.

Considerations
--------------

Upgrades Are Non-Disruptive
~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO's upgrade-then-restart procedure does *not* require taking downtime or scheduling a maintenance period.
MinIO restarts are fast, such that restarting all server processes in parallel typically completes in a few seconds. 
MinIO operations are atomic and strictly consistent, such that applications using MinIO or S3 SDKs can rely on the built-in :aws-docs:`transparent retry <general/latest/gr/api-retries.html>` without further client-side logic.
This ensures upgrades are non-disruptive to ongoing operations.

"Rolling" or serial "one-at-a-time" upgrade methods do not provide any advantage over the recommended "parallel" procedure, and can introduce unnecessary complexity to the upgrade procedure.
For virtualized environments which *require* rolling updates, you should modify the recommended procedure as follows:

1. Update the MinIO Binary in the virtual machine or container one at a time.
2. Restart the MinIO deployment using :mc-cmd:`mc admin service restart`.
3. Update the virtual machine/container configuration to use the matching newer MinIO image.
4. Perform the rolling restart of each machine/container with the updated image.

Check Release Notes
~~~~~~~~~~~~~~~~~~~

MinIO publishes :minio-git:`Release Notes <minio/releases>` for your reference as part of identifying the changes applied in each release.
Review the associated release notes between your current MinIO version and the newer release so you have a complete view of any changes.

Pay particular attention to any releases that are *not* backwards compatible.
You cannot trivially downgrade from any such release.

Update Using Homebrew
---------------------

For Homebrew installations, you can use homebrew to update the cask:

.. code-block:: shell
   :class: copyable

   brew upgrade minio/stable/minio

Restart the MinIO process to complete the update.

Update using Binary Replacement
-------------------------------

.. tab-set::

      .. tab-item:: Binary - arm64
         
         Open a Terminal, then use the following commands to download the latest stable MinIO binary, set it to executable, and install it to the system ``$PATH``:

            .. code-block:: shell
               :class: copyable

               curl -O https://dl.min.io/server/minio/release/darwin-arm64/minio
               chmod +x ./minio
               sudo mv ./minio /usr/local/bin/

      .. tab-item:: Binary - amd64
         
         Open a Terminal, then use the following commands to download the latest stable MinIO binary, set it to executable, and install it to the system ``$PATH``:

            .. code-block:: shell
               :class: copyable

               curl -O https://dl.min.io/server/minio/release/darwin-amd64/minio
               chmod +x ./minio
               sudo mv ./minio /usr/local/bin/

Restart the MinIO process to complete the update.