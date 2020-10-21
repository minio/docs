=====================
``kes tool identity``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes tool identity

The :mc:`kes tool identity` command creates a self-signed x.509 certificate
for use with deploying a :mc:`kes server` for local evaluation and initial
development. 

This page provides reference information for the :mc:`kes tool identity`
command. 

- For an example of using :mc:`kes tool identity`, see the 
  :ref:`KES Getting Started Guide <minio-kes-getting-started>`. 
  
- For more complete conceptual information on KES, see :ref:`minio-kes`.

:mc:`kes tool identity` only supports generating self-signed certificates and
is best suited for supporting early development and evaluation of KES. To
configure a KES server to use an x.509 certificate generated through other
means, including ACME-based tools like CertBot, use :mc:`kes identity assign`
instead.

Syntax
------

.. mc-cmd:: new
   :fullpath:

   Creates a new x.509 certificate identity for use with accessing the KES
   server.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes tool identity new [ARGUMENTS] NAME

   The command accepts the following arguments:

   .. mc-cmd:: NAME

      The x.509 ``commonName`` to associate to the generated x.509 certificates.
      
      Defaults to ``""`` if unspecified.

   .. mc-cmd:: key
      :option:

      The path to the private key to create for the identity. 

      Defaults to ``./private.key``.

   .. mc-cmd:: cert
      :option:

      The path to the public key certificate to create for the identity.

      Defaults to ``./public.cert``.

   .. mc-cmd:: time, t
      :option:

      The duration to certificate expiration. 

      Defaults to ``720h`` or 720 hours.

   .. mc-cmd:: force, f
      :option:

      Directs :mc-cmd:`kes tool identity new` to overwrite the
      specified :mc-cmd-option:`~kes tool identity new key` or
      :mc-cmd:`~kes tool identity new cert` if either exists.

.. mc-cmd:: of
   :fullpath:

   Computes the identity string from a TLS certificate.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes tool identity of [ARGUMENTS] NAME

   The command accepts the following arguments:

   .. mc-cmd:: NAME

      The name of the certificate for which the command computes the identity
      string.
   
   .. mc-cmd:: hash
      :option:

      The hash function used to compute the identity. Specify one of the
      following functions:

      - ``SHA-256``
      - ``SHA-384``
      - ``SHA-512``