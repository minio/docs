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

The :mc:`mc mirror` command synchronizes content to MinIO deployment, similar to the ``rsync`` utility.
:mc:`mc mirror` supports filesystems, MinIO deployments, and other S3-compatible hosts as the synchronization source.

.. end-mc-mirror-desc

.. note::
   
   :mc:`mc mirror` only synchronizes the current object without any version information or metadata.
   To synchronize an object's version history and metadata, consider using :mc:`mc replicate` or :mc:`mc admin replicate`.


.. tab-set::

   .. tab-item:: EXAMPLE

      The following command synchronizes content from a local filesystem directory to the ``mydata`` bucket on the ``myminio`` MinIO deployment.

      .. code-block:: shell
         :class: copyable

         mc mirror --watch ~/mydata myminio/mydata

      The command "watches" for files added or removed on the local filesystem and synchronizes those operations to MinIO until explicitly terminated. 
      
      :mc-cmd:`mc mirror --watch` updates files changed on the local filesystem to MinIO (see :mc-cmd:`~mc mirror --overwrite`).
      ``--watch`` does not remove other files from MinIO not present on the local filesystem (see :mc-cmd:`~mc mirror --remove`).

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] mirror                            \
                          [--attr "string"]                 \
                          [--disable-multipart]             \
                          [--dry-run]                       \
                          [--encrypt-key "string"]          \
                          [--exclude "string"]              \
                          [--exclude-storageclass "string"] \
                          [--limit-download string]         \
                          [--limit-upload string]           \
                          [--md5]                           \
                          [--monitoring-address "string"]   \
                          [--newer-than "string"]           \
                          [--older-than "string"]           \
                          [--preserve]                      \
                          [--region "string"]               \
                          [--remove]                        \
                          [--storage-class "string"]        \
                          [--watch]                         \
                          SOURCE                            \ 
                          TARGET

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: SOURCE

   *REQUIRED* The file(s) or object(s) to synchronize to the :mc-cmd:`~mc mirror TARGET` S3 host.

   For objects on S3-compatible hosts, specify the path to the object as ``ALIAS/PATH``, where:

   - ``ALIAS`` is the :mc:`alias <mc alias>` of a configured S3-compatible host, *and*

   - ``PATH`` is the path to the bucket or object. If specifying a bucket, :mc:`mc mirror` synchronizes all objects in the bucket.

   .. code-block:: shell

      mc mirror [FLAGS] play/mybucket/ myminio/mybucket

   For files on a filesystem, specify the full filesystem path to the file or directory :

   .. code-block:: shell

      mc mirror [FLAGS] ~/data/ myminio/mybucket

   If specifying a directory, :mc:`mc mirror` synchronizes all files in the directory.

.. mc-cmd:: TARGET

   *REQUIRED* The full path to bucket to which :mc:`mc mirror` synchronizes SOURCE objects. Specify the ``TARGET`` as ``ALIAS/PATH``, where:

   - ``ALIAS`` is the :mc:`alias <mc alias>` of a configured S3-compatible host, *and*

   - ``PATH`` is the path to the bucket.

   .. code-block:: shell

      mc mirror SOURCE play/mybucket

   :mc:`mc mirror` uses the object or file names from the :mc-cmd:`~mc mirror SOURCE` when synchronizing to the ``TARGET`` bucket.

.. mc-cmd:: --attr
   

   Add custom metadata for mirrored objects. Specify key-value pairs as ``KEY=VALUE\;``. 
   For example, ``--attr key1=value1\;key2=value2\;key3=value3``.

.. mc-cmd:: --disable-multipart
   

   Disables multipart upload for the synchronization session.

.. mc-cmd:: --encrypt-key
   

   Encrypt or decrypt objects using server-side encryption with client-specified keys. 
   Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting object(s).

   Enclose the entire list of key-value pairs passed to :mc-cmd:``~mc mirror --encrypt-key`` in double quotes ``"``.

   :mc-cmd:`~mc mirror --encrypt-key` can use the ``MC_ENCRYPT_KEY`` environment variable for retrieving a list of encryption key-value pairs as an alternative to specifying them on the command line.

   You can only delete encrypted objects if you specify the correct :mc-cmd:`~mc mirror --encrypt-key` secret key.

.. mc-cmd:: --exclude
   

   Exclude object(s) in the :mc-cmd:`~mc mirror SOURCE` path that match the specified object name pattern.

.. mc-cmd:: --exclude-storageclass
   

   Exclude object(s) in the :mc-cmd:`~mc mirror SOURCE` path from the specified storage class.
   You can use this flag multiple times in a command to exclude objects from more than one storage class.

   Use this when migrating from AWS S3 to MinIO to exclude objects from ``GLACIER`` or ``DEEP_ARCHIVE`` storage.

.. mc-cmd:: --dry-run
   

   Perform a mock mirror operation. 
   Use this operation to test that the :mc:`mc mirror` operation will only mirror the desired objects or buckets.

.. --limit-download and --limit-upload included here

.. include:: /includes/linux/minio-client.rst
   :start-after: start-mc-limit-flags-desc
   :end-before: end-mc-limit-flags-desc

.. mc-cmd:: --md5
   

   Forces all uploads to calculate MD5 checksums. 

.. mc-cmd:: --monitoring-address
   

   Creates a `Prometheus <https://prometheus.io/>`__ endpoint for monitoring mirroring activity. 
   Specify the local network adapter and port address on which to create the scraping endpoint. 
   Defaults to ``localhost:8081``).

.. mc-cmd:: --newer-than
   

   Mirror object(s) newer than the specified number of days.  
   Specify a string in ``#d#hh#mm#ss`` format. 
   For example: ``--newer-than 1d2hh3mm4ss``.

.. mc-cmd:: --older-than
   

   Mirror object(s) older than the specified time limit. 
   Specify a string in ``#d#hh#mm#ss`` format. 
   For example: ``--older-than 1d2hh3mm4ss``.
      
   Defaults to ``0`` (all objects).

.. mc-cmd:: --overwrite
   
   
   Overwrites object(s) on the :mc-cmd:`~mc mirror TARGET`.

   For example, consider an active ``mc mirror --overwrite`` synchronizing content from Source to Destination.

   If an object on Source changes, ``mc mirror --overwrite`` synchronizes and overwrites any matching file on Destination.

   Without ``--overwrite``, if an object already exists on the Destination, the mirror process fails to synchronize that object.
   ``mc mirror`` logs an error and continues to synchronize other objects.

.. mc-cmd:: --preserve, a
   

   Preserve file system attributes and bucket policy rules of the :mc-cmd:`~mc mirror SOURCE` on the :mc-cmd:`~mc mirror TARGET`.

.. mc-cmd:: --region
   

   Specify the ``string`` region when creating new bucket(s) on the target. 

   Defaults to ``"us-east-1"``.

.. mc-cmd:: --remove
   

   Removes object(s) on the Target that do not exist on the Source. 

   Use the ``--remove`` flag to have the same list of objects on both Source and Target.

   For example, objects A, B, and C exist on Source.
   Objects C, D, and E exist on Target.

   When running ``mc mirror --remove``, objects A and B synchronize to Target and objects D and E are removed from Target.
   Since an object C already exists on both, nothing moves from Source to Target. 

   After the action, only objects A, B, and C exist on both the Source and the Target.

   ``mc mirror --remove`` does not verify that the contents of object C are the same on both Source and Target, only that an object called `C` exists on both.
   To ensure objects on the Source and Target match both names `and` content, use  :mc-cmd:`~mc mirror --overwrite` or :mc-cmd:`~mc mirror --watch`.

   .. versionchanged:: RELEASE.2023-05-04T18-10-16Z

      ``mc mirror --remove`` returns an error if the target path is a local filesystem directory that does not exist.

      In prior versions, specifying ``/path/to/directory`` would result in the removal of the ``/path/to`` folder if ``directory`` did not exist.

.. mc-cmd:: storage-class, sc
   

   Set the storage class for the new object(s) on the :mc-cmd:`~mc mirror TARGET`. 
         
   See the Amazon documentation on :aws-docs:`Storage Classes <AmazonS3/latest/dev/storage-class-intro.html>` for more information on S3 storage classses.

.. mc-cmd:: --watch, w
   

   Use ``--watch`` flag to mirror objects from Source to Target, where the Target may also have additional objects not present on the Source.

   - ``--watch`` continuously synchronizes files from Source to Target until explicitly terminated
   - The Target may have files that do not exist on Source
   - ``--watch`` overwrites objects on the Target if a match exists on Source, like the :mc-cmd:`~mc mirror --overwrite` flag

   Defaults to ``0`` (all objects).

   For example, object A and B exist on the watched Source.
   Objects A, B, and C exist on the watched Target.
   
   A client writes object D to Source and removes object B.

   After the operation, objects A and D exist on the Source.
   Objects A, C, and D exist on the Target.
 
   
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

- Replace :mc-cmd:`FILEPATH <mc mirror SOURCE>` with the full file path to the directory to mirror.

- Replace :mc-cmd:`ALIAS <mc mirror TARGET>` with the :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mirror TARGET>` with the destination bucket.

Continuously Mirror a Local Directory to an S3-Compatible Host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mirror` with :mc-cmd:`~mc mirror --watch` to continuously mirror files from a filesystem to an S3-compatible host where objects added to or deleted from the filesystem are added to or deleted from the host:

.. code-block::
   :class: copyable

   mc mirror --watch FILEPATH ALIAS/PATH

- Replace :mc-cmd:`FILEPATH <mc mirror SOURCE>` with the full file path to the directory to mirror.

- Replace :mc-cmd:`ALIAS <mc mirror TARGET>` with the :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mirror TARGET>` with the destination bucket.

Continuously Mirror S3 Bucket to an S3-Compatible Host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mirror` with :mc-cmd:`~mc mirror --watch` to continuously mirror objects in a bucket on one S3-compatible host to another S3-compatible host where objects added to or deleted from the bucket are added to or deleted from the host.

.. code-block::
   :class: copyable

   mc mirror --watch SRCALIAS/SRCPATH TGTALIAS/TGTPATH

- Replace :mc-cmd:`SRCALIAS <mc mirror SOURCE>` with :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`SRCPATH <mc mirror SOURCE>` with the bucket to mirror.

- Replace :mc-cmd:`TGTALIAS <mc mirror TARGET>` with the :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`TGTPATH <mc mirror TARGET>` with the destination bucket.

Mirror Objects from AWS S3 to MinIO Skipping Objects in GLACIER
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mirror` with :mc-cmd:`~mc mirror --exclude-storageclass` to mirror objects from AWS S3 to MinIO without mirroring objects in GLACIER or DEEP_ARCHIVE storage.

.. code-block::
   :class: copyable
   
   mc mirror --exclude-storageclass GLACIER  \
      --exclude-storageclass DEEP_ARCHIVE SRCALIAS/SRCPATH TGALIAS/TGPATH

- Replace :mc-cmd:`SRCALIAS <mc mirror SOURCE>` with the :mc-cmd:`alias <mc alias>` of a configured S3 host.

- Replace :mc-cmd:`SRCPATH <mc mirror SOURCE>` with the bucket to mirror.

- Replace :mc-cmd:`TGTALIAS <mc mirror TARGET>` with the :mc-cmd:`alias <mc alias>` of a configured S3 host.

- Replace :mc-cmd:`TGTPATH <mc mirror TARGET>` with the destination bucket.

Behavior
--------

Mirror Continues on Failed Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If an object of the same name exists on the target, MinIO outputs an error for the duplicate object.
``mc mirror`` continues to mirror other objects from the source to the destination after the error.

MinIO Trims Empty Prefixes on Object Removal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :mc-cmd:`mc mirror --watch` command continuously synchronizes the source and destination targets for added and deleted objects. 
This includes automatically removing objects on the destination if they are removed on the source.

For objects updated on the source to also update on the target, use `--overwrite`.
To remove objects from the target that are not on the source, use `--remove`.

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
