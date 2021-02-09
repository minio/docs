=========
``mc ls``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ls

Description
-----------

.. start-mc-ls-desc

The :mc:`mc ls` command lists all buckets and objects on the target
S3-compatible service. For targets on a filesystem, :mc:`mc ls` has the same
functionality as the ``ls`` command.

.. end-mc-ls-desc

Examples
--------

List Bucket Contents
~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc ls <mc ls TARGET>` to list the contents of a bucket:

.. code-block:: shell
   :class: copyable

   mc ls [--recursive] ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc ls TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ls TARGET>` with the path to the bucket on the
  S3-compatible host.

  If specifying the path to the S3 root (``ALIAS`` only), include the
  :mc-cmd-option:`~mc ls recursive` option.

List Object Versions
~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd-option:`mc ls versions` to list all versions of an object:

.. code-block:: shell
   :class: copyable

   mc ls --versions ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc ls TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ls TARGET>` with the path to the bucket or object on
  the S3-compatible host.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

List Bucket Contents at Point in Time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd-option:`mc ls versions` to list all versions of an object:

.. code-block:: shell
   :class: copyable

   mc ls --rewind DURATION ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc ls TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ls TARGET>` with the path to the bucket or object on
  the S3-compatible host.

- Replace :mc-cmd:`DURATION <mc ls rewind>` with the point-in-time in the past
  at which the command returns the object. For example, specify ``30d`` to
  return the version of the object 30 days prior to the current date.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

Syntax
------

.. Replacement substitutions

.. |command| replace:: :mc-cmd:`mc ls`
.. |rewind| replace:: :mc-cmd-option:`~mc ls rewind`
.. |versions| replace:: :mc-cmd-option:`~mc ls versions`
.. |alias| replace:: :mc-cmd-option:`~mc ls TARGET`

:mc-cmd:`mc ls` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc ls [FLAGS] TARGET [TARGET ...]

:mc-cmd:`mc ls` supports the following arguments:

.. mc-cmd:: TARGET

   *Required* The full path to one or more locations whose contents the command
   lists. 
   
   - To list the root contents of an S3-compatible service, specify the
     :mc-cmd:`alias <mc alias>` of that service. For example:
     ``mc ls play``

   - To list the contents of a bucket on an S3-compatible service,
     specify the :mc-cmd:`alias <mc alias>` of that service as a prefix to
     the bucket. For example: ``mc ls play/mybucketname``.

   - To list the contents of a directory on a filesystem, specify the path
     to that directory. For example: ``mc ls ~/Documents``.

   If specifying multiple ``TARGET`` locations, :mc-cmd:`mc ls` collates
   the contents of each location sequentially.

.. mc-cmd:: recursive, r
   :option:

   Recursively lists the contents of each bucket or directory in the
   :mc-cmd:`~mc ls TARGET`.

.. mc-cmd:: versions
   :option:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-versions-desc
      :end-before: end-versions-desc

   Use :mc-cmd-option:`~mc ls versions` and 
   :mc-cmd-option:`~mc ls rewind` together to display on those object
   versions which existed at a specific point in time.

.. mc-cmd:: rewind
   :option:
   
   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

   Use :mc-cmd-option:`~mc ls rewind` and 
   :mc-cmd-option:`~mc ls versions` together to display on those object
   versions which existed at a specific point in time.

.. mc-cmd:: incomplete, -I
   :option:

   Returns any incomplete uploads on the specified :mc-cmd:`~mc ls TARGET`
   bucket.