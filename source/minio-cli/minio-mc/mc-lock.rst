===========
``mc lock``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc lock

Description
-----------

.. start-mc-lock-desc

The :mc:`mc lock` command sets or gets the bucket default object lock
configuration. Object locking enables Write-Once Read-Many (WORM)
object retention for a configurable period of time.

.. end-mc-lock-desc

Use :mc:`mc retention` to set object lock settings on specific objects
in a bucket. :mc:`mc retention` overrides any bucket default lock
settings set using :mc:`mc lock`.

.. important::

   :mc:`mc lock` *requires* that the specified bucket has object locking
   enabled. You can **only** enable object locking at bucket creation.

   See :mc-cmd-option:`mc mb with-lock` for documentation on creating
   buckets with object locking enabled. 

Syntax
------

:mc:`~mc lock` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc lock TARGET COMMAND | MODE VALIDITY

:mc:`~mc lock` supports the following arguments:

.. mc-cmd:: TARGET

   *Required* The full path to the bucket for which to set or get the bucket
   default object lock configuration. Specify the :mc-cmd:`alias <mc alias>` of
   a configured S3-compatible service as the prefix to the ``TARGET`` bucket
   path. For example:

   .. code-block:: shell

      mc lock play/mybucket COMMAND | MODE VALIDITY

.. mc-cmd:: info

   Retrieves the current object lock configuation for the 
   :mc-cmd:`~mc lock TARGET` bucket.

   Mutually exclusive with :mc-cmd:`mc lock MODE`.

.. mc-cmd:: clear

   Unsets the current object lock configuration for the
   :mc-cmd:`~mc lock TARGET` bucket.

   Mutually exclusive with :mc-cmd:`mc lock MODE`.

.. mc-cmd:: MODE

   Sets the locking mode for the :mc-cmd:`~mc lock TARGET` bucket. Specify
   one of the following supported values:

   - ``governance``
   - ``compliance``

   See the AWS S3 documentation on :s3-docs:`Object Lock Overview
   <object-lock-overview.html>` for more information on the supported
   modes.

   Requires specifying :mc-cmd:`~mc lock VALIDITY`.

   Mutually exclusive with :mc-cmd:`mc lock info` and
   :mc-cmd:`mc lock clear`.

.. mc-cmd:: VALIDITY

   The duration which objects remain in the specified
   :mc-cmd:`~mc lock MODE` after creation.

   - For days, specify a string formatted as ``Nd``. For example,
     ``30d`` for 30 days after object creation.

   - For years, specify a string formatted as ``Ny``. For example, 
     ``1y`` for 1 year after object creation.

Behavior
--------

:mc:`mc lock` *requires* that the specified bucket has object locking
enabled. You can **only** enable object locking at bucket creation. See
:mc-cmd-option:`mc mb with-lock` for documentation on creating buckets with
object locking enabled. 

Interaction with Legal Holds
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports enabling a legal hold lock on objects. Enabling legal hold on an
object prevents any modification or deletion of the object.

An object with an active legal hold remains locked regardless of the :mc:`mc
lock` bucket configuration. Setting, modifying, or clearing the bucket default
object lock settings has no effect on objects under legal hold. Object lock
settings only apply after the legal hold is explicitly disabled. 

For more information on object legal holds, see :mc-cmd:`mc legalhold`.

Examples
--------

Get Bucket Object Lock Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

This example assumes that the specified bucket has object locking enabled. 
See :mc-cmd-option:`mc mb with-lock` for more information on creating buckets
with object locking enabled.

.. code-block:: shell
   :class: copyable

   mc legalhold play/mybucket info

Clear Bucket Object Lock Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

This example assumes that the specified bucket has object locking enabled. 
See :mc-cmd-option:`mc mb with-lock` for more information on creating buckets
with object locking enabled.

.. code-block:: shell
   :class: copyable

   mc legalhold play/mybucket clear

Set Bucket Object Lock Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

This example assumes that the specified bucket has object locking enabled. 
See :mc-cmd-option:`mc mb with-lock` for more information on creating buckets
with object locking enabled.

.. code-block:: shell
   :class: copyable

   mc legalhold play/mybucket governance 30d