Enable Server-Side Encryption using Hashicorp Vault for Local Development
-------------------------------------------------------------------------

This procedure assumes deploying MinIO and KES onto the same host.
You can use and modify the information below to better suit your local development environment.

This procedure assumes the following:

- An existing Vault deployment
- A single host machine for deploying KES and MinIO

.. admonition:: Set Up Folder Hierarchy
   :class: note

   Create the following folders on the host machine if they do not already exist.

   .. code-block:: shell
      :class: copyable
      :substitutions:

      mkdir -P |kescertpath|
      mkdir -P |kesconfigpath|
      mkdir -P |miniocertpath|
      mkdir -P |minioconfigpath|
      mkdir -P |miniodatapath|

   This procedure uses these paths in the following steps. 
   If you use different paths, make the necessary modifications for each step to reflect those changes

1) Download the KES Server Binary
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/linux/common-minio-kes.rst
   :start-after: start-kes-download-desc
   :end-before: end-kes-download-desc

2) Generate TLS Certificates for KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-generate-kes-certs-desc
   :end-before: end-kes-generate-kes-certs-desc

Depending on your Vault configuration, you may need to pass the ``kes-server.cert`` certificate as a trusted Certificate Authority. 
See the `Hashicorp Server Configuration Documentation <https://www.vaultproject.io/docs/configuration/listener/tcp#tls_client_ca_file>`__ for more information.
Defer to the client documentation for instructions on trusting a third-party CA.

3) Create the KES and MinIO Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. container:: procedure

   a. Create the KES Configuration File

      Create the configuration file using your preferred text editor.
      The following example uses ``nano``:

      .. code-block:: shell
         :substitutions:

         nano |kesconfigpath|/kes-config.yaml

      .. include:: /includes/common/common-minio-kes-hashicorp.rst
         :start-after: start-kes-configuration-hashicorp-vault-desc
         :end-before: end-kes-configuration-hashicorp-vault-desc

      - Set ``MINIO_IDENTITY_HASH`` to the identity hash of the MinIO mTLS certificate.

        The following command computes the necessary hash:

        .. code-block:: shell
           :class: copyable
           :substitutions:

           kes identity of |miniocertpath|/minio-kes.cert

      - Replace the ``vault.endpoint`` with the hostname of the Vault server(s).
      - Set the ``vault.engine`` and ``vault.version`` to the appropriate values for the Vault K/V Engine configuration
      - Replace the ``VAULTAPPID`` and ``VAULTAPPSECRET`` with the appropriate :ref:`Vault AppRole credentials <minio-sse-vault-prereq-vault>`.

   b. Create the MinIO Environment File

      Create or modify the environment file for the MinIO deployment using your preferred text editor.
      The following example uses ``nano``:

      .. code-block:: shell
         :substitutions:

         nano |minioconfigpath|/minio

      .. include:: /includes/common/common-minio-kes.rst
         :start-after: start-kes-configuration-minio-desc
         :end-before: end-kes-configuration-minio-desc

4) Start KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes-hashicorp.rst
   :start-after: start-kes-vault-seal-unseal-desc
   :end-before: end-kes-vault-seal-unseal-desc

You must start KES *before* starting MinIO. 
The MinIO deployment requires access to KES as part of its startup.

.. container:: procedure

   a. Start the KES Server

      .. include:: /includes/common/common-minio-kes.rst
         :start-after: start-kes-start-server-desc
         :end-before: end-kes-start-server-desc

   b. Start the MinIO Server

      .. include:: /includes/common/common-minio-kes.rst
         :start-after: start-kes-minio-start-server-desc
         :end-before: end-kes-minio-start-server-desc

Foreground processes depend on the shell or terminal in which they run.
Exiting or terminating the shell/terminal instance also kills the attached process.
Defer to your operating system best practices for running processes in the background.

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
