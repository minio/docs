.. _minio-mc-admin-idp-ldap:

=====================
``mc admin idp ldap``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin idp ldap

Description
-----------

.. start-mc-admin-idp-ldap-desc

The :mc-cmd:`mc admin idp ldap` commands allow you to add, modify, review, list, remove, enable, and disable server configurations to 3rd party :ref:`Active Directory or LDAP Identity and Access Management (IAM) integrations <minio-external-identity-management-ad-ldap>`.

.. end-mc-admin-idp-ldap-desc

Define configuration settings as an alternative to using environment variables when :ref:`setting up an AD/LDAP connection <minio-authenticate-using-ad-ldap-generic>`.

.. note::

   Configuration settings do **not** override settings configured as environment variables.


The :mc-cmd:`mc admin idp ldap` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc admin idp ldap add`
     - Create an AD/LDAP IDP server configuration.

   * - :mc-cmd:`mc admin idp ldap update`
     - Modify an existing AD/LDAP IDP server configuration.

   * - :mc-cmd:`mc admin idp ldap remove`
     - Remove an AD/LDAP IDP server configuration from a deployment.

   * - :mc-cmd:`mc admin idp ldap list`
     - Outputs a list of the existing AD/LDAP server configurations for a deployment.

   * - :mc-cmd:`mc admin idp ldap info`
     - Displays details for a specific AD/LDAP server configuration.

   * - :mc-cmd:`mc admin idp ldap enable`
     - Enables an AD/LDAP server configuration.

   * - :mc-cmd:`mc admin idp ldap disable`
     - Disables an AD/LDAP server configuration.

   * - :mc-cmd:`mc admin idp ldap policy entities`
     - List policy association entities

Configuration Parameters
------------------------

The :mc-cmd:`mc admin idp ldap` subcommands support configuration parameters.
The parameters define the server's interaction with the Active Directory or LDAP IAM provider.

For a more detailed explanation of the configuration parameters, refer to the :ref:`config setting documentation <minio-ldap-config-settings>`.

Syntax
------

.. mc-cmd:: add

   Create a new set of configurations for an AD/LDAP provider.

   You can run the command multiple times to set up multiple Active Directory or LDAP providers.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example creates the configuration settings for the ``myminio`` deployment as defined in a new ``test-config`` setup for LDAP integration.

         .. code-block:: shell
            :class: copyable

             mc admin idp ldap add                                               \
                  myminio                                                        \
                  test-config                                                    \                                                        
                  server_addr=myldapserver:636                                   \                                                       
                  lookup_bind_dn=cn=admin,dc=min,dc=io                           \                                               
                  lookup_bind_password=somesecret                                \                                                    
                  user_dn_search_base_dn=dc=min,dc=io                            \                                                
                  user_dn_search_filter="(uid=%s)"                               \                                                   
                  group_search_base_dn=ou=swengg,dc=min,dc=io                    \                                        
                  group_search_filter="(&(objectclass=groupofnames)(member=%d))"                                                          
                                    
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp ldap add          \
                                       ALIAS             \
                                       [CFG_NAME]        \
                                       [CFG_PARAM1]      \
                                       [CFG_PARAM2]...

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for AD/LDAP integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the command creates default configuration values.
         - Replace the ``[CFG_PARAM#]`` with each of the :ref:`configuration setting <minio-ldap-config-settings>` key-value pairs in the format of ``PARAMETER="value"``.

.. mc-cmd:: update

   Modify an existing set of configurations for an AD/LDAP provider.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example changes two of the configuration settings for the ``myminio`` deployment as defined in the ``test-config`` setup for LDAP integration.

         .. code-block:: shell
            :class: copyable

            mc admin idp ldap update                                \
                              myminio                               \
                              test_config                           \
                              lookup_bind_dn=cn=admin,dc=min,dc=io  \
                              lookup_bind_password=somesecret                                                              
                                    
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp ldap update           \
                                            ALIAS            \
                                            [CFG_NAME]       \
                                            [CFG_PARAM1]     \
                                            [CFG_PARAM2]...

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for AD/LDAP integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the command updates the default configuration.
         - Replace the ``[CFG_PARAM#]`` with each of the :ref:`configuration setting <minio-ldap-config-settings>` key-value pairs to update in the format of ``PARAMETER="value"``.

.. mc-cmd:: remove

   Remove an existing set of configurations for an AD/LDAP provider.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example removes the ``test-config`` settings for the ``myminio`` deployment.

         .. code-block:: shell
            :class: copyable

            mc admin idp ldap remove myminio test_config                                                              
                                    
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp ldap remove     \
                                            ALIAS      \
                                            [CFG_NAME]

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for AD/LDAP integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the command removes the default configurations. 

.. mc-cmd:: list

   Outputs a list of existing configuration sets for AD/LDAP providers.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example outputs a list of all AD/LDAP configuration sets defined for the ``myminio`` deployment.

         .. code-block:: shell
            :class: copyable

            mc admin idp ldap list myminio                                                            
                                    
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp ldap list ALIAS

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to list AD/LDAP integration for.


.. mc-cmd:: info

   Outputs the set of values defined for an existing set of server configurations for an AD/LDAP provider.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example outputs the configuration settings defined for the ``test_config`` set of AD/LDAP settings on the ``myminio`` deployment.

         .. code-block:: shell
            :class: copyable

            mc admin idp ldap info myminio test_config
                                    
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp ldap info     \
                                            ALIAS      \
                                            [CFG_NAME]

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for AD/LDAP integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the information displays for the default server configuration.

.. mc-cmd:: enable

   Begin using an existing set of configurations for an AD/LDAP provider.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example enables the server configurations defined as ``test_config`` on the ``myminio`` deployment.

         .. code-block:: shell
            :class: copyable

            mc admin idp ldap enable       \
                              myminio      \
                              test_config

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp ldap enable     \
                                            ALIAS      \
                                            [CFG_NAME]

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for AD/LDAP integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the command enables the default configuration values.

.. mc-cmd:: disable

   Stop using a set of configurations for an AD/LDAP provider.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example disables the server configurations defined as ``test_config`` on the ``myminio`` deployment.

         .. code-block:: shell
            :class: copyable

            mc admin idp ldap disable      \
                              myminio      \
                              test_config

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp ldap disable       \
                                            ALIAS         \
                                            [CFG_NAME]

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for AD/LDAP integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the command disables the default configuration values.

Global Flags
------------

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

