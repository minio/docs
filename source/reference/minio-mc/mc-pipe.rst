===========
``mc pipe``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc pipe

Syntax
------

.. start-mc-pipe-desc

The :mc:`mc pipe` command streams content from `STDIN <https://www.gnu.org/software/libc/manual/html_node/Standard-Streams.html>`__ to a target object.

.. end-mc-pipe-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command writes contents of ``STDIN`` to an S3 compatible storage.

      .. code-block:: shell
         :class: copyable

         echo "My Meeting Notes" | mc pipe s3/engineering/meeting-notes.txt

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] pipe                              \
                          TARGET                            \
                          [--encrypt "string"]              \
                          [--storage-class, --sc "string"]  \
                          [--attr "string"]                 \
                          [--tags "string"]                 \
                          [--encrypt-key "string"] 

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

.. versionchanged:: RELEASE.2023-01-11T03-14-16Z

   ``mc pipe`` now supports concurrent uploads for better throughput of large streams.

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The full path to the :ref:`alias <minio-mc-alias>` or prefix where the command should run.

.. mc-cmd:: --attr
   :optional:

   Add custom metadata for the object.

   Specify key-value pairs as ``KEY=VALUE\;``, separating each pair with a back slash and semicolon (``\;``). 
   For example, ``--attr key1=value1\;key2=value2\;key3=value3``.

.. mc-cmd:: --encrypt
   :optional:
   
   Encrypt or decrypt objects using :ref:`server-side encryption <minio-sse>` with server-managed keys. 
   Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting object(s).

   Enclose the entire list of key-value pairs passed to :mc-cmd:`~mc pipe --encrypt` in double-quotes ``"``.

   :mc-cmd:`~mc pipe --encrypt` can use the ``MC_ENCRYPT`` environment variable for retrieving a list of encryption key-value pairs as an alternative to specifying them on the command line.

.. mc-cmd:: --encrypt-key
   :optional:

   Encrypt or decrypt objects using server-side encryption with client-specified keys. 
   Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting object(s).

   Enclose the entire list of key-value pairs passed to :mc-cmd:`~mc pipe --encrypt-key` in double quotes ``"``.

   :mc-cmd:`~mc pipe --encrypt-key` can use the ``MC_ENCRYPT_KEY`` environment variable for retrieving a list of encryption key-value pairs as an alternative to specifying them on the command line.

.. mc-cmd:: --storage-class, --sc
   :optional:

   Set the storage class for the new object at the :mc-cmd:`~mc pipe TARGET`. 
         
   See :aws-docs:`Amazons documentation <AmazonS3/latest/dev/storage-class-intro.html>` for more information on S3 storage classes.

.. mc-cmd:: --tags
   :optional:

   Applies one or more tags to the TARGET.

   Specify an ampersand-separated list of key-value pairs as ``KEY1=VALUE1&KEY2=VALUE2``, where each pair represents one tag to assign to the objects.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Write Contents of ``STDIN`` to the Local Filesystem
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command writes the contents of STDIN to the ``/tmp`` folder on the local filesystem.

.. code-block:: shell
   :class: copyable

   mc pipe /tmp/hello-world.go

Copy an ISO Image to S3 Storage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command first streams the contents of an iso image for Debian and then uses the stream to create the object at an S3 path.

.. code-block:: shell
   :class: copyable

   cat debian-live-11.5.0-amd64-mate.iso | mc pipe s3/opensource-isos/debian-11-5.iso

Stream MySQL Database Dump to S3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command first streams a MySQL database and uses the stream to create a backup on S3 with :mc-cmd:`mc pipe`:

.. code-block:: shell
   :class: copyable

   mysqldump -u root -p ******* accountsdb | mc pipe s3/sql-backups/backups/accountsdb-sep-28-2022.sql

Write a File to a Reduced Redundancy Storage Class
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command takes the STDIN stream and creates an object on the Reduced Redundancy storage class on S3.

.. code-block:: shell
   :class: copyable

    mc pipe --storage-class REDUCED_REDUNDANCY s3/personalbuck/meeting-notes.txt

Copy a File to a MinIO Deployment with Metadata
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command uploads an MP3 file to a MinIO deployment with an ALIAS of ``myminio`` and a ``music`` bucket.
The object writes with some metadata for ``Cache-Control`` and ``Artist``.

.. code-block:: shell
   :class: copyable

   cat music.mp3 | mc pipe --attr "Cache-Control=max-age=90000,min-fresh=9000;Artist=Unknown" myminio/music/guitar.mp3

Set Tags on Uploaded Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates an object on a MinIO deployment with an ALIAS of ``myminio`` in bucket ``mybucket`` with two tags.
MinIO supports adding up to 10 custom tags to an object.

.. code-block:: shell
   :class: copyable

   tar cvf - . | mc pipe --tags "category=prod&type=backup" myminio/mybucket/backup.tar
