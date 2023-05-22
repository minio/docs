.. _minio-mc-admin-svcacct-remove:

============================
``mc admin user svcacct rm``
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct remove
.. mc:: mc admin user svcacct rm


Syntax
------

.. start-mc-admin-svcacct-remove-desc

The :mc:`mc admin user svcacct rm` command removes an access key associated to a user on the deployment.

.. end-mc-admin-svcacct-remove-desc

The :mc:`mc admin user svcacct remove` command has equivalent functionality to :mc:`mc admin user svcacct rm`.
   
Applications can no longer authenticate using that access key after removal.
   
.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes the specified access key:
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin user svcacct rm myminio myuserserviceaccount  

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin user svcacct remove          \ 
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

   The service account access key to remove.


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
