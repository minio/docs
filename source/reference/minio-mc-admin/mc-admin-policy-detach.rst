==========================
``mc admin policy detach``
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin policy detach

Syntax
------

.. start-mc-admin-policy-detach-desc

Remove one or more IAM policies from either a :ref:`MinIO-managed user or a group <minio-users>`. 

.. end-mc-admin-policy-detach-desc

Exactly one :mc-cmd:`~mc admin policy detach --user` or one :mc-cmd:`~mc admin policy detach --group` is required.


.. tab-set::

   .. tab-item:: EXAMPLE

      The following command detaches the policy ``readonly`` from the user ``james`` on the deployment at alias ``myminio``.

      .. code-block:: shell
         :class: copyable

         mc admin policy detach myminio readonly --user james   

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc admin policy detach TARGET                         \
                                POLICY                         \
                                [POLICY...]                    \
                                [--user USER | --group GROUP]


      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


.. important::

   This command is intended for managing policy associations for :ref:`MinIO-managed <minio-users>` users only.

   For managing policies to OpenID-managed users, see :ref:`minio-external-identity-management-openid`.

   For detaching policies from Active Directory/LDAP users or groups, use :mc-cmd:`mc idp ldap policy detach`.

Parameters
~~~~~~~~~~

The :mc-cmd:`mc admin policy detach` command accepts the following arguments:

.. mc-cmd:: TARGET
   :required:

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment with the user or group for which you want to detach one or more policies.

.. mc-cmd:: POLICY
   :required:

   The name of the policy to detach from either the user or the group. 
   You may detach multiple policies at once by separating each policy name with a space.

   MinIO deployments include the following :ref:`built-in policies <minio-policy-built-in>` by default:

   - :userpolicy:`readonly` 
   - :userpolicy:`readwrite`
   - :userpolicy:`diagnostics`
   - :userpolicy:`writeonly`

.. mc-cmd:: --user
   :optional:

   The username of the identity you want to detach the policy or policies from.
   You may only list one user.

   You must include either the ``--user`` flag or the ``--group`` flag.
   You may not use the ``--user`` flag at the same time as the ``--group`` flag.

.. mc-cmd:: --group
   :optional:

   The name of the group identity you want to detach the policy or policies from.
   You may only list one group.

   All users with membership in the group lose access to any permissions granted by the policies associated to the group, unless those are granted by other policies or groups the users belong to.

   You must include either the ``--group`` flag or the ``--user`` flag.
   You may not use the ``--group`` flag at the same time as the ``--user`` flag.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Detach the policy ``readonly`` from the user ``james`` on the deployment at alias ``myminio``.

.. code-block:: shell
   :class: copyable

   mc admin policy detach myminio readonly --user james

Detach the ``audit-policy`` and ``acct-policy`` policies from group ``legal`` on the deployment at alias ``myminio``.

.. code-block:: shell
   :class: copyable

   mc admin policy detach myminio audit-policy acct-policy --group legal
