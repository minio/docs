.. _minio-mc-idp-ldap-disable:

=======================
``mc idp ldap disable``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc idp ldap disable


Description
-----------

.. start-mc-idp-ldap-disable-desc

The :mc:`mc idp ldap disable` command disables the currently configured AD/LDAP provider.

.. end-mc-idp-ldap-disable-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example disables the AD/LDAP configurations on the ``myminio`` deployment.

      .. code-block:: shell                                                                 
         :class: copyable

         mc idp ldap disable  \                                                             
                     myminio

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap disable  \
                                   ALIAS

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to disable the AD/LDAP integration.

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment for which to disable the AD/LDAP integration.

   For example:

   .. code-block:: none

      mc idp ldap disable myminio



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
