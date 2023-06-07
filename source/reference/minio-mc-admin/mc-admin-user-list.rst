.. _minio-mc-admin-user-list:

====================
``mc admin user ls``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user list
.. mc:: mc admin user ls


Syntax
------

.. start-mc-admin-user-list-desc

The :mc:`mc admin user ls` command lists all :ref:`MinIO users <minio-internal-idp>` on the target MinIO deployment.

.. end-mc-admin-user-list-desc

The :mc:`mc admin user list` command has equivalent functionality to :mc:`mc admin user ls`.

:mc-cmd:`mc admin user ls` does *not* return the access key or secret key associated to a user.
Use :mc-cmd:`mc admin user info` to retrieve detailed user information, including the user access key.

To manage external Identity Provider users, see :mc:`OIDC <mc idp openid>` or :mc:`AD/LDAP <mc idp ldap>`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command lists all users on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc admin user ls myminio

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin user list   \
                                     ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from which the command lists users.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Example
-------

List Available Users
~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user ls` to list all users on a MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin user ls ALIAS

- Replace :mc-cmd:`ALIAS <mc admin user ls ALIAS>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

The output resembles the following:

.. code-block:: shell

   enabled    devadmin              readwrite
   enabled    devtest               readonly
   enabled    newuser


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
