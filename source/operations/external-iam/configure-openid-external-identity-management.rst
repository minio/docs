.. _minio-authenticate-using-openid-generic:

===============================================
Configure MinIO for Authentication using OpenID
===============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

MinIO supports using an OpenID Connect (OIDC) compatible IDentity Provider (IDP) such as Okta, KeyCloak, Dex, Google, or Facebook for external management of user identities. 

This page has procedures for configuring OIDC for MinIO deployments in Kubernetes and Baremetal infrastructures.

This procedure covers:

- Configuring a MinIO cluster for an external OIDC provider.
- Using the MinIO ``AssumeRoleWithWebIdentity`` Security Token Service (STS) API to generate temporary credentials for use by applications.

This procedure is generic for OIDC compatible providers. 
Defer to the documentation for the OIDC provider of your choice for specific instructions or procedures on authentication and JWT retrieval.

Prerequisites
-------------

OpenID-Connect (OIDC) Compatible IDentity Provider
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure assumes an existing OIDC provider such as Okta, KeyCloak, Dex, Google, or Facebook. 
Instructions on configuring these services are out of scope for this procedure.

The MinIO cluster must have bidirectional access to the OIDC provider.

Review Access Management Behavior
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure each user identity intended for use with MinIO has the appropriate :ref:`claim <minio-external-identity-management-openid-access-control>` configured such that MinIO can associate a :ref:`policy <minio-policy>` to the authenticated user.
An OpenID user with no assigned policy has no permission to access any action or resource on the MinIO cluster.

For JWT claim-based authentication, MinIO only supports OIDC flows using the `OpenID Authorization Code Flow <https://openid.net/specs/openid-connect-core-1_0.html#CodeFlowAuth>`__.

Access to MinIO Cluster
~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses :mc:`mc` for performing operations on the MinIO cluster.
Install ``mc`` on a machine with network access to the cluster.
See the ``mc`` :ref:`Installation Quickstart <mc-install>` for instructions on downloading and installing ``mc``.
This procedure assumes a configured :mc:`alias <mc alias>` for the MinIO cluster. 

.. _minio-external-identity-management-openid-configure:

Configure MinIO with OpenID External Identity Management
--------------------------------------------------------

1. Create a new OpenID Configuration

   Use the :mc-cmd:`mc idp openid add` command to create a new OIDC configuration for the MinIO cluster.
   The following example command assumes using the JWT claims returned by the OIDC provider for :ref:`authorization through policy assignment <minio-external-identity-management-openid-access-control>`.

   .. code-block:: shell
      :class: copyable

      mc idp openid add ALIAS \
        client_id=minio-oidc-client-id \
        client_secret=minio-oidc-client-secret \
        config_url="https://openid-provider.example.net/REALM/.well-known/openid-configuration" \
        claim_name="minio-policies" \
        scopes="openid,groups"

   You can also configure ``RoleArn``-based functionality where all authenticated users have a single policy dictated by the ``role_policy`` setting.
   For example, set ``role_policy="readOnly"`` to assign all authenicated users the built-in read-only policy.

2. Review the MinIO Server logs

   The MinIO process restarts as part of the new configuration.
   Examine the logs to ensure the OIDC configuration persisted successfully.

   If configuring ``role_policy`` for one or more configurations, the output includes an ARN for use with the STS API.

3. Generate S3-Compatible Temporary Credentials using OIDC Credentials

   MinIO requires clients authenticate using :s3-api:`AWS Signature Version 4 protocol <sig-v4-authenticating-requests.html>` with support for the deprecated Signature Version 2 protocol. 
   Specifically, clients must present a valid access key and secret key to access any S3 or MinIO administrative API, such as ``PUT``, ``GET``, and ``DELETE`` operations.

   Applications can generate temporary access credentials as-needed using the :ref:`minio-sts-assumerolewithwebidentity` Security Token Service (STS) API endpoint and the JSON Web Token (JWT) returned by the :abbr:`OIDC (OpenID Connect)` provider.

   The application must provide a workflow for logging into the :abbr:`OIDC (OpenID Connect)` provider and retrieving the JSON Web Token (JWT) associated to the authentication session. 
   Defer to the provider documentation for obtaining and parsing the JWT token after successful authentication. MinIO provides an example Go application :minio-git:`web-identity.go <minio/blob/master/docs/sts/web-identity.go>` with an example of managing this workflow.

   Once the application retrieves the JWT token, use the ``AssumeRoleWithWebIdentity`` endpoint to generate the temporary credentials:

   .. code-block:: shell
      :class: copyable

      POST https://minio.example.net?Action=AssumeRoleWithWebIdentity
      &WebIdentityToken=TOKEN
      &Version=2011-06-15
      &DurationSeconds=86400
      &Policy=Policy

   - Replace the ``TOKEN`` with the JWT token returned in the previous step.
   - Replace the ``DurationSeconds`` with the duration in seconds until the temporary credentials expire. The example above specifies a period of ``86400`` seconds, or 24 hours.
   - Replace the ``Policy`` with an inline URL-encoded JSON :ref:`policy <minio-policy>` that further restricts the permissions associated to the temporary credentials. 
   
     Omit to use the policy associated to the OpenID user :ref:`policy claim <minio-external-identity-management-openid-access-control>`.

   You can optionally include the ``RoleArn`` parameter with the ARN string of your preferred single-policy OIDC configuration.

   The API response consists of an XML document containing the access key, secret key, session token, and expiration date. 
   Applications can use the access key and secret key to access and perform operations on MinIO.

   See the :ref:`minio-sts-assumerolewithwebidentity` for reference documentation.

