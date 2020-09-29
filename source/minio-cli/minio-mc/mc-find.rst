===========
``mc find``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc find

Description
-----------

.. start-mc-find-desc

The :mc:`mc find` command searches the specified paths using
the given criteria and returns only those objects that match the criteria.

.. end-mc-find-desc

Syntax
------

:mc:`~mc find` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc find PATH [FLAGS]

:mc:`~mc find` supports the following arguments:

.. mc-cmd:: PATH

   The full path to search. Specify the :mc:`~mc alias` of
   a configured S3 service as the prefix to the
   :mc-cmd:`~mc mirror PATH`. For example:

   .. code-block:: 

      mc find play/mybucket [FLAGS]

.. mc-cmd:: exec
   :option:
   
   Spawns an external process for each object returned by 
   :mc:`mc find`. Supports 
   :ref:`substitution formatting <mc-find-substitution-format>` of the
   output.

.. mc-cmd:: ignore
   :option:

   Exclude objects whose names match the specified wildcard pattern.

.. mc-cmd:: name
   :option:

   Return objects whose names match the specified wildcard pattern.

.. mc-cmd:: older
   :option:

   Mirror object(s) older than the specified time limit. Specify a string
   in ``#d#hh#mm#ss`` format. For example: ``--older-than 1d2hh3mm4ss``
      
   Defaults to ``0`` (all objects).

.. mc-cmd:: newer
   :option:

   Mirror object(s) newer than the specified number of days.  Specify a
   string in ``#d#hh#mm#ss`` format. For example: 
   ``--older-than 1d2hh3mm4ss``

.. mc-cmd:: path
   :option:

   Return the contents of directories whose names match the specified
   wildcard pattern.

.. mc-cmd:: print
   :option:

   Prints results to ``STDOUT``.  Supports 
   :ref:`substitution formatting <mc-find-substitution-format>` of the
   output.

.. mc-cmd:: regex
   :option:

   Returns objects or the contents of directories whose names match the
   specified PCRE regex pattern.

.. mc-cmd:: larger
   :option:

   Match all objects larger than the specified size in 
   :ref:`units <mc-find-units>`.

.. mc-cmd:: smaller
   :option:

   Match all objects smaller than the specifized size in
   :ref:`units <mc-find-units>`.

.. mc-cmd:: maxdepth
   :option:

   Limits directory navigation to the specified depth.

.. mc-cmd:: watch
   :option:

   Continuously monitor the :mc-cmd:`~mc find PATH` and return
   any new objects which match the specified criteria.

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

Examples
--------

Find All Objects with Specific File Extension
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc find play/bucket --name "*.jpg"

Find All Matching Objects and Copy To S3 Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc find ~/data/images/ --name "*.jpg" --exec "mc cp {} play/images/"

To continuously watch the specified directory and copy new objects, 
include the :mc-cmd-option:`~mc find watch` argument:

.. code-block:: shell
   :class: copyable

   mc find ~/data/images/ --name "*.jpg" --watch --exec "mc cp {} play/images/"

   