Deploy MinIO and KES with Server-Side Encryption using Hashicorp Vault for Production
-------------------------------------------------------------------------------------

Prior to starting these steps, create the following folders if they do not already exist:

.. code-block:: shell
   :class: copyable
   :substitutions:

   mkdir -P |kescertpath|
   mkdir -P |kesconfigpath|
   mkdir -P |miniocertpath|

1) Download KES and Create the Service File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a. Download KES

   .. include:: /includes/linux/common-minio-kes.rst
      :start-after: start-kes-download-desc
      :end-before: end-kes-download-desc

b. Create the Service File

   .. include:: /includes/linux/common-minio-kes.rst
      :start-after: start-kes-service-file-desc
      :end-before: end-kes-service-file-desc

2) Generate TLS Certificates for KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/linux/common-minio-kes.rst
   :start-after: start-kes-generate-kes-certs-prod-desc
   :end-before: end-kes-generate-kes-certs-prod-desc

Depending on your Vault configuration, you may also need to specify the CA used to sign the KES certificates to the Vault server.
See the `Hashicorp Vault Configuration Docs <https://www.vaultproject.io/docs/configuration/listener/tcp#tls_client_ca_file>`__ for more information.
Defer to the client documentation for instructions on trusting a third-party CA.

3) Create the KES and MinIO Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a. Create the KES Configuration File

   Create the configuration file using your preferred text editor.
   The following example uses ``nano``:

   .. code-block:: shell
      :substitutions:

      nano /opt/kes/config.yaml

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

   - Replace the ``VAULTAPPID`` and ``VAULTAPPSECRET`` with the appropriate :ref:`Vault AppRole credentials <minio-sse-vault-prereq-vault>`.

b. Configure the MinIO Environment File

   Modify the MinIO Server environment file for all hosts in the target deployment to include the following environment variables.

   MinIO defaults to expecting this file at ``/etc/default/minio``.
   If you modified your deployment to use a different location for the environment file, modify the file at that location.

   .. include:: /includes/linux/common-minio-kes.rst
      :start-after: start-kes-configuration-minio-desc
      :end-before: end-kes-configuration-minio-desc

4) Start KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~

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

.. include:: /includes/linux/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

6) Enable SSE-KMS for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-enable-sse-kms-desc
   :end-before: end-kes-enable-sse-kms-desc
