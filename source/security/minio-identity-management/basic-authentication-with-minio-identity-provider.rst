.. _minio-internal-idp:
.. _minio-users:

==================================
MinIO Internal Identity Management
==================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

MinIO includes a built-in IDentity Provider (IDP) that provides core identity
management functionality. The MiNIO IDP supports creating an arbitrary number of
long-lived users on the deployment for supporting client authentication. 

A *user* is an identity with associated privileges on a MinIO deployment. Each
user consists of a unique access key (username) and corresponding secret key
(password).  The access key and secret key support *authentication* on the MinIO
deployment, similar to a username and password. Clients must specify both a
valid access key (username) and the corresponding secret key (password) to
access the MinIO deployment.

Administrators use the :mc-cmd:`mc admin user` command to create and manage
MinIO users. The :minio-git:`MinIO Console <console>` provides a graphical
interface for creating users.

MinIO also supports creating :ref:`service accounts
<minio-idp-service-account>`. Service accounts are child identities of an
authenticated parent user and inherit their permissions from the parent. 

MinIO by default denies access to all actions or resources not explicitly
allowed by a user's assigned or inherited :ref:`policies <minio-policy>`. You
must either explicitly assign a :ref:`policy <minio-policy>` describing the
user's authorized actions and resources *or* assign the user to :ref:`groups
<minio-groups>` which have associated policies. See
:ref:`minio-access-management` for more information.

.. admonition:: External Identity Management
   :class: dropdown, note

   MinIO supports external management of identities using either an
   OpenID Connect (OIDC) or Active Directory/LDAP IDentity Provider (IDP).
   For more information, see:

   - :ref:`minio-external-identity-management-openid`
   - :ref:`minio-external-identity-management-ad-ldap`

   Enabling external identity management disables the MinIO internal IDP, with
   the exception of creating :ref:`service accounts
   <minio-idp-service-account>`.

.. _minio-users-root:

MinIO ``root`` User
~~~~~~~~~~~~~~~~~~~

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

Access Control
--------------

A user by default has no associated :ref:`privileges <minio-access-management>`.
You must either explicitly assign a :ref:`policy <minio-policy>` describing
the user's authorized actions and resources *or* assign the user to 
:ref:`groups <minio-groups>` which have associated policies. A user with
no explicitly assigned or inherited policies cannot perform any S3 or
MinIO administrative API operations.

For example, consider the following table of users. Each user is assigned
a :ref:`built-in policy <minio-policy-built-in>` or
a supported :ref:`action <minio-policy-actions>`. The table
describes a subset of operations a client could perform if authenticated
as that user:

.. list-table::
   :header-rows: 1
   :widths: 20 40 40
   :width: 100%

   * - User
     - Policy
     - Operations

   * - ``Operations``
     - | :userpolicy:`readwrite` on ``finance`` bucket
       | :userpolicy:`readonly` on ``audit`` bucket
     
     - | ``PUT`` and ``GET`` on ``finance`` bucket.
       | ``PUT`` on ``audit`` bucket

   * - ``Auditing``
     - | :userpolicy:`readonly` on ``audit`` bucket
     - ``GET`` on ``audit`` bucket

   * - ``Admin``
     - :policy-action:`admin:*`
     - All :mc-cmd:`mc admin` commands.

Each user can access only those resources and operations which are *explicitly*
granted by the built-in role. MinIO denies access to any other resource or
action by default.

.. _minio-idp-service-account:

Service Accounts
----------------

MinIO service accounts are child identities of a MinIO User. Each 
service account inherits its privileges based on the 
:ref:`policies <minio-policy>` attached to it's parent user *or* those 
groups in which the parent user has membership. Service accounts also support
an optional inline policy which further restricts access to a subset of 
actions and resources available to the parent user.

A MinIO user can generate any number of service accounts. This allows
application owners to generate arbitrary service accounts for their applications
without requiring action from the MinIO administrators. Since the generated
service accounts have the same or fewer permissions as the parents,
administrators can focus on managing the top-level parent users without
micro-managing generated service accounts.

Service accounts are only available through the :minio-git:`MinIO Console 
<console>`. After logging into the Console, click :guilabel:`Account`
from the left navigation to view all service accounts associated to the
authenticated user. Click :guilabel:`Create Service Account` to create
new service accounts.

User Management
---------------

Create a User
~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin user add` command to create a new user on the
MinIO deployment:

.. code-block:: shell
   :class: copyable

      mc admin user add ALIAS ACCESSKEY SECRETKEY

- Replace :mc-cmd:`ALIAS <mc admin user add TARGET>` with the
  :mc-cmd:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`ACCESSKEY <mc admin user add ACCESSKEY>` with the 
  access key for the user. MinIO allows retrieving the access key after
  user creation through the :mc-cmd:`mc admin user info` command.

- Replace :mc-cmd:`SECRETKEY <mc admin user add SECRETKEY>` with the
  secret key for the user. MinIO *does not* provide any method for retrieving
  the secret key once set.

Specify a unique, random, and long string for both the ``ACCESSKEY`` and 
``SECRETKEY``. Your organization may have specific internal or regulatory
requirements around generating values for use with access or secret keys. 

After creating the user, use :mc-cmd:`mc admin policy set` to associate 
a :ref:`MinIO Policy Based Access Control <minio-policy>` to the new user. You can also use
:mc-cmd:`mc admin group add` to add the user to a :ref:`minio-groups`.

Delete a User
~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin user remove` command to remove a user on a 
MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin user remove ALIAS USERNAME

- Replace :mc-cmd:`ALIAS <mc admin user remove TARGET>` with the
  :mc-cmd:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`USERNAME <mc admin user remove USERNAME>` with the name of
  the user to remove.

