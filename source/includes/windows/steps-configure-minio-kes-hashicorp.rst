Deploy MinIO and KES with Server-Side Encryption
------------------------------------------------

Prior to starting these steps, create the following folders:

.. code-block:: powershell
   :class: copyable
   :substitutions:

   New-Item -Path "|kescertpath|" -ItemType "directory"
   New-Item -Path "|kesconfigpath|" -ItemType "directory"
   New-Item -Path "|miniodatapath|" -ItemType "directory"

1) Generate TLS Certificates for KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/windows/common-minio-kes.rst
   :start-after: start-kes-generate-kes-certs-desc
   :end-before: end-kes-generate-kes-certs-desc

2) Create the MinIO Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create the MinIO Environment File

Create the environment file using your preferred text editor.
The following example uses the Windows Notepad program:

.. code-block:: powershell
   :substitutions:

   notepad |minioconfigpath|\minio

.. include:: /includes/windows/common-minio-kes.rst
   :start-after: start-kes-configuration-minio-desc
   :end-before: end-kes-configuration-minio-desc

3) Start the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::

   You **must** start KES *before* starting MinIO. 
   The MinIO deployment requires access to KES as part of its startup.

Start the MinIO Server

.. include:: /includes/windows/common-minio-kes.rst
   :start-after: start-kes-minio-start-server-desc
   :end-before: end-kes-minio-start-server-desc

4) Generate a New Encryption Key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/windows/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

5) Enable SSE-KMS for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-enable-sse-kms-desc
   :end-before: end-kes-enable-sse-kms-desc
