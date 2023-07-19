.. _minio-mc-version-info:

===================
``mc version info``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc version info


Syntax
------

.. start-mc-version-info-desc

The :mc:`mc version info` command returns the versioning status for the specified bucket.

.. end-mc-version-info-desc

Mutually exclusive with :mc-cmd:`~mc version suspend` and :mc-cmd:`~mc version enable`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command returns the versioning status for the ``mybucket`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc version info myminio/mybucket

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] version info ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   The full path to the bucket on which to retrieve the versioning status.
   For example:

   .. code-block:: shell

      mc version info myminio/mybucket


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Example
-------

Get Bucket Versioning Status
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc version info` to retrieve the versioning status for a bucket:

.. code-block:: shell
   :class: copyable

   mc version info ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc version ALIAS>` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

- Replace :mc-cmd:`PATH <mc version ALIAS>` with the bucket on which to retrieve the versioning status.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
