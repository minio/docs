Deploy MinIO Tenant with OpenID Connect Identity Management
-----------------------------------------------------------

1) Access the Operator Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio proxy` command to temporarily forward traffic between the local host machine and the MinIO Operator Console:

.. code-block:: shell
   :class: copyable

   kubectl minio proxy

The command returns output similar to the following:

.. code-block:: shell

   Starting port forward of the Console UI.

   To connect open a browser and go to http://localhost:9001

   Current JWT to login: TOKEN

Open your browser to the specified URL and enter the JWT Token into the login page. 
You should see the :guilabel:`Tenants` page:

.. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

Click the :guilabel:`+ Create Tenant` to start creating a MinIO Tenant.

If you are modifying an existing Tenant, select that Tenant from the list. 
The following steps reference the necessary sections and configuration settings for existing Tenants.

2) Complete the :guilabel:`Identity Provider` Section
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To enable external identity management with an OIDC select the :guilabel:`Identity Provider` section.
You can then change the radio button to :guilabel:`OIDC` to display the configuration settings.

.. image:: /images/k8s/operator-create-tenant-identity-provider-openid.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console - Create a Tenant - External Identity Provider Section - OpenID

An asterisk ``*`` marks required fields.
The following table provides general guidance for those fields:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Field
     - Description

   * - Configuration URL
     - The hostname of the OpenID ``.well-known/openid-configuration`` file.

   * - | Client ID
       | Secret ID
     - The Client and Secret ID MinIO uses when authenticating OIDC user credentials against OIDC service.

   * - Claim Name
     - The OIDC Claim MinIO uses for identifying the :ref:`policies <minio-policy>` to attach to the authenticated user.

Once you complete the section, you can finish any other required sections of :ref:`Tenant Deployment <minio-k8s-deploy-minio-tenant>`.

3) Assign Policies to OIDC Users
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO by default assigns no :ref:`policies <minio-policy>` to OIDC users.
MinIO uses the specified user Claim to identify one or more policies to attach to the authenticated user.
If the Claim is empty or specifies policies which do not exist on the deployment, the authenticated user has no permissions on the Tenant.

The following example assumes an existing :ref:`alias <alias>` configured for the MinIO Tenant.

Consider the following example policy that grants general S3 API access on only the ``data`` bucket:

.. code-block:: json
   :class: copyable

   {
      "Version": "2012-10-17",
      "Statement": [
         {
            "Effect": "Allow",
            "Action": [
               "s3:*"
            ],
            "Resource": [
               "arn:aws:s3:::data",
               "arn:aws:s3:::data/*"
            ]
         }
      ]
   }

Use the :mc:`mc admin policy create` command to create a policy for use by an OIDC user:

.. code-block:: shell
   :class: copyable

   mc admin policy create minio-tenant datareadonly /path/to/datareadonly.json

MinIO attaches the ``datareadonly`` policy to any authenticated OIDC user with ``datareadonly`` included in the configured claim.

See :ref:`minio-external-identity-management-openid-access-control` for more information on access control with OIDC users and groups.

4) Use the MinIO Tenant Console to Log In with OIDC Credentials
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Console supports the full workflow of authenticating to the OIDC provider, generating temporary credentials using the MinIO :ref:`minio-sts-assumerolewithldapidentity` Security Token Service (STS) endpoint, and logging the user into the MinIO deployment.

See the :ref:`Deploy MinIO Tenant: Access the Tenant's MinIO Console <create-tenant-cli-access-tenant-console>` for instructions on accessing the Tenant Console.

If the OIDC configuration succeeded, the Console displays a button to login with OIDC credentials.

Enter the user's OIDC credentials and log in to access the Console.

Once logged in, you can perform any action for which the authenticated user is :ref:`authorized <minio-external-identity-management-openid-access-control>`. 

You can also create :ref:`access keys <minio-idp-service-account>` for supporting applications which must perform operations on MinIO. 
Access Keys are long-lived credentials which inherit their privileges from the parent user.
The parent user can further restrict those privileges while creating the access keys. 

5) Generate S3-Compatible Temporary Credentials using OIDC Credentials
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Applications can generate temporary access credentials as-needed using the :ref:`minio-sts-assumerolewithwebidentity` Security Token Service (STS) API endpoint and the JSON Web Token (JWT) returned by the :abbr:`OIDC (OpenID Connect)` provider.

The application must provide a workflow for logging into the :abbr:`OIDC (OpenID Connect)` provider and retrieving the JSON Web Token (JWT) associated to the authentication session. 
Defer to the provider documentation for obtaining and parsing the JWT token after successful authentication. 
MinIO provides an example Go application :minio-git:`web-identity.go <minio/blob/master/docs/sts/web-identity.go>` with an example of managing this workflow.


Once the application retrieves the JWT token, use the ``AssumeRoleWithWebIdentity`` endpoint to generate the temporary credentials:

.. code-block:: shell
   :class: copyable

   POST https://minio.example.net?Action=AssumeRoleWithWebIdentity
   &WebIdentityToken=TOKEN
   &Version=2011-06-15
   &DurationSeconds=86400
   &Policy=Policy

- Replace ``minio.example.net`` with the hostname or URL of the MinIO Tenant service.
- Replace the ``TOKEN`` with the JWT token returned in the previous step.
- Replace the ``DurationSeconds`` with the duration in seconds until the temporary credentials expire. The example above specifies a period of ``86400`` seconds, or 24 hours.
- Replace the ``Policy`` with an inline URL-encoded JSON :ref:`policy <minio-policy>` that further restricts the permissions associated to the temporary credentials. 

  Omit to use the policy associated to the OpenID user :ref:`policy claim <minio-external-identity-management-openid-access-control>`.

The API response consists of an XML document containing the access key, secret key, session token, and expiration date. 
Applications can use the access key and secret key to access and perform operations on MinIO.

See the :ref:`minio-sts-assumerolewithwebidentity` for reference documentation.
