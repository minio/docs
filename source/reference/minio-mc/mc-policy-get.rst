.. _minio-mc-policy-get:

=================
``mc policy get``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc policy get

Syntax
------

.. start-mc-policy-get-desc

The :mc:`mc policy get` command gets the anonymous (i.e. unauthenticated or
public) access :ref:`policies <minio-policy>` for a bucket. 

.. end-mc-policy-get-desc

Buckets with anonymous policies allow clients to access the bucket contents
and perform actions consistent with the specified policy without 
:ref:`authentication <minio-authentication-and-identity-management>`.

To get the :s3-docs:`JSON policy <using-iam-policies>` assigned to the bucket,
use the :mc-cmd:`mc policy get-json` command.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command retrieves the anonymous access policy for the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc policy get myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] policy get ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The full path to the bucket or bucket prefix for which the
   command retrieves the anonymous bucket policy.
   
   Specify the :ref:`alias <alias>` of the MinIO or other
   S3-compatible service *and* the full path to the bucket or bucket
   prefix. For example:

   .. code-block:: shell
            
      mc get public play/mybucket

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Get Anonymous Policy for Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc policy get` to get the anonymous policy for a 
bucket:

.. code-block:: shell
   :class: copyable

   mc policy get ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc policy get ALIAS>` with the 
  :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc policy get ALIAS>` with the destination bucket.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility