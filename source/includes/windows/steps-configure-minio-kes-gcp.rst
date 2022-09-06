Deploy MinIO and KES with Server-Side Encryption using GCP Secrets Manager
--------------------------------------------------------------------------

Prior to starting these steps, create the following folders:

.. code-block:: powershell
   :class: copyable
   :substitutions:

   New-Item -Path "|kescertpath|" -ItemType "directory"
   New-Item -Path "|kesconfigpath|" -ItemType "directory"
   New-Item -Path "|miniodatapath|" -ItemType "directory"

1) Download KES for Windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/windows/common-minio-kes.rst
   :start-after: start-kes-download-desc
   :end-before: end-kes-download-desc

2) Generate TLS Certificates for KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/windows/common-minio-kes.rst
   :start-after: start-kes-generate-kes-certs-desc
   :end-before: end-kes-generate-kes-certs-desc

3) Create the KES and MinIO Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a. Create the KES Configuration File

   Create the configuration file using your preferred text editor.
   The following example uses the Windows Notepad program:

   .. code-block:: powershell
      :substitutions:

      notepad |kesconfigpath|\kes-config.yaml

   .. include:: /includes/common/common-minio-kes-gcp.rst
      :start-after: start-kes-configuration-gcp-desc
      :end-before: end-kes-configuration-gcp-desc

   - Set ``MINIO_IDENTITY_HASH`` to the identity hash of the MinIO mTLS certificate.

      The following command computes the necessary hash:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         kes.exe tool identity of |miniocertpath|/minio-kes.cert

   - Set ``GCPPROJECTID`` to the GCP project for the Secrets Manager instance KES should use.

   - Set ``GCPCLIENTEMAIL``, ``GCPCLIENTID``, ``GCPPRIVATEKEYID``, and ``GCPPRIVATEKEY`` to the credentials associated to the :ref:`GCP Service Account <minio-sse-gcp-prereq-gcp>` KES should use when accessing the Secrets Manager service.

b. Create the MinIO Environment File

   Create the environment file using your preferred text editor.
   The following example uses the Windows Notepad program:

   .. code-block:: powershell
      :substitutions:

      notepad |minioconfigpath|\minio

   .. include:: /includes/windows/common-minio-kes.rst
      :start-after: start-kes-configuration-minio-desc
      :end-before: end-kes-configuration-minio-desc

4) Start KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~

You must start KES *before* starting MinIO. 
The MinIO deployment requires access to KES as part of its startup.

a. Start the KES Server

   .. include:: /includes/windows/common-minio-kes.rst
      :start-after: start-kes-start-server-desc
      :end-before: end-kes-start-server-desc

b. Start the MinIO Server

   .. include:: /includes/windows/common-minio-kes.rst
      :start-after: start-kes-minio-start-server-desc
      :end-before: end-kes-minio-start-server-desc

5) Generate a New Encryption Key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/windows/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

6) Enable SSE-KMS for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-enable-sse-kms-desc
   :end-before: end-kes-enable-sse-kms-desc
