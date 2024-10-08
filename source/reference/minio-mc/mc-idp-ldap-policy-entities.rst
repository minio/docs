.. _minio-mc-idp-ldap-policy-entities:

===============================
``mc idp ldap policy entities``
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc idp ldap policy entities


Description
-----------

.. start-mc-idp-ldap-policy-entities-desc

The :mc:`mc idp ldap policy entities` command displays a list of mappings for a user, group, and/or policy.

.. end-mc-idp-ldap-policy-entities-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example lists all mappings for a specific policy, a set of groups, and a selection of users on the ``myminio`` deployment.

      Specifically, it lists:

      - Users mapped to the ``finteam-policy`` policy.
      - Policies assigned to the ``uid=bobfisher,ou=people,ou=hwengg,dc=min,dc=io`` user.
      - Policies assigned to the ``cn=projectb,ou=groups,ou=swengg,dc=min,dc=io`` group.

      .. code-block:: shell
         :class: copyable

         mc idp ldap policy entities myminio                                                  \
                                     --policy finteam-policy                                  \
                                     --user 'uid=bobfisher,ou=people,ou=hwengg,dc=min,dc=io'  \
                                     --group 'cn=projectb,ou=groups,ou=swengg,dc=min,dc=io'

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap policy entities                       \
                                          ALIAS                          \
                                          [--group `value`, -g `value`]  \
                                          [--policy value]               \
                                          [--user `value`, -u `value`]

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for AD/LDAP integration.
      - You may use each of the ``--user``, ``--group``, and/or ``--policy`` flags as many times as desired in the command.
      - For each flag, the output lists the entities mapped to the specified policy, user, or group.
      - Omit all flags to return a list of mappings for all policies.

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment for which to display the entity mappings.

   For example:

   .. code-block:: none

      mc idp ldap policy entities myminio

.. mc-cmd:: --group
   :optional:

   Returns a list of users and policies associated with the specified group.
   Repeat the flag to return a list for multiple groups.

.. mc-cmd:: --policies
   :optional:

   Returns a list of users and groups associated with the specified policy.
   Repeat the flag to return a list for multiple policies.

.. mc-cmd:: --user
   :optional:

   Returns a list of groups to which the user belongs and the policies associated with each group.
   The output includes only groups assigned to policies.

   Repeat the flag to return a list for multiple users.

Example
~~~~~~~

The following example lists the entities mapped to each of two policies, ``policy1`` and ``policy2`` and entities mapped to the ``projectb`` group on the ``myminio`` deployment:

.. code-block:: shell
   :class: copyable

   mc idp ldap policy entities myminio                                                 \
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
