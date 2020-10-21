================
``kes identity``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes identity

The :mc:`kes identity` command performs non-persistent association or removal
of x.509 identities to :ref:`policies <minio-kes-policy>` on a KES server. 
All changes made by :mc:`kes identity` are lost when the KES server restarts.

To make persistent changes to KES policies, modify the 
:kesconf:`policy` section of the KES 
:ref:`configuration file <minio-kes-config>`. Specifically, for each
:kesconf:`policy.policyname` to modify, you must add/remove the 
identities to/from the :kesconf:`policy.policyname.identities` array.

Use the :mc:`kes tool identity of` command line tool to compute the
identity hash for the x.509 certificate to add or remove from a policy.

This page provides reference information for the :mc:`kes policy` command.

- For more complete information on KES policies, see
  :ref:`minio-kes-policy`.

- For more complete conceptual information on KES, see :ref:`minio-kes`.

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

   Assigns a new x.509 identity to a policy on the KES server. 

   Use the :mc:`kes tool identity of` command to compute the identity hash
   for the x.509 certificate.

.. mc-cmd:: list
   :fullpath:

   Lists the x.509 identities on the KES server.

.. mc-cmd:: forget
   :fullpath:

   Removes an x.509 identity from the KES server.