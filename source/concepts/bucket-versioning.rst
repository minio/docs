.. _minio-bucket-versioning:

=================
Bucket Versioning
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO supports keeping multiple "versions" of an object in a single bucket.
Write operations which would normally overwrite an existing object instead
result in the creation of a new versioned object. MinIO versioning protects from
unintended overwrites and deletions while providing support for "undoing" a
write operation. Bucket versioning also supports retention and archive policies.

<Diagram>

MinIO generates a unique immutable ID for each object. If a ``PUT`` request
contains an object name which duplicates an existing object, MinIO does *not*
overwrite the "older" object. Instead, MinIO retains all object versions while
considering the most recently written "version" of the object as "latest".
Applications retrieve the latest object version by default, but *may* retrieve
any other version in the history of that object. To view all versions of an
object or objects in a bucket, use the :mc-cmd-option:`mc ls versions` command.

By default, deleting an object does *not* remove all existing versions of
that object. Instead, MinIO places a "delete" marker for the object, such that
applications requesting only the latest object versions do not see the object.
Applications *may* retrieve earlier versions of that object. To completely
delete an object and its entire version history, use the
:mc-cmd-option:`mc rm versions` command. 

Enable Bucket Versioning
------------------------

Enabling bucket versioning on a MinIO deployment requires that the deployment
have *at least* four disks. Specifically, Bucket Versioning depends on
:ref:`Erasure Coding <minio-erasure-coding>`. For MinIO deployments that
meet the disk requirements, use the :mc-cmd:`mc version enable` command to
enable versioning on a specific bucket. 

The :mc-cmd:`mc version` command *may* work on other S3-compatible services
depending on their implementation of and support for the AWS S3 API.

Buckets with Existing Content
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After enabling bucket versioning, MinIO begins generating version IDs for
*new* objects created in the bucket. MinIO does *not* iterate through existing
objects to generate version IDs. Existing unversioned objects in a versioned
bucket have a ``null`` version ID.

Suspend Bucket Versioning
-------------------------

You can suspend bucket versioning at any time using 
:mc-cmd:`mc version disable`. MinIO retains all existing object versions. During
suspension, MinIO allows overwrites of any *unversioned* object. Applications
can continue referencing any existing object version.

You can later re-enable object versioning on the bucket. MinIO resumes
generating version IDs for *new* objects, and does not retroactively generate
version IDs for existing unversioned objects. MinIO lists unversioned
objects with a ``null`` version ID. 

Version ID Generation
---------------------

MinIO version ID's are DCE 1.1/RFC 4122-compliant Universally Unique Identifiers
(UUID) version 4. Each UUID is a random 128-bit number intended to have a high
likelihood of uniqueness over space and time, *and* that are computationally
difficult to guess. UUID's are globally unique that can be generated without
contacting a global registration authority. 

MinIO object version UUID's are *immutable* after creation. 

Versioning Dependent Features
-----------------------------

The following MinIO features *require* bucket versioning for functionality:

- Object Locking (:mc-cmd:`mc lock` and :mc-cmd-option:`mc mb with-lock`)
- Object Legal Hold (:mc-cmd:`mc legalhold`)
- Bucket Replication (:mc-cmd:`mc admin bucket remote` and :mc-cmd:`mc replicate`)