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

         mc [GLOBALFLAGS] cat             \
                          [--rewind]      \
                          [--version-id]  \
                          [--encrypt-key] \
                          ALIAS [ALIAS ...]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


You can also use :mc:`mc cat` against a local filesystem to produce similar
results to the ``cat`` commandline tool:

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

.. mc-cmd:: --rewind
   :optional:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: --version-id, vid
   :optional:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

.. mc-cmd:: --enc-kms

   Encrypt or decrypt objects using server-side :ref:`SSE-KMS encryption <minio-sse>` with client-managed keys.
   
   The parameter accepts a key-value pair formatted as ``KEY=VALUE``

   - ``KEY`` must contain the full path to the object as ``alias/bucket/path/object``.
   - ``VALUE`` must contain the 32-byte Base64-encoded data key to use for encrypting object(s).

   The ``VALUE`` must correspond to an existing data key on the external KMS.
   See the :mc-cmd:`mc admin kms key create` reference for creating data keys.

   For example:

   .. code-block:: shell

      --enc-kms "myminio/mybucket/prefix/object.obj=bXktc3NlLWMta2V5Cg=="

   You can specify multiple encryption keys by repeating the parameter.

   Specify the path to a prefix to apply encryption to all matching objects at that path:

   .. code-block:: shell

      --enc-kms "myminio/mybucket/prefix/=bXktc3NlLWMta2V5Cg=="

.. mc-cmd:: --enc-s3
   :optional:

   Encrypt or decrypt objects using server-side :ref:`SSE-S3 encryption <minio-sse>` with KMS-managed keys.
   Specify the full path to the object as ``alias/bucket/prefix/object``.

   For example:

   .. code-block:: shell

      --enc-s3 "myminio/mybucket/prefix/object.obj"

   You can specify the parameter multiple times to denote different object(s) to encrypt:

   .. code-block:: shell

      --enc-s3 "myminio/mybucket/foo/fooobject.obj" --enc-s3 "myminio/mybucket/bar/barobject.obj"

   Specify the path to a prefix to apply encryption to all matching objects at that path:

   .. code-block:: shell

      --enc-s3 "myminio/mybucket/foo"

.. mc-cmd:: --enc-c
   :optional:

   Encrypt or decrypt objects using server-side :ref:`SSE-C encryption <minio-sse>` with client-managed keys.
   
   The parameter accepts a key-value pair formatted as ``KEY=VALUE``

   - ``KEY`` must contain the full path to the object as ``alias/bucket/path/object``.
   - ``VALUE`` must contain the 32-byte Base64-encoded data key to use for encrypting object(s).

   For example:

   .. code-block:: shell

      --enc-c "myminio/mybucket/prefix/object.obj=bXktc3NlLWMta2V5Cg=="

   You can specify multiple encryption keys by repeating the parameter.

   Specify the path to a prefix to apply encryption to all matching objects at that path:

   .. code-block:: shell

      --enc-c "myminio/mybucket/prefix/=bXktc3NlLWMta2V5Cg=="

   .. note::

      MinIO strongly recommends against using SSE-C encryption in production workloads.
      Use SSE-KMS via the :mc-cmd:`mc cat --enc-kms` or SSE-S3 via the:mc-cmd:`mc cat --enc-s3` parameters instead.

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

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
