.. _minio-upgrade:

==========================
Upgrade a MinIO Deployment
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO uses an update-then-restart methodology for upgrading a deployment to a newer release:

1. Update the MinIO binary on all hosts with the newer release.
2. Restart the deployment using :mc-cmd:`mc admin service restart`.

This procedure does **not** require taking downtime and is non-disruptive to ongoing operations.

This page documents methods for upgrading using the update-than-restart method for both ``systemctl`` and user-managed MinIO deployments.
Deployments using Ansible, Terraform, or other management tools can use the procedures here as guidance for implementation within the existing automation framework.

.. admonition:: Test Upgrades In a Lower Environment
   :class: important

   Your unique deployment topology, workload patterns, or overall environment **requires** testing of any MinIO upgrades in a lower environment (Dev/QA/Staging) *before* applying those upgrades to Production deployments, or any other environment containing critical data.
   Performing "blind" updates to production environments is done at your own risk.

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
For virtualized environments which *require* rolling updates, you should amend the recommend procedure as follows:

1. Update the MinIO Binary in the virtual machine or container one at a time.
2. Restart the MinIO deployment using :mc-cmd:`mc admin service restart`.
3. Update the virtual machine/container configuration to use the matching newer MinIO image.
4. Perform the rolling restart of each machine/container with the updated image.

Check Release Notes
~~~~~~~~~~~~~~~~~~~

MinIO publishes :minio-git:`Release Notes <minio/releases>` for your reference as part of identifying the changes applied in each release.
Review the associated release notes between your current MinIO version and the newer release such that you have a complete view of any changes.

Pay particular attention to any releases that are backwards incompatible.
You cannot trivially downgrade from any such release.

.. _minio-upgrade-systemctl:

Update ``systemctl``-Managed MinIO Deployments
----------------------------------------------

Use these steps to upgrade a MinIO deployment where the MinIO server process is managed by ``systemctl``, such as those created using the MinIO :ref:`DEB/RPM packages <deploy-minio-distributed-baremetal>`.

1. **Update the MinIO Binary on Each Node**

   .. include:: /includes/common-installation.rst
      :start-after: start-upgrade-minio-binary-desc
      :end-before: end-upgrade-minio-binary-desc

2. **Restart the Deployment**

   Run the :mc-cmd:`mc admin service restart` command to restart all MinIO server processes in the deployment simultaneously.
   
   The restart process typically completes within a few seconds and is *non-disruptive* to ongoing operations.

   .. code-block:: shell
      :class: copyable

      mc admin service restart ALIAS

   Replace :ref:`alias <alias>` of the MinIO deployment to restart.

3. **Validate the Upgrade**

   Use the :mc-cmd:`mc admin info` command to check that all MinIO servers are online, operational, and reflect the installed MinIO version.

4. **Update MinIO Client**

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

The :mc-cmd:`mc admin update` command updates all MinIO server binaries in the target MinIO deployment before restarting all nodes simultaneously.
The restart process typically completes within a few seconds and is *non-disruptive* to ongoing operations.

- For deployments managed using ``systemctl``, see
  :ref:`minio-upgrade-systemctl`.

- For Kubernetes or other containerized environments, defer to the native 
  mechanisms for updating container images across a deployment.

The following command updates a MinIO deployment with the specified :ref:`alias <alias>` to the latest stable release:

.. code-block:: shell
   :class: copyable

   mc admin update ALIAS

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
