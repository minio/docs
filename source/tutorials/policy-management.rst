=================
Policy Management
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

This page documents procedures for managing policies on a MinIO Tenant. MinIO
uses Policy-Based Access Control (PBAC) for defining the actions and resources
to which a client has access. MinIO policies are JSON documents with
:iam-docs:`IAM-compatible syntax <reference_policies.html>`.

Each MinIO user can have *one* attached policy for
defining its scope of access. MinIO also supports creating *groups* of users,
where the users inherit the policy attached to the group. A group can have *one*
attached policy for defining the scope of access of its membership. 

A given user's access therefore consists of the set of both its explicitly
attached policy *and* all inherited policies from its group membership. MinIO
only processes the requested operation if the user's complete set of policies
explicitly allow access to both the required actions *and* resources for that
operation.

.. _minio-k8s-create-new-policy:

Create New Policy
-----------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access

The following procedure uses the MinIO Console to create a new policy on the 
MinIO Tenant. You can then attach the new policy to a user or group on the 
MinIO Tenant.

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the Policy Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`IAM Policies` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`IAM Policies` navigation item.

.. image:: /images/IAM_Policy_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console IAM Policies Management View

Click the :guilabel:`+ Create Policy` button to open the 
:guilabel:`Create Policy` modal.

2) Configure the New Policy
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Create Policy` modal displays inputs for configuring a new 
IAM policy:

.. image:: /images/IAM_Policy_Create.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console IAM Policy Creation Modal

.. list-table::
   :stub-columns: 1
   :width: 100%
   :widths: 30 70

   * - :guilabel:`Policy Name`
     - The name of the policy. The name *must* be unique among all other 
       policies on the MinIO Tenant.

   * - :guilabel:`Write Policy`
     - The JSON document describing the IAM policy. 
       See :iam-docs:`IAM JSON policy reference <reference_policies.html>`
       for more complete documentation of supported syntax.

Click :guilabel:`Save` to save the new policy. You *cannot* update the 
policy JSON after saving.

.. important::

   The MinIO Console only validates that the JSON document has valid structure
   and syntax. The Console does not perform any simulations on the created
   policy to validate it's functionality in practice. Consider performing 
   end-to-end testing of the new policy to validate that it supports the 
   access required for the intended workload *prior* to using the policy in 
   production environments.                    

3) Attach Policy to User or Group
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Optional* You can skip this step if you do not intend to attach the policy to 
a user or group immediately. 

.. tabs::

   .. tab:: Users

      To attach a policy to a MinIO user, click :guilabel:`Users` in the 
      left-hand navigation. Click the :guilabel:`Flag` icon to open the 
      :guilabel:`Set Policies` modal. Under the :guilabel:`Assign Policies` 
      section, select the newly created policy. For more complete 
      documentation, see :ref:`minio-k8s-attach-user-policy`.

      Users can have at most *one* attached policy. If the user has an existing
      attached policy, specifying the newly created policy *replaces* the
      previous policy.

   .. tab:: Groups

      To attach a policy to a MinIO group, click :guilabel:`Groups` in the 
      left-hand navigation. Click the :guilabel:`Flag` icon to open the 
      :guilabel:`Set Policies` modal. Under the :guilabel:`Assign Policies`
      section, select the newly created policy. For more complete documentation,
      see :ref:`minio-k8s-assign-group-policy`.

      Groups can have at most *one* attached policy. All users with membership 
      in that group inherit the group policy. If the group has an existing 
      attached policy, specifying the newly created policy *replaces* the 
      previous policy.

.. _minio-k8s-delete-policy:

Delete Policy
-------------

.. include:: /includes/common-minio-kubernetes.rst
   :start-after: start-console-access
   :end-before: end-console-access


The following procedure uses the MinIO Console to delete an existing policy on
the MinIO Tenant. 

.. admonition:: Required Permissions
   :class: note, dropdown

   The ``consoleAdmin`` built-in policy provides the necessary permissions for 
   performing this procedure. Authenticate as a user that either has that 
   policy explicitly attached *or* inherits that policy from its group 
   membership.

1) Open the Policy Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the Console in your browser and log in with your credentials. 
From the Console, click :guilabel:`IAM Policies` in the left hand navigation. If 
the :guilabel:`Admin` navigation group is collapsed, click on it to expand 
the section and view the :guilabel:`IAM Policies` navigation item.

.. image:: /images/IAM_Policy_Management.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console IAM Policies Management View

2) Back Up the Policy
~~~~~~~~~~~~~~~~~~~~~

*Optional* You can skip this step if you do not need to keep a backup 
copy of the policy to delete.

From the :guilabel:`IAM Policies` section, click the row for the 
policy you intend to delete to open the :guilabel:`Info` modal:

.. image:: /images/IAM_Policy_View.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console IAM Policies Info

Copy the JSON document to a secure location to back up the policy. You can
recreate the policy using the JSON at a later time.

3) Delete the  Policy
~~~~~~~~~~~~~~~~~~~~~

To delete the policy, click the :guilabel:`Trash` icon to open the 
:guilabel:`Delete Policy` modal:

.. image:: /images/IAM_Policy_Select.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: MinIO Console IAM Policy Select Trash Icon

You must confirm policy deletion by clicking :guilabel:`Delete` from the modal.

.. image:: /images/IAM_Policy_Delete.png
   :align: center
   :width: 80%
   :class: no-scaled-link
   :alt: MinIO Console IAM Policy Select Trash Icon