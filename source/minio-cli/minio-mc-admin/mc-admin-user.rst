=================
``mc admin user``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user

Description
-----------

.. start-mc-admin-user-desc

The :mc-cmd:`mc admin user` command manages users on a MinIO deployment. Clients
*must* authenticate to the MinIO deployment with the access key and secret key
associated to a user on the deployment. MinIO users constitue a key component in
MinIO Identity and Access Management.

.. end-mc-admin-user-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Users and Policy-Based Access Control
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO uses Policy-Based Access Control (PBAC) to support *authorization* of
users who have successfully *authenticated* to the deployment. Each policy
includes rules that dictate the allowed or denied actions/resources on the
deployment. You can assign one or more :ref:`policies
<minio-policy>` to a User. Users *also* inherit the policies
of any groups of which they are members. A user's total set of permissions
includes their explicitly assigned policies *and* any policies inherited via
group membership.

Newly created users have *no* policies by default and therefore cannot perform
any operations on the MinIO deployment. To configure a user's assigned policies,
you can do either or both of the following:

- Use :mc-cmd:`mc admin policy set` to associate one or more policies to
  the user.

- Use :mc-cmd:`mc admin group add` to associate the user to the group. Users
  inherit any policies assigned to the group.

Each user's total set of permissions consists of their explicitly assigned
permission *and* the inherited permissions from each of their assigned groups.

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

Create a New User
~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user add` to create a user on an S3-compatible host:

.. code-block:: shell
   :class: copyable

      mc admin user add ALIAS ACCESSKEY SECRETKEY

- Replace :mc-cmd:`ALIAS <mc admin user add TARGET>` with the
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`ACCESSKEY <mc admin user add ACCESSKEY>` with the 
  access key for the user. MinIO allows retrieving the access key after
  user creation through the :mc-cmd:`mc admin user info` command.

- Replace :mc-cmd:`SECRETKEY <mc admin user add SECRETKEY>` with the
  secret key for the user. MinIO *does not* provide any method for retrieving
  the secret key once set.

Specify a unique, random, and long string for both the ``ACCESSKEY`` and 
``SECRETKEY``. Your organization may have specific internal or regulatory
requirements around generating values for use with access or secret keys. 

List Available Users
~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user list` to list all users on an S3-compatible host:

.. code-block:: shell
   :class: copyable

   mc admin user list ALIAS 

- Replace :mc-cmd:`ALIAS <mc admin user list TARGET>` with the
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.

:mc-cmd:`mc admin user list` does *not* return the access key or secret key
associated to a user. Use :mc-cmd:`mc admin user info` to retrieve detailed
user information, including the user access key.

View User Details
~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user info` to view detailed user information on an
S3-compatible host:

.. code-block:: shell
   :class: copyable

   mc admin user info ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user info TARGET>` with the
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`USERNAME <mc admin user info USERNAME>` with the name of
  the user.

Remove a User
~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user remove` to remove a user from an S3-compatible host:

.. code-block:: shell
   :class: copyable

   mc admin user remove ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user remove TARGET>` with the
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`USERNAME <mc admin user remove USERNAME>` with the name of
  the user to remove.

Disable a User
~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user disable` to disable a user on an S3-compatible host.
Disabling a user prevents clients from authenticating to the S3 host with that
user's credentials, but does *not* remove that user from the S3 host.

Use :mc-cmd:`mc admin user enable` to enable a disabled user on an S3-compatible
host.

.. code-block:: shell
   :class: copyable

   mc admin user disable ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user disable TARGET>` with the
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`USERNAME <mc admin user disable USERNAME>` with the name of
  the user to disable.

Enable a User
~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user enable` to enable a user on an S3-compatible
host.

.. code-block:: shell
   :class: copyable

   mc admin user enable ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user enable TARGET>` with the
  :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`USERNAME <mc admin user enable USERNAME>` with the name of
  the user to enable.

Syntax
------

.. mc-cmd:: add
   :fullpath:

   Adds new user to the target MinIO deployment. The command has the following
   syntax:

   .. code-block:: shell
      :class: copyable

      mc admin user add TARGET ACCESSKEY SECRETKEY

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which
      the command creates the new user. 

   .. mc-cmd:: ACCESSKEY

      The access key that uniquely identifies the new user, similar to a
      username.

   .. mc-cmd:: SECRETKEY

      The secret key for the new user. Consider the following guidance
      when creating a secret key:

      - The key should be *unique*
      - The key should be *long* (Greater than 12 characters)
      - The key should be *complex* (A mixture of characters, numerals, and symbols)


.. mc-cmd:: list
   :fullpath:

   Lists all users on the target MinIO deployment. The command has the
   following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin user list TARGET

   The command accepts the following argument:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from which
      the command lists users.

.. mc-cmd:: info
   :fullpath:

   Returns detailed information of a user on the target MinIO deployment. The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin user info TARGET USERNAME

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from
      which the command retrieves the specified user information.

   .. mc-cmd:: USERNAME

      The username (:mc-cmd:`ACCESSKEY <mc admin user set ACCESSKEY>`) for the
      user whose information the command retrieves. 

.. mc-cmd:: remove

   Removes a user from the target MinIO deployment. The command has the
   following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin user remove TARGET USERNAME

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc-alias>` of a configured MinIO deployment on which
      the command removes the specified user.

   .. mc-cmd:: USERNAME

      The username (:mc-cmd:`ACCESSKEY <mc admin user set ACCESSKEY>`) for
      the user to remove. 

.. mc-cmd:: disable
   :fullpath:

   Disables a user on the target MinIO deployment. Clients cannot use the
   user credentials to authenticate to the MinIO deployment. Disabling
   a user does *not* remove that user from the deployment.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin user disable TARGET USERNAME

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc-alias>` of a configured MinIO deployment on which
      the command disables the specified user.

   .. mc-cmd:: USERNAME

      The username (:mc-cmd:`ACCESSKEY <mc admin user set ACCESSKEY>`) for
      the user to disable. 

.. mc-cmd:: enable
   :fullpath:

   Enables a user on the target deployment. Clients can only use enabled
   users to authenticate to the MinIO deployment. Users created using
   :mc-cmd:`mc admin user add` are enabled by default.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin user enable TARGET USERNAME

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc-alias>` of a configured MinIO deployment on which
      the command enables the specified user.

   .. mc-cmd:: USERNAME

      The username (:mc-cmd:`ACCESSKEY <mc admin user set ACCESSKEY>`) for
      the user to enable. 
