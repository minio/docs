.. _minio-authentication-and-identity-management:

==============================
Identity and Access Management
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO requires the client perform both authentication and authorization for each new operation.

Authentication
  The process of verifying the identity of a connecting client. 
  MinIO requires clients authenticate using :s3-api:`AWS Signature Version 4 protocol <sig-v4-authenticating-requests.html>` with support for the deprecated Signature Version 2 protocol. 
  Specifically, clients must present a valid access key and secret key to access any S3 or MinIO administrative API, such as ``PUT``, ``GET``, and ``DELETE`` operations. 

Authorization
  The process of restricting the actions and resources the authenticated client can perform on the deployment. 
  MinIO uses Policy-Based Access Control (PBAC), where each policy describes one or more rules that outline the permissions of a user or group of users. 
  MinIO supports S3-specific:ref:`actions <minio-policy-actions>` and :ref:`conditions <minio-policy-conditions>` when creating policies. 
  By default, MinIO *denies* access to actions or resources not explicitly referenced in a user's assigned or inherited policies.

Identity Management
-------------------

MinIO supports both internal and external identity management:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - IDentity Provider (IDP)
     - Description

   * - :ref:`MinIO Internal IDP <minio-internal-idp>` 
     - Provides built-in identity management functionality.

   * - :ref:`OpenID <minio-external-identity-management-openid>` 
     - Supports managing identities through an OpenID Connect (OIDC) compatible
       service.

   * - :ref:`Active Directory / LDAP 
       <minio-external-identity-management-ad-ldap>` 
     - Supports managing identities through an Active Directory or LDAP service.

Once authenticated, MinIO either allows or rejects the client request depending
on whether or not the authenticated identity is *authorized* to perform the
operation on the specified resource.

Enabling external identity management disables the MinIO internal IDP, with the exception of the creating :ref:`service accounts <minio-idp-service-account>`.

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

   For more information on IAM policy evaluation logic, see the IAM documentation on :iam-docs:`Determining Whether a Request is Allowed or Denied Within an Account <reference_policies_evaluation-logic.html#policy-eval-denyallow>`.

.. toctree::
   :titlesonly:
   :hidden:

   /administration/identity-access-management/minio-identity-management
   /administration/identity-access-management/oidc-access-management
   /administration/identity-access-management/ad-ldap-access-management
   /administration/identity-access-management/policy-based-access-control