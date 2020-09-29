==========
``mc tag``
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc tag

Description
-----------

.. start-mc-tag-desc

The :mc:`mc tag` command adds, removes, and lists the tags associated to a
bucket or object.

.. end-mc-tag-desc.

Quick Reference
---------------

:mc-cmd:`mc tag set play/mybucket/myobject.csv "tag1=value1,tag2=value2" <mc tag set>`
   Applies the tags ``tag1`` and ``tag2`` and their corresponding values to 
   the ``myobject.csv`` object in the ``mybucket`` bucket. ``play`` 
   corresponds to the :mc-cmd:`alias <mc alias>` of a configured S3-compatible
   service.

:mc-cmd:`mc tag remove play/mybucket/myobject.csv <mc tag remove>`
   Removes all tags assigned to the ``myobject.csv`` bucket. ``play`` 
   corresponds to the :mc-cmd:`alias <mc alias>` of a configured S3-compatible
   service.

:mc-cmd:`mc tag info play/mybucket/myobject.csv <mc tag info>`
   Retrieves the tags assigned to the ``myobject.csv`` bucket. ``play`` 
   corresponds to the :mc-cmd:`alias <mc alias>` of a configured S3-compatible
   service.

Syntax
------

.. code-block:: shell

   mc tag COMMAND

:mc:`mc tag` supports the following commands:

.. |command| replace:: :mc-cmd:`mc tag set`
.. |rewind| replace:: :mc-cmd-option:`~mc tag set rewind`
.. |versions| replace:: :mc-cmd-option:`~mc tag set versions`
.. |versionid| replace:: :mc-cmd-option:`~mc tag set version-id`
.. |alias| replace:: :mc-cmd-option:`~mc tag set TARGET`

.. mc-cmd:: set
   :fullpath:

   Sets the tags for a bucket or object. :mc-cmd:`mc tag set`
   overwrites any existing tags on the bucket or object. 
   
   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc tag set [FLAGS] TARGET "TAG1=VALUE1,[TAG2=VALUE2]"

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      **Required** The full path to the bucket or object to which to set the
      :mc-cmd-option:`~mc tag set TAGS`. Specify the :mc-cmd:`alias <mc alias>`
      of a configured S3-compatible service as the prefix to the :mc-cmd:`~mc
      tag TARGET` path. For example:

      .. code-block:: shell

         mc version set play/mybucket

   .. mc-cmd:: TAGS

      One or more comma-separated key-value pairs, where each pair describes a
      single tag.

   .. mc-cmd:: versions
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-versions-desc
         :end-before: end-versions-desc

      Use :mc-cmd-option:`~mc rm versions` and 
      :mc-cmd-option:`~mc rm rewind` together to apply the tag all object
      versions which existed at a specific point in time.

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

.. |command-2| replace:: :mc-cmd:`mc tag remove`
.. |versions-2| replace:: :mc-cmd-option:`~mc tag remove versions`
.. |rewind-2| replace:: :mc-cmd-option:`~mc tag remove rewind`
.. |versionid-2| replace:: :mc-cmd-option:`~mc tag remove version-id`
.. |alias-2| replace:: :mc-cmd-option:`~mc tag remove TARGET`

.. mc-cmd:: remove
   :fullpath:

   Removes *all* tags from a bucket or object.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc tag remove [FLAGS] TARGET

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      **Required** The full path to the bucket or object from which to remove
      tags. Specify the :mc-cmd:`alias <mc alias>` of a configured S3-compatible
      service as the prefix to the :mc-cmd:`~mc tag TARGET` path. For example:

      .. code-block:: shell

         mc version remove play/mybucket

   .. mc-cmd:: versions
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-versions-desc-2
         :end-before: end-versions-desc-2

      Use :mc-cmd-option:`~mc rm versions` and 
      :mc-cmd-option:`~mc rm rewind` together to apply the tag all object
      versions which existed at a specific point in time.

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


.. |command-3| replace:: :mc-cmd:`mc tag list`
.. |versions-3| replace:: :mc-cmd-option:`~mc tag list versions`
.. |rewind-3| replace:: :mc-cmd-option:`~mc tag list rewind`
.. |versionid-3| replace:: :mc-cmd-option:`~mc tag list version-id`
.. |alias-3| replace:: :mc-cmd-option:`~mc tag list TARGET`

.. mc-cmd:: list
   :fullpath:

   Lists the tags assigned to a bucket or object.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc tag <CMD> [FLAGS] TARGET

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      **Required** The full path to the bucket or object for which the command
      lists tags. Specify the :mc-cmd:`alias <mc alias>` of a
      configured S3-compatible service as the prefix to the :mc-cmd:`~mc tag
      TARGET` path. For example:

      .. code-block:: shell

         mc version <CMD> play/mybucket

   .. mc-cmd:: versions
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-versions-desc-3
         :end-before: end-versions-desc-3

      Use :mc-cmd-option:`~mc rm versions` and 
      :mc-cmd-option:`~mc rm rewind` together to apply the tag all object
      versions which existed at a specific point in time.

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
