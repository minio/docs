================
``kes identity``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes identity

The :mc:`kes identity` command temporarily adds or removes :ref:`identities
<minio-kes-authorization>` to or from :ref:`policies <minio-kes-policy>` on a
KES server. The command can also list available identities on the command line.

All changes made by :mc:`kes identity` are lost when the KES server restarts. To
make persistent changes to KES policies, modify the :kesconf:`policy` section of
the KES :ref:`configuration file <minio-kes-config>`. Specifically, for each
:kesconf:`policy.policyname` to modify, you must add/remove the identities
to/from the :kesconf:`policy.policyname.identities` array.

This page provides reference information for the :mc:`kes identity` command.

- For more information on KES Access Control, see
  :ref:`minio-kes-access-control`.

- For conceptual information on KES, see :ref:`minio-kes`.

Examples
--------

Assign an Identity to a Policy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List Identities on the KES Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Remove an Identity from the KES Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Syntax
------

.. mc-cmd:: assign
   :fullpath:

   Assigns a new temporary :ref:`identity <minio-kes-authorization>` to a
   :ref:`policy <minio-kes-policy>` on the KES server. KES grants clients
   authenticating with that identity access to the operations explicitly allowed
   by the associated policy.

   All changes made by :mc:`kes identity assign` are lost when the KES server
   restarts. To permanently assign an identity to a policy, modify the
   :kesconf:`policy` section of the KES
   :ref:`configuration document <minio-kes-config>` to include the new 
   association.

   The command has the following syntax:

   .. code-block:: shell

      kes identity assign [OPTIONS] IDENTITY POLICY

   The command accepts the following arguments:

   .. mc-cmd:: IDENTITY

      *Required*

      The SHA-256 hash of an x.509 certificate to use as a KES
      :ref:`identity <minio-kes-authorization>`. Use the 
      :mc:`kes tool identity of` command to compute the identity for the
      x.509 certificate.

   .. mc-cmd:: POLICY

      *Required*

      The name of the policy to which to associate the identity. 

      A given identity can associate to at most *one* policy on a 
      KES server.

   .. mc-cmd:: insecure, k
      :option:

      *Optional*

      .. include:: /includes/common-minio-kes.rst
         :start-after: start-kes-insecure
         :end-before: end-kes-insecure

.. mc-cmd:: list
   :fullpath:

   List all :ref:`identities <minio-kes-authorization>` configured on the KES
   server.

   The command has the following syntax:

   .. code-block:: shell

      kes identity [OPTIONS] list [PATTERN]

   The command accepts the following arguments:

   .. mc-cmd:: PATTERN

      *Optional*

      The `glob pattern <https://man7.org/linux/man-pages/man7/glob.7.html>`__
      used to filter identities on the KES server.

      Defaults to ``*`` or all identities.

   .. mc-cmd:: insecure, k
      :option:

      *Optional*

      .. include:: /includes/common-minio-kes.rst
         :start-after: start-kes-insecure
         :end-before: end-kes-insecure

.. mc-cmd:: forget
   :fullpath:

   Temporarily removes an :ref:`identity <minio-kes-authorization>` from the KES
   server. Removing an identity prevents clients authenticating with that
   identity from performing any operation on the KES server.

   All changes made by :mc:`kes identity forget` are lost when the KES server
   restarts. To permanently remove an identity-policy association, modify the
   :kesconf:`policy` section of the KES
   :ref:`configuration document <minio-kes-config>` to remove the 
   association.

   The command has the following syntax:

   .. code-block:: shell

      kes identity forget [OPTIONS] IDENTITY

   The command accepts the following arguments:

   .. mc-cmd:: IDENTITY

      *Required*

      The identity to remove from the KES server.

      Use the :mc:`kes tool identity of` command line tool to compute the
      identity hash for the x.509 certificate to forget.

   .. mc-cmd:: insecure, k
      :option:

      *Optional*

      .. include:: /includes/common-minio-kes.rst
         :start-after: start-kes-insecure
         :end-before: end-kes-insecure