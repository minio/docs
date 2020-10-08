=========
``mc cp``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc cp

Description
-----------

.. start-mc-cp-desc

The :mc:`mc cp` command copies data from one or more sources to a target
S3-compatible service.

.. end-mc-cp-desc

Examples
~~~~~~~~

Copy Object to S3
~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp` to copy an object to an S3-compatible host:

.. tabs::

   .. tab:: Filesystem to S3

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

   .. tab:: S3 to S3

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

Use :mc-cmd-option:`mc cp recursive` to recursively copy objects to an
S3-compatible host:

.. tabs::

   .. tab:: Filesystem to S3

      .. code-block:: shell
         :class: copyable

         mc cp --recursive SOURCE ALIAS/PATH

      - Replace :mc-cmd:`SOURCE <mc cp SOURCE>` with the filesystem path to the
        directory containing the file(s).

      - Replace :mc-cmd:`ALIAS <mc cp TARGET>` with the :mc:`alias <mc alias>`
        of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc cp TARGET>` with the path to the object on 
        the S3-compatible host. :mc-cmd:`mc cp` uses the ``SOURCE`` filenames
        when creating the objects on the target host.

   .. tab:: S3 to S3

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
        object on the target S3-compatible host. :mc-cmd:`mc cp` uses the
        ``SRCPATH`` object names when creating objects on the target
        host.

Copy Point-In-Time Version of Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd-option:`mc cp rewind` to copy an object as it existed at a 
specific point in time. This command only applies to S3-to-S3 copy.

.. code-block:: shell
   :class: copyable

   mc cp --rewind DURATION SRCALIAS/SRCPATH TGTALIAS/TGTPATH

- Replace :mc-cmd:`DURATION <mc cp rewind>` with the point-in-time in the 
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

Use :mc-cmd-option:`mc cp version-id` to copy a specific version of an object. This
command only applies to S3-to-S3 copy.

.. code-block:: shell
   :class: copyable

   mc cp --version-id VERSION SRCALIAS/SRCPATH TGTALIAS/TGTPATH

- Replace :mc-cmd:`VERSION <mc cp rewind>` with the version of the object to
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

Syntax
------

.. |command| replace:: :mc-cmd:`mc cp`
.. |rewind| replace:: :mc-cmd-option:`~mc cp rewind`
.. |versionid| replace:: :mc-cmd-option:`~mc cp version-id`
.. |alias| replace:: :mc-cmd-option:`~mc cp SOURCE`

:mc:`mc cp` has the following syntax:

.. code-block:: shell

   mc cp [FLAGS] SOURCE [SOURCE...] TARGET

:mc:`~mc cp` supports the following arguments:

.. mc-cmd:: SOURCE

   **REQUIRED**
   
   The object or objects to copy. You can specify both local paths
   and S3 paths using a configured S3 service :mc:`alias <mc alias>`. 

   For example:

   .. code-block:: none

      mc cp play/mybucket/object.txt ~/localfiles/mybucket/object.txt TARGET

   If you specify a directory or bucket to :mc-cmd:`~mc cp SOURCE`, you must
   also specify :mc-cmd-option:`~mc cp recursive` to recursively copy the
   contents of that directory or bucket. If you omit the ``--recursive``
   argument, :mc:`~mc cp` only copies objects in the top level of the specified
   directory or bucket.

.. mc-cmd:: TARGET

   **REQUIRED**

   The full path to the bucket to copy the specified 
   :mc-cmd:`~mc cp SOURCES` to. Specify the :mc:`alias <mc alias>` 
   of a configured S3 service as the prefix to the 
   :mc-cmd:`~mc cp TARGET` path. 

   For example:

   .. code-block:: shell

      mc cp ~/localfiles/object.txt play/mybucket/

.. mc-cmd:: recursive, r
   :option:
   
   Recursively copy the contents of each bucket or directory
   :mc-cmd:`~mc cp SOURCE` to the :mc-cmd:`~mc cp TARGET`
   bucket.

.. mc-cmd:: rewind
   :option:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: version-id, vid
   :option:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

.. mc-cmd:: older-than
   :option:

   Remove object(s) older than the specified time limit. Specify a string
   in ``#d#hh#mm#ss`` format. For example: ``--older-than 1d2hh3mm4ss``
      
   Defaults to ``0`` (all objects).

.. mc-cmd:: newer-than
   :option:

   Remove object(s) newer than the specified number of days.  Specify a 
   string in ``#d#hh#mm#ss`` format. For example: 
   ``--older-than 1d2hh3mm4ss``

   Defaults to ``0`` (all objects).

.. mc-cmd:: storage-class, sc
   :option:

   Set the storage class for the new object(s) on the 
   :mc-cmd:`~mc cp TARGET`. 
         
   See :aws-docs:`AmazonS3/latest/dev/storage-class-intro.html` for
   more information on S3 storage classses.

.. mc-cmd:: preserve, a
   :option:

   Preserve file system attributes and bucket policy rules of the
   :mc-cmd:`~mc cp SOURCE` directories, buckets, and objects on the 
   :mc-cmd:`~mc cp TARGET` bucket(s).

.. mc-cmd:: attr
   :option:

   Add custom metadata for the object. Specify key-value pairs as 
   ``KEY=VALUE\;``. For example, 
   ``--attr key1=value1\;key2=value2\;key3=value3``.

.. mc-cmd:: continue, c
   :option:

   Create or resume a copy session. 

.. mc-cmd:: encrypt
   :option:

   Encrypt or decrypt objects using server-side encryption with
   server-managed keys. Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting 
      object(s).

   Enclose the entire list of key-value pairs passed to
   :mc-cmd-option:`~mc cp encrypt` in double-quotes ``"``.

   :mc-cmd-option:`~mc cp encrypt` can use the ``MC_ENCRYPT`` environment
   variable for retrieving a list of encryption key-value pairs as an
   alternative to specifying them on the command line.

.. mc-cmd:: encrypt-key
   :option:

   Encrypt or decrypt objects using server-side encryption with
   client-specified keys. Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting 
      object(s).

   Enclose the entire list of key-value pairs passed to 
   :mc-cmd-option:`~mc cp encrypt-key` in double quotes ``"``.

   :mc-cmd-option:`~mc cp encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for retrieving a list of encryption key-value pairs
   as an alternative to specifying them on the command line.

Behavior
--------

:mc:`mc cp` verifies all copy operations to object storage using MD5SUM
checksums. 

Interrupted or failed copy operations can resume from the point of failure
by issuing the :mc:`mc cp` operation again with the 
:mc-cmd-option:`~mc cp continue` argument.

Examples
--------

Copy a text file to an object storage.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc cp myobject.txt play/mybucket

Copy a text file to an object storage with specified metadata.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable
   
   mc cp --attr key1=value1;key2=value2 myobject.txt play/mybucket

Copy a folder recursively from MinIO cloud storage to Amazon S3 cloud storage with specified metadata.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

    mc cp --attr Cache-Control=max-age=90000,min-fresh=9000\;key1=value1\;key2=value2 \
      --recursive play/mybucket/bucketname/ s3/mybucket/


Copy a text file to an object storage and assign ``storage-class`` REDUCED_REDUNDANCY to the uploaded object.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc cp --storage-class REDUCED_REDUNDANCY myobject.txt play/mybucket

Copy a server-side encrypted file to an object storage.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example assumes that the ``s3`` and ``myminio`` aliases
exists in the :mc:`mc` :ref:`configuration file <mc-configuration>`. See
:mc:`mc alias` for more information on aliases.

.. code-block:: shell
   :class: copyable

   mc cp --recursive \
     --encrypt-key "s3/documents/=32byteslongsecretkeymustbegiven1 , myminio/documents/=32byteslongsecretkeymustbegiven2" \ 
     s3/documents/myobject.txt myminio/documents/

Perform key-rotation on a server-side encrypted object.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:mc:`mc cp` key rotation requires creating an additional alias with the same
endpoing as the target S3 service alias. :mc:`mc cp` effectively decrypts
the object using the old secret key, encrypts the object using the new
secret key, and replaces the old object with the newly encrypted object.

The following example assumes that the ``myminio1`` and ``myminio2`` aliases
exists in the :mc:`mc` :ref:`configuration file <mc-configuration>`. See
:mc:`mc alias` for more information on aliases.

.. code-block:: shell
   :class: copyable

   mc cp --encrypt-key 'myminio1/mybucket=32byteslongsecretkeymustgenerate , myminio2/mybucket/=32byteslongsecretkeymustgenerat1' \
     myminio1/mybucket/encryptedobject myminio2/mybucket/encryptedobject

Copy a javascript file to object storage and assign ``Cache-Control`` header to the uploaded object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc cp --attr Cache-Control=no-cache myscript.js play/mybucket

Copy a text file to an object storage and preserve the filesyatem attributes.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc cp -a myobject.txt play/mybucket


