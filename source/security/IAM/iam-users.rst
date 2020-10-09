.. _minio-users:

=====
Users
=====

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

A *user* is an identity with associated privileges on a MinIO deployment. Each
user consists of a unique access key (username) and corresponding secret key
(password).  The access key and secret key support *authentication* on the MinIO
deployment, similar to a username and password. Clients must specify both a
valid access key (username) and the corresponding secret key (password) to
access the MinIO deployment. 

Each user can have one or more assigned :ref:`policies <minio-policy>` that
explicitly list the actions and resources to which the user is allowed or denied
access. A user can also have membership in a :ref:`group <minio-groups>`, where
the user inherits any policies assigned to the group. Policies support
*authorization* on the MinIO deployment, such that clients can only access a
resource or operation if the user's assigned and inherited policies explicitly
grant. MinIO by default *denies* access to any resource or operation not
explicitly allowed by a user's assigned or inherited policies.

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

.. admonition:: ``Deny`` overrides ``Allow``
   :class: note

   MinIO follows the IAM policy evaluation rules where a ``Deny`` rule overrides
   ``Allow`` rule on the same action/resource. For example, if a user has an
   explicitly assigned policy with an ``Allow`` rule for an action/resource
   while one of its groups has an assigned policy with a ``Deny`` rule for that
   action/resource, MinIO would apply only the ``Deny`` rule. 

   For more information on IAM policy evaluation logic, see the IAM
   documentation on 
   :iam-docs:`Determining Whether a Request is Allowed or Denied Within an Account 
   <reference_policies_evaluation-logic.html#policy-eval-denyallow>`.

.. _minio-users-root:

``root`` User
~~~~~~~~~~~~~

MinIO deployments have a ``root`` user with access to all actions and resources
on the deployment. When a :mc:`minio` server first starts, it sets the ``root``
user credentials by checking the value of the following envrionment variables:

- :envvar:`MINIO_ACCESS_KEY`
- :envvar:`MINIO_SECRET_KEY`

To rotate the ``root`` user credentials, set the following environment 
variables and restart the :mc:`minio` server:

- :envvar:`MINIO_ACCESS_KEY` to the new access key.
- :envvar:`MINIO_SECRET_KEY` to the new secret key.
- :envvar:`MINIO_ACCESS_KEY_OLD` to the old access key.
- :envvar:`MINIO_SECRET_KEY_OLD` to the old secret key.

After the :mc:`minio` server starts successfully, you can unset the
:envvar:`MINIO_ACCESS_KEY_OLD` and :envvar:`MINIO_SECRET_KEY_OLD`. 

When specifying the ``root`` access key and secret key, consider using *long,
unique, and random* strings. Exercise all possible precautions in storing the
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

Create a User
-------------

Use the :mc-cmd:`mc admin user add` command to create a new user on the
MinIO deployment:

Delete a User
-------------

Use the :mc-cmd:`mc admin user remove` command to remove a user on a 
MinIO deployment:

Authenticate as a User
----------------------

ToDo: Examples of authenticating to a MinIO deployment with a created user. 

Should have examples with `mc` and each of the SDKs. 