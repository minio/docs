====================
``mc admin kms key``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin kms key

Description
-----------

.. start-mc-admin-kms-key-desc

The :mc-cmd:`mc admin kms key` command performs cryptographic key management
operations through the MinIO Key Encryption Service (KES).

.. end-mc-admin-kms-key-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

.. TODO

   Return to this section as part of the KES documentation. There's a lot here
   that only makes sense once we can link to KES overview + config.

Syntax
------

.. mc-cmd:: create
   :fullpath:


   Creates a new master key on a Key Management System (KMS). 

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin kms key create TARGET [KEY_NAME]

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment.
      
      The ``TARGET`` deployment **must** include a configured
      MinIO Key Encryption Service (KES) server. 

   .. mc-cmd:: KEY_NAME

      Specify the name of the new master key.

.. mc-cmd:: status
   :fullpath:

   Requests information on a Key Management System (KMS) master key.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin kms key status TARGET [KEY_NAME]

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment.

      The ``TARGET`` deployment **must** include a configured MinIO Key
      Encryption Service (KES) server.

   .. mc-cmd:: KEY_NAME

      Specify the name of a master key on the KMS.

      Omit this argument to return the default master key on the
      :mc-cmd:`~mc admin kms key status TARGET` deployment.