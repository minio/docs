.. _minio-mc-admin-user-info:

======================
``mc admin user info``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user info


Syntax
------

.. start-mc-admin-user-info-desc

The :mc:`mc admin user info` command returns detailed information of a :ref:`MinIO user <minio-internal-idp>` on the target MinIO deployment.

.. end-mc-admin-user-info-desc

To manage external Identity Provider users, see :mc:`OIDC <mc idp openid>` or :mc:`AD/LDAP <mc idp ldap>`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command returns details of user ``myuser`` on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc admin user info myminio myuser

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin user info      \
                                     ALIAS     \
	                             USERNAME

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment to retrieve user information from.

.. mc-cmd:: USERNAME

   The username to retrieve information for.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Example
-------

View User Details
~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user info` to view detailed user information for a user on a MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin user info ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user info ALIAS>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`USERNAME <mc admin user info USERNAME>` with the username of the user to display information for.

The output resembles the following:

.. code-block:: shell

   AccessKey: myuser
   Status: enabled
   PolicyName: readwrite
   MemberOf:


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
