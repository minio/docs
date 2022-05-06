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

MinIO supports the following STS API endpoints:

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Endpoint
     - Supported IDP
     - Description

   * - AssumeRoleWithWebIdentity
     - OpenID Connect
     - Generates an access key and secret key using the JWT token returned by the OIDC provider

   * - AssumeRoleWithLDAPIdentity
     - Active Directory / LDAP
     - Generates an access key and secret key using the AD/LDAP credentials specified to the API endpoint.

.. toctree::
   :titlesonly:
   :hidden:
   :glob:

   /developers/security-token-service/*