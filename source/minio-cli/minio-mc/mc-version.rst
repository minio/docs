==============
``mc version``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc version

Description
-----------

.. start-mc-version-desc

The :mc:`mc version` command enables or disables bucket versioning. 

.. end-mc-version-desc

Object Locking Enables Bucket Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While bucket versioning is disabled by default, configuring
object locking on a bucket or an object in that bucket automatically
enables versioning for the bucket. See 
:mc:`mc lock` for more information on configuring object locking.

Bucket Versioning Requires Erasure Coding
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Bucket versioning requires that the MinIO deployment supports erasure coding.
See <erasure coding link> for more information.

Bucket Versioning with Existing Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enabling bucket versioning on a bucket with existing data immediately applies
a versioning ID to any unversioned object.

Disabling bucket versioning on a bucket with existing versioned data does
*not* remove any versioned objects. Applications can continue to access
versioned data after disabling bucket versioning. Use 
:mc-cmd:`mc rm --versions ALIAS/BUCKET/OBJECT <mc rm versions>` to delete an 
object *and* all its versions.

Quick Reference
---------------

:mc-cmd:`mc version enable play/mybucket <mc version enable>`
   Enables bucket versioning on the ``mybucket`` bucket. ``play``
   corresponds to the :mc-cmd:`alias <mc alias>` of a configured
   S3-compatible service.

:mc-cmd:`mc version disable play/mybucket <mc version disable>`
   Disables bucket versioning on the ``mybucket`` bucket. ``play``
   corresponds to the :mc-cmd:`alias <mc alias>` of a configured
   S3-compatible service.


:mc-cmd:`mc version info play/mybucket <mc version info>`
   Retrieves the bucket versioning status of the ``mybucket`` bucket. ``play``
   corresponds to the :mc-cmd:`alias <mc alias>` of a configured
   S3-compatible service.


Syntax
------

.. code-block:: shell
   
   mc version COMMAND

:mc:`~mc version` supports the following commands:

.. mc-cmd:: enable
   :fullpath:

   Enables bucket versioning on the specified bucket.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc version enable TARGET

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      **Required** The full path to the bucket on which to enable bucket
      versioning. Specify the :command:`alias <mc alias>` of a configured
      S3-compatible service as the prefix to the :mc-cmd:`~mc version TARGET`
      path. For example:

      .. code-block:: shell

         mc version enable play/mybucket

.. mc-cmd:: disable
   :fullpath:

   Disables bucket versioning on the specified bucket. 

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc version disable TARGET

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      **Required** The full path to the bucket on which to disable bucket
      versioning. Specify the :command:`alias <mc alias>` of a configured
      S3-compatible service as the prefix to the :mc-cmd:`~mc version TARGET`
      path. For example:

      .. code-block:: shell

         mc version disable play/mybucket

.. mc-cmd:: info
   :fullpath:

   Retrieves the bucket versioning status for the specified bucket. 

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc version info TARGET

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      **Required** The full path to the bucket on which to retrieve the bucket
      versioning status. Specify the :command:`alias <mc alias>` of a configured
      S3-compatible service as the prefix to the :mc-cmd:`~mc version TARGET`
      path. For example:

      .. code-block:: shell

         mc version info play/mybucket

Examples
--------

Enable Bucket Versioning
~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc version play/mybucket enable

Disable Bucket Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc version play/mybucket suspend