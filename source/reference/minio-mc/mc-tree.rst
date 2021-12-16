===========
``mc tree``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc tree

.. |command| replace:: :mc-cmd:`mc tree`
.. |rewind| replace:: :mc-cmd-option:`~mc tree rewind`
.. |alias| replace:: :mc-cmd-option:`~mc tree ALIAS`

Syntax
------

.. start-mc-tree-desc

The :mc:`mc tree` command lists all prefixes inside a MinIO bucket in a tree
format. The command optionally supports listing all objects inside of bucket
at each prefix, including the bucket root.

.. end-mc-tree-desc

You can also use :mc:`mc tree` against a local filesystem directory to
produce similar results to the ``tree`` commandline tool.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command prints a complete tree of all objects at any
      depth in the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc tree --files myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] tree                 \
                          [--depth int]        \
                          [--files]            \
                          [--rewind "string"]  \

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The :ref:`alias <alias>` of a MinIO deployment and the
   full path to the bucket to list the tree hierarchy. For example:

   .. code-block:: shell

      mc tree myminio/mybucket

   You can specify multiple targets to The command command. For
   example:

   .. code-block:: shell

      mc tree myminio/mybucket myminio/myotherbucket

   For retrieving the tree heirarchy of a local filesystem directory,
   specify the full path to that directory. For example:

   .. code-block:: shell

      mc tree ~/minio/mydata/

.. mc-cmd:: depth, d
   :option:

   *Optional* Limit the tree depth to the specified integer value. 
   
   Defaults to ``-1`` or unlimited depth.

.. mc-cmd:: files, f
   :option:

   *Optional* Includes files in the object or directory in the :mc:`mc tree`
   output.

.. mc-cmd:: rewind
   :option:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

Examples
--------

.. code-block:: shell
   :class: copyable

   mc tree ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc tree ALIAS>` with the :ref:`alias <alias>` 
  of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc tree ALIAS>` with the path to the bucket on the
  MinIO deployment.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility