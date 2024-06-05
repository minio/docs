.. _minio-server-envvar-kes:

===============================
Key Encryption Service Settings
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. |SSE| replace:: :abbr:`SSE (Server-Side Encryption)`

MinIO Server includes three groups of environment variables to manage how the MinIO Server interacts with the Key Encryption Service (KES), Key Management Service (KMS), or static key files.
You may only define one of the three sets.
If more than one type of environment variable sets is defined, MinIO returns an error.

.. note::

   These settings do not have configuration setting options for use with :mc:`mc admin config set`.

Define any one set of these environment variables in the host system prior to starting or restarting the MinIO process.
Refer to your operating system's documentation for how to define an environment variable.

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-test-before-prod
   :end-before: end-minio-settings-test-before-prod

Key Encryption Service
----------------------

Define the following variables to use the Key Encryption Service (KES) to connect to a :kes-docs:`supported 3rd party Key Management Service provider <#supported-kms-targets>`.

.. envvar:: MINIO_KMS_KES_ENDPOINT

   The endpoint(s) for the MinIO Key Encryption Service (KES) process to use for supporting SSE-S3 and MinIO backend encryption operations.
   Separate multiple KES endpoints with a ``,``.

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

.. envvar:: MINIO_KMS_KES_API_KEY

   Preferred method for authenticating with the encryption service using the KES API key obtained from the :kes-docs:`kes identity new <cli/kes-identity/new/>` command.

   This environment variable is mutually exclusive with the :envvar:`MINIO_KMS_KES_KEY_FILE` and :envvar:`MINIO_KMS_KES_CERT_FILE` environment variables.

.. envvar:: MINIO_KMS_KES_KEY_FILE

   The private key associated to the the :envvar:`MINIO_KMS_KES_CERT_FILE` x.509 certificate to use when authenticating to the KES server. 
   The KES server requires clients to present their certificate for performing mutual TLS (mTLS).

   See the :minio-git:`KES wiki <kes/wiki/Configuration#policy-configuration>` for more complete documentation on KES access control.'

   You must also set the :envvar:`MINIO_KMS_KES_CERT_FILE`.
   This variable is mutually exclusive with :envvar:`MINIO_KMS_KES_API_KEY`.

.. envvar:: MINIO_KMS_KES_CERT_FILE

   The x.509 certificate to present to the KES server. 
   The KES server requires clients to present their certificate for performing mutual TLS (mTLS).

   The KES server computes an :minio-git:`identity <kes/wiki/Configuration#policy-configuration>` from the certificate and compares it to its configured    policies. 
   The KES server grants the :mc:`minio` server access to only those operations explicitly granted by the policy.

   See the :minio-git:`KES wiki <kes/wiki/Configuration#policy-configuration>` for more complete documentation on KES access control.

   You must also set the :envvar:`MINIO_KMS_KES_KEY_FILE`.
   This variable is mutually exclusive with :envvar:`MINIO_KMS_KES_API_KEY`.

.. envvar:: MINIO_KMS_KES_CAPATH
   :optional:

   Allows validation of the KES Server Certificate for a Self-Signed or Third-Party :abbr:`CA <Certificate Authority>`.
   Specify the path to the location of the :abbr:`CA <Certificate Authority>` certificate for your KES deployment.

   This variable is not required if you use a public certificate authority.

.. envvar:: MINIO_KMS_KES_KEY_PASSWORD
   :optional:

   The password used to encrypt and decrypt the TLS private key, if used.

MinIO Key Management Server (KMS)
---------------------------------

Define the following variables to use `MinIO KMS <https://min.io/product/enterprise/key-management-server?ref=docs`__ to manage keys.

.. envvar:: MINIO_KMS_SERVER

   The endpoint(s) for the MinIO Key Management Service (KMS) process to use for supporting SSE-S3 and MinIO backend encryption operations.
   Separate multiple KMS endpoints with a ``,``.

.. envvar:: MINIO_KMS_ENCLAVE

   The MinIO KMS Enclave where the key and identity exist.

.. envvar:: MINIO_KMS_SSE_KEY

   The default key to use for SSE-S3 encryption when a call does not specify a key identity.

.. envvar:: MINIO_KMS_API_KEY

   The credential used to authenticate with the MinIO KMS service.

Static Key Files
----------------

Provide a static KMS key or key file to use for encryption.

.. envvar:: MINIO_KMS_SECRET_KEY

   The base64 form of the static KMS key in the form ``<key-name>:<base64-32byte-key>``. 
   Implements a subset of KMS APIs.

.. envvar:: MINIO_KMS_SECRET_KEY_FILE

   Path to the file to read the static KMS key from.
