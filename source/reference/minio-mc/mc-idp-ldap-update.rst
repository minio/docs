.. _minio-mc-idp-ldap-update:

======================
``mc idp ldap update``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc idp ldap update


Description
-----------

.. start-mc-idp-ldap-update-desc

The :mc:`mc idp ldap update` command modifies an existing set of configurations for an AD/LDAP provider.

.. end-mc-idp-ldap-update-desc

Configuration Parameters
------------------------

:mc-cmd:`mc idp ldap update` supports the same configuration parameters as the :mc-conf:`identity_ldap` configuration key.
These parameters define the server's interaction with the Active Directory or LDAP IAM provider.

For a more detailed explanation of the configuration parameters, refer to the :ref:`config setting documentation <minio-ldap-config-settings>`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example changes two of the AD/LDAP configuration settings for the ``myminio`` deployment.

      .. code-block:: shell
         :class: copyable

         mc idp ldap update                                   \
                     myminio                               \
                     lookup_bind_dn=cn=admin,dc=min,dc=io  \
                     lookup_bind_password=somesecret

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap update           \
                                   ALIAS            \
                                   [CFG_PARAM1]     \
                                   [CFG_PARAM2]...

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to update for AD/LDAP integration.
      - Replace the ``[CFG_PARAM#]`` with each of the :ref:`configuration setting <minio-ldap-config-settings>` key-value pairs in the format of ``PARAMETER="value"``.

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment on which to modify an AD/LDAP integration

   For example:

   .. code-block:: none

      mc idp ldap update myminio



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
