===========
``mc stat``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc stat

.. |command| replace:: :mc:`mc stat`
.. |rewind| replace:: :mc-cmd:`~mc stat --rewind`
.. |versions| replace:: :mc-cmd:`~mc stat --versions`
.. |versionid| replace:: :mc-cmd:`~mc stat --version-id`
.. |alias| replace:: :mc-cmd:`~mc stat ALIAS`

Syntax
-----------

.. start-mc-stat-desc

The :mc:`mc stat` command displays information on objects in a MinIO bucket, including object metadata.
You can also use it to retrieve bucket metadata.

.. end-mc-stat-desc

You can use :mc:`mc stat` against the local filesystem to produce similar results to the ``stat`` commandline tool.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command displays information on all objects in the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc stat --recursive myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] stat                      \
                          [--enc-c "value"]         \
                          [--no-list]               \
                          [--recursive]             \
                          [--rewind "string"]       \
                          [--versions]              \
                          [--version-id "string"]*  \
                          ALIAS [ALIAS ...]


      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

      :mc-cmd:`mc stat --version-id` is mutually exclusive with multiple parameters. See the reference documentation for more information.

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of a MinIO deployment and the full path to the object for which to retrieve detailed information. For example:

   .. code-block:: shell

      mc stat myminio/mybucket/myobject.txt

   You can specify multiple objects on the same or different MinIO deployments:

   .. code-block:: shell

      mc stat myminio/mybucket/myobject.txt myminio/mybucket/myobject.txt

   If specifying the path to a bucket or bucket prefix, you **must** include the :mc-cmd:`mc stat --recursive` flag:

   .. code-block:: shell

      mc stat --recursive myminio/mybucket/

   For retrieving information on a file from a local filesystem, specify the full path to that file:

   .. code-block:: shell

      mc stat ~/data/myobject.txt

.. block include of enc-c

.. include:: /includes/common-minio-sse.rst
   :start-after: start-minio-mc-sse-c-only
   :end-before: end-minio-mc-sse-options

.. mc-cmd:: --no-list
   :optional:

   Disable all ``LIST`` operations if the target does not exist.   

.. mc-cmd:: --recursive, r
   :optional:

   Recursively :mc:`mc stat` the contents of the MinIO bucket specified to :mc-cmd:`~mc stat ALIAS`.

.. mc-cmd:: --rewind
   :optional:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: --versions
   :optional:   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-versions-desc
      :end-before: end-versions-desc

   Use :mc-cmd:`~mc stat --versions` and  :mc-cmd:`~mc stat --rewind` together to remove all object versions which existed at a specific point in time.

.. mc-cmd:: --version-id, vid
   :optional:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

   Mutually exclusive with any of the following flags:
   
   - :mc-cmd:`~mc stat --versions`
   - :mc-cmd:`~mc stat --rewind`
   - :mc-cmd:`~mc stat --recursive`

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Display Object Details
~~~~~~~~~~~~~~~~~~~~~~

The following example displays details of the object ``myfile.txt`` in the bucket ``mybucket``:

.. code-block:: shell
   :class: copyable

   mc stat myminio/mybucket/myfile.txt

The output resembles the following:

.. code-block:: shell

   Name      : myfile.txt
   Date      : 2024-07-16 15:40:02 MDT 
   Size      : 6.0 KiB 
   ETag      : 3b38f7b05a0c42acdc377e60b2a74ddf 
   Type      : file 
   Metadata  :
     Content-Type: text/plain 

You can specify more than one object by adding multiple paths:

.. code-block:: shell
   :class: copyable

   mc stat myminio/mybucket/file1.txt myminio/yourbucket/file2.txt

To display detail for all objects in a bucket, use :mc-cmd:`~mc stat --recursive`.
The following example displays details for all objects in bucket ``mybucket``:

.. code-block:: shell
   :class: copyable

   mc stat --recursive myminio/mybucket

The output resembles the following:

.. code-block:: shell

   Name      : file1.txt
   Date      : 2024-07-16 15:40:02 MDT
   Size      : 6.0 KiB
   ETag      : 3b38f7b05a0c42acdc377e60b2a74ddf
   Type      : file
   Metadata  :
     Content-Type: text/plain

   Name      : file2.txt
   Date      : 2024-07-26 10:45:19 MDT
   Size      : 6.0 KiB
   ETag      : 3b38f7b05a0c42acdc377e60b2a74ddf
   Type      : file
   Metadata  :
     Content-Type: text/plain


Display Bucket Details
~~~~~~~~~~~~~~~~~~~~~~

The following example displays information about the bucket ``mybucket`` on the ``myminio`` MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc stat myminio/mybucket

The output resembles the following:

.. code-block:: shell

   Name      : mybucket
   Date      : 2024-07-26 10:56:43 MDT 
   Size      : N/A    
   Type      : folder 

   Properties:
     Versioning: Un-versioned
     Location: us-east-1
     Anonymous: Disabled
     ILM: Disabled

   Usage:
         Total size: 6.0 KiB
      Objects count: 1
     Versions count: 0

   Object sizes histogram:
      1 object(s) BETWEEN_1024B_AND_1_MB
      1 object(s) BETWEEN_1024_B_AND_64_KB
      0 object(s) BETWEEN_10_MB_AND_64_MB
      0 object(s) BETWEEN_128_MB_AND_512_MB
      0 object(s) BETWEEN_1_MB_AND_10_MB
      0 object(s) BETWEEN_256_KB_AND_512_KB
      0 object(s) BETWEEN_512_KB_AND_1_MB
      0 object(s) BETWEEN_64_KB_AND_256_KB
      0 object(s) BETWEEN_64_MB_AND_128_MB
      0 object(s) GREATER_THAN_512_MB
      0 object(s) LESS_THAN_1024_B


Count of Objects in a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To show the number of objects in a bucket, use :std:option:`--json <mc.--json>` and extract the value of ``objectsCount`` with a JSON parser:

The following example uses the `jq <https://jqlang.github.io/jq/>`__ utility:

.. code-block:: shell
   :class: copyable

   mc stat myminio/mybucket --json | jq '.Usage.objectsCount'


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
