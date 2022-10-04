.. _minio-mc-policy-set:

====================
``mc anonymous set``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc anonymous
.. mc:: mc anonymous set

Syntax
------

.. start-mc-policy-set-desc

The :mc:`mc anonymous set` command sets anonymous (i.e. unauthenticated or public)
access :ref:`policies <minio-policy>` for a bucket. 

.. end-mc-policy-set-desc

Buckets with anonymous policies allow clients to access the bucket contents
and perform actions consistent with the specified policy without 
:ref:`authentication <minio-authentication-and-identity-management>`.

To set anonymous bucket policies using an IAM 
:s3-docs:`JSON policy <using-iam-policies>`, use the
:mc-cmd:`mc anonymous set-json` command.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command sets anonymous access policies for several
      buckets on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc anonymous set upload myminio/uploads
         mc anonymous set download myminio/downloads
         mc anonymous set public myminio/public

      Applications can perform the following operations without authentication:

      - ``PUT`` objects to ``myminio/uploads`` and ``myminio/public``.
      - ``GET`` objects from ``myminio/downloads`` and ``myminio/public``.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] policy set PERMISSION ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: PERMISSION
      
   *Required* Name of the policy to assign to the specified ``ALIAS``.
   Specify one of the following values:

   - ``none`` - Disable anonymous access to the ``ALIAS``.
   - ``download`` - Enable download-only access to the ``ALIAS``.
   - ``upload`` - Enable upload-only access to the ``ALIAS``.
   - ``public`` - Enable download and upload access to the ``ALIAS``.

.. mc-cmd:: ALIAS

   *Required* The full path to the bucket or bucket prefix to which the
   command applies the specified :mc-cmd:`~mc anonymous set PERMISSION`. 
   
   Specify the :ref:`alias <alias>` of the MinIO or other
   S3-compatible service *and* the full path to the bucket or bucket
   prefix. For example:

   .. code-block:: shell
            
      mc set public play/mybucket

   Specify a bucket prefix to set the policy on only that prefix. For example,
   this command sets distinct anonymous bucket policies on the 
   ``mybucket/downloads`` and ``mybucket/uploads`` prefixes:

   .. code-block:: shell

      mc set download play/mybucket/downloads
      mc set upload play/mybucket/uploads

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Set Anonymous Policy for Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc anonymous set` to set the anonymous policy for a 
bucket:

.. code-block:: shell
   :class: copyable

   mc anonymous set POLICY ALIAS/PATH

- Replace :mc-cmd:`POLICY <mc anonymous set PERMISSION>` with a supported
  :mc-cmd:`permission <mc anonymous set PERMISSION>`.

- Replace :mc-cmd:`ALIAS <mc anonymous set ALIAS>` with the 
  :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc anonymous set ALIAS>` with the destination bucket.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility