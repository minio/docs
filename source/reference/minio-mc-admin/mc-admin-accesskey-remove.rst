.. _minio-mc-admin-accesskey-remove:

=========================
``mc admin accesskey rm``
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin accesskey remove
.. mc:: mc admin accesskey rm


Syntax
------

.. start-mc-admin-accesskey-remove-desc

The :mc:`mc admin accesskey rm` command removes an access key associated to a user on the deployment.

.. end-mc-admin-accesskey-remove-desc

The :mc:`mc admin accesskey remove` command has equivalent functionality to :mc:`mc admin accesskey rm`.
   
.. warning::

   Applications can no longer authenticate using the access key after its removal.
   
.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes the specified access key:
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin accesskey rm myminio myuserserviceaccount  

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin accesskey rm                \ 
                                          ALIAS             \ 
                                          ACCESSKEYTOREMOVE

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment.

.. mc-cmd:: ACCESSKEYTOREMOVE
   :required:

   The access key to remove.


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
