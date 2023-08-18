.. _minio-mc-idp-ldap-policy-attach:

=============================
``mc idp ldap policy attach``
=============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc idp ldap policy attach


Description
-----------

.. start-mc-idp-ldap-policy-attach-desc

The :mc:`mc idp ldap policy attach` command attaches one or more polices to an entity.

.. end-mc-idp-ldap-policy-attach-desc

.. tab-set::

   .. tab-item:: EXAMPLE

         The following example attaches the policy, ``userpolicy``, to the user ``bobfisher`` on the ``myminio`` deployment:

      .. code-block:: shell
         :class: copyable

         mc idp ldap policy attach myminio                                                  \
                                   userpolicy                                               \
                                   --user='uid=bobfisher,ou=people,ou=hwengg,dc=min,dc=io'

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap policy attach             \
                                          POLICYNAME         \
                                          [POLICY2] ...      \
                                          ALIAS              \
                                          [--user=`USER`]    \
                                          [--group=`GROUP`]


      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for AD/LDAP integration.
      - Replace ``POLICYNAME`` with the policy to attach to the entity.
        You may list multiple policies to attach to the entity.
      - Use must use one of either the ``--user`` or ``--group`` flag.
        You may only use the flag once in the command.
        You cannot use both flags in the same command.

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment with the entity for which to attach a policy.

   For example:

   .. code-block:: none

      mc idp ldap policy attach myminio


Example
~~~~~~~

The following example attaches two policies, ``policy1`` and ``policy2``, to the ``projectb`` group on the ``myminio`` deployment:

.. code-block:: shell
   :class: copyable

   mc idp ldap policy attach myminio                                                 \
                             policy1                                                 \
                             policy2                                                 \
                             --group='cn=projectb,ou=groups,ou=swengg,dc=min,dc=io'


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
