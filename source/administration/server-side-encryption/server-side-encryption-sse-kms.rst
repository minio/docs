.. _minio-encryption-sse-kms:

=====================================================
Server-Side Encryption with Per-Bucket Keys (SSE-KMS)
=====================================================

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

MinIO SSE-KMS en/decrypts objects using an External Key (EK) managed by a Key
Management System (KMS). Each bucket and object can have a separate |EK|,
supporting more granular cryptographic operations in the deployment. MinIO can
only decrypt an object if it can access both the KMS *and* the |EK| used to
encrypt that object.

You can enable bucket-default SSE-KMS encryption using the 
:mc:`mc encrypt set` command:

.. code-block:: shell
   :class: copyable

   mc encrypt set sse-kms EXTERNALKEY play/mybucket

- Replace ``EXTERNALKEY`` with the name of the |EK| to use for encrypting
  objects in the bucket.

- Replace ``play/mybucket`` with the :mc:`alias <mc alias>` and bucket 
  on which you want to enable automatic SSE-KMS encryption.

MinIO SSE-KMS is functionally compatible with AWS S3 :s3-docs:`Server-Side Encryption with KMS keys stored in AWS <UsingKMSEncryption.html>` while expanding support to include the following KMS providers:

- :kes-docs:`AWS Secrets Manager <integrations/aws-secrets-manager/>`
- :kes-docs:`Azure Key Vault <integrations/azure-keyvault/>`
- :kes-docs:`Entrust KeyControl <integrations/entrust-keycontrol/>`
- :kes-docs:`Fortanix SDKMS <integrations/fortanix-sdkms/>`
- :kes-docs:`Google Cloud Secret Manager <integrations/google-cloud-secret-manager/>`
- :kes-docs:`Hashicorp Vault Keystore <integrations/hashicorp-vault-keystore/>`
- :kes-docs:`Thales CipherTrust Manager (formerly Gemalto KeySecure) <integrations/thales-ciphertrust/>`

.. _minio-encryption-sse-kms-quickstart:

Quickstart
----------

The following procedure uses the ``play`` MinIO |KES| sandbox for 
supporting |SSE| with SSE-KMS in evaluation and early development environments.

For extended development or production environments, use one of the following
supported external Key Management Services (KMS):

- :kes-docs:`AWS Secrets Manager <integrations/aws-secrets-manager/>`
- :kes-docs:`Azure Key Vault <integrations/azure-keyvault/>`
- :kes-docs:`Entrust KeyControl <integrations/entrust-keycontrol/>`
- :kes-docs:`Fortanix SDKMS <integrations/fortanix-sdkms/>`
- :kes-docs:`Google Cloud Secret Manager <integrations/google-cloud-secret-manager/>`
- :kes-docs:`Hashicorp Vault Keystore <integrations/hashicorp-vault-keystore/>`
- :kes-docs:`Thales CipherTrust Manager (formerly Gemalto KeySecure) <integrations/thales-ciphertrust/>`

.. include:: /includes/common/common-minio-kes.rst
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

1) Create an Encryption Key for SSE-KMS Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :minio-git:`kes <kes>` commandline tool to create a new External Key
(EK) for use with SSE-KMS Encryption.

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
KES.

.. code-block:: shell
   :class: copyable

   kes key create my-minio-sse-kms-key

This tutorial uses the example ``my-minio-sse-kms-key`` name for ease of
reference. Specify a unique key name to prevent collision
with existing keys.

2) Configure MinIO for SSE-KMS Object Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
Specify the following environment variables in the shell or terminal on each
MinIO server host in the deployment:

.. code-block:: shell
   :class: copyable

   export MINIO_KMS_KES_ENDPOINT=https://play.min.io:7373
   export MINIO_KMS_KES_KEY_FILE=root.key
   export MINIO_KMS_KES_CERT_FILE=root.cert
   export MINIO_KMS_KES_KEY_NAME=my-minio-sse-kms-key

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
       the configured Key Management Service (KMS). Specify the name of the
       key created in the previous step. 


3) Restart the MinIO Deployment to Enable SSE-KMS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
restart.

4) Configure Automatic Bucket Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc encrypt set` command to enable automatic SSE-KMS protection
of all objects written to a specific bucket.

.. code-block:: shell
   :class: copyable

   mc encrypt set sse-kms my-minio-sse-kms-key ALIAS/BUCKET

- Replace :mc-cmd:`ALIAS <mc encrypt set ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment on which you enabled SSE-KMS.

- Replace :mc-cmd:`BUCKET <mc encrypt set ALIAS>`  with the full path to the
  bucket or bucket prefix on which you want to enable automatic SSE-KMS.

Objects written to the specified bucket are automatically encrypted using
the specified |EK|

Repeat this step for each bucket on which you want to enable automatic
SSE-KMS encryption. You can generate additional keys per bucket or bucket
prefix, such that the scope of each |EK| is limited to a subset of objects.


.. _minio-encryption-sse-kms-erasure-locking:

Secure Erasure and Locking
--------------------------

SSE-KMS protects objects using an |EK| specified either as part of the
bucket automatic encryption settings *or* as part of the write operation.
MinIO therefore *requires* access to that |EK| for decrypting that object.

- Disabling the |EK| temporarily locks objects encrypted with that |EK| by
  rendering them unreadable. You can later enable the |EK| to resume
  normal read operations on those objects.

- Deleting the |EK| renders all objects encrypted by that |EK|
  *permanently* unreadable. If the KMS does not have or support backups
  of the |EK|, this process is *irreversible*.

The scope of a single |EK| depends on:

- Which buckets specified that |EK| for automatic SSE-KMS encryption, 
  *and*
- Which write operations specified that |EK| when requesting SSE-KMS 
  encryption.

For example, consider a MinIO deployment using one |EK| per bucket.
Disabling a single |EK| renders all objects in the associated bucket
unreadable without affecting other buckets. If the deployment instead used
one |EK| for all objects and buckets, disabling that |EK| renders all
objects in the deployment unreadable.

.. _minio-encryption-sse-kms-encryption-process:

Encryption Process
------------------

.. note:: 

   This section describes MinIO internal logic and functionality.
   This information is purely educational and is not a prerequisite for 
   configuring or implementing any MinIO feature.

SSE-KMS uses an External Key (EK) managed by the configured Key Management
System (KMS) for performing cryptographic operations and protecting objects.
The table below describes each stage of the encryption process:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Stage
     - Description

   * - SSE-Enabled Write Operation
     - MinIO receives a write operation requesting SSE-KMS encryption. 
       The write operation *must* have an associated External Key (EK) to use
       for encrypting the object.

       - For write operations in buckets with automatic SSE-KMS enabled,
         MinIO uses the bucket |EK|. If the write operation includes an 
         explicit EK, MinIO uses that *instead* of the bucket EK.

       - For write operations in buckets *without* automatic SSE-KMS enabled,
         MinIO uses the |EK| specified to the write operation.

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
       object to the drive. MinIO then encrypts the |OEK| with the |KEK|. 

       MinIO stores the encrypted representation of the |OEK| and |DEK| as part
       of the metadata.

For read operations, MinIO decrypts the object by retrieving the |EK| to
decrypt the |DEK|. MinIO then regenerates the |KEK|, decrypts the |OEK|, and
decrypts the object.
