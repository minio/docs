.. _minio-mc-admin-idp-ldap-policy:

============================
``mc admin idp ldap policy``
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin idp ldap policy

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

   * - :mc-cmd:`mc admin idp ldap policy entities`
     - List policy entity mappings

Syntax
------

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