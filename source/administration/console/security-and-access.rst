

.. _minio-console-security-access:

===================
Security and Access
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

You can use the MinIO Console to perform several of the identity and access management functions available in MinIO, such as:

- Create child :ref:`access keys <minio-console-user-access-keys>` that inherit the parent's permissions.
- View, manage, and create access :ref:`policies <minio-console-admin-policies>`.
- Create and manage :ref:`user credentials <minio-console-admin-identity>` or groups with the built-in MinIO IDP, connect to one or more OIDC provider, or add an AD/LDAP provider for SSO.


.. _minio-console-user-access-keys:

Access Keys
-----------

The :guilabel:`Access Keys` or `Service Accounts` section displays all :ref:`minio-id-access-keys` associated to the authenticated user.
The summary list of access keys that already exist for a particular user includes the access key, expiration, status, name, and description.

Access Keys support providing applications authentication credentials which inherit permissions from the "parent" user.

For deployments using an external identity manager such as Active Directory or an OIDC-compatible provider, access keys provide a way for users to create long-lived credentials.

- You can select the access key row to view its custom policy, if one exists.

   You can create or modify the policy from this screen.
   Access key policies cannot exceed the permissions granted to the parent user.

- You can create a new access key by selecting :guilabel:`Create access key`.

   The Console auto-generates an access key and password.
   You can select the eye :octicon:`eye` icon on the password field to reveal the value.
   You can override these values as needed.

   You can set a custom policy for the access key that further restricts the permissions granted to users authenticating with that key.
   Select :guilabel:`Restrict beyond user policy` to open the policy editor and modify as necessary.

   Ensure you have saved the access key password to a secure location before selecting :guilabel:`Create` to create the access key.
   You cannot retrieve or reset the password value after creating the access key.

   To rotate credentials for an application, create a new access key and delete the old one once the application updates to using the new credentials.

.. _minio-console-admin-policies:

Policies
--------

The :guilabel:`Policies` section displays all :ref:`policies <minio-policy>` on the MinIO deployment. 
The Policies section allows you to create, modify, or delete policies.

:ref:`Policies <minio-policy>` define the authorized actions and resources to which an authenticated user has access.
Each policy describes one or more actions a user, group of users, or access key can perform or conditions they must meet.

The policies are JSON formatted text files compatible with Amazon AWS Identity and Access Management policy syntax, structure, and behavior.
Refer to :ref:`Policy Based Action Control <minio-policy>` for details on managing access in MinIO with policies.

This section or its contents may not be visible if the authenticated user does not have the :ref:`required administrative permissions <minio-policy-mc-admin-actions>`.

- Select :guilabel:`+ Create Policy` to create a new MinIO Policy.

- Select the policy row to manage the policy details.

  The :guilabel:`Summary` view displays a summary of the policy.

  The :guilabel:`Users` view displays all users assigned to the policy.

  The :guilabel:`Groups` view displays all groups assigned to the policy.

  The :guilabel:`Raw Policy` view displays the raw JSON policy.

Use the :guilabel:`Users` and :guilabel:`Groups` views to assign a created policy to users and groups, respectively.

.. _minio-console-admin-identity:

Identity
--------

The :guilabel:`Identity` section provides a management interface for :ref:`MinIO-Managed users <minio-users>`.

The section contains the following subsections.
Some subsections may not be visible if the authenticated user does not have the :ref:`required administrative permissions <minio-policy-mc-admin-actions>`.

Users
~~~~~

The :guilabel:`Users` section displays all MinIO-managed  :ref:`users <minio-users>` on the deployment.

This section is not visible for deployments using an external identity manager such as Active Directory or an OIDC-compatible provider.

- Select :guilabel:`Create User` to create a new MinIO-managed user. 
        
  You can assign :ref:`groups <minio-groups>` and :ref:`policies <minio-policy>` to the user during creation.

- Select a user's row to view details for that user.
        
  You can view and modify the user's assigned :ref:`groups <minio-groups>` and :ref:`policies <minio-policy>`.
        
  You can also view and manage any :ref:`Access Keys <minio-idp-service-account>` associated to the user.

Groups
~~~~~~

The :guilabel:`Groups` section displays all :ref:`groups <minio-groups>` on the MinIO deployment. 

This section is not visible for deployments using an external identity manager such as Active Directory or an OIDC-compatible provider.

- Select :guilabel:`Create Group` to create a new MinIO Group. 
        
  You can assign new users to the group during creation.

  You can assign policies to the group after creation.

- Select the group row to open the details for that group.

  You can modify the group membership from the :guilabel:`Members` view.
        
  You can modify the group's assigned policies from the :guilabel:`Policies` view.

  Changing a user's group membership modifies the policies that user inherits. See :ref:`minio-access-management` for more information.

OpenID
~~~~~~

MinIO supports using an :ref:`OpenID Connect (OIDC) compatible IDentity Provider (IDP) <minio-external-identity-management-openid>` for external management of user identities.

Examples of OpenID providers include:

- Okta
- KeyCloak
- Dex
- Google
- Facebook 

Configuring an external IDP enables Single-Sign On workflows, where applications authenticate against the external IDP before accessing MinIO.

Use the the screens in this section to view, add, or edit OIDC configurations for the deployment.
MinIO supports any number of active OIDC configurations.

.. _minio-console-admin-identity-ldap:

LDAP
~~~~

MinIO supports using an :ref:`Active Directory or LDAP (AD/LDAP) <minio-external-identity-management-ad-ldap>` service for external management of user identities. 
Configuring an external IDentity Provider (IDP) enables Single-Sign On (SSO) workflows, where applications authenticate against the external IDP before accessing MinIO.

Use the the screens in this section to view, add, or edit an LDAP configuration for the deployment.
MinIO only supports one active LDAP configuration.

MinIO queries the Active Directory / LDAP server to verify the client-specified credentials. 
MinIO also performs a group lookup on the AD/LDAP server if configured to do so.
