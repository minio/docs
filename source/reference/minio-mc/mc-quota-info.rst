=================
``mc quota info``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc quota info

.. versionchanged:: RELEASE.2022-12-13T00-23-28Z

   ``mc quota info`` replaced ``mc admin bucket quota``.

Description
-----------

.. start-mc-quota-info-desc

The :mc-cmd:`mc quota info` command displays the currently configured quota for a bucket.

.. end-mc-quota-info-desc

Examples
--------


Retrieve Bucket Quota Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc quota info` to retrieve the current quota configuration for a bucket:

.. code-block:: shell
   :class: copyable

   mc quota info TARGET/BUCKET

Replace ``TARGET`` with the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment. 
Replace ``BUCKET`` with the name of the bucket on which to retrieve the quota.

Syntax
------

:mc-cmd:`mc quota info` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc quota info TARGET

:mc-cmd:`mc quota info` supports the following arguments:

.. mc-cmd:: TARGET
   :required:

   The full path to the bucket for which the command creates the quota. 
   Specify the :mc-cmd:`alias <mc alias>` of the MinIO deployment as a prefix to the path. 
   For example:

   .. code-block:: shell
      :class: copyable

      mc quota play/mybucket

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

   
S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility