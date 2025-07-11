.. _minio-external-identity-management-openid:
.. _minio-external-identity-management-openid-access-control:

================================
OpenID Connect Access Management
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO supports using an OpenID Connect (OIDC) compatible IDentity Provider (IDP)
such as Okta, KeyCloak, Dex, Google, or Facebook for external management of user
identities.

For identities managed by the external OpenID Connect (OIDC) compatible provider, MinIO can use either of two methods to assign policies to the authenticated user.

1. Use the `JSON Web Token claim <https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ returned as part of the OIDC authentication flow to identify the :ref:`policies <minio-policy>` to assign to the authenticated user.
2. Use the ``RoleArn`` specified in the authorization request to assign the policies attached to the provider's RolePolicy.
   
MinIO by default denies access to all actions or resources not explicitly allowed by a user's assigned or inherited :ref:`policies <minio-policy>`. 
Users managed by an OIDC provider must specify the necessary policies as part of the JWT claim. If the user JWT claim has no matching MinIO policies, that user has no permissions to access any action or resource on the MinIO deployment.

The specific claim which MinIO looks for is configured as part of :ref:`deploying the cluster with OIDC identity management <minio-external-iam-oidc>`. This page focuses on creating MinIO policies to match the configured OIDC claims.

Authentication and Authorization Flow 
-------------------------------------

MinIO supports two OIDC authentication and authorization flows:

1. The RolePolicy flow sets the assigned policies for an authenticated user in the MinIO configuration.

   MinIO recommends using the RolePolicy method for authenticating with an OpenID provider.

2. The JWT flow sets the assigned policies for an authenticated user as part of the OIDC configuration.

MinIO supports multiple OIDC provider configurations.
However, you can configure only **one** JWT claim-based OIDC provider per deployment. 
All other providers must use RolePolicy.

RolePolicy and RoleArn
~~~~~~~~~~~~~~~~~~~~~~

With a RolePolicy, all clients which generate an STS credential using a given RoleArn receive the :ref:`policy or policies <minio-policy>` associated to the RolePolicy configuration for that RoleArn.

You can use  :ref:`OpenID Policy Variables <minio-policy-variables-oidc>` to create policies that programmatically manage what each individual user has access to.

The login flow for an application using :abbr:`OIDC (OpenID Connect)` credentials with a RolePolicy claim flow is as follows:

1. Create an OIDC Configuration.
2. Record the RoleArn assigned to the configuration either at time of creation or at MinIO start.
   Use this RoleArn with the :ref:`AssumeRoleWithWebIdentity <minio-sts-assumerolewithwebidentity>` STS API.
3. Create a RolePolicy to use with the RoleArn.
   Use either the :envvar:`MINIO_IDENTITY_OPENID_ROLE_POLICY` environment variable or the :mc-conf:`identity_openid role_policy <identity_openid.role_policy>` configuration setting to define the list of policies to use for the provider
4. Users select the configured OIDC provider when logging in to MinIO.
5. Users complete authentication to the configured :abbr:`OIDC (OpenID Connect)` provider and redirect back to MinIO. 
   
   MinIO only supports the `OpenID Authorization Code Flow <https://openid.net/specs/openid-connect-core-1_0.html#CodeFlowAuth>`__. 
   Authentication using Implicit Flow is not supported.

6. MinIO verifies the ``RoleArn`` in the API call and checks for the :ref:`RolePolicy <minio-external-identity-management-openid-access-control>` to use.
   Any authentication request with the RoleArn receives the same policy access permissions.
7. MinIO returns temporary credentials in the STS API response in the form of an access key, secret key, and session token. 
   The credentials have permissions matching those policies specified in the RolePolicy.
   
8. Applications use the temporary credentials returned by the STS endpoint to perform authenticated S3 operations on MinIO.


JSON Web Token Claim
~~~~~~~~~~~~~~~~~~~~

Using JSON Web Tokens allows you to have individual assignment of policies.
However, the use of web tokens also comes at the increased cost of managing multiple policies for separate claims.

The login flow for an application using :abbr:`OIDC (OpenID Connect)`
credentials with a JSON Web Token Claim flow is as follows:

1. Authenticate to the configured :abbr:`OIDC (OpenID Connect)`
   provider and retrieve a `JSON Web Token (JWT) <https://jwt.io/introduction>`__. 
   
   MinIO only supports the `OpenID Authorization Code Flow <https://openid.net/specs/openid-connect-core-1_0.html#CodeFlowAuth>`__. 
   Authentication using Implicit Flow is not supported.

2. Specify the :abbr:`JWT (JSON Web Token)` to the MinIO Security Token Service
   (STS) :ref:`minio-sts-assumerolewithwebidentity` API endpoint. 
   
   MinIO verifies the :abbr:`JWT (JSON Web Token)` against the configured OIDC provider.

   If the JWT is valid, MinIO checks for a :ref:`claim 
   <minio-external-identity-management-openid-access-control>` specifying a list
   of one or more :ref:`policies <minio-policy>` to assign to the
   authenticated user. MinIO defaults to checking the ``policy`` claim.

3. MinIO returns temporary credentials in the STS API response in the form of an
   access key, secret key, and session token. The credentials have 
   permissions matching those policies specified in the JWT claim.
   
4. Applications use the temporary credentials returned by the STS endpoint to
   perform authenticated S3 operations on MinIO.

MinIO provides an example Go application :minio-git:`web-identity.go <minio/blob/master/docs/sts/web-identity.go>` that handles the full login flow.

Identifying the JWT Claim Value
+++++++++++++++++++++++++++++++

MinIO uses the JWT token returned as part of the OIDC authentication flow to identify the specific policies to assign to the authenticated user.

You can use a `JWT Debugging tool <https://jwt.io/>`__ to decode the returned JWT token and validate that the user attributes include the required claims. 

.. todo - example JWT claim

See `RFC 7519: JWT Claim <https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ for more information on JWT claims. 

Defer to the documentation for your preferred OIDC provider for instructions on configuring user claims.

Creating Policies to Match Claims
---------------------------------

Use the :mc:`mc admin policy` command to create policies that match one or more claim values.

OIDC Policy Variables
---------------------

.. include:: /includes/common/common-minio-oidc.rst
   :start-after: start-minio-oidc-policy-variables
   :end-before: end-minio-oidc-policy-variables
