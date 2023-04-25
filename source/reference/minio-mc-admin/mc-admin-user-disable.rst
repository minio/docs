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

The :mc:`mc admin user disable` command disables a user on the target MinIO deployment.

.. end-mc-admin-user-disable-desc

Clients cannot use the user credentials to authenticate to the MinIO deployment.
Disabling a user does *not* remove that user from the deployment.
Use :mc-cmd:`mc admin user enable` to enable a disabled user on an S3-compatible host.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command disables user ``username`` on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc admin user disable myminio username

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin user disable  \
                          ALIAS               \
			  USERNAME

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc:`alias <mc alias>` of a configured MinIO deployment on which the command disables the specified user.

.. mc-cmd:: USERNAME
   :required:

   The name of the user to disable.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Example
-------

Disable a User
~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user disable` to disable a user on an S3-compatible host.

.. code-block:: shell
   :class: copyable

   mc admin user disable ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user disable TARGET>` with the :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`USERNAME <mc admin user disable USERNAME>` with the name of the user to disable.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
