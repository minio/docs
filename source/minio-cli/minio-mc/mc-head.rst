===========
``mc head``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc::  mc head

Description
-----------

.. start-mc-head-desc

The :mc:`mc head` command displays the first ``n`` lines of an object,
where ``n`` is an argument specified to the command.

.. end-mc-head-desc

Quick Reference
---------------

:mc-cmd:`mc head play/object.txt <mc head SOURCE>`
   Returns the first 10 lines of ``object.txt``. ``play`` corresponds to the
   :mc-cmd:`alias <mc alias>` of a configured S3-compatible service.

:mc-cmd:`mc head --lines 20 play/object.txt <mc head lines>`
   Returns the first 20 lines of ``object.txt``. ``play`` corresponds to the
   :mc-cmd:`alias <mc alias>` of a configured S3-compatible service.

:mc-cmd:`mc head --rewind "30d" play/object.txt <mc head rewind>`
   Returns the first 10 lines of ``object.txt`` as it existed 30 days prior to
   the current date. ``play`` corresponds to the
   :mc-cmd:`alias <mc alias>` of a configured S3-compatible service.

   :mc-cmd-option:`mc head rewind` requires :ref:`bucket versioning
   <minio-bucket-versioning>`. Use :mc:`mc version` to enable versioning
   on a bucket.

:mc-cmd:`mc head --version-id 4f85ff5c-ade5-4fb7-be54-1b62dd00f45f play/object.txt <mc head version-id>`
   Returns the first 10 lines of the ``object.txt`` version with matching
   ``--version-id``. ``play`` corresponds to the
   :mc-cmd:`alias <mc alias>` of a configured S3-compatible service.

   :mc-cmd-option:`mc head version-id` requires :ref:`bucket versioning
   <minio-bucket-versioning>`. Use :mc:`mc version` to enable versioning
   on a bucket.

   Use :mc-cmd:`mc ls versions play\myobject.txt <mc ls versions>` to list all 
   versions of the object.

Syntax
------

.. |command| replace:: :mc-cmd:`mc head`
.. |rewind| replace:: :mc-cmd-option:`~mc head rewind`
.. |versionid| replace:: :mc-cmd-option:`~mc head version-id`
.. |alias| replace:: :mc-cmd-option:`~mc head SOURCE`

:mc:`~mc head` has the following syntax:

.. code-block:: shell

   mc head [FLAGS] SOURCE [SOURCE...]

:mc:`~mc head` supports the following arguments:

.. mc-cmd::  --lines, -n

   The number of lines to print.

   Defaults to ``10``.

.. mc-cmd::  SOURCE

   **REQUIRED**
   
   The object or objects to print. You can specify both local paths
   and S3 paths using a configured S3 service :mc:`alias <mc alias>`. 

   For example:

   .. code-block:: none

      mc head play/mybucket/object.txt ~/localfiles/mybucket/object.txt

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

.. mc-cmd::  encrypt-key
   :option:

   Encrypt or decrypt objects using server-side encryption with
   client-specified keys. Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting 
      object(s).

   Enclose the entire list of key-value pairs passed to 
   :mc-cmd-option:`~mc head encrypt-key` in double quotes ``"``.

   :mc-cmd-option:`~mc head encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for retrieving a list of encryption key-value pairs
   as an alternative to specifying them on the command line.

Behavior
--------

:mc:`mc head` makes no assumptions about the format of the object data.
If the object data is not human readable, the output of :mc:`mc head`
will also not be human readable.

Examples
--------

Display ``n`` Lines of an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc head --lines 20 play/mybucket/myobject.txt

Display ``n`` Lines of an Encrypted Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc head lines --20 \
     --encrypt-key "play/mybucket=32byteslongsecretkeymustbegiven1" \
     play/mybucket/myobject.txt
