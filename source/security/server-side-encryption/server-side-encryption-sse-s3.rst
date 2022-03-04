.. _minio-encryption-sse-s3:

==================================================
Server-Side Encryption Per-Deployment Key (SSE-S3)
==================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. |EK|  replace:: :abbr:`EK (External Key)`
.. |DEK| replace:: :abbr:`DEK (Data Encryption Key)`
.. |KEK| replace:: :abbr:`KEK (Key Encryption Key)`
.. |OEK| replace:: :abbr:`OEK (Object Encryption Key)`
.. |SSE| replace:: :abbr:`SSE (Server-Side Encryption)`
.. |KMS| replace:: :abbr:`KMS (Key Management Service)`
.. |KES| replace:: :abbr:`KES (Key Encryption Service)`

MinIO Server-Side Encryption (SSE) protects objects as part of write operations,
allowing clients to take advantage of server processing power to secure objects
at the storage layer (encryption-at-rest). SSE also provides key functionality
to regulatory and compliance requirements around secure locking and erasure.

MinIO SSE uses the :minio-git:`MinIO Key Encryption Service (KES) <kes>` and an
external Key Management Service (KMS) for performing secured cryptographic
operations at scale. MinIO also supports client-managed key management, where
the application takes full responsibility for creating and managing encryption
keys for use with MinIO SSE. 

MinIO SSE-S3 en/decrypts objects using an External Key (EK) managed by a 
Key Management System (KMS). You must specify the |EK| using the 
:envvar:`MINIO_KMS_KES_KEY_NAME` environment variable when starting up the
MinIO server. MinIO uses the same EK for *all* SSE-S3 cryptographic operations.

You can enable bucket-default SSE-S3 encryption using the 
:mc-cmd:`mc encrypt set` command:

.. code-block:: shell
   :class: copyable

   mc encrypt set sse-s3 play/mybucket

- Replace ``play/mybucket`` with the :mc-cmd:`alias <mc alias>` and bucket 
  on which you want to enable automatic SSE-KMS encryption.

MinIO SSE-S3 is functionally compatible with AWS S3 
:s3-docs:`Server-Side Encryption with Amazon S3-Managed Keys
<UsingServerSideEncryption.html>` while expanding support to include the
following KMS providers:

- :ref:`AWS SecretsManager <minio-sse-aws>`
- :ref:`Google Cloud SecretManager <minio-sse-gcp>`
- :ref:`Azure Key Vault <minio-sse-azure>`
- :ref:`Hashicorp KeyVault <minio-sse-vault>`
- Thales CipherTrust (formerly Gemalto KeySecure)

.. _minio-encryption-sse-s3-quickstart:

Quickstart
----------

The following procedure uses the ``play`` MinIO |KES| sandbox for 
supporting |SSE| with SSE-S3 in evaluation and early development environments.

For extended development or production environments, use one of the following
supported external Key Management Services (KMS):

- :ref:`AWS SecretsManager <minio-sse-aws>`
- :ref:`Google Cloud SecretManager <minio-sse-gcp>`
- :ref:`Azure Key Vault <minio-sse-azure>`
- :ref:`Hashicorp KeyVault <minio-sse-vault>`
- Thales CipherTrust (formerly Gemalto KeySecure)

.. include:: /includes/common-minio-kes.rst
   :start-after: start-kes-play-sandbox-warning
   :end-before: end-kes-play-sandbox-warning

This procedure requires the following components:

- Install :mc:`mc` on a machine with network access to the source
  deployment. See the ``mc`` :ref:`Installation Quickstart <mc-install>` for
  instructions on downloading and installing ``mc``.


- Install :minio-git:`MinIO Key Encryption Service (KES) <kes>` on a machine
  with internet access. See the ``kes``
  :minio-git:`Getting Started <kes/wiki/Getting-Started>` guide for 
  instructions on downloading, installing, and configuring KES.


1) Create an Encryption Key for SSE-S3 Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :minio-git:`kes <kes>` commandline tool to create a new External Key
(EK) for use with SSE-S3 Encryption.

Issue the following command to retrieve the root 
:minio-git:`identity <kes/wiki/Configuration#policy-configuration>` for the KES
server:

.. code-block:: shell
   :class: copyable

   curl -sSL --tlsv1.2 \
     -O 'https://raw.githubusercontent.com/minio/kes/master/root.key' \
     -O 'https://raw.githubusercontent.com/minio/kes/master/root.cert'

Set the following environment variables in the terminal or shell:

.. code-block:: shell
   :class: copyable

   export KES_CLIENT_KEY=root.key
   export KES_CLIENT_CERT=root.cert

.. list-table::
   :stub-columns: 1
   :widths: 40 60
   :width: 100%

   * - ``KES_CLIENT_KEY``
     - The private key for an :minio-git:`identity
       <kes/wiki/Configuration#policy-configuration>` on the KES server.
       The identity must grant access to at minimum the ``/v1/create``,
       ``/v1/generate``, and ``/v1/list`` :minio-git:`API endpoints 
       <kes/wiki/Server-API#api-overview>`. This step uses the root
       identity for the MinIO ``play`` KES sandbox, which provides access
       to all operations on the KES server.

   * - ``KES_CLIENT_CERT``
     - The corresponding certificate for the :minio-git:`identity
       <kes/wiki/Configuration#policy-configuration>` on the KES server.
       This step uses the root identity for the MinIO ``play`` KES
       sandbox, which provides access to all operations on the KES server.

Issue the following command to create a new |EK| through
KES:

.. code-block:: shell
   :class: copyable

   kes key create my-minio-sse-s3-key

This tutorial uses the example ``my-minio-sse-s3-key`` name for ease of
reference. Specify a unique key name to prevent collision with existing keys.

2) Configure MinIO for SSE-S3 Object Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
Specify the following environment variables in the shell or terminal on each
MinIO server host in the deployment:

.. code-block:: shell
   :class: copyable

   export MINIO_KMS_KES_ENDPOINT=https://play.min.io:7373
   export MINIO_KMS_KES_KEY_FILE=root.key
   export MINIO_KMS_KES_CERT_FILE=root.cert
   export MINIO_KMS_KES_KEY_NAME=my-minio-sse-s3-key

.. list-table::
   :stub-columns: 1
   :widths: 30 80

   * - :envvar:`MINIO_KMS_KES_ENDPOINT`
     - The endpoint for the MinIO ``Play`` KES service.

   * - :envvar:`MINIO_KMS_KES_KEY_FILE`
     - The private key file corresponding to an 
       :minio-git:`identity <kes/wiki/Configuration#policy-configuration>`
       on the KES service. The identity must grant permission to 
       create, generate, and decrypt keys. Specify the same
       identity key file as the ``KES_KEY_FILE`` environment variable
       in the previous step.

   * - :envvar:`MINIO_KMS_KES_CERT_FILE`
     - The public certificate file corresponding to an 
       :minio-git:`identity <kes/wiki/Configuration#policy-configuration>`
       on the KES service. The identity must grant permission to 
       create, generate, and decrypt keys. Specify the same
       identity certificate as the ``KES_CERT_FILE`` environment
       variable in the previous step.

   * - :envvar:`MINIO_KMS_KES_KEY_NAME`
     - The name of the External Key (EK) to use for
       performing SSE encryption operations. KES retrieves the |EK| from
       the configured Key Management System (KMS). Specify the name of the
       key created in the previous step. 

3) Restart the MinIO Deployment to Enable SSE-S3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
restart.

4) Configure Automatic Bucket Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Optional*

You can skip this step if you intend to use only client-driven SSE-S3.

Use the :mc-cmd:`mc encrypt set` command to enable automatic SSE-S3 protection
of all objects written to a specific bucket.

.. code-block:: shell
   :class: copyable

   mc encrypt set sse-s3 ALIAS/BUCKET

- Replace :mc-cmd:`ALIAS <mc encrypt set ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment on which you enabled SSE-S3.

- Replace :mc-cmd:`BUCKET <mc encrypt set ALIAS>`  with the full path to the
  bucket or bucket prefix on which you want to enable automatic SSE-S3.

.. _minio-encryption-sse-s3-erasure-locking:

Secure Erasure and Locking
--------------------------

SSE-S3 protects objects using an |EK| specified at server startup
using the :envvar:`MINIO_KMS_KES_KEY_NAME` environment variable. MinIO
therefore *requires* access to that |EK| for decrypting that object.

- Disabling the |EK| temporarily locks SSE-S3-encrypted objects in the
  deployment by rendering them unreadable. You can later enable the |EK|
  to resume normal read operations.

- Deleting the |EK| renders all SSE-S3-encrypted objects in the deployment
  *permanently* unreadable. If the KMS does not have or support backups
  of the |EK|, this process is *irreversible*.

The scope of the |EK| depends on:

- Which buckets specified automatic SSE-S3 encryption, *and*
- Which write operations requested SSE-S3 encryption.

.. _minio-encryption-sse-s3-encryption-process:

Encryption Process
------------------

.. note:: 

   The following section describes MinIO internal logic and functionality.
   This information is purely educational and is not necessary for 
   configuring or implementing any MinIO feature.

SSE-S3 uses an External Key (EK) managed by the configured Key Management
System (KMS) for performing cryptographic operations and protecting objects.
The table below describes each stage of the encryption process:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Stage
     - Description

   * - SSE-Enabled Write Operation
     - MinIO receives a write operation requesting SSE-S3 encryption. 
       MinIO uses the key name specified to 
       :envvar:`MINIO_KMS_KES_KEY_NAME` as the External Key (EK).

   * - Generate the Data Encryption Key (DEK)
     - .. include:: /includes/common-minio-sse.rst
          :start-after: start-sse-dek
          :end-before: end-sse-dek

   * - Generate the Key Encryption Key (KEK)
     - .. include:: /includes/common-minio-sse.rst
          :start-after: start-sse-kek
          :end-before: end-sse-kek

   * - Generate the Object Encryption Key (OEK)
     - .. include:: /includes/common-minio-sse.rst
          :start-after: start-sse-oek
          :end-before: end-sse-oek

   * - Encrypt the Object
     - MinIO uses the |OEK| to encrypt the object *prior* to storing the
       object to disk. MinIO then encrypts the |OEK| with the |KEK|. 

       MinIO stores the encrypted representation of the |OEK| and |DEK| as part
       of the metadata.
