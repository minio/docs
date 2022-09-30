Deploy MinIO and KES with Server-Side Encryption using Azure Key Vault for Local Development
--------------------------------------------------------------------------------------------

Prior to starting these steps, create the following folders:

.. code-block:: shell
   :class: copyable
   :substitutions:

   mkdir -P |kescertpath|
   mkdir -P |kesconfigpath|
   mkdir -P |miniocertpath|
   mkdir -P |minioconfigpath|
   mkdir -P |miniodatapath|

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

3) Create the KES and MinIO Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a. Create the KES Configuration File

   Create the configuration file using your preferred text editor.
   The following example uses ``nano``:

   .. code-block:: shell
      :substitutions:

      nano |kesconfigpath|/kes-config.yaml

   .. include:: /includes/common/common-minio-kes-azure.rst
      :start-after: start-kes-configuration-azure-desc
      :end-before: end-kes-configuration-azure-desc

   - Set ``MINIO_IDENTITY_HASH`` to the identity hash of the MinIO mTLS certificate.

      The following command computes the necessary hash:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         kes identity of |miniocertpath|/minio-kes.cert

   - Replace the ``endpoint`` with the URL for the Keyvault instance.

   - Set ``TENANTID``, ``CLIENTID``, and ``CLIENTSECRET`` to match the credentials for a project user with the :ref:`required permissions <minio-sse-azure-prereq-azure>`.

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

You must start KES *before* starting MinIO. 
The MinIO deployment requires access to KES as part of its startup.

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

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

6) Enable SSE-KMS for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-enable-sse-kms-desc
   :end-before: end-kes-enable-sse-kms-desc
