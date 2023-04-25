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

The :mc:`mc admin user info` command returns detailed information of a user on the target MinIO deployment.

.. end-mc-admin-user-info-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command returns details of user ``username`` on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc admin user info myminio username

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin user info  \
                          ALIAS            \
			  USERNAME

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from which the command retrieves the specified user information.

.. mc-cmd:: USERNAME

   The name of the user whose information the command retrieves.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Example
-------

View User Details
~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin user info` to view detailed user information on an S3-compatible host:

.. code-block:: shell
   :class: copyable

   mc admin user info ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user info ALIAS>` with the :mc-cmd:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`USERNAME <mc admin user info USERNAME>` with the name of the user.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
