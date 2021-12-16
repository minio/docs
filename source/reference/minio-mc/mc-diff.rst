.. _minio-mc-diff:

===========
``mc diff``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc diff

Syntax
------

.. start-mc-diff-desc

The :mc:`mc diff` mc computes the differences between two filesystem directories
or MinIO buckets. :mc:`mc diff` lists only those objects which are missing or
which differ in size. :mc:`mc diff` does **not** compare the contents of
objects.

.. end-mc-diff-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command computes the difference between an object on
      a local filesystem and an object in the ``mydata`` bucket on the
      ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc diff ~/mydata/myobject.txt myminio/mydata/myobject.txt

   .. tab-item:: SYNTAX

      The command command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] diff SOURCE TARGET

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: SOURCE

   *Required* The object to compare to the ``TARGET``.

   For an object from MinIO or another S3-compatible service,
   specify the :mc:`alias <mc alias>` and the full path to that 
   object (e.g. bucket and path to object). For example:

   .. code-block:: none

      mc diff play/mybucket/object.txt ~/mydata/object.txt


   For an object from a local filesystem, specify the full
   path to that object. For example:

   .. code-block:: none

      mc diff ~/mydata/object.txt play/mybucket/object.txt

.. mc-cmd:: TARGET

   *Required* The object to compare to the ``SOURCE``.

   For an object from MinIO or another S3-compatible service,
   specify the :mc:`alias <mc alias>` and the full path to that 
   object (e.g. bucket and path to object). For example:

   .. code-block:: none

      mc diff play/mybucket/object.txt ~/mydata/object.txt


   For an object from a local filesystem, specify the full
   path to that object. For example:

   .. code-block:: none

      mc diff ~/mydata/object.txt play/mybucket/object.txt

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc diff play/bucket1 play/bucket2

Behavior
--------

Output Legend
~~~~~~~~~~~~~

:mc:`mc diff` uses the following legend when formatting the diff output:

.. code-block:: none
   
   FIRST < SECOND - object exists only in FIRST 
   FIRST > SECOND - object exists only in SECOND 
   FIRST ! SECOND - Newer object exists in FIRST

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
