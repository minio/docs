==============
``mc version``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc version

Description
-----------

.. start-mc-version-desc

The :mc:`mc version` command enables, suspends, and retrieves the 
:ref:`versioning <minio-bucket-versioning>` configuration for a MinIO bucket.

.. end-mc-version-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command enables, suspends, and retrieves versioning
      for the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc version enable myminio/mydata
         mc version info myminio/mydata
         mc version suspend myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] version                    \
                          [enable | suspend | info]  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: enable

   Enables versioning on the MinIO bucket specified to
   :mc-cmd:`ALIAS <mc version ALIAS>`.

   Mutually exclusive with :mc-cmd:`~mc version suspend` and
   :mc-cmd:`~mc version info`

.. mc-cmd:: suspend

   Disables versioning on the MinIO bucket specified to
   :mc-cmd:`ALIAS <mc version ALIAS>`.

   Mutually exclusive with :mc-cmd:`~mc version suspend` and
   :mc-cmd:`~mc version info`

.. mc-cmd:: info

   Returns the versioning configuration for the MinIO bucket specified to
   :mc-cmd:`ALIAS <mc version ALIAS>`.

   Mutually exclusive with :mc-cmd:`~mc version suspend` and
   :mc-cmd:`~mc version info`

.. mc-cmd:: ALIAS

   *Required* The :ref:`alias <alias>` of a MinIO deployment and the full path
   to the bucket for which to set the versioning configuration. For example:

   .. code-block:: shell

      mc version enable myminio/mybucket

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-json-globals
   :end-before: end-minio-mc-json-globals

Examples
--------

Enable Bucket Versioning
~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc version suspend` to enable versioning on a bucket:

.. code-block:: shell
   :class: copyable

   mc version ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc version ALIAS>` with the
  :mc:`alias <mc alias>` of a configured MinIO deployment.

- Replace :mc-cmd:`PATH <mc version ALIAS>` with the bucket on which
  to enable versioning.

Disable Bucket Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc version suspend` to suspend versioning on a bucket:

.. code-block:: shell
   :class: copyable

   mc version ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc version ALIAS>` with the
  :mc:`alias <mc alias>` of a configured MinIO deployment.

- Replace :mc-cmd:`PATH <mc version ALIAS>` with the bucket on which
  to suspend versioning.

Get Bucket Versioning Status
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc version info` to enable versioning on a bucket:

.. code-block:: shell
   :class: copyable

   mc version ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc version ALIAS>` with the
  :mc:`alias <mc alias>` of a configured MinIO deployment.

- Replace :mc-cmd:`PATH <mc version ALIAS>` with the bucket on which
  to retrieve the versioning status.

Behavior
--------

Object Locking Enables Bucket Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While bucket versioning is disabled by default, configuring
object locking on a bucket or an object in that bucket automatically
enables versioning for the bucket. See 
:mc:`mc retention` for more information on configuring object locking.

Bucket Versioning with Existing Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enabling bucket versioning on a bucket with existing data immediately applies
a versioning ID to any unversioned object.

Disabling bucket versioning on a bucket with existing versioned data does
*not* remove any versioned objects. Applications can continue to access
versioned data after disabling bucket versioning. Use 
:mc-cmd:`mc rm --versions ALIAS/BUCKET/OBJECT <mc rm --versions>` to delete an 
object *and* all its versions.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility