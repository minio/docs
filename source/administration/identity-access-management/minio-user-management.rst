.. _minio-users:

===============
User Management
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

A MinIO user consists of a unique access key (username) and corresponding secret
key (password). Clients must authenticate their identity by specifying both
a valid access key (username) and the corresponding secret key (password) of
an existing MinIO user.

Each user can have one or more assigned :ref:`policies <minio-policy>` that
explicitly list the actions and resources to which that user has access. 
Users can also inherit policies from the :ref:`groups <minio-groups>` in which
they have membership. 

MinIO by default denies access to all actions or resources not explicitly
allowed by a user's assigned or inherited :ref:`policies <minio-policy>`. You
must either explicitly assign a :ref:`policy <minio-policy>` describing the
user's authorized actions and resources *or* assign the user to :ref:`groups
<minio-groups>` which have associated policies. See
:ref:`minio-access-management` for more information.

This page documents user management for the MinIO internal IDentity Provider
(IDP). MinIO also external management of identities using either an
OpenID Connect (OIDC) or Active Directory/LDAP IDentity Provider (IDP).
For more information, see:

- :ref:`minio-external-identity-management-openid`
- :ref:`minio-external-identity-management-ad-ldap`

Enabling external identity management disables the MinIO internal IDP, with
the exception of creating :ref:`access keys
<minio-idp-service-account>`.

.. _minio-idp-service-account:
.. _minio-id-access-keys:

Access Keys
-----------

MinIO Access Keys (formerly "Service Accounts") are child identities of an authenticated MinIO user, including :ref:`externally managed identities <minio-authentication-and-identity-management>`. 
Each access key inherits its privileges based on the :ref:`policies <minio-policy>` attached to it's parent user *or* those groups in which the parent user has membership. 
Access keys also support an optional inline policy which further restricts access to a subset of actions and resources available to the parent user.

A MinIO user can generate any number of access keys. 
This allows application owners to generate arbitrary access keys for their applications without requiring action from the MinIO administrators. 
Since the generated access keys have the same or fewer permissions as the parents, administrators can focus on managing the top-level parent users without micro-managing generated access keys.

You can create access keys using either the :ref:`MinIO Console <minio-console-user-access-keys>` *or* by using the :mc:`mc admin user svcacct add` command.
Identities created by these methods do not expire until you remove the access key or the parent account.

You can also create :ref:`security token service <minio-security-token-service>` accounts programmatically with the ``AssumeRole`` STS API endpoint.
STS tokens default to expire in 1 hour, but you set expiration for up to 7 days from creation.

.. admonition:: Access Keys are for Programmatic Access
   :class: dropdown, note

   Access Keys support programmatic access by applications. 
   You cannot use an access key to log into the MinIO Console.

.. _minio-users-root:

MinIO ``root`` User
-------------------

MinIO deployments have a ``root`` user with access to all actions and resources
on the deployment, regardless of the configured :ref:`identity manager
<minio-authentication-and-identity-management>`. When a :mc:`minio` server first
starts, it sets the ``root`` user credentials by checking the value of the
following environment variables:

- :envvar:`MINIO_ROOT_USER`
- :envvar:`MINIO_ROOT_PASSWORD`

Rotating the root user credentials requires updating either or both variables
for all MinIO servers in the deployment. Specify *long, unique, and random*
strings for root credentials. Exercise all possible precautions in storing the
access key and secret key, such that only known and trusted individuals who
*require* superuser access to the deployment can retrieve the ``root``
credentials.

- MinIO *strongly discourages* using the ``root`` user for regular client access
  regardless of the environment (development, staging, or production).

- MinIO *strongly recommends* creating users such that each client has access to
  the minimal set of actions and resources required to perform their assigned
  workloads. 

If these variables are unset, :mc:`minio` defaults to ``minioadmin`` and
``minioadmin`` as the access key and secret key respectively. MinIO *strongly
discourages* use of the default credentials regardless of deployment
environment.

.. admonition:: Deprecation of Legacy Root User Environment Variables
   :class: dropdown, important

   MinIO :minio-release:`RELEASE.2021-04-22T15-44-28Z` and later deprecates the
   following variables used for setting or updating root user
   credentials:

   - :envvar:`MINIO_ACCESS_KEY` to the new access key.
   - :envvar:`MINIO_SECRET_KEY` to the new secret key.
   - :envvar:`MINIO_ACCESS_KEY_OLD` to the old access key.
   - :envvar:`MINIO_SECRET_KEY_OLD` to the old secret key.

User Management
---------------

Create a User
~~~~~~~~~~~~~

Use the :mc:`mc admin user add` command to create a new user on the
MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin user add ALIAS ACCESSKEY SECRETKEY

- Replace :mc-cmd:`ALIAS <mc admin user add ALIAS>` with the
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`ACCESSKEY <mc admin user add ACCESSKEY>` with the 
  access key for the user. MinIO allows retrieving the access key after
  user creation through the :mc:`mc admin user info` command.

- Replace :mc-cmd:`SECRETKEY <mc admin user add SECRETKEY>` with the
  secret key for the user. MinIO *does not* provide any method for retrieving
  the secret key once set.

Specify a unique, random, and long string for both the ``ACCESSKEY`` and 
``SECRETKEY``. Your organization may have specific internal or regulatory
requirements around generating values for use with access or secret keys. 

After creating the user, use :mc:`mc admin policy attach` to associate a
:ref:`MinIO Policy Based Access Control <minio-policy>` to the new user. 
The following command assigns the built-in :userpolicy:`readwrite` policy:

.. code-block:: shell
   :class: copyable

   mc admin policy attach ALIAS readwrite --user=USERNAME

Replace ``USERNAME`` with the ``ACCESSKEY`` created in the previous step.

Delete a User
~~~~~~~~~~~~~

Use the :mc:`mc admin user rm` command to remove a user on a 
MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin user rm ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user rm ALIAS>` with the
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`USERNAME <mc admin user rm USERNAME>` with the name of
  the user to remove.
