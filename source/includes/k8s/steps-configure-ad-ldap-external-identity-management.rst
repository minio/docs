Deploy MinIO Tenant with Active Directory / LDAP Identity Management
--------------------------------------------------------------------

1) Access the Operator Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Temporarily forward traffic between the local host machine and the MinIO Operator Console and retrieve the JWT token for your Operator deployment.
For instructions, see :ref:`Configure access to the Operator Console service <minio-k8s-deploy-operator-access-console>`.

Open your browser to the temporary URL and enter the JWT Token into the login page. 
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

To enable external identity management with an Active Directory / LDAP provider, select the :guilabel:`Identity Provider` section.
You can then change the radio button to :guilabel:`Active Directory` to display the configuration settings.

.. image:: /images/k8s/operator-create-tenant-identity-provider-adldap.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console - Create a Tenant - External Identity Provider Section - Active Directory / LDAP

An asterisk ``*`` marks required fields.
The following table provides general guidance for those fields:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Field
     - Description

   * - LDAP Server Address
     - The hostname of the Active Directory or LDAP server.

   * - Lookup Bind DN
     - The Distinguished Name MinIO uses to authenticate and query the AD/LDAP server.

       See :ref:`minio-external-identity-management-ad-ldap-lookup-bind` for more information.

   * - List of user DNs (Distinguished Names) to be Tenant Administrators
     - Specify a user :abbr:`DNs (Distinguished Names)` which MinIO assigns a :ref:`policy <minio-policy>` with administrative permissions for the Tenant.
       You can specify multiple :abbr:`DNs (Distinguished Names)` by selecting the plus :octicon:`plus-circle` icon.
       You can delete a DN by selecting the trash can :octicon:`trash` icon for that DN.

Once you complete the section, you can finish any other required sections of :ref:`Tenant Deployment <minio-k8s-deploy-minio-tenant>`.

3) Assign Policies to AD/LDAP Users
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO by default assigns no :ref:`policies <minio-policy>` to AD/LDAP users or groups.
You must explicitly assign MinIO policies to a given user or group Distinguished Name (DN) to grant that user or group access to the MinIO deployment.

The following example assumes an existing :ref:`alias <alias>` configured for the MinIO Tenant.

Use the :mc:`mc idp ldap policy attach` command to assign a user or group DN to an existing MinIO Policy:

.. code-block:: shell
   :class: copyable

   mc idp ldap policy attach minio-tenant POLICY --user='uid=primary,cn=applications,dc=domain,dc=com'
   mc idp ldap policy attach minio-tenant POLICY --group='cn=applications,ou=groups,dc=domain,dc=com'

Replace ``POLICY`` with the name of the MinIO policy to assign to the user or group DN.

See :ref:`minio-external-identity-management-ad-ldap-access-control` for more information on access control with AD/LDAP users and groups.

4) Generate S3-Compatible Temporary Credentials using AD/LDAP Credentials
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Applications can use an AD/LDAP user credential to generate temporary S3-compatible credentials as-needed using the :ref:`minio-sts-assumerolewithldapidentity` Security Token Service (STS) API endpoint. 
MinIO provides an example Go application :minio-git:`ldap.go <minio/blob/master/docs/sts/ldap.go>` with an example of managing this workflow.

.. code-block:: shell

   POST https://minio.example.net?Action=AssumeRoleWithLDAPIdentity
   &LDAPUsername=USERNAME
   &LDAPPassword=PASSWORD
   &Version=2011-06-15
   &Policy={}

- Replace ``minio.example.net`` with the hostname or URL for the MinIO Tenant service.

- Replace the ``LDAPUsername`` with the username of the AD/LDAP user.

- Replace the ``LDAPPassword`` with the password of the AD/LDAP user.

- Replace the ``Policy`` with an inline URL-encoded JSON :ref:`policy <minio-policy>` that further restricts the permissions associated to the temporary credentials. 

  Omit to use the :ref:`policy whose name matches <minio-external-identity-management-ad-ldap-access-control>` the Distinguished Name (DN) of the AD/LDAP user. 

The API response consists of an XML document containing the access key, secret key, session token, and expiration date. 
Applications can use the access key and secret key to access and perform operations on MinIO.

See the :ref:`minio-sts-assumerolewithldapidentity` for reference documentation.
