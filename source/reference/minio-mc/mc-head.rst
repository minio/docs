.. _minio-mc-head:

===========
``mc head``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc::  mc head


.. |command| replace:: :mc:`mc head`
.. |rewind| replace:: :mc-cmd:`~mc head --rewind`
.. |versionid| replace:: :mc-cmd:`~mc head --version-id`
.. |alias| replace:: :mc-cmd:`~mc head ALIAS`

Syntax
------

.. start-mc-head-desc

The :mc:`mc head` command displays the first ``n`` lines of an object,
where ``n`` is an argument specified to the command.

.. end-mc-head-desc

:mc:`mc head` does not perform any transformation or formatting of object
contents to facilitate readability. You can also use :mc:`mc head` against
the local filesystem to produce similar results to the ``head`` commandline 
tool.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command returns the first 10 lines of an object in the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc head myminio/mydata/myobject.txt

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] head                     \
                          [--lines int]            \
                          [--rewind "string"]      \
                          [--version-id "string"]  \
                          [--encrypt-key "string"] \
                          ALIAS [ALIAS ...]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The object or objects to print. 
   
   For an object on MinIO, specify the :ref:`alias <alias>` and the full path to
   that object (e.g. bucket and path to object). For example:

   .. code-block:: none

      mc head play/mybucket/object.txt

   You can specify multiple objects on the same or different MinIO
   deployments. For example:

   .. code-block:: none

      mc head ~/mydata/object.txt myminio/mydata/object.txt

   For an object on a local filesystem, specify the full path to that object.
   For example:

   .. code-block:: none

      mc head ~/mydata/object.txt

.. mc-cmd:: --lines, n
   :optional:

   The number of lines to print.

   Defaults to ``10``.

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
      Use SSE-KMS via the :mc-cmd:`mc head --enc-kms` or SSE-S3 via the:mc-cmd:`mc head --enc-s3` parameters instead.

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


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

View Partial Contents of an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc head` to return the first 10 lines of an object:

.. code-block:: shell
   :class: copyable

   mc head ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc head ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc head ALIAS>` with the path to the object on the
  S3-compatible host.

View Partial Contents of an Object at a Point in Time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc head --rewind` to return the first 10 lines of the
object at a specific point-in-time in the past:

.. code-block:: shell
   :class: copyable

   mc head ALIAS/PATH --rewind DURATION

- Replace :mc-cmd:`ALIAS <mc head ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc head ALIAS>` with the path to the object on the
  S3-compatible host.

- Replace :mc-cmd:`DURATION <mc head --rewind>` with the point-in-time in the past
  at which the command returns the object. For example, specify ``30d`` to
  return the version of the object 30 days prior to the current date.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

View Partial Contents of an Object with Specific Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc head --version-id` to return the first 10 lines of the
object at a specific point-in-time in the past:

.. code-block:: shell
   :class: copyable

   mc head ALIAS/PATH --version-id VERSION

- Replace :mc-cmd:`ALIAS <mc head ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc head ALIAS>` with the path to the object on the
  S3-compatible host.

- Replace :mc-cmd:`VERSION <mc head --version-id>` with the version of the object.
  For example, specify ``30d`` to return the version of the object 30 days prior
  to the current date.

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
