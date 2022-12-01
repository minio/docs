.. _minio-mc-admin-idp-openid:

=======================
``mc admin idp openid``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin idp openid

Description
-----------

.. start-mc-admin-idp-openid-desc

The :mc-cmd:`mc admin idp openid` commands allow you to add, modify, review, list, remove, enable, and disable server configurations to 3rd party :ref:`OpenID Identity and Access Management (IAM) integrations <minio-external-identity-management-openid>`.

.. end-mc-admin-idp-openid-desc

Define configuration settings as an alternative to using environment variables when :ref:`setting up an OpenID connection <minio-external-identity-management-openid-configure>`.


The :mc-cmd:`mc admin idp openid` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc admin idp openid add`
     - Create an OpenID IDP server configuration.

   * - :mc-cmd:`mc admin idp openid update`
     - Modify an existing OpenID IDP server configuration.

   * - :mc-cmd:`mc admin idp openid remove`
     - Remove an OpenID IDP server configuration from a deployment.

   * - :mc-cmd:`mc admin idp openid list`
     - Outputs a list of the existing OpenID server configurations for a deployment.

   * - :mc-cmd:`mc admin idp openid info`
     - Displays details for a specific OpenID server configuration.

   * - :mc-cmd:`mc admin idp openid enable`
     - Enables an OpenID server configuration.

   * - :mc-cmd:`mc admin idp openid disable`
     - Disables an OpenID server configuration.

Configuration Parameters
------------------------

The :mc-cmd:`mc admin idp openid` subcommands support configuration parameters.
The parameters define the server's interaction with the IAM provider.

For a more detailed explanation of the configuration parameters, refer to the :ref:`config setting documentation <minio-open-id-config-settings>`.

Syntax
------

.. mc-cmd:: add

   Create a new set of configurations for an OpenID provider.

   You can run the command multiple times to set up multiple OpenID providers.

   When adding multiple OpenID providers, only one can be a JWT Claim-based provider.
   All others must be role-based providers.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example creates the configuration settings for the ``myminio`` deployment as defined in a new ``test-config`` setup for Dex integration.

         .. code-block:: shell
            :class: copyable

             mc admin idp openid add myminio test-config                                  \                                                
                client_id=minio-client-app                                                \
                client_secret=minio-client-app-secret                                     \           
                config_url="http://localhost:5556/dex/.well-known/openid-configuration"   \
                scopes="openid,groups"                                                    \
                redirect_uri="http://127.0.0.1:10000/oauth_callback"                      \
                role_policy="consoleAdmin"                                                           
                                    
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp openid add        \
                                       ALIAS             \
                                       [CFG_NAME]        \
                                       [CFG_PARAM1]      \
                                       [CFG_PARAM2]...

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for OpenID integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the command creates default configuration values.
         - Replace the ``[CFG_PARAM#]`` with each of the :ref:`configuration setting <minio-open-id-config-settings>` key-value pairs in the format of ``PARAMETER="value"``.

.. mc-cmd:: update

   Modify an existing set of configurations for an OpenID provider.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example changes two of the configuration settings for the ``myminio`` deployment as defined in the ``test-config`` setup for Dex integration.

         .. code-block:: shell
            :class: copyable

            mc admin idp openid update                      \
                                myminio                     \
                                test_config                 \
                                scopes="openid,groups"      \
                                role_policy="consoleAdmin"                                                              
                                    
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp openid update           \
                                              ALIAS            \
                                              [CFG_NAME]       \
                                              [CFG_PARAM1]     \
                                              [CFG_PARAM2]...

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for OpenID integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the command updates the default configuration.
         - Replace the ``[CFG_PARAM#]`` with each of the :ref:`configuration setting <minio-open-id-config-settings>` key-value pairs to update in the format of ``PARAMETER="value"``.

.. mc-cmd:: remove

   Remove an existing set of configurations for an OpenID provider.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example removes the ``test-config`` settings for the ``myminio`` deployment.

         .. code-block:: shell
            :class: copyable

            mc admin idp openid remove myminio test_config                                                              
                                    
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp openid remove     \
                                              ALIAS      \
                                              [CFG_NAME]

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for OpenID integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the command removes the default configurations. 

.. mc-cmd:: list

   Outputs a list of existing configuration sets for OpenID providers.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example outputs a list of all OpenID configuration sets defined for the ``myminio`` deployment.

         .. code-block:: shell
            :class: copyable

            mc admin idp openid list myminio                                                            
                                    
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp openid list ALIAS

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to list OpenID integrations for.


.. mc-cmd:: info

   Outputs the set of values defined for an existing set of server configurations for an OpenID provider.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example outputs the configuration settings defined for the ``test_config`` set of OpenID settings on the ``myminio`` deployment.

         .. code-block:: shell
            :class: copyable

            mc admin idp openid info myminio test_config
                                    
      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp openid info     \
                                              ALIAS      \
                                              [CFG_NAME]

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for OpenID integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the information displays for the default server configuration.

.. mc-cmd:: enable

   Begin using an existing set of configurations for an OpenID provider.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example enables the server configurations defined as ``test_config`` on the ``myminio`` deployment.

         .. code-block:: shell
            :class: copyable

            mc admin idp openid enable       \
                                myminio      \
                                test_config

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp openid enable     \
                                              ALIAS      \
                                              [CFG_NAME]

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for OpenID integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the command enables the default configuration values.

.. mc-cmd:: disable

   Stop using a set of configurations for an OpenID provider.

   .. tab-set::

      .. tab-item:: EXAMPLE

         The following example disables the server configurations defined as ``test_config`` on the ``myminio`` deployment.

         .. code-block:: shell
            :class: copyable

            mc admin idp openid disable      \
                                myminio      \
                                test_config

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin idp openid disable       \
                                              ALIAS         \
                                              [CFG_NAME]

         - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment to configure for OpenID integration.
         - Replace ``CFG_NAME`` with a unique string for this configuration.
           If not specified, the command disables the default configuration values.



Global Flags
------------

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals