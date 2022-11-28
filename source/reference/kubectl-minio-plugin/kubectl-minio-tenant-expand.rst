
.. _kubectl-minio-tenant-expand:

===============================
``kubectl minio tenant expand``
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio tenant expand

Description
-----------

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. start-kubectl-minio-tenant-expand-desc

Extends the total capacity of a MinIO Tenant by adding a new Pool. 
A Pool consists of an independent set of pods running the MinIO Server and MinIO Console. 
The new pool uses the same MinIO Server and Console Docker images as the existing Tenant pool(s).

.. end-kubectl-minio-tenant-expand-desc

Syntax
------

.. tab-set::
                                    
   .. tab-item:: EXAMPLE

      The following example expands a MinIO Tenant with a Pool consisting of 4 MinIO servers with 8 drives each and a total additional capacity of 32Ti:

      .. code-block:: shell
         :class: copyable

         kubectl minio tenant expand                            \
                              minio-tenant-1                    \
                              --servers          4              \
                              --volumes          8              \
                              --capacity         32Ti           \
                              --namespace        minio-tenant-1 \
                              --storage-class    local-storage

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell

         kubectl minio tenant expand            \
                              TENANT_NAME       \
                              --capacity        \
                              --servers         \
                              --volumes         \
                              --namespace       \
                              [--output]        \
                              [--pool]          \
                              [--storage-class]

Flags
-----

The command supports the following flags:

.. mc-cmd:: TENANT_NAME
   :required:

   The name of the MinIO tenant to expand. 

.. mc-cmd:: --capacity
   :optional:

   The total capacity of the new MinIO Tenant Pool. :mc:`kubectl minio` divides the capacity by the number of :mc-cmd:`~kubectl minio tenant expand --volumes` to determine the 
      amount of ``resources.requests.storage`` to set for each Persistent Volume Claim (``PVC``).

   If the existing Persistent Volumes (``PV``) can satisfy the requested storage, :mc:`kubectl minio tenant expand` hangs and waits until the required storage exists.

.. mc-cmd:: --servers
   :required:

   The number of ``minio`` servers to deploy in the new MinIO Tenant Pool.
      
   Ensure that the specified number of :mc-cmd:`~kubectl minio tenant expand --servers` does *not* exceed the number of available nodes in the Kubernetes cluster.
   
.. mc-cmd:: --volumes
   :required:

   The number of volumes in the new MinIO Tenant Pool. 
   :mc:`kubectl minio` generates one Persistent Volume Claim (``PVC``) for each volume. 

   The number of volumes affects both the requested storage of each ``PVC`` *and* the number of ``PVC`` to associate to each MinIO Pod in the new Pool:

   - The command :mc:`kubectl minio` divides the :mc-cmd:`~kubectl minio tenant expand --capacity` by the number of volumes to determine the amount of ``resources.requests.storage`` to set for each ``PVC``.

   - :mc:`kubectl minio` determines the number of ``PVC`` to associate to each ``minio`` server by dividing :mc-cmd:`~kubectl minio tenant expand --volumes` by :mc-cmd:`~kubectl minio tenant expand --servers`.

   The command generates each ``PVC`` with Pod-specific selectors, such that each Pod only uses ``PV`` that are locally-attached to the node running that Pod.

   If the specified number of volumes exceeds the number of unbound ``PV`` available in the cluster, :mc:`kubectl minio tenant expand` hangs and waits until the required ``PV`` exist.

.. mc-cmd:: --namespace
   :optional:

   The namespace in which to create the new MinIO Tenant Pool. 
   The namespace *must* match that of the MinIO Tenant being extended.

   Defaults to ``minio``.

.. mc-cmd:: --output
   :optional:

   Outputs the generated ``YAML`` objects to ``STDOUT`` for further customization. 

   :mc-cmd:`~kubectl minio tenant expand --output` does **not** create the new MinIO Tenant Pool. 
   Use ``kubectl apply -f <FILE>`` to manually create the MinIO tenant using the generated file.

.. mc-cmd:: --pool
   :optional:

   The name to assign to the pool created for this expansion.

.. mc-cmd:: --storage-class
   :optional:

   The name of the Kubernetes :kube-docs:`Storage Class <concepts/storage/storage-classes/>` to use when creating Persistent Volume Claims (``PVC``) for the new MinIO Tenant Pool. 
   The specified :mc-cmd:`~kubectl minio tenant expand --storage-class` *must* match the ``storage-class`` of the Persistent Volumes (``PVs``) to which the ``PVCs`` should bind.

   MinIO strongly recommends creating a Storage Class that corresponds to locally-attached volumes on the host machines on which the Tenant deploys. 
   This ensures each pod can use locally-attached storage for maximum performance and throughput. 
   See the :ref:`Deploy MinIO Tenant <minio-k8s-deploy-minio-tenant>` tutorial for guidance on creating Storage Classes for supporting the MinIO Tenant.