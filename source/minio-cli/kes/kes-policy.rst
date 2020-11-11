==============
``kes policy``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes policy

The :mc:`kes policy` command temporarily creates or modifies policies on the
MinIO Key Encryption Service (KES). The command can also list available
policies and display their contents on the command line. 

All changes made by :mc:`kes policy` are lost when the KES server restarts.
To make persistent changes to KES policies, add or modify the policies
listed under the :kesconf:`policy` section of the 
:ref:`KES configuration file <minio-kes-config>`. :mc:`kes policy` supports
testing the effect of new or modified policies prior to adding them to the
KES configuration file.

This page provides reference information for the :mc:`kes policy`
command. 

- For more complete information on KES policies, see
  :ref:`minio-kes-policy`.

- For more information on KES access control, see 
  :ref:`minio-kes-access-control`.

- For complete conceptual information on KES, see :ref:`minio-kes`.

Examples
--------

Add a New Policy
~~~~~~~~~~~~~~~~

List Existing Policies
~~~~~~~~~~~~~~~~~~~~~~

Remove an Existing Policy
~~~~~~~~~~~~~~~~~~~~~~~~~

Syntax
------

.. mc-cmd:: add
   :fullpath:

   Adds a new temporary :ref:`policy <minio-kes-policy>` to the KES
   server. Policies support KES :ref:`access control
   <minio-kes-access-control>`.

   The created policy has no associated :ref:`identities 
   <minio-kes-authorization>`. Use :mc-cmd:`kes identity assign` to assign
   identities to the policy. 

   All changes made by :mc:`kes policy` are lost when the KES server restarts.
   To create permanent policies, modify the :kesconf:`policy` section of the KES
   :ref:`configuration document <minio-kes-config>` to include the new policy.

   The command has the following syntax:

   .. code-block:: shell

      kes policy add [OPTIONS] POLICY FILE

   The command supports the following arguments:

   .. mc-cmd:: POLICY

      *Required*

      The name of the policy to add to the KES server. The specified name
      *must* be unique among all policies configured on the KES server.

   .. mc-cmd:: FILE

      *Required*

      The ``JSON`` formatted file to use for creating the new policy.
      The file must has the following schema:

      .. code-block:: json
         :class: copyable

         {
            "paths": [
               "ENDPOINT",
               "ENDPOINT"
            ]
         }

      Each ``ENDPOINT`` is a KES :ref:`Server API endpoint 
      <minio-kes-endpoints>` to which the policy grants access. KES supports
      using 
      `glob patterns <https://man7.org/linux/man-pages/man7/glob.7.html>`__ in 
      the following form:

      .. code-block:: shell

         <APIVERSION>/<API>/<operation>/[<argument>/<argument>/]

      The following example uses the ``*`` wildcard character to allow
      access to any operation using the ``/v1/key/create`` endpoint:
      
      .. code-block:: json

         {
            "paths" : [
               "/v1/key/create/*"
            ]
         }

      See :ref:`minio-kes-endpoints` for a list of KES endpoints and the
      actions associated to each.

   .. mc-cmd:: insecure, k
      :option:

      *Optional*

      .. include:: /includes/common-minio-kes.rst
         :start-after: start-kes-insecure
         :end-before: end-kes-insecure

.. mc-cmd:: show
   :fullpath:

   Outputs the specified 
   :ref:`minio-kes-policy` contents to ``STDOUT``.

   The command has the following syntax:

   .. code-block:: shell

      kes policy show [OPTIONS] POLICY

   The command accepts the following arguments:

   .. mc-cmd:: POLICY

      *Required*

      The name of the policy to show.

   .. mc-cmd:: insecure, k
      :option:

      *Optional*

      .. include:: /includes/common-minio-kes.rst
         :start-after: start-kes-insecure
         :end-before: end-kes-insecure



.. mc-cmd:: list
   :fullpath:

   Lists :ref:`policies <minio-kes-policy>` on the KES server.

   The command has the following syntax:

   .. code-block:: shell

      kes policy list [OPTIONS] [PATTERN]

   The command accepts the following arguments:

   .. mc-cmd:: PATTERN

      *Optional*

      The `glob pattern <https://man7.org/linux/man-pages/man7/glob.7.html>`__
      used to filter policies on the KES server.

      Defaults to ``*`` or all policies.

   .. mc-cmd:: insecure, k
      :option:

      *Optional*

      .. include:: /includes/common-minio-kes.rst
         :start-after: start-kes-insecure
         :end-before: end-kes-insecure

.. mc-cmd:: delete
   :fullpath:

   Deletes a :ref:`policies <minio-kes-policy>` on the KES server.
   Deleting a policy prevents clients authenticating with an identity
   associated to that policy from performing any operations on the KES server.

   The command has the following syntax:

   .. code-block:: shell

      kes policy delete [OPTIONS] POLICY

   The command accepts the following arguments:

   .. mc-cmd:: insecure, k
      :option:

      *Optional*

      .. include:: /includes/common-minio-kes.rst
         :start-after: start-kes-insecure
         :end-before: end-kes-insecure