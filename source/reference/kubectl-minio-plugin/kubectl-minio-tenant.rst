
.. _kubectl-minio-tenant:

========================
``kubectl minio tenant``
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio tenant

Description
-----------

.. start-kubectl-minio-tenant-desc

:mc-cmd:`kubectl minio tenant` creates and manages tenants for the MinIO Operator. 

.. end-kubectl-minio-tenant-desc

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

Subcommands
-----------

The :mc-cmd:`kubectl minio tenant` command includes the following subcommands:

- :mc-cmd:`~kubectl minio tenant create`
- :mc-cmd:`~kubectl minio tenant list`
- :mc-cmd:`~kubectl minio tenant info`
- :mc-cmd:`~kubectl minio tenant expand`
- :mc-cmd:`~kubectl minio tenant report`
- :mc-cmd:`~kubectl minio tenant upgrade`
- :mc-cmd:`~kubectl minio tenant delete`

.. toctree::
   :titlesonly:
   :hidden:

   /reference/kubectl-minio-plugin/kubectl-minio-tenant-create
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-delete
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-expand
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-info
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-list
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-report
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-upgrade