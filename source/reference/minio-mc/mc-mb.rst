=========
``mc mb``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc mb

Syntax
------

.. start-mc-mb-desc

The :mc:`mc mb` command creates a new bucket or directory at the
specified path. 

.. end-mc-mb-desc

You can also use :mc:`mc mb` against the local filesystem to produce
similar results to the ``mkdir -p`` commandline tool.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command creates a new bucket ``mydata`` on the
      ``myminio`` MinIO deployment. The command creates the bucket
      with :ref:`object locking enabled <minio-object-locking>`.

      .. code-block:: shell
         :class: copyable

         mc mb --with-locks myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] mb                   \
                          [--ignore-existing]  \
                          [--region "string"]  \
                          [--with-lock]        \
                          [--with-versioning]  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The MinIO or other S3-compatible service on which to create the new bucket.

   For creating a bucket on MinIO, specify the
   :ref:`alias <alias>` and the name of the bucket. For example:

   .. code-block:: none

      mc mb play/mybucket

   For creating a directory on a local filesystem, specify the full
   path to that directory. For example:

   .. code-block:: none

      mc mb ~/mydata/mydir

.. mc-cmd:: --ignore-existing, p
   :optional:

   Directs :mc:`mc mb` to do nothing if the bucket or directory already exists.

.. mc-cmd:: --region
   :optional:

   The region in which to create the specified bucket. 
   Has no effect if the specified :mc-cmd:`~mc mb ALIAS` is a filesystem directory.

   If not specified, default value is ``us-east-1``.

.. mc-cmd:: --with-lock, l
   :optional:

   Enables :ref:`object locking <minio-object-locking>` on the specified bucket.
   Object locking requires, and therefore implies, enabling object versioning.

   .. important::

      You can *only* enable object locking when creating the bucket. 
      Buckets created without object locking cannot use
      :ref:`Bucket Lifecycle Management <minio-lifecycle-management>` or
      :ref:`Bucket Object Locking <minio-object-locking>` functionality.

.. mc-cmd:: --with-versioning
   :optional:

   Enables :ref:`object versioning <minio-bucket-versioning>` on the new bucket.
   With versioning enabled, by default MinIO allows up to the maximum value of an Int64 versions per object, or over 9.2 quintillion.
   Define :ref:`object expiration <minio-lifecycle-management-create-expiry-rule>` rules to remove versions of objects no longer needed, such as by the number of versions or the date of versions.

   Versioning is required for :ref:`bucket replication <minio-bucket-replication>` or :ref:`site replication <minio-site-replication-overview>`.
   Versioning does not imply or require object locking.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Create Bucket with Object Locking
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mb` to create a bucket on an S3-compatible host. 
The :mc-cmd:`~mc mb --with-lock` option creates the bucket with locking enabled:

.. code-block:: shell
   :class: copyable

   mc mb --with-lock ALIAS/BUCKET

- Replace :mc-cmd:`ALIAS <mc mb ALIAS>` with the :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`BUCKET <mc mb ALIAS>` with the bucket to create.

Create a New Bucket in a Specific Region
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mb` to create a bucket on an S3-compatible host.
The :mc-cmd:`~mc mb --region` option creates the bucket in a desired region.

.. code-block:: shell
   :class: copyable

   mc mb --region --region=us-west-2 myminio/mynewbucket

The above command creates a new bucket, ``mynewbucket`` on the ``myminio`` bucket within the ``us-west-2`` region.

Create a New Bucket with Versioning Enabled
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc mb --with-versioning myminio/myversionedbucket

The above command creates a new bucket, ``myversionedbucket``, on the ``myminio`` alias.
The new bucket enables :ref:`object versioning <minio-bucket-versioning>` for all objects in the bucket.

Behavior
--------

Bucket Limits Per Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO does not limit the number of buckets you can create on a deployment.
However, MinIO recommends no more than 500,000 buckets per deployment as a general guideline.

Bucket Limits for Non-MinIO S3 Services
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Certain S3 services may restrict the number of buckets a given user or account
can create. For example, Amazon S3 limits each account to 
:s3-docs:`100 buckets <BucketRestrictions.html>`. :mc:`mc mb` may return an 
error if the user has reached bucket limits on the target S3 service.

MinIO Object Storage deployments do not place any limits on the number of
buckets each user can create.

Enable Object Locking at Bucket Creation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO follows 
:s3-docs:`AWS S3 behavior <object-lock-overview.html#object-lock-bucket-config>` 
where you *must* enable :ref:`object locking <minio-object-locking>` at
bucket creation. Buckets created without object locking can *never* enable object
retention or locking.

Enabling bucket locking does *not* set any object locking or retention settings.
Consider enabling bucket locking as standard practice.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
