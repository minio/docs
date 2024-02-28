Deploy MinIO and KES with Server-Side Encryption
------------------------------------------------

Prior to starting these steps, create the following folders:

.. code-block:: powershell
   :class: copyable
   :substitutions:

   New-Item -Path "|kescertpath|" -ItemType "directory"
   New-Item -Path "|kesconfigpath|" -ItemType "directory"
   New-Item -Path "|miniodatapath|" -ItemType "directory"

Prerequisite
~~~~~~~~~~~~

Depending on your chosen :kes-docs:`supported KMS target <#supported-kms-targets>` configuration, you may need to pass the ``kes-server.cert`` as a trusted Certificate Authority (CA).
Defer to the client documentation for instructions on trusting a third-party CA.

1) Create the MinIO Configurations
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

2) Start the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::

   You **must** start KES *before* starting MinIO. 
   The MinIO deployment requires access to KES as part of its startup.

Start the MinIO Server

.. include:: /includes/windows/common-minio-kes.rst
   :start-after: start-kes-minio-start-server-desc
   :end-before: end-kes-minio-start-server-desc

3) Generate a New Encryption Key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/windows/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

4) Enable SSE-KMS for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-enable-sse-kms-desc
   :end-before: end-kes-enable-sse-kms-desc
