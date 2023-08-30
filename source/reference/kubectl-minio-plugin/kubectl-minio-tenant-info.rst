
.. _kubectl-minio-tenant-info:

=============================
``kubectl minio tenant info``
=============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio tenant info

Description
-----------

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. start-kubectl-minio-tenant-info-desc

Displays information on a MinIO Tenant, including but not limited to:

- The total capacity of the Tenant
- The version of MinIO server and MinIO Console running on the Tenant
- The configuration of each Pool in the Tenant.
- The root user credentials for the Tenant.

.. end-kubectl-minio-tenant-info-desc

Syntax
------

.. tab-set::
                                    
   .. tab-item:: EXAMPLE

      The following example retrieves the information of the MinIO Tenant ``minio-tenant-1`` in the namespace ``minio-namespace-1``.

      .. code-block:: shell
         :class: copyable

         kubectl minio tenant info                          \
                              minio-tenant-1                \
                              --namespace minio-namespace-1 

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell

         kubectl minio tenant info          \
                              TENANT_NAME   \
                              --namespace


Flags
-----

The command supports the following flag:

.. mc-cmd:: --namespace
   :optional:

   The namespace in which to look for the MinIO Tenant.

   Defaults to ``minio``.
