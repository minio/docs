===========
``mc head``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc::  mc head

Description
-----------

.. start-mc-head-desc

The :mc:`mc head` command displays the first ``n`` lines of an object,
where ``n`` is an argument specified to the command.

.. end-mc-head-desc

:mc:`mc head` does not perform any transformation or formatting of object
contents to facilitate readability.

Examples
--------

View Partial Contents of an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc head` to return the first 10 lines of an object:

.. code-block:: shell
   :class: copyable

   mc head ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc head SOURCE>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc head SOURCE>` with the path to the object on the
  S3-compatible host.

View Partial Contents of an Object at a Point in Time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd-option:`mc head rewind` to return the first 10 lines of the
object at a specific point-in-time in the past:

.. code-block:: shell
   :class: copyable

   mc head ALIAS/PATH --rewind DURATION

- Replace :mc-cmd:`ALIAS <mc head SOURCE>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc head SOURCE>` with the path to the object on the
  S3-compatible host.

- Replace :mc-cmd:`DURATION <mc head rewind>` with the point-in-time in the past
  at which the command returns the object. For example, specify ``30d`` to
  return the version of the object 30 days prior to the current date.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

View Partial Contents of an Object with Specific Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd-option:`mc head version-id` to return the first 10 lines of the
object at a specific point-in-time in the past:

.. code-block:: shell
   :class: copyable

   mc head ALIAS/PATH --version-id VERSION

- Replace :mc-cmd:`ALIAS <mc head SOURCE>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc head SOURCE>` with the path to the object on the
  S3-compatible host.

- Replace :mc-cmd:`VERSION <mc head version-id>` with the version of the object.
  For example, specify ``30d`` to return the version of the object 30 days prior
  to the current date.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

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
