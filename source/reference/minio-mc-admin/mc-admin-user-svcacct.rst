.. _minio-mc-admin-user-svcacct:

=========================
``mc admin user svcacct``
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct

Description
-----------

.. start-mc-admin-user-svcacct-desc

The :mc:`mc admin user svcacct` command creates and manages :ref:`Access Keys <minio-idp-service-account>` on a MinIO deployment.

.. end-mc-admin-user-svcacct-desc

Each access keys is linked to a :ref:`user identity <minio-authentication-and-identity-management>` and inherits the :ref:`policies <minio-policy>` attached to it's parent user *or* those groups in which the parent user has membership. Each access key also supports an optional inline policy which further restricts access to a subset of actions and resources available to the parent user.

:mc:`mc admin user svcacct` only supports creating access keys for :ref:`MinIO-managed <minio-users>` and :ref:`Active Directory/LDAP-managed <minio-external-identity-management-ad-ldap>` accounts. 

To create access keys for :ref:`OpenID Connect-managed users <minio-external-identity-management-openid>`, log into the :ref:`MinIO Console <minio-console>` and generate the access keys through the UI.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

The :mc:`mc admin user svcacct` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc admin user svcacct add`
     - Adds a new access keys to an existing MinIO or AD/LDAP user

   * - :mc-cmd:`mc admin user svcacct list`
     - Lists the existing access keys associated to a MinIO or AD/LDAP user.

   * - :mc-cmd:`mc admin user svcacct remove`
     - Removes a access keys from a MinIO or AD/LDAP user.

   * - :mc-cmd:`mc admin user svcacct info`
     - Returns detailed information on a access keys.

   * - :mc-cmd:`mc admin user svcacct edit`
     - Modifies the secret key or inline policy associated with a access keys.

   * - :mc-cmd:`mc admin user svcacct enable`
     - Enables a access keys.

   * - :mc-cmd:`mc admin user svcacct disable`
     - Disables a access keys.

Syntax
------

.. mc-cmd:: add
   :fullpath:

   Adds a new access keys associated to the specified user.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command creates a new access keys associated to an existing MinIO user:

         .. code-block:: shell
            :class: copyable

            mc admin user svcacct add                       \
               --access-key "myuserserviceaccount"          \
               --secret-key "myuserserviceaccountpassword"  \
               --policy "/path/to/policy.json"              \
               myminio myuser

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin user svcacct add     \
                                        [--access-key]  \
                                        [--secret-key]  \
                                        [--policy]      \
                                        [--commment]    \
                                        ALIAS           \
                                        USER

   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of the MinIO deployment.

   .. mc-cmd:: USER
      :required:

      The name of the user to which MinIO adds the new access keys.

      - For :ref:`MinIO-managed users <minio-users>`, specify the access key for the user.
      - For :ref:`Active Directory/LDAP users <minio-external-identity-management-ad-ldap>`, specify the Distinguished Name of the user.
      - For :ref:`OpenID Connect users <minio-external-identity-management-openid>`, use the :ref:`MinIO Console <minio-console>` to generate access keys.

   .. mc-cmd:: --access-key
      :optional:

      The access key to associate with the new access keys. Omit to direct MinIO to autogenerate the access key for the new access keys.

      Access Key names *must* be unique across all users.

   .. mc-cmd:: --secret-key
      :optional:

      The secret key to associate with the new access keys. Omit to direct MinIO to autogenerate the secret key for the new access keys.

   .. mc-cmd:: --policy
      :optional:

      The path to a :ref:`policy document <minio-policy>` to attach to the new access keys. The attached policy cannot grant access to any action or resource not explicitly allowed by the parent user's policies.

   .. mc-cmd:: --comment
      :optional:

      .. versionadded:: RELEASE.2023-01-28T20-29-38Z

      Add a note to the service account.
      For example, you might specify the reason the service account exists.

.. mc-cmd:: list
   :fullpath:
   :alias: ls

   Lists all access keys associated to the specified user.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command lists all access keys associated to an existing MinIO user:

         .. code-block:: shell
            :class: copyable

            mc admin user svcacct list myminio myuser

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin user svcacct list  \
                                        ALIAS         \
                                        USER

   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of the MinIO deployment.

   .. mc-cmd:: USER
      :required:

      The name of the user to which MinIO adds the new access keys.

      - For :ref:`MinIO-managed users <minio-users>`, specify the access key for the user.
      - For :ref:`Active Directory/LDAP users <minio-external-identity-management-ad-ldap>`, specify the Distinguished Name of the user.
      - For :ref:`OpenID Connect users <minio-external-identity-management-openid>`, use the :ref:`MinIO Console <minio-console>` to list access keys.

.. mc-cmd:: remove
   :fullpath:
   :alias: rm

   Removes a access keys associated to the specified user. Applications can no longer authenticate using that access keys after removal.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command removes the specified access keys:

         .. code-block:: shell
            :class: copyable

            mc admin user svcacct remove myminio myuserserviceaccount

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin user svcacct remove   \
                                        ALIAS            \
                                        SERVICEACCOUNT

   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of the MinIO deployment.

   .. mc-cmd:: SERVICEACCOUNT
      :required:

      The access key for the access keys to remove.

.. mc-cmd:: info
   :fullpath:

   Returns a description of a access keys associated to the specified user. The description includes the parent user of the specified access keys, its status, and whether the access keys has an assigned inline policy.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command returns detailed information on the specified access keys:

         .. code-block:: shell
            :class: copyable

            mc admin user svcacct info --policy myminio myuserserviceaccount

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin user svcacct info    \
                                        [--policy]      \
                                        ALIAS           \
                                        SERVICEACCOUNT

   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of the MinIO deployment.

   .. mc-cmd:: SERVICEACCOUNT
      :required:

      The access key for the access keys to remove.

   .. mc-cmd:: --policy
      :optional:

      Returns the policy attached to the access keys in JSON format. The output is ``null`` if the access keys has no attached policy.

.. mc-cmd:: edit
   :fullpath:
   :alias: set

   Modifies the configuration of a access keys associated to the specified user.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command modifies the specified access keys:

         .. code-block:: shell
            :class: copyable

            mc admin user svcacct edit                                             \
                                  --secret-key "myuserserviceaccountnewsecretkey"  \
                                  --policy "/path/to/new/policy.json"              \
                                  myminio myuserserviceaccount

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin user svcacct edit    \
                                        [--secret-key]  \
                                        [--policy]      \
                                        ALIAS           \
                                        SERVICEACCOUNT

   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of the MinIO deployment.

   .. mc-cmd:: SERVICEACCOUNT
      :required:

      The access key for the access keys to modify.

   .. mc-cmd:: --secret-key
      :optional:

      The secret key to associate with the new access keys. Overwrites the previous secret key. Applications using the access keys *must* update to use the new credentials to continue performing operations.

   .. mc-cmd:: --policy
      :optional:

      The path to a :ref:`policy document <minio-policy>` to attach to the new access keys. The attached policy cannot grant access to any action or resource not explicitly allowed by the parent user's policies.

      The new policy overwrites any previously attached policy.

.. mc-cmd:: enable
   :fullpath:

   Enables a access keys for the specified user. Applications can only authenticate using enabled access keys.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command enables the specified access keys:

         .. code-block:: shell
            :class: copyable

            mc admin user svcacct enable myminio myuserserviceaccount

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin user svcacct enable  \
                                        ALIAS           \
                                        SERVICEACCOUNT

   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of the MinIO deployment.

   .. mc-cmd:: SERVICEACCOUNT
      :required:

      The access key for the access keys to enable.

.. mc-cmd:: disable
   :fullpath:

   Disables a access keys for the specified user. Applications can only authenticate using enabled access keys. 

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command disables the specified access keys:

         .. code-block:: shell
            :class: copyable

            mc admin user svcacct disable myminio myuserserviceaccount

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin user svcacct disable  \
                                        ALIAS            \
                                        SERVICEACCOUNT

   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of the MinIO deployment.

   .. mc-cmd:: SERVICEACCOUNT
      :required:

      The access key for the access keys to disable.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals