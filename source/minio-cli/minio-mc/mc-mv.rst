=========
``mc mv``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc mv

Description
-----------

.. start-mc-mv-desc

The :mc:`mc mv` command moves data from one or more sources to a target
S3-compatible service.

.. end-mc-mv-desc

Checksum Verification
~~~~~~~~~~~~~~~~~~~~~

:mc:`mc mv` verifies all move operations to object storage using MD5SUM
checksums. 

Resume Move Operations
~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd-option:`mc mv continue` to resume an interrupted or failed
move operation from the point of failure. 

Examples
--------

Move Files from Filesystem to S3-Compatible Host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc mv [--recursive] FILEPATH ALIAS/PATH

- Replace :mc-cmd:`FILEPATH <mc mv SOURCE>` with the full file path to the
  file to move. 

  If specifying the path to a directory, include the :mc-cmd-option:`~mc mv
  recursive` flag.

  :mc:`mc mv` *removes* the files from the source after
  successfully moving it to the destination.

- Replace :mc-cmd:`ALIAS <mc mv TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mv TARGET>` with the destination bucket.

Move a File from Filesystem to S3-Compatible Host with Custom Metadata
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mv` with the :mc-cmd-option:`~mc mv attr` option to set custom
attributes on file(s).

.. code-block:: shell
   :class: copyable

   mc mv --attr "ATTRIBUTES" FILEPATH ALIAS/PATH

- Replace :mc-cmd:`FILEPATH <mc mv SOURCE>` with the full file path to the
  file to move. :mc:`mc mv` *removes* the file from the source after
  successfully moving it to the destination.

- Replace :mc-cmd:`ALIAS <mc mv TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mv TARGET>` with the destination bucket.

- Replace :mc-cmd:`ATTRIBUTES <mc mv attr>` with one or more comma-separated
  key-value pairs ``KEY=VALUE``. Each pair represents one attribute key and
  value.

Move Bucket Between S3-Compatible Services
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

    mc mv --recursive SRCALIAS/SRCPATH TGTALIAS/TGTPATH

- Replace :mc-cmd:`SRCALIAS <mc mv SOURCE>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`SRCPATH <mc mv SOURCE>` with the path to the bucket.
  :mc:`mc mv` *removes* the bucket and its contents from the source after
  successfully moving it to the destination.

- Replace :mc-cmd:`TGTALIAS <mc mv TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`TGTPATH <mc mv TARGET>` with the path to the bucket.


Move File to S3-Compatible Host with Specific Storage Class
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mv` with the :mc-cmd-option:`~mc mv storage-class` option to set
the storage class on the destination S3-compatible host.

.. code-block:: shell
   :class: copyable

   mc mv --storage-class CLASS FILEPATH ALIAS/PATH

- Replace :mc-cmd:`CLASS <mc mv storage-class>` with the storage class to 
  associate to the files.

- Replace :mc-cmd:`FILEPATH <mc mv SOURCE>` with the full file path to the
  file to move. :mc:`mc mv` *removes* the file from the source after
  successfully moving it to the destination.

- Replace :mc-cmd:`ALIAS <mc mv TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mv TARGET>` with the destination bucket.

- Replace :mc-cmd:`ATTRIBUTES <mc mv attr>` with one or more comma-separated
  key-value pairs ``KEY=VALUE``. Each pair represents one attribute key and
  value.

   mc mv --storage-class REDUCED_REDUNDANCY myobject.txt play/mybucket




Syntax
------

:mc:`~mc mv` has the following syntax:

.. code-block:: shell

   mc mv [FLAGS] SOURCE [SOURCE...] TARGET

:mc:`~mc mv` supports the following arguments:

.. mc-cmd:: SOURCE

   *REQUIRED*
   
   The object or objects to move. You can specify both local paths
   and S3 paths using a configured S3 service :mc:`alias <mc alias>`. 

   For example:

   .. code-block:: none

      mc mv play/mybucket/object.txt ~/localfiles/mybucket/object.txt TARGET

   If you specify a directory or bucket to :mc-cmd:`~mc mv SOURCE`, you must
   also specify :mc-cmd-option:`~mc mv recursive` to recursively move the
   contents of that directory. If you omit the :mc-cmd-option:`~mc mv recursive`
   argument, :mc:`~mc mv` only moves objects in the top level of the specified
   directory or bucket.

.. mc-cmd:: TARGET

   *REQUIRED*

   The full path to the bucket to move the specified 
   :mc-cmd:`~mc mv SOURCE` to. Specify the :mc:`alias <mc alias>` 
   of a configured S3 service as the prefix to the 
   :mc-cmd:`~mc mv TARGET` path. 

   For example:

   .. code-block:: shell

      mc mv ~/localfiles/object.txt play/mybucket/

.. mc-cmd:: recursive, r
   :option:
   
   Recursively move the contents of each bucket or directory
   :mc-cmd:`~mc mv SOURCE` to the :mc-cmd:`~mc mv TARGET`
   bucket.

.. mc-cmd:: older-than
   :option:

   Remove object(s) older than the specified time limit. Specify a string
   in ``#d#hh#mm#ss`` format. For example: ``--older-than 1d2hh3mm4ss``.
      
   Defaults to ``0`` (all objects).

.. mc-cmd:: newer-than
   :option:

   Remove object(s) newer than the specified number of days.  Specify a
   string in ``##d#hh#mm#ss`` format. For example: 
   ``--newer-than 1d2hh3mm4ss``.

   Defaults to ``0`` (all objects).

.. mc-cmd:: storage-class, sc
   :option:

   Set the storage class for the new object(s) on the 
   :mc-cmd:`~mc mv TARGET`. 
         
   See the Amazon documentation on
   :aws-docs:`Storage Classes <AmazonS3/latest/dev/storage-class-intro.html>` 
   for more information on S3 storage classses.

.. mc-cmd:: preserve, a
   :option:

   Preserve file system attributes and bucket policy rules of the
   :mc-cmd:`~mc mv SOURCE` directories, buckets, and objects on the 
   :mc-cmd:`~mc mv TARGET` bucket(s).

.. mc-cmd:: attr
   :option:

   Add custom metadata for the object. Specify key-value pairs as 
   ``KEY=VALUE\;``. For example, 
   ``--attr key1=value1\;key2=value2\;key3=value3``.

.. mc-cmd:: continue, c
   :option:

   Create or resume a move session. 

.. mc-cmd:: encrypt
   :option:

   Encrypt or decrypt objects using server-side encryption with
   server-managed keys. Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting 
      object(s).

   Enclose the entire list of key-value pairs passed to
   :mc-cmd-option:`~mc mv encrypt` in double-quotes ``"``.

   :mc-cmd-option:`~mc mv encrypt` can use the ``MC_ENCRYPT`` environment
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
   :mc-cmd-option:`~mc mv encrypt-key` in double quotes ``"``.

   :mc-cmd-option:`~mc mv encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for retrieving a list of encryption key-value pairs
   as an alternative to specifying them on the command line.



