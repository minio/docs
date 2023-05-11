.. _minio-mc-ilm-restore:

==================
``mc ilm restore``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm restore

Syntax
------

.. start-mc-ilm-restore-desc

The :mc:`mc ilm restore` command creates a temporary copy of an object archived
on a remote tier. The copy automatically expires after 1 day by default.

.. end-mc-ilm-restore-desc

Use this command to allow applications to access a tiered object through the
MinIO deployment (e.g. "hot tier"). The archived object remains on the remote
tier, while the temporary copy becomes ``HEAD`` for that object.

.. versionadded:: mc RELEASE.2023-04-12T02-21-51Z

   Use :mc:`mc stat` to display whether a restored file reads from the local temporary copy or the remote tier.
   Restored files read from the local copy show a status of ``Ongoing : true``.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command restores a copy of a transitioned object from the
      remote tier back to the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc ilm restore myminio/mybucket/object.txt

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] ilm restore      \
                          [--days "int" ]  \
                          [--recursive]    \
                          [--vid "string"] \
                          [--versions]     \
                          [--encrypt-key]  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The MinIO :ref:`alias <alias>`, bucket, and path to the archived object to restore.

   .. code-block:: shell

      mc ilm restore myminio/mybucket/object.txt

.. mc-cmd:: --days                     
   :optional:

   The number of days after which MinIO expires the restored copy of the archived object.

.. mc-cmd:: --recursive, r                  
   :optional:

   Restores all objects under the specified prefix.

.. mc-cmd:: --versions                       
   :optional:

   Restores all versions of the object on the remote tier.

.. mc-cmd:: --version-id, vid  
   :optional:

   Restores the specified version of the object on the remote tier.

.. mc-cmd:: --encrypt-key
   :optional:

   .. versionadded:: RELEASE.2023-01-28T20-29-38Z

   Encrypt or decrypt objects using server-side encryption with client-specified keys. 
   Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting object(s).

   Enclose the entire list of key-value pairs passed to :mc-cmd:`~mc ilm restore --encrypt-key` in double quotes ``"``.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Restore an Archived Object
~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command restores an object archived to a remote tier:

.. code-block:: shell
   :class: copyable

   mc ilm restore myminio/mybucket/object.txt


Restore a Specific Archived Object Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command restore a specific object version archived to a 
remote tier:

.. code-block:: shell
   :class: copyable

   mc ilm restore --vid "VERSIONID" myminio/mybucket/object.txt

Restore All Archived Objects at a Bucket Prefix
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command restores all objects archived under a specified prefix on
the remote tier:

.. code-block:: shell
   :class: copyable

   mc ilm restore --recursive myminio/mybucket/data/

Behavior
--------

Restored Objects Expire Automatically
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO automatically expires the restored object copy after the specified
number of days (Default: 1 day).

Restored Objects Become HEAD
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The restored object copy becomes HEAD for that object namespace *regardless*
of it's versioning history. This can result in applications returning
"stale" data while the local copy exists. 

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
