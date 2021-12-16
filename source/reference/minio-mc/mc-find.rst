.. _minio-mc-find:

===========
``mc find``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc find

Syntax
------

.. start-mc-find-desc

The :mc:`mc find` command supports searching for objects on a MinIO
deployment. You can also use the command to search for files on a filesystem. 

.. end-mc-find-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command searches for all objects matching the specified
      pattern in the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc find myminio/mydata --name "*.jpg"

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] find                    \
                          [--exec "string"]       \
                          [--ignore "string"]     \
                          [--larger "string"]     \
                          [--maxdepth "string"]   \
                          [--name "string"]       \
                          [--newer-than "string"] \
                          [--older-than "string"] \
                          [--path "string"]       \
                          [--print "string"]      \
                          [--regex "string"]      \
                          [--smaller "string"]    \
                          [--watch]               \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* 
   
   For objects on  MinIO or an S3-compatible host, specify the  
   :ref:`alias <alias>` and the full path to search
   (e.g. bucket and prefixes). For example:

   .. code-block:: none

      mc find play/mydata/

   For objects on a filesyste, specify the full path to search. For 
   example:

   .. code-block:: shell

      mc find ~/mydata/

   Issuing :mc-cmd:`mc find ALIAS` with no other arguments returns a list of
   *all* objects or files at the specified path, similar to :mc-cmd:`mc ls`.

.. mc-cmd:: exec
   :option:
   
   *Optional* Spawns an external process for each object returned by 
   :mc:`mc find`. Supports :ref:`substitution formatting
   <mc-find-substitution-format>` of the output.

.. mc-cmd:: ignore
   :option:

   *Optional* Exclude objects whose names match the specified wildcard pattern.


.. mc-cmd:: larger
   :option:

   *Optional* Match all objects larger than the specified size in 
   :ref:`units <mc-find-units>`.

.. mc-cmd:: maxdepth
   :option:

   *Optional* Limits directory navigation to the specified depth.

.. mc-cmd:: name
   :option:

   *Optional* Return objects whose names match the specified wildcard pattern.

.. mc-cmd:: newer-than
   :option:

   *Optional* Mirror object(s) newer than the specified number of days.  Specify
   a string in ``#d#hh#mm#ss`` format. For example: ``--older-than 1d2hh3mm4ss``

.. mc-cmd:: older-than
   :option:

   *Optional* Mirror object(s) older than the specified time limit. Specify a
   string in ``#d#hh#mm#ss`` format. For example: ``--older-than 1d2hh3mm4ss``
      
   Defaults to ``0`` (all objects).

.. mc-cmd:: path
   :option:

   *Optional* Return the contents of directories whose names match the specified
   wildcard pattern.

.. mc-cmd:: print
   :option:

   *Optional* Prints results to ``STDOUT``.  Supports 
   :ref:`substitution formatting <mc-find-substitution-format>` of the output.

.. mc-cmd:: regex
   :option:

   *Optional* Returns objects or the contents of directories whose names match
   the specified PCRE regex pattern.

.. mc-cmd:: smaller
   :option:

   *Optional* Match all objects smaller than the specifized size in 
   :ref:`units <mc-find-units>`.

.. mc-cmd:: watch
   :option:

   *Optional* Continuously monitor the :mc-cmd:`~mc find ALIAS` and return any
   new objects which match the specified criteria.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Find a Specific Object in a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc find ALIAS/PATH --name NAME

- Replace :mc-cmd:`ALIAS <mc find ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc find ALIAS>` with the path to a bucket on the
  S3-compatible host. Omit the path to search from the root of the S3 host.

- Replace :mc-cmd:`NAME <mc find name>` with the object.

Find Objects with File Extention in Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc find ALIAS/PATH --name *.EXTENSION

- Replace :mc-cmd:`ALIAS <mc find ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc find ALIAS>` with the path to a bucket on the
  S3-compatible host.

- Replace :mc-cmd:`EXTENSION <mc find name>` with the file extention of the 
  object.

Find All Matching Files and Copy To S3 Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc find` with the :mc-cmd-option:`~mc find exec` option to find
files on a local filesystem and pass them to an :program:`mc` command for
further processing. The following example uses :mc:`mc cp` to copy the 
output of :mc:`mc find` to an S3-compatible host.

.. code-block:: shell
   :class: copyable

   mc find FILEPATH --name "*.EXTENSION" --exec "mc cp {} ALIAS/PATH"

- Replace :mc-cmd:`FILEPATH <mc find ALIAS>` with the full file path to the
  directory to search.

- Replace :mc-cmd:`EXTENSION <mc find name>` with the file extention of the 
  object.

- Replace :mc-cmd:`ALIAS <mc find ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc find ALIAS>` with the path to a bucket on the
  S3-compatible host.

To continuously watch the specified directory and copy new objects, 
include the :mc-cmd-option:`~mc find watch` argument:

.. code-block:: shell
   :class: copyable

   mc find --watch FILEPATH --name "*.EXTENSION" --exec "mc cp {} ALIAS/PATH"

Behavior
--------

.. _mc-find-units:

Units of Measurement
~~~~~~~~~~~~~~~~~~~~

The :mc-cmd-option:`mc find smaller` and :mc-cmd-option:`mc find larger` flags
accept the following case-insensitive suffixes to represent the unit of the
specified size value:

.. list-table::
   :header-rows: 1
   :widths: 20 80
   :width: 100%

   * - Suffix
     - Unit Size

   * - ``k``
     - KB (Kilobyte, 1000 Bytes)

   * - ``m``
     - MB (Megabyte, 1000 Kilobytes)

   * - ``g``
     - GB (Gigabyte, 1000 Megabytes)

   * - ``t``
     - TB (Terrabyte, 1000 Gigabytes)

   * - ``ki``
     - KiB (Kibibyte, 1024 Bites)

   * - ``mi``
     - MiB (Mebibyte, 1024 Kibibytes)

   * - ``gi``
     - GiB (Gibibyte, 1024 Mebibytes)

   * - ``ti``
     - TiB (Tebibyte, 1024 Gibibytes)

Omitting the suffix defaults to ``bytes``.


.. _mc-find-substitution-format:

Substitution Format
~~~~~~~~~~~~~~~~~~~

The :mc-cmd-option:`mc find exec` and :mc-cmd-option:`mc find print` commands
support string substitutions with special interpretations for following
keywords. 

The following keywords are supported for both filesystem and S3 service targets:

- ``{}`` - Substitutes to full path.
- ``{base}`` - Substitutes to basename of path.
- ``{dir}`` - Substitutes to dirname of the path.
- ``{size}`` - Substitutes to object size of the path.
- ``{time}`` - Substitutes to object modified time of the path.

The following keyword is supported only for S3 service targets:

- ``{url}`` - Substitutes to a shareable URL of the path.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
   