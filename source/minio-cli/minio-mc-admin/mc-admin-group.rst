===================
``mc admin group``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin group

Description
-----------

.. start-mc-admin-group-desc

The :mc-cmd:`mc admin group` command manages groups on a MinIO deployment.

.. end-mc-admin-group-desc

A :ref:`group <minio-groups>` is a collection of :ref:`users
<minio-users>`. Each group can have one or more assigned
:ref:`policies <minio-policy>` that explicitly list the
actions and resources to which group members are allowed or denied access.
Groups provide a simplified method for managing shared permissions among users
with common access patterns and workloads. 

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Groups and Policy-Based Access Control
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO uses Policy-Based Access Control (PBAC) to support *authorization* of
users who have successfully *authenticated* to the deployment. Each policy
includes rules that dictate the allowed or denied actions/resources on the
deployment. You can assign one or more :ref:`policies
<minio-policy>` to a group. Users with membership in the
group inherit the group's assigned policies. A user's total set of permissions
includes their explicitly assigned policies *and* any policies inherited
via group membership.

Newly created groups have *no* policies by default. To configure a group's
assigned policies, use the :mc-cmd:`mc admin policy set` command.

For more information on MinIO users and groups, see
:ref:`minio-users` and :ref:`minio-groups`. For 
more information on MinIO policies, see :ref:`minio-policy`.

.. admonition:: ``Deny`` overrides ``Allow``
   :class: note

   MinIO follows the IAM standard where a ``Deny`` rule overrides ``Allow`` rule
   on the same action or resource. For example, if a user has an explicitly
   assigned policy with an ``Allow`` rule for an action/resource while one of
   its groups has an assigned policy with a ``Deny`` rule for that
   action/resource, MinIO would apply only the ``Deny`` rule. 

   For more information on IAM policy evaluation logic, see the IAM
   documentation on 
   :iam-docs:`Determining Whether a Request is Allowed or Denied Within an Account 
   <reference_policies_evaluation-logic.html#policy-eval-denyallow>`.

Examples
--------

Create a New Group
~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin group add` to create a new group to an S3-compatible host:

.. code-block:: shell
   :class: copyable

   mc admin group add ALIAS GROUPNAME MEMBER [MEMBER...]

- Replace :mc-cmd:`ALIAS <mc admin group add ALIAS>` with the 
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`GROUPNAME <mc admin group add GROUPNAME>` with the name
  of the group to create.

- Replace :mc-cmd:`MEMBER <mc admin group add MEMBERS>` with *at least* one
  :mc-cmd:`user <mc admin user>` on the S3 host. Specify multiple members 
  as a list: ``MEMBER1 MEMBER2 MEMBER3``

List Available Groups
~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin group list` to list list all groups on an S3-compatible
host:

.. code-block:: shell
   :class: copyable

   mc admin group list ALIAS

- Replace :mc-cmd:`ALIAS <mc admin group info ALIAS>` with the 
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.


View Group Details
~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin group info` to view detailed group information on an 
S3-compatible host:

.. code-block:: shell
   :class: copyable

   mc admin group info ALIAS GROUPNAME

- Replace :mc-cmd:`ALIAS <mc admin group info ALIAS>` with the 
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`GROUPNAME <mc admin group info GROUPNAME>` with the name of
  the group.

Remove a Group
~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin group remove` to remove a group from an S3-compatible
host:

.. code-block:: shell
   :class: copyable

   mc admin group remove ALIAS GROUPNAME

- Replace :mc-cmd:`ALIAS <mc admin group remove ALIAS>` with the 
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`GROUPNAME <mc admin group remove GROUPNAME>` with the
  name of the group.

Disable a Group
~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin group disable` to disable a group on an S3-compatible
host:

.. code-block:: shell
   :class: copyable

   mc admin group disable ALIAS GROUPNAME

- Replace :mc-cmd:`ALIAS <mc admin group disable ALIAS>` with the 
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`GROUPNAME <mc admin group disable GROUPNAME>` with the name
  of the group.

Enable a Group
~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin group enable` to enable a group on an S3-compatible
host:

.. code-block:: shell
   :class: copyable

   mc admin group enable ALIAS GROUPNAME

- Replace :mc-cmd:`ALIAS <mc admin group enable ALIAS>` with the 
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`GROUPNAME <mc admin group enable GROUPNAME>` with the name
  of the group.


Quick Reference
---------------

:mc-cmd:`mc admin group add TARGET GROUPNAME MEMBERS <mc admin group add>`
   Adds a user to a group on the MinIO deployment. Creates the group if it
   does not exist.

:mc-cmd:`mc admin group info TARGET GROUPNAME <mc admin group info>`
   Returns detailed information for a group on the MinIO deployment.

:mc-cmd:`mc admin group list TARGET <mc admin group list>`
   Returns a list of all groups on the MinIO deployment.

:mc-cmd:`mc admin group remove TARGET GROUPNAME <mc admin group remove>`
   Removes a group on the MinIO deployment.

:mc-cmd:`mc admin group enable TARGET GROUPNAME <mc admin group enable>`
   Enables a group on the MinIO deployment. Users can only inherit
   :ref:`policies <minio-policy>` assigned to an enabled group.

:mc-cmd:`mc admin group disable TARGET GROUPNAME <mc admin group disable>`
   Disables a group on the MinIO deployment. Users cannot inherit :ref:`policies
   <minio-policy>` assigned to a disabled group.

Syntax
------

.. mc-cmd:: add
   :fullpath:

   Adds an existing user to the group. The command creates the group if it
   does not exist. The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin group add TARGET GROUPNAME MEMBERS

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which
      the command adds users to the new or existing group

   .. mc-cmd:: GROUPNAME

      The name of the group. The command creates the group if it does not 
      already exist. Use :mc-cmd:`mc admin group list` to review the existing
      groups on a deployment.

   .. mc-cmd:: MEMBERS

      The name of the user to add to the group.
      
      The user *must* exist on the :mc-cmd:`~mc admin group add TARGET` MinIO
      deployment. Use :mc-cmd:`mc admin user list` to review the available
      users on the deployment. 

.. mc-cmd:: info
   :fullpath:

   Returns details for the group on the target deployment, such as all
   :ref:`users <minio-users>` with membership in the group and the
   assigned :ref:`policies <minio-policy>`. The command has
   the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin group info TARGET GROUPNAME

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from which
      to retrieve the group information.

   .. mc-cmd:: GROUPNAME

      The name of the group.

.. mc-cmd:: list
   :fullpath:

   List all groups on the target MinIO deployment. The command has the
   following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin group list TARGET

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from
      which to retrieve groups.

.. mc-cmd:: remove
   :fullpath:

   Removes a group on the target MinIO deployment. Removing a group does *not*
   remove any users with membership in the group. Use 
   :mc-cmd:`mc admin user remove` to remove users from a group. 
   
   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin group remove TARGET GROUPNAME

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which
      to remove the group.

   .. mc-cmd:: GROUPNAME

      The name of the group to remove.

.. mc-cmd:: enable
   :fullpath:

   Enables the group on the target MinIO deployment. Users can only inherit
   :ref:`policies <minio-policy>` from an enabled group.
   Groups are enabled on creation by default. The command has the following
   syntax:

   .. code-block:: shell
      :class: copyable

      mc admin group enable TARGET GROUPNAME

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on
      which to enable the group.

   .. mc-cmd:: GROUPNAME

      The name of the group to enable. 

.. mc-cmd:: disable
   :fullpath:

   Disables the group on the target MinIO deployment. Users cannot inherit
   :ref:`policies <minio-policy>` from a disabled group. The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin group disable TARGET GROUPNAME

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which
      to disable the group.

   .. mc-cmd:: GROUPNAME

      The name of the group to disable.

