
.. _kubectl-minio-tenant-list:

=============================
``kubectl minio tenant list``
=============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio tenant list

Description
-----------

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. start-kubectl-minio-tenant-list-desc

Displays a list of all of the tenants managed by the MinIO Operator.

.. end-kubectl-minio-tenant-list-desc

The output includes information for each tenant similar to the following: 

- Tenant name
- Tenant's namespace
- Total capacity
- Current status
- MinIO version

Syntax
------

The command has the following syntax:

.. code-block:: shell
   :class: copyable

   kubectl minio tenant list
