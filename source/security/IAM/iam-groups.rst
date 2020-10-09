.. _minio-groups:

======
Groups
======

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

A *group* is a collection of :ref:`users <minio-users>`. Each group
can have one or more assigned :ref:`policies <minio-policy>`
that explicitly list the actions and resources to which group members are
allowed or denied access.

For example, consider the following groups. Each group is assigned a
:ref:`built-in policy <minio-policy-built-in>` or supported
:ref:`policy action <minio-policy-actions>`. Each group also has one or
more assigned users. Each user's total set of permissions consists of their
explicitly assigned permission *and* the inherited permissions from each of
their assigned groups. MinIO by default *denies* access to any resource or
operation not explicitly allowed by a user's assigned or inherited policies.

.. list-table::
   :header-rows: 1
   :widths: 20 40 40
   :width: 100%

   * - Group
     - Policy
     - Members

   * - ``Operations``
     - | :userpolicy:`readwrite` on ``finance`` bucket
       | :userpolicy:`readonly` on ``audit`` bucket
     
     - ``john.doe``, ``jane.doe``

   * - ``Auditing``
     - | :userpolicy:`readonly` on ``audit`` bucket
     - ``jen.doe``, ``joe.doe``

   * - ``Admin``
     - :policy-action:`admin:*`
     - ``greg.doe``, ``jen.doe``

Groups provide a simplified method for managing shared permissions among
users with common access patterns and workloads. Client's *cannot* authenticate
to a MinIO deployment using a group as an identity.

.. admonition:: ``Deny`` overrides ``Allow``
   :class: note

   MinIO follows the IAM standard where a ``Deny`` rule overrides ``Allow`` rule
   on the same action or resource. For example, if a user has an explicitly
   assigned policy with an ``Allow`` rule for an action/resource while one of
   its groups has an assigned policy with a ``Deny`` rule for that
   action/resource, MinIO would apply only the ``Deny`` rule. 

   For more information on IAM policy evaluation logic, see the IAM
   documentation on 
   :iam-docs:`Determining Whether a Request is Allowed or Denied Within an Account 
   <reference_policies_evaluation-logic.html#policy-eval-denyallow>`.

Create a Group
--------------

Use the :mc-cmd:`mc admin group add` command to add a user to a group. 
MinIO implicitly creates the group if it does not already exist. You cannot
create empty groups:

Delete a Group
--------------

Use the :mc-cmd:`mc admin group remove` command to remove a group: