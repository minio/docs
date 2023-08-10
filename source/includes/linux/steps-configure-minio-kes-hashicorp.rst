Procedure
---------

This procedure provides instructions for configuring and enabling Server-Side Encryption using Hashicorp Vault in production environments. 
Specifically, this procedure assumes the following:

- An existing production-grade Vault deployment
- One or more hosts for deploying KES
- One or more hosts for a new or existing MinIO deployment

1) Download KES and Create the Service File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. container:: procedure

   a. Download KES

      .. include:: /includes/linux/common-minio-kes.rst
         :start-after: start-kes-download-desc
         :end-before: end-kes-download-desc

   b. Create the Service File

      .. include:: /includes/linux/common-minio-kes.rst
         :start-after: start-kes-service-file-desc
         :end-before: end-kes-service-file-desc

2) Generate TLS Certificates for KES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/linux/common-minio-kes.rst
   :start-after: start-kes-generate-kes-certs-prod-desc
   :end-before: end-kes-generate-kes-certs-prod-desc

Depending on your Vault configuration, you may also need to specify the CA used to sign the KES certificates to the Vault server.
See the `Hashicorp Vault Configuration Docs <https://www.vaultproject.io/docs/configuration/listener/tcp#tls_client_ca_file>`__ for more information.
Defer to the client documentation for instructions on trusting a third-party CA.

3) Generate a KES API Key for use by MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with KES version :minio-git:`2023-02-15T14-54-37Z <kes/releases/tag/2023-02-15T14-54-37Z>`, you can generate an API key to use for authenticating to the KES server.

Use the :kes-docs:`kes identity new <cli/kes-identity/new>` command to generate a new API key for use by the MinIO Server:

.. code-block:: shell
   :class: copyable

   kes identity new

The output includes both the API Key for use with MinIO and the Identity hash for use with the :kes-docs:`KES Policy configuration <tutorials/configuration/#policy-configuration>`.

4) Create the KES and MinIO Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. important::

   Starting with :minio-release:`RELEASE.2023-02-17T17-52-43Z`, MinIO requires expanded KES permissions for functionality.
   The example configuration in this section contains all required permissions.

.. container:: procedure

   a. Create the KES Configuration File

      Create the configuration file using your preferred text editor.
      The following example uses ``nano``:

      .. code-block:: shell
         :substitutions:

         nano /opt/kes/config.yaml

      .. include:: /includes/common/common-minio-kes-hashicorp.rst
         :start-after: start-kes-configuration-hashicorp-vault-desc
         :end-before: end-kes-configuration-hashicorp-vault-desc

      - Set ``MINIO_IDENTITY_HASH`` to the identity hash of the API Key generated in the previous step.

        The following command recomputes the necessary hash from the API key:

        .. code-block:: shell
           :class: copyable

           kes identity of kes:v1:KEY/KEY

      - Replace the ``keystore.vault.endpoint`` with the hostname of the Vault server(s).

      - Replace ``keystore.vault.engine`` and ``keystore.vault.version`` with the path and version of the KV engine used for storing secrets.

      - Replace the ``VAULTAPPID`` and ``VAULTAPPSECRET`` with the appropriate :ref:`Vault AppRole credentials <minio-sse-vault-prereq-vault>`.

      - Modify the ``keystore.vault.tls.ca`` value to correspond to the path to the Vault :abbr:`CA (Certificate Authority)` certificate used to sign the Vault TLS keys.

   b. Configure the MinIO Environment File

      Create or modify the MinIO Server environment file for all hosts in the target deployment to include the following environment variables:

      .. include:: /includes/common/common-minio-kes.rst
         :start-after: start-kes-configuration-minio-desc
         :end-before: end-kes-configuration-minio-desc

      MinIO defaults to expecting this file at ``/etc/default/minio``.
      If you modified your deployment to use a different location for the environment file, modify the file at that location.

5) Start KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes-hashicorp.rst
   :start-after: start-kes-vault-seal-unseal-desc
   :end-before: end-kes-vault-seal-unseal-desc

You must start KES *before* starting MinIO. 
The MinIO deployment requires access to KES as part of its startup.

This step uses ``systemd`` for starting and managing both the KES and MinIO server processes:

a. Start the KES Service on All Hosts

   .. include:: /includes/linux/common-minio-kes.rst
      :start-after: start-kes-start-service-desc
      :end-before: end-kes-start-service-desc

b. Start the MinIO Server

   .. include:: /includes/linux/common-minio-kes.rst
      :start-after: start-kes-minio-start-service-desc
      :end-before: end-kes-minio-start-service-desc

5) Generate a New Encryption Key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes-hashicorp.rst
   :start-after: start-kes-vault-seal-unseal-desc
   :end-before: end-kes-vault-seal-unseal-desc

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

6) Enable SSE-KMS for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-enable-sse-kms-desc
   :end-before: end-kes-enable-sse-kms-desc
