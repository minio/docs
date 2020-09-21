===========
``mc tree``
===========

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 1

.. mc:: mc tree

Description
-----------

.. start-mc-tree-desc

The :mc:`mc tree` command lists buckets and directories in a tree format. 

When applied to an S3-compatible service bucket, :mc:`mc tree` returns
a tree listing of the bucket and all bucket prefixes.

When applied to a local filesystem directory, :mc:`mc tree` returns a 
tree listing of the directory and all of its subdirectories.

.. end-mc-tree-desc

Syntax
------

.. |command| replace:: :mc-cmd:`mc tree`
.. |rewind| replace:: :mc-cmd-option:`~mc tree set rewind`
.. |alias| replace:: :mc-cmd-option:`~mc tree set TARGET`

:mc:`~mc tree` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc tree [FLAGS] TARGET [TARGET...]

:mc:`~mc tree` supports the following arguments:

.. mc-cmd:: TARGET

   *Required* The full path to an S3-compatible service bucket *or* local
   filesystem directory.

   For objects on an S3-compatible service, specify the :mc:`alias <mc alias>`
   of a configured service as the prefix to the :mc-cmd:`~mc stat TARGET`
   path. For example:

   .. code-block:: shell

      mc stat [FLAGS] play/mybucket

.. mc-cmd:: files, f
   :option:

   Includes files in the object or directory in the :mc:`mc tree` output.

.. mc-cmd:: rewind
   :option:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

Examples
--------

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc tree play/mybucket