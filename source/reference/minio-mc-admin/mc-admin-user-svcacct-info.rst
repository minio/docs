.. _minio-mc-admin-svcacct-info:

==============================
``mc admin user svcacct info``
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct info


Syntax
------

.. start-mc-admin-svcacct-info-desc

The :mc-cmd:`mc admin user svcacct info` command returns a description of the specified access key.

.. end-mc-admin-svcacct-info-desc

The description output includes the following details, as available:

- Access Key
- Parent user of the specified access key
- Access key status (``on`` or ``off``)
- Policy or policies
- Comment
- Expiration

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command returns detailed information on the specified access keys:
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin user svcacct info --policy myminio myuserserviceaccount 

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin user svcacct info   \  
                                     [--policy]     \  
                                     ALIAS          \  
                                     SERVICEACCOUNT

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment.

.. mc-cmd:: USER
   :required:

   The service account for the command to display.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
