.. _minio-object-delete:

===============
Object Deletion
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

This page summarizes how a ``DELETE`` operation affects objects depending on the configuration of the bucket that contains the object.

Any combination of the following factors may impact how ``DELETE`` operations function:

- :ref:`Bucket versioning <minio-bucket-versioning>`
- :ref:`Object locking rules <minio-object-locking>`
- :ref:`Object Lifecycle Management rules <minio-lifecycle-management>`
- :ref:`Object tiering <minio-lifecycle-management-tiering>`
- :ref:`Site <minio-site-replication-overview>` or :ref:`bucket <minio-replication-behavior-delete>` replication
- :ref:`Scanner <minio-concepts-scanner>`

Permissions
-----------

MinIO uses a :ref:`policy based access control <minio-policy>` system for access management.
The user or service account must provide the correct policy action and conditions to allow a ``DELETE`` for the bucket and object.

Unversioned Objects
-------------------

When performing a ``DELETE`` operation on an object in a bucket that does not have versioning enabled, the operation is straightforward.
After verifying the user or service account has permission to perform the ``DELETE`` operation, MinIO permanently removes the object.

The user or service account requesting the delete action the action must have the :policy-action:`s3:deleteObject` action permission for the bucket and object.

Versioned Objects
-----------------

``DELETE`` operations work differently when an object is versioned.

The user or service account must have the :policy-action:`s3:DeleteObjectVersion` action permission for the bucket and object.

Delete operations on the current version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A ``DELETE`` operation on a versioned object that does not specify a version UUID results in a ``DeleteMarker`` placed as the ``head`` of the object.

In this scenario, MinIO does not actually remove the object or any of its versions from the disk.
All existing versions of the object remain available to access by specifying the version's UUID.
When a ``DeleteMarker`` is the head for the object, MinIO does not serve the object for ``GET`` requests that do not specify a version number.
Instead, MinIO returns a ``404``-like response. 

You can find the UUID of object versions with :mc-cmd:`mc ls --versions`.

To remove the current version of the object from the drive, find the UUID of the version, and then use :mc-cmd:`mc rm --version-id=UUID ... <mc rm --version-id>` to delete the current version.
In this scenario, the immediately preceding version of the object then becomes the current version of the object served for ``GET`` requests of the object with no UUID specified.

.. warning::

   Specifying a ``version-id`` in a DELETE operation is irreversible.
   MinIO removes the specified version from the drive and **cannot** retrieve it.

Delete operations on a prior version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To delete prior versions of an object, specify the version's UUID.
You can retrieve the version UUID with :mc-cmd:`mc ls --versions`. 
When the ``DELETE`` request specifies a ``version-id`` and the user has the correct permissions to delete the object version`, MinIO permanently removes the specified version from the drive.

.. warning::

   Specifying a ``version-id`` in a DELETE operation is irreversible.
   MinIO removes the specified version from the drive and **cannot** retrieve it.

Delete all versions
~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc rm --versions` to delete *all* versions of an object.
This is irreversible.

Lifecycle Management Expiration
-------------------------------

You can define one or more :ref:`lifecycle management expiration rule(s) <minio-lifecycle-management-create-expiry-rule>` to expire objects after a certain version number count or a certain period of time.
When more versions exist than the rule specifies, or when a version is older than specified, MinIO permanently removes the object version from the drive.

These rules rely on the :ref:`scanner <minio-concepts-scanner>` to process the rule on the bucket.
The scanner operates as a lower priority continuous process where ``READ`` and ``WRITE`` actions are preferred.
Because of this, object versions that meet the requirements for expiration may not immediately be removed from MinIO.

See the :ref:`scanner <minio-concepts-scanner>` page for more details on how the scanner works and configuration options.

``DeleteMarkers`` are their own objects.
Lifecycle rules can remove ``DeleteMarkers`` that are the only remaining versions of their objects.

Retained Objects
----------------

MinIO protects objects subject to a :ref:`locking rule <minio-object-locking>` from being overwritten or deleted.
These rules require that objects be retained until either the rule expires or is removed.

``DELETE`` operations on locked objects without a specified version result in the creation of a `DeleteMarker` for the object.
However, the object versions themselves are retained as required by the lock.

``DELETE`` operations that specify an object version are subject to the retention rules.
MinIO protects object versions subject to a lock from being overwritten or deleted until the lock expires or is removed.

Replicated Objects
------------------

Replication duplicates objects from one location to another.
MinIO supports replication at the bucket level or the cluster ("site") level.

Delete operations may or may not replicate, depending on the type of replication and how the replication is configured.

Site Replication
~~~~~~~~~~~~~~~~

For clusters with :ref:`multi-site replication <minio-site-replication-overview>` set up, MinIO replicates all ``delete`` operations performed on any cluster to each of the other clusters in the peer group.

Delete behavior on any single peer follows the same processes as any MinIO deployment.

Bucket Replication
~~~~~~~~~~~~~~~~~~

With :ref:`bucket replication <minio-bucket-replication>`, MinIO supports replicating delete operations between a source bucket and a configured remote bucket.
MinIO synchronizes deleting specific object versions *and* new  :s3-docs:`delete markers <delete-marker-replication.html>`. 
Delete operation replication uses the same :ref:`replication process <minio-replication-process>` as all other replication operations. 

MinIO requires *explicitly enabling* versioned deletes and delete marker replication. 
Use the :mc-cmd:`mc replicate add --replicate` field to specify either ``delete`` and ``delete-marker`` or both to enable versioned deletes and delete marker replication, respectively. 
To enable both, specify both strings using a comma separator ``delete,delete-marker``.

For delete marker replication, MinIO begins the replication process after a delete operation creates the delete marker. 
MinIO uses the ``X-Minio-Replication-DeleteMarker-Status`` metadata field for tracking  delete marker replication status. 
In :ref:`active-active <minio-bucket-replication-serverside-twoway>` replication configurations, MinIO may produce duplicate delete markers if both clusters concurrently create a delete marker for an object *or* if one or both clusters were down before the replication event synchronized.

For replicating the deletion of a specific object version, MinIO marks the object version as ``PENDING`` until replication completes. 
Once the remote target deletes that object version, MinIO deletes the object on the source.
While this process ensures near-synchronized version deletion, it may result in listing operations returning the object version after the initial delete operation. 
MinIO uses the ``X-Minio-Replication-Delete-Status`` for tracking delete version replication status.

MinIO only replicates explicit client-driven delete operations. 
MinIO does *not* replicate objects deleted from the application of :ref:`lifecycle management expiration rules <minio-lifecycle-management-expiration>`. 
For :ref:`active-active <minio-bucket-replication-serverside-twoway>` configurations, set the same expiration rules on *all* of of the replication buckets to ensure consistent application of object expiration.

.. admonition:: MinIO Trims Empty Object Prefixes on Source and Remote Bucket
   :class: note, dropdown

   If a delete operation removes the last object in a bucket prefix, MinIO recursively removes each empty part of the prefix up to the bucket root.
   MinIO only applies the recursive removal to prefixes created *implicitly* as part of object write operations - that is, the prefix was not created using an explicit directory creation command such as :mc:`mc mb`.

   If a replication rule enables replication delete operations, the replication process *also* applies the implicit prefix trimming behavior on the destination MinIO cluster.

   For example, consider a bucket ``photos`` with the following object prefixes:
   
   - ``photos/2021/january/myphoto.jpg``
   - ``photos/2021/february/myotherphoto.jpg``
   - ``photos/NYE21/NewYears.jpg``

   ``photos/NYE21`` is the *only* prefix explicitly created using :mc:`mc mb`.
   All other prefixes were *implicitly* created as part of writing the object located at that prefix. 
   
   - A command removes ``myphoto.jpg``. 
     MinIO automatically trims the empty ``/january`` prefix. 
   
   - A command then removes the ``myotherphoto.jpg``. 
     MinIO automatically trims the ``/february`` prefix *and* the now-empty ``/2021`` prefix. 
   
   - A command removes the ``NewYears.jpg`` object. 
     MinIO leaves the ``/NYE21`` prefix remains in place since it was *explicitly* created.
