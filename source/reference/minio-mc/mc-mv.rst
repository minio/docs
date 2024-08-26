=========
``mc mv``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc mv

Syntax
------

.. start-mc-mv-desc

The :mc:`mc mv` command moves an object from source to the target, such as
between MinIO deployments *or* between buckets on the same MinIO deployment.
:mc:`mc mv` also supports moving objects between a local filesystem and MinIO.

.. end-mc-mv-desc

You can also use :mc:`mc mv` against the local filesystem to produce
similar results to the ``mv`` commandline tool.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command moves objects from the ``mydata`` bucket to the
      ``archive`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc mv --recursive myminio/mydata myminio/archive

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] mv         \
         [--attr "string"]           \
         [--disable-multipart]       \
         [--enc-kms "string"]        \
         [--enc-s3 "string"]         \
         [--enc-c "string"]          \
         [--limit-download string]   \
         [--limit-upload string]     \
         [--newer-than "string"]     \
         [--older-than "string"]     \
         [--preserve]                \
         [--recursive]               \
         [--storage-class "string"]  \
         SOURCE [SOURCE...]          \
         TARGET

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: SOURCE
   :required:

  The object or objects to move. 
   
   For moving an object from a MinIO bucket, specify the :ref:`alias <alias>`
   and the full path to the object(s) (e.g. bucket and path to objects). For
   example:

   .. code-block:: shell

      mc mv play/mybucket/object.txt play/myotherbucket/object.txt

   For moving an object from a local filesystem, specify the full path to that
   object. For example:

   .. code-block:: shell

      mc mv ~/mydata/object.txt play/mybucket/object.txt
   
   Specify multiple ``SOURCE`` paths to move multiple objects to the
   specified :mc-cmd:`~mc mv TARGET`. :mc:`mc rm` treats the
   *last* specified alias or filesystem path as the ``TARGET``. For example:

   .. code-block:: shell

      mc mv ~/mydata/object.txt play/mydata/otherobject.txt myminio/mydata

   If you specify a directory or bucket to :mc-cmd:`~mc mv SOURCE`, you must
   also specify :mc-cmd:`~mc mv --recursive` to recursively move the
   contents of that directory. If you omit the :mc-cmd:`~mc mv --recursive`
   argument, :mc:`~mc mv` only moves objects in the top level of the specified
   directory or bucket.

.. mc-cmd:: TARGET
   :required:

   The full path to the bucket to which the command moves the
   object(s) at the specified :mc-cmd:`~mc mv SOURCE`. Specify the 
   :ref:`alias <alias>` of a configured S3 service as the prefix to the 
   :mc-cmd:`~mc mv TARGET` path. 

   For moving an object from MinIO,
   specify the :ref:`alias <alias>` and hte full path to the object(s)
   (e.g. bucket and path to objects). For example:

   .. code-block:: shell

      mc mv play/mybucket/object.txt play/myotherbucket/object.txt

   For moving an object from a local filesystem, specify the full path to that
   object. For example:

   .. code-block:: shell

      mc mv ~/mydata/object.txt play/mybucket/object.txt

   The ``TARGET`` object name can differ from the ``SOURCE`` to 
   "rename" the object as part of the move operation. 

   If running :mc:`mc mv` with the :mc-cmd:`~mc mv --recursive` option, 
   :mc:`mc mv` treats the ``TARGET`` as the bucket prefix for all
   objects at the ``SOURCE``. 

.. mc-cmd:: --attr
   :optional:

   Add custom metadata for the object. Specify key-value pairs as ``KEY=VALUE\;``. 
   For example, ``--attr key1=value1\;key2=value2\;key3=value3``.

.. mc-cmd:: --disable-multipart
   :optional:

   Disables the multipart upload feature.

   Multipart upload breaks an object into a set of separate parts.
   Each part uploads individually and in any order.
   If any individual part upload fails, MinIO retries that part without affecting the other parts.
   After upload completes, the parts combine to restore the original object.

   MinIO recommends using multipart upload for any object larger than 100 MB.
   For more information on multipart upload, refer to the :s3-docs:`Amazon S3 documentation <mpuoverview.html>`

.. block include of enc-c , enc-s3, and enc-kms

.. include:: /includes/common-minio-sse.rst
   :start-after: start-minio-mc-sse-options
   :end-before: end-minio-mc-sse-options


.. include:: /includes/linux/minio-client.rst
   :start-after: start-mc-limit-flags-desc
   :end-before: end-mc-limit-flags-desc

.. mc-cmd:: --newer-than
   :optional:

   Remove object(s) newer than the specified number of days.  Specify
   a string in ``##d#hh#mm#ss`` format. For example: 
   ``--newer-than 1d2hh3mm4ss``.

   Defaults to ``0`` (all objects).

.. mc-cmd:: --older-than
   :optional:

   Remove object(s) older than the specified time limit. Specify a
   string in ``#d#hh#mm#ss`` format. For example: ``--older-than 1d2hh3mm4ss``.
      
   Defaults to ``0`` (all objects).

.. mc-cmd:: --preserve, a
   :optional:

   Preserve file system attributes and bucket policy rules of the
   :mc-cmd:`~mc mv SOURCE` directories, buckets, and objects on the 
   :mc-cmd:`~mc mv TARGET` bucket(s).

.. mc-cmd:: --recursive, r
   :optional:
   
   Recursively move the contents of each bucket or directory
   :mc-cmd:`~mc mv SOURCE` to the :mc-cmd:`~mc mv TARGET` bucket.

.. mc-cmd:: --storage-class
   :optional:

   Set the storage class for the new object(s) on the 
   :mc-cmd:`~mc mv TARGET`. 
         
   See the Amazon documentation on
   :aws-docs:`Storage Classes <AmazonS3/latest/dev/storage-class-intro.html>` 
   for more information on S3 storage classses.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Examples
--------

Move Files from Filesystem to S3-Compatible Host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc mv [--recursive] FILEPATH ALIAS/PATH

- Replace :mc-cmd:`FILEPATH <mc mv SOURCE>` with the full file path to the
  file to move. 

  If specifying the path to a directory, include the 
  :mc-cmd:`~mc mv --recursive` flag.

  :mc:`mc mv` *removes* the files from the source after
  successfully moving it to the destination.

- Replace :mc-cmd:`ALIAS <mc mv TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mv TARGET>` with the destination bucket.

Move a File from Filesystem to S3-Compatible Host with Custom Metadata
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mv` with the :mc-cmd:`~mc mv --attr` option to set custom
attributes on file(s).

.. code-block:: shell
   :class: copyable

   mc mv --attr "ATTRIBUTES" FILEPATH ALIAS/PATH

- Replace :mc-cmd:`FILEPATH <mc mv SOURCE>` with the full file path to the
  file to move. :mc:`mc mv` *removes* the file from the source after
  successfully moving it to the destination.

- Replace :mc-cmd:`ALIAS <mc mv TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mv TARGET>` with the destination bucket.

- Replace :mc-cmd:`ATTRIBUTES <mc mv --attr>` with one or more comma-separated
  key-value pairs ``KEY=VALUE``. Each pair represents one attribute key and
  value.

Move Bucket Between S3-Compatible Services
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

    mc mv --recursive SRCALIAS/SRCPATH TGTALIAS/TGTPATH

- Replace :mc-cmd:`SRCALIAS <mc mv SOURCE>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`SRCPATH <mc mv SOURCE>` with the path to the bucket.
  :mc:`mc mv` *removes* the bucket and its contents from the source after
  successfully moving it to the destination.

- Replace :mc-cmd:`TGTALIAS <mc mv TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`TGTPATH <mc mv TARGET>` with the path to the bucket.


Move File to S3-Compatible Host with Specific Storage Class
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc mv` with the :mc-cmd:`~mc mv --storage-class` option to set
the storage class on the destination S3-compatible host.

.. code-block:: shell
   :class: copyable

   mc mv --storage-class CLASS FILEPATH ALIAS/PATH

- Replace :mc-cmd:`CLASS <mc mv --storage-class>` with the storage class to 
  associate to the files.

- Replace :mc-cmd:`FILEPATH <mc mv SOURCE>` with the full file path to the
  file to move. :mc:`mc mv` *removes* the file from the source after
  successfully moving it to the destination.

- Replace :mc-cmd:`ALIAS <mc mv TARGET>` with the :mc-cmd:`alias <mc alias>`
  of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc mv TARGET>` with the destination bucket.

- Replace :mc-cmd:`ATTRIBUTES <mc mv --attr>` with one or more comma-separated
  key-value pairs ``KEY=VALUE``. Each pair represents one attribute key and
  value.

   mc mv --storage-class REDUCED_REDUNDANCY myobject.txt play/mybucket


Behavior
--------

Object Names on Move
~~~~~~~~~~~~~~~~~~~~

MinIO uses the :mc-cmd:`~mc mv SOURCE` object name when moving
the object to the :mc-cmd:`~mc mv TARGET` if no explicit target
object name is specified.

You can specify a different object name for the
:mc-cmd:`~mc mv TARGET` with the same object path to "rename"
an object. For example:

.. code-block:: shell

   mc mv play/mybucket/object.txt play/mybucket/myobject.txt

For recursive move operations (:mc-cmd:`mc mv --recursive`), MinIO
treats the ``TARGET`` path as a prefix for objects on the ``SOURCE``. 

Checksum Verification
~~~~~~~~~~~~~~~~~~~~~

:mc:`mc mv` verifies all move operations to object storage using MD5SUM
checksums. 

MinIO Trims Empty Prefixes on Object Removal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. |command| replace:: :mc:`mc mv`

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
