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

Specify the redirect URI the MinIO Console uses when authenticating against the
configured provider. Include the console port and ``/oauth_callback`` 
as part of the URL:

.. code-block:: shell

   http://minio.example.net:consoleport/oauth_callback

MinIO defaults to using the hostname of the node making the authentication
request. MinIO deployments behind a load balancer or reverse proxy *may* 
need to specify this field to ensure the OIDC provider returns the 
authentication response to the correct URL.

The specified URI *must* match one of the approved
redirect / callback URIs on the provider. See the OpenID `Authentication Request 
<https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest>`__ for
more information.

.. note::

   The embedded MinIO Console by default uses a random port number selected at
   server startup. Start the MinIO server process with the
   :mc-cmd-option:`~minio server console-address` option to specify a static
   port number.

.. end-minio-openid-redirect-uri

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

``https://ldapserver.com:636``

.. end-minio-ad-ldap-server-addr

.. start-minio-ad-ldap-sts-expiry

Specify the duration for which the credentials are valid as ``<int><unit>``.
Valid time units are as follows:

- ``s`` - seconds.
- ``m`` - minutes.
- ``h`` - hours.
- ``d`` - days

The default is ``1h`` or 1 hour.

.. end-minio-ad-ldap-sts-expiry

.. start-minio-ad-ldap-lookup-bind-dn

Specify the Distinguished Name (DN) for an AD/LDAP account MinIO uses when
querying the AD/LDAP server. Enables :ref:`Lookup-Bind
<minio-external-identity-management-ad-ldap-lookup-bind>` authentication to the AD/LDAP server.

The DN account should be a read-only service account with sufficient
privileges to support querying performing user and group lookups.

.. end-minio-ad-ldap-lookup-bind-dn

.. start-minio-ad-ldap-lookup-bind-password

Specify the password for the :ref:`Lookup-Bind 
<minio-external-identity-management-ad-ldap-lookup-bind>` user account.

.. end-minio-ad-ldap-lookup-bind-password

.. start-minio-ad-ldap-user-dn-search-base-dn

Specify the base Distinguished name (DN) MinIO uses when querying for 
user credentials matching those provided by an authenticating client.
For example:

``cn=miniousers,dc=myldapserver,dc=net``

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

.. start-minio-ad-ldap-username-format

Specify a comma-separated list of Distinguished Name templates used for
querying the AD/LDAP server. MinIO attempts to login to the AD/LDAP server
by applying the user credentials specified by the authenticating client to
each DN template. 

Use the ``%s`` substitution character to insert the client-specified username
into the search string. For example:

.. code-block:: shell
   :class: copyable

   uid=%s,cn=miniousers,dc=myldapserver,dc=net,userPrincipalName=%s,cn=miniousers,dc=myldapserver,dc=net

MinIO uses the *first* DN template that results in successful login to
perform a group lookup for that user. 

.. end-minio-ad-ldap-username-format

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

.. start-minio-ad-ldap-comment

Specify a comment to associate to the AD/LDAP configuration.

.. end-minio-ad-ldap-comment