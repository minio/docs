.. _minio-mc-admin-svcacct-remove:

================================
``mc admin user svcacct remove``
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct remove


Syntax
------

.. start-mc-admin-svcacct-remove-desc

The :mc-cmd:`mc admin user svcacct remove` command removes an access key associated to the specified user.

.. end-mc-admin-svcacct-remove-desc
   
Applications can no longer authenticate using that access key after removal.
   
.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes the specified access keys:
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin user svcacct remove myminio myuserserviceaccount  

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin user svcacct remove  \ 
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

   The service account for the command to remove.


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
