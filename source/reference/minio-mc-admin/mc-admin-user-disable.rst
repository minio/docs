.. _minio-mc-admin-user-disable:

=========================
``mc admin user disable``
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user disable


Syntax
------

.. start-mc-admin-user-disable-desc

The :mc:`mc admin user disable` command disables a :ref:`MinIO user <minio-internal-idp>` on the target MinIO deployment.

.. end-mc-admin-user-disable-desc

Clients cannot use the user credentials to authenticate to the MinIO deployment.
Disabling a user does *not* remove that user from the deployment.
Use :mc-cmd:`mc admin user enable` to enable a disabled user on a MinIO deployment.

To manage external Identity Provider users, see :mc:`OIDC <mc admin idp openid>` or :mc:`AD/LDAP <mc admin idp ldap>`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command disables user ``myuser`` on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc admin user disable myminio myuser

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin user disable   \
                                     ALIAS     \
				     USERNAME

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc:`alias <mc alias>` of the MinIO deployment with the user to disable.

.. mc-cmd:: USERNAME
   :required:

   The username of the user to disable.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Example
-------

Disable a User
~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user disable` to disable a user on a MinIO deployment.

.. code-block:: shell
   :class: copyable

   mc admin user disable ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user disable ALIAS>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`USERNAME <mc admin user disable USERNAME>` with the username of the user to disable.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
