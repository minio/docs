.. _minio-bucket-versioning:

=================
Bucket Versioning
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. container:: extlinks-video

   - `Versioning overview <https://youtu.be/XGOiwV6Cbuk?ref=docs>`__
   - `Versioning lab <https://youtu.be/nFUI2N5zH34?ref=docs>`__

Overview
--------

MinIO supports keeping multiple "versions" of an object in a single bucket.

When enabled, versioning allows MinIO to keep multiple iterations of the same object.
Write operations which would normally overwrite an existing object instead result in the creation of a new versioned object. 
MinIO versioning protects from unintended overwrites and deletions while providing support for "undoing" a write operation. 
Bucket versioning is a prerequisite for configuring :ref:`object locking and retention rules <minio-object-locking>`.

For versioned buckets, a write operation that mutates an object results in a new version of that object with a unique version ID. 
MinIO marks the "latest" version of the object that clients retrieve by default. 
Clients can then explicitly choose to list, retrieve, or remove a specific object version. 

Define :ref:`object expiration <minio-lifecycle-management-create-expiry-rule>` rules to remove versions of objects no longer needed, such as by the number of versions or the date of versions.

Read Operations on Versioned Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Review each of the four images in this series to see how MinIO retrieves objects in a versioned bucket.
Use the arrows on either side of the images to navigate from one to the next.

.. card-carousel:: 1

   .. card:: Object with Single Version

      .. image:: /images/retention/minio-versioning-single-version.svg
         :alt: Object with single version
         :align: center

      MinIO adds a unique version ID to each object as part of write operations.

   .. card:: Object with Multiple Versions

      .. image:: /images/retention/minio-versioning-multiple-versions.svg
         :alt: Object with Multiple Versions
         :align: center

      MinIO retains all versions of an object and marks the most recent
      version as the "latest".

   .. card:: Retrieving the Latest Object Version

      .. image:: /images/retention/minio-versioning-retrieve-latest-version.svg
         :alt: Object with Multiple Versions
         :align: center

      A read operation request without a version ID returns the latest version of the object.

   .. card:: Retrieving a Specific Object Version

      .. image:: /images/retention/minio-versioning-retrieve-single-version.svg
         :alt: Object with Multiple Versions
         :align: center

      Include the version ID to retrieve a specific version of an object during a read operation.

.. versionchanged:: MinIO Server RELEASE.2023-05-04T21-44-30Z

   MinIO does not create versions for creation, mutation, or deletion of explicit directory objects ("prefixes").
   Objects created within that explicit directory object retain normal versioning behavior.

MinIO implicitly determines prefixes from object paths.
Explicit prefix creation typically only occurs with Spark and similar workloads which apply legacy POSIX/HDFS directory creation behavior within the S3 context.

Versioning is Per-Namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO uses the full namespace (the bucket and path to an object) for each object
as part of determining object uniqueness. For example, all of the following
namespaces are "unique" objects, where mutations of each object result in
the creation of new object versions *at that namespace*:

.. code-block:: shell

   databucket/object.blob
   databucket/blobs/object.blob
   blobbucket/object.blob
   blobbucket/blobs/object.blob

While ``object.blob`` might be the same binary across all namespaces, 
MinIO only enforces versioning with a specific namespace and therefore
considers each ``object.blob`` above as distinct and unique.

Versioning and Storage Capacity
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO does not perform incremental or differential-type versioning. For
mutation-heavy workloads, this may result in substantial drive usage by
older or aged object versions.

For example, consider a 1GB object containing log data. An application
appends 100MB of data to the log and uploads to MinIO. MinIO would then contain
both the 1GB and 1.1GB versions of the object. If the application repeated
this process every day for 10 days, the bucket would eventually contain more
than 14GB of data associated to a single object.

MinIO supports configuring configuring :ref:`object lifecycle management rules 
<minio-lifecycle-management>` to automatically expire or transition aged
object versions and free up storage capacity. For example, you can configure
a rule to automatically expire object versions 90 days after they become
non-current (i.e. no longer the "latest" version of that object). See 
:ref:`MinIO Object Expiration <minio-lifecycle-management-expiration>` for 
more information.

You can alternatively perform manual removal of object versions using the 
following commands:

- :mc-cmd:`mc rm --versions` - Removes all versions of an object.
- :mc-cmd:`mc rm --versions --older-than <mc rm --older-than>` -
   Removes all versions of an object older than the specified calendar date.

.. versionadded:: RELEASE.2024-04-18T19-09-19Z

   MinIO emits a warning if the cumulative size of versions for any single object exceeds 1TiB.

.. _minio-bucket-versioning-id:

Version ID Generation
~~~~~~~~~~~~~~~~~~~~~

MinIO generates a unique and immutable identifier for each versioned object as
part of write operations. Each object version ID consists of a 128-bit
fixed-size :rfc:`UUIDv4 <4122#section-4.4>`. UUID generation is sufficiently
random to ensure high likelihood of uniqueness for any environment, are
computationally difficult to guess, and do not require centralized registration
process and authority to guarantee uniqueness.

.. image:: /images/retention/minio-versioning-multiple-versions.svg
   :alt: Object with Multiple Versions
   :width: 600px
   :align: center

MinIO does not support client-managed version ID allocation. All version ID
generation is handled by the MinIO server process.

For objects created while versioning is disabled or suspended, MinIO 
uses a ``null`` version ID. You can access or remove these objects by specifying
``null`` as the version ID as part of S3 operations.

.. _minio-bucket-versioning-delete:

Versioned Delete Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Performing a ``DELETE`` operation on a versioned object creates a 0-byte ``DeleteMarker`` as the latest version of that object.
For objects where the latest version is a ``DeleteMarker``, clients must specify versioning flags or identifiers to perform ``GET/HEAD/LIST/DELETE`` operations on a prior version of that object.
The default server behavior omits ``DeleteMarker`` objects from consideration for unversioned operations.

MinIO can utilize :ref:`Lifecycle Management expiration rules <minio-lifecycle-management-expiration>` to automatically remove versioned objects permanently.
Otherwise, use manual ``DELETE`` operations to permanently remove non-current versioned objects or ``DeleteMarker`` objects.

.. admonition:: MinIO Implements Idempotent Delete Markers
   :class: note

   .. versionchanged:: RELEASE.2022-08-22T23-53-06Z

   Standard S3 implementations can create multiple sequential delete markers for the same object when processing simple ``DeleteObject`` requests with no version identifier.
   See the S3 docs for details on :s3-docs:`managing delete markers <ManagingDelMarkers.html#RemDelMarker>`.

   MinIO diverges from standard S3 implementation by avoiding this potential duplication of delete markers.
   When processing a ``Delete`` request with no version identifier, MinIO creates at most one Delete Marker for the specified object.
   MinIO **does not** share S3's behavior in creating multiple sequential delete markers.

To permanently delete an object version, perform the ``DELETE`` operation and 
specify the version ID of the object to delete. Versioned delete operations 
are **irreversible**.

.. card-carousel:: 1

   .. card:: Deleting an Object

      .. image:: /images/retention/minio-versioning-delete-object.svg
         :alt: Deleting an Object
         :align: center

      Performing a ``DELETE`` operation on a versioned object produces a 
      ``DeleteMarker`` for that object.

   .. card:: Reading a Deleted Object

      .. image:: /images/retention/minio-versioning-retrieve-deleted-object.svg
         :alt: Object with Multiple Versions
         :align: center

      Clients by default retrieve the "latest" object version. MinIO returns
      a ``404``-like response if the latest version is a ``DeleteMarker``.

   .. card:: Retrieve Previous Version of Deleted Object

      .. image:: /images/retention/minio-versioning-retrieve-version-before-delete.svg
         :alt: Retrieve Version of Deleted Object
         :align: center

      Clients can retrieve any previous version of the object by specifying the
      version ID, even if the "Latest" version is a ``DeleteMarker``.

   .. card:: Delete a Specific Object Version

      .. image:: /images/retention/minio-versioning-delete-specific-version.svg
         :alt: Retrieve Version of Deleted Object
         :align: center

      Clients can delete a specific object version by specifying the version ID
      as part of the ``DELETE`` operation. Deleting a specific version is 
      **permanent** and does not result in the creation of a ``DeleteMarker``.

The following :mc:`mc` commands operate on ``DeleteMarkers`` or versioned 
objects:

- Use :mc-cmd:`mc ls --versions` to view all versions of an object,
  including delete markers.

- Use :mc-cmd:`mc cp --version-id=UUID ... <mc cp --version-id>` to 
  retrieve the version of the "deleted" object with matching ``UUID``.

- Use :mc-cmd:`mc rm --version-id=UUID ... <mc rm --version-id>` to delete
  the version of the object with matching ``UUID``.

- Use :mc-cmd:`mc rm --versions` to delete *all* versions of an object.

Tutorials
---------

Enable Bucket Versioning
~~~~~~~~~~~~~~~~~~~~~~~~

You can enable versioning using the MinIO Console, the MinIO :mc:`mc` CLI, or
using an S3-compatible SDK.

.. tab-set::

   .. tab-item:: MinIO Console

      Select the :guilabel:`Buckets` section of the MinIO Console to access bucket creation and management functions. You can use the :octicon:`search` :guilabel:`Search` bar to filter the list. 
      
      .. image:: /images/minio-console/console-bucket.png
         :width: 600px
         :alt: MinIO Console Bucket Management
         :align: center

      Each bucket row has a :guilabel:`Manage` button that opens the management view for that bucket. 

      .. image:: /images/minio-console/console-bucket-manage.png
         :width: 600px
         :alt: MinIO Console Bucket Management
         :align: center

      Toggle the :guilabel:`Versioning` field to enable versioning on the bucket.

      The MinIO Console also supports enabling versioning as part of bucket
      creation. See :ref:`minio-console-buckets` for more information on
      bucket management using the MinIO Console.

   .. tab-item:: MinIO CLI

      Use the :mc:`mc version enable` command to enable versioning on an 
      existing bucket:

      .. code-block:: shell
         :class: copyable

         mc version ALIAS/BUCKET

      - Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured 
        MinIO deployment.

      - Replace ``BUCKET`` with the 
        :mc-cmd:`target bucket <mc version enable ALIAS>` on which to enable
        versioning.

Objects created prior to enabling versioning have a 
``null`` :ref:`version ID <minio-bucket-versioning-id>`.


Exclude a Prefix From Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can exclude certain :ref:`prefixes <minio-admin-concepts-organize-objects>` from versioning using the :ref:`MinIO Client <minio-client>`.
This is useful for Spark/Hadoop workloads or others that initially create objects with temporary prefixes. 

.. admonition:: Replication and Object Locking Require Versioning
   :class: note

   MinIO requires versioning to support :term:`replication`.
   Objects in excluded prefixes do not replicate to any peer site or remote site.

   MinIO does not support excluding prefixes from versioning on buckets with :ref:`object locking enabled <minio-object-locking>`.

- Use :mc:`mc version enable` with the :mc-cmd:`~mc version enable --excluded-prefixes` option:

  .. code-block:: shell
     :class: copyable

     mc version enable --excluded-prefixes "prefix1, prefix2" ALIAS/BUCKET

  - Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

  - Replace ``BUCKET`` with the name of the :s3-docs:`bucket <UsingBucket.html>` you want to exclude :ref:`prefixes <minio-admin-concepts-organize-objects>` for.

The list of :mc-cmd:`~mc version enable --excluded-prefixes` prefixes match all objects containing the specified strings in their prefix or name, similar to a regular expression of the form ``prefix*``.
To match objects by prefix only, use ``prefix/*``.

For example, the following command excludes any objects containing ``_test`` or ``_temp`` in their prefix or name from versioning:

  .. code-block:: shell
     :class: copyable

     mc version enable --excluded-prefixes "_test, _temp" local/my-bucket

You can exclude up to 10 prefixes for each bucket.
To add or remove prefixes, repeat the :mc:`mc version enable` command with an updated list.
The new list of prefixes replaces the previous one.

To view the currently excluded prefixes, use :mc:`mc version info` with the ``--json`` option:

  .. code-block:: shell
     :class: copyable

     mc version info ALIAS/BUCKET --json

The command output resembles the following, with the list of excluded prefixes in the ``ExcludedPrefixes`` property:

.. code-block:: shell

     $ mc version info local/my-bucket --json
     {
      "Op": "info",
      "status": "success",
      "url": "local/my-bucket",
      "versioning": {
       "status": "Enabled",
       "MFADelete": "",
       "ExcludedPrefixes": [
        "prefix1, prefix2"
       ]
      }
     }

To disable prefix exclusion and resume versioning all prefixes, repeat the :mc:`mc version enable` command without :mc-cmd:`~mc version enable --excluded-prefixes`:

  .. code-block:: shell
     :class: copyable

     mc version enable ALIAS/BUCKET

     
Exclude Folders from Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can exclude folders from versioning using the :ref:`MinIO Client <minio-client>`.

.. admonition:: Replication and Object Locking Require Versioning
   :class: note

   MinIO requires versioning to support :term:`replication`.
   Objects in excluded folders do not replicate to any peer site or remote site.

   MinIO does not support excluding folders from versioning on buckets with :ref:`object locking enabled <minio-object-locking>`.

.. admonition:: Object locking
   :class: note

   Buckets with :ref:`object locking enabled <minio-object-locking>` require versioning and do not support excluding folders.

- Use :mc:`mc version enable` with the :mc-cmd:`~mc version enable --exclude-folders` option to exclude objects with names ending in ``/`` from versioning:

  .. code-block:: shell
     :class: copyable

     mc version enable --exclude-folders ALIAS/BUCKET

  - Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

  - Replace ``BUCKET`` with the :s3-docs:`bucket <UsingBucket.html>` you want to exclude :ref:`folders <minio-admin-concepts-organize-objects>` for.

To check whether folders are versioned for a bucket, use the :mc:`mc version enable` command with the ``--json`` option.
If the ``ExcludeFolders`` property is ``true``, folders in that bucket are not versioned.

  .. code-block:: shell
     :class: copyable

     mc version enable --excluded-prefixes ALIAS/BUCKET --json

The command output resembles the following:

.. code-block:: shell

     $ mc version info local/my-bucket --json
     {
      "Op": "info",
      "status": "success",
      "url": "local/my-bucket",
      "versioning": {
       "status": "Enabled",
       "MFADelete": "",
       "ExcludeFolders": true
      }
     }

To disable folder exclusion and resume versioning all folders, repeat the :mc:`mc version enable` command without :mc-cmd:`~mc version enable --exclude-folders`:

  .. code-block:: shell
     :class: copyable

     mc version enable ALIAS/BUCKET


Suspend Bucket Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~

You can suspend bucket versioning at any time using the MinIO Console, the
MinIO :mc:`mc` CLI, or using an S3-compatible SDK.

.. tab-set::

   .. tab-item:: MinIO Console

      Select the :guilabel:`Buckets` section of the MinIO Console to access bucket creation and management functions. You can use the :octicon:`search` :guilabel:`Search` bar to filter the list. 
      
      .. image:: /images/minio-console/console-bucket.png
         :width: 600px
         :alt: MinIO Console Bucket Management
         :align: center

      Each bucket row has a :guilabel:`Manage` button that opens the management view for that bucket.

      .. image:: /images/minio-console/console-bucket-manage.png
         :width: 600px
         :alt: MinIO Console Bucket Management
         :align: center

      Select the :guilabel:`Versioning` field and follow the instructions to suspend versioning in the bucket.

      See :ref:`minio-console-buckets` for more information on bucket
      management using the MinIO Console.

   .. tab-item:: MinIO CLI

      Use the :mc:`mc version suspend` command to enable versioning on an 
      existing bucket:

      .. code-block:: shell
         :class: copyable

         mc version suspend ALIAS/BUCKET

      - Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured 
        MinIO deployment.

      - Replace ``BUCKET`` with the 
        :mc-cmd:`target bucket <mc mb ALIAS>` on which to disable
        versioning.

Objects created while versioning is suspended are assigned a ``null`` :ref:`version ID <minio-bucket-versioning-id>`. 
Any mutations to an object while versioning is suspended result in overwriting that ``null`` versioned object. 
MinIO does not remove or otherwise alter existing versioned objects as part of suspending versioning. 
Clients can continue interacting with any existing object versions in the bucket.
