================
``mc legalhold``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc legalhold

Description
-----------

.. start-mc-legalhold-desc

The :mc:`mc legalhold` command enables or disables object legal hold. 
Enabling legal hold on an object prevents any modification or deletion
of the object and is equivalent to setting Write-Once Read-Only (WORM) 
mode on the object.

.. end-mc-legalhold-desc

.. important::

   :mc:`mc legalhold` *requires* that the specified bucket has object locking
   enabled. You can **only** enable object locking at bucket creation.

   See :mc-cmd-option:`mc mb with-lock` for documentation on creating
   buckets with object locking enabled. 

Quick Reference
---------------

:mc-cmd:`mc legalhold set play/mybucket/myobject.txt <mc legalhold set>`
   Enables legalhold on the ``myobject.txt`` object in the ``mybucket`` bucket.
   ``play`` corresponds to the :mc-cmd:`alias <mc alias>` of a configured
   S3-compatible service.

:mc-cmd:`mc legalhold set --recursive play/mybucket <mc legalhold set recursive>`
   Recursively enables legalhold on the contents of the ``mybucket`` bucket.
   ``play`` corresponds to the :mc-cmd:`alias <mc alias>` of a configured
   S3-compatible service.

:mc-cmd:`mc legalhold set --rewind "30d" --recursive play/mybucket <mc legalhold set rewind>`
   Recursively enables legalhold on the contents of the ``mybucket`` bucket 
   as they existed 30 days prior to the current date. ``play`` corresponds 
   to the :mc-cmd:`alias <mc alias>` of a configured S3-compatible service.

   :mc-cmd-option:`mc legalhold set rewind` requires :ref:`bucket versioning
   <minio-bucket-versioning>`. Use :mc:`mc version` to enable versioning
   on a bucket.

:mc-cmd:`mc legalhold clear play/mybucket/myobject.txt <mc legalhold clear>`
   Removes legalhold on the ``myobject.txt`` object in the ``mybucket``
   bucket. ``play`` corresponds to the :mc-cmd:`alias <mc alias>` of a 
   configured S3-compatible service.

:mc-cmd:`mc legalhold info play/mybucket/myobject.txt <mc legalhold info>`
   Retrieves the legalhold status of the ``myobject.txt`` object in the
   ``mybucket`` bucket. ``play`` corresponds to the :mc-cmd:`alias <mc alias>`
   of a configured S3-compatible service.

Syntax
------

.. code-block:: shell
   :class: copyable

   mc legalhold COMMAND

:mc:`~mc legalhold` supports the following commands:

.. replacements for mc legalhold set

.. |command| replace:: :mc-cmd:`mc legalhold set`
.. |rewind| replace:: :mc-cmd-option:`~mc legalhold info rewind`
.. |versionid| replace:: :mc-cmd-option:`~mc legalhold set version-id`
.. |alias| replace:: :mc-cmd-option:`~mc legalhold set TARGET`

.. mc-cmd:: set
   :fullpath:

   Enables legal hold on an object or object(s). 

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc legalhold set [FLAGS] TARGET

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the object or bucket on which to enable
      the legal hold. Specify the :mc-cmd:`alias <mc alias>` of a configured
      S3-compatible service as the prefix to the ``TARGET`` path. For example:

      .. code-block::

         mc legalhold set play/mybucket/myobject.txt

      If you specify a path to a bucket or bucket prefix, you must also
      specify :mc-cmd-option:`mc legalhold set recursive`.

   .. mc-cmd:: recursive, r
      :option:

      Applies the legal hold to all objects in the 
      :mc-cmd:`~mc legalhold set TARGET` bucket or bucket prefix.

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

.. replacements for mc legalhold clear

.. |command-2| replace:: :mc-cmd:`mc legalhold clear`
.. |rewind-2| replace:: :mc-cmd-option:`~mc legalhold clear rewind`
.. |versionid-2| replace:: :mc-cmd-option:`~mc legalhold clear version-id`
.. |alias-2| replace:: :mc-cmd-option:`~mc legalhold clear TARGET`

.. mc-cmd:: clear

   Removes legal hold on an object or object(s). 

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc legalhold clear [FLAGS] TARGET

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the object or bucket on which to remove
      the legal hold. Specify the :mc-cmd:`alias <mc alias>` of a configured
      S3-compatible service as the prefix to the ``TARGET`` path. For example:

      .. code-block::

         mc legalhold set play/mybucket/myobject.txt

      If you specify a path to a bucket or bucket prefix, you must also
      specify :mc-cmd-option:`mc legalhold set recursive`.

   .. mc-cmd:: recursive, r
      :option:

      Removes the legal hold from all objects in the 
      :mc-cmd:`~mc legalhold set TARGET` bucket or bucket prefix.

   .. mc-cmd:: rewind
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-rewind-desc-2
         :end-before: end-rewind-desc-2

   .. mc-cmd:: version-id, vid
      :option:
   
      .. include:: /includes/facts-versioning.rst
         :start-after: start-version-id-desc-2
         :end-before: end-version-id-desc-2

.. replacements for mc legalhold info

.. |command-3| replace:: :mc-cmd:`mc legalhold info`
.. |rewind-3| replace:: :mc-cmd-option:`~mc legalhold info rewind`
.. |versionid-3| replace:: :mc-cmd-option:`~mc legalhold info version-id`
.. |alias-3| replace:: :mc-cmd-option:`~mc legalhold info TARGET`

.. mc-cmd:: info

   Retrieves the legal hold status of an object or object(s). 

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc legalhold info [FLAGS] TARGET

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the object or bucket on which to retrieve
      the legal hold status. Specify the :mc-cmd:`alias <mc alias>` of a configured
      S3-compatible service as the prefix to the ``TARGET`` path. For example:

      .. code-block::

         mc legalhold set play/mybucket/myobject.txt

      If you specify a path to a bucket or bucket prefix, you must also
      specify :mc-cmd-option:`mc legalhold set recursive`.

   .. mc-cmd:: recursive, r
      :option:

      Retrieves the legal hold from all objects in the 
      :mc-cmd:`~mc legalhold set TARGET` bucket or bucket prefix.

   .. mc-cmd:: rewind
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-rewind-desc-3
         :end-before: end-rewind-desc-3

   .. mc-cmd:: version-id, vid
      :option:
   
      .. include:: /includes/facts-versioning.rst
         :start-after: start-version-id-desc-3
         :end-before: end-version-id-desc-3

Examples
--------

Enable Legal Hold on Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

This example assumes that the specified bucket has object locking enabled. 
See :mc-cmd-option:`mc mb with-lock` for more information on creating buckets
with object locking enabled.

.. code-block:: shell

   mc legalhold set --recursive play/mybucket

Enable Legal Hold on an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

This example assumes that the specified bucket has object locking enabled. 
See :mc-cmd-option:`mc mb with-lock` for more information on creating buckets
with object locking enabled.

.. code-block:: shell

   mc legalhold set play/mybucket/myobject.csv

