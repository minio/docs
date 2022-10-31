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

The MinIO Gateway entered a feature freeze in July 2020.
In February 2022, MinIO announced the `deprecation of the MinIO Gateway <https://blog.min.io/deprecation-of-the-minio-gateway/?ref=docs>`__.
Along with the deprecation announcement, MinIO also announced that the feature would be removed in six months time.

As of :minio-release:`RELEASE.2022-10-29T06-21-33Z`, the MinIO Gateway and the related filesystem mode code have been removed.
Deployments still using the `standalone` or `filesystem` MinIO modes that upgrade to :minio-release:`RELEASE.2022-10-29T06-21-33Z` or later receive an error when attempting to start MinIO.

Overview
--------

To upgrade to a :minio-release:`RELEASE.2022-10-29T06-21-33Z` or later, those who were using the `standalone` or `filesystem` deployment modes must create a new :ref:`Single-Node Single-Drive <minio-snsd>` deployment and migrate settings and content to the new deployment.

This document outlines the steps required to successfully launch and migrate to a new deployment.

Procedure
---------

#. Retrieve the existing deployment's **environment variables**

   Use :mc-cmd:`mc admin config get` with the ``--json`` flag to retrieve a list of the environment variables defined on the existing standalone MinIO deployment.

#. :ref:`Create a new Single-Node Single-Drive MinIO deployment <minio-snsd>`

   The location of the deployment can be any empty folder on the storage medium of your choice.
   As long as the existing deployment is not to the root of a drive, a new folder on the same drive can work for the new deployment.
   If the existing standalone system points to the root of the drive, you must use a separate drive for the new deployment.

   Use the environment variable values retrieved from the standalone deployment to establish the same values for the new deployment.

   Set the port to a custom point different than the existing standalone deployment.

#. Duplicate **configurations** from existing standalone deployment to new deployment



#. Duplicate **buckets** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc ls` with the ``--json`` flag to retrieve a list of the buckets that exist on the standalone deployment.
   Use the list to recreate the buckets on the new deployment.

#. Duplicate **tiers** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc admin tier ls` with the ``--json`` flag to retrieve a list of the tiers that exist on the standalone deployment.
   Use the list to recreate the tiers on the new deployment.

#. Duplicate **policies** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc admin policy list` with the ``--json`` flag  to retrieve a list of policies that exist on the standalone deployment.
   Use the list to recreate the policies on the new deployment.

#. Duplicate **groups** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc admin group list` with the ``--json`` flag to retrieve a list of groups that exist on the standalone deployment.
   Use the list to recreate the groups on the new deployment.

#. Duplicate **users** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc admin user list` with the ``--json`` flag to retrieve a list of users with access key, policy name, and status.
   Use the list to recreate the users on the new deployment.

   Note: You will need to define each user's ``SECRETKEY`` on the new deployment.
   Make note of the ``SECRETKEY`` for each user to let them know their new credentials.

#. Duplicate **service accounts** from existing standalone deployment to new deployment

   Use :mc-cmd:`mc admin user svcacct ls` with the ``--json`` flag to list existing service accounts on the standalone deployment.
   Use the list to recreate the service accounts on the new deployment.

#. Use :mc:`mc mirror` with the ``--watch`` flag on the standalone deployment to move objects to the new |SNSD| deployment

   Do this for each bucket.

#. After the initial mirror process completes, convert standalone deployment to be read only

   Some options for doing this include:

   - ``mc admin policy remove`` for each active policy
   - ``mc admin policy unset`` to remove policy/policies for each group

#. Wait for ``mc mirror`` to complete for all buckets.

#. Shut down the server for the existing standalone deployment.

   

#. Restart the new MinIO deployment with the ports used for the previous standalone deployment.



#. Confirm the new deployment works as expected.

   Verify that users and service accounts have access to the buckets and objects as usual.