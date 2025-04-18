.. _minio-lifecycle-management:

===========================
Object Lifecycle Management
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. container:: extlinks-video

   - `MinIO Object Lifecycle Management Part I <https://youtu.be/Exg2KsfzHzI?ref=docs>`__
   - `MinIO Object Lifecycle Management Part II <https://youtu.be/5fz3rE3wjGg?ref=docs>`__
   - `MinIO Object Lifecycle Management Lab <https://youtu.be/5fz3rE3wjGg?ref=docs>`__

Use MinIO Object Lifecycle Management to create rules for time or date based automatic transition or expiry of objects. 
For object transition, MinIO automatically moves the object to a configured remote storage tier. 
For object expiry, MinIO automatically deletes the object.

MinIO derives it's behavior and syntax from :s3-docs:`S3 lifecycle <object-lifecycle-mgmt.html>` for compatibility in migrating workloads and lifecycle rules from S3 to MinIO.
For example, you can export S3 lifecycle management rules and import them into MinIO or vice-versa. 
MinIO uses JSON to describe lifecycle management rules and may require conversion to or from XML as part of importing S3 lifecycle rules. 

.. _minio-lifecycle-management-tiering:

Object Transition ("Tiering")
-----------------------------

MinIO supports creating object transition lifecycle management rules, where MinIO can automatically move an object to a remote storage "tier". 
MinIO supports any of the following remote tier targets:

- :ref:`MinIO <minio-lifecycle-management-transition-to-minio>`
- :ref:`Amazon S3 <minio-lifecycle-management-transition-to-s3>`
- :ref:`Google Cloud Storage <minio-lifecycle-management-transition-to-gcs>`
- :ref:`Microsoft Azure Blob Storage 
  <minio-lifecycle-management-transition-to-azure>`

MinIO object transition supports use cases like moving aged data from MinIO clusters in private or public cloud infrastructure to low-cost private or public cloud storage solutions.
Directory objects, which are 0-byte objects with a name ending in ``/``, do **not** tier.
MinIO manages retrieving tiered objects on-the-fly without any additional application-side logic. 

Use the :mc:`mc ilm tier add` command to create a remote target for tiering data to that target. 
You can then use the :mc-cmd:`mc ilm rule add --transition-days` command to transition objects to that tier after a specified number of calendar days.

.. versionadded:: RELEASE.2022-11-10T18-20-21Z

You can verify the tiering status of an object using :mc:`mc ls` against the bucket or bucket prefix.
The output includes the storage tier of each object:

.. code-block:: shell

   $ mc ls play/mybucket
   [2022-11-08 11:30:24 PST]    52MB  STANDARD log-data.csv
   [2022-11-09 12:20:18 PST]    120MB WARM event-2022-11-09.mp4

- ``STANDARD`` marks objects stored on the MinIO deployment.
- ``WARM`` marks objects stored on the remote tier with matching name.

.. important::

   MinIO Object Transition supports cost-saving strategies around moving older or aged data to cost-optimized remote storage tiers, such as cloud storage or high-density HDD storage.

   MinIO Object Transition does **not** provide backup and recovery functionality.
   You cannot use the remote tier as a recovery source in the event of data loss in MinIO.

   Use either :ref:`site replication <minio-site-replication-overview>` or :ref:`bucket replication <minio-bucket-replication>` to support backup/recovery or :abbr:`BC/DR (Business Continuity / Disaster Recovery)` requirements.

Exclusive Access to Remote Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-transition-bucket-access-desc
   :end-before: end-transition-bucket-access-desc

Availability of Remote Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-tiering.rst
   :start-after: start-transition-data-loss-desc
   :end-before: end-transition-data-loss-desc

Versioned Buckets
~~~~~~~~~~~~~~~~~

MinIO adopts :s3-docs:`S3 behavior <intro-lifecycle-rules.html#intro-lifecycle-rules-actions>` for transition rules on :ref:`versioned buckets <minio-bucket-versioning>`. 
Specifically, MinIO by default applies the transition operation to the *current* object version. 

To transition noncurrent object versions, specify the :mc-cmd:`~mc ilm rule add --noncurrent-transition-days` and :mc-cmd:`~mc ilm rule add --noncurrent-transition-tier` options when creating the transition rule. 

.. _minio-lifecycle-management-expiration:

Object Expiration
-----------------

MinIO lifecycle management supports expiring objects on a bucket. 
Object "expiration" involves performing a ``DELETE`` operation on the object. 
For example, you can create a lifecycle management rule to expire any object older than 365 days.

.. todo: Diagram of MinIO Expiration

Use :mc-cmd:`mc ilm rule add --expire-days` to expire objects after a specified number of calendar days.

For buckets with :ref:`replication <minio-bucket-replication>` configured, MinIO does not replicate objects deleted by a lifecycle management expiration rule.
See :ref:`minio-replication-behavior-delete` for more information.

Versioned Buckets
~~~~~~~~~~~~~~~~~

MinIO adopts :s3-docs:`S3 behavior <intro-lifecycle-rules.html#intro-lifecycle-rules-actions>` for expiration rules on :ref:`versioned buckets <minio-bucket-versioning>`. 
MinIO has several default behaviors for versioned buckets:

- MinIO applies the expiration option to only the *current* object version by creating a ``DeleteMarker`` as is normal with versioned delete.

  To expire noncurrent object versions, specify the :mc-cmd:`~mc ilm rule add --noncurrent-expire-days` option when creating the expiration rule. 

- MinIO does not expire ``DeleteMarkers`` *even if* no other versions of that object exist.

  To expire delete markers when there are no remaining versions for that object, specify the :mc-cmd:`~mc ilm rule add --expire-delete-marker` option when creating the expiration rule.

- To expire *all* versions of an object that does *not* have a delete marker after a specified period of days, use the :mc-cmd:`~mc ilm rule add --expire-all-object-versions` flag with the :mc-cmd:`~mc ilm rule add --expire-days` flag. 
  This permits the permanent deletion of the object after the specified number of days pass.

  .. versionchanged:: MinIO RELEASE.2024-05-01T01-11-10Z

     This flag applies only to objects that do **not** have a delete marker.

.. _minio-lifecycle-management-scanner:

Lifecycle Management Object Scanner
-----------------------------------

MinIO uses a built-in :ref:`scanner <minio-concepts-scanner>` to actively check objects against all configured lifecycle management rules. 

The scanner is a low-priority process that yields to high :abbr:`I/O (Input / Output)` workloads to prevent performance spikes triggered by rule timing. 
The scanner may therefore not detect an object as eligible for a configured transition or expiration lifecycle rule until *after* the lifecycle rule period has passed.

.. toctree::
   :hidden:

   /administration/object-management/transition-objects-to-minio.rst
   /administration/object-management/transition-objects-to-s3.rst
   /administration/object-management/transition-objects-to-gcs.rst
   /administration/object-management/transition-objects-to-azure.rst
   /administration/object-management/create-lifecycle-management-expiration-rule.rst
