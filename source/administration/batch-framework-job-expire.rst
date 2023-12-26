.. _minio-batch-framework-expire-job:

=================
Batch Expiration
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. versionadded:: MinIO RELEASE.2023-12-02T10-51-33Z

The MinIO Batch Framework allows you to create, manage, monitor, and execute jobs using a YAML-formatted job definition file (a "batch file").
The batch jobs run directly on the MinIO deployment to take advantage of the server-side processing power without constraints of the local machine where you run the :ref:`MinIO Client <minio-client>`.

The ``expire`` batch job applies :ref:`minio-lifecycle-management-create-expiry-rule` behavior to a single bucket.
The job determines expiration eligibility based on the provided configuration, independent of any configured expiration rules.


Behavior
--------

Immediate Expiration of Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Batch expiration occurs immediately as part of the batch job, as compared to the :ref:`passive scanner-based application of expiration rules <minio-lifecycle-management-scanner>`.
Specifically, batch expiration does not yield to application I/O and may impact performance of regular read/write operations on the deployment.

Expiration Eligibility Determined at Batch-Run
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The batch expiration works per-bucket and runs once to completion.
The job determines expiration eligibility at the time the job runs, and does *not* rescan or recheck for new objects periodically.

You can instead re-run the batch job later to capture any new objects eligible for expiration under the job configuration.

.. _minio-batch-framework-expire-job-ref:

Expire Batch Job Reference
--------------------------

.. list-table::
   :widths: 25 75
   :width: 100%

   * - Field
     - Description

   * - ``expire``
     - *Required* 
       
       Top-level field for the expiration job type.

   * - ``apiVersion``
     - *Required*
        
       Set to ``v1``.

   * - ``bucket``
     - *Required*
       
       Specify the name of the object in which the job runs.

   * - ``prefix``
     - *Optional*
      
       Specify the bucket prefix in which the job runs.

   * - ``rules``
     - *Required*
       
       An array of one or more expiration rules to apply to objects in the specified ``bucket`` and ``prefix`` (if any).

   * - ``rules.[n].type``
     - *Required*

       Supports one of the following two values:

       - ``object`` - apply the expiration to objects and their versions
       - ``deleted`` - apply the expiration to object Delete Markers

   * - ``rules.[n].name``
     - *Optional*

       Specify a match string to use for filtering objects.

       Supports glob-style wildcards (``*``, ``?``).

   * - ``rules.[n].olderThan``
     - *Optional*

       Specify the age of objects for filtering objects.
       The rule applies to only those objects older than the specified unit of time.

       Supports values such as ``72h`` or ``3d`` for objects three days old.

   * - ``rules.[n].createdBefore``
     - *Optional*

       Specify an ISO-8601 timestamp for filtering objects.

       The rule applies to only those objects created *before* the specified timestamp.

   * - ``rules.[n].tags``
     - *Optional*

       Specify an array of key-value pairs describing object tags to use for filtering objects.
       The ``value`` key supports glob-style wildcards (``*``, ``?``).

       For example, the following filters the rule to only objects with matching tags:

       .. code-block:: yaml

          tags:
            - key: archive
              value: True

       This key is incompatible with ``rules.[n].type: deleted``.

   * - ``rules.[n].metadata``
     - *Optional*

       Specify an array of key-value pairs describing object metadata to use for filtering objects.
       The ``value`` key supports glob-style wildcards (``*``, ``?``).

       For example, the following filters the rule to only objects with matching metadata:

       .. code-block:: yaml

          metadata:
            - key: content-type
              value: image/*

       This key is incompatible with ``rules.[n].type: deleted``.

   * - ``rules.[n].size``
     - *Optional*

       Specify the range of object sizes for filtering objects.

       - ``lessThan`` - matches objects with size less than the specified amount (e.g. ``MiB``, ``GiB``).
       - ``greaterThan`` - matches objects with size greater than the specified amount (e.g. ``MiB``, ``GiB``).

   * - ``rules.[n].purge.retainVersions``
     - *Optional*

       Specify the number of object versions to retain when applying expiration.

       Defaults to ``0`` for deleting all object versions (fastest).

   * - ``notify.endpoint``
     - *Optional*

       The predefined endpoint to send events for notifications.

   * - ``notify.token``
     - *Optional*

       An optional :abbr:`JWT <JSON Web Token>` to access the ``notify.endpoint``.

   * - ``retry.attempts``
     - *Optional*

       The number of tries to complete the batch job before giving up.

   * - ``retry.delay``
     - *Optional*

       The amount of time to wait between each attempt (``ms``).

Sample YAML Description for an ``expire`` Job Type
--------------------------------------------------
       
Use :mc:`mc batch generate` to create a basic ``expire`` batch job for further customization.

.. literalinclude:: /includes/code/expire.yaml
   :language: yaml
