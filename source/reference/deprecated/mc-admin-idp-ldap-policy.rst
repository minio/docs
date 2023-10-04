.. _minio-mc-admin-idp-ldap-policy:

============================
``mc admin idp ldap policy``
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin idp ldap policy

.. versionchanged:: RELEASE.2023-05-26T23-31-54Z

   ``mc admin idp ldap policy`` and its subcommands replaced by :mc-cmd:`mc idp ldap policy`.

Description
-----------

.. start-mc-admin-idp-ldap-policy-desc

The :mc-cmd:`mc admin idp ldap policy` command allows you to view the mapping relationships between policies and the associated groups or users.

.. end-mc-admin-idp-ldap-policy-desc


The :mc-cmd:`mc admin idp ldap policy` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc admin idp ldap policy attach`
     - Attach a policy to an entity

   * - :mc-cmd:`mc admin idp ldap policy detach`
     - Detach a policy from an entity

   * - :mc-cmd:`mc admin idp ldap policy entities`
     - List policy entity mappings

Syntax
------

.. mc-cmd:: attach

   Attach one or more polices to entity.

   .. tab-set::

      .. tab-item:: EXAMPLES

         The following example attaches two policies, ``policy1`` and ``policy2``, to the ``projectb`` group on the ``myminio`` deployment. 

         .. code-block:: shell
            :class: copyable

             mc admin idp ldap policy attach myminio/                                               \
                                             policy1                                                \
                                             policy2                                                \
                                             --group='cn=projectb,ou=groups,ou=swengg,dc=min,dc=io'


         The following example attaches the policy, ``userpolicy``, to the user ``bobfisher`` on the ``myminio`` deployment. 

         .. code-block:: shell
            :class: copyable

             mc admin idp ldap policy attach myminio/                                               \
                                             mypolicy                                               \
                                             policy2                                                \
                                             --user='uid=bobfisher,ou=people,ou=hwengg,dc=min,dc=io'
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable
 
            mc [GLOBALFLAGS] admin idp ldap policy attach     \
                                            POLICYNAME        \
                                            [POLICY2] ...     \
                                            ALIAS             \
                                            [--user=`USER`]   \
                                            [--group=`GROUP`]

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for AD/LDAP integration.
         - Replace ``POLICYNAME`` with the policy to attach to the entity.
           You may list multiple policies to attach to the entity.
         - Use must use one of either the ``--user`` or ``--group`` flag.
           You may only use the flag once in the command.
           You cannot use both flags in the same command.


.. mc-cmd:: detach

   Detach one or more policies from an entity.

   .. tab-set::

      .. tab-item:: EXAMPLES

         The following example detaches two policies, ``policy1`` and ``policy2``, from the ``projectb`` group on the ``myminio`` deployment. 

         .. code-block:: shell
            :class: copyable

             mc admin idp ldap policy detach myminio/                                               \
                                             policy1                                                \
                                             policy2                                                \
                                             --group='cn=projectb,ou=groups,ou=swengg,dc=min,dc=io'


         The following example detaches the policy, ``userpolicy``, from the user ``bobfisher`` on the ``myminio`` deployment. 

         .. code-block:: shell
            :class: copyable

             mc admin idp ldap policy detach myminio/                                               \
                                             mypolicy                                               \
                                             policy2                                                \
                                             --user='uid=bobfisher,ou=people,ou=hwengg,dc=min,dc=io'
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable
 
            mc [GLOBALFLAGS] admin idp ldap policy detach     \
                                            POLICYNAME        \
                                            [POLICY2] ...     \
                                            ALIAS             \
                                            [--user=`USER`]   \
                                            [--group=`GROUP`]

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for AD/LDAP integration.
         - Replace ``POLICYNAME`` with the policy to detach from the entity.
           You may list multiple policies to detach from the entity.
         - Use must use one of either the ``--user`` or ``--group`` flag.
           You may only use the flag once in the command.
           You cannot use both flags in the same command.

.. mc-cmd:: entities

   Display a list of mappings for a user, group, and/or policy.

   .. tab-set::

      .. tab-item:: EXAMPLES

         The following example lists all mappings for a specific policy, a set of groups, and a selection of users on the ``myminio`` deployment.

         Specifically, it lists 
         - Users mapped to the ``finteam-policy`` policy.
         - Policies assigned to the ``uid=bobfisher,ou=people,ou=hwengg,dc=min,dc=io`` user
         - Policies assigned to the ``cn=projectb,ou=groups,ou=swengg,dc=min,dc=io`` group

         .. code-block:: shell
            :class: copyable

             mc admin idp ldap policy entities myminio/                                            \
                                          --policy finteam-policy                                  \
                                          --user 'uid=bobfisher,ou=people,ou=hwengg,dc=min,dc=io'  \
                                          --group 'cn=projectb,ou=groups,ou=swengg,dc=min,dc=io' 

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp ldap policy entities                \
                                            ALIAS                          \
                                            [--user `value`, -u `value`]   \
                                            [--group `value`, -g `value`]  \
                                            [--policy value]

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for AD/LDAP integration.
         - You may use each of the ``--user``, ``--group``, and/or ``--policy`` flags as many times as desired in the command.
         - For each flag, the output lists the entities mapped to the specified policy, user, or group.
         - Omit all flags to return a list of mappings for all policies.


Global Flags
------------

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
