.. _minio-mc-cat:

==========
``mc cat``
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc cat

.. Replacement substitutions

.. |command| replace:: :mc:`mc cat`
.. |rewind| replace:: :mc-cmd:`~mc cat --rewind`
.. |versionid| replace:: :mc-cmd:`~mc cat --version-id`
.. |alias| replace:: :mc-cmd:`~mc cat ALIAS`

Syntax
------

.. start-mc-cat-desc

The :mc:`mc cat` command concatenates the contents of a file or
object to another file or object. You can also use the command to
display the contents of the specified file or object to ``STDOUT``. 
:mc:`~mc cat` has similar functionality to ``cat``. 

.. end-mc-cat-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command concatenates the contents of an object on a 
      MinIO deployment to ``STDOUT``:

      .. code-block:: shell
         :class: copyable

         mc cat play/mybucket/myobject.txt

   .. tab-item:: SYNTAX

      The :mc:`mc cat` command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] cat                       \
                          ALIAS [ALIAS ...]         \
                          [--enc-c "value"]         \
                          [--offset "int"]          \
                          [--part-number "int"]     \
                          [--rewind]                \
                          [--tail "int"]            \
                          [--version-id "string"]   \
                          [--zip] 

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


You can also use :mc:`mc cat` against a local filesystem to produce similar results to the ``cat`` commandline tool.

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of a MinIO deployment and the full
   path to the object. For example:

   .. code-block:: shell

      mc cat myminio/mybucket/myobject.txt

   You can specify multiple objects on the same or different MinIO
   deployment. For example:

   .. code-block:: shell

      mc cat myminio/mybucket/object.txt myminio/myotherbucket/object.txt

   For an object on a local filesystem, specify the full path to that
   object. For example:

   .. code-block:: shell

      mc cat ~/data/object.txt

.. block include of enc-c

.. include:: /includes/common-minio-sse.rst
   :start-after: start-minio-mc-sse-c-only
   :end-before: end-minio-mc-sse-options

.. mc-cmd:: --offset
   :optional:

   Specify an integer that is the number of bytes from which the command offsets the output.

   Mutually exclusive with the :mc-cmd:`~mc cat --part-number` flag.

.. mc-cmd:: --part-number
   :optional:

   Download a specific part number of a multi-part upload.
   Specify the integer of the part number to download.

   Mutually exclusive with the :mc-cmd:`~mc cat --offset` and :mc-cmd:`~mc cat --tail` flags.

.. mc-cmd:: --rewind
   :optional:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: --tail
   :optional:

   Specify an integer that is the number of bytes from which the command trims the output.

   Mutually exclusive with the :mc-cmd:`~mc cat --part-number` flag.

.. mc-cmd:: --version-id, vid
   :optional:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

.. mc-cmd:: --zip
   :optional:

   Extracts the contents from a zip file on the source to the remote.
   Requires a MinIO deployment as the source ``ALIAS``.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

View an S3 Object
~~~~~~~~~~~~~~~~~

Use :mc:`mc cat` to return the object:

.. code-block:: shell
   :class: copyable

   mc cat ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc cat ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc cat ALIAS>` with the path to the object on the
  S3-compatible host.

View an S3 Object at a Point-In-Time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cat --rewind` to return the object at a specific
point-in-time in the past:

.. code-block:: shell
   :class: copyable

   mc cat ALIAS/PATH --rewind DURATION

- Replace :mc-cmd:`ALIAS <mc cat ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc cat ALIAS>` with the path to the object on the
  S3-compatible host.

- Replace :mc-cmd:`DURATION <mc cat --rewind>` with the point-in-time in the past
  at which the command returns the object. For example, specify ``30d`` to
  return the version of the object 30 days prior to the current date.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

View an S3 Object with Specific Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cat --version-id` to return a specific version of the 
object:

.. code-block:: shell

   mc cat ALIAS/PATH --version-id VERSION

- Replace :mc-cmd:`ALIAS <mc cat ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc cat ALIAS>` with the path to the object on the
  S3-compatible host.

- Replace :mc-cmd:`VERSION <mc cat --version-id>` with the specific version of the
  object to return.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

Download a particular part
~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cat --part-number` to download a particular part of a multi-part upload:

.. code-block:: shell
   :class: copyable

   mc cat ALIAS/PATH --part-number=#

- Replace :mc-cmd:`ALIAS <mc cat ALIAS>` with the :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc cat ALIAS>` with the path to the object on the S3-compatible host.

- Replace ``#`` with the integer of the part number to download.
  For example, to download part 3 of at 16-part multi-part file, use ``--part-number=3``.

You cannot use the ``--part-number`` flag if you are using either the ``--offset`` or the ``--tail`` flags.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
