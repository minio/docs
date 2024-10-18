.. _minio-mc-admin-accesskey-disable:

==============================
``mc admin accesskey disable``
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin accesskey disable


Syntax
------

.. start-mc-admin-accesskey-disable-desc

The :mc-cmd:`mc admin accesskey disable` command disables an existing access key for a MinIO IDP user.

.. end-mc-admin-accesskey-disable-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command disables the specified access key:
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin accesskey disable myminio myuserserviceaccount  

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin accesskey disable         \  
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

   The access key to disable.


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
