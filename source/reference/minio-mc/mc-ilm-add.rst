.. _minio-mc-ilm-add:

==============
``mc ilm add``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm add

Syntax
------

.. start-mc-ilm-add-desc

The :mc:`mc ilm add` command adds an object lifecycle management rule to a
bucket.

.. end-mc-ilm-add-desc

The command supports adding both 
:ref:`Transition (Tiering) <minio-lifecycle-management-tiering>` and
:ref:`Expiration <minio-lifecycle-management-expiration>` lifecycle management
rules.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command adds new lifecycle management rules to the
      ``mydata`` bucket on the ``myminio`` deployment:

      .. code-block:: shell
         :class: copyable

         mc ilm add --expiry-days 90 --noncurrentversion-expiry-days 30  mydata/myminio
         
         mc ilm add --expired-object-delete-marker mydata/myminio

         mc ilm add --transition-days 30 --storage-class "COLDTIER" mydata/myminio
         
         mc ilm add --noncurrentversion-transition-days 7 --noncurrent-version-transition-storage-class "COLDTIER" 

      The configured rules have the following effect:

      - Delete objects more than 90 days old
      - Delete objects 30 days after they become non-current
      - Delete ``DeleteMarker`` tombstones if that object has no other versions 
        remaining.
      - Transition objects more than 30 days old to the ``COLDTIER`` remote 
        tier.
      - Transition objects 7 days after they become non-current to the 
        ``COLDTIER`` remote tier.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] ilm add \
                          --expiry-days "string" | --expired-object-delete-marker                                              \
                          --transition-days "string" --storage-class "string"                                                  \
                          [--noncurrentversion-expiration-days "string"]                                                       \
                          [--noncurrentversion-transition-days "string" --noncurrentversion-transition-storage-class "string"] \
                          [--tags]                                                                                             \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   
   *Required* The :ref:`alias <alias>` and full path to the bucket on the MinIO
   deployment to which to add the object lifecycle management rule. For example:

   .. code-block:: none

      mc ilm add myminio/mydata

   To restrict the management rule to a specific bucket prefix, specify that
   prefix as part of the ``ALIAS``. For example:

   .. code-block:: none

      mc ilm add myminio/mydata/someprefix

.. mc-cmd:: expiry-days
   :option:

   *Required* The number of days to retain an object after being created. MinIO
   marks the object for deletion after the specified number of days pass. 
   Specify the number of days as an integer, e.g. ``30`` for 30 days.

   For versioned buckets, the expiry rule applies only to the *current*
   object version. Use the 
   :mc-cmd-option:`~mc ilm add noncurrentversion-expiration-days` option
   to apply expiration behavior to noncurrent object versions.

   MinIO uses a scanner process to check objects against all configured
   lifecycle management rules. Slow scanning due to high IO workloads or
   limited system resources may delay application of lifecycle management
   rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   Mutually exclusive with the following options:

   - :mc-cmd-option:`~mc ilm add expired-object-delete-marker`

   For more complete documentation on object expiration, see
   :ref:`minio-lifecycle-management-expiration`.

.. mc-cmd:: expired-object-delete-marker
   :option:

   *Required* Specify this option to direct MinIO to remove delete markers for
   objects with no remaining object versions. Specifically, the delete
   marker is the *only* remaining "version" of the given object.

   This option is mutually exclusive with the following option:
   
   - :mc-cmd-option:`~mc ilm add tags`
   - :mc-cmd-option:`~mc ilm add expiry-days`

   MinIO uses a scanner process to check objects against all configured
   lifecycle management rules. Slow scanning due to high IO workloads or
   limited system resources may delay application of lifecycle management
   rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   For more complete documentation on object expiration, see
   :ref:`minio-lifecycle-management-expiration`.

.. mc-cmd:: transition-days
   :option:

   *Required* The number of calendar days from object creation after which MinIO
   marks an object as eligible for transition. MinIO transitions the object to
   the configured remote storage tier specified to the 
   :mc-cmd-option:`~mc ilm add storage-class`. Specify the number of days as an 
   integer, e.g. ``30`` for 30 days.

   For versioned buckets, the transition rule applies only to the *current*
   object version. Use the 
   :mc-cmd-option:`~mc ilm add noncurrentversion-transition-days` option
   to apply transition behavior to noncurrent object versions.

   Requires specifying :mc-cmd-option:`~mc ilm add storage-class`.

   MinIO uses a scanner process to check objects against all configured
   lifecycle management rules. Slow scanning due to high IO workloads or
   limited system resources may delay application of lifecycle management
   rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   For more complete documentation on object transition, see
   :ref:`minio-lifecycle-management-tiering`.

.. mc-cmd:: storage-class
   :option:

   *Required* The remote storage tier to which MinIO 
   :ref:`transition objects <minio-lifecycle-management-tiering>`.
   Specify a remote storage tier created by :mc-cmd:`mc admin tier`. 

   Required if specifying :mc-cmd-option:`~mc ilm add transition-days`.

.. mc-cmd:: tags
   :option:

   *Optional* One or more ampersand ``&``-delimited key-value pairs describing
   the object tags to use for filtering objects to which the lifecycle
   configuration rule applies.

   This option is mutually exclusive with the following option:

   - :mc-cmd-option:`~mc ilm add expired-object-delete-marker`

.. mc-cmd:: noncurrentversion-expiration-days
   :option:

   *Optional* The number of days to retain an object version after becoming
   *non-current* (i.e. a different version of that object is now the `HEAD`).
   MinIO marks noncurrent object versions for deletion after the specified
   number of days pass.

   This option has the same behavior as the 
   S3 ``NoncurrentVersionExpiration`` action.

   MinIO uses a scanner process to check objects against all configured
   lifecycle management rules. Slow scanning due to high IO workloads or
   limited system resources may delay application of lifecycle management
   rules. See :ref:`minio-lifecycle-management-scanner` for more information.

.. mc-cmd:: noncurrentversion-transition-days
   :option:

   *Optional* The number of days an object has been non-current (i.e. replaced
   by a newer version of that same object) after which MinIO marks the object
   version as eligible for transition. MinIO transitions the object to the
   configured remote storage tier specified to the 
   :mc-cmd-option:`~mc ilm add storage-class` once the system host datetime
   passes that calendar date.

   This option has no effect on non-versioned buckets. Requires specifying
   :mc-cmd-option:`~mc ilm add noncurrentversion-transition-storage-class`.

   This option has the same behavior as the 
   S3 ``NoncurrentVersionTransition`` action.

   MinIO uses a scanner process to check objects against all configured
   lifecycle management rules. Slow scanning due to high IO workloads or
   limited system resources may delay application of lifecycle management
   rules. See :ref:`minio-lifecycle-management-scanner` for more information.

.. mc-cmd:: noncurrentversion-transition-storage-class
   :option:

   *Optional* The remote storage tier to which MinIO 
   :ref:`transitions noncurrent objects versions
   <minio-lifecycle-management-tiering>`. Specify a remote storage tier created
   by :mc-cmd:`mc admin tier`.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Expire Bucket Contents After Number of Days
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc ilm add` with :mc-cmd-option:`~mc ilm add expiry-days` to
expire bucket contents a number of days after object creation:

.. code-block:: shell
   :class: copyable

   mc ilm add ALIAS/PATH --expiry-days "DAYS" 

- Replace :mc-cmd:`ALIAS <mc ilm add ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm add ALIAS>` with the path to the bucket on the
  S3-compatible host.

- Replace :mc-cmd:`DATE <mc ilm add expiry-days>` with the number of days after
  which to expire the object. For example, specify ``30`` to expire the
  object 30 days after creation.

Behavior
--------

Lifecycle Management Object Scanner
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO uses a scanner process to check objects against all configured
lifecycle management rules. Slow scanning due to high IO workloads or
limited system resources may delay application of lifecycle management
rules. See :ref:`minio-lifecycle-management-scanner` for more information.

Expiry vs Transition
~~~~~~~~~~~~~~~~~~~~

MinIO supports specifying both expiry and transition rules in the same
bucket or bucket prefix. MinIO can execute an expiration rule on an object
regardless of its transition status. Use
:mc-cmd:`mc ilm ls` to review the currently configured object lifecycle
management rules for any potential interactions between expiry and transition
rules.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
