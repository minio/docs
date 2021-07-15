==========
``mc ilm``
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm

Description
-----------

.. start-mc-ilm-desc

The :mc:`mc ilm` command manages object lifecycle management
rules on a bucket. See the AWS documentation on 
:s3-docs:`Object Lifecycle Management <object-lifecycle-mgmt.html>` for more
information.

.. end-mc-ilm-desc

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
:mc-cmd:`mc ilm list` to review the currently configured object lifecycle
management rules for any potential interactions between expiry and transition
rules.

Examples
--------

Expire Bucket Contents After Specific Date
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc ilm add` with :mc-cmd-option:`~mc ilm add expiry-date` to
expire bucket contents after a specific date.

.. code-block:: shell
   :class: copyable

   mc ilm add ALIAS/PATH --expiry-date "DATE"

- Replace :mc-cmd:`ALIAS <mc ilm add TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm add TARGET>` with the path to the bucket on the
  S3-compatible host.

- Replace :mc-cmd:`DATE <mc ilm add expiry-date>` with the calendar date after
  which to expire the object. For example, specify "2021-01-01" to expire
  objects after January 1st, 2021.

Expire Bucket Contents After Number of Days
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc ilm add` with :mc-cmd-option:`~mc ilm add expiry-days` to
expire bucket contents a number of days after object creation:

.. code-block:: shell
   :class: copyable

   mc ilm add ALIAS/PATH --expiry-days "DAYS" 

- Replace :mc-cmd:`ALIAS <mc ilm add TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm add TARGET>` with the path to the bucket on the
  S3-compatible host.

- Replace :mc-cmd:`DATE <mc ilm add expiry-date>` with the number of days after
  which to expire the object. For example, specify ``30d`` to expire the
  object 30 days after creation.

List Bucket Lifecycle Management Rules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc ilm list` to list a bucket's lifecycle management rules:

.. code-block:: shell
   :class: copyable

   mc ilm list ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc ilm list TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm list TARGET>` with the path to the bucket on the
  S3-compatible host.

Remove a Bucket Lifecycle Management Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc ilm remove` to remove a bucket lifecycle management rule:

.. code-block:: shell
   :class: copyable

   mc ilm remove --id "RULE" ALIAS/PATH

- Replace :mc-cmd:`RULE <mc ilm remove id>` with the unique name of the lifecycle
  management rule.

- Replace :mc-cmd:`ALIAS <mc ilm remove TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm remove TARGET>` with the path to the bucket on the
  S3-compatible host.


Syntax
------

.. mc-cmd:: list
   :fullpath:

   Lists the current lifecycle management rules of the specified bucket. The
   subcommand has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc ilm list TARGET [FLAGS]

   The subcommand supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the bucket from which to list existing 
      lifecycle management rules. Specify the :mc-cmd:`alias <mc alias>` 
      of a configured S3 service as the prefix to the ``TARGET`` path.

      For example:

      .. code-block:: shell

         mc ilm list play/mybucket
   
   .. mc-cmd:: expiry
      :option:

      :mc-cmd:`mc ilm` returns only fields related to lifecycle rule expiration.

   .. mc-cmd:: transition
      :option:

      :mc-cmd:`mc ilm` returns only fields related to lifecycle rule transition.

   .. mc-cmd:: minimum
      :option:

      :mc-cmd:`mc ilm` returns only the following fields:
            
      - ``id``
      - ``prefix``
      - ``status``
      - ``transition set``
      - ``expiry set``

.. mc-cmd:: add
   :fullpath:

   Adds a new bucket lifecycle management rules. The command has
   the following syntax:

   .. code-block:: shell
      :class: copyable

      mc ilm add TARGET [FLAGS]

   .. mc-cmd:: TARGET
      
      *Required* 
      
      The full path to the bucket from which to add the lifecycle
      management rule. Specify the :mc-cmd:`alias <mc alias>` of a configured S3
      service as the prefix to the ``TARGET`` path.

      For example:

      .. code-block:: shell

         mc ilm add play/mybucket [FLAGS] 

   .. mc-cmd:: prefix
      :option:
      
      The path to the specific subset of the :mc-cmd:`~mc ilm add TARGET` bucket
      on which to apply the lifecycle configuration rule. MinIO appends the
      :mc-cmd-option:`~mc ilm add prefix` field to the ``TARGET`` path to
      construct the full path.

      Omit to apply the rule to the entire ``TARGET`` bucket.

   .. mc-cmd:: tags
      :option:

      One or more ampersand ``&``-delimited key-value pairs describing 
      the object tags to which to apply the lifecycle configuration rule.

      This option is mutually exclusive with the following option:

      - :mc-cmd-option:`~mc ilm add expired-object-delete-marker`

   .. mc-cmd:: expiry-date
      :option:

      The ISO-8601-formatted calendar date until which MinIO retains an object
      after being created. MinIO marks the object for deletion once the
      system host datetime passes that calendar date.

      Specifying a calendar date that is *prior* to the current system host
      datetime marks all objects covered by the rule for deletion.

      For versioned buckets, the expiry rule applies only to the *current*
      object version. Use the 
      :mc-cmd-option:`~mc ilm add noncurrentversion-expiration-days` option
      to apply expiration behavior to noncurrent object versions.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

      Mutually exclusive with the following options:

      - :mc-cmd-option:`~mc ilm add expiry-days`
      - :mc-cmd-option:`~mc ilm add expired-object-delete-marker`

   .. mc-cmd:: expiry-days
      :option:

      The number of days to retain an object after being created. MinIO
      marks the object for deletion after the specified number of days pass.

      For versioned buckets, the expiry rule applies only to the *current*
      object version. Use the 
      :mc-cmd-option:`~mc ilm add noncurrentversion-expiration-days` option
      to apply expiration behavior to noncurrent object versions.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

      Mutually exclusive with the following options:

      - :mc-cmd-option:`~mc ilm add expiry-date`
      - :mc-cmd-option:`~mc ilm add expired-object-delete-marker`

   .. mc-cmd:: noncurrentversion-expiration-days
      :option:

      The number of days to retain an object version after becoming 
      *non-current* (i.e. a different version of that object is now the `HEAD`).
      MinIO marks noncurrent object versions for deletion after the 
      specified number of days pass.

      This option has the same behavior as the 
      S3 ``NoncurrentVersionExpiration`` action.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   .. mc-cmd:: expired-object-delete-marker
      :option:

      Specify this option to direct MinIO to remove delete markers for
      objects with no remaining object versions. Specifically, the delete
      marker is the *only* remaining "version" of the given object.

      This option is mutually exclusive with the following option:
      
      - :mc-cmd-option:`~mc ilm add tags`
      - :mc-cmd-option:`~mc ilm add expiry-date`
      - :mc-cmd-option:`~mc ilm add expiry-days`

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   .. mc-cmd:: transition-date
      :option:

      The ISO-8601-formatted calendar date after which MinIO marks an object as
      eligible for transition to the remote tier. MinIO transitions the object
      to the configured remote storage tier specified to the 
      :mc-cmd-option:`~mc ilm add storage-class` once the system host datetime
      passes that calendar date.

      For versioned buckets, the transition rule applies only to the *current*
      object version. Use the 
      :mc-cmd-option:`~mc ilm add noncurrentversion-transition-days` option
      to apply transition behavior to noncurrent object versions.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.
            
   .. mc-cmd:: transition-days
      :option:

      The number of calendar days from object creation after which MinIO marks
      an object as eligible for transition. MinIO transitions the object to the
      configured remote storage tier specified to the 
      :mc-cmd-option:`~mc ilm add storage-class`. 

      For versioned buckets, the transition rule applies only to the *current*
      object version. Use the 
      :mc-cmd-option:`~mc ilm add noncurrentversion-transition-days` option
      to apply transition behavior to noncurrent object versions.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   .. mc-cmd:: noncurrentversion-transition-days
      :option:

      The number of days an object has been non-current (i.e. replaced by a
      newer version of that same object) after which MinIO marks the object
      version as eligible for transition. MinIO transitions the object to the
      configured remote storage tier specified to the 
      :mc-cmd-option:`~mc ilm add storage-class` once the system host datetime
      passes that calendar date.

      This option has no effect on non-versioned buckets.

      This option has the same behavior as the 
      S3 ``NoncurrentVersionTransition`` action.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   .. mc-cmd:: storage-class
      :option:

      The remote storage tier to which MinIO 
      :ref:`transition objects <minio-lifecycle-management-tiering>`.
      Specify a remote storage tier created by :mc-cmd:`mc admin tier`. 

      If using :mc-cmd:`mc ilm add` against an Amazon S3 service, this argument
      is the Amazon S3 storage class to transition objects covered by the rule.
      See :s3-docs:`Transition objects using Amazon S3 Lifecycle
      <lifecycle-transition-general-considerations.html>` for more information
      on S3 storage classes.

   .. mc-cmd:: disable
      :option:

      Disables the rule.

      To enable a disabled rule, specify ``--disable=false``

.. mc-cmd:: edit
   :fullpath:

   Edits an existing lifecycle management rule in the bucket. The command
   has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc ilm edit --id "RULE_ID" TARGET [FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* 
      
      The full path to the bucket from which to modify the 
      specified lifecycle management rule. Specify the :mc-cmd:`alias
      <mc alias>` of a configured S3 service as the prefix to the
      ``TARGET`` path.

      For example:

      .. code-block:: shell

         mc ilm edit --id "RULE_ID" play/mybucket [FLAGS]

   .. mc-cmd:: id
      :option:

      *Required*

      The unique ID of the rule. Use :mc-cmd:`mc ilm list` to list bucket rules
      and retrieve the ``id`` for the rule you want to modify.

   .. mc-cmd:: tags
      :option:

      One or more ampersand ``&``-delimited key-value pairs describing 
      the object tags to which to apply the lifecycle configuration rule.

      This option is mutually exclusive with the following option:

      - :mc-cmd-option:`~mc ilm edit expired-object-delete-marker`

   .. mc-cmd:: expiry-date
      :option:

      The ISO-8601-formatted calendar date until which MinIO retains an object
      after being created. MinIO marks the object for deletion once the
      system host datetime passes that calendar date.

      Specifying a calendar date that is *prior* to the current system host
      datetime marks all objects covered by the rule for deletion.

      For versioned buckets, the expiry rule applies only to the *current*
      object version. Use the 
      :mc-cmd-option:`~mc ilm edit noncurrentversion-expiration-days` option
      to apply expiration behavior to noncurrent object versions.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

      Mutually exclusive with the following options:

      - :mc-cmd-option:`~mc ilm edit expiry-days`
      - :mc-cmd-option:`~mc ilm edit expired-object-delete-marker`


   .. mc-cmd:: expiry-days
      :option:

      The number of days to retain an object after being created. MinIO
      marks the object for deletion after the specified number of days pass.

      For versioned buckets, the expiry rule applies only to the *current*
      object version. Use the 
      :mc-cmd-option:`~mc ilm edit noncurrentversion-expiration-days` option
      to apply expiration behavior to noncurrent object versions.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

      Mutually exclusive with the following options:

      - :mc-cmd-option:`~mc ilm edit expiry-date`
      - :mc-cmd-option:`~mc ilm edit expired-object-delete-marker`

   .. mc-cmd:: noncurrentversion-expiration-days
      :option:

      The number of days to retain an object version after becoming 
      *non-current* (i.e. a different version of that object is now the `HEAD`).
      MinIO marks noncurrent object versions for deletion after the 
      specified number of days pass.

      This option has the same behavior as the 
      S3 ``NoncurrentVersionExpiration`` action.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   .. mc-cmd:: expired-object-delete-marker
      :option:

      Specify this option to direct MinIO to remove delete markers for
      objects with no remaining object versions. Specifically, the delete
      marker is the *only* remaining "version" of the given object.

      This option is mutually exclusive with the following option:
      
      - :mc-cmd-option:`~mc ilm edit tags`
      - :mc-cmd-option:`~mc ilm edit expiry-date`
      - :mc-cmd-option:`~mc ilm edit expiry-days`

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   .. mc-cmd:: transition-date
      :option:

      The ISO-8601-formatted calendar date after which MinIO marks an object as
      eligible for transition to the remote tier. MinIO transitions the object
      to the configured remote storage tier specified to the 
      :mc-cmd-option:`~mc ilm edit storage-class` once the system host datetime
      passes that calendar date.

      For versioned buckets, the transition rule applies only to the *current*
      object version. Use the 
      :mc-cmd-option:`~mc ilm edit noncurrentversion-transition-days` option
      to apply transition behavior to noncurrent object versions.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.
            
   .. mc-cmd:: transition-days
      :option:

      The number of calendar days from object creation after which MinIO marks
      an object as eligible for transition. MinIO transitions the object to the
      configured remote storage tier specified to the 
      :mc-cmd-option:`~mc ilm edit storage-class`. 

      For versioned buckets, the transition rule applies only to the *current*
      object version. Use the 
      :mc-cmd-option:`~mc ilm edit noncurrentversion-transition-days` option
      to apply transition behavior to noncurrent object versions.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   .. mc-cmd:: noncurrentversion-transition-days
      :option:

      The number of days an object has been non-current (i.e. replaced by a
      newer version of that same object) after which MinIO marks the object
      version as eligible for transition. MinIO transitions the object to the
      configured remote storage tier specified to the 
      :mc-cmd-option:`~mc ilm edit storage-class` once the system host datetime
      passes that calendar date.

      This option has no effect on non-versioned buckets.

      This option has the same behavior as the 
      S3 ``NoncurrentVersionTransition`` action.

      MinIO uses a scanner process to check objects against all configured
      lifecycle management rules. Slow scanning due to high IO workloads or
      limited system resources may delay application of lifecycle management
      rules. See :ref:`minio-lifecycle-management-scanner` for more information.

   .. mc-cmd:: storage-class
      :option:

      The remote storage tier to which MinIO 
      :ref:`transition objects <minio-lifecycle-management-tiering>`.
      Specify a remote storage tier created by :mc-cmd:`mc admin tier`. 

      If using :mc-cmd:`mc ilm edit` against an Amazon S3 service, this argument
      is the Amazon S3 storage class to transition objects covered by the rule.
      See :s3-docs:`Transition objects using Amazon S3 Lifecycle
      <lifecycle-transition-general-considerations.html>` for more information
      on S3 storage classes.

   .. mc-cmd:: disable
      :option:

      Disables the rule.

.. mc-cmd:: remove
   :fullpath:

   Removes an existing lifecycle management rule from the bucket.  The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

       mc ilm remove [FLAGS] TARGET

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the bucket from which to remove the 
      specified lifecycle management rule. Specify the :mc-cmd:`alias
      <mc alias>` of a configured S3 service as the prefix to the
      ``TARGET`` path.

      For example:

      .. code-block:: shell

         mc ilm remove [FLAGS] play/mybucket

   .. mc-cmd:: id

      *Required*
      
      The unique ID of the rule. Use :mc-cmd:`mc ilm list` to list bucket rules
      and retrieve the ``id`` for the rule you want to remove.

      Mutually exclusive with :mc-cmd-option:`mc ilm remove all`

   .. mc-cmd:: all

      *Required* Removes all rules in the bucket. Mutually exclusive with
      :mc-cmd-option:`mc ilm remove id`.

      Requires including :mc-cmd-option:`~mc ilm remove force`.

   .. mc-cmd:: force

      Required if specifying :mc-cmd-option:`~mc ilm remove all`.

.. mc-cmd:: export
   :fullpath:

   Export the JSON-formatted lifecycle configuration to ``STDOUT``. The command
   has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc ilm export TARGET

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the bucket from which to export the
      configured lifecycle management rules. Specify the
      :mc-cmd:`alias <mc alias>` of a configured S3 service as the prefix
      to the ``TARGET`` path. For example:

      .. code-block:: shell

         mc ilm export play/mybucket > play_mybucket_lifecycle_rules.json

.. mc-cmd:: import
   :fullpath:

   Import a JSON-formatted lifecycle configuration from ``STDIN``. The command
   has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc ilm import TARGET

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the bucket from which to apply the imported
      lifecycle management rules. Specify the :mc-cmd:`alias <mc alias>` of a
      configured S3 service as the prefix to the ``TARGET`` path. For example:

      .. code-block:: shell

         mc ilm import play/mybucket < play_mybucket_lifecycle_rules.json

