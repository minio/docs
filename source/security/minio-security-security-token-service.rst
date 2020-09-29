.. _minio-sts-overview:

============================
MinIO Security Token Service
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

The MinIO Security Token Service (STS) is an endpoint service that enables
clients to request temporary credentials for MinIO resources. Temporary
credentials work almost identically to default admin credentials, with some
differences:

- Temporary credentials are short-term, as the name implies. They can be
  configured to last for anywhere from a few minutes to several hours. After the
  credentials expire, MinIO no longer recognizes them or allows any kind of
  access from API requests made with them.

- Temporary credentials do not need to be stored with the application but are
  generated dynamically and provided to the application when requested. When (or
  even before) the temporary credentials expire, the application can request new
  credentials.

Consider the following advantages of using temporary credentials:

- Eliminates the need to embed long-term credentials with an application.

- Eliminates the need to provide access to buckets and objects without having to
  define static credentials.

- Temporary credentials have a limited lifetime, there is no need to rotate them
  or explicitly revoke them. Expired temporary credentials cannot be reused.

Identity Federation
-------------------

MinIO STS supports the following identity federation providers:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Provider
     - Description

   * - OpenID Providers
     - Applications can request a client credential grant from an
       OpenID-compatible identity provider. Clients validate their identity
       using a JWT access token supplied by the identity provider.
     
       See <doc> for more information on configuring OpenID-based identity
       federation.

   * - OpenID WebIdentity
     - Applications can request temporary credentials using any OpenID (OIDC)
       compatible web identity provider. See <doc> for more information.

   * - AssumeRole
     - Applications can request temporary credentials using a MinIO User
       access and secret key.

   * - Active Directory / Lightweight Directory Access Protocol (AD/LDAP)
     - Applications can request temporary credentials using an external 
       AD/LDAP service.

