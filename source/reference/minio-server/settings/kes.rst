.. _minio-server-envvar-kes:

===============================
Key Encryption Service Settings
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The following environment variables control how the MinIO Server interacts with the Key Encryption Service (KES) when managing encryption and keys.

.. note::

   These settings do not have configuration setting options for use with :mc:`mc admin config set`.

Define any of these environment variables in the host system prior to starting or restarting the MinIO process.
Refer to your operating system's documentation for how to define an environment variable.

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-test-before-prod
   :end-before: end-minio-settings-test-before-prod

.. envvar:: MINIO_KMS_KES_ENDPOINT

   The endpoint for the MinIO Key Encryption Service (KES) process to use for supporting SSE-S3 and MinIO backend encryption operations.

.. envvar:: MINIO_KMS_KES_KEY_FILE

   The private key associated to the the :envvar:`MINIO_KMS_KES_CERT_FILE` x.509 certificate to use when authenticating to the KES server. 
   The KES server requires clients to present their certificate for performing mutual TLS (mTLS).

   See the :minio-git:`KES wiki <kes/wiki/Configuration#policy-configuration>` for more complete documentation on KES access control.'

.. envvar:: MINIO_KMS_KES_CAPATH

   Allows validation of the KES Server Certificate for a Self-Signed or Third-Party :abbr:`CA <Certificate Authority>`.
   Specify the path to the location of the :abbr:`CA <Certificate Authority>` certificate for your KES deployment.

.. envvar:: MINIO_KMS_KES_CERT_FILE

   The x.509 certificate to present to the KES server. 
   The KES server requires clients to present their certificate for performing mutual TLS (mTLS).

   The KES server computes an :minio-git:`identity <kes/wiki/Configuration#policy-configuration>` from the certificate and compares it to its configured    policies. 
   The KES server grants the :mc:`minio` server access to only those operations explicitly granted by the policy.

   See the :minio-git:`KES wiki <kes/wiki/Configuration#policy-configuration>` for more complete documentation on KES access control.

.. envvar:: MINIO_KMS_KES_KEY_NAME

   The name of an external key on the Key Management system (KMS) configured on the KES server and used for performing en/decryption operations. 
   MinIO uses this key for the following:

   - Encrypting backend data (:ref:`IAM <minio-authentication-and-identity-management>`, server configuration).

   - The default encryption key for Server-Side Encryption with :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   - The encryption key for Server-Side Encryption with :ref:`SSE-S3 <minio-encryption-sse-s3>`.

   .. important::

      .. include:: /includes/common/common-minio-kes.rst
         :start-after: start-kes-encrypted-backend-desc
         :end-before: end-kes-encrypted-backend-desc

.. envvar:: MINIO_KMS_KES_ENCLAVE

   Use this optional environment variable to define the name of a KES enclave.
   A KES enclave provides an isolated space for its associated keys separate from other enclaves on a stateful KES server.

   If not set, MinIO does not send enclave information.
   For a stateful KES server, this results in using the default enclave.
