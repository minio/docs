==============
``kes policy``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes policy

The :mc:`kes policy` command performs non-persistent creation and modification
of access policies on a MinIO Key Encryption Service (KES). All changes made by
:mc:`kes policy` are lost when the KES server restarts.

To make persistent changes to KES policies, add or modify the policies
listed under the :kesconf:`policy` section of the 
:ref:`KES configuration file <minio-kes-config>`. :mc:`kes policy` supports
testing the effect of new or modified policies prior to adding them to the
KES configuration file.

This page provides reference information for the :mc:`kes policy`
command. 

- For more complete information on KES policies, see
  :ref:`minio-kes-policy`.

- For more complete conceptual information on KES, see :ref:`minio-kes`.

.. _minio-kes-policy-document:

Policy Document Structure
~~~~~~~~~~~~~~~~~~~~~~~~~

KES uses JSON-formatted policy documents to describe the permissions granted
to authenticated clients.

The KES Policy Document has the following schema:

.. code-block:: json
   :class: copyable

   {
      "policyName": { 
         "paths": [
            "ENDPOINT",
            "ENDPOINT"
         ],
         "identities": [
            "IDENTITY",
            "IDENTITY"
         ]
      }
   }

The following table describes each field in the KES Policy Document:

.. kespolicy:: policyName

   *Type: object*

   The name of the KES policy. Replace ``"policyName"`` with a unique name
   for the KES policy. You can specify multiple :kespolicy:`policyName`
   objects in the KES Policy document:

   .. code-block:: json
      
      {
         "keyManagement" : {},
         "encryptDecrypt" : {}
      }

.. kespolicy:: policyName.paths

   *Type: array*

   An array of KES API endpoints for which the 
   :kespolicy:`~policyName.identities` can access. 

   Each endpoint *must* be a glob pattern in the following form:

   .. code-block:: shell

      <APIVERSION>/<API>/<operation>/[<argument>/<argument>/]

   You can specify an asterisk ``*`` to create a catch-all pattern for
   a given endpoint. For example, the following endpoint pattern 
   allows complete access to key creation via the ``/v1/key/create`` 
   endpoint:

   .. code-block:: shell

      /v1/key/create/*

   See :ref:`minio-kes-endpoints` for a list of KES endpoints and the
   actions associated to each.

.. kespolicy:: policyName.identities

   *Type: array*

   An array of x.509 identities associated to the policy. KES grants clients
   authenticating with a matching x.509 certificate access to the
   endpoints listed in the :kespolicy:`~policyName.paths` for the 
   policy.

   Use :mc-cmd:`kes tool identity of` to compute the name of each x.509
   certificate you want to associate to the policy and specify that value to the
   array.

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

   This command adds a new policy to the KES server.

.. mc-cmd:: show
   :fullpath:

   This command outputs the policy JSON document too ``STDOUT``.

.. mc-cmd:: list
   :fullpath:

   This command lists all policies on the KES server.

.. mc-cmd:: delete
   :fullpath:

   This command deletes a policy on the KES server.