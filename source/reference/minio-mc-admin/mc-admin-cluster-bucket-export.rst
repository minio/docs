.. _minio-mc-admin-cluster-bucket-export:

==================================
``mc admin cluster bucket export``
==================================

.. default-domain:: minio

.. mc:: mc admin cluster bucket export

Description
-----------

.. versionadded:: RELEASE.2022-06-17T02-52-50Z

.. start-mc-admin-cluster-bucket-export-desc

The :mc:`mc admin cluster bucket export` command exports bucket metadata for use with the :mc:`mc admin cluster bucket import` command.

.. end-mc-admin-cluster-bucket-export-desc

You can use this command to manually back up the metadata for the specified MinIO bucket.
The command always saves the output as ``cluster-metadata.zip``.

If you specify only the deployment as the target, this command backs up all bucket metadata on the target deployment.

. tab-set::

   .. tab-item:: EXAMPLE

      The following command exports all bucket metadata for the ``myminio`` deployment.
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin cluster bucket export myminio

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin cluster bucket export  \
                                             ALIAS[/BUCKET] \
                                             
      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment.

.. mc-cmd:: BUCKET
   :optional:

   The bucket from which the command exports metadata.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
