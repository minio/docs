=============
``mc mirror``
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc mirror

Description
-----------

.. start-mc-mirror-desc

The :mc:`mc mirror` command synchronizes content between a source
filesystem and a target S3-compatible service. :mc:`~mc mirror` has
similar functionality to ``rsync``. 

.. end-mc-mirror-desc

Syntax
------

:mc:`~mc mirror` has the following syntax:

.. code-block:: shell

   mc mirror [FLAGS] SOURCE TARGET

:mc:`~mc mirror` supports the following arguments:

.. mc-cmd:: SOURCE

   **REQUIRED**

   The full path to the object or directory to synchronize. If specifying
   a directory, :mc:`mc mirror` synchronizes all objects in the 
   directory.

.. mc-cmd:: TARGET

   **REQUIRED**

   The full path to bucket in which :mc:`mc mirror` copies
   synchronized SOURCE objects. Specify the :mc:`alias <mc alias>` of a
   configured S3 service as the prefix to the :mc-cmd:`~mc mirror TARGET`
   path. 

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

Behavior
--------

Examples
--------

Mirror a Local Directory to an S3 Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only


.. code-block::
   :class: copyable

   mc mirror ~/data/ play/mybucket

Continuously Mirror a Local Directory to an S3 Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only


.. code-block::
   :class: copyable

   mc mirror --watch ~/data/ play/mybucket