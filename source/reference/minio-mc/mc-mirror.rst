=============
``mc mirror``
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc mirror

Syntax
------

.. start-mc-mirror-desc

The :mc:`mc mirror` command synchronizes content to MinIO deployment, similar to
the ``rsync`` utility. :mc:`mc mirror` supports filesystems, MinIO deployments,
and other S3-compatible hosts as the synchronization source.

.. end-mc-mirror-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command synchronizes content from a local filesystem
      directory to the ``mydata`` bucket on the ``myminio`` MinIO deployment.

      .. code-block:: shell
         :class: copyable

         mc mirror --watch ~/mydata myminio/mydata

      The command "watches" the local filesystem and synchronizes any additional
      operations to MinIO until explicitly terminated from the terminal:

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] mirror                           \
                          [--attr "string"]                \
                          [--disable-multipart]            \
                          [--encrypt-key "string"]         \
                          [--exclude "string"]             \
                          [--fake]                         \
                          [--md5]                          \
                          [--monitoring-address "string"]  \
                          [--newer-than "string"]          \
                          [--older-than "string"]          \
                          [--preserve]                     \
                          [--region "string"]              \
                          [--remove]                       \
                          [--storage-class "string"]       \
                          [--watch]                        \
                          SOURCE                           \ 
                          TARGET

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: SOURCE

   *REQUIRED* The file(s) or object(s) to synchronize to the 
   :mc-cmd:`~mc mirror TARGET` S3 host.

   For objects on S3-compatible hosts, specify the path to the object as 
   ``ALIAS/PATH``, where:

   - ``ALIAS`` is the :mc:`alias <mc alias>` of a configured S3-compatible host,
     *and*

   - ``PATH`` is the path to the bucket or object. If specifying a bucket,
     :mc:`mc mirror` synchronizes all objects in the bucket.

   .. code-block:: shell

      mc mirror [FLAGS] play/mybucket/ myminio/mybucket

   For files on a filesystem, specify the full filesystem path to the file or
   directory :

   .. code-block:: shell

      mc mirror [FLAGS] ~/data/ myminio/mybucket

   If specifying a directory, :mc-cmd:`mc mirror` synchronizes all files in the
   directory.

.. mc-cmd:: TARGET

   *REQUIRED* The full path to bucket in which :mc:`mc mirror` copies
   synchronized SOURCE objects. Specify the ``TARGET`` as
   ``ALIAS/PATH``, where:

   - ``ALIAS`` is the :mc:`alias <mc alias>` of a configured S3-compatible
     host, *and*

   - ``PATH`` is the path to the bucket.

   .. code-block:: shell

      mc mirror SOURCE play/mybucket

   :mc:`mc mirror` uses the object or file names from the
   :mc-cmd:`~mc mirror SOURCE` when synchronizing to the ``TARGET`` bucket.

.. mc-cmd:: --attr
   

   Add custom metadata for mirrored objects. Specify key-value pairs as 
   ``KEY=VALUE\;``. For example, 
   ``--attr key1=value1\;key2=value2\;key3=value3``.

.. mc-cmd:: --disable-multipart
   

   Disables multipart upload for the copy session.

.. mc-cmd:: --encrypt-key
   

   Encrypt or decrypt objects using server-side encryption with
   client-specified keys. Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting 
      object(s).

   Enclose the entire list of key-value pairs passed to 
   :mc-cmd:`~mc mirror --encrypt-key` in double quotes ``"``.

   :mc-cmd:`~mc mirror --encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for retrieving a list of encryption key-value pairs
   as an alternative to specifying them on the command line.

   You can only delete encrypted objects if you specify the correct
   :mc-cmd:`~mc mirror --encrypt-key` secret key.

.. mc-cmd:: --exclude
   

   Exclude object(s) in the :mc-cmd:`~mc mirror SOURCE` path that
   match the specified object name pattern.

.. mc-cmd:: --fake
   

   Perform a fake mirror operation. Use this operation to perform 
   validate that the :mc:`mc mirror` operation will only
   mirror the desired objects or buckets.

.. mc-cmd:: md5
   

   Forces all uploads to calculate MD5 checksums. 

.. mc-cmd:: --monitoring-address
   

   Creates a `Prometheus <https://prometheus.io/>`__ endpoint for monitoring
   mirroring activity. Specify the local network adapter and port address on
   which to create the scraping endpoint. Defaults to ``localhost:8081``).

.. mc-cmd:: --newer-than
   

   Mirror object(s) newer than the specified number of days.  Specify a
   string in ``#d#hh#mm#ss`` format. For example: 
   ``--older-than 1d2hh3mm4ss``.

.. mc-cmd:: --older-than
   

   Mirror object(s) older than the specified time limit. Specify a string
   in ``#d#hh#mm#ss`` format. For example: ``--older-than 1d2hh3mm4ss``.
      
   Defaults to ``0`` (all objects).

.. mc-cmd:: --overwrite
   
   
   Overwrites object(s) on the :mc-cmd:`~mc mirror TARGET`.

.. mc-cmd:: --preserve, a
   

   Preserve file system attributes and bucket policy rules of the
   :mc-cmd:`~mc mirror SOURCE` on the
   :mc-cmd:`~mc mirror TARGET`.

.. mc-cmd:: --region
   

   Specify the ``string`` region when creating new bucket(s) on the
   target. 

   Defaults to ``"us-east-1"``.

.. mc-cmd:: --remove
   

   Removes extraneous object(s) on the target. 

.. mc-cmd:: storage-class, sc
   

   Set the storage class for the new object(s) on the 
   :mc-cmd:`~mc mirror TARGET`. 
         
   See the Amazon documentation on
   :aws-docs:`Storage Classes <AmazonS3/latest/dev/storage-class-intro.html>` 
   for more information on S3 storage classses.

.. mc-cmd:: --watch, w
   

   Continuously monitor the :mc-cmd:`~mc mirror SOURCE` path and
   synchronize changes.

   Defaults to ``0`` (all objects).

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Mirror a Local Directory to an S3-Compatible Host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mirror` to mirror files from a filesystem to an S3 Host:

.. code-block::
   :class: copyable

   mc mirror FILEPATH ALIAS/PATH

- Replace :mc-cmd:`FILEPATH <mc mirror SOURCE>` with the full file path to the
  directory to mirror.

- Replace :mc-cmd:`ALIAS <mc mirror TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mirror TARGET>` with the destination bucket.

Continuously Mirror a Local Directory to an S3-Compatible Host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mirror` with :mc-cmd:`~mc mirror --watch` to continuously mirror
files from a filesystem to an S3-compatible host:

.. code-block::
   :class: copyable

   mc mirror FILEPATH ALIAS/PATH

- Replace :mc-cmd:`FILEPATH <mc mirror SOURCE>` with the full file path to the
  directory to mirror.

- Replace :mc-cmd:`ALIAS <mc mirror TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mirror TARGET>` with the destination bucket.

Continuously Mirror S3 Bucket to an S3-Compatible Host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mirror` with :mc-cmd:`~mc mirror --watch` to continuously
mirror objects in a bucket on one S3-compatible host to another S3-compatible
host.

.. code-block::
   :class: copyable

   mc mirror --watch SRCALIAS/SRCPATH TGTALIAS/TGTPATH

- Replace :mc-cmd:`SRCALIAS <mc mirror SOURCE>` with :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`SRCPATH <mc mirror SOURCE>` with the bucket to mirror.

- Replace :mc-cmd:`TGTALIAS <mc mirror TARGET>` with the 
  :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`TGTPATH <mc mirror TARGET>` with the destination bucket.

Behavior
--------

MinIO Trims Empty Prefixes on Object Removal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :mc-cmd:`mc mirror --watch` command continuously synchronizes the
source and destination targets. This includes automatically removing objects
on the destination if they are removed on the source.

.. |command| replace:: :mc-cmd:`mc mirror --watch`

.. include:: /includes/common-admonitions.rst
   :start-after: start-remove-api-trims-prefixes
   :end-before: end-remove-api-trims-prefixes

.. include:: /includes/common-admonitions.rst
   :start-after: start-remove-api-trims-prefixes-fs
   :end-before: end-remove-api-trims-prefixes-fs

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
