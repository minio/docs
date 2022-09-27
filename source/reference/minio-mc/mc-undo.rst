.. _minio-mc-undo:

===========
``mc undo``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc undo

Syntax
------

.. start-mc-undo-desc

The :mc:`mc undo` command reverses changes due to either a ``PUT`` or ``DELETE`` operation at a specified path.

.. end-mc-undo-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command undoes the last three uploads and/or removals of the ``file.zip`` object on the ``myminio`` deployment in the ``data`` bucket:

      .. code-block:: shell
         :class: copyable

         mc undo myminio/data/file.zip --last 3

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] undo               \
                          TARGET             \
                          [--last "integer"] \
                          [--recursive, r]   \
                          [--force]          \
                          [--dry-run]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The full path to the object or prefix where the command should run.
   The path must include the :ref:`ALIAS <mc-alias-set>`, bucket, and prefix or object name.

.. mc-cmd:: --last
   :optional:

   Accepts an integer value specifying the number of ``PUT`` and/or ``DELETE`` changes to undo.
   
   If not specified, the command undoes one (``1``) operation.

.. mc-cmd:: --recursive, r
   :optional:

   Performs the command in a recursive fashion.
   Use this flag to undo changes on a prefix, for example.

.. mc-cmd:: --force
   :optional:

   Force a recursive operation.

.. mc-cmd:: --dry-run
   :optional:

   Output the results of the command without actually performing the operations.
   Use this flag to test the outcome of running the command in a particular way.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Undo the Last Three Uploads or Deletions on an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command undoes the last three uploads and/or removals of the ``file.zip`` object on the ``myminio`` deployment in the ``data`` bucket:

.. code-block:: shell
   :class: copyable

   mc undo myminio/data/file.zip --last 3

Undo the Last Upload or Deletion of any Object at a Prefix
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc undo` to reverse the most recent ``PUT`` or ``DELETE`` operation performed on the ``myminio`` alias in the ``data`` bucket under the ``presentations/recordings/`` :term:`prefix`:

.. code-block:: shell
   :class: copyable

   mc undo myminio/data/presentations/recordings/ --recursive --force

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
