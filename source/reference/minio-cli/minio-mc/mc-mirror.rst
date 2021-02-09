=============
``mc mirror``
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc mirror

Description
-----------

.. start-mc-mirror-desc

The :mc:`mc mirror` command synchronizes content to an S3-compatible host,
similar to the ``rsync`` utility. :mc:`mc mirror` supports both filesystems and
S3-compatible hosts as the synchronization source.

.. end-mc-mirror-desc

Examples
--------

Mirror a Local Directory to an S3-Compatible Host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mirror` to mirror files from a filesystem to an S3 Host:

.. code-block::
   :class: copyable

   mc mirror FILEPATH ALIAS/PATH

- Replace :mc-cmd:`FILEPATH <mc mirror SOURCE>` with the full file path to the
  directory to mirror.

- Replace :mc-cmd:`ALIAS <mc mirror TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mirror TARGET>` with the destination bucket.

Continuously Mirror a Local Directory to an S3-Compatible Host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc watch` with :mc-cmd-option:`~mc mirror watch` to continuously mirror
files from a filesystem to an S3-compatible host:

.. code-block::
   :class: copyable

   mc mirror FILEPATH ALIAS/PATH

- Replace :mc-cmd:`FILEPATH <mc mirror SOURCE>` with the full file path to the
  directory to mirror.

- Replace :mc-cmd:`ALIAS <mc mirror TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mirror TARGET>` with the destination bucket.

Continuously Mirror S3 Bucket to an S3-Compatible Host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mirror` with :mc-cmd-option:`~mc mirror watch` to continuously
mirror objects in a bucket on one S3-compatible host to another S3-compatible
host.

.. code-block::
   :class: copyable

   mc mirror --watch SRCALIAS/SRCPATH TGTALIAS/TGTPATH

- Replace :mc-cmd:`SRCALIAS <mc mirror SOURCE>` with :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`SRCPATH <mc mirror SOURCE>` with the bucket to mirror.

- Replace :mc-cmd:`TGTALIAS <mc mirror TARGET>` with the 
  :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`TGTPATH <mc mirror TARGET>` with the destination bucket.

Syntax
------

:mc:`~mc mirror` has the following syntax:

.. code-block:: shell

   mc mirror [FLAGS] SOURCE TARGET

:mc:`~mc mirror` supports the following arguments:

.. mc-cmd:: SOURCE

   *REQUIRED*

   The file(s) or object(s) to synchronize to the :mc-cmd:`~mc mirror TARGET`
   S3 host.

   For objects on S3-compatible hosts, specify the path to the object as 
   ``ALIAS/PATH``, where:

   - ``ALIAS`` is the :mc:`alias <mc alias>` of a configured S3-compatible host,
     *and*

   - ``PATH`` is the path to the bucket or object. If specifying a bucket,
     :mc:`mc mirror` synchronizes all objects in the bucket.

   .. code-block:: shell

      mc mirror [FLAGS] play/mybucket/ TARGET

   For files on a filesystem, specify the full filesystem path to the file or
   directory :

   .. code-block:: shell

      mc mirror [FLAGS] ~/data/ TARGET

   If specifying a directory, :mc-cmd:`mc mirror` synchronizes all files in the
   directory.

.. mc-cmd:: TARGET

   *REQUIRED*

   The full path to bucket in which :mc:`mc mirror` copies
   synchronized SOURCE objects. Specify the ``TARGET`` as
   ``ALIAS/PATH``, where:

   - ``ALIAS`` is the :mc:`alias <mc alias>` of a configured S3-compatible
     host, *and*

   - ``PATH`` is the path to the bucket.

   .. code-block:: shell

      mc mirror SOURCE play/mybucket

   :mc:`mc mirror` uses the object or file names from the
   :mc-cmd:`~mc mirror SOURCE` when synchronizing to the ``TARGET`` bucket.

.. mc-cmd:: overwrite
   :option:
   
   Overwrites object(s) on the :mc-cmd:`~mc mirror TARGET`.

.. mc-cmd:: remove
   :option:

   Removes extraneous object(s) on the target. 

.. mc-cmd:: watch, w
   :option:

   Continuously monitor the :mc-cmd:`~mc mirror SOURCE` path and
   synchronize changes.

.. mc-cmd:: region
   :option:

   Specify the ``string`` region when creating new bucket(s) on the
   target. 

   Defaults to ``"us-east-1"``.

.. mc-cmd:: preserve, a
   :option:

   Preserve file system attributes and bucket policy rules of the
   :mc-cmd:`~mc mirror SOURCE` on the
   :mc-cmd:`~mc mirror TARGET`.

.. mc-cmd:: exclude
   :option:

   Exclude object(s) in the :mc-cmd:`~mc mirror SOURCE` path that
   match the specified object name pattern.

.. mc-cmd:: older-than
   :option:

   Mirror object(s) older than the specified time limit. Specify a string
   in ``#d#hh#mm#ss`` format. For example: ``--older-than 1d2hh3mm4ss``
      
   Defaults to ``0`` (all objects).

.. mc-cmd:: newer-than
   :option:

   Mirror object(s) newer than the specified number of days.  Specify a
   string in ``#d#hh#mm#ss`` format. For example: 
   ``--older-than 1d2hh3mm4ss``

   Defaults to ``0`` (all objects).

.. mc-cmd:: fake
   :option:

   Perform a fake mirror operation. Use this operation to perform 
   validate that the :mc:`mc mirror` operation will only
   mirror the desired objects or buckets.

.. mc-cmd:: storage-class, sc
   :option:

   Set the storage class for the new object(s) on the 
   :mc-cmd:`~mc mirror TARGET`. 
         
   See the Amazon documentation on
   :aws-docs:`Storage Classes <AmazonS3/latest/dev/storage-class-intro.html>` 
   for more information on S3 storage classses.

.. mc-cmd:: encrypt-key
   :option:

   Encrypt or decrypt objects using server-side encryption with
   client-specified keys. Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting 
      object(s).

   Enclose the entire list of key-value pairs passed to 
   :mc-cmd-option:`~mc mirror encrypt-key` in double quotes ``"``.

   :mc-cmd-option:`~mc mirror encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for retrieving a list of encryption key-value pairs
   as an alternative to specifying them on the command line.

   You can only delete encrypted objects if you specify the correct
   :mc-cmd-option:`~mc mirror encrypt-key` secret key.

