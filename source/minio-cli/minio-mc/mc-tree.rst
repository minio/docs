===========
``mc tree``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc tree

Description
-----------

.. start-mc-tree-desc

The :mc:`mc tree` command lists buckets and directories in a tree format. 

.. end-mc-tree-desc

- When applied to an S3-compatible service bucket, :mc:`mc tree` returns
  a tree listing of the bucket and all bucket prefixes.

- When applied to a local filesystem directory, :mc:`mc tree` returns a 
  tree listing of the directory and all of its subdirectories.

Examples
--------

.. code-block:: shell
   :class: copyable

   mc tree ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc tree TARGET>` with the :mc:`alias <mc alias>` 
  of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc tree TARGET>` with the path to the bucket on the
  S3-compatible host.

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

