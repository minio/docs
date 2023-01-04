.. _minio-mc-ilm-rule-rm:

==================
``mc ilm rule rm``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm rule rm

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z

   ``mc ilm rule rm`` replaces ``mc ilm rm``.

Syntax
------

.. start-mc-ilm-rule-rm-desc

The :mc:`mc ilm rule rm` command removes an object lifecycle management rule from a MinIO Bucket.

.. end-mc-ilm-rule-rm-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes a single lifecycle management rule from the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc ilm rule rm --id "bgrt1ghju" myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] ilm rule rm                         \
                              --id "string" | (--all --force) \
                              ALIAS                           \

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:
   
   The :ref:`alias <alias>` and full path to the bucket on the MinIO deployment to which to remove the object lifecycle management rule. 
   For example:

   .. code-block:: none

      mc ilm rule rm myminio/mydata

.. mc-cmd:: --all
   :optional:

   Removes all rules in the bucket. 
   Requires including :mc-cmd:`~mc ilm rule rm --force`.

   Mutually exclusive with :mc:`~mc ilm rule rm --id`.

.. mc-cmd:: --force
   :optional:

   Required if specifying :mc-cmd:`~mc ilm rule rm --all`.

.. mc-cmd:: --id
   :optional:

   The unique ID of the rule. 
   Use :mc:`mc ilm rule ls` to list bucket rules and retrieve the ``id`` for the rule you want to remove.

   Mutually exclusive with :mc:`mc ilm rule rm --all`

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Remove a Bucket Lifecycle Management Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc ilm rule rm` to remove a bucket lifecycle management rule:

.. code-block:: shell
   :class: copyable

   mc ilm rule rm --id "RULE" ALIAS/PATH

- Replace ``RULE`` with the unique identifier of the lifecycle  management rule.
  Use :mc-cmd:`mc ilm rule ls` to find the ID to use.

- Replace :mc-cmd:`ALIAS <mc ilm rule rm ALIAS>` with the :mc:`alias <mc alias>` of the S3-compatible host.

- Replace ``PATH`` with the path to the bucket on the S3-compatible host.

Required Permissions
--------------------

For permissions required to remove a rule, refer to the :ref:`required permissions <minio-mc-ilm-rule-permissions>` on the parent command.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
