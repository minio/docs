.. _minio-mc-admin-user-remove:

========================
``mc admin user remove``
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user remove

Syntax
------

.. start-mc-admin-user-remove-desc

The :mc:`mc admin user remove` command removes a :ref:`MinIO user <minio-internal-idp>` on the target MinIO deployment.

.. end-mc-admin-user-remove-desc

To manage external Identity Provider users, see :mc:`OIDC <mc admin idp openid>` or :mc:`AD/LDAP <mc admin idp ldap>`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes user ``myuser`` on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc admin user remove myminio myuser

   .. tab-item:: SYNTAX

      Removes a user on the target MinIO deployment.

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin user remove    \
                                     ALIAS     \
				     USERNAME

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc:`alias <mc alias>` of the configured MinIO deployment with the user to remove.

.. mc-cmd:: USERNAME
   :required:

   The username of the user to remove.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Example
-------

Remove a User
~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user remove` to remove a user from a MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin user remove ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user remove TARGET>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`USERNAME <mc admin user remove USERNAME>` with the username of the user to remove.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
