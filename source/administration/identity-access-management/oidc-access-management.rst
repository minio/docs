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

For identities managed by the external OpenID Connect (OIDC) compatible provider, MinIO uses the `JSON Web Token claim <https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ returned as part of the OIDC authentication flow to identify the :ref:`policies <minio-policy>` to assign to the authenticated user.

MinIO by default denies access to all actions or resources not explicitly allowed by a user's assigned or inherited :ref:`policies <minio-policy>`. 
Users managed by an OIDC provider must specify the necessary policies as part of the JWT claim. If the user JWT claim has no matching MinIO policies, that user has no permissions to access any action or resource on the MinIO deployment.

The specific claim which MinIO looks for is configured as part of :ref:`deploying the cluster with OIDC identity management <minio-external-iam-oidc>`. This page focuses on creating MinIO policies to match the configured OIDC claims.

Authentication and Authorization Flow
-------------------------------------

The login flow for an application using :abbr:`OIDC (OpenID Connect)`
credentials is as follows:

1. Authenticate to the configured :abbr:`OIDC (OpenID Connect)`
   provider and retrieve a 
   `JSON Web Token (JWT) <https://jwt.io/introduction>`__. 
   
   MinIO only supports the 
   `OpenID Authorization Code Flow 
   <https://openid.net/specs/openid-connect-core-1_0.html#CodeFlowAuth>`__. 
   Authentication using Implicit Flow is not supported.

2. Specify the :abbr:`JWT (JSON Web Token)` to the MinIO Security Token Service
   (STS) :ref:`minio-sts-assumerolewithwebidentity` API endpoint. 
   
   MinIO verifies the :abbr:`JWT (JSON Web Token)` against the
   configured OIDC provider.

   If the JWT is valid, MinIO checks for a :ref:`claim 
   <minio-external-identity-management-openid-access-control>` specifying a list
   of one or more :ref:`policies <minio-policy>` to assign to the
   authenticated user. MinIO defaults to checking the ``policy`` claim.

3. MinIO returns temporary credentials in the STS API response in the form of an
   access key, secret key, and session token. The credentials have 
   permissions matching those policies specified in the JWT claim.
   
4. Applications use the temporary credentials returned by the STS endpoint to
   perform authenticated S3 operations on MinIO.

MinIO provides an example Go application
:minio-git:`web-identity.go <minio/blob/master/docs/sts/web-identity.go>` that
handles the full login flow.

OIDC users can alternatively create :ref:`access keys <minio-idp-service-account>` associated to their AD/LDAP user. Service accounts are long-lived credentials which inherit their privileges from the parent user. The parent user can further restrict those privileges while creating the access keys. To create a new access keys, log into the :ref:`MinIO Console <minio-console>` using the OIDC-managed user credentials. From the :guilabel:`Identity` section of the left navigation, select :guilabel:`Service Accounts` followed by the :guilabel:`Create access keys +` button.

Identifying the JWT Claim Value
-------------------------------

MinIO uses the JWT token returned as part of the OIDC authentication flow to identify the specific policies to assign to the authenticated user.

You can use a `JWT Debugging tool <https://jwt.io/>`__ to decode the returned JWT token and validate that the user attributes include the required claims. 

.. todo - example JWT claim

See `RFC 7519: JWT Claim <https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ for more information on JWT claims. 

Defer to the documentation for your preferred OIDC provider for instructions on configuring user claims.

Creating Policies to Match Claims
---------------------------------

Use either the MinIO Console *or* the :mc:`mc admin policy` command to create policies that match one or more claim values.

.. todo - instructions