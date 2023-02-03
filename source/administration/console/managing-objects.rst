
.. _minio-console-managing-objects:

================
Managing Objects
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

You can use the MinIO Console to perform several of the bucket and object management and interaction functions available in MinIO.
Depending on the permissions and IAM policies for the authenticated user, you can:

- :ref:`Browse, upload, revert, manage, and interact with objects <minio-console-object-browser>`.
- :ref:`Browse, create, and manage buckets <minio-console-buckets>`.
- :ref:`Create or monitor remote tiers <minio-console-tiers>` for object transition rules.

.. _minio-console-object-browser:

Object Browser
--------------

The Object Browser lists the buckets and objects the authenticated user has access to on the deployment.

After logging in or navigating to the tab, the object browser displays a list of the user's buckets, which the user can filter.
Select a bucket to show a list of objects in the bucket.

Select a specific object to display summary information about the object such as name, size, tags, holds, and retention policies that apply.
The console also shows the object's metadata.

The user can perform actions on the bucket's objects, depending on the policies and permissions that apply.
Example actions the user may be able to perform include:

- Rewind to a previous version
- Create prefixes
- View deleted objects
- Download
- Share
- Preview
- Manage legal holds
- Manage retention
- Manage tags
- Inspect
- Display versions
- Delete

.. _minio-console-buckets:

.. _minio-console-admin-buckets:

Buckets
-------

The Console's :guilabel:`Bucket` section displays all buckets to which the authenticated user has :ref:`access <minio-policy>`.
Use this section to create or manage these buckets, depending on your user's access.

Creating Buckets
~~~~~~~~~~~~~~~~

Select :guilabel:`Create Bucket` to create a new bucket on the deployment.
MinIO validates bucket names.
To see the rules for bucket names, select :guilabel:`View Bucket Naming Rules`.

MinIO does not limit the total number of buckets allowed on a deployment.
However, MinIO recommends no more than 500,000 buckets per deployment as a general guideline.

While creating a bucket, you can enable :ref:`versioning <minio-bucket-versioning>`, :ref:`object locking <minio-object-locking>`, bucket size (quota) limits, and :ref:`retention rules <minio-object-locking-retention-modes>` (which require versioning).

You **must** configure replication, locking, and versioning options at the time of bucket creation.
You cannot change these settings for the bucket later.

Managing Buckets
~~~~~~~~~~~~~~~~

Use the :guilabel:`Search` bar to filter for specific buckets.
Select the row for the bucket to display summary information about the bucket.

Form the summary screen, select any of the available tabs to further manage the bucket.

.. note::

   Some management features may not be available if the authenticated user does not have the :ref:`required administrative permissions <minio-policy-mc-admin-actions>`.

When managing a bucket, your access settings may allow you to view or change any of the following:

- The :guilabel:`Summary` section displays a summary of the bucket's configuration.

  Use this section to view and modify the bucket's access policy, encryption, quota, and tags.

- Configure alerts in the :guilabel:`Events` section to trigger :ref:`notification events <minio-bucket-notifications>` when a user uploads, accesses, or deletes matching objects.

- Copy objects to remote locations in the :guilabel:`Replication` section with :ref:`Server Side Bucket Replication Rules <minio-bucket-replication-serverside>`.

- Expire or transition objects in the bucket from the :guilabel:`Lifecycle` section by setting up :ref:`Object Lifecycle Management Rules <minio-lifecycle-management>`.

- Review security in the :guilabel:`Access` section by listing the :ref:`policies <minio-policy>` and :ref:`users <minio-users>` with access to that bucket.

- Properly secure unauthenticated access with the :guilabel:`Anonymous` section by managing rules for prefixes that unauthenticated users can use to read or write objects.

.. _minio-console-tiers:

Tiers
-----

The :guilabel:`Tiers` section provides an interface for adding and managing :ref:`remote tiers <minio-lifecycle-management-tiering>` to support lifecycle management transition rules.
MinIO tiering supports moving objects from the deployment to the remote storage, but does not support automatically restoring them to the deployment.

The tiering tab allows users with the appropriate permissions to:

- Review the status and summary information for all configured remote tiers.
- Create a tier for a new remote target to storage on another MinIO deployment, Google Cloud Storage, Amazon's AWS S3, or Azure.
- Cycle the access credentials for any of the configured tiers with the tier's :octicon:`pencil` icon.