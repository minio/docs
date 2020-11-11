=====================
``kes tool identity``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes tool identity

The :mc:`kes tool identity new` command creates a self-signed x.509 certificate
for use with deploying a :mc:`kes server` for local evaluation and initial
development. 

This page provides reference information for the :mc:`kes tool identity`
command. 

- For an example of using :mc:`kes tool identity`, see the 
  :ref:`KES Getting Started Guide <minio-kes-getting-started>`. 
  
- For more complete conceptual information on KES, see :ref:`minio-kes`.

:mc:`kes tool identity new` only supports generating self-signed certificates
and is best suited for supporting early development and evaluation of KES. To
configure a KES server to use an x.509 certificate generated through other
means, including ACME-based tools like CertBot, use :mc:`kes identity assign`
instead.

Syntax
------

.. mc-cmd:: new
   :fullpath:

   Creates a new self-signed x.509 certificate for use with accessing the KES
   server. These certificates are best used during early development and
   evaluation, and require the KES :mc:`~kes server` run with x.509 validation
   disabled (:mc-cmd-option:`kes server auth=off <kes server auth>`).
   
   - Use :mc-cmd:`kes tool identity of` to derive the 
     :ref:`identity hash <minio-kes-authorization>` of the new certificate.

   - Use :mc-cmd:`kes identity assign` to temporarily assign the new identity
     to a :ref:`policy <minio-kes-policy>` on the KES server.

   - Modify the :kesconf:`policy` section of the KES 
     :ref:`configuration document <minio-kes-config>` to permanently assign
     the new identity to a :ref:`policy <minio-kes-policy>` on the KES server.

   KES clients can authenticate using the generated certificate by specifying
   the certificate ``*.cert`` and private key ``*.key`` to the 
   ``KES_CLIENT_CERT`` and ``KES_CLIENT_KEY`` environment variables
   respectively.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes tool identity new [OPTIONS] [SUBJECT]

   The command accepts the following arguments:

   .. mc-cmd:: SUBJECT

      *Optional*

      The x.509 ``Subject.commonName`` to associate to the generated x.509
      certificates.
      
      Defaults to ``""`` if unspecified.

   .. mc-cmd:: key
      :option:

      *Optional*

      The path to the private key to create for the identity. 

      Defaults to ``./private.key``.

   .. mc-cmd:: cert
      :option:

      *Optional*

      The path to the self-signed public key certificate to create for the
      identity.

      Defaults to ``./public.cert``.

   .. mc-cmd:: time, t
      :option:

      *Optional*

      The duration to certificate expiration. 

      Defaults to ``720h`` or 720 hours (30 days).

   .. mc-cmd:: force, f
      :option:

      *Optional*

      Directs :mc-cmd:`kes tool identity new` to overwrite the
      specified :mc-cmd-option:`~kes tool identity new key` or
      :mc-cmd:`~kes tool identity new cert` if either exists.

.. mc-cmd:: of
   :fullpath:

   Computes a hash from an x.509 certificate. You can use the computed
   hash as an :ref:`identity <minio-kes-authorization>` for configuring
   KES :ref:`access control <minio-kes-access-control>`.

   Use the computed string when assigning the identity to a :ref:`policy
   <minio-kes-policy>`. KES grants clients authenticating with the x.509
   certificate access to the operations explicitly allowed by the
   associated policy.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kes tool identity of [OPTIONS] CERTIFICATE

   The command accepts the following arguments:

   .. mc-cmd:: NAME

      The name of the x.509 certificate for which the command computes the
      identity string. Specify the full path to the certificate.
   
   .. mc-cmd:: hash
      :option:

      The hash function used to compute the identity. Specify one of the
      following functions:

      - ``SHA-256``
      - ``SHA-384``
      - ``SHA-512``

      :mc-cmd:`kes tool identity of` defaults to ``SHA-256`` if this option is
      omitted. 
      
      The KES server uses ``SHA-256`` to compute a KES client's identity using
      the client x.509 certificate. Omit this option *or* explicitly
      specify ``SHA-256`` if computing an identity hash for use with
      configuring :ref:`KES access control <minio-kes-access-control>`.
