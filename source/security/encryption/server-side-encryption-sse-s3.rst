.. _minio-server-side-encryption-sse-s3:

===========================================================
Server-Side Encryption using a Customer Master Key (SSE-S3)
===========================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The procedure on this page configures and enables automatic and bucket-level
Server-Side Encryption with a Customer Master Key (SSE-S3). MinIO SSE-S3
supports automatic and client-driven encryption of objects *before* writing
them to disk. MinIO automatically decrypts SSE-S3-encrypted objects as part
of authorized read operations. 

The Customer Master Key (CMK) is managed by an external Key Management System
(KMS). KMS configuration and :abbr:`CMK (Customer Master Key)` generation are
managed by the MinIO :minio-git:`Key Encryption Service <kes>`. MinIO uses KES
for supporting specific cryptographic operations as part of the 
:ref:`encryption process <minio-encryption-sse-encryption-process>`, such as
the retrieval of the CMK and subsequent generation of object encryption keys.

MinIO SSE-S3 is functionally compatible with AWS S3 
:s3-docs:`Server-Side Encryption with Amazon S3-Managed Keys
<UsingServerSideEncryption.html>` while expanding support to include the
following KMS providers:

- AWS SecretsManager
- Google Cloud SecretManager
- Thales CipherTrust (formerly Gemalto KeySecure)
- Hashicorp KeyVault



Requirements
------------

Install and Configure ``mc`` with Access to the MinIO Cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses :mc:`mc` for performing operations on the source MinIO
deployment. Install :mc:`mc` on a machine with network access to the source
deployment. See the ``mc`` :ref:`Installation Quickstart <mc-install>` for
instructions on downloading and installing ``mc``.

Install and Configure MinIO KES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses the  
:minio-git:`MinIO Key Encryption Service (KES) <kes>` server and client for
configuring and enabling SSE-S3. See the ``kes``
:minio-git:`Getting Started <kes/wiki/Getting-Started>` guide for 
instructions on downloading, installing, and configuring KES. 

This procedure makes the following assumptions regarding the KES service:

- The KES service exists and is configured for a supported 
  :minio-git:`Key Management Service (KMS) <kes/wiki#guides>`. The MinIO
  deployment *must* have bidirectional network access to the KES service.

- KES has at least one :minio-git:`identity
  <kes/wiki/Configuration#policy-configuration>` that grants permission to
  at minimum the ``/v1/create``, ``/v1/generate``, and ``/v1/list`` 
  :minio-git:`API endpoints <kes/wiki/Server-API#api-overview>` Defer to the KES 
  documentation for creating policies and identities for supporting 
  cryptographic operations.

- KES has at least one Customer Master Key (CMK) for supporting SSE-S3
  cryptographic operations. KES supports creating default keys as part
  of it's :minio-git:`configuration <kes/blob/master/server-config.yaml#L133>`.
  You can also use the ``kes key create`` command to create a CMK on the
  KES server.

Procedure
---------

1) Create a Customer Master Key for SSE-S3 Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :minio-git:`kes <kes>` commandline tool to create a new Customer Master
Key (CMK) for use with SSE-S3 Encryption.

The following tabs provide instructions for a self-managed MinIO KES service
*or* the MinIO-managed KES ``play`` sandbox. The sandbox environment is
appropriate for evaluation environments *only* and should *never* be used
for Production or any other environment which requires strict data security:

.. tabs::

   .. tab:: Self-Managed KES

      Set the following environment variables in the terminal or shell:

      .. code-block:: shell
         :class: copyable

         export KES_CLIENT_KEY=identity.key
         export KES_CLIENT_CERT=identity.cert

      .. list-table::
         :stub-columns: 1
         :widths: 40 60
         :width: 100%

         * - ``KES_CLIENT_KEY``
           - The private key for an :minio-git:`identity
             <kes/wiki/Configuration#policy-configuration>` on the KES server.
             The identity must grant access to at minimum the ``/v1/create``,
             ``/v1/generate``, and ``/v1/list`` :minio-git:`API endpoints 
             <kes/wiki/Server-API#api-overview>`.

         * - ``KES_CLIENT_CERT``
           - The corresponding certificate for the :minio-git:`identity
             <kes/wiki/Configuration#policy-configuration>` on the KES server.
             
   .. tab:: MinIO ``Play`` Sandbox

      .. important::

         The MinIO KES ``Play`` sandbox is public and grants root access to
         all created CMKs. Generated CMKs may be accessed or destroyed at
         any time, rendering protected data vulnerable or permanently 
         unreadable. **Never** use the ``Play`` sandbox to protect data you
         cannot afford to lose or reveal.

      Issue the following command to retrieve the root :minio-git:`identity
      <kes/wiki/Configuration#policy-configuration>` for the KES server:

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

Issue the following command to create a new Customer Master Key (CMK) through
KES:

.. code-block:: shell
   :class: copyable

   kes key create my-minio-sse-s3-key

This tutorial uses the example ``my-minio-sse-s3-key`` name for ease of
reference. MinIO recommends specifying a key name that meets your organization's
requirements for naming secure encryption keys.

KES creates the new CMK on the configured Key Management System (KMS). MinIO
uses the CMK to generate additional encryption keys for use with SSE-S3.
See :ref:`minio-encryption-sse-encryption-process` for more information on the
SSE encryption process.

2) Configure MinIO for SSE-S3 Object Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
The following tabs provide instructions for a self-managed MinIO KES service
*or* the MinIO-managed KES ``play`` sandbox. The sandbox environment is
appropriate for evaluation environments *only* and should *never* be used
for Production or any other environment which requires strict data security.
Select the same tab used for the previous step:

.. tabs::

   .. tab:: Self-Managed KES

      Specify the following environment variables in the shell or terminal:

      .. code-block:: shell
         :class: copyable

         export MINIO_KMS_KES_ENDPOINT=https://kes.example.net:7373
         export MINIO_KMS_KES_KEY_FILE=identity.key
         export MINIO_KMS_KES_CERT_FILE=identity.cert
         export MINIO_KMS_KES_KEY_NAME=my-minio-sse-s3-key

      .. list-table::
         :stub-columns: 1
         :widths: 30 80

         * - :envvar:`MINIO_KMS_KES_ENDPOINT`
           - The endpoint for the KES service to use for supporting SSE-S3
             operations.

         * - :envvar:`MINIO_KMS_KES_KEY_FILE`
           - The private key file corresponding to an 
             :minio-git:`identity <kes/wiki/Configuration#policy-configuration>`
             on the KES service. The identity must grant permission to 
             create, generate, and decrypt keys. You can specify the same
             identity key file as the ``KES_KEY_FILE`` environment variable
             in the previous step.

         * - :envvar:`MINIO_KMS_KES_CERT_FILE`
           - The public certificate file corresponding to an 
             :minio-git:`identity <kes/wiki/Configuration#policy-configuration>`
             on the KES service. The identity must grant permission to 
             create, generate, and decrypt keys. You can specify the same
             identity certificate as the ``KES_CERT_FILE`` environment
             variable in the previous step.

         * - :envvar:`MINIO_KMS_KES_KEY_NAME`
           - The name of the Customer Master Key (CMK) to use for
             performing SSE encryption operations. KES retrieves the CMK from
             the configured Key Management System (KMS). Specify the name of the
             key created in the previous step. 

   .. tab:: MinIO ``Play`` Sandbox

      .. important::

         The MinIO KES ``Play`` sandbox is public and grants root access to
         all created CMKs. Generated CMKs may be accessed or destroyed at
         any time, rendering protected data vulnerable or permanently 
         unreadable. **Never** use the ``Play`` sandbox to protect data you
         cannot afford to lose or reveal.

      Specify the following environment variables in the shell or terminal:

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
           - The name of the Customer Master Key (CMK) to use for
             performing SSE encryption operations. KES retrieves the CMK from
             the configured Key Management System (KMS). Specify the name of the
             key created in the previous step. 


3) Restart the MinIO Deployment to Enable SSE-S3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. important::

   MinIO restarts *all* :mc:`minio server` processes associated to the 
   deployment at the same time. Applications may experience a brief period of 
   downtime during the restart process. 

   Consider scheduling the restart during a maintenance period to minimize
   interruption of services.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :mc:`alias <mc-alias>` of the deployment to 
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

- Replace :mc-cmd:`ALIAS <mc encrypt set TARGET>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment on which you enabled SSE-S3.

- Replace :mc-cmd:`BUCKET <mc encrypt set TARGET>`  with the full path to the
  bucket or bucket prefix on which you want to enable automatic SSE-S3.

5) Manually Encrypt Objects using SSE-S3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Optional*

You can skip this step for buckets configured with automatic SSE-S3 encryption.

Specify the ``X-Amz-Server-Side-Encryption`` header with value
``AES256`` to direct the MinIO server to apply SSE-S3 protection to the object.

The MinIO :mc:`mc` commandline tool S3-compatible SDKs include specific syntax
for setting headers. Certain :mc:`mc` commands like :mc:`mc cp` include specific
arguments for enabling SSE-S3 encryption:

.. code-block:: shell
   :class: copyable

   mc cp ~/data/mydata.json ALIAS/BUCKET/mydata.json --encrypt ALIAS/BUCKET

- Replace :mc-cmd:`ALIAS <mc encrypt set TARGET>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment on which you enabled SSE-S3.

- Replace :mc-cmd:`BUCKET <mc encrypt set TARGET>`  with the full path to the
  bucket or bucket prefix in which you are interacting with the SSE-S3 encrypted
  object.