.. _minio-mc-replicate-ls:

===================
``mc replicate ls``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc replicate list
.. mc:: mc replicate ls

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z 

   ``mc replicate ls`` replaces the ``mc admin bucket remote ls`` command.

Syntax
------

.. start-mc-replicate-ls-desc

The :mc:`mc replicate ls` command lists all 
:ref:`replication rules <minio-bucket-replication-serverside>` on a 
MinIO bucket.

.. end-mc-replicate-ls-desc

The :mc:`mc replicate list` alias has equivalent functionality to :mc:`mc replicate ls`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command lists all enabled replication rules for the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc replicate ls --status "enabled" myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] replicate ls         \
                          [--status "string"]  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* the :ref:`alias <alias>` of the MinIO deployment and full path to
   the bucket or bucket prefix for which to list the replication rules. For
   example:

   .. code-block:: none

      mc replicate ls myminio/mybucket


.. mc-cmd:: --status
   

   *Optional*  Filter replication rules on the bucket based on their status.
   Specify one of the following values:

   - ``enabled`` - Show only enabled replication rules.
   - ``disabled`` - Show only disabled replication rules.

   If omitted, :mc:`mc replicate ls` defaults to showing all replication
   rules.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

List Existing Replication Rules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc replicate ls` to list bucket replication rules:

.. code-block:: shell
   :class: copyable

   mc replicate ls ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc replicate ls ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate ls ALIAS>` with the path to the 
  bucket or bucket prefix.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
