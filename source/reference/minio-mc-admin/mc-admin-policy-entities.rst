============================
``mc admin policy entities``
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin policy entities

Syntax
------

.. start-mc-admin-policy-entities-desc

List the entities associated with a policy, user, or group on a target MinIO deployment. 

.. end-mc-admin-policy-entities-desc

.. versionchanged:: RELEASE.2023-05-27T05-56-19Z

   This command only returns :ref:`minio-managed users and groups <minio-users>`.

To list entities associated with an Active Directory or LDAP (AD/LDAP) configuration, use :mc-cmd:`mc idp ldap policy entities`.


For example, you can list all of the users and groups attached to a policy or list all of the policies attached to a specific user or group.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command returns a list of the policies associated with the user ``bob`` on the deployment at alias ``myminio``.

      .. code-block:: shell
         :class: copyable

         mc admin policy entities myminio/ --user bob  

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc admin policy entities         \
                         TARGET           \
                         [--user value]   \
                         [--group value]  \
                         [--policy value]


      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

.. important::

   This command is intended for managing policy associations for :ref:`MinIO-managed <minio-users>` users only.

   For managing policies to OpenID-managed users, see :ref:`minio-external-identity-management-openid`.

   For viewing policies for Active Directory/LDAP users or groups, use :mc-cmd:`mc idp ldap policy entities`.

Parameters
~~~~~~~~~~

The :mc-cmd:`mc admin policy entities` command accepts the following arguments:

.. mc-cmd:: TARGET
   :required:

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which to add the new policy.

.. mc-cmd:: --group
   :optional:

   The name of the group identity for which you want to list attached policies.

   You may include multiple groups by repeating the flag multiple times.
   The command returns each group with a list of associated entities.

.. mc-cmd:: --policy
   :optional:

   The name of a policy for which to list associated entities. 
      
   You may include multiple policies by repeating the flag multiple times.
   The command returns each policy with a list of all associated entities.

.. mc-cmd:: --user
   :optional:

   The username of the identity for which you want to list attached policies.

   You may include multiple users by repeating the flag multiple times.
   The command returns each user with a list of associated policies.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

List all entities and policy associations for a deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command lists all policies and the entity mappings associated with them on the deployment at alias ``myminio``.

.. code-block:: shell
   :class: copyable

   mc admin policy entities myminio/

List entities associated with two different policies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command lists all entities associated with the policies ``inteam-policy`` and ``mlteam-policy`` on the deployment at alias ``myminio``.

.. code-block:: shell
   :class: copyable

   mc admin policy entities myminio/ --policy finteam-policy --policy mlteam-policy

List policies associated with two different users
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command lists all policies associated with the users ``bob`` and ``james`` on the deployment at alias ``myminio``.

The command outputs the list of policies associated with ``bob`` then the list of policies associated with ``james`` on the deployment at alias ``myminio``.

.. code-block:: shell
   :class: copyable

   mc admin policy entities myminio/ --user bob --user james 

List policies associated with two different groups
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command lists all policies associated with the groups ``auditors`` and ``accounting`` on the deployment at alias ``myminio``.

The command outputs the list of policies associated with the group ``auditors`` then the list of policies associated with the group ``accounting`` on the deployment at alias ``myminio``.

.. code-block:: shell
   :class: copyable

   mc admin policy entities play/ --group auditors --group accounting

List policies associated with a policy, a group, and a user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command lists all policies associated with the policy ``finteam-policy``, the user ``bobfisher``, and the group ``consulting`` on the deployment at alias ``myminio``.

The command outputs the list of groups and users associated with the policy ``finteam-policy``, then lists the policies associated with the user ``bobfisher``, and finally lists the policies associated with the group ``consulting`` on the deployment at alias ``myminio``.

.. code-block:: shell
   :class: copyable

   mc admin policy entities play/ \                                                                        
              --policy finteam-policy --user bobfisher --group consulting 

Output
------

The output of the commands resembles the following:

.. code-block:: shell

   Query time: 2023-04-04T20:39:27Z
     Policy -> Entity Mappings:
       Policy: finteam-policy
         User Mappings:
           bobfisher
       Policy: diagnostics
         User Mappings:
           james
           bobfisher
           marcia
         Group Mappings:
           consulting
           auditors
     User -> Policy Mappings:
       User: bobfisher
         ALLOW_PUBLIC_READ
         finteam-policy
         diagnostics
         readonly
         readwrite
         writeonly