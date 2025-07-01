1. Access the Operator Console

   Temporarily forward traffic between the local host machine and the MinIO Operator Console and retrieve the JWT token for your Operator deployment.
   For instructions, see :ref:`Configure access to the Operator Console service <minio-k8s-deploy-operator-access-console>`.

   Open your browser to the temporary URL and enter the JWT Token into the login page.
   You should see the :guilabel:`Tenants` page:

   .. image:: /images/k8s/operator-dashboard.png
      :align: center
      :width: 70%
      :class: no-scaled-link
      :alt: MinIO Operator Console

   To deploy a new MinIO Tenant with OIDC external identity management, select the :guilabel:`+ Create Tenant` button.

   TO configure an existing MinIO Tenant with OIDC external identity management select that Tenant from the displayed list.
   The following steps reference the necessary sections and configuration settings for existing Tenants.

#. Complete the :guilabel:`Identity Provider` Section

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

#. Assign Policies to OIDC Users

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

#. Generate S3-Compatible Temporary Credentials using OIDC Credentials

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
