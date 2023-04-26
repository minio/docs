.. _minio-mc-admin-svcacct-edit:

==============================
``mc admin user svcacct edit``
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct edit


Syntax
------

.. start-mc-admin-svcacct-edit-desc

The :mc-cmd:`mc admin user svcacct edit` command modifies the configuration of an access key associated to the specified user.

.. end-mc-admin-svcacct-edit-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command modifies the specified access keys:

      .. code-block:: shell  
         :class: copyable 

         mc admin user svcacct edit                                             \  
                               --secret-key "myuserserviceaccountnewsecretkey"  \     
                               --policy "/path/to/new/policy.json"              \  
                               myminio myuserserviceaccount

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 

         mc [GLOBALFLAGS] admin user svcacct edit            \  
                                             [--secret-key]  \  
                                             [--policy]      \  
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

   The service account for the command to modify.

.. mc-cmd:: --policy
   :optional:

   The path to a :ref:`policy document <minio-policy>` to attach to the new access key.
   The attached policy cannot grant access to any action or resource not explicitly allowed by the parent user's policies.

   The new policy overwrites any previously attached policy.

.. mc-cmd:: --secret-key
   :optional:

   The secret key to associate with the new access key.
   Overwrites the previous secret key.
   Applications using the access keys *must* update to use the new credentials to continue performing operations.


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
