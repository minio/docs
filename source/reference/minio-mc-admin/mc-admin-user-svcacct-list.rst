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

      The output resembles the following:
   
      .. code-block:: shell

            Access Key        | Expiry
         5XF3ZHNZK6FBDWH9JMLX | 2023-06-24 07:00:00 +0000 UTC
         F4V2BBUZSWY7UG96ED70 | 2023-12-24 18:00:00 +0000 UTC
         FZVSEZ8NM9JRBEQZ7B8Q | no-expiry
         HOXGL8ON3RG0IKYCHCUD | no-expiry

      .. versionadded:: RELEASE.2023-05-26T23-31-54Z

        The list of access keys includes the expiry date, or ``no-expiry`` for keys that do not expire.
	 
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
