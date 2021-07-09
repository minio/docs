====================================
MinIO Identity and Access Management
====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

MinIO provides an internal Identity and Access Management subsystem that
supports the creation of user identities, groups, and policies in support of
authentication and authorization of client operations.

*Authentication* is the process of verifying the identity of a connecting
client. MinIO requires clients authenticate using :s3-api:`AWS Signature Version
4 protocol <sig-v4-authenticating-requests.html>` with support for the
deprecated Signature Version 2 protocol. Specifically, clients must present a
valid access key and secret key to access any S3 or MinIO administrative API,
such as ``PUT``, ``GET``, and ``DELETE`` operations. MinIO provides
a built-in :ref:`IDentity Provider (IDP) <minio-internal-idp>` for creating and
managing user identities in support of client authentication.

*Authorization* is the process of restricting the actions and resources the
authenticated client can perform on the deployment. MinIO uses Policy-Based
Access Control (PBAC), where each policy describes one or more rules that
outline the permissions of a user or group of users. MinIO supports a subset of
:ref:`actions <minio-policy-actions>` and 
:ref:`conditions <minio-policy-conditions>` when creating policies.
By default, MinIO *denies* access to actions or resources not explicitly
referenced in a user's assigned or inherited policies.

.. _minio-internal-idp:

Identity Management
-------------------

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

.. _minio-access-management:

Access Management
-----------------

MinIO uses Policy-Based Access Control (PBAC) to define the authorized actions
and resources to which an authenticated user has access. Each policy describes
one or more :ref:`actions <minio-policy-actions>` and :ref:`conditions
<minio-policy-conditions>` that outline the permissions of a 
:ref:`user <minio-users>` or :ref:`group <minio-groups>` of
users. 

MinIO manages the creation and storage of policies. The process for 
assigning a policy to a user or group depends on the configured
:ref:`IDentity Provider (IDP) <minio-authentication-and-identity-management>`.

MinIO deployments using the :ref:`MinIO Internal IDP <minio-internal-idp>`
require explicitly associating a user to a policy or policies using the
:mc-cmd:`mc admin policy set`  command. A user can also inherit the policies
attached to the :ref:`groups <minio-groups>` in which they have membership.

By default, MinIO *denies* access to actions or resources not explicitly allowed
by an attached or inherited policy. A user with no explicitly assigned or
inherited policies cannot perform any S3 or MinIO administrative API operations.

For MinIO deployments using an External IDP, policy assignment depends on the
choice of IDP:

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - :ref:`OpenID Connect (OIDC)  <minio-external-identity-management-openid>`
     - MinIO checks for a JSON Web Token (JWT) claim (``policy`` by default)
       containing the name of the policy or policies to attach to the
       authenticated user. If the policies do not exist, the user cannot
       perform any action on the MinIO deployment.

       MinIO does not support assigning OIDC user identities to 
       :ref:`groups <minio-groups>`. The IDP administrator must instead
       assign all necessary policies to the user's policy claim.

       See :ref:`Access Control for Externally Managed Identities 
       <minio-external-identity-management-openid-access-control>` for
       more information.

   * - :ref:`Active Directory / LDAP (AD/LDAP)
       <minio-external-identity-management-ad-ldap>`
     - MinIO checks for a policy whose name matches the Distinguished Name (DN)
       of the authenticated AD/LDAP user.

       MinIO also supports querying for the authenticated AD/LDAP user's 
       group memberships. MinIO assigns any policy whose name matches the
       DN for each returned group.

       If no policies match either the user DN *or* any of the user's group DNs,
       the user cannot perform any action on the MinIO deployment.

       See :ref:`Access Control for Externally Managed Identities
       <minio-external-identity-management-ad-ldap-access-control>` for more
       information.
     
MinIO PBAC is built for compatibility with AWS IAM policy syntax, structure, and
behavior. The MinIO documentation makes a best-effort to cover IAM-specific
behavior and functionality. Consider deferring to the :iam-docs:`IAM
documentation <>` for more complete documentation on IAM, IAM policies, or IAM
JSON syntax.

.. admonition:: ``Deny`` overrides ``Allow``
   :class: note

   MinIO follows AWS IAM policy evaluation rules where a ``Deny`` rule overrides
   ``Allow`` rule on the same action/resource. For example, if a user has an
   explicitly assigned policy with an ``Allow`` rule for an action/resource
   while one of its groups has an assigned policy with a ``Deny`` rule for that
   action/resource, MinIO would apply only the ``Deny`` rule. 

   For more information on IAM policy evaluation logic, see the IAM
   documentation on 
   :iam-docs:`Determining Whether a Request is Allowed or Denied Within an Account 
   <reference_policies_evaluation-logic.html#policy-eval-denyallow>`.

   .. toctree::
      :titlesonly:
      :hidden:

      /security/minio-identity-management/user-management
      /security/minio-identity-management/group-management
      /security/minio-identity-management/policy-based-access-control

