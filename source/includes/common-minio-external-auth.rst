.. Descriptions for External Identity Management using an OpenID Connect-compatible Provider
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst
   - /source/security/identity-management/external-identity-management-openid/*


.. start-minio-openid-client-id

Specify the unique public identifier MinIO uses when authenticating user
credentials against the :abbr:`OIDC (OpenID Connect)` compatible provider.

.. end-minio-openid-client-id

.. start-minio-openid-client-secret

Specify the client secret MinIO uses when authenticating user credentials
against the :abbr:`OIDC (OpenID Connect)` compatible provider. This field
may be optional depending on the provider.

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

.. end-minio-openid-client-secret

.. start-minio-openid-jwks-url

Specify the URL for the JSON Web Key Set (JWKS) for MinIO to use when verifying
any JSON Web Tokens (JWT) issued by the :abbr:`OIDC (OpenID Connect)` compatible
provider.

.. end-minio-openid-jwks-url

.. start-minio-openid-config-url

Specify the URL for the :abbr:`OIDC (OpenID Connect)` compatible provider
`discovery document 
<https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderConfig>`__. 

The :abbr:`OIDC (OpenID Connect)` Discovery URL typically resembles the
following:

``https://openid-provider.example.net/.well-known/openid-configuration``

.. end-minio-openid-config-url

.. start-minio-openid-claim-name

Specify the name of the 
`JWT Claim <https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ 
MinIO uses to identify the :ref:`policies <minio-policy>` to attach to the
authenticated user.

The claim can contain one or more comma-separated policy names to attach to 
the user. The claim must contain *at least* one policy for the user to have
any permissions on the MinIO server.

Defaults to ``policy``.

.. end-minio-openid-claim-name

.. start-minio-openid-display-name

Specify the user-facing name the MinIO Console displays on the login screen.

.. end-minio-openid-display-name

.. start-minio-openid-claim-prefix

Specify the 
`JWT Claim <https://datatracker.ietf.org/doc/html/rfc7519#section-4>`__ 
namespace prefix to apply to the specified claim name.

.. end-minio-openid-claim-prefix

.. start-minio-openid-scopes

Specify a comma-separated list of 
`scopes <https://datatracker.ietf.org/doc/html/rfc6749#section-3.3>`__. 
Defaults to those scopes advertised in the discovery document.

.. end-minio-openid-scopes

.. start-minio-openid-redirect-uri

.. important::

   This parameter was removed in :minio-release:`RELEASE.2023-02-27T18-10-45Z`.
   Use the :envvar:`MINIO_BROWSER_REDIRECT_URL` :ref:`environment variable <minio-server-environment-variables>` instead.

The MinIO Console defaults to using the hostname of the node making the authentication request. 
For MinIO deployments behind a load balancer or reverse proxy, specify this field to ensure the OIDC provider returns the authentication response to the correct MinIO Console URL.
Include the Console hostname, port, and ``/oauth_callback``:

.. code-block:: shell

   http://minio.example.net:consoleport/oauth_callback

Ensure you start the MinIO Server with the :mc-cmd:`~minio server --console-address` option to set a static Console listen port.
The default behavior with that option omitted is to select a random port number at startup.

The specified URI *must* match one of the approved redirect / callback URIs on the provider. 
See the OpenID `Authentication Request <https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest>`__ for more information.

.. end-minio-openid-redirect-uri

.. start-minio-openid-redirect-uri-dynamic

The MinIO Console defaults to using the hostname of the node making the authentication request as part of the redirect URI provided to the OIDC provider.
For MinIO deployments behind a load balancer using a round-robin protocol, this may result in the load balancer returning the response to a different MinIO Node than the originating client.

Specify this option as ``on`` to direct the MinIO Console to use the ``Host`` header of the originating request to construct the redirect URI passed to the OIDC provider.
Defaults to ``off``.

.. end-minio-openid-redirect-uri-dynamic

.. start-minio-openid-claim-userinfo

Specify the OpenID User info API endpoint for the OIDC service.
For example, ``https://oidc-endpoint:port/realms/REALM/protocol/openid-connect/userinfo``

Some OIDC providers do not provide group information as part of the JWT response after authentication.
Specify this URL to direct MinIO to make an additional API call to construct the complete JWT token.

.. end-minio-openid-claim-userinfo

.. start-minio-openid-vendor

Specify the OIDC Vendor to enable specific supported behaviors for that vendor.

Supports the following value:

- ``keycloak``

.. end-minio-openid-vendor

.. start-minio-openid-keycloak-realm

Specify the Keycloak Realm to use as part of Keycloak Admin API Operations, such as ``main``.

.. end-minio-openid-keycloak-realm

.. start-minio-openid-keycloak-admin-url

Specify the Keycloak Admin API URL. 
MinIO can use this URL if configured to periodically validate authenticated Keycloak users as active/existing.
For example, ``https://keycloak-endpoint:port/admin/``.

.. end-minio-openid-keycloak-admin-url

.. start-minio-openid-comment

Specify a comment to associate with the :abbr:`OIDC (OpenID Connect)` compatible 
provider configuration.

.. end-minio-openid-comment

.. Descriptions for External Identity Management using an AD/LDAP Provider
   Used in the following files:
   - /source/reference/minio-server/minio-server.rst
   - /source/reference/minio-cli/minio-mc-admin/mc-admin-config.rst
   - /source/security/identity-management/ad-ldap-external-identity-management/*


.. start-minio-ad-ldap-server-addr

Specify the hostname for the Active Directory / LDAP server. For example:

.. code-block:: shell
   :class: copyable

   ldapserver.com:636

.. admonition:: :mc-cmd:`~mc idp ldap add srv_record_name` automatically identifies the port
   :class: note

   If your AD/LDAP server uses :mc-cmd:`DNS SRV Records <mc idp ldap add srv_record_name>`, do *not* append the port number to your :mc-cmd:`~mc idp ldap add server_addr` value.
   SRV requests automatically include port numbers when returning the list of available servers.
   
.. end-minio-ad-ldap-server-addr

.. start-minio-ad-ldap-lookup-bind-dn

Specify the Distinguished Name (DN) for an AD/LDAP account MinIO uses when
querying the AD/LDAP server. Enables :ref:`Lookup-Bind
<minio-external-identity-management-ad-ldap-lookup-bind>` authentication to the AD/LDAP server.

The DN account should be a read-only access keys with sufficient
privileges to support querying performing user and group lookups.

.. end-minio-ad-ldap-lookup-bind-dn

.. start-minio-ad-ldap-lookup-bind-password

Specify the password for the :ref:`Lookup-Bind 
<minio-external-identity-management-ad-ldap-lookup-bind>` user account.

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

.. end-minio-ad-ldap-lookup-bind-password

.. start-minio-ad-ldap-user-dn-search-base-dn

Specify the base Distinguished Name (DN) MinIO uses when querying for 
user credentials matching those provided by an authenticating client.
For example:

.. code-block:: shell
   :class: copyable

   cn=miniousers,dc=myldapserver,dc=net

Supports :ref:`Lookup-Bind  <minio-external-identity-management-ad-ldap-lookup-bind>` mode.

.. end-minio-ad-ldap-user-dn-search-base-dn

.. start-minio-ad-ldap-user-dn-search-filter

Specify the AD/LDAP search filter MinIO uses when querying for user credentials
matching those provided by an authenticating client. 

Use the ``%s`` substitution character to insert the client-specified
username into the search string. For example:

.. code-block:: shell
   :class: copyable

   (userPrincipalName=%s)

.. end-minio-ad-ldap-user-dn-search-filter

.. start-minio-ad-ldap-group-search-filter

Specify an AD/LDAP search filter for performing group lookups for the
authenticated user

Use the ``%s`` substitution character to insert the client-specified username
into the search string. Use the ``%d`` substitution character to insert the
Distinguished Name of the client-specified username into the search string.

For example:

.. code-block:: shell
   :class: copyable
   
   (&(objectclass=groupOfNames)(memberUid=%s))

.. end-minio-ad-ldap-group-search-filter

.. start-minio-ad-ldap-group-search-base-dn

Specify a comma-separated list of group search base Distinguished Names 
MinIO uses when performing group lookups.
 
For example:

.. code-block:: shell
   :class: copyable
   
   cn=miniogroups,dc=myldapserver,dc=net"

.. end-minio-ad-ldap-group-search-base-dn

.. start-minio-ad-ldap-tls-skip-verify

Specify ``on`` to trust the AD/LDAP server TLS certificates without 
verification. This option may be required if the AD/LDAP server TLS certificates
are signed by an untrusted Certificate Authority (e.g. self-signed). 

Defaults to ``off``

.. end-minio-ad-ldap-tls-skip-verify

.. start-minio-ad-ldap-server-insecure

Specify ``on`` to allow unsecured (non-TLS encrypted) connections to
the AD/LDAP server.

MinIO sends AD/LDAP user credentials in plain text to the AD/LDAP server, such
that enabling TLS is *required* to prevent reading credentials over the wire.
Using this option presents a security risk where any user with access to
network traffic can observe the unencrypted plaintext credentials.

Defaults to ``off``.

.. end-minio-ad-ldap-server-insecure

.. start-minio-ad-ldap-server-starttls

Specify ``on`` to enable 
`StartTLS <https://ldapwiki.com/wiki/StartTLS>`__ connections to AD/LDAP server.

Defaults to ``off``

.. end-minio-ad-ldap-server-starttls

.. start-minio-ad-ldap-srv_record_name

Specify the appropriate value to enable MinIO to select an AD/LDAP server using a `DNS SRV record <https://ldap.com/dns-srv-records-for-ldap>`__ request.

When enabled, MinIO selects an AD/LDAP server by:

- Constructing the target SRV record name following standard naming conventions.
- Requesting a list of available AD/LDAP servers.
- Choosing an appropriate target based on priority and weight.

The configuration examples below presume the AD/LDAP server address is set to ``example.com`` and the SRV record protocol is ``_tcp``.

For SRV record names beginning with ``_ldap``, specify ``ldap``.
The constructed DNS SRV record name resembles the following:

.. code-block:: shell

   _ldap._tcp.example.com

For SRV record names with beginning with ``_ldaps``, specify ``ldaps``.
The constructed	DNS SRV	record name resembles the following:

.. code-block:: shell

   _ldaps._tcp.example.com

If your DNS SRV record name uses alternate service or protocol names, specify ``on`` and provide the full record name as your LDAP server address.
Example: ``_ldapserver._specialtcp.example.com``

For more about DNS SRV records, see `DNS SRV Records for LDAP <https://ldap.com/dns-srv-records-for-ldap>`__.
 
.. admonition:: Server address for DNS SRV record configurations
   :class: important

   The specified server name **must not** include a port number.
   This is different from a standard AD/LDAP configuration, where the port number is required.

   See :mc-conf:`~identity_ldap.server_addr` or :envvar:`MINIO_IDENTITY_LDAP_SERVER_ADDR` for more about configuring an AD/LDAP server address.

.. end-minio-ad-ldap-srv_record_name

.. start-minio-ad-ldap-comment

Specify a comment to associate to the AD/LDAP configuration.

.. end-minio-ad-ldap-comment

.. start-minio-ad-ldap-console-enable

#. Log in to the MinIO Console as either the :ref:`root <minio-users-root>` user or a MinIO user with the  :userpolicy:`consoleAdmin` policy.
#. In the :guilabel:`Identity` section, select :guilabel:`LDAP` and then :guilabel:`Edit Configuration` to configure an Active Directory or LDAP server.
   The minimum required settings are:

   - Server Address
   - Lookup Bind DN
   - Lookup Bind Password
   - User DN Search Base
   - User DN Search Filter

   Not all configuration options are available in the MinIO Console.
   For additional settings, use :mc:`mc idp ldap` or :ref:`environment variables <minio-server-envvar-external-identity-management-ad-ldap>`.
 
.. end-minio-ad-ldap-console-enable

.. start-minio-identity-management-plugin-url

The webhook endpoint for the external identity management service (``https://authservice.example.net:8080/auth``).

.. end-minio-identity-management-plugin-url

.. start-minio-identity-management-auth-token

An authentication token to present to the configured webhook endpoint.

Specify a supported HTTP `Authentication scheme <https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication#authentication_schemes>`__ as a string value, such as ``"Bearer TOKEN"``.
MinIO sends the token using the HTTP `Authorization <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization>`__ header.

.. end-minio-identity-management-auth-token

.. start-minio-identity-management-role-policy

Specify a comma separated list of MinIO :ref:`policies <minio-policy>` to assign to authenticated users.

.. end-minio-identity-management-role-policy

.. start-minio-identity-management-role-id

Specify a unique ID MinIO uses to generate an ARN for this identity manager.

If omitted, MinIO automatically generates the ID and prints the full ARN to the server log.

.. end-minio-identity-management-role-id

.. start-minio-identity-management-comment

Specify a comment to associate to the identity configuration.

.. end-minio-identity-management-comment

