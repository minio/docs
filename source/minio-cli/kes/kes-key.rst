===========
``kes key``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes key

The :mc:`kes key` command manages creating cryptographic keys for use with
Server-Side Object Encryption (SSE).

This page provides reference information for the :mc:`kes key`
command. 

- For more complete conceptual information on KES, see :ref:`minio-kes`.

- For an example of using :mc:`kes key` to generate secret keys using
  Thales CipherTrust as the KMS, see <tutorial>

- Other specific tutorials to follow.

Syntax
------

.. mc-cmd:: create
   :fullpath:

   Creates a new secret key on the KES server.

   Creates a new CMK.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes key create [OPTIONS] NAME [KEY]

   The command accepts the following arguments:

   .. mc-cmd:: NAME

      The name of the secret key.

   .. mc-cmd:: KEY

      *Optional*
      
      The value to use as the secret key. Specify a base64-encoded string.

      Omit :mc-cmd:`~kes key create KEY` to direct KES to automatically
      generate a random value for the key.

   .. mc-cmd:: insecure, k
      :option:

      Skips x.509 Certificate Validation during TLS handshakes. This option
      is required if using self-signed certificates.

.. mc-cmd:: delete
   :fullpath:

   Deletes a master key on the KES server. Deleting a master key prevents
   decrypting any cryptographic keys derived using that master key, which
   in turn prevents decrypting any objects encrypted with those cryptographic
   keys. 

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes key delete [OPTIONS] NAME

   The command accepts the following arguments:

   .. mc-cmd:: NAME

      *Required*

      The name of the master key to delete.

   .. mc-cmd:: insecure, k
      :option:

      Skips x.509 Certificate Validation during TLS handshakes. This option
      is required if using self-signed certificates.

.. mc-cmd:: derive
   :fullpath:

   Derives a new cryptographic key using a master key on the KES server. The
   cryptographic key can support Server-Side Object Encryption (SSE-S3).

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes key derive [ARGUMENTS] NAME [CONTEXT]


   The command accepts the following arguments:

   .. mc-cmd:: NAME

      *Required*

      The name of the master key on the KES server to use to generate the
      cryptographic key.

   .. mc-cmd:: CONTEXT

      *Optional*

      A base64-encoded string to use with the master key for deriving the
      cryptographic key.

   .. mc-cmd:: insecure, k
      :option:

      Skips x.509 Certificate Validation during TLS handshakes. This option
      is required if using self-signed certificates.

.. mc-cmd:: decrypt
   :fullpath: 
   
   Decrypt the ciphertext and return the plain cryptographic key produced :mc-cmd:`kes key derive`
   :mc-cmd:`kes key derive`.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes key decrypt [ARGUMENTS] NAME CIPHERTEXT [CONTEXT]

   The command accepts the following arguments:

   .. mc-cmd:: NAME
   
      *Required*

      The name of master key used to generate the cryptographic key.
      
      :mc-cmd:`kes key decrypt` fails if the specified master key
      was not used to encrypt the :mc-cmd:`~kes key decrypt CIPHERTEXT`.

   .. mc-cmd:: CIPHERTEXT

      *Required*

      The cryptographic key to decrypt using the specified 
      :mc-cmd:`master key <kes key decrypt NAME>`.

   .. mc-cmd:: CONTEXT

      *Optional*

      The base64-encoded string specified to 
      :mc-cmd:`kes key derive CONTEXT` when creating the cryptographic key, if
      any.

   .. mc-cmd:: insecure, k
      :option:

      Skips x.509 Certificate Validation during TLS handshakes. This option
      is required if using self-signed certificates.
