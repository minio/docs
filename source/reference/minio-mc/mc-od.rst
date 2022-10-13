=========
``mc od``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc od

Syntax
------

.. start-mc-od-desc

The :mc:`mc od` command copies a local file to a remote location in a specified number of parts and part sizes.
The command outputs the time it took to upload the file. 

.. end-mc-od-desc

Use the :mc:`mc od` to mimic the functionality of the Linux ``dd`` command.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command Upload 200MiB of a file to a bucket in 5 parts of size 40MiB.
      The output shows the results of the upload, including the length of time it took for the upload to complete.

      .. code-block:: shell
         :class: copyable

         mc od if=file.zip of=myminio/mybucket/file.zip size=40MiB parts=5

      If passing the ``--json`` :ref:`global flag <minio-mc-global-options>`, the output of the command resembles the following:

      .. code-block:: json

         {
           "source": "home/user/file.zip"
           "target": "myminio/mybucket/file.zip"
           "partSize": 41943040
           "totalSize": 209715200
           "parts": 5
           "elapsed": "314ms"
         }

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] od                                            \
                          if=<path of source file to upload>            \
                          of=<target MinIO path to upload to>           \
                          [size=<size of file>]                         \
                          [parts=<number of parts to split file into>]  \
                          [skip=<number of parts to skip>]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: if
   :required:

   The path of the source object to use for the upload.
   Use the full path relative to your current location.

   .. code-block:: none

      mc od if=file.zip of=myminio/mybucket/file.zip

.. mc-cmd:: of
   :required:

   The full target path to upload the object to.

.. mc-cmd:: size
   :optional:

   The size for each part of the file to upload.
   If not specified, MinIO determines the size for parts from the source stream.

.. mc-cmd:: parts
   :optional:

   The number of parts to divide the object into for uploading.
   If not specified, MinIO determines the number of parts based on the size of the source stream.

.. mc-cmd:: skip
   :optional:

   The number of parts of the file to skip during the upload.
   For example, use this option to test the upload speed for a large file of many parts on only a portion of the object's parts.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Upload a Full File with 40MiB Parts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc od` to upload a file to MinIO in a set of parts of specified size. 
The :mc-cmd:`~mc od size` option allows you to specify the desired part size.

.. code-block:: shell
   :class: copyable

   mc od if=file.zip of=myminio/mybucket/file.zip size=40MiB

- Replace ``myminio/mybucket/file.zip`` with the path of the object or file stream to upload.

- Replace :mc-cmd:`size <mc od size>` with the desired size of the object parts.

MinIO examines the source file and divides it into the necessary number of parts so that no part is larger than the specified 40MiB part size.

Upload a First Five 40 MiB Parts of a File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc od` to upload parts of a file to MinIO of specified part size. 
The :mc-cmd:`~mc od size` option allows you to specify the desired part size.
The :mc-cmd:`~mc od parts` option allows you to specify the total number of parts to use for the object.

.. code-block:: shell
   :class: copyable

   mc od if=file.zip of=myminio/mybucket/file.zip size=40MiB parts=5

- Replace ``myminio/mybucket/file.zip`` with the path of the object or file stream to upload.
- Replace :mc-cmd:`size <mc od size>` with the desired size of the object parts.
- Replace :mc-cmd:`parts <mc od parts>` with the number of desired parts to use for the object.

In this command example, if the source object stream is larger than 200MiB (40MiB × 5 parts), only the first 200MiB of the file upload.

.. important:: 

   Using the command this way may not upload the entirety of an object.

Upload a Full File in 5 Parts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Take a source file, divide the file into a specified number of parts, then upload all parts of the file to a MinIO target.

.. code-block:: shell
   :class: copyable

   mc od if=file.zip of=myminio/mybucket/file.zip parts=5

The above command divides the source file into five equal parts, then uploads those parts.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
