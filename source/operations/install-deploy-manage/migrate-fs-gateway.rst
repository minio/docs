.. _minio-gateway-migration:

=======================================
Migrate from Gateway or Filesystem Mode
=======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Background
----------

The MinIO Gateway and the related filesystem mode entered a feature freeze in July 2020.
In February 2022, MinIO announced the `deprecation of the MinIO Gateway <https://blog.min.io/deprecation-of-the-minio-gateway/?ref=docs>`__.
Along with the deprecation announcement, MinIO also announced that the feature would be removed in six months time.

As of :minio-release:`RELEASE.2022-10-29T06-21-33Z`, the MinIO Gateway and the related filesystem mode code have been removed.
Deployments still using the `standalone` or `filesystem` MinIO modes that upgrade to MinIO Server :minio-release:`RELEASE.2022-10-29T06-21-33Z` or later receive an error when attempting to start MinIO.

.. cond:: linux

   .. note::

      For deployments running in a container, see the `Container - Migrate from Gateway or Filesystem Mode <https://min.io/docs/minio/container/operations/install-deploy-manage/migrate-fs-gateway.html>`__ tutorial instead.

Overview
--------

To upgrade to a :minio-release:`RELEASE.2022-10-29T06-21-33Z` or later, those who were using the `standalone` or `filesystem` deployment modes must create a new :ref:`Single-Node Single-Drive <minio-snsd>` deployment and migrate settings and content to the new deployment.

This document outlines the steps required to successfully launch and migrate to a new deployment.

.. important:: 

   Standalone/file system mode continues to work on any release up to and including MinIO Server `RELEASE.2022-10-24T18-35-07Z <https://github.com/minio/minio/releases/tag/RELEASE.2022-10-24T18-35-07Z>`__.
   To continue using a standalone deployment, install that MinIO Server release with MinIO Client `RELEASE.2022-10-29T10-09-23Z <https://github.com/minio/mc/releases/tag/RELEASE.2022-10-29T10-09-23Z>`__ or any `earlier release <https://github.com/minio/minio/releases>`__ with its corresponding MinIO Client. Note that the version of the MinIO Client should be newer and as close as possible to the version of the MinIO server.


Procedure
---------

.. note:: 
   
   You can set MinIO configuration settings in environment variables and using :mc-cmd:`mc admin config set <mc admin config set>`.
   Depending on your current deployment setup, you may need to retrieve the values for both.

   This procedure does not cover migrating environment variables due to the variety of configuration methods.
   You can examine any runtime settings using ``env | grep MINIO_`` or, for deployments using MinIO's systemd service, check the contents of ``/etc/default/minio``.

#. Create a new Single-Node Single-Drive MinIO deployment.

   Refer to the :ref:`documentation for step-by-step instructions <deploy-minio-standalone>` for launching a new |SNSD| deployment.

   The location of the deployment can be any empty folder on the storage medium of your choice.
   A new folder on the same drive can work for the new deployment as long as the existing deployment is not on the root of a drive.
   If the existing standalone system points to the root of the drive, you must use a separate drive for the new deployment.

   Set the port to a custom point different than the existing standalone deployment.

#. Add an alias for the new deployment with :mc:`mc alias set` with the new MinIO Client from the previous step.

   .. code-block:: shell
      :class: copyable
      
      mc alias set NEWALIAS PATH ACCESSKEY SECRETKEY

   - Use the new MinIO Client.
   - Replace ``NEWALIAS`` with the alias to create for the deployment.
   - Replace ``PATH`` with the IP address or hostname and port for the new deployment.
   - Replace ``ACCESSKEY`` and ``SECRETKEY`` with the credentials you used when creating the new deployment.

#. Standalone deployments: migrate environment variables

   Copy the :ref:`environment variables <minio-server-environment-variables>` from the existing deployment's ``/etc/default/minio`` file to the same file in the new deployment.
   You may omit any ``MINIO_CACHE_*`` and ``MINIO_GATEWAY_SSE`` environment variables, as these are no longer used.

   To continue migrating a `standalone` deployment, skip to :ref:`migrate bucket contents <minio-gateway-migrate-bucket-contents>`.

#. Filesystem Mode Deployments: Export the existing deployment's **configurations**.

   Use the :mc-cmd:`mc admin config export <mc admin config export>` export command with the existing MinIO Client to retrieve the configurations defined for the existing standalone MinIO deployment.

   .. code-block:: shell
      :class: copyable

      mc admin config export ALIAS > config.txt

   - Use the existing MinIO Client.
   - Replace ``ALIAS`` with the alias used for the existing standalone deployment you are retrieving values from. 

#. Import **configurations** from existing standalone deployment to new deployment with the new MinIO Client.

   .. code-block:: shell
      :class: copyable

      mc admin config import ALIAS < config.txt

   - Use the new MinIO Client.
   - Replace ``ALIAS`` with the alias for the new deployment.

#. Restart the server for the new deployment with the new MinIO Client.

   .. code-block:: shell
      :class: copyable

      mc admin service restart ALIAS
   
   - Use the new MinIO Client.
   - Replace ``ALIAS`` with the alias for the new deployment.
   
#. Export **bucket metadata** from existing standalone deployment with the existing MinIO Client.

   The following command exports bucket metadata from the existing deployment to a ``.zip`` file.

   The data includes:

   - bucket targets
   - lifecycle rules
   - notifications
   - quotas
   - locks
   - versioning

   The export includes the bucket metadata only.
   No objects export from the existing deployment with this command.

   .. code-block:: shell
      :class: copyable

      mc admin cluster bucket export ALIAS

   - Use the existing MinIO Client.
   - Replace ``ALIAS`` with the alias for your existing deployment.

   This command creates a ``cluster-metadata.zip`` file with metadata for each bucket.

#. Import **bucket metadata** to the new deployment with the new MinIO Client.

   The following command reads the contents of the exported bucket ``.zip`` file and creates buckets on the new deployment with the same configurations.

   .. code-block:: shell
      :class: copyable

      mc admin cluster bucket import ALIAS cluster-metadata.zip

   - Use the new MinIO Client.
   - Replace ``ALIAS`` with the alias for the new deployment.

   The command creates buckets on the new deployment with the same configurations as provided by the metadata in the .zip file from the existing deployment.

#. *(Optional)* Duplicate **tiers** from existing standalone deployment to new deployment with the existing MinIO Client.

   Use :mc:`mc ilm tier ls` with the ``--json`` flag to retrieve a list of the tiers that exist on the standalone deployment.

   .. code-block:: shell
      :class: copyable

      mc ilm tier ls ALIAS --json

   - Use the existing MinIO Client.
   - Replace ``ALIAS`` with the alias for the existing standalone deployment.
   
   Use the list to recreate the tiers on the new deployment.

#. Export **IAM settings** from the existing standalone deployment to new deployment with the existing MinIO Client.

   If you are using an external identity and access management provider, recreate those settings in the new deployment along with all associated policies.

   Use the following command to export IAM settings from the existing deployment.
   This command exports:

   - Groups and group mappings
   - STS users and STS user mappings
   - Policies
   - Users and user mappings

   .. code-block:: shell
      :class: copyable

      mc admin cluster iam export ALIAS

   - Use the existing MinIO Client.
   - Replace ``ALIAS`` with the alias for your existing deployment.

   This command creates a ``ALIAS-iam-info.zip`` file with IAM data.

#. Import the **IAM settings** to the new deployment with the new MinIO Client.

   Use the exported file to create the IAM setting on the new deployment.

   .. code-block:: shell
      :class: copyable

      mc admin cluster iam import ALIAS alias-iam-info.zip

   - Use the new MinIO Client.
   - Replace ``ALIAS`` with the alias for the new deployment.
   - Replace the name of the zip file with the name for the existing deployment's file.

   .. _minio-gateway-migrate-bucket-contents:

#. Standalone deployments: migrate bucket contents with :mc:`mc mirror`.

   Use :mc:`mc mirror` with the :mc-cmd:`~mc mirror --preserve` and :mc-cmd:`~mc mirror --watch` flags on the standalone deployment to move objects to the new |SNSD| deployment with the existing MinIO Client

   .. code-block:: shell
      :class: copyable

      mc mirror --preserve --watch SOURCE/BUCKET TARGET/BUCKET

   - Use the existing MinIO Client.
   - Replace ``SOURCE/BUCKET`` with the alias and a bucket for the existing standalone deployment.
   - Replace ``TARGET/BUCKET`` with the alias and corresponding bucket for the new deployment.

#. Stop writes to the standalone deployment from any S3 or POSIX client.

#. Wait for ``mc mirror`` to complete for all buckets for any remaining operations.

#. Stop the server for both deployments.

#. Restart the new MinIO deployment with the ports used for the previous standalone deployment.

   Refer to step four in the deploy |SNSD| :ref:`documentation <deploy-minio-standalone>`.
   
   Ensure you apply all environment variables and runtime configuration settings, and validate the behavior.
