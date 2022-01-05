=========
``mc ls``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ls

.. Replacement substitutions

.. |command| replace:: :mc-cmd:`mc ls`
.. |rewind| replace:: :mc-cmd-option:`~mc ls rewind`
.. |versions| replace:: :mc-cmd-option:`~mc ls versions`
.. |alias| replace:: :mc-cmd-option:`~mc ls ALIAS`

Syntax
------

.. start-mc-ls-desc

The :mc:`mc ls` command lists buckets and objects on MinIO or another
S3-compatible service. 

.. end-mc-ls-desc

You can also use :mc:`mc ls` against the local filesystem to produce similar
results as the ``ls`` command.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command lists all objects *and* object versions in the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc ls --recursive --versions myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] ls              \
                          [--incomplete]  \
                          [--recursive]   \
                          [--rewind]      \
                          [--versions]    \
                          [--summarize]   \
                          ALIAS [ALIAS ...]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The object or objects to copy. 

   For listing objects on MinIO,
   specify the :ref:`alias <alias>` and the full path to that 
   object (e.g. bucket and path to object). For example:

   .. code-block:: none

      mc ls play/mybucket/object.txt


   For listing objects on a local filesystem, specify the full
   path to that object. For example:

   .. code-block:: none

      mc ls ~/mydata/object.txt
   
   If you specify a directory or bucket to :mc-cmd:`~mc ls ALIAS`, you must
   also specify :mc-cmd-option:`~mc ls recursive` to recursively list the
   contents of that directory or bucket. If you omit the ``--recursive``
   argument, :mc:`~mc ls` only lists objects in the top level of the specified
   directory or bucket.


.. mc-cmd:: incomplete, -I
   :option:

   *Optional* Returns any incomplete uploads on the specified 
   :mc-cmd:`~mc ls ALIAS` bucket.

.. mc-cmd:: recursive, r
   :option:

   *Optional* Recursively lists the contents of each bucket or directory in the
   :mc-cmd:`~mc ls ALIAS`.

.. mc-cmd:: rewind
   :option:
   
   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

   Use :mc-cmd-option:`~mc ls rewind` and 
   :mc-cmd-option:`~mc ls versions` together to display on those object
   versions which existed at a specific point in time.

.. mc-cmd:: versions
   :option:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-versions-desc
      :end-before: end-versions-desc

   Use :mc-cmd-option:`~mc ls versions` and 
   :mc-cmd-option:`~mc ls rewind` together to display on those object
   versions which existed at a specific point in time.

.. mc-cmd:: summarize
   :option:

   *Optional* Displays summarized information for the specified ``ALIAS`` path.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

List Bucket Contents
~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc ls <mc ls ALIAS>` to list the contents of a bucket:

.. code-block:: shell
   :class: copyable

   mc ls [--recursive] ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc ls ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ls ALIAS>` with the path to the bucket on the
  S3-compatible host.

  If specifying the path to the S3 root (``ALIAS`` only), include the
  :mc-cmd-option:`~mc ls recursive` option.

List Object Versions
~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd-option:`mc ls versions` to list all versions of an object:

.. code-block:: shell
   :class: copyable

   mc ls --versions ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc ls ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ls ALIAS>` with the path to the bucket or object on
  the S3-compatible host.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

List Bucket Contents at Point in Time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd-option:`mc ls versions` to list all versions of an object:

.. code-block:: shell
   :class: copyable

   mc ls --rewind DURATION ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc ls ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ls ALIAS>` with the path to the bucket or object on
  the S3-compatible host.

- Replace :mc-cmd:`DURATION <mc ls rewind>` with the point-in-time in the past
  at which the command returns the object. For example, specify ``30d`` to
  return the version of the object 30 days prior to the current date.

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
