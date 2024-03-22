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

      The following command reverts the last three uploads and/or deletions of the ``file.zip`` object on the ``myminio`` deployment in the ``data`` bucket:

      .. code-block:: shell
         :class: copyable

         mc undo myminio/data/file.zip --last 3

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] undo                \
                          TARGET              \
                          [--action "type"]*  \
                          [--force]           \
                          [--last "integer"]* \
                          [--recursive, r]*   \
                          [--dry-run]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The full path to the object or prefix where the command should run.
   The path must include the :ref:`ALIAS <minio-mc-alias>`, bucket, and prefix or object name.

.. mc-cmd:: --action
   :optional:

   Undo the most recent change of the specified type.
   Accepted values are ``DELETE`` or ``PUT``.

   By default, :mc:`mc undo` reverses both ``DELETE`` and ``PUT`` operations.
   Use :mc-cmd:`~mc undo --action` to choose one or the other, but only for the most recent operation of the specified type.

   The following command reverts the most recent ``PUT`` for the object ``today.zip`` in bucket ``data``, reverting to the previous object version:

   .. code-block:: shell
      :class: copyable

      mc undo myminio/data/today.zip --action "PUT"

   This example reverts the most recent ``DELETE`` for the prefix ``archive``, recursively restoring it and any child objects:

   .. code-block:: shell
      :class: copyable

      mc undo myminio/data/archive --recursive --action "DELETE"

   Mutually exclusive with :mc-cmd:`~mc undo --last`.

.. mc-cmd:: --dry-run
   :optional:

   Output the results of the command without actually performing the operations.
   Use this flag to test the outcome of running the command in a particular way.

.. mc-cmd:: --force
   :optional:

   Force a recursive operation.

.. mc-cmd:: --last
   :optional:

   Accepts an integer value specifying the number of ``PUT`` and/or ``DELETE`` changes to undo.
   
   If not specified, the command reverses one (``1``) operation.
   Mutually exclusive with :mc-cmd:`~mc undo --action`.

.. mc-cmd:: --recursive, r
   :optional:

   Performs the command in a recursive fashion.
   Use this flag to undo changes on a prefix, for example.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Undo the Last Three Uploads or Deletions on an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command reverts the last three uploads and/or deletions of the ``file.zip`` object on the ``myminio`` deployment in the ``data`` bucket:

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
