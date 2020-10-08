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

Examples
--------

Enable Legal Hold On Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc legalhold set` to enable legal hold on objects:

.. code-block:: shell
   :class: copyable

   mc legalhold set [--recursive] ALIAS/PATH 

- Replace :mc-cmd:`ALIAS <mc legalhold set TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc legalhold set TARGET>` with the path to the bucket
  or object on the S3-compatible host. If specifying the path to a bucket,
  include the :mc-cmd-option:`~mc legalhold set recursive` option.

Remove Legal Hold From Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc legalhold clear` to remove legal hold on objects:

.. code-block:: shell
   :class: copyable

   mc legalhold clear [--recursive] ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc legalhold clear TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc legalhold clear TARGET>` with the path to the bucket
  or object on the S3-compatible host. If specifying the path to a bucket,
  include the :mc-cmd-option:`~mc legahold clear recursive` option.

Retrieve the Legal Hold Status Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc legalhold info` to retrieve the legal hold status of an object.
Include :mc-cmd-option:`~mc legalhold info recursive` to return the legal hold
status of the contents of a bucket:

.. code-block:: shell
   :class: copyable

   mc legalhold clear [--recursive] ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc legalhold clear TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc legalhold clear TARGET>` with the path to the object
  or bucket on the S3-compatible host. If specifying the path to a bucket,
  include the :mc-cmd-option:`~mc legalhold info recursive` option.

Syntax
------

.. replacements for mc legalhold set

.. |command| replace:: :mc-cmd:`mc legalhold set`
.. |rewind| replace:: :mc-cmd-option:`~mc legalhold set rewind`
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

      *Required* 
      
      The full path to the object or bucket on which to enable
      the legal hold. Specify the :mc-cmd:`alias <mc alias>` of a configured
      S3-compatible service as the prefix to the ``TARGET`` path. For example:

      .. code-block:: shell

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

