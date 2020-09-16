==========
``mc cat``
==========

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 1

.. mc:: mc cat

Description
-----------

.. start-mc-cat-desc

The :mc:`mc cat` command concatenates the contents of a file or
object to another file or object. You can also use the command to
display the contents of the specified file or object to ``STDOUT``. 
:mc:`~mc cat` has similar functionality to ``cat``. 

.. end-mc-cat-desc

Quick Reference
---------------

:mc-cmd:`mc cat play\object.txt <mc cat SOURCE>`
   Returns the contents of ``object.txt``. ``play`` corresponds to the
   :mc-cmd:`alias <mc alias>` of a configured S3-compatible service.

:mc-cmd:`mc cat --rewind "30d" play\myobject.txt <mc cat rewind>`
   Returns the contents of the ``object.txt`` as it existed ``30`` days
   prior to the current date. ``play`` corresponds to the
   :mc-cmd:`alias <mc alias>` of a configured S3-compatible service.

   :mc-cmd-option:`mc cat rewind` requires :ref:`bucket versioning
   <minio-bucket-versioning>`. Use :mc:`mc version` to enable versioning
   on a bucket.

:mc-cmd:`mc cat --version-id 4f85ff5c-ade5-4fb7-be54-1b62dd00f45f play\myobject.txt <mc cat version-id>`
   Returns the contents of the ``object.txt`` version with matching
   ``--version-id``. ``play`` corresponds to the
   :mc-cmd:`alias <mc alias>` of a configured S3-compatible service.

   :mc-cmd-option:`mc cat version-id` requires :ref:`bucket versioning
   <minio-bucket-versioning>`. Use :mc:`mc version` to enable versioning
   on a bucket.

   Use :mc-cmd:`mc ls versions play\myobject.txt <mc ls versions>` to list all 
   versions of the object.

Syntax
------

.. Replacement substitutions

.. |command| replace:: :mc-cmd:`mc cat`
.. |rewind| replace:: :mc-cmd-option:`~mc cat rewind`
.. |versionid| replace:: :mc-cmd-option:`~mc cat version-id`
.. |alias| replace:: :mc-cmd-option:`~mc cat SOURCE`

:mc:`~mc cat` has the following syntax:

.. code-block:: shell

   mc cat [FLAGS] SOURCE [SOURCE ...]

:mc:`~mc cat` supports requires following arguments:

.. mc-cmd:: SOURCE

   **REQUIRED**

   The full path to the file or object to concatenate. 

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

.. mc-cmd:: encrypt-key
   :option:

   Encrypt or decrypt objects using server-side encryption with
   client-specified keys. Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting 
      object(s).

   Enclose the entire list of key-value pairs passed to 
   :mc-cmd:`~mc cat --encrypt-key` in double quotes ``"``.

   :mc-cmd:`~mc cat --encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for retrieving a list of encryption key-value pairs
   as an alternative to specifying them on the command line.

Examples
--------

Display the Contents of an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc cat play/mybucket/object.txt

Display the Contents of a Server Encrypted Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc cat --encrypt-key="play/mybucket=32ByteLongSecretKeyMustBeGiven1" play/mybucket/object.txt

If the secret key contains non-printable characters, specify a ``base64``
encoded string instead:

.. code-block:: shell
   :class: copyable

   mc cat --encrypt-key="play/mybucket=MzJieXRlc2xvbmdzZWNyZWFiY2RlZmcJZ2l2ZW5uMjE=" play/mybucket/object.txt

Display the Past Contents of an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

To retrieve the contents of an object a specific number of days in the past, 
specify :mc-cmd-option:`mc cat rewind` with a duration of ``##d``:

.. code-block:: shell
   :class: copyable

   mc cat --rewind "10d" play/mybucket/object.txt

To retrieve the contents of an object at a specific date or time in the past,
specify :mc-cmd-option:`mc cat rewind` with an ISO8601-formatted timestamp:

.. code-block:: shell
   :class: copyable

   mc cat --rewind "2020.03.04T12:34" play/mybucket/object.txt

:mc-cmd-option:`mc cat rewind` requires :ref:`bucket versioning
<minio-bucket-versioning>`. Use :mc:`mc version` to enable versioning
on a bucket.
