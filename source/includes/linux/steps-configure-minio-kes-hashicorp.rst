#. Generate a KES API Key for use by MinIO

   Use the :kes-docs:`kes identity new <cli/kes-identity/new>` command to generate a new API key for use by the MinIO Server:

   .. code-block:: shell
      :class: copyable

      kes identity new

   The output includes both the API Key for use with MinIO and the Identity hash for use with the :kes-docs:`KES Policy configuration <tutorials/configuration/#policy-configuration>`.

#. Configure the MinIO Environment File

   Create or modify the MinIO Server environment file for all hosts in the target deployment to include the following environment variables:

   .. include:: /includes/common/common-minio-kes.rst
      :start-after: start-kes-configuration-minio-desc
      :end-before: end-kes-configuration-minio-desc

   MinIO defaults to expecting this file at ``/etc/default/minio``.
   If you modified your deployment to use a different location for the environment file, modify the file at that location.

#. Start MinIO

   .. admonition:: KES Operations Requires Unsealed Vault
      :class: important

      Depending on your selected KMS solution, you may need to unseal the key instance to allow normal cryptographic operations, including key creation or retrieval.
      KES requires an unsealed key target to perform its operations.
      
      Refer to the :kes-docs:`documentation for your chosen KMS solution <#supported-kms-targets>` for information regarding whether sealing and unsealing the instance is required for operations.

      You must start KES *before* starting MinIO. 
      The MinIO deployment requires access to KES as part of its startup.

   You can use the :mc:`mc admin service restart` command to restart MinIO:

   .. code-block:: shell
      :class: copyable

      mc admin service restart ALIAS

#. Generate a New Encryption Key

   .. include:: /includes/common/common-minio-kes.rst
      :start-after: start-kes-generate-key-desc
      :end-before: end-kes-generate-key-desc

#. Enable SSE-KMS for a Bucket

   .. include:: /includes/common/common-minio-kes.rst
      :start-after: start-kes-enable-sse-kms-desc
      :end-before: end-kes-enable-sse-kms-desc
