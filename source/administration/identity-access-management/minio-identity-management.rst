.. _minio-internal-idp:

=========================
MinIO Identity Management
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO includes a built-in IDentity Provider (IDP) that provides core identity
management functionality. The MinIO IDP supports creating an arbitrary number of
long-lived users on the deployment for supporting client authentication. 

Each user consists of a unique access key (username) and corresponding secret
key (password). Clients must authenticate their identity by specifying both
a valid access key (username) and the corresponding secret key (password) of
an existing MinIO user.

Administrators use the :mc-cmd:`mc admin user` command to create and manage
MinIO users. The :minio-git:`MinIO Console <console>` provides a graphical
interface for creating users.

MinIO also supports creating :ref:`service accounts
<minio-idp-service-account>`. Service accounts are child identities of an
authenticated parent user and inherit their permissions from the parent. 

MinIO by default denies access to all actions or resources not explicitly
allowed by a user's assigned or inherited :ref:`policies <minio-policy>`. You
must either explicitly assign a :ref:`policy <minio-policy>` describing the
user's authorized actions and resources *or* assign the user to :ref:`groups
<minio-groups>` which have associated policies. See
:ref:`minio-access-management` for more information.

.. admonition:: External Identity Management
   :class: dropdown, note

   MinIO supports external management of identities using either an
   OpenID Connect (OIDC) or Active Directory/LDAP IDentity Provider (IDP).
   For more information, see:

   - :ref:`minio-external-identity-management-openid`
   - :ref:`minio-external-identity-management-ad-ldap`

   Enabling external identity management disables the MinIO internal IDP, with
   the exception of creating :ref:`service accounts
   <minio-idp-service-account>`.

.. toctree::
   :titlesonly:
   :hidden:

   /administration/identity-access-management/minio-user-management.rst
   /administration/identity-access-management/minio-group-management.rst