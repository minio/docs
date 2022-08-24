==================
Security Checklist
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Use the following checklist when planning the security configuration for a production, distributed MinIO deployment.

Required Steps
--------------

.. list-table::
   :widths: auto
   :width: 100%

   * - :octicon:`circle`
     - Define group policies either on MinIO or the selected 3rd party Identity Provider (LDAP/Active Directory or OpenID)

   * - :octicon:`circle`
     - Define individual access policies on MinIO or the selected 3rd party Identity Provider

   * - :octicon:`circle`
     - (For Kubernetes deployments only) Configure the tenant(s) to use the selected 3rd party Identity Provider


:ref:`Encryption-at-Rest <minio-sse>`
-------------------------------------

MinIO supports the following external KMS providers through Key Encryption Service (KES):

- :ref:`Hashicorp Vault Root KMS <minio-sse-vault>`
- :ref:`AWS Root KMS <minio-sse-aws>`
- :ref:`Google Cloud Platform Secret Manager Root KMS <minio-sse-gcp>`
- :ref:`Azure Key Vault Root KMS <minio-sse-azure>`

.. list-table::
   :widths: auto
   :width: 100%

   * - :octicon:`circle`
     - Download and install the MinIO Key Encryption Service (KES)

   * - :octicon:`circle`
     - Enable TLS

   * - :octicon:`circle`
     - Generate private and public keys for KES

   * - :octicon:`circle`
     - Generate private and public keys for MinIO

   * - :octicon:`circle`
     - Create a KES configuration file and start the service

   * - :octicon:`circle`
     - Generate an external key for the key management service (KMS)

   * - :octicon:`circle`
     - Connect MinIO to the KES

   * - :octicon:`circle`
     - Enable server side encryption


:ref:`Encryption-in-Transit ("In flight") <minio-tls>`
------------------------------------------------------

.. list-table::
   :widths: auto
   :width: 100%

   * - :octicon:`circle`
     - :ref:`Enable TLS <minio-tls>`

   * - :octicon:`circle`
     - Add separate certificates and keys for each internal and external domain that accesses MinIO

   * - :octicon:`circle`
     - Generate public and private TLS keys using a supported cipher for TLS 1.3 or TLS 1.2

   * - :octicon:`circle`
     - Configure trusted Certificate Authority (CA) store(s)

   * - :octicon:`circle`
     - Expose your Kubernetes service, such as with NGINX

   * - :octicon:`circle`
     - (Optional) Validate certificates, such as with https://www.sslchecker.com/certdecoder
