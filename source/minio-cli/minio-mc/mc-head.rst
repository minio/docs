===========
``mc head``
===========

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 1

.. mc::  mc head

Description
-----------

.. start-mc-head-desc

The :mc:`mc head` command displays the first ``n`` lines of an object,
where ``n`` is an argument specified to the command.

.. end-mc-head-desc

Syntax
------

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
