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

The :mc:`mc admin user svcacct` command creates and manages :ref:`Service Accounts <minio-idp-service-account>` on a MinIO deployment.

.. end-mc-admin-user-svcacct-desc

Each service account is linked to a :ref:`user identity <minio-authentication-and-identity-management>` and inherits the :ref:`policies <minio-policy>` attached to it's parent user *or* those groups in which the parent user has membership. Service accounts also support an optional inline policy which further restricts access to a subset of actions and resources available to the parent user.

:mc:`mc admin user svcacct` only supports creating service accounts for :ref:`MinIO-managed <minio-users>` and :ref:`Active Directory/LDAP-managed <minio-external-identity-management-ad-ldap>` accounts. 

To create service accounts for :ref:`OpenID Connect-managed users <minio-external-identity-management-openid>`, log into the :ref:`MinIO Console <minio-console>` and generate the service account through the UI.

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
     - Adds a new service account to an existing MinIO or AD/LDAP user

   * - :mc-cmd:`mc admin user svcacct list`
     - Lists the existing service accounts associated to a MinIO or AD/LDAP user.

   * - :mc-cmd:`mc admin user svcacct remove`
     - Removes a service account from a MinIO or AD/LDAP user.

   * - :mc-cmd:`mc admin user svcacct info`
     - Returns detailed information on a service account.

   * - :mc-cmd:`mc admin user svcacct edit`
     - Modifies the secret key or inline policy associated with a service account.

   * - :mc-cmd:`mc admin user svcacct enable`
     - Enables a service account.

   * - :mc-cmd:`mc admin user svcacct disable`
     - Disables a service account.

Syntax
------

.. mc-cmd:: add
   :fullpath:

   Adds a new service account associated to the specified user.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command creates a new service account associated to an existing MinIO user:

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
                                        ALIAS
                                        USER

   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of the MinIO deployment.

   .. mc-cmd:: USER
      :required:

      The name of the user to which MinIO adds the new service account.

      - For :ref:`MinIO-managed users <minio-users>`, specify the access key for the user.
      - For :ref:`Active Directory/LDAP users <minio-external-identity-management-ad-ldap>`, specify the Distinguished Name of the user.
      - For :ref:`OpenID Connect users <minio-external-identity-management-openid>`, use the :ref:`MinIO Console <minio-console>` to generate service accounts.

   .. mc-cmd:: --access-key
      :optional:

      The access key to associate with the new service account. Omit to direct MinIO to autogenerate the access key for the new service account.

      Service account names *must* be unique across all users.

   .. mc-cmd:: --secret-key
      :optional:

      The secret key to associate with the new service account. Omit to direct MinIO to autogenerate the secret key for the new service account.

   .. mc-cmd:: --policy
      :optional:

      The path to a :ref:`policy document <minio-policy>` to attach to the new service account. The attached policy cannot grant access to any action or resource not explicitly allowed by the parent user's policies.

.. mc-cmd:: list
   :fullpath:
   :alias: ls

   Lists all service accounts associated to the specified user.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command lists all service accounts associated to an existing MinIO user:

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

      The name of the user to which MinIO adds the new service account.

      - For :ref:`MinIO-managed users <minio-users>`, specify the access key for the user.
      - For :ref:`Active Directory/LDAP users <minio-external-identity-management-ad-ldap>`, specify the Distinguished Name of the user.
      - For :ref:`OpenID Connect users <minio-external-identity-management-openid>`, use the :ref:`MinIO Console <minio-console>` to list service accounts.

.. mc-cmd:: remove
   :fullpath:
   :alias: rm

   Removes a service account associated to the specified user. Applications can no longer authenticate using that service account after removal.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command removes the specified service account:

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

      The access key for the service account to remove.

.. mc-cmd:: info
   :fullpath:

   Returns a description of a service account associated to the specified user. The description includes the parent user of the specified service account, its status, and whether the service account has an assigned inline policy.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command returns detailed information on the specified service account:

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

      The access key for the service account to remove.

   .. mc-cmd:: --policy
      :optional:

      Returns the policy attached to the service account in JSON format. The output is ``null`` if the service account has no attached policy.

.. mc-cmd:: edit
   :fullpath:
   :alias: set

   Modifies the configuration of a service account associated to the specified user.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command modifies the specified service account:

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

      The access key for the service account to modify.

   .. mc-cmd:: --secret-key
      :optional:

      The secret key to associate with the new service account. Overwrites the previous secret key. Applications using the service account *must* update to use the new credentials to continue performing operations.

   .. mc-cmd:: --policy
      :optional:

      The path to a :ref:`policy document <minio-policy>` to attach to the new service account. The attached policy cannot grant access to any action or resource not explicitly allowed by the parent user's policies.

      The new policy overwrites any previously attached policy.

.. mc-cmd:: enable
   :fullpath:

   Enables a service account for the specified user. Applications can only authenticate using enabled service accounts.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command enables the specified service account:

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

      The access key for the service account to enable.

.. mc-cmd:: disable
   :fullpath:

   Disables a service account for the specified user. Applications can only authenticate using enabled service accounts. 

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following command disables the specified service account:

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

      The access key for the service account to disable.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals