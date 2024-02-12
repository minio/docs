MinIO uses an update-then-restart methodology for upgrading a deployment to a newer release:

1. Update the MinIO binary with the newer release.
2. Restart the deployment using :mc-cmd:`mc admin service restart`.

This procedure does not require taking downtime and is non-disruptive to ongoing operations.

This page documents methods for upgrading using the update-then-restart method for both ``systemctl`` and user-managed MinIO deployments.
Deployments using Ansible, Terraform, or other management tools can use the procedures here as guidance for implementation within the existing automation framework.

Prerequisites
-------------

Back Up Cluster Settings First
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc admin cluster bucket export` and :mc:`mc admin cluster iam export` commands to take a snapshot of the bucket metadata and IAM configurations prior to starting decommissioning.
You can use these snapshots to restore :ref:`bucket <minio-mc-admin-cluster-bucket-import>` and :ref:`IAM <minio-mc-admin-cluster-iam-import>` settings to recover from user or process errors as necessary.

Check Release Notes
~~~~~~~~~~~~~~~~~~~

MinIO publishes :minio-git:`Release Notes <minio/releases>` for your reference as part of identifying the changes applied in each release.
Review the associated release notes between your current MinIO version and the newer release so you have a complete view of any changes.

Pay particular attention to any releases that are *not* backwards compatible.
You cannot trivially downgrade from any such release.

Test Upgrades Before Applying To Production
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO uses a testing and validation suite as part of all releases.
However, no testing suite can account for unique combinations and permutations of hardware, software, and workloads of your production environment.

You should always validate any MinIO upgrades in a lower environment (Dev/QA/Staging) *before* applying those upgrades to Production deployments, or any other environment containing critical data.
Performing updates to production environments without first validating in lower environments is done at your own risk.

For MinIO deployments that are significantly behind latest stable (6+ months), consider using |SUBNET| for additional support and guidance during the upgrade procedure.

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

.. _minio-upgrade-systemctl:

Update ``systemctl``-Managed MinIO Deployments
----------------------------------------------

Use these steps to upgrade a MinIO deployment where the MinIO server process is managed by ``systemctl``, such as those created using the MinIO :ref:`DEB/RPM packages <deploy-minio-distributed-baremetal>`.

1. Update the MinIO Binary on Each Node

   .. include:: /includes/linux/common-installation.rst
      :start-after: start-upgrade-minio-binary-desc
      :end-before: end-upgrade-minio-binary-desc

2. Restart the Deployment

   Run the :mc-cmd:`mc admin service restart` command to restart all MinIO server processes in the deployment simultaneously.
   
   The restart process typically completes within a few seconds and is *non-disruptive* to ongoing operations.

   .. code-block:: shell
      :class: copyable

      mc admin service restart ALIAS

   Replace :ref:`alias <alias>` of the MinIO deployment to restart.

3. Validate the Upgrade

   Use the :mc:`mc admin info` command to check that all MinIO servers are online, operational, and reflect the installed MinIO version.

4. Update MinIO Client

   You should upgrade your :mc:`mc` binary to match or closely follow the MinIO server release. 
   You can use the :mc:`mc update` command to update the binary to the latest stable release:

   .. code-block:: shell
      :class: copyable

      mc update

.. _minio-upgrade-mc-admin-update:

Update Non-System Managed MinIO Deployments
-------------------------------------------

Use these steps to upgrade a MinIO deployment where the MinIO server process is managed outside of the system (``systemd``, ``systemctl``), such as by a user, an automated script, or some other process management tool.
This procedure only works for systems where the user running the MinIO process has write permissions for the path to the MinIO binary.
For deployments managed using ``systemctl``, see :ref:`minio-upgrade-systemctl`.

Update using ``mc admin update``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :mc:`mc admin update` command updates all MinIO server binaries in the target MinIO deployment before restarting all nodes simultaneously.
The restart process typically completes within a few seconds and is *non-disruptive* to ongoing operations.

The following command updates a MinIO deployment with the specified :ref:`alias <alias>` to the latest stable release:

.. code-block:: shell
   :class: copyable

   mc admin update ALIAS

The command may fail if the user which a ``minio`` server process runs as does not have read/write permissions to the path of the binary itself.

You can specify a URL resolving to a specific MinIO server binary version.
Airgapped or internet-isolated deployments may utilize this feature for updating from an internally-accessible server:

.. code-block:: shell
   :class: copyable

   mc admin update ALIAS https://minio-mirror.example.com/minio

You should upgrade your :mc:`mc` binary to match or closely follow the MinIO server release. 
You can use the :mc:`mc update` command to update the binary to the latest stable release:

.. code-block:: shell
   :class: copyable

   mc update

Update by manually replacing the binary
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can download and manually replace the ``minio`` server binary on each of the host nodes in the deployment.
You must then restart all nodes simultaneously, such as by using :mc-cmd:`mc admin service restart`.

For example, the following command downloads the latest stable MinIO binary for Linux and copies it to ``/usr/local/bin``. 
The command overwrites the existing ``minio`` binary at that path.

.. code-block:: shell
   :class: copyable

   wget https://dl.min.io/server/minio/release/linux-amd64/minio
   chmod +x ./minio
   sudo mv -f ./minio /usr/local/bin/

Once you have replaced the binary on all MinIO hosts in the deployment, you must restart all nodes simultaneously.

You should upgrade your :mc:`mc` binary to match or closely follow the MinIO server release. 
You can use the :mc:`mc update` command to update the binary to the latest stable release:

.. code-block:: shell
   :class: copyable

   mc update