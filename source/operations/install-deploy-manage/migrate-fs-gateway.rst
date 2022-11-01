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
Deployments still using the `standalone` or `filesystem` MinIO modes that upgrade to :minio-release:`RELEASE.2022-10-29T06-21-33Z` or later receive an error when attempting to start MinIO.

Overview
--------

To upgrade to a :minio-release:`RELEASE.2022-10-29T06-21-33Z` or later, those who were using the `standalone` or `filesystem` deployment modes must create a new :ref:`Single-Node Single-Drive <minio-snsd>` deployment and migrate settings and content to the new deployment.

This document outlines the steps required to successfully launch and migrate to a new deployment.

.. important:: 

   Standalone/file system mode continues to work on any release up to and including `RELEASE.2022-10-24T18-35-07Z <https://github.com/minio/minio/releases/tag/RELEASE.2022-10-24T18-35-07Z>`__.
   To continue using a standalone deployment, install that MinIO release or any `earlier release <https://github.com/minio/minio/releases>`__.

   Do not upgrade to any release later than ``RELEASE.2022-10-24T18-35-07Z``.

Procedure
---------

#. Retrieve the existing deployment's **environment variables**

   Use the :mc-cmd:`mc admin config` export command to retrieve the environment variables defined on the existing standalone MinIO deployment.

   .. code-block:: shell
      :class: copyable

      mc admin config export ALIAS > config.txt

   Replace ``ALIAS`` with the alias used for the existing standalone deployment you are retrieving values from.

#. Create a new Single-Node Single-Drive MinIO deployment

   Refer to the :ref:`documentation for step-by-step instructions <deploy-minio-standalone>` for launching a new |SNSD| deployment.

   The location of the deployment can be any empty folder on the storage medium of your choice.
   A new folder on the same drive can work for the new deployment as long as the existing deployment is not on the root of a drive.
   If the existing standalone system points to the root of the drive, you must use a separate drive for the new deployment.

   Set the port to a custom point different than the existing standalone deployment.

#. Add an alias for the new deployment with :mc:`mc alias set`
 
   .. code-block:: shell
      :class: copyable
      
      mc alias set PATH ACCESSKEY SECRETKEY

   - Replace PATH with the IP address or hostname and port for the new deployment.
   - Replace ``ACCESSKEY`` and ``SECRETKEY`` with the credentials you used when creating the new deployment.

#. Import **configurations** from existing standalone deployment to new deployment

   .. code-block:: shell
      :class: copyable

      mc admin config import ALIAS < config.txt

   - Replace ``ALIAS`` with the alias for the new deployment.

#. Restart the server for the new deployment

   .. code-block:: shell
      :class: copyable

      mc admin service restart ALIAS
   
   - Replace ``ALIAS`` with the alias for the new deployment.
   
#. Duplicate **buckets** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc ls` with the ``--json`` flag to retrieve a list of the buckets that exist on the standalone deployment.
   Use the list to recreate the buckets on the new deployment.

   .. code-block:: shell
      :class: copyable

      mc ls ALIAS --json

   - Replace ``ALIAS`` with the alias for the existing standalone deployment.

#. *(Optional)* Duplicate **tiers** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc admin tier ls` with the ``--json`` flag to retrieve a list of the tiers that exist on the standalone deployment.

   .. code-block:: shell
      :class: copyable

      mc admin tier ls ALIAS --json

   - Replace ``ALIAS`` with the alias for the existing standalone deployment.
   
   Use the list to recreate the tiers on the new deployment.

#. Duplicate **policies** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc admin policy list` with the ``--json`` flag  to retrieve a list of policies that exist on the standalone deployment.
   
   .. code-block:: shell
      :class: copyable

      mc admin policy list ALIAS --json

   - Replace ``ALIAS`` with the alias for the existing standalone deployment.

   Use the list to recreate the policies on the new deployment.

#. Duplicate **groups** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc admin group list` with the ``--json`` flag to retrieve a list of groups that exist on the standalone deployment.

   .. code-block:: shell
      :class: copyable

      mc admin group list ALIAS --json

   - Replace ``ALIAS`` with the alias for the existing standalone deployment.

   Use the list to recreate the groups on the new deployment.

#. Duplicate **users** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc admin user list` with the ``--json`` flag to retrieve a list of users with access key, policy name, and status.

   .. code-block:: shell
      :class: copyable

      mc admin user list ALIAS --json

   - Replace ``ALIAS`` with the alias for the existing standalone deployment.

   Use the list to recreate the users on the new deployment.

   Note: You will need to define each user's ``SECRETKEY`` on the new deployment.
   Make note of the ``SECRETKEY`` for each user to let them know their new credentials.

#. Duplicate **service accounts** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc admin user svcacct list` with the ``--json`` flag to list existing service accounts on the standalone deployment.

   .. code-block:: shell
      :class: copyable

      mc admin user svcacct list ALIAS --json

   - Replace ``ALIAS`` with the alias for the existing standalone deployment.

   Use the list to recreate the service accounts on the new deployment.

#. Use :mc:`mc mirror` with the :mc-cmd:`~mc mirror --preserve` and :mc-cmd:`~mc mirror --watch` flags on the standalone deployment to move objects to the new |SNSD| deployment

   .. code-block:: shell
      :class: copyable

      mc mirror --preserve --watch SOURCE/BUCKET TARGET/BUCKET

   - Replace ``SOURCE/BUCKET`` with the alias and a bucket for the existing standalone deployment.
   - Replace ``TARGET`` with the alias and corresponding bucket for the new deployment.

#. After the initial mirror process completes, convert standalone deployment to be read only

   One options for doing this is to remove policies that provide write permissions from users or groups with :mc:`mc admin policy`'s ``unset`` command.

   .. code-block:: shell

      mc admin policy unset ALIAS POLICYNAME [user=USERNAME | group=GROUPNAME]

   - Replace ``ALIAS`` with the alias for the existing standalone deployment 
   - Replace ``POLICYNAME`` with the name of a policy on the existing standalone deployment.
   - Replace either ``USERNAME`` or ``GROUPNAME`` with either the user or group assigned the policy.

   Use care to not remove permissions for the user running the ``mc mirror`` command.

#. Wait for ``mc mirror`` to complete for all buckets for any remaining operations.

#. Stop the server for both deployments.

#. Restart the new MinIO deployment with the ports used for the previous standalone deployment.

   Refer to step four in the deploy |SNSD| :ref:`documentation <deploy-minio-standalone>`.   

#. Confirm the new deployment works as expected.

   Verify that users and service accounts have access to the buckets and objects as usual.