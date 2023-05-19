.. _minio-mc-admin-cluster-bucket-import:

==================================
``mc admin cluster bucket import``
==================================

.. default-domain:: minio

.. mc:: mc admin cluster bucket import

Description
-----------

.. versionadded:: RELEASE.2022-06-17T02-52-50Z

.. start-mc-admin-cluster-bucket-import-desc

The :mc:`mc admin cluster bucket import` command imports bucket metadata as created by the :mc:`mc admin cluster bucket export` command.

.. end-mc-admin-cluster-bucket-import-desc

You can use this command to manually restore the metadata to the specified bucket on a MinIO deployment.

If you specify only the deployment as the target, this command applies the metadata objects to all matching buckets on the target.

. tab-set::

   .. tab-item:: EXAMPLE

      The following command imports the specified metadata onto the ``myminio`` deployment.
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin cluster bucket import myminio ~/minio-metadata-backup/myminio-cluster.zip

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin cluster bucket import  \
                                             ALIAS[/BUCKET] \
                                             METADATA.ZIP  
                                             
      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment.

.. mc-cmd:: METADATA.ZIP
   :required:

   The path to the metadata file created by :mc:`mc admin cluster bucket export`.

.. mc-cmd:: BUCKET
   :optional:

   The bucket onto which the command applies the imported metadata.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
