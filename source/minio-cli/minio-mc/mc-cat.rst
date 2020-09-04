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

Syntax
------

:mc:`~mc cat` has the following syntax:

.. code-block:: shell

   mc cat [FLAGS] SOURCE [SOURCE ...]

:mc:`~mc cat` supports requires following arguments:

.. mc-cmd:: SOURCE

   **REQUIRED**

   The full path to the file or object to concatenate. 

.. mc-cmd:: rewind
   :option:

   Returns the contents of the object at a specified date or after the
   specified duration. Enclose the specified date or duration in double
   quotes ``"``.

   - For a date in time, specify an ISO8601-formatted timestamp. For example:
     ``--rewind "2020.03.24T10:00"``.

   - For duration, specify a string in ``#d#hh#mm#ss`` format. For example:
     ``--rewind "1d2hh3mm4ss"``.

   :mc-cmd:`mc cat rewind` requires the specified :mc-cmd:`~mc cat SOURCE`
   be an S3-compatible service that supports Bucket Versioning. For
   MinIO deployments, use :mc-cmd:`mc version` to enable or disable bucket
   versioning.

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
specify :mc-cmd:`mc cat --rewind` with a duration of ``##d``:

.. code-block:: shell
   :class: copyable

   mc cat --rewind "10d" play/mybucket/object.txt

To retrieve the contents of an object at a specific date or time in the past,
specify :mc-cmd:`mc cat --rewind` with an ISO8601-formatted timestamp:

.. code-block:: shell
   :class: copyable

   mc cat --rewind "2020.03.04T12:34" play/mybucket/object.txt