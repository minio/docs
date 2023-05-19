.. _minio-mc-admin-svcacct-list:

============================
``mc admin user svcacct ls``
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct list
.. mc:: mc admin user svcacct ls


Syntax
------

.. start-mc-admin-svcacct-list-desc

The :mc:`mc admin user svcacct ls` command lists all access keys associated to the specified user.

.. end-mc-admin-svcacct-list-desc

The alias :mc:`mc admin user svcacct list` has equivalent functionality to :mc:`mc admin user svcacct ls`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command lists all access keys associated to the user with username ``admin1``:

      .. code-block:: shell  
         :class: copyable 

         mc admin user svcacct ls myminio admin1

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin user svcacct ls   \ 
                                             ALIAS  \ 
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

   The username of the user to display access keys for.


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
