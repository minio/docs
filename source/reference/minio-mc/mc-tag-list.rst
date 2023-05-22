.. _minio-mc-tag-list:

===============
``mc tag list``
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc tag list

.. |command| replace:: :mc:`mc tag list`
.. |rewind| replace:: :mc-cmd:`~mc tag list --rewind`
.. |versions| replace:: :mc-cmd:`~mc tag list --versions`
.. |versionid| replace:: :mc-cmd:`~mc tag list --version-id`
.. |alias| replace:: :mc-cmd:`~mc tag list ALIAS`

Syntax
------

.. start-mc-tag-list-desc

The :mc:`mc tag list` command lists all tags from a bucket or object.

.. end-mc-tag-list-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command lists tags for the ``mydata`` bucket on the
      ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc tag list myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] tag set                   \
                          [--rewind "string"]       \
                          [--versions]              \
                          [--version-id "string"]*  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

      :mc-cmd:`mc tag list --version-id` is mutually exclusive with
      multiple parameters. See the reference documentation for more information.

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The :ref:`alias <alias>` for a MinIO deployment and the
   full path to the object for which to list all tags (e.g. bucket and path to
   object). For example:

   .. code-block:: none

      mc tag list myminio/mybucket/object.txt

.. mc-cmd:: --recursive, r
   :optional:

   .. versionadded:: RELEASE.2023-05-04T18-10-16Z

   Recursively lists the tags for all objects at the path specified to :mc:`ALIAS <mc tag list ALIAS>`.

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

   Use :mc-cmd:`~mc tag list --versions` and 
   :mc-cmd:`~mc tag list --rewind` together to list tags from all
   object versions which existed at a specific point in time.

.. mc-cmd:: --version-id, vid
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

   Mutually exclusive with the following parameters:

   - :mc-cmd:`~mc tag list --rewind`
   - :mc-cmd:`~mc tag list --versions`

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

List Tags for a Bucket or Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc tag list` to list tags for a bucket or object:

.. code-block:: shell
   :class: copyable

   mc tag list ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc tag list ALIAS>` with the 
  :ref:`alias <alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc tag list ALIAS>` with the path to the bucket
  or object on the MinIO deployment.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
