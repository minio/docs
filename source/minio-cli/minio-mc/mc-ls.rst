=========
``mc ls``
=========

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 1

.. mc:: mc ls

Description
-----------

.. start-mc-ls-desc

The :mc:`mc ls` command lists all buckets and objects on the target
S3-compatible service. For targets on a filesystem, :mc:`mc ls` has the same
functionality as the ``ls`` command.

.. end-mc-ls-desc

Quick Reference
---------------

:mc-cmd:`mc ls play/mybucket <mc ls TARGET>`
   Lists the contents of the ``mybucket`` bucket. ``play`` corresponds to the
   :mc-cmd:`alias <mc alias>` of a configured S3-compatible service.

:mc-cmd:`mc ls --recursive play <mc ls recursive>`
   Recursively lists all buckets and objects on the S3-compatible service.
   ``play`` corresponds to the :mc-cmd:`alias <mc alias>` of a configured
   S3-compatible service.

:mc-cmd:`mc ls --versions play/myversionedbucket <mc ls versions>`
   Lists the version of all objects in the ``myversionbucket`` bucket. ``play``
   corresponds to the :mc-cmd:`alias <mc alias>` of a configured S3-compatible
   service.

   :mc-cmd-option:`mc ls versions` requires :ref:`bucket versioning
   <minio-bucket-versioning>`. Use :mc:`mc version` to enable versioning
   on a bucket.

:mc-cmd:`mc ls --rewind 7d play/myversionedbucket <mc ls versions>`
   Lists the contents of the ``myversionedbucket`` bucket as they
   existed 7 days prior to the current date. ``play`` corresponds to the
   :mc-cmd:`alias <mc alias>` of a configured S3-compatible service.

   :mc-cmd-option:`mc ls versions` requires :ref:`bucket versioning
   <minio-bucket-versioning>`. Use :mc:`mc version` to enable versioning
   on a bucket.

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
   :fullpath:

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