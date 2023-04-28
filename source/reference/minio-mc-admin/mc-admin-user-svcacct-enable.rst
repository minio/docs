.. _minio-mc-admin-svcacct-enable:

================================
``mc admin user svcacct enable``
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct enable


Syntax
------

.. start-mc-admin-svcacct-enable-desc

The :mc-cmd:`mc admin user svcacct enable` command enables an existing access key.

.. end-mc-admin-svcacct-enable-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command enables the specified access key:
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin user svcacct enable myminio myuserserviceaccount  

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin user svcacct enable          \  
                                             ALIAS           \  
                                             SERVICEACCOUNT 

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment.

.. mc-cmd:: SERVICEACCOUNT
   :required:

   The service account access key to enable.


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
