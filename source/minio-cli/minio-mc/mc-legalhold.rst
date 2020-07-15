================
``mc legalhold``
================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 1

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

Syntax
------

:mc:`~mc legalhold` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc legalhold [FLAGS] TARGET [ ON | OFF ]

:mc:`~mc legalhold` supports the following arguments:

.. mc-cmd:: TARGET

   *Required* The full path to the object or bucket on which to enable or
   disable the legal hold. Specify the :mc-cmd:`alias <mc alias>` 
   of a configured S3 service as the prefix to the ``TARGET`` path. For example:

   .. code-block:: shell

      mc legalhold play/mybucket

   You can specify a bucket prefix to apply the legal hold to only objects
   in the specified prefix. For example:

   .. code-block:: shell

      mc legalhold play/mybucket/mydata

   If you specify a path to a bucket or bucket prefix, you must also specify 
   :mc-cmd-option:`mc legalhold recursive`.

.. mc-cmd:: recursive, r

   Applies the legal hold recursively to all objects in the
   :mc-cmd:`~mc legalhold TARGET` bucket.

.. mc-cmd:: ACTION

   *Required* 
   
   Specify ``ON`` to enable legal hold on the :mc-cmd:`~mc legalhold TARGET` 
   path.

   Specify ``OFF`` to disable legal hold on the :mc-cmd:`~mc legalhold TARGET` 
   path.

Behavior
--------

:mc:`mc legalhold` *requires* that the specified bucket has object locking
enabled. You can **only** enable object locking at bucket creation. See
:mc-cmd-option:`mc mb with-lock` for documentation on creating buckets with
object locking enabled. 

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

   mc legalhold --recursive play/mybucket ON

Enable Legal Hold on an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

This example assumes that the specified bucket has object locking enabled. 
See :mc-cmd-option:`mc mb with-lock` for more information on creating buckets
with object locking enabled.

.. code-block:: shell

   mc legalhold --recursive play/mybucket/myobject.csv ON

