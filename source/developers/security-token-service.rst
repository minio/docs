.. _minio-security-token-service:

============================
Security Token Service (STS)
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The MinIO Security Token Service (STS) APIs allow applications to generate temporary credentials for accessing the MinIO deployment.

The STS API is *required* for MinIO deployments configured to use external identity managers, as the API allows conversion of the external IDP credentials into AWS Signature v4-compatible credentials.

STS API Endpoints
-----------------

MinIO supports the following STS API endpoints:

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Endpoint
     - Supported IDP
     - Description

   * - :ref:`AssumeRoleWithWebIdentity <minio-sts-assumerolewithwebidentity>`
     - OpenID Connect
     - Generates an access key and secret key using the JWT token returned by the OIDC provider

   * - :ref:`AssumeRoleWithLDAPIdentity <minio-sts-assumerolewithldapidentity>`
     - Active Directory / LDAP
     - Generates an access key and secret key using the AD/LDAP credentials specified to the API endpoint.

   * - :ref:`AssumeRoleWithCustomToken <minio-sts-assumerolewithcustomtoken>`
     - MinIO Identity Plugin
     - Generates a token for use with an external identity provider and the :ref:`MinIO Identity Plugin <minio-external-identity-management-plugin>`.
 

.. toctree::
   :titlesonly:
   :hidden:
   :glob:

   /developers/security-token-service/*