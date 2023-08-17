.. _minio-mc-idp-ldap-ls:

==================
``mc idp ldap ls``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc idp ldap ls
.. mc:: mc idp ldap list


Description
-----------

.. start-mc-idp-ldap-ls-desc

The :mc:`mc idp ldap ls` command lists the existing set of configurations for an AD/LDAP provider.

.. end-mc-idp-ldap-ls-desc

:mc:`mc idp ldap ls` is also known as :mc:`mc idp ldap list`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example lists the AD/LDAP configuration settings for the ``myminio`` deployment.

      .. code-block:: shell
         :class: copyable

         mc idp ldap ls       \
                     myminio

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap ls     \
                                   ALIAS

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to list the AD/LDAP integration.

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

      mc idp ldap ls myminio



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
