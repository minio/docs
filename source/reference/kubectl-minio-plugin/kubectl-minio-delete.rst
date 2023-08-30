
.. _kubectl-minio-delete:

========================
``kubectl minio delete``
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio delete

Description
-----------

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. start-kubectl-minio-delete-desc

Deletes the MinIO Operator along with all associated resources, including all MinIO Tenant instances in the :mc-cmd:`watched namespace <kubectl minio init --namespace-to-watch>`.

.. end-kubectl-minio-delete-desc

.. warning::

   If the underlying Persistent Volumes (``PV``) were created with a reclaim policy of ``recycle`` or ``delete``, deleting the MinIO Tenant results in complete loss of all objects stored on the tenant.

   Ensure you have performed all due diligence in confirming the safety of any data on each Operator-managed MinIO Tenant prior to deletion.

Syntax
------

.. tab-set::

   .. tab-item:: EXAMPLE
      
      The following example deletes a the MinIO Operator in the ``minio-operator`` namesapce and all its tenants:

      .. code-block:: shell
         :class: copyable

         kubectl minio delete --namespace minio-operator

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell

         kubectl minio delete                 \
                        --namespace           \
			[--force --dangerous]

Flags
-----

The command supports the following flags:

.. mc-cmd:: --namespace
   :required:

   The namespace of the operator to delete.

   Defaults to ``minio-operator``. 

.. mc-cmd:: --dangerous
   :optional:

   Safety flag to confirm deletion of the MinIO Operator and all tenants with :mc-cmd:`~kubectl minio delete --force`.

   This operation is irreversible.

.. mc-cmd:: --force
   :optional:

   Deletes the MinIO Operator and all tenants without confirmation.
   Requires the :mc-cmd:`~kubectl minio delete --dangerous` flag.

   This operation is irreversible.
