================
Group Management
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

This page documents procedures for managing groups on a MinIO Tenant. 
Each group can have *one* attached IAM policy, where all users with membership
in that group inherit that policy. Groups support more simplified management 
of user permissions on the MinIO Tenant.

.. _minio-k8s-create-new-group:

Create New MinIO Group
----------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

The following procedure uses the MinIO Console to create a new group on the 
MinIO Tenant.

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the Group Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the MinIO Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`Groups` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`Groups` navigation item.

.. image:: /images/Group_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Management View

The :guilabel:`Group` interface shows all existing MinIO groups. 
Click the :guilabel:`+ Create Group` button to open the
:guilabel:`Create Group` modal. 

2) Create a New Group
~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Create Group` modal displays the following inputs for 
configuring the new group:

.. image:: /images/Group_Management_Create.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Create Modal

.. list-table::
   :stub-columns: 1
   :width: 100%
   :widths: 30 70

   * - :guilabel:`Group Name`
     - The name of the group. The specified name *must* be unique among all 
       groups on the MinIO Tenant.

   * - :guilabel:`Assign Users`
     - The MinIO Tenant users with membership in the group. Toggle the 
       :guilabel:`Select` checkbox next to each user to assign to the group. 
       A highlighted or "active" checkbox indicates the user has membership in 
       the group. An empty or "inactive" checkbox indicates the user does not
       have membership in the group.

       You can filter users using the :guilabel:`Filter Users` input.

Click :guilabel:`Save` to save the new group.

3) Assign Policy to the New Group
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

From the :guilabel:`Groups` interface, click on the :guilabel:`flag` icon for
the newly created group to open the :guilabel:`Set Policies` modal:

.. image:: /images/Group_Management_Select_Policy.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Select Policies

The :guilabel:`Set Policies` modal displays information on the group's 
currently attached policy:

.. image:: /images/Group_Management_Policy.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Set Policies

A group can have at most *one* attached policy. From the :guilabel:`Assign
Policies` section, toggle the :guilabel:`Select` radio button next to the policy
to attach to the group:

You can filter policies using the :guilabel:`Filter by Policy` input.

Click :guilabel:`Save` to save the group with the newly attached policy. All
users with membership in that group inherit the attached policy *in addition to*
the user's own explicitly assigned policy *and* other group-attached policies.

For complete documentation on creating a new IAM policy to attach to a 
MinIO group, see :ref:`minio-k8s-create-new-policy`.

.. _minio-k8s-assign-group-policy:

Change Attached Group Policy
----------------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

MinIO uses Policy-Based Access Control (PBAC) to determine which actions and
resources to which a MinIO user has access. The user also inherits 
the policies attached to each group in which it has membership. The total 
set of permissions for a given user are both its explicitly assigned and 
inherited policies.

For complete documentation on creating a new IAM policy to attach to a 
MinIO group, see :ref:`minio-k8s-create-new-policy`.

The following procedure uses the MinIO Console to manage the IAM policy 
attached to a group in the MinIO Tenant.

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the Group Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the MinIO Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`Groups` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`Groups` navigation item.

.. image:: /images/Group_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Management View

2) Change Policy Attached to Group
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

From the :guilabel:`Groups` interface, click on the :guilabel:`flag` icon for
the group to open the :guilabel:`Set Policies` modal:

.. image:: /images/Group_Management_Select_Policy.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Select Policies

A group can have at most *one* attached policy. From the 
:guilabel:`Assign Policies` section, toggle the :guilabel:`Select` radio button
next to the policy to attach to the group:

.. image:: /images/User_Management_Select.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Set Policies

You can filter policies using the :guilabel:`Filter by Policy` input.

Click :guilabel:`Save` to save the group with the newly attached policy. All
users with membership in that group inherit the attached policy *in addition to*
the user's own explicitly assigned policy *and* other group-attached policies.

.. _minio-k8s-change-group-membership:

Change User Membership in Group
-------------------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

MinIO uses Policy-Based Access Control (PBAC) to determine which actions and
resources to which a MinIO user has access. The user also inherits 
the policies attached to each group in which it has membership. The total 
set of permissions for a given user are both its explicitly assigned and 
inherited policies.

The following procedure uses the MinIO Console to change user membership 
in a group.

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the Group Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the MinIO Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`Groups` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`Groups` navigation item.

.. image:: /images/Group_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Management View

2) Change Group Membership
~~~~~~~~~~~~~~~~~~~~~~~~~~

Click the row of the group for which you want to manage MinIO Tenant user
membership to open the :guilabel:`Edit Group` modal:

.. image:: /images/Group_Management_Select_Row.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Management Select Row

The :guilabel:`Edit Group` modal displays inputs for adding or removing 
MinIO Tenant users from the group:

.. image:: /images/Group_Management_Edit.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Management Edit View

From the :guilabel:`Edit Members` section, toggle the :guilabel:`Select`
checkbox for each user to add or remove from the group. A highlighted or
"active" checkbox indicates the user has membership in the group. An empty or
"inactive" checkbox indicates the user does not have membership in the group.

You can filter users using the :guilabel:`Filter by Users` input.

Click :guilabel:`Save` to save the membership changes. All users with membership
in that group inherit the attached policy *in addition to* the user's own
explicitly assigned policy *and* other group-attached policies.

Enable or Disable a Group
-------------------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

The following procedure uses the MinIO Console to enable or disable 
a group on the MinIO Tenant. Users cannot inherit policies attached to a 
disabled group.

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the Group Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the MinIO Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`Groups` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`Groups` navigation item.

.. image:: /images/Group_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Management View

The :guilabel:`Group` interface shows all existing MinIO groups. 

2) Select the Group to Enable or Disable
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Click the row for the Group to open the :guilabel:`Edit Group` modal:

.. image:: /images/Group_Management_Select_Row.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Management Select Row

3) Enable or Disable the Group
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The toggle in the top-right hand corner of the :guilabel:`Edit Group` 
modal displays the current state of the MinIO group.

.. image:: /images/Group_Management_Edit.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Management Edit Group

If the toggle displays :guilabel:`Enabled`, the group is currently enabled. 
If the toggle displays :guilabel:`Disabled`, the group is currently disabled. 
Click the toggle to change the state of the group.

Click :guilabel:`Save` to save the changes. MinIO ignores disabled 
groups for the purpose of :ref:`authorizing <minio-k8s-access-management>` 
a user.

Delete a Group
--------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

The following procedure uses the MinIO Console to delete a group on the MinIO
Tenant. Users with membership in that group can no longer inherit the policy
attached to that group.

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the Group Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the MinIO Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`Groups` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`Groups` navigation item.

.. image:: /images/Group_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Management View

2) Delete the Group
~~~~~~~~~~~~~~~~~~~

To delete a group, click the :guilabel:`Trash` icon to open the 
:guilabel:`Delete User` modal:

.. image:: /images/Group_Management_Select_Delete.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console Group Select Trash Icon

You must confirm group deletion by clicking :guilabel:`Delete` from the modal. 

.. image:: /images/Group_Management_Delete.png
   :align: center
   :width: 50%
   :class: no-scaled-link
   :alt: MinIO Console Group Management Delete User