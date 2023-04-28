.. _minio-mc-admin-svcacct-disable:

=================================
``mc admin user svcacct disable``
=================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct disable


Syntax
------

.. start-mc-admin-svcacct-disable-desc

The :mc-cmd:`mc admin user svcacct disable` command disables an existing access key.

.. end-mc-admin-svcacct-disable-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command disables the specified access key:
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin user svcacct disable myminio myuserserviceaccount  

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin user svcacct disable         \  
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

   The service account access key to disable.


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
