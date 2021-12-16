.. _minio-mc-encrypt-info:

===================
``mc encrypt info``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc encrypt info

Syntax
------

.. start-mc-encrypt-info-desc

The :mc:`mc encrypt info` command returns the current default
encryption settings for a bucket.

.. end-mc-encrypt-info-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command returns the default encryption setting for the
      ``mydata`` bucket on the ``myminio`` MinIO deployment.

      .. code-block:: shell
         :class: copyable

         mc encrypt info myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] encrypt info ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   The full path to the bucket on which to retrieve the default SSE mode.
   Specify the :ref:`alias <alias>` of the MinIO deployment as the prefix to the
   ALIAS path. For example:

   .. code-block:: shell

      mc encrypt info play/mybucket

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Retrieve the Automatic Server-Side Encryption Settings for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Example

      .. code-block:: shell
         :class: copyable

          mc encrypt info myminio/data

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable

         mc encrypt info ALIAS

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of the
        MinIO deployment on which to configure automatic server-side bucket
        encryption.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
