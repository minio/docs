.. _minio-external-identity-management-openid:

===================================
OpenID External Identity Management
===================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

MinIO supports using an OpenID Connect (OIDC) compatible IDentity Provider (IDP)
such as Okta, KeyCloak, Dex, Google, or Facebook for external management of user
identities. Configuring an external :abbr:`IDP (IDentity Provider)` enables
Single-Sign On workflows, where applications authenticate against the external
:abbr:`IDP (IDentity Provider)` before accessing MinIO.

MinIO by default denies access to all actions or resources not explicitly
allowed by a user's assigned or inherited :ref:`policies <minio-policy>`. Users
managed by an OIDC provider must specify the necessary policies as part of the
user profile data. See :ref:`Access Control for OIDC Managed Identities
<minio-external-identity-management-openid-access-control>` for more
information.

See :ref:`minio-authenticate-using-openid-generic` for instructions on enabling
external identity management using an :abbr:`OIDC (OpenID Connect)` compatible
service.

.. admonition:: MinIO Supports At Most One Configured IDentity Provider
   :class: important

   Configuring an external IDP disables the :ref:`MinIO internal IDP
   <minio-internal-idp>` and prevents the configuration of any other
   external IDP.

   The external :abbr:`IDP (IDentity Provider)` must have *at least* one
   configured user identity with the required :ref:`policy claims
   <minio-external-identity-management-openid-access-control>`. If no such user
   exists, the MinIO server is effectively inaccessible outside of using the
   :ref:`root <minio-users-root>` user.

Authentication and Authorization Flow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

OIDC users can alternatively create :ref:`service accounts <minio-idp-service-account>` associated to their AD/LDAP user. Service accounts are long-lived credentials which inherit their privileges from the parent user. The parent user can further restrict those privileges while creating the service account. To create a new service account, log into the :ref:`MinIO Console <minio-console>` using the OIDC-managed user credentials. From the :guilabel:`Identity` section of the left navigation, select :guilabel:`Service Accounts` followed by the :guilabel:`Create service account +` button.

.. _minio-external-identity-management-openid-access-control:

Access Control for Externally Managed Identities
------------------------------------------------

MinIO uses :ref:`Policy Based Access Control (PBAC) <minio-access-management>`
to define the actions and resources to which an authenticated user has access.
MinIO supports creating and managing :ref:`policies <minio-policy>` which an
externally managed user can claim. 

For identities managed by the external OpenID Connect (OIDC) compatible
provider, MinIO uses a `JSON Web Token claim
<https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ to identify the
:ref:`policy <minio-policy>` to assign to the authenticated user. 

MinIO by default looks for a ``policy`` claim and reads a list of one or more
policies to assign. MinIO attempts to match existing policies to those
specified in the JWT claim. If none of the specified policies exist on the MinIO
deployment, MinIO denies authorization for any and all operations issued
by that user. For example, consider a claim with the following key-value
assignment:

.. code-block:: shell

   policy="readwrite_data,read_analytics,read_logs"

The specified policy claim directs MinIO to attach the policies with names
matching ``readwrite_data``, ``read_analytics``, and ``read_logs`` to the
authenticated user.

You can set a custom policy claim using the 
:envvar:`MINIO_IDENTITY_OPENID_CLAIM_NAME` environment variable
*or* by using :mc-cmd:`mc admin config set` to set the 
:mc-conf:`identity_openid claim_name <identity_openid.claim_name>` setting.

You can use a `JWT Debugging tool <https://jwt.io/>`__ to decode the returned
JWT token and validate that the user attributes include the required claims. See
`RFC 7519: JWT Claim
<https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ for more
information on JWT claims. Defer to the documentation for your preferred OIDC
provider for instructions on configuring user claims.

MinIO provides :ref:`built-in policies <minio-policy-built-in>` for basic access
control. You can create new policies using the :mc:`mc admin policy` command, or
by using the MinIO Console. 

MinIO does not support using MinIO :ref:`groups <minio-groups>` with :abbr:`OIDC (OpenID Connect)`. 
Instead, an :abbr:`OIDC (OpenID Connect)` administrator can use the configured OIDC claim to list multiple, comma-separated MinIO :ref:`policies <minio-policy>` to assign to the user.
The OIDC administrator can create a type of "group" assignment managed entirely within :abbr:`OIDC (OpenID Connect)`.
For example, ``'policy[,policy]'``.

.. toctree::
   :titlesonly:
   :hidden:

   /security/openid-external-identity-management/configure-openid-external-identity-management
   /security/openid-external-identity-management/AssumeRoleWithWebIdentity
