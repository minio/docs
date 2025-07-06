.. start-configure-keycloak-client

Select :guilabel:`Create client` and follow the instructions to create a new Keycloak client for MinIO.
Fill in the specified inputs as follows:

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - :guilabel:`Client ID`
     - Set to a unique identifier for MinIO (``minio``)
   * - :guilabel:`Client type` 
     - Set to ``OpenID Connect``
   * - :guilabel:`Always display in console`
     - Toggle to ``On``
   * - :guilabel:`Client authentication`
     - Toggle to ``On``
   * - :guilabel:`Authentication flow`
     - Toggle on ``Standard flow``
   * - (Optional) :guilabel:`Authentication flow`
     - Toggle on ``Direct access grants`` (API testing)

Keycloak deploys the client with a default set of configuration values.
Modify these values as necessary for your Keycloak setup and desired behavior.
The following table provides a baseline of settings and values to configure:

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - :guilabel:`Root URL`
     - Set to ``${authBaseUrl}``
   * - :guilabel:`Home URL`
     - Set to the Realm you want MinIO to use (``/realms/master/account/``)
   * - :guilabel:`Valid Redirect URI`
     - Set to ``*``
   * - :guilabel:`Keys -> Use JWKS URL`
     - Toggle to ``On``
   * - :guilabel:`Advanced -> Advanced Settings -> Access Token Lifespan`
     - Set to ``1 Hour``.

.. end-configure-keycloak-client

.. start-configure-keycloak-client-scope

Navigate to the :guilabel:`Client scopes` view and create a new client scope for MinIO authorization:

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - :guilabel:`Name` 
     - Set to any recognizable name for the policy (``minio-authorization``)
   * - :guilabel:`Include in token scope` 
     - Toggle to ``On``

Once created, select the scope from the list and navigate to :guilabel:`Mappers`.

Select :guilabel:`Configure a new mapper` to create a new mapping:

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - :guilabel:`User Attribute`
     - Select the Mapper Type
   * - :guilabel:`Name`
     - Set to any recognizable name for the mapping (``minio-policy-mapper``)
   * - :guilabel:`User Attribute` 
     - Set to ``policy``
   * - :guilabel:`Token Claim Name` 
     - Set to ``policy``
   * - :guilabel:`Add to ID token` 
     - Set to ``On``
   * - :guilabel:`Claim JSON Type` 
     - Set to ``String``
   * - :guilabel:`Multivalued` 
     - Set to ``On``

       This allows setting multiple ``policy`` values in the single claim.
   * - :guilabel:`Aggregate attribute values`
     - Set to ``On``

       This allows users to inherit any ``policy`` set in their Groups

Once created, assign the Client Scope to the MinIO client.

1. Navigate to :guilabel:`Clients` and select the MinIO client.
2. Select :guilabel:`Client scopes`, then select :guilabel:`Add client scope`.
3. Select the previously created scope and set the :guilabel:`Assigned type` to ``default``.

.. end-configure-keycloak-client-scope

.. start-configure-keycloak-user-group-attributes

For Users, navigate to :guilabel:`Users` and select or create the User:

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - :guilabel:`Credentials`
     - Set the user password to a permanent value if not already set
   * - :guilabel:`Attributes`
     - Create a new attribute with key ``policy`` and value of any :ref:`policy <minio-policy>` (``consoleAdmin``)

For Groups, navigate to :guilabel:`Groups` and select or create the Group:

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - :guilabel:`Attributes`
     - Create a new attribute with key ``policy`` and value of any :ref:`policy <minio-policy>` (``consoleAdmin``)

You can assign users to groups such that they inherit the specified ``policy`` attribute.
If you set the Mapper settings to enable :guilabel:`Aggregate attribute values`, Keycloak includes the aggregated array of policies as part of the authenticated user's JWT token.
MinIO can use this list of policies when authorizing the user.

You can test the configured policies of a user by using the Keycloak API:

.. code-block:: shell
   :class: copyable
   :substitutions:

   curl -d "client_id=minio" \
        -d "client_secret=secretvalue" \
        -d "grant_type=password" \
        -d "username=minio-user-1" \
        -d "password=minio-user-1-password" \
        http://|KEYCLOAK_URL|/realms/REALM/protocol/openid-connect/token

If successful, the ``access_token`` contains the JWT necessary to use the MinIO :ref:`minio-sts-assumerolewithwebidentity` STS API and generate S3 credentials.

You can use a JWT decoder to review the payload and ensure it contains the ``policy`` key with one or more MinIO policies listed.

.. end-configure-keycloak-user-group-attributes

.. start-configure-keycloak-sts

Applications using an S3-compatible SDK must specify credentials in the form of an access key and secret key.
The MinIO :ref:`minio-sts-assumerolewithwebidentity` API returns the necessary temporary credentials, including a required session token, using a JWT returned by Keycloak after authentication.

You can test this workflow using the following sequence of HTTP calls and the ``curl`` utility:

1. Authenticate as a Keycloak user and retrieve the JWT token

   .. code-block:: shell
      :class: copyable
      :substitutions:

      curl -X POST "https://|KEYCLOAK_URL|/realms/REALM/protocol/openid-connect/token" \
           -H "Content-Type: application/x-www-form-urlencoded" \
           -d "username=USER" \
           -d "password=PASSWORD" \
           -d "grant_type=password" \
           -d "client_id=CLIENT" \
           -d "client_secret=SECRET"

   - Replace the ``USER`` and ``PASSWORD`` with the credentials of a Keycloak user on the ``REALM``.
   - Replace the ``CLIENT`` and ``SECRET`` with the client ID and secret for the MinIO-specific Keycloak client on the ``REALM``

   You can process the results using ``jq`` or a similar JSON-formatting utility.
   Extract the ``access_token`` field to retrieve the necessary access token.
   Pay attention to the ``expires_in`` field to note the number of seconds before the token expires.

2. Generate MinIO Credentials using the ``AssumeRoleWithWebIdentity`` API

   .. code-block:: shell
      :class: copyable
      :substitutions:

      curl -X POST "https://|MINIO_S3_URL|" \
           -H "Content-Type: application/x-www-form-urlencoded" \
           -d "Action=AssumeRoleWithWebIdentity" \
           -d "Version=2011-06-15" \
           -d "DurationSeconds=86000" \
           -d "WebIdentityToken=TOKEN"

   Replace the ``TOKEN`` with the ``access_token`` value returned by Keycloak.

   The API returns an XML document on success containing the following keys:
   
   - ``Credentials.AccessKeyId`` - the Access Key for the Keycloak User
   - ``Credentials.SecretAccessKey`` - the Secret Key for the Keycloak User
   - ``Credentials.SessionToken`` - the Session Token for the Keycloak User
   - ``Credentials.Expiration`` - the Expiration Date for the generated credentials

3. Test the Credentials

   Use your preferred S3-compatible SDK to connect to MinIO using the generated credentials.

   For example, the following Python code using the MinIO :ref:`Python SDK <minio-python-quickstart>` connects to the MinIO deployment and returns a list of buckets:

   .. code-block:: python
      :substitutions:

      from minio import Minio

      client = MinIO(
         "|MINIO_S3_URL|",
         access_key = "ACCESS_KEY",
         secret_key = "SECRET_KEY",
         session_token = "SESSION_TOKEN"
         secure = True
      )

      client.list_buckets()

.. end-configure-keycloak-sts

.. start-configure-keycloak-minio-console

Log in as a user with administrative privileges for the MinIO deployment such as a user with the :userpolicy:`consoleAdmin` policy.

Select :guilabel:`Identity` from the left-hand navigation bar, then select :guilabel:`OpenID`.
Select :guilabel:`Create Configuration` to create a new configuration.

Enter the following information into the modal:

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - :guilabel:`Name` 
     - Enter a unique name for the Keycloak instance 
   
   * - :guilabel:`Config URL`
     - Specify the address of the Keycloak OpenID configuration document (|KEYCLOAK_URL|)

       Ensure the ``REALM`` matches the Keycloak realm you want to use for authenticating users to MinIO.

   * - :guilabel:`Client ID`
     - Specify the name of the Keycloak client created in Step 1
   
   * - :guilabel:`Client Secret`
     - Specify the secret credential value for the Keycloak client created in Step 1

   * - :guilabel:`Display Name`
     - Specify the user-facing name the MinIO Console displays as part of the Single-Sign On (SSO) workflow for the configured Keycloak service

   * - :guilabel:`Scopes` 
     - Specify the OpenID scopes to include in the JWT, such as ``preferred_username`` or ``email``
   
       You can reference these scopes using supported OpenID policy variables for the purpose of programmatic policy .

   * - :guilabel:`Redirect URI Dynamic`
     - Toggle to ``on``
     
       Substitutes the MinIO Console address used by the client as part of the Keycloak redirect URI.
       Keycloak returns authenticated users to the Console using the provided URI.
        
       For MinIO Console deployments behind a reverse proxy, load balancer, or similar network control plane, you can instead use the :envvar:`MINIO_BROWSER_REDIRECT_URL` variable to set the redirect address for Keycloak to use.

Select :guilabel:`Save` to apply the configuration.

.. end-configure-keycloak-minio-console

.. start-configure-keycloak-minio-cli


You can use the :mc-cmd:`mc idp openid add` command to create a new configuration for the Keycloak service.
The command takes all supported :ref:`OpenID Configuration Settings <minio-open-id-config-settings>`:

.. code-block:: shell
   :class: copyable
   :substitutions:

   mc idp openid add ALIAS PRIMARY_IAM \
      client_id=MINIO_CLIENT \
      client_secret=MINIO_CLIENT_SECRET \
      config_url="https://|KEYCLOAK_URL|/realms/REALM/.well-known/openid-configuration" \
      display_name="SSO_IDENTIFIER"
      scopes="openid,email,preferred_username" \
      redirect_uri_dynamic="on"

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - ``PRIMARY_IAM``
     - Set to a unique identifier for the Keycloak service, such as ``keycloak_primary``

   * - | ``MINIO_CLIENT``
       | ``MINIO_CLIENT_SECRET``
     - Set to the Keycloak client ID and secret configured in Step 1

   * - ``config_url``
     - Set to the address of the Keycloak OpenID configuration document (|KEYCLOAK_URL|)

   * - ``display_name`` 
     - Set to a user-facing name the MinIO Console displays as part of the Single-Sign On (SSO) workflow for the configured Keycloak service

   * - ``scopes`` 
     - Set to a list of OpenID scopes you want to include in the JWT, such as ``preferred_username`` or ``email``

   * - ``redirect_uri_dynamic``
     - Set to ``on``

       Substitutes the MinIO Console address used by the client as part of the Keycloak redirect URI.
       Keycloak returns authenticated users to the Console using the provided URI.
        
       For MinIO Console deployments behind a reverse proxy, load balancer, or similar network control plane, you can instead use the :envvar:`MINIO_BROWSER_REDIRECT_URL` variable to set the redirect address for Keycloak to use.

.. end-configure-keycloak-minio-cli

.. start-configure-keycloak-minio-envvar

Set the following :ref:`environment variables <minio-server-envvar-external-identity-management-openid>` prior to starting the container using the ``-e ENVVAR=VALUE`` flag.

The following example code sets the minimum required environment variables related to configuring Keycloak as an external identity management provider. 

.. code-block:: shell
   :class: copyable
   :substitutions:

   MINIO_IDENTITY_OPENID_CONFIG_URL_PRIMARY_IAM="https://|KEYCLOAK_URL|/realms/REALM/.well-known/openid-configuration"
   MINIO_IDENTITY_OPENID_CLIENT_ID_PRIMARY_IAM="MINIO_CLIENT"
   MINIO_IDENTITY_OPENID_CLIENT_SECRET_PRIMARY_IAM="MINIO_CLIENT_SECRET"
   MINIO_IDENTITY_OPENID_DISPLAY_NAME_PRIMARY_IAM="SSO_IDENTIFIER"
   MINIO_IDENTITY_OPENID_SCOPES_PRIMARY_IAM="openid,email,preferred_username"
   MINIO_IDENTITY_OPENID_REDIRECT_URI_DYNAMIC_PRIMARY_IAM="on"

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%

   * - ``_PRIMARY_IAM``
     - Replace the suffix ``_PRIMARY_IAM`` with a unique identifier for this Keycloak configuration.
       For example, ``MINIO_IDENTITY_OPENID_CONFIG_URL_KEYCLOAK_PRIMARY``.

       You can omit the suffix if you intend to only configure a single OIDC provider for the deployment.

   * - :envvar:`CONFIG_URL <MINIO_IDENTITY_OPENID_CONFIG_URL>`
     - Specify the address of the Keycloak OpenID configuration document (|KEYCLOAK_URL|)

       Ensure the ``REALM`` matches the Keycloak realm you want to use for authenticating users to MinIO

   * - | :envvar:`CLIENT_ID <MINIO_IDENTITY_OPENID_CLIENT_ID>`
       | :envvar:`CLIENT_SECRET <MINIO_IDENTITY_OPENID_CLIENT_SECRET>`

     - Specify the Keycloak client ID and secret configured in Step 1

   * - :envvar:`DISPLAY_NAME <MINIO_IDENTITY_OPENID_DISPLAY_NAME>` 
     - Specify the user-facing name the MinIO Console displays as part of the Single-Sign On (SSO) workflow for the configured Keycloak service

   * - :envvar:`OPENID_SCOPES <MINIO_IDENTITY_OPENID_SCOPES>`

     - Specify the OpenID scopes you want to include in the JWT, such as ``preferred_username`` or ``email``

   * - :envvar:`REDIRECT_URI_DYNAMIC <MINIO_IDENTITY_OPENID_REDIRECT_URI_DYNAMIC>`
     - Set to ``on``

       Substitutes the MinIO Console address used by the client as part of the Keycloak redirect URI.
       Keycloak returns authenticated users to the Console using the provided URI.
        
       For MinIO Console deployments behind a reverse proxy, load balancer, or similar network control plane, you can instead use the :envvar:`MINIO_BROWSER_REDIRECT_URL` variable to set the redirect address for Keycloak to use.

For complete documentation on these variables, see :ref:`minio-server-envvar-external-identity-management-openid`

.. end-configure-keycloak-minio-envvar
