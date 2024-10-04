.. _minio-mc-cp:

=========
``mc cp``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc cp

.. |command| replace:: :mc:`mc cp`
.. |rewind| replace:: :mc-cmd:`~mc cp --rewind`
.. |versionid| replace:: :mc-cmd:`~mc cp --version-id`
.. |alias| replace:: :mc-cmd:`~mc cp SOURCE`

Syntax
------

.. start-mc-cp-desc

The :mc:`mc cp` command copies objects to or from a MinIO deployment, where
the source can MinIO *or* a local filesystem.

.. end-mc-cp-desc

You can also use :mc:`mc cp` against the local filesystem to produce
similar results to the ``cp`` commandline tool.

.. note::

   :mc:`mc cp` only copies the latest version or the specified version of an object without any version information or modification date.
   To copy all versions, version information, and related metadata, use :mc:`mc replicate add` or :mc:`mc admin replicate`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command copies files from a local filesystem directory
      to the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc cp --recursive ~/mydata/ myminio/mydata/

   .. tab-item:: SYNTAX

      The :mc:`mc cp` command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] cp                                                        \
                          [--attr "string"]                                         \
                          [--disable-multipart]                                     \
                          [--enc-kms "string"]                                      \
                          [--enc-s3 "string"]                                       \
                          [--enc-c "string"]                                        \
                          [--legal-hold "on"]                                       \
                          [--limit-download string]                                 \
                          [--limit-upload string]                                   \
                          [--md5]                                                   \
                          [--newer-than "string"]                                   \
                          [--older-than "string"]                                   \
                          [--preserve]                                              \
                          [--recursive]                                             \
                          [--retention-mode "string" --retention-duration "string"] \
                          [--rewind "string"]                                       \
                          [--storage-class "string"]                                \
                          [--tags "string"]                                         \
                          [--version-id "string"]                                   \
                          [--zip]                                                   \
                          SOURCE [SOURCE ...]                                       \
                          TARGET

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: SOURCE
   :required:

   The object or objects to copy. 

   For copying an object from MinIO, specify the :ref:`alias <alias>` and the full path to that object (e.g. bucket and path to object). 
   For example:

   .. code-block:: none

      mc cp play/mybucket/object.txt ~/mydata/object.txt

   Specify multiple ``SOURCE`` paths to copy multiple objects to the specified :mc-cmd:`~mc cp TARGET`. 
   :mc:`mc cp` treats the *last* specified alias or filesystem path as the ``TARGET``. 
   For example:

   .. code-block:: none

      mc cp ~/data/object.txt myminio/mydata/object.txt play/mydata/

   For copying an object from a local filesystem, specify the full path to that object. 
   For example:

   .. code-block:: none

      mc cp ~/mydata/object.txt play/mybucket/object.txt
   
   If you specify a directory or bucket to :mc-cmd:`~mc cp SOURCE`, you must also specify :mc-cmd:`~mc cp --recursive` to recursively copy the contents of that directory or bucket. 
   If you omit the ``--recursive`` argument, :mc:`~mc cp` only copies objects in the top level of the specified directory or bucket.

.. mc-cmd:: TARGET
   :required:

   The full path to which :mc:`mc cp` copies the object.

   For copying an object to MinIO,
   specify the :mc:`alias <mc alias>` and the full path to that object
   (e.g. bucket and path to object). For example:

   .. code-block:: none

      mc cp ~/mydata/object.txt play/mybucket/object.txt


   For copying an object from a local filesystem, specify the full
   path to that object. For example:

   .. code-block:: none

      mc cp play/mybucket/object.txt ~/mydata/object.txt

.. mc-cmd:: --attr
   :optional:

   Add custom metadata for the object. 
   Specify key-value pairs as ``KEY=VALUE\;``. 
   For example, ``--attr key1=value1\;key2=value2\;key3=value3``.

.. mc-cmd:: --checksum
   :optional:

   .. versionadded:: RELEASE.2024-10-02T08-27-28Z

   Add a checksum to an uploaded object. 
   
   Valid values are: 
   - ``MD5``
   - ``CRC32``
   - ``CRC32C``
   - ``SHA1``
   - ``SHA256``

   The flag requires server trailing headers and works with AWS or MinIO targets.

.. mc-cmd:: --disable-multipart
   :optional:

   Disables multipart upload for the copy session.

.. block include of enc-c , enc-s3, and enc-kms

.. include:: /includes/common-minio-sse.rst
   :start-after: start-minio-mc-sse-options
   :end-before: end-minio-mc-sse-options

.. mc-cmd:: --legal-hold
   :optional:

   Enables indefinite :ref:`legal hold <minio-object-locking-legalhold>` object locking on the copied objects.

   Specify ``on``.

.. include:: /includes/linux/minio-client.rst
   :start-after: start-mc-limit-flags-desc
   :end-before: end-mc-limit-flags-desc

.. mc-cmd:: --md5
   :optional:

   .. versionchanged:: RELEASE.2024-10-02T08-27-28Z

      Replaced by the :mc-cmd:`~mc cp --checksum` flag.

   Forces all uploads to calculate MD5 checksums. 

.. mc-cmd:: --newer-than
   :optional:

   Copy object(s) newer than the specified number of days.  
   Specify a string in ``#d#hh#mm#ss`` format. 
   For example: ``--older-than 1d2hh3mm4ss``

   Defaults to ``0`` (all objects).

.. mc-cmd:: --older-than
   :optional:

   Copy object(s) older than the specified time limit. 
   Specify a string in ``#d#hh#mm#ss`` format. 
   For example: ``--older-than 1d2hh3mm4ss``
      
   Defaults to ``0`` (all objects).

.. mc-cmd:: --preserve, a
   :optional:

   Preserve file system attributes and bucket policy rules of the :mc-cmd:`~mc cp SOURCE` directories, buckets, and objects on the :mc-cmd:`~mc cp TARGET` bucket(s).


.. mc-cmd:: --recursive, r
   :optional:
   
   Recursively copy the contents of each bucket or directory :mc-cmd:`~mc cp SOURCE` to the :mc-cmd:`~mc cp TARGET` bucket.

.. mc-cmd:: --retention-duration
   :optional:

   The duration of the :ref:`WORM retention mode <minio-object-locking-retention-modes>` to apply to the copied object(s).

   Specify the duration as a string in ``#d#hh#mm#ss`` format. 
   For example: ``--retention-duration "1d2hh3mm4ss"``.

   Requires specifying :mc-cmd:`~mc cp --retention-mode`.

.. mc-cmd:: --retention-mode
   :optional:

   Enables :ref:`object locking mode <minio-object-locking-retention-modes>` on the copied object(s).
   Supports the following values:

   - ``GOVERNANCE``
   - ``COMPLIANCE``

   Requires specifying :mc-cmd:`~mc cp --retention-duration`.

.. mc-cmd:: --rewind
   :optional:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: --storage-class, sc
   :optional:

   Set the storage class for the new object(s) on the :mc-cmd:`~mc cp TARGET`. 
         
   See :aws-docs:`AmazonS3/latest/dev/storage-class-intro.html` for
   more information on S3 storage classes.

.. mc-cmd:: --tags
   :optional:

   Applies one or more tags to the copied objects.

   Specify an ampersand-separated list of key-value pairs as 
   ``KEY1=VALUE1&KEY2=VALUE2``, where each pair represents one tag to
   assign to the objects.

.. mc-cmd:: --version-id, vid
   :optional:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

.. mc-cmd:: --zip
   :optional:

   During copy, extract files from a `.zip` archive.
   Only functional when the source archive file exists on a MinIO deployment.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Copy Object to S3
~~~~~~~~~~~~~~~~~

Use :mc:`mc cp` to copy an object to an S3-compatible host:

.. tab-set::

   .. tab-item:: Filesystem to S3

      .. code-block:: shell
         :class: copyable

         mc cp SOURCE ALIAS/PATH

      - Replace :mc-cmd:`SOURCE <mc cp SOURCE>` with the filesystem path to the
        object.

      - Replace :mc-cmd:`ALIAS <mc cp TARGET>` with the :mc:`alias <mc alias>`
        of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc cp TARGET>` with the path to the object on 
        the S3-compatible host. You can specify a different object name to
        "rename" the object on copy.

   .. tab-item:: S3 to S3

      .. code-block:: shell
         :class: copyable

         mc cp SRCALIAS/SRCPATH TGTALIAS/TGTPATH

      - Replace :mc-cmd:`SRCALIAS <mc cp SOURCE>` with the 
        :mc:`alias <mc alias>` of a source S3-compatible host.

      - Replace :mc-cmd:`SRCPATH <mc cp SOURCE>` with the path to the 
        object on the S3-compatible host.

      - Replace :mc-cmd:`TGTALIAS <mc cp TARGET>` with the 
        :mc:`alias <mc alias>` of a target S3-compatible host.

      - Replace :mc-cmd:`TGTPATH <mc cp TARGET>` with the path to the 
        object on a target S3-compatible host. Omit the object name to use
        the ``SRCPATH`` object name.

Recursively Copy Objects to S3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp --recursive` to recursively copy objects to an
S3-compatible host:

.. tab-set::

   .. tab-item:: Filesystem to S3

      .. code-block:: shell
         :class: copyable

         mc cp --recursive SOURCE ALIAS/PATH

      - Replace :mc-cmd:`SOURCE <mc cp SOURCE>` with the filesystem path to the
        directory containing the file(s).

      - Replace :mc-cmd:`ALIAS <mc cp TARGET>` with the :mc:`alias <mc alias>`
        of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc cp TARGET>` with the path to the object on 
        the S3-compatible host. :mc:`mc cp` uses the ``SOURCE`` filenames
        when creating the objects on the target host.

   .. tab-item:: S3 to S3

      .. code-block:: shell
         :class: copyable

         mc cp --recursive SRCALIAS/SRCPATH TGTALIAS/TGTPATH

      - Replace :mc-cmd:`SRCALIAS <mc cp SOURCE>` with the 
        :mc:`alias <mc alias>` of a source S3-compatible host.

      - Replace :mc-cmd:`SRCPATH <mc cp SOURCE>` with the path to the 
        bucket or bucket prefix on the source S3-compatible host.

      - Replace :mc-cmd:`TGTALIAS <mc cp TARGET>` with the 
        :mc:`alias <mc alias>` of a target S3-compatible host.

      - Replace :mc-cmd:`TGTPATH <mc cp TARGET>` with the path to the 
        object on the target S3-compatible host. :mc:`mc cp` uses the
        ``SRCPATH`` object names when creating objects on the target
        host.

Copy Point-In-Time Version of Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp --rewind` to copy an object as it existed at a 
specific point in time. This command only applies to S3-to-S3 copy.

.. code-block:: shell
   :class: copyable

   mc cp --rewind DURATION SRCALIAS/SRCPATH TGTALIAS/TGTPATH

- Replace :mc-cmd:`DURATION <mc cp --rewind>` with the point-in-time in the 
  past at which the command copies the object. For example, specify
  ``30d`` to copy the version of the object 30 days prior to the 
  current date.

- Replace :mc-cmd:`SRCALIAS <mc cp SOURCE>` with the 
  :mc:`alias <mc alias>` of a source S3-compatible host.

- Replace :mc-cmd:`SRCPATH <mc cp SOURCE>` with the path to the 
  object on the source S3-compatible host.

- Replace :mc-cmd:`TGTALIAS <mc cp TARGET>` with the 
  :mc:`alias <mc alias>` of a target S3-compatible host.

- Replace :mc-cmd:`TGTPATH <mc cp TARGET>` with the path to the 
  object on the target S3-compatible host. Omit the object name to use
  the ``SRCPATH`` object name.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

Copy Specific Version of Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp --version-id` to copy a specific version of an object. This
command only applies to S3-to-S3 copy.

.. code-block:: shell
   :class: copyable

   mc cp --version-id VERSION SRCALIAS/SRCPATH TGTALIAS/TGTPATH

- Replace :mc-cmd:`VERSION <mc cp --rewind>` with the version of the object to
  copy.

- Replace :mc-cmd:`SRCALIAS <mc cp SOURCE>` with the 
  :mc:`alias <mc alias>` of a source S3-compatible host.

- Replace :mc-cmd:`SRCPATH <mc cp SOURCE>` with the path to the 
  object on the source S3-compatible host.

- Replace :mc-cmd:`TGTALIAS <mc cp TARGET>` with the 
  :mc:`alias <mc alias>` of a target S3-compatible host.

- Replace :mc-cmd:`TGTPATH <mc cp TARGET>` with the path to the 
  object on the target S3-compatible host. Omit the object name to use
  the ``SRCPATH`` object name.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

Add a ``content-type`` Value
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp --attr` to add a ``content-type`` value.
This command only applies to S3-to-S3 copy.

.. code-block:: shell
   :class: copyable

   mc cp --attr="content-type=CONTENT-TYPE" SRCALIAS/SRCPATH TGTALIAS/TGTPATH

- Replace ``CONTENT-TYPE`` with the desired content type (also called a `media type <https://www.iana.org/assignments/media-types/media-types.xhtml>`__).

- Replace :mc-cmd:`SRCALIAS <mc cp SOURCE>` with the :mc:`alias <mc alias>` of a source S3-compatible host.

- Replace :mc-cmd:`SRCPATH <mc cp SOURCE>` with the path to the object on the source S3-compatible host.

- Replace :mc-cmd:`TGTALIAS <mc cp TARGET>` with the :mc:`alias <mc alias>` of a target S3-compatible host.

- Replace :mc-cmd:`TGTPATH <mc cp TARGET>` with the path to the object on the target S3-compatible host.
  Omit the object name to use the ``SRCPATH`` object name.

The following example sets a ``content-type`` of ``application/json``:

.. code-block::
   :class: copyable

    mc cp data.ndjson --attr="content-type=application/json" myminio/mybucket                              


Behavior
--------

:mc:`mc cp` verifies all copy operations to object storage using MD5SUM
checksums. 

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
