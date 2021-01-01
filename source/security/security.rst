=========================
Configure Tenant Security
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Identity and Access Management
------------------------------

MinIO enforces authentication and authorization for all incoming requests. 
Administrators can use the MinIO Console *or* an S3-compatible command-line tool 
such as ``mc`` for configuring IAM on a MinIO Tenant.

.. _minio-k8s-identity-management:

Identity Management
~~~~~~~~~~~~~~~~~~~

A MinIO *user* is an identity that includes at minimum credentials 
consisting of an Access Key and Secret Key. MinIO requires all incoming 
requests include credentials which match an existing user.

DIAGRAM: Client Request -> User Auth -> Server Response

If MinIO successfully *authenticates* an incoming request against either an 
internally-managed or externally-managed identity, MinIO then checks if the 
identity is *authorized* to make the request. See 
:ref:`minio-k8s-access-management` for more information on authorization.

MinIO by default supports creating and managing users directly on the MinIO
Tenant. MinIO *also* supports configuring an 
:ref:`External IDentity Providers (IDP) <minio-k8s-idp>`, such as Active
Directory or OpenID, where MinIO can look up identities managed by the external
IDP as part of authentication. For more information on configuring external IDP, 
see :ref:`minio-k8s-idp`.

See :doc:`/tutorials/user-management` for tutorials on using the MinIO 
Console for performing user management on the MinIO Tenant. The following 
list includes common identity management procedures:

- :ref:`minio-k8s-create-new-user`
- :ref:`minio-k8s-change-user-password`
- :ref:`minio-k8s-create-service-account`

.. _minio-k8s-access-management:

Access Management
~~~~~~~~~~~~~~~~~

After MinIO :ref:`authenticates <minio-k8s-identity-management>` a user, 
MinIO checks whether the specified user is *authorized* to perform the 
requested operation. MinIO uses Policy-Based Access Control (PBAC) for 
defining the actions and resources to which a client has access.

DIAGRAM: Client Request -> Identity -> Policy -> Allowed/Denied

MinIO policies are JSON documents with :iam-docs:`IAM-compatible syntax
<reference_policies.html>`. Each MinIO user can have *one* attached policy for
defining its scope of access. MinIO also supports creating *groups* of users,
where the users inherit the policy attached to the group. A group can have *one*
attached policy for defining the scope of access of its membership. 

A given user's access therefore consists of the set of both its explicitly 
attached policy *and* all inherited policies from its group membership. 
MinIO only processes the requested operation if the user's complete set of 
policies explicitly allow access to both the required actions *and* resources 
for that operation.

DIAGRAM: User Policy + Group Policy -> Request -> Allowed/Denied (flowchart?)

MinIO PBAC is deny-by-default, where MinIO denies access to any action or 
resource not *explicitly* allowed by the user's attached or inherited 
policies. MinIO *also* prioritizes Deny rules if two or more policies 
conflict over access to a given action or resource.

See :doc:`/tutorials/group-management` and :doc:`/tutorials/policy-management`
for tutorials on using the MinIO Console for performing group and policy
management respectively. The following list includes common access management 
procedures:

- :ref:`minio-k8s-create-new-group`
- :ref:`minio-k8s-change-group-membership`
- :ref:`minio-k8s-assign-group-policy`
- :ref:`minio-k8s-attach-user-policy`
- :ref:`minio-k8s-create-new-policy`


.. _minio-k8s-idp:

External IDentity Providers (IDP)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO performs authentication and authorization for each incoming request 
it receives. The client must provide credentials such as an access key and 
secret key to authenticate as a user on the MinIO Tenant. MinIO then 
authorizes access to a select set of actions and resources based on the 
*policies* associated to that user *or* its groups.

DIAGRAM: Groups -> Users -> Client (auth/authz)

MinIO uses Policy-Based Access Control (PBAC), where each policy describes one
or more rules that outline the permissions of a user or group of users. MinIO
supports a subset of :iam-docs:`IAM actions and conditions
<reference_policies_actions-resources-contextkeys.html>` when creating policies.
By default, MinIO *denies* access to actions or resources not explicitly
referenced in a user's assigned or inherited policies.

MinIO Tenants deploy with the MinIO Console by default, a browser-based 
management interface with support for configuring IAM-related settings 
on the Tenant such as policies, users, and groups. Administrators can 
also use the ``mc`` command line tool for performing IAM on the MinIO Tenant.

Encryption and Key Management
-----------------------------

Network Encryption
~~~~~~~~~~~~~~~~~~

MinIO supports configuring TLS for encrypting data transmitted across the 
network. The MinIO Operator by default deploys Tenants with auto-generated TLS 
certificates for each Tenant component. MinIO supports the 
:rfc:`Server Name Indication (SNI) <6066#section-3>` extension and 
allows Administrators to specify multiple custom TLS certificates for supporting
HTTPS access to the Tenant through multiple domains. See <TUTORIAL> for 
more information on deploying MinIO Tenants with custom certificates.

Object Encryption
~~~~~~~~~~~~~~~~~

MinIO Tenants support Server-Side Encryption (SSE-S3) of objects using an
external Key Management Service (KMS) such as Hashicorp Vault, Thales 
CipherTrust (formerly Gemalto Keysecure), and Amazon KMS. 

.. todo

   Document SSE-S3 on MinIO



.. toctree::
   :titlesonly:
   :hidden:

   /tutorials/user-management
   /tutorials/group-management
   /tutorials/policy-management
   /tutorials/server-side-encryption-thales
   /tutorials/transport-layer-security