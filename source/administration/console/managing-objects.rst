
.. _minio-console-managing-objects:

================
Managing Objects
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

You can use the MinIO Console to perform several of the bucket and object interaction functions available in MinIO.
Depending on the permissions and IAM policies for the authenticated user, you can:

- :ref:`Browse, upload, revert, manage, and interact with objects <minio-console-object-browser>`.
- :ref:`Browse, create, and manage buckets <minio-console-buckets>`.

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
- Upload objects
- Download objects
- Share
- Preview
- Manage tags
- Inspect
- Display versions
- :ref:`Delete <minio-object-delete>`

.. versionadded:: Console v0.24.0

   View the status of uploading or downloading objects with the object manager button available on the top right corner of the Console.
   If you have not uploaded or downloaded any objects during the current session, the button does not appear.

.. versionchanged:: Console v0.35.0

   If you select multiple objects to download, MinIO creates a ZIP archive of those objects for downloading.
   You must unzip or uncompress this archive after downloading to access the files.

.. _minio-console-buckets:

.. _minio-console-admin-buckets:

Buckets
-------

The Console's :guilabel:`Bucket` section displays all buckets to which the authenticated user has :ref:`access <minio-policy>`.

Select :guilabel:`Create Bucket` to create a new bucket on the deployment.
MinIO validates bucket names.
To see the rules for bucket names, select :guilabel:`View Bucket Naming Rules`.

MinIO does not limit the total number of buckets allowed on a deployment.
However, MinIO recommends no more than 500,000 buckets per deployment as a general guideline.

While creating a bucket, you can enable :ref:`versioning <minio-bucket-versioning>`, :ref:`object locking <minio-object-locking>`, bucket size (quota) limits, and :ref:`retention rules <minio-object-locking-retention-modes>` (which require versioning).

.. versionchanged:: Console v0.35.0

   If you enable versioning, you can specify prefixes to exclude from versioning.

You can configure locking and versioning options only when you create the bucket.
You cannot change these settings for the bucket later.
