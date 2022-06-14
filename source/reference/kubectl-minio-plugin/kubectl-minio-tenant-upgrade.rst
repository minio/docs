
.. _kubectl-minio-tenant-upgrade:

================================
``kubectl minio tenant upgrade``
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio tenant upgrade

Description
-----------

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. start-kubectl-minio-tenant-upgrade-desc

Upgrades the ``minio`` server container image used by the MinIO Tenant.

.. end-kubectl-minio-tenant-upgrade-desc

.. important::

   MinIO upgrades the image used by all pods in the Tenant at once. 
   Applications typically transparently retry operations against the MinIO Tenant, such that there should be no perceived downtime.

   Test all upgrades in a staging environment, such as a separate MinIO Tenant, before applying to production tenants.

Syntax
------

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example expands a MinIO Tenant with a Pool consisting of 4 MinIO servers with 8 drives each and a total additional capacity of 32Ti:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         kubectl minio tenant upgrade            \
                                minio-tenant-1   \
                                --image  quay.io/minio/minio:|minio-latest|

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell

         kubectl minio tenant upgrade 
                                TENANT_NAME    \
                                --image        \
                                --namespace    \
                                [--output]

Flags
-----

The command supports the following flags:

.. mc-cmd:: TENANT_NAME
   :required:

   The name of the MinIO tenant to upgrade. 

.. mc-cmd:: --image
   :required:

   The container image to use for upgrading the MinIO Tenant.

.. mc-cmd:: --namespace
   :optional:

   The namespace in which to look for the MinIO Tenant. 
   
   Defaults to ``minio``.

.. mc-cmd:: --output
   :optional:

   Displays the generated ``YAML`` objects, but does not upgrade the tenant. 
