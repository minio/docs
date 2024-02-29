Procedure
---------

This procedure provides instructions for configuring and enabling Server-Side Encryption using your selected `supported KMS solution <https://min.io/docs/kes/#supported-kms-targets>`__ in production environments. 
Specifically, this procedure assumes the following:

- An existing production-grade KMS target
- One or more KES servers connected to the KMS target
- One or more hosts for a new or existing MinIO deployment

Prerequisite
~~~~~~~~~~~~

Depending on your chosen :kes-docs:`supported KMS target <#supported-kms-targets>` configuration, you may need to pass the ``kes-server.cert`` as a trusted Certificate Authority (CA).
Defer to the client documentation for instructions on trusting a third-party CA.

1) Generate a KES API Key for use by MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with KES version :minio-git:`2023-02-15T14-54-37Z <kes/releases/tag/2023-02-15T14-54-37Z>`, you can generate an API key to use for authenticating to the KES server.

Use the :kes-docs:`kes identity new <cli/kes-identity/new>` command to generate a new API key for use by the MinIO Server:

.. code-block:: shell
   :class: copyable

   kes identity new

The output includes both the API Key for use with MinIO and the Identity hash for use with the :kes-docs:`KES Policy configuration <tutorials/configuration/#policy-configuration>`.

2) Create the MinIO Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Configure the MinIO Environment File

Create or modify the MinIO Server environment file for all hosts in the target deployment to include the following environment variables:

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-configuration-minio-desc
   :end-before: end-kes-configuration-minio-desc

MinIO defaults to expecting this file at ``/etc/default/minio``.
If you modified your deployment to use a different location for the environment file, modify the file at that location.

3) Start MinIO
~~~~~~~~~~~~~~

.. admonition:: KES Operations Requires Unsealed Vault
   :class: important

   Depending on your selected KMS solution, you may need to unseal the key instance to allow normal cryptographic operations, including key creation or retrieval.
   KES requires an unsealed key target to perform its operations.
   
   Refer to the :kes-docs:`documentation for your chosen KMS solution <#supported-kms-targets>` for information regarding whether sealing and unsealing the instance is required for operations.

   You must start KES *before* starting MinIO. 
   The MinIO deployment requires access to KES as part of its startup.

This step uses ``systemd`` for starting and managing the MinIO server processes:

Start the MinIO Server

.. include:: /includes/linux/common-minio-kes.rst
   :start-after: start-kes-minio-start-service-desc
   :end-before: end-kes-minio-start-service-desc

4) Generate a New Encryption Key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

5) Enable SSE-KMS for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-enable-sse-kms-desc
   :end-before: end-kes-enable-sse-kms-desc
