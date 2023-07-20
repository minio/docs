.. _minio-mc-version-enable:

=====================
``mc version enable``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc version enable


Syntax
------

.. start-mc-version-enable-desc

The :mc:`mc version enable` command enables versioning on the specified bucket.

.. end-mc-version-enable-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command enables versioning for the ``mybucket`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

          mc version enable myminio/mybucket

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] version enable ALIAS                \
	                                 --exclude-folders    \
					 --excluded-prefixes

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of a MinIO deployment and the full path to the bucket for which to enable versioning. For example:

   .. code-block:: shell

      mc version enable myminio/mybucket

.. mc-cmd:: --exclude-folders
   :optional:

   Disable versioning on all folders (objects whose name ends with ``/``) in the specified bucket.

.. mc-cmd:: --excluded-prefixes
   :optional:

   Disable versioning on objects matching a list of prefixes, up to 10.
   The list of prefixes match all objects containing the specified strings in their prefix or name, similar to a regular expression of the form ``prefix*``.
   To match objects by prefix only, use ``prefix/*``.

   For example, the following command excludes any objects containing ``_test`` or ``_temp`` in their prefix or name from versioning:

   .. code-block:: shell
      :class: copyable

      mc version enable --excluded-prefixes "_test, _temp" myminio/mybucket


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Example
-------

Enable Bucket Versioning
~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc version enable` to enable versioning for a bucket:

.. code-block:: shell
   :class: copyable

   mc version enable ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc version enable ALIAS>` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

- Replace :mc-cmd:`PATH <mc version enable ALIAS>` with the bucket on which to enable versioning.


Behavior
--------

Bucket Versioning with Existing Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enabling bucket versioning on a bucket with existing data immediately applies a versioning ID to any unversioned object.


S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
