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

The :mc:`mc stat` command displays information on objects in a MinIO bucket,
including object metadata. 

.. end-mc-stat-desc

You can also use :mc:`mc stat` against the local filesystem to produce similar
results to the ``stat`` commandline tool.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command displays information on all objects in the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc stat --recursive myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] stat                      \
                          [--encrypt-key "value"]   \
                          [--recursive]             \
                          [--rewind "string"]       \
                          [--versions]              \
                          [--version-id "string"]*  \
                          ALIAS [ALIAS ...]


      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

      :mc-cmd:`mc stat --version-id` is mutually exclusive with multiple
      parameters. See the reference documentation for more information.

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   The :ref:`alias <alias>` of a MinIO deployment and the full path to the
   object for which to retrieve detailed information. For example:

   .. code-block:: shell

      mc stat myminio/mybucket/myobject.txt

   You can specify multiple objects on the same or different MinIO deployments:

   .. code-block:: shell

      mc stat play/mybucket/myobject.txt myminio/mybucket/myobject.txt

   If specifying the path to a bucket or bucket prefixy, you **must**
   include the :mc-cmd:`mc stat --recursive` flag:

   .. code-block:: shell

      mc stat --recursive myminio/mybucket/

   For retrieving information on a file from a local filesystem, specify the
   full path to that file:

   .. code-block:: shell

      mc stat ~/data/myobject.txt

.. mc-cmd:: --encrypt-key
   

   *Optional* Encrypt or decrypt objects using server-side encryption with
   client-specified keys. Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting 
      object(s).

   Enclose the entire list of key-value pairs passed to 
   :mc-cmd:`~mc stat --encrypt-key` in double quotes ``"``.

   :mc-cmd:`~mc stat --encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for retrieving a list of encryption key-value pairs
   as an alternative to specifying them on the command line.

.. mc-cmd:: --recursive, r
   

   *Optional* Recursively :mc:`mc stat` the contents of the MinIO bucket
   specified to :mc-cmd:`~mc stat ALIAS`.

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

   Use :mc-cmd:`~mc stat --versions` and 
   :mc-cmd:`~mc stat --rewind` together to remove all object
   versions which existed at a specific point in time.

.. mc-cmd:: --version-id, vid
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

   Mutually exclusive with any of the following flags:
   
   - :mc-cmd:`~mc stat --versions`
   - :mc-cmd:`~mc stat --rewind`
   - :mc-cmd:`~mc stat --recursive`

Examples
--------

.. tab-set::

   .. tab-item:: Single Object

      .. code-block:: shell
         :class: copyable

         mc stat ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc stat ALIAS>` with the 
        :mc:`alias <mc alias>` of the S3-compatible host.

      - Replace :mc-cmd:`PATH <mc stat ALIAS>` with the path to the bucket
        or object on the S3-compatible host.

   .. tab-item:: Object(s) in Bucket

      Use :mc:`mc stat` with the :mc-cmd:`~mc stat --recursive` option
      to apply the operation to all objects in the bucket:

      .. code-block:: shell
         :class: copyable

         mc stat --recursive ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc stat ALIAS>` with the 
        :mc:`alias <mc alias>` of the S3-compatible host.

      - Replace :mc-cmd:`PATH <mc stat ALIAS>` with the path to the bucket
        or object on the S3-compatible host.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
