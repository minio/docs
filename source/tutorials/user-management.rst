===============
User Management
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

This page documents procedures for managing 
:ref:`users <minio-k8s-identity-management>` on a MinIO Tenant. 
MinIO enforces authentication and authorization for all incoming requests,
where clients *must* present the credentials for a user on the MinIO Tenant.

.. todo

   For documentation on managing users through an External IDentity Provider
   (IDP), see <LINK>.

.. _minio-k8s-create-new-user:

Create a New MinIO User
-----------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

The following procedure uses the MinIO Console to create a new user on the MinIO
Tenant.

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the User Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the MinIO Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`Users` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`Users` navigation item.

.. image:: /images/User_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

The :guilabel:`Users` interface shows all existing MinIO users and their 
access keys. Click the :guilabel:`+ Create User` button to open the
:guilabel:`Create User` modal. 

2) Create a New User
~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Create User` modal displays the following inputs for 
configuring the new user:

.. image:: /images/User_Management_Create.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Creation Modal

.. list-table::
   :stub-columns: 1
   :width: 100%
   :widths: 30 70

   * - :guilabel:`Access Key`
     - *Required* 
       
       The Access Key to attach to the user. Clients must present
       this key when connecting to the MinIO Tenant.

   * - :guilabel:`Secret Key`
     - *Required* 
       
       Enter the secret key to attach to the user. Defer to your 
       organizations policies for generating secure passwords. MinIO 
       strongly recommends generating a long, unique, and random 
       string for each secret key.

   * - :guilabel:`Assign Groups`
     - *Optional* 
       
       The groups in which the user has membership. The user inherits
       the IAM policy associated to each group.

       You can filter groups using the :guilabel:`Filter by Group` input.

Click :guilabel:`Save` to save the new user.

3) Assign a Policy to the User
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Optional* 

This step is not required if the user's group membership provides the necessary
policies for supporting that user's intended workload.

MinIO uses Policy-Based Access Control (PBAC) to determine which actions and
resources to which a MinIO Tenant user has access. A user can have 
*one* explicitly attached policy. Each user also inherits the
policies attached to each group in which it has membership. The total set of
permissions for a given user are both its explicitly attached and inherited
policies. 

To explicitly attach a policy to a user, open the 
:guilabel:`Users` management interface and click the :guilabel:`flag`
icon next to their name to open the :guilabel:`Set Policies` modal.

.. image:: /images/User_Management_Select.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Select

The :guilabel:`Set Policies` modal displays inputs for selecting a policy 
to attach to the user.

.. image:: /images/User_Management_Set_Policies.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management Set Policies

Under :guilabel:`Assign Policies`, select the policy to attach to the user.
You can filter policies using the :guilabel:`Filter by Policy` text input. 
A user can have exactly *one* attached policy. 

Click :guilabel:`Save` to save the new policy attachment.

For complete documentation on creating a new IAM policy to attach to a 
MinIO group, see :ref:`minio-k8s-create-new-policy`.

4) Next Steps
~~~~~~~~~~~~~

Client applications can use the Access Key and Secret Key associated to the 
user for authenticating and performing operations on the MinIO Tenant. See 
the MinIO client SDKs or any S3-compatible SDK for examples of connecting 
to an S3-compatible object storage system with user credentials.

.. TODO: Example Connection Strings w/ New User Credentials.

.. _minio-k8s-attach-user-policy:

Attach a Policy to a MinIO User
-------------------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

MinIO uses Policy-Based Access Control (PBAC) to determine which actions and
resources to which a MinIO Tenant user has access. A user can have 
*one* explicitly attached policy. Each user also inherits the
policies attached to each group in which it has membership. The total set of
permissions for a given user are both its explicitly attached and inherited
policies. 

For complete documentation on creating a new IAM policy to attach to a 
MinIO user, see :ref:`minio-k8s-create-new-policy`.

The following procedure uses the MinIO Console to change the IAM policy attached
to a MinIO user.

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the User Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`Users` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`Users` navigation item.

.. image:: /images/User_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

2) Set the User's Attached IAM Policy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To modify the policy attached to a user, click the :guilabel:`Flag` icon to open
the :guilabel:`Set Policies` modal.

.. image:: /images/User_Management_Select.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Select Flag Icon

The :guilabel:`Set Policies` modal displays inputs for selecting a policy 
to attach to the user.

.. image:: /images/User_Management_Set_Policies.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management Set Policies

Under :guilabel:`Assign Policies`, select the policy to attach to the user.
You can filter policies using the :guilabel:`Filter by Policy` text input. 
A user can have exactly *one* attached policy. 

Enable or Disable a MinIO User
------------------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

The following procedure uses the MinIO Console to enable or disable a 
MinIO user. Applications can only authenticate as enabled MinIO users.

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the User Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`Users` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`Users` navigation item.

.. image:: /images/User_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

2) Select the User to Enable or Disable
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Click the row for the User to open the :guilabel:`Edit User` modal:

.. image:: /images/User_Management_Select_Row.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

3) Enable or Disable the User
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The toggle in the top-right hand corner of the :guilabel:`Edit User` modal 
displays the current state of the MinIO user. 

.. image:: /images/User_Management_Edit_User.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

If the toggle displays :guilabel:`Enabled`, the user is currently enabled. 
If the toggle displays :guilabel:`Disabled`, the user is currently disabled. 
Click the toggle to change the state of the user.

Click :guilabel:`Save` to save the changes. Applications cannot use
:guilabel:`Disabled` users to authenticate to the MinIO Tenant until they are
re-enabled.

Change Group Membership for MinIO User
--------------------------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

MinIO uses Policy-Based Access Control (PBAC) to determine which actions and
resources to which a MinIO Tenant user has access. MinIO also supports *groups*
of users, where the users inherit the policy attached to the group. A given
user's access therefore consists of the set of both its explicitly attached
policy *and* all inherited policies from its group membership. 

The following procedure uses the MinIO Console to change the group memberships
for a MinIO user.

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the User Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`Users` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`Users` navigation item.

.. image:: /images/User_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

2) Select the User to Edit
~~~~~~~~~~~~~~~~~~~~~~~~~~

Click the row for the User to open the :guilabel:`Edit User` modal:

.. image:: /images/User_Management_Select_Row.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

3) Change Group Membership
~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Edit User` modal displays information on the selected MinIO 
Tenant User:

.. image:: /images/User_Management_Edit_User.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

The :guilabel:`Assign Groups` section displays the available groups on the MinIO
Tenant. Toggle the :guilabel:`Select` checkbox next to each group such that only
those groups in which the user must have membership are selected.

You can filter groups using the :guilabel:`Filter by Group` input.

Click :guilabel:`Save` to save the new group membership.

Delete a MinIO User
-------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

The following procedure uses the MinIO Console to delete a MinIO user.

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the User Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`Users` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`Users` navigation item.

.. image:: /images/User_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

2) Delete the User
~~~~~~~~~~~~~~~~~~

To delete a user, click the :guilabel:`Trash` icon to open the 
:guilabel:`Delete User` modal:

.. image:: /images/User_Management_Select_Delete.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Select Trash Icon

You must confirm user deletion by clicking :guilabel:`Delete` from the modal. 

.. image:: /images/User_Management_Delete.png
   :align: center
   :width: 50%
   :class: no-scaled-link
   :alt: MinIO Console User Management Delete User

.. _minio-k8s-change-user-password:

Change MinIO User Password
--------------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

The following procedure uses the MinIO Console to change the password for 
the authenticated MinIO user.

.. admonition:: Required Permissions
   :class: note, dropdown

   Changing the authenticated user's password requires the user to either have 
   an explicitly attached *or* inherited policy with the following allowed 
   actions and resources:

   .. code-block:: json
      
      {
         "Version": "2012-10-17",
         "Statement": [
            {
                  "Effect": "Allow",
                  "Action": [
                     "admin:ListUsers",
                     "admin:GetUser",
                     "admin:CreateUser"
                  ]
            },
            {
                  "Effect": "Allow",
                  "Action": [
                     "s3:*"
                  ],
                  "Resource": [
                     "arn:aws:s3:::*"
                  ]
            }
         ]
      }

   

1) Open the Account Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To change your MinIO User password, open the MinIO Console in your browser and
log in with your credentials. From the Console, click :guilabel:`Account` in the
left hand navigation. If the :guilabel:`User` navigation group is collapsed,
click on it to expand the section and view the :guilabel:`Account` navigation
item.

.. image:: /images/Account_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Account Management View

Click the :guilabel:`Change Password` to open the :guilabel:`Change Password` 
modal.

.. image:: /images/Account_Management_Change_Password.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Account Management Change Password

2) Change the User Password
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Change Password` modal displays the following inputs for 
changing the MinIO User password:

.. image:: /images/Account_Management_Change_Password_Modal.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

.. list-table::
   :stub-columns: 1
   :width: 100%
   :widths: 30 70

   * - :guilabel:`Current Password`
     - Specify the existing password for the MinIO Tenant user.

   * - :guilabel:`New Password`
     - Specify the new password for the MinIO Tenant user.

   * - :guilabel:`Type New Password Again`
     - Specify the new password again for verification.

Click :guilabel:`Save` to save the new password. Future login attempts 
with the MinIO Tenant user must specify the new password.

.. _minio-k8s-create-service-account:

Create Service Accounts
-----------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

MinIO Service Accounts are child identities of a single parent MinIO User. 
Each Service Account inherits its privileges based on the 
:ref:`policies <minio-k8s-access-management>` attached to it's parent user
*and* the policy attached to each group in which the parent user has membership. 
Service Accounts also support an optional attached policy which restricts its 
access to a *subset* of the actions and resources available to the parent user.

Service Accounts allow MinIO Tenant users to manage access to the Tenant 
without relying on administrative action. Disabling or deleting the parent 
user also disables/deletes all of that user's Service Accounts.

MinIO Service Accounts are only available through the MinIO Console. 
The following procedure uses the MinIO Console to create a new Service Account
associated to a MinIO Tenant user.

1) Open the Account Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To create a new Service Account, open the MinIO Console in your browser and log
in with your credentials. From the Console, click :guilabel:`Account` in the
left hand navigation. If the :guilabel:`User` navigation group is collapsed,
click on it to expand the section and view the :guilabel:`Account` navigation
item.

.. image:: /images/Account_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Service Account Management View

The :guilabel:`Account` interface shows all existing Service Accounts 
created by the current user. Click the :guilabel:`+ Create Service Account` 
button to open the :guilabel:`Create Service Account` modal.

2) Create a New Service Account
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Create Service Account` modal displays an input for configuring 
an optional IAM policy for the new Service Account:

.. image:: /images/Account_Management_Create.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Service Account Management Create New Service Account

MinIO Service Accounts inherit its privileges from the policies attached to and
inherited by the Tenant user. The optional policy can specify a *subset* of the
actions and resources explicitly allowed as part of the Tenant user's
privileges. You *cannot* apply a custom policy after creating the Service
Account. 

Click :guilabel:`Create` to create the Service Account with the optional 
IAM policy if one is specified.

3) Copy the Service Account Credentials
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`New Service Account Created` dialog presents the 
randomly generated Access Key and Secret key for the new Service Account.

.. image:: /images/Account_Management_Create_Credentials.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Service Account Management View Download Credentials

Copy the credentials to a secure location, such as a password manager or similar
password protected system. You can also click :guilabel:`Download` to download
the credentials as a JSON file. The MinIO Console only displays the Secret Key
in this dialog and *never* displays it again after closing the dialog. 

Delete Service Users
--------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

MinIO Service Accounts are special credentials associated to a single 
MinIO Tenant user. Each Service Account consists of an automatically generated 
random Access Key and a shared Secret Key.

The following procedure deletes a Service Account associated to a 
MinIO Tenant user. Applications using that Service Account cannot access 
the MinIO Tenant using the Service Account credentials after deletion.
Service User management is available *only* through the MinIO Console.

1) Open the Account Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To create a new Service Account, open the MinIO Console in your browser and log
in with your credentials. From the Console, click :guilabel:`Account` in the
left hand navigation. If the :guilabel:`User` navigation group is collapsed,
click on it to expand the section and view the :guilabel:`Account` navigation
item.

.. image:: /images/Account_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

The :guilabel:`Account` interface shows all existing Service Accounts 
created by the current user.

2) Delete the Service Account
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Click the :guilabel:`Trash` icon to open the :guilabel:`Delete Service Account` 
modal.

.. image:: /images/Account_Management_Select_Delete.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console User Management View

You must confirm user deletion by clicking :guilabel:`Delete` from the modal. 

.. image:: /images/Account_Management_Delete.png
   :align: center
   :width: 50%
   :class: no-scaled-link
   :alt: MinIO Console User Management Delete User

