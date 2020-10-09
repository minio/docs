.. _minio-auth-authz-overview:

==============================
Identity and Access Management
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

*Authentication* is the process of verifying the identity of a connecting
client. MinIO authentication requires providing user credentials in the form of
an access key (username) and corresponding secret key (password). The MinIO
deployment only grants access *if*:

- The access key corresponds to a user on the deployment, *and*
- The secret key corresponds to the specified access key.

*Authorization* is the process of restricting the actions and resources the
authenticated client can perform on the deployment. MinIO uses Policy-Based
Access Control (PBAC), where each policy describes one or more rules that
outline the permissions of a user or group of users. MinIO supports a subset of
:iam-docs:`IAM actions and conditions
<reference_policies_actions-resources-contextkeys.html>` when creating policies.
By default, MinIO *denies* access to actions or resources not explicitly
referenced in a user's assigned or inherited policies.

- For more information on MinIO user management, see 
  :ref:`minio-users`.

- For more information on MinIO group management, see
  :ref:`minio-groups`.

- For more information on MinIO policy creation, see
  :ref:`minio-policy`.

Users and Groups
----------------

MinIO requires that client's *authenticate* using an access key and secret key
that correspond to a :ref:`user <minio-users>`. A user can have membership in
one or more :ref:`groups <minio-groups>`, where the user inherits any privileges
associated to each group. MinIO *authorizes* the client to access only those
resources and operations which the user's assigned or inherited :ref:`privileges
<minio-policy>` explicitly allow. 

MinIO supports creating an arbitrary number of users and groups on the 
deployment for supporting client authentication. 

- Use :mc-cmd:`mc admin user add` to create a new user.

- Use :mc-cmd:`mc admin group add` to add users to a group. The command
  implicitly creates the group if it does not exist.

For complete documentation on creating MinIO users and groups, see
:ref:`minio-users` and :ref:`minio-groups`.

MinIO *also* supports federating identity management to supported third-party
services through the :ref:`Secure Token Service <minio-sts>`. Supported
identity providers include Okta, Facebook, Google, and Active Directory/LDAP.
For more complete documentation on MinIO STS configuration, see
:ref:`minio-sts`.

Policies
--------

MinIO uses :ref:`Policy-Based Access Control <minio-policy>` (PBAC) to specify
the *authorized* resources and operations to which a :ref:`user <minio-users>`
or :ref:`groups <minio-groups>` has access. MinIO PBAC uses AWS IAM-compatible
JSON syntax for defining policies. For example, MinIO can use IAM policies
designed for use with AWS S3 or S3-compatible services.

MinIO provides a set of built-in policies that provide a baseline for 
seperation of least privilege, such that a user has access to the minimum set 
of privileges required to perform their assigned actions. MinIO also supports
customized policies, including those imported from AWS IAM or IAM-compatible
policy building tools. For more complete documentation on MinIO policies, see
:ref:`minio-policy`.

To assign policies to users or groups, use the :mc-cmd:`mc admin policy set` 
command from the :program:`mc` command line tool.

.. toctree::
   :hidden:
   :titlesonly:

   /security/IAM/iam-users
   /security/IAM/iam-groups
   /security/IAM/iam-policies
   /security/IAM/iam-providers
   /security/IAM/iam-security-token-service