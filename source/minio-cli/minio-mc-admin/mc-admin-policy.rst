===================
``mc admin policy``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin policy

Description
-----------

.. start-mc-admin-policy-desc

The :mc-cmd:`mc admin policy` command manages policies for use with MinIO
Policy-Based Access Control (PBAC). MinIO PBAC uses IAM-compatible policy JSON
documents to define rules for accessing resources on a MinIO server.

.. end-mc-admin-policy-desc

For complete documentation on MinIO PBAC, including policy document JSON
structure and syntax, see
:doc:`/security/minio-authentication-authorization`.

Quick Reference
---------------

:mc-cmd:`mc admin policy add TARGET POLICYNAME POLICYFILE <mc admin policy add>`
   Creates a new policy on the target MinIO deployment. 

   .. code-block:: shell
      :class: copyable

      mc admin policy add play myNewPolicy /path/to/policy.json

:mc-cmd:`mc admin policy list TARGET <mc admin policy list>`
   Lists the available policies on the target MinIO deployment.

   .. code-block:: shell
      :class: copyable
      
      mc admin policy list play

:mc-cmd:`mc admin policy info TARGET POLICYNAME <mc admin policy info>`
   Returns the policy in JSON format from the target MinIO deployment.

   .. code-block:: shell
      :class: copyable

      mc admin policy info play myNewPolicy

:mc-cmd:`mc admin policy set TARGET POLICYNAME user=|group= <mc admin policy set>`
   Associates a policy to a user or group on the target MinIO deployment.

   .. code-block:: shell
      :class: copyable

      mc admin policy set play myNewPolicy user=myMinioUser

      mc admin policy set play myNewGroupPolicy group=myMinioGroup

:mc-cmd:`mc admin policy remove TARGET POLICYNAME <mc admin policy remove>`
   Removes a policy from the target MinIO deployment.

   .. code-block:: shell
      :class: copyable

      mc admin policy remove play myNewPolicy

Examples
--------

Create a Policy
~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: myminio-alias
   :end-before: end-myminio-alias

Consider the following JSON policy document:

.. code-block:: javascript
   :class: copyable

   {
      "Version": "2012-10-17",
      "Statement": [
         {
            "Effect": "Allow",
            "Action": [
               "s3:ListAllMyBuckets"
            ],
            "Resource": [
               "arn:minio:s3:::*"
            ]
         }
      ]
   }

The following :mc-cmd:`mc admin policy add` command creates a new policy
``listbucketsonly`` on the ``myminio`` MinIO deployment using the
example JSON policy document:

.. code-block:: shell
   :class: copyable

   mc admin policy add myminio listbucketsonly /path/to/listbucketsonly.json

You can associate the new ``listbucketsonly`` policy to users or groups on the
``myminio`` deployment using the :mc-cmd:`mc admin policy set` command.

List Available Policies
~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: myminio-alias
   :end-before: end-myminio-alias

The following :mc-cmd:`mc admin policy list` command lists the available
policies on the ``myminio`` MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin policy list myminio

The command returns output that resembles the following:

.. code-block:: shell

   readwrite
   writeonly

To retrieve information on a specific policy, use the 
:mc-cmd:`mc admin policy info` command:

.. code-block:: shell
   :class: copyable

   mc admin policy info myminio writeonly

The command returns output that resembles the following:

.. code-block:: javascript

   {
      "Version": "2012-10-17",
      "Statement": [
         {
            "Effect": "Allow",
            "Action": [
               "s3:PutObject"
            ],
            "Resource": [
               "arn:aws:s3:::*"
            ]
         }
      ]
   }

Remove a Policy
~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: myminio-alias
   :end-before: end-myminio-alias

The following :mc-cmd:`mc admin policy remove` command removes a policy
on the ``myminio`` MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin policy remove myminio listbucketsonly


Apply a Policy to a User or Group
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: myminio-alias
   :end-before: end-myminio-alias

- Use the :mc-cmd:`mc admin user list` command to return a list of
  users on the target MinIO deployment. 

- Use the :mc-cmd:`mc admin group list` command to return a list of
  users on the target MinIO deployment.

The following :mc-cmd:`mc admin policy set` command associates the 
``listbucketsonly`` policy to a user on the ``myminio`` MinIO deployment. 
Replace the ``<USER>`` with the name of a user that exists on the deployment.

.. code-block:: shell
   :class: copyable

   mc admin policy set myminio listbucketsonly user=<USER>

The following :mc-cmd:`mc admin policy set` command associates the 
``listbucketsonly`` policy to a group on the ``myminio`` MinIO deployment. 
Replace the ``<GROUP>`` with the name of a user that exists on the deployment.

.. code-block:: shell
   :class: copyable

   mc admin policy set myminio listbucketsonly group=<GROUP>

Syntax
------

.. mc-cmd:: add
   :fullpath:

   Creates a new policy on the target MinIO
   deployment. The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin policy add TARGET POLICYNAME POLICYPATH

   The :mc-cmd:`mc admin policy add` command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which
      to add the new policy.

   .. mc-cmd:: POLICYNAME

      The name of the policy to add. 
      
      Specifying the name of an existing policy overwrites that policy on the
      :mc-cmd:`~mc admin policy TARGET` MinIO deployment.

   .. mc-cmd:: POLICYPATH

      The file path to the policy to add. The file *must* be a JSON-formatted
      file with :iam-docs:`IAM-compatible syntax <reference_policies.html>`. 

.. mc-cmd:: list
   :fullpath:

   Lists all policies on the target MinIO deployment. The command
   has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin policy list TARGET

   For example, the following command lists all policies on the 
   ``myminio`` MinIO deployment:

   .. code-block:: shell
      :class: copyable

      mc admin policy list play

   The :mc-cmd:`mc admin policy add` command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from which
      the command lists the available policies.

.. mc-cmd:: info
   :fullpath:

   Returns the specified policy in JSON format if it exists 
   on the target MinIO deployment. The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin policy info TARGET POLICYNAME

   :mc-cmd:`mc admin policy info` accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from
      which the command returns information on the specified policy.

   .. mc-cmd:: POLICYNAME

      The name of the policy whose details the command returns.

.. mc-cmd:: set
   :fullpath:

   Applies an existing policy to a user or group on the 
   target MinIO deployment. :mc-cmd:`mc admin policy set` overwrites the
   existing policy associated to the user or group.
   
   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin policy set TARGET POLICYNAME[,POLICYNAME,...] [ user=USERNAME | group=GROUPNAME ]

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc-alias>` of a configured MinIO deployment on which
      the command associates the :mc-cmd:`~mc admin policy set POLICYNAME`
      to the :mc-cmd:`~mc admin policy set user` or
      :mc-cmd:`~mc admin policy set group`.

   .. mc-cmd:: POLICYNAME

      The name of the policy which the command associates to the specified
      :mc-cmd:`~mc admin policy set user` or 
      :mc-cmd:`~mc admin policy set group`. Specify multiple policies
      as a comma-separated list.

      MinIO deployments include the following :ref:`built-in policies
      <minio-auth-authz-pbac-built-in>` policies by default:

      - :userpolicy:`readonly` 
      - :userpolicy:`readwrite`
      - :userpolicy:`diagnostics`
      - :userpolicy:`writeonly`

   .. mc-cmd:: user

      The name of the user to which the command associates the
      :mc-cmd:`~mc admin policy set POLICYNAME`. 

      Mutually exclusive with :mc-cmd:`~mc admin policy set GROUP`

   .. mc-cmd:: group

      The name of the group to which the command associates the 
      :mc-cmd:`~mc admin policy set POLICYNAME`. All users with membership in
      the group inherit the policies associated to the group.

      Mutually exclusive with :mc-cmd:`~mc admin policy set USER`

.. mc-cmd:: remove
   :fullpath:

   This command removes an existing policy from the target MinIO deployment. The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin policy remove TARGET POLICYNAME

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc-alias>` of a configured MinIO deployment on which
      the command removes the :mc-cmd:`~mc admin policy remove POLICYNAME`.

   .. mc-cmd:: POLICYNAME

      The name of the policy which the command removes from the
      :mc-cmd:`~mc admin policy remove TARGET` deployment.
