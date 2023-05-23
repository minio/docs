.. _minio-mc-admin-cluster-iam-import:

===============================
``mc admin cluster iam import``
===============================

.. default-domain:: minio

.. mc:: mc admin cluster iam import

Description
-----------

.. versionadded:: RELEASE.2022-06-17T02-52-50Z

.. start-mc-admin-cluster-iam-import-desc

The :mc:`mc admin cluster iam import` command imports :ref:`IAM <minio-authentication-and-identity-management>` metadata as created by the :mc:`mc admin cluster iam export` command.

.. end-mc-admin-cluster-iam-import-desc

You can use this command to manually restore IAM metadata settings for a MinIO deployment.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command imports the IAM metadata of the specified file onto the ``myminio`` deployment.
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin cluster iam import myminio ~/minio-metadata-backup/myminio-cluster.zip

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin cluster iam import  \
                                            ALIAS \
                                            IAM-METADATA.ZIP  
                                             
      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Starting with :mc-release:`RELEASE.2023-05-04T18-10-16Z`, :mc:`mc admin cluster iam import` adds support for aliases ending with a trailing forward slash ``ALIAS/``.
Prior to this release, the command would fail when provided a trailing forward slash.

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment.

.. mc-cmd:: IAM-METADATA.ZIP
   :required:

   The path to the IAM metadata file to import.
   
   Use the :mc:`mc admin cluster iam export` to export IAM metadata for use with this command.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
