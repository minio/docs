.. _minio-external-identity-management-ad-ldap:

=========================================
Active Directory / LDAP Access Management
=========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO supports configuring a single Active Directory or LDAP (AD/LDAP) service for external management of user identities.

For identities managed by the external AD/LDAP provider, MinIO uses the user's Distinguished Name and attempts to map it against an existing :ref:`policy <minio-policy>`.

If the AD/LDAP configuration includes the necessary settings to query the user's AD/LDAP group membership, MinIO *also* uses those group Distinguished Names and attempts to map each against an existing :ref:`policy <minio-policy>`.

MinIO by default denies access to all actions or resources not explicitly allowed by a user's assigned or inherited :ref:`policies <minio-policy>`. 
Users managed by an AD/LDAP provider must specify the necessary policies as part of the user profile data. 
If no policies match either the user DN or group DNs, MinIO blocks all access to actions and resources on the deployment.

The specific AD/LDAP queries MinIO issues to authenticate the user and retrieve it's group membership are configured as part of :ref:`deploying the cluster with Active Directory / LDAP identity management <minio-external-iam-ad-ldap>`.
This page covers creation of MinIO policies to match the possible returned Distinguished Names.

Authentication and Authorization Flow
-------------------------------------

The login flow for an application using Active Directory / LDAP 
credentials is as follows:

1. Specify the AD/LDAP credentials to the MinIO Security Token Service (STS)
   :ref:`minio-sts-assumerolewithldapidentity` API endpoint.

2. MinIO verifies the provided credentials against the AD/LDAP server. 

3. MinIO checks for any :ref:`policy <minio-policy>` whose name matches the
   user Distinguished Name (DN) and assigns that policy to the authenticated
   user.

   If configured to perform group queries, MinIO also queries for a list of
   AD/LDAP groups in which the user has membership. MinIO checks for any policy
   whose name matches a returned group DN and assigns that
   policy to the authenticated user.
   
4. MinIO returns temporary credentials in the STS API response in the form of an
   access key, secret key, and session token. The credentials have permissions
   matching those policies whose name matches either the authenticated user DN
   *or* a group DN.

MinIO provides an example Go application
:minio-git:`ldap.go <minio/blob/master/docs/sts/ldap.go>` that handles the
full login flow. 

AD/LDAP users can alternatively create :ref:`access keys <minio-idp-service-account>` associated to their AD/LDAP user Distinguished Name. 
Access Keys are long-lived credentials which inherit their privileges from the parent user. 
The parent user can further restrict those privileges while creating the access keys. 
Use either of the following methods to create a new access key:

- Log into the :ref:`MinIO Console <minio-console>` using the AD/LDAP-managed user credentials. 
   In the :guilabel:`User` section, select :guilabel:`Access Keys` followed by :guilabel:`Create access keys +`.

- Use the :mc:`mc admin user svcacct add` command to create the access keys. Specify the user Distinguished Name as the username to which to associate the access keys.


Mapping Policies to User DN
---------------------------

The following commands use :mc-cmd:`mc idp ldap policy attach` to associate an existing MinIO :ref:`policy <minio-policy>` to an AD/LDAP User DN.

.. code-block:: shell

   mc idp ldap policy attach myminio consoleAdmin \ 
     --user='cn=sisko,cn=users,dc=example,dc=com'
   
   mc idp ldap policy attach myminio readwrite,diagnostics \
     --user='cn=dax,cn=users,dc=example,dc=com'

- MinIO would assign an authenticated user with DN matching 
  ``cn=sisko,cn=users,dc=example,dc=com`` the :userpolicy:`consoleAdmin`
  policy, granting complete access to the MinIO server.

- MinIO would assign an authenticated user with DN matching
  ``cn=dax,cn=users,dc=example,dc=com`` both the :userpolicy:`readwrite` and
  :userpolicy:`diagnostics` policies, granting general read/write access to the
  MinIO server *and* access to diagnostic administrative operations.

- MinIO would assign no policies to an authenticated user with DN matching 
  ``cn=quark,cn=users,dc=example,dc=com`` and deny all access to API operations.

Mapping Policies to Group DN
----------------------------

The following commands use :mc-cmd:`mc idp ldap policy attach` to associate an existing MinIO :ref:`policy <minio-policy>` to an AD/LDAP Group DN.

.. code-block:: shell

   mc idp ldap policy attach myminio consoleAdmin \
     --group='cn=ops,cn=groups,dc=example,dc=com'

   mc idp ldap policy attach myminio diagnostics \
     --group='cn=engineering,cn=groups,dc=example,dc=com'

- MinIO would assign any authenticating user with membership in the
  ``cn=ops,cn=groups,dc=example,dc=com`` AD/LDAP group the
  :userpolicy:`consoleAdmin` policy, granting complete access to the MinIO
  server.

- MinIO would assign any authenticating user with membership in the
  ``cn=engineering,cn=groups,dc=example,dc=com`` AD/LDAP group the
  :userpolicy:`diagnostics` policy, granting access to diagnostic administrative
  operations.
