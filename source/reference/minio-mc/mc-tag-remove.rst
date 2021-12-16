.. _minio-mc-tag-remove:

=================
``mc tag remove``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc tag remove

.. |command| replace:: :mc-cmd:`mc tag remove`
.. |rewind| replace:: :mc-cmd-option:`~mc tag remove rewind`
.. |versions| replace:: :mc-cmd-option:`~mc tag remove versions`
.. |versionid| replace:: :mc-cmd-option:`~mc tag remove version-id`
.. |alias| replace:: :mc-cmd-option:`~mc tag remove ALIAS`

Syntax
------

.. start-mc-tag-remove-desc

The :mc:`mc tag remove` command removes all tags from a bucket or object.

.. end-mc-tag-remove-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes tags for the ``mydata`` bucket on the
      ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc tag remove myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] tag remove                \
                          [--rewind "string"]       \
                          [--versions]              \
                          [--version-id "string"]*  \

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

      :mc-cmd-option:`mc tag remove version-id` is mutually exclusive with
      multiple parameters. See the reference documentation for more information.

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The :ref:`alias <alias>` for a MinIO deployment and the
   full path to the object on which to remove all tags (e.g. bucket and path to
   object). For example:

   .. code-block:: none

      mc tag remove myminio/mybucket/object.txt

.. mc-cmd:: rewind
   :option:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: versions
   :option:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-versions-desc
      :end-before: end-versions-desc

   Use :mc-cmd-option:`~mc tag remove versions` and 
   :mc-cmd-option:`~mc tag remove rewind` together to remove tags from all
   object versions which existed at a specific point in time.

.. mc-cmd:: version-id, vid
   :option:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

   Mutually exclusive with the following parameters:

   - :mc-cmd-option:`~mc tag remove rewind`
   - :mc-cmd-option:`~mc tag remove versions`

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Remove Tags from a Bucket or Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc tag remove` to remove tags from a bucket or object:

.. code-block:: shell
   :class: copyable

   mc tag remove ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc tag remove ALIAS>` with the 
  :ref:`alias <alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc tag remove ALIAS>` with the path to the bucket
  or object on the MinIO deployment.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
