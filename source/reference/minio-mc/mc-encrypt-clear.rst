.. _minio-mc-encrypt-clear:

====================
``mc encrypt clear``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc encrypt clear

Syntax
------

.. start-mc-encrypt-clear-desc

The :mc:`mc encrypt clear` command removes the current default
encryption settings for a bucket.

.. end-mc-encrypt-clear-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes the default encryption settings for
      the ``mydata`` bucket on the MinIO deployment associated with the 
      ``myminio`` :ref:`alias <alias>`:

      .. code-block:: shell
         :class: copyable

         mc encrypt clear myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] encrypt clear ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   The full path to the bucket on which to remove the default SSE mode.
   Specify the :ref:`alias <alias>` of the MinIO deployment as the prefix to the
   ALIAS path. For example:

   .. code-block:: shell

      mc encrypt clear play/mybucket

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Remove the Automatic Server-Side Encryption Settings for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Example

      .. code-block:: shell
         :class: copyable

          mc encrypt clear myminio/data

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable

         mc encrypt clear ALIAS

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of the
        MinIO deployment on which to remove automatic server-side bucket
        encryption.

Behavior
--------

Modifying Bucket Encryption Settings Does Not Affect Encrypted Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Disabling automatic bucket encryption does *not* decrypt any objects in the
bucket. 

To permanently decrypt objects in the bucket, you can perform an in-place
copy after disabling object decryption. For versioned buckets, the
previous object versions remain encrypted.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
