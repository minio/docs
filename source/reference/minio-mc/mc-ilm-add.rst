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

The :mc:`mc ilm add` command adds an object lifecycle management rule to a bucket.

.. end-mc-ilm-add-desc

The command supports adding both :ref:`Transition (Tiering) <minio-lifecycle-management-tiering>` and :ref:`Expiration <minio-lifecycle-management-expiration>` lifecycle management rules.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command adds new lifecycle management rules to the ``mydata`` bucket on the ``myminio`` deployment:

      .. code-block:: shell
         :class: copyable

         mc ilm add --expiry-days 90 --noncurrentversion-expiry-days 30  mydata/myminio
         
         mc ilm add --expired-object-delete-marker mydata/myminio

         mc ilm add --transition-days 30 --tier "COLDTIER" mydata/myminio
         
         mc ilm add --noncurrentversion-transition-days 7 --noncurrent-version-transition-tier "COLDTIER" 

      The configured rules have the following effect:

      - Delete objects more than 90 days old
      - Delete objects 30 days after they become non-current
      - Delete ``DeleteMarker`` tombstones if that object has no other versions remaining.
      - Transition objects more than 30 days old to the ``COLDTIER`` remote tier.
      - Transition objects 7 days after they become non-current to the ``COLDTIER`` remote tier.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] ilm add                                             \
                          --expiry-days "integer"                             \
                          [--prefix string]                                   \
                          [--tags string]                                            \
                          [--transition-days "string"]                       \
                          [--tier "string"]                                   \
                          [--expired-object-delete-marker]                    \
                          [--noncurrentversion-expiration-days "integer"]     \
                          [--noncurrentversion-transition-days "integer"]     \
                          [--noncurrentversion-tier "string"]                 \
                          [--newer-noncurrentversions-expiration "integer"]   \
                          [--newer-noncurrentversions-transition "integer"]   \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:
   
   The :ref:`alias <alias>` and bucket on the MinIO deployment to which to add the object lifecycle management rule. 
   
   For example:

   .. code-block:: none

      mc ilm add myminio/mydata

.. mc-cmd:: --prefix
   :optional:
   
   Restrict the management rule to a specific bucket prefix.
   
   For example:

   .. code-block:: none

      mc ilm add --prefix "meetingnotes/" myminio/mydata/ --expiry-days "90"

   The command creates a rule that expires objects in the ``mydata`` bucket of the ``myminio`` ALIAS after 90 days for any object with the ``meetingnotes/`` prefix.

.. mc-cmd:: --expiry-days
   :required:   

   The number of days to retain an object after being created. 
   MinIO marks the object for deletion after the specified number of days pass. 
   Specify the number of days as an integer, e.g. ``30`` for 30 days.

   For versioned buckets, the expiry rule applies only to the *current* object version. 
   Use the :mc-cmd:`~mc ilm add --noncurrentversion-expiration-days` option to apply expiration behavior to noncurrent object versions.

   MinIO uses a scanner process to check objects against all configured lifecycle management rules. 
   Slow scanning due to high IO workloads or limited system resources may delay application of lifecycle management rules. 
   See :ref:`minio-lifecycle-management-scanner` for more information.

   Mutually exclusive with the following options:

   - :mc-cmd:`~mc ilm add --expired-object-delete-marker`

   For more complete documentation on object expiration, see :ref:`minio-lifecycle-management-expiration`.

.. mc-cmd:: --expired-object-delete-marker
   :optional:

   Specify this option to direct MinIO to remove delete markers for objects with no remaining object versions. 
   Specifically, the delete marker is the *only* remaining "version" of the given object.

   This option is mutually exclusive with the following option:
   
   - :mc-cmd:`~mc ilm add --tags`
   - :mc-cmd:`~mc ilm add --expiry-days`

   MinIO uses a scanner process to check objects against all configured lifecycle management rules. 
   Slow scanning due to high IO workloads or limited system resources may delay application of lifecycle management rules. 
   See :ref:`minio-lifecycle-management-scanner` for more information.

   For more complete documentation on object expiration, see
   :ref:`minio-lifecycle-management-expiration`.

.. mc-cmd:: --transition-days
   :optional:
   
   The number of calendar days from object creation after which MinIO marks an object as eligible for transition. 
   MinIO transitions the object to the configured remote tier specified to the :mc-cmd:`~mc ilm add --tier`. 
   Specify the number of days as an integer, e.g. ``30`` for 30 days.

   For versioned buckets, the transition rule applies only to the *current* object version. 
   Use the :mc-cmd:`~mc ilm add --noncurrentversion-transition-days` option to apply transition behavior to noncurrent object versions.

   Requires specifying :mc-cmd:`~mc ilm add --tier`.

   MinIO uses a scanner process to check objects against all configured lifecycle management rules. 
   Slow scanning due to high IO workloads or limited system resources may delay application of lifecycle management rules. 
   See :ref:`minio-lifecycle-management-scanner` for more information.

   For more complete documentation on object transition, see :ref:`minio-lifecycle-management-tiering`.

.. mc-cmd:: --tier
   :optional:

   The remote tier to which MinIO :ref:`transition objects <minio-lifecycle-management-tiering>`.
   Specify an existing remote tier created by :mc:`mc admin tier`. 

   Required if specifying :mc-cmd:`~mc ilm add --transition-days`.

.. mc-cmd:: --tags
   :optional:

   One or more ampersand ``&``-delimited key-value pairs describing the object tags to use for filtering objects to which the lifecycle configuration rule applies.

   This option is mutually exclusive with the following option:

   - :mc-cmd:`~mc ilm add --expired-object-delete-marker`

.. mc-cmd:: --noncurrentversion-expiration-days
   :optional:

   The number of days to retain an object version after becoming *non-current* (i.e. a different version of that object is now the `HEAD`).
   MinIO marks noncurrent object versions for deletion after the specified number of days pass.

   This option has the same behavior as the S3 ``NoncurrentVersionExpiration`` action.

   MinIO uses a scanner process to check objects against all configured lifecycle management rules. 
   Slow scanning due to high IO workloads or limited system resources may delay application of lifecycle management rules. 
   See :ref:`minio-lifecycle-management-scanner` for more information.

.. mc-cmd:: --noncurrentversion-transition-days
   :optional:

   The number of days an object has been non-current (i.e. replaced by a newer version of that same object) after which MinIO marks the object   version as eligible for transition. 
   MinIO transitions the object to the configured remote tier specified to the :mc-cmd:`~mc ilm add --tier` once the system host datetime passes that calendar date.

   This option has no effect on non-versioned buckets. 
   Requires specifying :mc-cmd:`~mc ilm add --noncurrentversion-tier`.

   This option has the same behavior as the S3 ``NoncurrentVersionTransition`` action.

   MinIO uses a scanner process to check objects against all configured lifecycle management rules. 
   Slow scanning due to high IO workloads or limited system resources may delay application of lifecycle management rules. 
   See :ref:`minio-lifecycle-management-scanner` for more information.

.. mc-cmd:: --noncurrentversion-tier
   :optional:

   The remote tier to which MinIO :ref:`transitions noncurrent objects versions <minio-lifecycle-management-tiering>`. 
   Specify a remote tier created by :mc:`mc admin tier`.

.. mc-cmd:: --newer-noncurrentversions-expiration
   :optional:

   The maximum number of non-current object versions to retain, ordered from newest to oldest.
   
   Use this flag to retain a certain number of past versions of a file in a first in, first out fashion.
   After retaining the maximum number of non-current versions, MinIO marks any remaining older non-current object versions as eligible for expiration.
   
   The following table lists a number of object versions and their expiration eligibility based on ``--newer-noncurrentversions-expiration 3``:

   .. list-table::
      :widths: 50 50
      :width: 100% 

      * - v5 (current version)
        - Current version not affected by ILM rules.
      * - v4
        - retained
      * - v3
        - retained
      * - v2
        - retained
      * - v1
        - marked for expiry

   MinIO retains the current version, v5.
   MinIO also retains the next ``3`` non-current versions, starting with the newest.
   This means MinIO marks ``v4``, ``v3``, and ``v2`` for the three non-current version to retain.

   ``v1`` would be a fourth non-current version, which falls outside the limit of non-current versions to retain, so MinIO marks ``v1`` for expiration.

   Updating the number for this flag only impacts the unmarked versions of objects.
   Any versions already marked for expiration do not change if you increase the number to retain.

   MinIO uses a scanner process to check objects against all configured lifecycle management rules. 
   Slow scanning due to high IO workloads or limited system resources may delay application of lifecycle management rules. 
   See :ref:`minio-lifecycle-management-scanner` for more information.
   
.. mc-cmd:: --newer-noncurrentversions-transition
   :optional:
   
   The maximum number of non-current object versions to retain on the current tier.
   Older object versions beyond the number to retain transition to a different, specified tier.

   Use this flag to keep a certain number of non-current versions of an object accessible on the tier in a first in, first out order.

   If not specified, all non-current object versions transition to the different tier.

   The following table lists a number of object versions and their transition eligibility based on ``--newer-noncurrentversions-transition 3``:

   .. list-table::
      :widths: 50 50
      :width: 100% 

      * - v5 (current version)
        - Current version not affected by ILM rules.
      * - v4
        - kept on current tier
      * - v3
        - kept on current tier
      * - v2
        - kept on current tier
      * - v1
        - marked for transition to other tier

   MinIO retains the current version, v5, on the tier.
   MinIO also retains the next ``3`` non-current versions on the tier, starting with the newest.
   This means MinIO leaves ``v4``, ``v3``, and ``v2`` for the three non-current version to keep on the current tier.

   ``v1`` would be a fourth non-current version, which falls outside the limit of non-current versions to retain, so MinIO marks ``v1`` for transition.

   Updating the number for this flag only impacts the unmarked versions of objects.
   Any versions already marked for transition do not change if you increase the number, and any object versions already transitioned do not transition back to the tier.

   MinIO uses a scanner process to check objects against all configured lifecycle management rules. 
   Slow scanning due to high IO workloads or limited system resources may delay application of lifecycle management rules. 
   See :ref:`minio-lifecycle-management-scanner` for more information.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Expire All Bucket Contents After Number of Days
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc ilm add` with :mc-cmd:`~mc ilm add --expiry-days` to mark bucket contents for expiration after a number of days pass from the object's creation:

.. code-block:: shell
   :class: copyable

   mc ilm add ALIAS/PATH --expiry-days "DAYS" 

- Replace :mc-cmd:`ALIAS <mc ilm add ALIAS>` with the :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm add ALIAS>` with the path to the bucket on the S3-compatible host.

- Replace :mc-cmd:`DATE <mc ilm add --expiry-days>` with the number of days after which to expire the object. 
  For example, specify ``30`` to expire the object 30 days after creation.

Transition Non-Current Object Versions at a Prefix to a Different Tier
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc ilm add` with :mc-cmd:`~mc ilm add --prefix` and :mc-cmd:`~mc ilm add --tier` to transition older non-current versions of an object to a different storage tier.

.. code-block:: shell
   :class: copyable

   mc ilm add --prefix "doc/" --transition-days "90" --tier "MINIOTIER-1"                  \
          --noncurrentversion-transition-days "45" --noncurrentversion-tier "MINIOTIER-2"  \
          myminio/mybucket/

This command looks at the contents with the ``doc/`` prefix in the ``mybucket`` bucket on the ``myminio`` deployment.

- Current objects in the prefix older than 90 days move to the ``MINIOTIER-1`` storage tier.
- Non-current objects in the prefix older than 45 days move to the ``MINIOTIER-2`` storage tier.
- Both ``MINIOTIER-1`` and ``MINIOTIER-2`` have already been created with :mc:`mc admin tier add`.

Expire All Objects at a Prefix, Retain Current Object Versions Longer Than Non-Current Object Versions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc ilm add` command with :mc-cmd:`~mc ilm add --prefix`, :mc-cmd:`~mc ilm add --expiry-days`, and :mc-cmd:`~mc ilm add --noncurrentversion-expiration-days` to expire current and non-current versions of an object at different times.

.. code-block:: shell
   :class: copyable

   mc ilm add --prefix "doc/" --expiry-days "300" --noncurrentversion-expiration-days "100" myminio/mybucket/

This command looks at the contents with the ``doc/`` prefix in the ``mybucket`` bucket on the ``myminio`` deployment.

- Current objects expire after 300 days.
- Non-current objects expire after 100 days.

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
:mc:`mc ilm ls` to review the currently configured object lifecycle
management rules for any potential interactions between expiry and transition
rules.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
