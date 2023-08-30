
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


Example
-------

Display Tenant Details
~~~~~~~~~~~~~~~~~~~~~~

The following command outputs information for the Tenant ``minio-tenant`` in the namespace ``minio-ns``:

.. code-block:: shell
   :class: copyable

   kubectl minio tenant info               \
                     minio-tenant          \
                     --namespace minio-ns

The output resembles the following:

.. code-block:: shell

   Tenant 'minio-tenant', Namespace 'minio-ns', Total capacity 16 GiB

   Current status: Initialized
   MinIO version: minio/minio:RELEASE.2023-06-23T20-26-00Z
   MinIO service: minio/ClusterIP (port 443)
   Console service: minio-tenant-console/ClusterIP (port 9443)

   POOL    SERVERS    VOLUMES(SERVER)    CAPACITY(VOLUME)
   0       4          1                  4.0 GiB

   MinIO Root User Credentials:
   MINIO_ROOT_USER="root_user"
   MINIO_ROOT_PASSWORD="root_password"
