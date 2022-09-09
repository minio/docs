.. _minio-mc-replicate-export:

=======================
``mc replicate export``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc replicate export

Syntax
------

.. start-mc-replicate-export-desc

The :mc:`mc replicate export` command exports the JSON-formatted
:ref:`replication rules <minio-bucket-replication-serverside>` for a 
MinIO bucket to ``STDOUT``.

.. end-mc-replicate-export-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command exports the replication configuration for the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc replicate export myminio/mydata > mydata-replication.json

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] export ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* the :ref:`alias <alias>` of the MinIO deployment and full path to
   the bucket or bucket prefix for which to export the replication rules. For
   example:

   .. code-block:: none

      mc replicate export myminio/mybucket

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Export Existing Replication Rules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc replicate export` to export bucket replication rules:

.. code-block:: shell
   :class: copyable

   mc replicate export ALIAS/PATH > bucket-replication-rules.json

- Replace :mc-cmd:`ALIAS <mc replicate export ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate export ALIAS>` with the path to the 
  bucket or bucket prefix.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
