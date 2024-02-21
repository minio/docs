Deploy MinIO and KES with Server-Side Encryption
------------------------------------------------

Prior to starting these steps, create the following folders:

.. code-block:: shell
   :class: copyable
   :substitutions:

   mkdir -P |kescertpath|
   mkdir -P |kesconfigpath|
   mkdir -P |miniodatapath|

1) Download the KES Binary
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/macos/common-minio-kes.rst
   :start-after: start-kes-download-desc
   :end-before: end-kes-download-desc

2) Generate TLS Certificates for KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-generate-kes-certs-desc
   :end-before: end-kes-generate-kes-certs-desc

Depending on your chosen :kes-docs:`supported KMS target <#supported-kms-targets>` configuration, you may need to pass the ``kes-server.cert`` as a trusted Certificate Authority.
Defer to the client documentation for instructions on trusting a third-party CA.

1) Create the KES and MinIO Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a. Create the KES Configuration File

   Create the :kes-docs:`configuration file <tutorials/configuration/#config-file>` using your preferred text editor.
   The following example uses ``nano``:

   .. code-block:: shell
      :substitutions:

      nano |kesconfigpath|/kes-config.yaml

   - Set ``MINIO_IDENTITY_HASH`` to the identity hash of the MinIO mTLS certificate.

      The following command computes the necessary hash:

      .. note::
               
         Depending on your selected KMS solution, you may need to unseal the key instance to allow normal cryptographic operations, including key creation or retrieval.
         KES requires an unsealed key target to perform its operations.

      .. code-block:: shell
         :class: copyable
         :substitutions:

         kes identity of |miniocertpath|/minio-kes.cert

   Refer to the documentation for your selected :kes-docs:`supported KMS solution <#supported-kms-targets>` for details on config items specific to your provider.

b. Create the MinIO Environment File

   Create the environment file using your preferred text editor.
   The following example uses ``nano``:

   .. code-block:: shell
      :substitutions:

      nano |minioconfigpath|/minio

   .. include:: /includes/common/common-minio-kes.rst
      :start-after: start-kes-configuration-minio-desc
      :end-before: end-kes-configuration-minio-desc

1) Start KES and MinIO
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
