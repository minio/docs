.. _minio-lifecycle-management:

===========================
Object Lifecycle Management
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO Object Lifecycle Management allows creating rules for time or date
based automatic transition or expiry of objects. For object transition,
MinIO automatically moves the object to a configured remote storage
tier. For object expiry, MinIO automatically deletes the object.

MinIO lifecycle management is built for behavior and syntax compatibility with 
:s3-docs:`AWS S3 Lifecycle Management <object-lifecycle-mgmt.html>`. For
example, you can export S3 lifecycle management rules and import them into
MinIO or vice-versa. MinIO uses JSON to describe lifecycle management rules,
and conversion to or from XML may be required. 

.. _minio-lifecycle-management-tiering:

Object Transition ("Tiering")
-----------------------------

MinIO supports creating object transition lifecycle management rules, where
MinIO can automatically move an object to a remote storage "tier". MinIO
supports any S3-compatible service as a remote tier *in addition to* the
following public cloud storage services:

- :ref:`Amazon S3 <minio-lifecycle-management-transition-to-s3>`
- :ref:`Google Cloud Storage <minio-lifecycle-management-transition-to-gcs>`
- :ref:`Microsoft Azure Blob Storage 
  <minio-lifecycle-management-transition-to-azure>`

MinIO object transition supports use cases like moving aged data from MinIO
clusters in private or public cloud infrastructure to low-cost private or public
cloud storage solutions. MinIO manages retrieving tiered objects on-the-fly
without any additional application-side logic. 

Use the :mc-cmd:`mc admin tier` command to create a remote target for tiering
data to a supported Cloud Service Provider object storage. You can then use the
:mc-cmd:`mc ilm add --transition-days` command to transition objects to the
remote tier after a specified number of calendar days.

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

MinIO adopts :s3-docs:`S3 behavior
<intro-lifecycle-rules.html#intro-lifecycle-rules-actions>` for transition rules
on :ref:`versioned buckets <minio-bucket-versioning>`. Specifically, MinIO by
default applies the transition operation to the *current* object version. 

To transition noncurrent object versions, specify the 
:mc-cmd:`~mc ilm add --noncurrentversion-transition-days` and
:mc-cmd:`~mc ilm add --noncurrentversion-transition-storage-class` options
when creating the transition rule. 

.. _minio-lifecycle-management-expiration:

Object Expiration
-----------------

MinIO lifecycle management supports expiring objects on a bucket. Object
"expiration" involves performing a ``DELETE`` operation on the object. For 
example, you can create a lifecycle management rule to expire any object
older than 365 days.

.. todo: Diagram of MinIO Expiration

Use :mc-cmd:`mc ilm add --expiry-days` to expire objects after a specified
number of calendar days.

For buckets with :ref:`replication <minio-bucket-replication>` configured, MinIO
does not replicate objects deleted by a lifecycle management expiration rule.
See :ref:`minio-replication-behavior-delete` for more information.

Versioned Buckets
~~~~~~~~~~~~~~~~~

MinIO adopts :s3-docs:`S3 behavior
<intro-lifecycle-rules.html#intro-lifecycle-rules-actions>` for expiration rules
on :ref:`versioned buckets <minio-bucket-versioning>`. MinIO has two
specific default behaviors for versioned buckets:

- MinIO applies the expiration option to only the *current* object version by
  creating a ``DeleteMarker`` as is normal with versioned delete.

  To expire noncurrent object versions, specify the 
  :mc-cmd:`~mc ilm add --noncurrentversion-expiration-days` option
  when creating the expiration rule. 

- MinIO does not expire ``DeleteMarkers`` *even if* no other versions of 
  that object exist.

  To expire delete markers when there are no remaining versions for that
  object, specify the :mc-cmd:`~mc ilm add --expired-object-delete-marker`
  option when creating the expiration rule.

.. _minio-lifecycle-management-scanner:

Lifecycle Management Object Scanner
-----------------------------------

MinIO uses a built-in scanner to actively check objects against all
configured lifecycle management rules. The scanner is a low-priority process
that yields to high IO workloads to prevent performance spikes triggered 
by rule timing. The scanner may therefore not detect an object as eligible 
for a configured transition or expiration lifecycle rule until *after*
the lifecycle rule period has passed.

Delayed application of lifecycle management rules is typically associated to
limited node resources and cluster size. Scanner speed tends to slow as 
clusters grow as more time is required to visit all buckets and objects. 
This can be exacerbated if the cluster hardware is undersized for regular
workloads, as the scanner will yield to high cluster load to avoid performance
loss. Consider regularly checking cluster metrics, capacity, and resource
usage to ensure the cluster hardware is scaling alongside cluster and workload
growth.

.. toctree::
   :hidden:

   /lifecycle-management/transition-objects-to-s3.rst
   /lifecycle-management/transition-objects-to-gcs.rst
   /lifecycle-management/transition-objects-to-azure.rst
   /lifecycle-management/create-lifecycle-management-expiration-rule.rst
