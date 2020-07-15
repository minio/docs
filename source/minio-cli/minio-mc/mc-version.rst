==============
``mc version``
==============

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 1

.. mc:: mc version

Description
-----------

.. start-mc-version-desc

The :mc:`mc version` command enables or disables bucket versioning. 

.. end-mc-version-desc

.. note::

   The :release:`RELEASE.2020-08-08T02-33-58Z` release renamed 
   ``mc versioning`` to :mc:`mc version`.
   

Syntax
------

:mc:`~mc version` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc version TARGET COMMAND

:mc:`~mc version` supports the following arguments:

.. mc-cmd:: TARGET

   **Required** The full path to the bucket on which to enable or 
   disable bucket versioning. Specify the 
   :command:`alias <mc alias>` of a configured S3-compatible service as the
   prefix to the :mc-cmd:`~mc version TARGET` path. For example:

   .. code-block:: shell

      mc version play/mybucket COMMAND

.. mc-cmd:: enable

   The :mc-cmd:`mc version TARGET enable <mc version enable>` command
   enables bucket versioning on the :mc-cmd:`~mc version TARGET` bucket.

.. mc-cmd:: suspend

   The :mc-cmd:`mc version TARGET suspend <mc version suspend>` command
   disables bucket versioning on the :mc-cmd:`~mc version TARGET` bucket.

.. mc-cmd:: info

   The :mc-cmd:`mc version TARGET info <mc version info>` command
   returns the current bucket versioning configuration.
   

Behavior
--------

Object Locking Enables Bucket Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While bucket versioning is disabled by default, configuring
object locking on a bucket or an object in that bucket automatically
enables versioning for the bucket. See 
:mc:`mc lock` for more information on configuring object locking.

Requires Erasure Coding
~~~~~~~~~~~~~~~~~~~~~~~

Bucket versioning requires that the MinIO deployment supports erasure coding.
See <erasure coding link> for more information.

Bucket Versioning with Existing Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enabling bucket versioning on a bucket with existing data immediately applies
a versioning ID to any unversioned object.

Disabling bucket versioning on a bucket with existing versioned data does
*not* remove any versioned objects. Applications can continue to access
versioned data after disabling bucket versioning. Use 
:mc:`mc rm` to delete an object *and* all its versions.

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