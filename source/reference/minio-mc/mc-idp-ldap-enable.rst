.. _minio-mc-idp-ldap-enable:

======================
``mc idp ldap enable``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc idp ldap enable


Description
-----------

.. start-mc-idp-ldap-enable-desc

The :mc:`mc idp ldap enable` command enables the currently configured AD/LDAP provider.

.. end-mc-idp-ldap-enable-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example enables the AD/LDAP configurations on the ``myminio`` deployment.

      .. code-block:: shell                                                                 
         :class: copyable

         mc idp ldap enable  \                                                             
                     myminio

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap disable  \
                                   ALIAS

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to enable the AD/LDAP integration.

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment for which to enable the AD/LDAP integration.

   For example:

   .. code-block:: none

      mc idp ldap enable myminio



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
