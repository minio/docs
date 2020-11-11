===========
``kes key``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes key

The :mc:`kes key` command creates, utilizes, and deletes cryptographic keys
(Secrets) through the MinIO Key Encryption Service (KES). KES stores 
created secrets on the configured :ref:`Key Management System (KMS) 
<minio-kes-supported-kms>`.

This page provides reference information for the :mc:`kes key`
command. 

- For more complete conceptual information on KES, see :ref:`minio-kes`.

- For an example of using :mc:`kes key` to generate secret keys using
  Thales CipherTrust as the KMS, see <tutorial>

Syntax
------

.. mc-cmd:: create
   :fullpath:

   Creates a new Secret cryptographic key using the MinIO Key Encryption
   Service (KES). The Secret key supports generation of
   Data Encryption Keys (DEK) via the :mc:`kes key derive` command.

   The created Secret key also supports enabling MinIO Server-Side Encryption
   (SSE-S3). Specify the created key name to the
   :envvar:`MINIO_KMS_KES_KEY_NAME` environment variable before starting the
   :mc:`minio` server.

   KES stores the Secret key on the configured 
   :ref:`Key Management System (KMS) <minio-kes-supported-kms>`. 
   KES *never* returns the Secret key to clients.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes key create [OPTIONS] NAME [KEY]

   The command accepts the following arguments:

   .. mc-cmd:: NAME

      The name of the Secret key. 

      - If the :mc-cmd:`kes key create NAME` command *includes* 
        :mc-cmd:`~kes key create KEY`, the command imports the ``KEY``
        and labels it using the specified :mc-cmd:`~kes key create NAME`.

      - If the :mc-cmd:`kes key create NAME` command *omits* 
        :mc-cmd:`~kes key create KEY`, the command creates a new Secret on the
        configured KMS and labels it using the
        specified :mc-cmd:`~kes key create NAME`.

   .. mc-cmd:: KEY

      *Optional*
      
      The Secret key to import into the configured KMS. Specify a base64-encoded
      string.

      Specifying this option directs :mc-cmd:`kes key create` to
      use the ``v1/key/import`` API endpoint, which has distinct 
      :ref:`policy <minio-kes-policy>` requirements compared to 
      key creation.
      
   .. mc-cmd:: insecure, k
      :option:

      *Optional*

      .. include:: /includes/common-minio-kes.rst
         :start-after: start-kes-insecure
         :end-before: end-kes-insecure

.. mc-cmd:: delete
   :fullpath:

   Deletes a Secret key on the KES server. Deleting a Secret key prevents
   decrypting any cryptographic keys derived using that Secret key, which
   in turn prevents decrypting any objects encrypted with those cryptographic
   keys. 

   .. warning::

      Deleting a Secret key renders all data encrypted using that key
      permanently unreadable.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes key delete [OPTIONS] NAME

   The command accepts the following arguments:

   .. mc-cmd:: NAME

      *Required*

      The name of the Secret key to delete.

   .. mc-cmd:: insecure, k
      :option:

      *Optional*

      .. include:: /includes/common-minio-kes.rst
         :start-after: start-kes-insecure
         :end-before: end-kes-insecure

.. mc-cmd:: derive
   :fullpath:

   Derives a new cryptographic Data Encryption Key (DEK) using a Secret key on
   the KES server.

   The command returns the plaintext and ciphertext representations of the DEK.
   To encrypt or decrypt data using the DEK, use the following procedure:

   1. Use :mc-cmd:`kes key decrypt` on the ciphertext to extract the plaintext.
   2. Encrypt or decrypt data using the plaintext.

   Avoid storing the plaintext on disk, as it allows decryption of data
   without requiring access to the Secret key used to generate the DEK.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes key derive [ARGUMENTS] NAME [CONTEXT]


   The command accepts the following arguments:

   .. mc-cmd:: NAME

      *Required*

      The name of the Secret key to use to generate the DEK.

   .. mc-cmd:: CONTEXT

      *Optional*

      A base64-encoded string to use with the Secret key for deriving the
      DEK. If specified, the ``CONTEXT`` is *required* to decrypt the DEK
      ciphertext.

   .. mc-cmd:: insecure, k
      :option:

      *Optional*

      .. include:: /includes/common-minio-kes.rst
         :start-after: start-kes-insecure
         :end-before: end-kes-insecure

.. mc-cmd:: decrypt
   :fullpath: 
   
   Decrypt the Data Encryption Key (DEK) ciphertext and return the plaintext
   key.

   Use the plaintext value for encrypting or decrypting data using the DEK. 
   Avoid storing the plaintext on disk, as it allows decryption of data
   without requiring access to the Secret key used to generate the DEK.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes key decrypt [OPTIONS] NAME CIPHERTEXT [CONTEXT]

   The command accepts the following arguments:

   .. mc-cmd:: NAME
   
      *Required*

      The name of Secret key used to generate the DEK key.
      
      :mc-cmd:`kes key decrypt` fails if the specified Secret key
      was not used to encrypt the :mc-cmd:`~kes key decrypt CIPHERTEXT`.

   .. mc-cmd:: CIPHERTEXT

      *Required*

      The DEK ciphertext to decrypt using the specified 
      :mc-cmd:`Secret <kes key decrypt NAME>`.

   .. mc-cmd:: CONTEXT

      *Optional*

      The base64-encoded string specified to 
      :mc-cmd:`kes key derive CONTEXT` when creating the DEK key, if
      any.

   .. mc-cmd:: insecure, k
      :option:

      *Optional*

      .. include:: /includes/common-minio-kes.rst
         :start-after: start-kes-insecure
         :end-before: end-kes-insecure
