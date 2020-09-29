==============
``mc encrypt``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc encrypt

Description
-----------

.. start-mc-encrypt-desc

The :mc:`mc encrypt` mc sets, updates, or disables the default
bucket Server-Side Encryption (SSE) mode. MinIO automatically encrypts
objects using the specified SSE mode.

For more information on configuring SSE, see
:doc:`/security/minio-security-server-side-encryption`.

.. end-mc-encrypt-desc

Syntax
------

:mc:`~mc encrypt` has the following syntax:

.. code-block:: shell

   mc encrypt COMMAND [COMMAND FLAGS] [ARGUMENTS...]

:mc:`~mc encrypt` supports the following commands:

.. mc-cmd:: set

   Sets the default encryption settings for the bucket. The command has the
   following syntax:

   .. code-block:: shell
      :class: copyable

      mc encrypt set ENCRYPTION [KMSKEY] TARGET

   The mc requires the following arguments:

   .. mc-cmd:: ENCRYPTION
   
      Specify the server-side encryption type to use as the default SSE mode.
      Supports the following values:

      - ``sse-kms`` - SSE using a Key Management System (KMS)
      - ``sse-s3`` - SSE using client-provided keys (SSE-C).

   .. mc-cmd:: KMSKEY

      Specify the KMS Master Key to use for performing SSE object encryption.
      Only required if :mc-cmd:`~mc encrypt ENCRYPTION` is ``sse-kms``.

   .. mc-cmd:: TARGET

      The full path to the bucket on which to set the default SSE mode. Specify
      the :mc-cmd:`~mc alias` of a configured S3 service as the prefix to the
      TARGET path. For example:

      .. code-block:: shell

         mc encrypt set ENCRYPTION [KMSKEY] play/mybucket

.. mc-cmd:: clear

   Removes the default encryption settings for the bucket. The command has
   the following syntax:

   .. code-block:: shell

      mc encrypt clear TARGET

   The command requires the following argument:

   .. mc-cmd:: TARGET

      The full path to the bucket on which to clear the default SSE mode.
      Specify the :mc-cmd:`~mc alias` of a configured S3 service as the prefix
      to the TARGET path. For example:

      .. code-block:: shell

         mc encrypt remove play/mybucket

.. mc-cmd:: info

   Returns the current default bucket encryption settings. The command
   has the following syntax:

   .. code-block:: shell

      mc encrypt info TARGET

   The command requires the following argument:

   .. mc-cmd:: TARGET

      The full path to the bucket on which to return the default SSE mode.
      Specify the :mc-cmd:`~mc alias` of a configured S3 service as the prefix
      to the TARGET path. For example:

      .. code-block:: shell

         mc encrypt remove play/mybucket

Behavior
--------

:mc:`mc encrypt` makes no assumptions about the MinIO server's current
encryption state. Specifying default encryption settings which the 
server cannot support may result in undesired behavior.

Setting or modifying the default server-side encryption settings does *not*
automatically encrypt or decrypt the existing bucket contents. If the bucket
contents *must* have consistent encryption settings, use the
:mc:`mc mv` mc with the :mc-cmd:`~mc mv --encrypt` or
:mc-cmd:`~mc mv --encrypt-key` arguments to manually modify the
encryption settings or encrypted state of the bucket contents *before*
changing the bucket default. 

Examples
--------

ToDo

