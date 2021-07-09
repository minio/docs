========
Security
========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. _minio-authentication-and-identity-management:

Identity and Access Management
------------------------------

MinIO requires clients authenticate using :s3-api:`AWS Signature Version 4
protocol <sig-v4-authenticating-requests.html>` with support for the deprecated
Signature Version 2 protocol. Specifically, clients must *authenticate* by
presenting a valid access key and secret key to access any S3 or MinIO
administrative API, such as ``PUT``, ``GET``, and ``DELETE`` operations. 
S3-compatible SDKs, including those provided by MinIO, typically include
built-in helpers for creating the necessary signatures using an access key
and secret key.

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

MinIO uses Policy-Based Access Control (PBAC) to define the authorized actions
and resources to which an authenticated user has access. Each policy describes
one or more :ref:`actions <minio-policy-actions>` and :ref:`conditions
<minio-policy-conditions>` that outline the permissions of a :ref:`user
<minio-users>` or :ref:`group <minio-groups>` of users. By default, MinIO
*denies* access to actions or resources not explicitly referenced in a user's
assigned or inherited policies. MinIO manages the creation and storage of
policies and does not support external authorization management.

MinIO PBAC is built for compatibility with AWS IAM policy syntax, structure, and
behavior. The MinIO documentation makes a best-effort to cover IAM-specific
behavior and functionality. Consider deferring to the :iam-docs:`IAM
documentation <>` for more complete documentation on IAM, IAM policies, or IAM
JSON syntax.

Encryption
----------

MinIO supports end-to-end encryption of objects over-the-wire (network 
encryption) and on read/write (at-rest). 

Network Encryption
~~~~~~~~~~~~~~~~~~

MinIO supports :ref:`Transport Layer Security (TLS) <minio-TLS>` encryption of
incoming and outgoing traffic. 

TLS is the successor to Secure Socket Layer (SSL) encryption. SSL is fully
`deprecated <https://tools.ietf.org/html/rfc7568>`__ as of June 30th, 2018. 
MinIO uses only supported (non-deprecated) TLS protocols (TLS 1.2 and later).

See :ref:`minio-encryption-tls` for more complete documentation.

Server-Side Object Encryption (SSE)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports :ref:`Server-Side Object Encryption (SSE) <minio-sse>` of
objects, where MinIO uses a secret key to encrypt and store objects on disk
(encryption at-rest). MinIO SSE requires :ref:`minio-encryption-tls`. 
See :ref:`minio-sse` for more complete documentation.

.. toctree::
   :titlesonly:
   :hidden:

   /security/minio-identity-management/basic-authentication-with-minio-identity-provider
   /security/openid-external-identity-management/external-authentication-with-openid-identity-provider
   /security/ad-ldap-external-identity-management/external-authentication-with-ad-ldap-identity-provider
   /security/encryption/encryption-key-management

