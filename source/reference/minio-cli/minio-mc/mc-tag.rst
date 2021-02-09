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

Examples
--------

Apply Tags to a Bucket or Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc tag set` to apply tags to a bucket or object:

.. code-block:: shell
   :class: copyable

   mc tag set ALIAS/PATH "TAGS"

- Replace :mc-cmd:`ALIAS <mc tag set TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc tag set TARGET>` with the path to the bucket
  or object on the S3-compatible host.

- Replace :mc-cmd:`TAGS <mc tag set TAGS>` with one or more comma-separated
  key-value pairs for each tag and its corresponding value.

Remove Tags from a Bucket or Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc tag remove` to remove all tags from a bucket or object:

.. code-block:: shell
   :class: copyable

   mc tag remove ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc tag remove TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc tag remove TARGET>` with the path to the bucket
  or object on the S3-compatible host.

List Tags for a Bucket or Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc tag list` to retrieve all tags for a bucket or object:

.. code-block:: shell
   :class: copyable

   mc tag list ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc tag list TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc tag list TARGET>` with the path to the bucket
  or object on the S3-compatible host.

Syntax
------

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
      of a configured S3-compatible service as the prefix to the 
      :mc-cmd:`~mc tag set TARGET` path. For example:

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

      Use :mc-cmd-option:`~mc tag set versions` and 
      :mc-cmd-option:`~mc tag set rewind` together to apply the tag all object
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
      service as the prefix to the :mc-cmd:`~mc tag remove TARGET` path. For 
      example:

      .. code-block:: shell

         mc version remove play/mybucket

   .. mc-cmd:: versions
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-versions-desc-2
         :end-before: end-versions-desc-2

      Use :mc-cmd-option:`~mc tag remove versions` and 
      :mc-cmd-option:`~mc tag remove rewind` together to remove the tag from 
      object versions which existed at a specific point in time.

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
      configured S3-compatible service as the prefix to the 
      :mc-cmd:`~mc tag list TARGET` path. For example:

      .. code-block:: shell

         mc version <CMD> play/mybucket

   .. mc-cmd:: versions
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-versions-desc-3
         :end-before: end-versions-desc-3

      Use :mc-cmd-option:`~mc tag list versions` and 
      :mc-cmd-option:`~mc tag list rewind` together to list all tags applied to
      all object versions which existed at a specific point in time.

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
