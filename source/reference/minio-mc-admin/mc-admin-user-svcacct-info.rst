.. _minio-mc-admin-svcacct-info:

==============================
``mc admin user svcacct info``
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct info


Syntax
------

.. start-mc-admin-svcacct-info-desc

The :mc-cmd:`mc admin user svcacct info` command returns a description of the specified :ref:`access key <minio-id-access-keys>`.

.. end-mc-admin-svcacct-info-desc

"Access Keys" have equivalent functionality to and replace the concept of "Service Accounts" in MinIO.

The description output includes the following details, as available:

- Access Key
- Parent user of the specified access key
- Access key status (``on`` or ``off``)
- Policy or policies
- Comment
- Expiration

Use :mc-cmd:`~mc admin user svcacct info --policy` to view the attached policies.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command returns information on the specified access key:
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin user svcacct info myminio myuseraccesskey 

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin user svcacct info           \  
                                             [--policy]     \  
                                             ALIAS          \  
                                             ACCESSKEY

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment.

.. mc-cmd:: ACCESSKEY
   :required:

   The service account access key to display.

.. mc-cmd:: --policy
   :optional:

   Displays policies attached to the specified service account.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Display Service Account Details
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user svcacct info` to display details of a service account on a MinIO deployment:

.. code-block:: shell
   :class: copyable

      mc admin user svcacct info ALIAS ACCESSKEY

- Replace :mc-cmd:`ALIAS <mc admin user add ALIAS>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`ACCESSKEY <mc admin user svcacct info ACCESSKEY>` with the service account access key.


The output resembles the following:

.. code-block:: shell

   AccessKey: myuserserviceaccount
   ParentUser: myuser
   Status: on
   Comment: 
   Policy: implied
   Expiration: no-expiry


Display Service Account Policy Details
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user svcacct info` to display the policies attached to service account:

.. code-block:: shell
   :class: copyable

      mc admin user svcacct info --policy ALIAS ACCESSKEY

- Replace :mc-cmd:`ALIAS <mc admin user add ALIAS>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`ACCESSKEY <mc admin user svcacct info ACCESSKEY>` with the service account access key.

The output resembles the following:

.. code-block:: shell

   {
    "Version": "2012-10-17",
    "Statement": [
     {
      "Effect": "Allow",
      "Action": [
       "s3:*"
      ],
      "Resource": [
       "arn:aws:s3:::*"
      ]
     }
    ]
   }


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
