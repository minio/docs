.. _minio-mc-admin-user-enable:

========================
``mc admin user enable``
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user enable


Syntax
------

.. start-mc-admin-user-enable-desc

The :mc:`mc admin user enable` command enables a user on the target MinIO deployment.

.. end-mc-admin-user-enable-desc

Clients can only use enabled users to authenticate to the MinIO deployment.
Users created using :mc-cmd:`mc admin user add` are enabled by default.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command enables user ``username`` on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc admin user enable myminio username

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin user enable  \
                          ALIAS              \
			  USERNAME

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc:`alias <mc alias>` of a configured MinIO deployment on which the command enables the specified user.

.. mc-cmd:: USERNAME
   :required:

   The name of the user to enable.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Example
-------

Enable a User
~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user enable` to enable a user on an S3-compatible host.

.. code-block:: shell
   :class: copyable

   mc admin user enable ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user enable ALIAS>` with the :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`USERNAME <mc admin user enable USERNAME>` with the name of the user to enable.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
