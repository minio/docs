1. Set the Active Directory / LDAP Configuration Settings

   Configure the AD/LDAP provider using one of the following:

   * MinIO Client
   * Environment variables
   * MinIO Console

   All methods require starting/restarting the MinIO deployment to apply changes.

   The following tabs provide a quick reference for the available configuration methods:

   .. tab-set::

      .. tab-item:: MinIO Client

         MinIO supports specifying the AD/LDAP provider settings using :mc:`mc idp ldap` commands.

         For distributed deployments, the :mc:`mc idp ldap` command applies the configuration to all nodes in the deployment. 

         The following example code sets *all* configuration settings related to configuring an AD/LDAP provider for external identity management.
	 The minimum *required* settings are:

         - :mc-conf:`server_addr <identity_ldap.server_addr>`
         - :mc-conf:`lookup_bind_dn <identity_ldap.lookup_bind_dn>`
         - :mc-conf:`lookup_bind_password <identity_ldap.lookup_bind_password>`
         - :mc-conf:`user_dn_search_base_dn <identity_ldap.user_dn_search_base_dn>`
         - :mc-conf:`user_dn_search_filter <identity_ldap.user_dn_search_filter>`

        .. code-block:: shell
           :class: copyable

	   mc idp ldap add ALIAS                                                   \
	      server_addr="ldaps.example.net:636"                                  \
              lookup_bind_dn="CN=xxxxx,OU=xxxxx,OU=xxxxx,DC=example,DC=net"        \
	      lookup_bind_password="xxxxxxxx"                                      \
	      user_dn_search_base_dn="DC=example,DC=net"                           \
	      user_dn_search_filter="(&(objectCategory=user)(sAMAccountName=%s))"  \
	      group_search_filter= "(&(objectClass=group)(member=%d))"             \
	      group_search_base_dn="ou=MinIO Users,dc=example,dc=net"              \
              enabled="true"                                                       \
              tls_skip_verify="off"                                                \
              server_insecure=off                                                  \
              server_starttls="off"                                                \
              srv_record_name=""                                                   \
              comment="Test LDAP server"

        For more complete documentation on these settings, see :mc:`mc idp ldap`.

	.. admonition:: :mc:`mc idp ldap` recommended
           :class: note

           :mc:`mc idp ldap` offers additional features and improved validation over :mc-cmd:`mc admin config set` runtime configuration settings.
           :mc:`mc idp ldap` supports the same settings as :mc:`mc admin config` and the :mc-conf:`identity_ldap` configuration key.

           The :mc-conf:`identity_ldap` configuration key remains available for existing scripts and tools.

      .. tab-item:: Environment Variables

         MinIO supports specifying the AD/LDAP provider settings using :ref:`environment variables <minio-server-envvar-external-identity-management-ad-ldap>`.
	 The :mc:`minio server` process applies the specified settings on its next startup.
	 For distributed deployments, specify these settings across all nodes in the deployment using the *same* values.
	 Any differences in server configurations between nodes will result in startup or configuration failures.

         The following example code sets *all* environment variables related to configuring an AD/LDAP provider for external identity management. The minimum *required* variable are:

         - :envvar:`MINIO_IDENTITY_LDAP_SERVER_ADDR`
         - :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN`
         - :envvar:`MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD`
         - :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN`
         - :envvar:`MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER`

         .. code-block:: shell
            :class: copyable

            export MINIO_IDENTITY_LDAP_SERVER_ADDR="ldaps.example.net:636"
            export MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN="CN=xxxxx,OU=xxxxx,OU=xxxxx,DC=example,DC=net"
            export MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN="dc=example,dc=net"
            export MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER="(&(objectCategory=user)(sAMAccountName=%s))"
            export MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD="xxxxxxxxx"
            export MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER="(&(objectClass=group)(member=%d))"
            export MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN="ou=MinIO Users,dc=example,dc=net"
            export MINIO_IDENTITY_LDAP_TLS_SKIP_VERIFY="off"
            export MINIO_IDENTITY_LDAP_SERVER_INSECURE="off"
            export MINIO_IDENTITY_LDAP_SERVER_STARTTLS="off"
            export MINIO_IDENTITY_LDAP_SRV_RECORD_NAME=""
            export MINIO_IDENTITY_LDAP_COMMENT="LDAP test server"

         For complete documentation on these variables, see :ref:`minio-server-envvar-external-identity-management-ad-ldap`

      .. tab-item:: MinIO Console

         MinIO supports specifying the AD/LDAP provider settings using the :ref:`MinIO Console <minio-console>`.
         For distributed deployments, configuring AD/LDAP from the Console applies the configuration to all nodes in the deployment.

	 .. include:: /includes/common-minio-external-auth.rst
            :start-after: start-minio-ad-ldap-console-enable
            :end-before: end-minio-ad-ldap-console-enable

#. Restart the MinIO Deployment

   You must restart the MinIO deployment to apply the configuration changes.

   If you configured AD/LDAP from the MinIO Console, no additional action is required.
   The MinIO Console automatically restarts the deployment after saving the new AD/LDAP configuration.

   For MinIO Client and environment variable configuration, use the :mc-cmd:`mc admin service restart` command to restart the deployment:

   .. code-block:: shell
      :class: copyable

      mc admin service restart ALIAS

   Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to restart.

#. Use the MinIO Console to Log In with AD/LDAP Credentials
   
   The MinIO Console supports the full workflow of authenticating to the AD/LDAP provider, generating temporary credentials using the MinIO :ref:`minio-sts-assumerolewithldapidentity` Security Token Service (STS) endpoint, and logging the user into the MinIO deployment.

   You can access the Console by opening the root URL for the MinIO cluster. For example, ``https://minio.example.net:9000``.

   Once logged in, you can perform any action for which the authenticated user is :ref:`authorized <minio-external-identity-management-ad-ldap-access-control>`.

   You can also create :ref:`access keys <minio-idp-service-account>` for supporting applications which must perform operations on MinIO.
   Access Keys are long-lived credentials which inherit their privileges from the parent user.
   The parent user can further restrict those privileges while creating the service account.

#. Generate S3-Compatible Temporary Credentials using AD/LDAP Credentials

   MinIO requires clients to authenticate using :s3-api:`AWS Signature Version 4 protocol <sig-v4-authenticating-requests.html>` with support for the deprecated Signature Version 2 protocol.
   Specifically, clients must present a valid access key and secret key to access any S3 or MinIO administrative API, such as ``PUT``, ``GET``, and ``DELETE`` operations.

   Applications can generate temporary access credentials as-needed using the :ref:`minio-sts-assumerolewithldapidentity` Security Token Service (STS) API endpoint and AD/LDAP user credentials. 
   MinIO provides an example Go application :minio-git:`ldap.go <minio/blob/master/docs/sts/ldap.go>` that manages this workflow.

   .. code-block:: shell

      POST https://minio.example.net?Action=AssumeRoleWithLDAPIdentity
      &LDAPUsername=USERNAME
      &LDAPPassword=PASSWORD
      &Version=2011-06-15
      &Policy={}

   - Replace the ``LDAPUsername`` with the username of the AD/LDAP user.

   - Replace the ``LDAPPassword`` with the password of the AD/LDAP user.

   - Replace the ``Policy`` with an inline URL-encoded JSON :ref:`policy <minio-policy>` that further restricts the permissions associated to the temporary credentials. 

     Omit to use the  :ref:`policy whose name matches <minio-external-identity-management-ad-ldap-access-control>` the Distinguished Name (DN) of the AD/LDAP user. 

   The API response consists of an XML document containing the access key, secret key, session token, and expiration date.
   Applications can use the access key and secret key to access and perform operations on MinIO.

   See the :ref:`minio-sts-assumerolewithldapidentity` for reference documentation.