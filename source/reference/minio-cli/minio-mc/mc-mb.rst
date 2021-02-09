=========
``mc mb``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc mb

Description
-----------

.. start-mc-mb-desc

The :mc:`mc mb` command creates a new bucket or directory at the
specified path. For targets on an S3-compatible service, :mc:`mc mb`
creates a new bucket. For targets on a filesystem, :mc:`mc mb` has
equivalent functionality to ``mkdir -p``. 

.. end-mc-mb-desc

Bucket Limits for Non-MinIO S3 Services
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Certain S3 services may restrict the number of buckets a given user or account
can create. For example, Amazon S3 limits each account to 
:s3-docs:`100 buckets <BucketRestrictions.html>`. :mc:`mc mb` may return an 
error if the user has reached bucket limits on the target S3 service.

MinIO Object Storage deployments do not place any limits on the number of
buckets each user can create.

Examples
--------

Create Bucket
~~~~~~~~~~~~~

Use :mc:`mc mb` to create a bucket on an S3-compatible host. The 
:mc-cmd-option:`~mc mb with-lock` option creates the bucket with locking
enabled:

.. code-block:: shell
   :class: copyable

   mc mb --with-lock ALIAS/BUCKET

- Replace :mc-cmd:`ALIAS <mc mb TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`BUCKET <mc mb TARGET>` with the bucket to create.

Syntax
------

:mc:`~mc mb` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc mb [FLAGS] TARGET [TARGET...]

:mc:`~mc mb` supports the following arguments:

.. mc-cmd:: TARGET

   *Required* The full path to the bucket or directory to create. If
   creating a directory on a filesystem, :mc:`mc mb` creates all required
   folders in the specified path similar to ``mkdir -p``. 

   To create a bucket, specify the :mc-cmd:`alias <mc alias>` of a configured
   S3 service as the prefix to the ``TARGET`` path. For example:

   .. code-block:: shell

      mc mb [FLAGS] play/mybucket

.. mc-cmd:: region
   :option:

   The region in which to create the specified bucket. Has no effect if the
   specified :mc-cmd:`~mc mb TARGET` is a filesystem directory.

.. mc-cmd:: ignore-existing, p
   :option:

   Directs :mc-cmd:`mc mb` to do nothing if the bucket or directory already
   exists.

.. mc-cmd:: with-lock, l
   :option:

   Enables object locking on the specified bucket. Has no effect if the
   specified :mc-cmd:`~mc mb TARGET` is a filesystem directory.

   .. important::

      You can *only* enable object locking when creating the bucket. 
      You cannot use features like Bucket Lifecycle Management, 
      Bucket Object Retention, or Bucket Legal Hold if object locking is
      disabled for a bucket.

