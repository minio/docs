.. _minio-groups:

================
Group Management
================

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


The :mc-cmd:`mc admin group` command supports the creation and management of
groups on the MinIO deployment. See the command reference for examples of
usage.

