.. _minio-mc-idp-ldap-rm:

==================
``mc idp ldap rm``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc idp ldap rm
.. mc:: mc idp ldap remove


Description
-----------

.. start-mc-idp-ldap-rm-desc

The :mc:`mc idp ldap rm` command removes the existing configuration for an AD/LDAP provider.

.. end-mc-idp-ldap-rm-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example removes the AD/LDAP provider settings for the ``myminio`` deployment.

      .. code-block:: shell                                                                 
         :class: copyable

         mc idp ldap rm  \                                                             
                     myminio

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap info  \
                                   ALIAS

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to remove the AD/LDAP integration.

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment for which to output the current AD/LDAP configuration.

   For example:

   .. code-block:: none

      mc idp ldap rm myminio



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
