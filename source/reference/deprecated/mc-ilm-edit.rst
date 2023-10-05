.. _minio-mc-ilm-edit:

===============
``mc ilm edit``
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm edit

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z

   ``mc ilm edit`` replaced by :mc-cmd:`mc ilm rule edit`.


Syntax
------

.. start-mc-ilm-edit-desc

The :mc:`mc ilm edit` command modifies an existing object lifecycle management
rule on a MinIO bucket.

.. end-mc-ilm-edit-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command modifies existing lifecycle management rules for
      the ``mydata`` bucket on the ``myminio`` deployment:

      .. code-block:: shell
         :class: copyable

         mc ilm edit --id "c79ntj94b0t6rukh6lr0" --expiry-days 90  mydata/myminio
         
         mc ilm edit --id "c79nu2p4b0t6qko19rgg" --expired-object-delete-marker mydata/myminio

         mc ilm edit --id "c79n19dn10dnab109fg1" --transition-days 30 --tier "COLDTIER"
         
      The command modifies the specified rules as follows:

      - Delete objects more than 90 days old.
      - Delete ``DeleteMarker`` tombstones if that object has no other versions 
        remaining.
      - Transition objects more than 30 days old to the ``COLDTIER`` remote 
        tier.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] ilm edit \
                          --id "string"                                                                                        \
                          [--prefix "string"]                                                                                  \
                          [--enable]                                                                                           \
                          [--disable]                                                                                          \
                          [--expiry-days "string" | --expired-object-delete-marker]                                            \
                          [--transition-days "string"] --tier "string"                                                \
                          [--noncurrentversion-expiration-days "string"]                                                       \
                          [--noncurrentversion-transition-days "string" --noncurrentversion-tier "string"] \
                          [--tags]                                                                                             \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` and full path to the bucket on the MinIO
   deployment to which to modify the object lifecycle management rule. For
   example:

   .. code-block:: none

      mc ilm edit myminio/mydata

.. mc-cmd:: --id
   :required:

   The unique ID of the rule. Use :mc:`mc ilm rule ls` to list bucket
   rules and retrieve the ``id`` for the rule you want to modify.

.. mc-cmd:: --disable
   :optional:

   Stop using the rule, but retain the rule for future use.
   Objects do not transition or expire when a rule is disabled.

.. mc-cmd:: --enable
   :optional:

   Use a rule to transition or expire objects.

.. mc-cmd:: --prefix
   :optional:
   
   Restrict the management rule to a specific bucket prefix.
   
   For example:

   .. code-block:: none

      mc ilm edit --prefix "meetingnotes/" myminio/mydata/ --expiry-days "90"

   The command modifies a rule that expires objects in the ``mydata`` bucket of the ``myminio`` ALIAS after 90 days for any object with the ``meetingnotes/`` prefix.

.. mc-cmd:: --expiry-days
   :optional:

   The number of days to retain an object after being created. MinIO
   marks the object for deletion after the specified number of days pass.

   Exercise caution when using this option, as its behavior can result in
   immediate expiration of uploaded objects. Any objects created *after* 
   the specified expiration date are automatically eligible for expiration. 
   Similarly, specifying a calendar date that is *prior* to the current 
   system host datetime marks all objects covered by the rule for deletion. 
   Consider immediately removing any ILM rule using this option once the
   specified calendar date has passed.

   For versioned buckets, the expiry rule applies only to the *current*
   object version. Use the 
   :mc-cmd:`~mc ilm edit --noncurrentversion-expiration-days` option
   to apply expiration behavior to noncurrent object versions.

   MinIO uses a scanner process to check objects against all configured
   lifecycle management rules. Slow scanning due to high IO workloads or
   limited system resources may delay application of lifecycle management
   rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   Mutually exclusive with the following options:

   - :mc-cmd:`~mc ilm edit --expired-object-delete-marker`

.. mc-cmd:: --expired-object-delete-marker
   :optional:

   Specify this option to direct MinIO to remove delete markers for
   objects with no remaining object versions. Specifically, the delete marker is
   the *only* remaining "version" of the given object.

   This option is mutually exclusive with the following option:
   
   - :mc-cmd:`~mc ilm edit --tags`
   - :mc-cmd:`~mc ilm edit --expiry-days`

   MinIO uses a scanner process to check objects against all configured
   lifecycle management rules. Slow scanning due to high IO workloads or
   limited system resources may delay application of lifecycle management
   rules. See :ref:`minio-lifecycle-management-scanner` for more information.

.. mc-cmd:: --noncurrentversion-expiration-days
   :optional:

   The number of days to retain an object version after becoming
   *non-current* (i.e. a different version of that object is now the `HEAD`).
   MinIO marks noncurrent object versions for deletion after the specified
   number of days pass.

   This option has the same behavior as the 
   S3 ``NoncurrentVersionExpiration`` action.

   MinIO uses a scanner process to check objects against all configured
   lifecycle management rules. Slow scanning due to high IO workloads or
   limited system resources may delay application of lifecycle management
   rules. See :ref:`minio-lifecycle-management-scanner` for more information.

.. mc-cmd:: --noncurrentversion-transition-days
   :optional:

   The number of days an object has been non-current (i.e. replaced
   by a newer version of that same object) after which MinIO marks the object
   version as eligible for transition. MinIO transitions the object to the
   configured remote storage tier specified to the 
   :mc-cmd:`~mc ilm edit --tier` once the system host datetime
   passes that calendar date.

   This option has no effect on non-versioned buckets. Requires specifying
   :mc-cmd:`~mc ilm edit --noncurrentversion-tier`.

   This option has the same behavior as the 
   S3 ``NoncurrentVersionTransition`` action.

   MinIO uses a scanner process to check objects against all configured
   lifecycle management rules. Slow scanning due to high IO workloads or
   limited system resources may delay application of lifecycle management
   rules. See :ref:`minio-lifecycle-management-scanner` for more information.

.. mc-cmd:: --noncurrentversion-tier
   :optional:

   The remote storage tier to which MinIO 
   :ref:`transitions noncurrent objects versions
   <minio-lifecycle-management-tiering>`. Specify a remote storage tier created
   by :mc:`mc admin tier`.

   MinIO does *not* automatically migrate objects from the previously
   specified remote tier to the new remote tier. MinIO continues to
   route requests for objects stored on the old remote tier.

.. mc-cmd:: --newer-noncurrentversions-expiration
   :optional:

   The number of non-current versions of an object to retain before applying expiration.
   Older non-current versions beyond the specified number expire.
   
   By default, MinIO does not retain any non-current versions when an expiration rule applies.

.. mc-cmd:: --newer-noncurrentversions-transition
   :optional:

   The number of non-current versions of an object to keep on the current storage tier.
   Older non-current versions beyond the specified number transition to the specified tier.

   By default, MinIO transitions all non-current versions when a transition rule applies.

.. mc-cmd:: --tags
   :optional:

   One or more ampersand ``&``-delimited key-value pairs describing
   the object tags to which to apply the lifecycle configuration rule.

   This option is mutually exclusive with the following option:

   - :mc-cmd:`~mc ilm edit --expired-object-delete-marker`

.. mc-cmd:: --transition-days
   :optional:
   
   The number of calendar days from object creation after which MinIO
   marks an object as eligible for transition. MinIO transitions the object to
   the configured remote storage tier specified to the 
   :mc-cmd:`~mc ilm edit --tier`. 

   For versioned buckets, the transition rule applies only to the *current*
   object version. Use the 
   :mc-cmd:`~mc ilm edit --noncurrentversion-transition-days` option
   to apply transition behavior to noncurrent object versions.

   Requires specifying :mc-cmd:`~mc ilm edit --tier`.

   MinIO uses a scanner process to check objects against all configured
   lifecycle management rules. Slow scanning due to high IO workloads or
   limited system resources may delay application of lifecycle management
   rules. See :ref:`minio-lifecycle-management-scanner` for more information.

.. mc-cmd:: --tier
   :optional:

   The remote storage tier to which MinIO 
   :ref:`transition objects <minio-lifecycle-management-tiering>`. Specify a
   remote storage tier created by :mc:`mc admin tier`. 

   Required if specifying :mc-cmd:`~mc ilm edit --transition-days`.

   MinIO does *not* automatically migrate objects from the previously
   specified remote tier to the new remote tier. MinIO continues to
   route requests for objects stored on the old remote tier.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Modify an Existing Lifecycle Management Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc ilm edit` with :mc-cmd:`~mc ilm edit --id` to modify
an existing object expiration rule:

.. code-block:: shell
   :class: copyable

   mc ilm edit ALIAS/PATH --id "RULEID" [FLAGS]

- Replace :mc-cmd:`ALIAS <mc ilm edit ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm edit ALIAS>` with the path to the bucket on the
  S3-compatible host.

- Replace ``RULEID`` with the unique ID of the object lifecycle management
  rule.
  Use :mc:`mc ilm rule ls` to find the ``RULEID``.

- Specify any additional flags to add or modify the lifecycle management
  rule. For example, specify
  :mc-cmd:`~mc ilm edit --transition-days` to override the existing 
  transition days value for the rule.

Disable a Lifecycle Management Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc ilm edit` with :mc-cmd:`~mc ilm edit --disable` to stop using an existing management rule.

.. code-block:: shell
   :class: copyable
   
   mc ilm edit --id "RULEID" --disable myminio/mybucket

- Replace ``RULEID`` with the unique ID of the object lifecycle management rule.
  Use :mc:`mc ilm rule ls` to find the ``RULEID``.
- Replace ``myminio`` with the ALIAS of the deployment where the rule exists.
- Replace ``mybucket`` with the bucket for the rule.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
