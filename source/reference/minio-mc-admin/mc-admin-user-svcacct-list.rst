.. _minio-mc-admin-svcacct-list:

==============================
``mc admin user svcacct list``
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct list


Syntax
------

.. start-mc-admin-svcacct-list-desc

The :mc-cmd:`mc admin user svcacct list` command lists all access keys associated to the specified user.

.. end-mc-admin-svcacct-list-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command lists all access keys associated to an existing MinIO user:  

      .. code-block:: shell  
         :class: copyable 

         mc admin user svcacct list myminio myuser

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin user svcacct list  \ 
                                     ALIAS         \ 
                                     USER

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

   The name of the user for which MinIO lists the access keys.


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
