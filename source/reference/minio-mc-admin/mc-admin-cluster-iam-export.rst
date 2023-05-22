.. _minio-mc-admin-cluster-iam-export:

===============================
``mc admin cluster iam export``
===============================

.. default-domain:: minio

.. mc:: mc admin cluster iam export

Description
-----------

.. versionadded:: RELEASE.2022-06-26T18-51-48Z

.. start-mc-admin-cluster-iam-export-desc

The :mc:`mc admin cluster iam export` command exports :ref:`IAM <minio-authentication-and-identity-management>` metadata for use with the :mc:`mc admin cluster iam import` command.

.. end-mc-admin-cluster-iam-export-desc

The command saves the output as ``ALIAS-iam-metadata.zip``, where ``ALIAS`` is the :mc:`alias <mc admin cluster iam export ALIAS>` of the MinIO deployment.

. tab-set::

   .. tab-item:: EXAMPLE

      The following command exports all IAM metadata for the ``myminio`` deployment.
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin cluster iam export myminio

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin cluster iam export  \
                                            ALIAS
                                             
      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Starting with :mc-release:`RELEASE.2023-05-04T18-10-16Z`, :mc:`mc admin cluster iam export` adds support for aliases ending with a trailing forward slash ``ALIAS/``.
Prior to this release, the command would fail when provided a trailing forward slash.

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.

.. mc-cmd:: BUCKET
   :optional:

   The iam from which the command exports the IAM metadata.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
