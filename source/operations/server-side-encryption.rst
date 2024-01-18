.. _minio-sse-data-encryption:

=====================
Data Encryption (SSE)
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. |EK| replace:: :abbr:`EK (External Key)`
.. |SSE| replace:: :abbr:`SSE (Server-Side Encryption)`
.. |KMS| replace:: :abbr:`KMS (Key Management System)`

MinIO Server-Side Encryption (SSE) protects objects as part of write operations,
allowing clients to take advantage of server processing power to secure objects
at the storage layer (encryption-at-rest). SSE also provides key functionality
to regulatory and compliance requirements around secure locking and erasure.

MinIO SSE uses the :kes-docs:`MinIO Key Encryption Service (KES) <>` and an
external Key Management Service (KMS) for performing secured cryptographic
operations at scale. MinIO also supports client-managed key management, where
the application takes full responsibility for creating and managing encryption
keys for use with MinIO SSE. 

MinIO supports the following |KMS| providers as the central key store:

- :kes-docs:`Azure Key Vault <integrations/azure-keyvault/>`
- :kes-docs:`AWS SecretsManager <integrations/aws-secrets-manager/>`
- :kes-docs:`Fortanix SDKMS <integrations/fortanix-sdkms/>`
- :kes-docs:`Google Cloud SecretManager <integrations/google-cloud-secret-manager/>`
- :kes-docs:`Hashicorp KeyVault <integrations/hashicorp-vault-keystore/>`
- :kes-docs:`Thales Digital Identity and Security (formerly Gemalto) <integrations/thales-ciphertrust/>`

MinIO SSE requires enabling :ref:`minio-tls`. 

Supported Encryption Types
--------------------------

MinIO SSE is feature and API compatible with 
:s3-docs:`AWS Server-Side Encryption <server-side-encryption.html>` and
supports the following encryption strategies:

.. tab-set::

   .. tab-item:: SSE-KMS *Recommended*
      :sync: sse-kms

      MinIO supports enabling automatic SSE-KMS encryption of all objects
      written to a bucket using a specific External Key (EK) stored on the
      external |KMS|. Clients can override the bucket-default |EK| by specifying
      an explicit key as part of the write operation.

      For buckets without automatic SSE-KMS encryption, clients can specify
      an |EK| as part of the write operation instead.

      SSE-KMS provides more granular and customizable encryption compared to
      SSE-S3 and SSE-C and is recommended over the other supported encryption
      methods.

      For a tutorial on enabling SSE-KMS in a local (non-production) MinIO Deployment, see :ref:`minio-encryption-sse-kms-quickstart`.

   .. tab-item:: SSE-S3
      :sync: sse-s3

      MinIO supports enabling automatic SSE-S3 encryption of all objects
      written to a bucket using an |EK| stored on the external |KMS|. MinIO
      SSE-S3 supports *one* |EK| for the entire deployment.

      For buckets without automatic SSE-S3 encryption, clients can request
      SSE encryption as part of the write operation instead.

      For a tutorial on enabling SSE-s3 in a local (non-production) MinIO Deployment, see :ref:`minio-encryption-sse-s3-quickstart`.

   .. tab-item:: SSE-C
      :sync: sse-c

      Clients specify an |EK| as part of the write operation for an object.
      MinIO uses the specified |EK| to perform SSE-S3. 

      SSE-C does not support bucket-default encryption settings and requires
      clients perform all key management operations.

Configuring a KMS for MinIO
---------------------------

.. cond:: linux

   This procedure provides guidance for deploying MinIO configured to use KES and enable :ref:`Server Side Encryption <minio-sse-data-encryption>`.

   As part of this procedure, you will:

   #. Deploy one or more |KES| servers configured to use a KMS solution.
      You may optionally deploy a load balancer for managing connections to those KES servers.

   #. Create a new |EK| on for use with |SSE|.

   #. Create or modify a MinIO deployment with support for |SSE| using |KES|.
      Defer to the :ref:`Deploy Distributed MinIO <minio-mnmd>` tutorial for guidance on production-ready MinIO deployments.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`

.. cond:: macos or windows

   This procedure assumes a single local host machine running the MinIO and KES processes.
   As part of this procedure, you will:

   #. Deploy a |KES| server configured to use a KMS solution.

   #. Create a new |EK| on Vault for use with |SSE|.

   #. Deploy a MinIO server in :ref:`Single-Node Single-Drive mode <minio-snsd>` configured to use the |KES| container for supporting |SSE|.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with the KMS.

   For production baremetal environments, see the :kes-docs:`KES documentation <>` for tutorials on configuring MinIO with KES and Hashicorp Vault.

.. cond:: container

   This procedure assumes a single host machine running the MinIO and KES containers.
   As part of this procedure, you will:

   #. Deploy a |KES| container configured to use |rootkms-short| as the root |KMS|.

   #. Create a new |EK| on Vault for use with |SSE|.

   #. Deploy a MinIO Server container in :ref:`Single-Node Single-Drive mode <minio-snsd>` configured to use the |KES| container for supporting |SSE|.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with Hashicorp Vault.

   For production baremetal environments, see the MinIO on Linux documentation for tutorials on configuring MinIO with KES and Hashicorp Vault.

.. cond:: k8s

   This procedure assumes you have access to a Kubernetes cluster with an active MinIO Operator installation.
   As part of this procedure, you will:

   #. Use the MinIO Operator Console to create or manage a MinIO Tenant.
   #. Access the :guilabel:`Encryption` settings for that tenant and configure |SSE| using |rootkms-short|.
   #. Create a new |EK| on Vault for use with |SSE|.
   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production baremetal environments, see the MinIO on Linux documentation for tutorials on configuring MinIO with KES and Hashicorp Vault.

.. important::

   .. include:: /includes/common/common-minio-kes.rst
      :start-after: start-kes-encrypted-backend-desc
      :end-before: end-kes-encrypted-backend-desc

.. toctree::
   :titlesonly:
   :hidden:

   /operations/server-side-encryption/configure-minio-kes-hashicorp
   /operations/server-side-encryption/configure-minio-kes-aws
   /operations/server-side-encryption/configure-minio-kes-gcp
   /operations/server-side-encryption/configure-minio-kes-azure