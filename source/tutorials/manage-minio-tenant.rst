=====================
Manage a MinIO Tenant
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

This page documents several common procedures for managing an existing 
MinIO Tenant.

Expand a MinIO Tenant
---------------------

This procedure documents expanding a MinIO Tenant by adding a new 
Pool of MinIO Pods and storage resources.

1) Configure the Persistent Volumes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO automatically generates one 
:kube-docs:`Persistent Volume Claim (PVC) 
<concepts/storage/persistent-volumes/#persistentvolumeclaims>` for each 
volume in the Pool. The Kubernetes cluster *must* have an equal number of 
unbound :kube-docs:`Persistent Volumes (PV) <concepts/storage/volumes/>`. MinIO 
*strongly recommends* using locally-attached storage to maximize performance and 
throughput.

The following steps create the necessary 
:kube-docs:`local <concepts/storage/volumes/#local>` Persistent Volumes (PV)
resources such that each MinIO Pod and their associated storage are local 
to the same Node.

You can skip this step if the cluster already has local ``PV`` resources
configured for use by the MinIO Tenant.

The following YAML describes a ``PV`` ``local`` volume:

.. code-block:: yaml
   :class: copyable
   :emphasize-lines: 4, 12, 14, 22

   apiVersion: v1
   kind: PersistentVolume
   metadata:
      name: PV-NAME
   spec:
      capacity:
         storage: 1Ti
      volumeMode: Filesystem
      accessModes:
      - ReadWriteOnce
      persistentVolumeReclaimPolicy: Retain
      storageClassName: local-storage
      local:
         path: /mnt/disks/ssd1
      nodeAffinity:
         required:
            nodeSelectorTerms:
            - matchExpressions:
            - key: kubernetes.io/hostname
               operator: In
               values:
               - NODE-NAME

.. list-table::
   :header-rows: 1
   :widths: 20 80
   :width: 100%

   * - Field
     - Description

   * - .. code-block:: yaml
   
            metadata:
               name:

     - Set to a name that supports easy visual identification of the
       ``PV`` and its associated physical host. For example, for a ``PV`` on 
       host ``minio-1``, consider specifying ``minio-1-pv-1``.

   * - .. code-block:: yaml

            nodeAffinity:
            required: 
               nodeSelectorTerms:
               - key: 
                  values:

     - Set to the name of the node on which the physical disk is
       installed.

   * - .. code-block:: yaml
            
            spec:
               storageClassName:

     - Set to the ``StorageClass`` created for supporting the
       MinIO ``local`` volumes.

   * - .. code-block:: yaml
   
            spec:
               local:
                  path:

     - Set to the full file path of the locally-attached disk. You
       can specify a directory on the disk to isolate MinIO-specific data.
       The specified disk or directory **must** be empty for MinIO to start.

Create one ``PV`` for each volume in the new Pool. For example, given a
Kubernetes cluster with 4 available nodes with 4 locally attached drives,
create a total of 16 ``local`` ``PVs``.

Issue the ``kubectl get PV`` command to validate the created PVs:

.. code-block:: shell
   :class: copyable

   kubectl get PV

2) Expand the MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant expand` command to create the MinIO
Tenant.

The following example expands a MinIO Tenant with a Pool consisting of
4 Nodes with 4 locally-attached drives of 1Ti each:

.. code-block:: shell
   :class: copyable

   kubectl minio tenant expand minio-tenant-1   \
     --servers                 4                \
     --volumes                 16               \
     --capacity                16Ti             \
     --namespace               minio-tenant-1

The following table explains each argument specified to the command:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Argument
     - Description

   * - :mc-cmd:`minio-tenant-1 <kubectl minio tenant create TENANT_NAME>`
     - The name of the MinIO Tenant which the command creates.

   * - :mc-cmd-option:`~kubectl minio tenant create servers`
     - The number of ``minio`` servers to deploy across the Kubernetes 
       cluster.

   * - :mc-cmd-option:`~kubectl minio tenant create volumes`
     - The number of volumes in the cluster. :mc:`kubectl minio` determines the
       number of volumes per server by dividing ``volumes`` by ``servers``.

   * - :mc-cmd-option:`~kubectl minio tenant create capacity`
     - The total capacity of the cluster. :mc:`kubectl minio` determines the 
       capacity of each volume by dividing ``capacity`` by ``volumes``.

   * - :mc-cmd-option:`~kubectl minio tenant create namespace`
     - The Kubernetes namespace in which to deploy the MinIO Tenant.

3) Validate the Expanded MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant info` command to return a summary of 
the MinIO Tenant, including the new Pool:

.. code-block:: shell
   :class: copyable

   kubectl minio tenant info minio-tenant-1 \
     --namespace minio-tenant-1

Upgrade a MinIO Tenant
----------------------

This procedure documents upgrading pods running on a MinIO Tenant.

1) Validate the Active MinIO Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant info` command to return a summary of 
the MinIO Tenant, including the new Pool:

.. code-block:: shell
   :class: copyable

   kubectl minio tenant info TENANT_NAME \
     --namespace TENANT_NAMESPACE  

- Replace ``TENANT_NAME`` with the name of the Tenant.
- Replace ``TENANT_NAMESPACE`` with the namespace of the Tenant.

The output includes the version of the MinIO Server used by all Pods in the 
Tenant.

2) Upgrade the MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant upgrade` command to upgrade the Docker
image used by *all* MinIO Pods in the Tenant. MinIO upgrades *all* ``minio``
server processes at once. This may result in downtime until the upgrade process
completes.

.. code-block:: shell
   :class: copyable

   kubectl minio tenant upgrade TENANT_NAME \
     --image     minio:minio:RELEASE:YYYY-MM-DDTHH-MM-SSZ    \
     --namespace TENANT_NAMESPACE                              \

- Replace ``TENANT_NAME`` with the name of the Tenant.
- Replace ``RELEASE:YYYY-MM-DDTHH-MM-SSZ`` with the specific release to use. 
  Specify ``minio/minio`` to use the latest stable version of MinIO.
- Replace ``TENANT_NAMESPACE`` with the namespace of the Tenant.

See :minio-git:`MinIO Tags <minio/tags>` for a list of release tags. 
MinIO Releases use ``RELEASE:YYYY-MM-DDTHH-MM-SSZ`` format. 

Delete a MinIO Tenant
---------------------

Use the :mc-cmd:`kubectl minio tenant delete` command to delete a MinIO 
Tenant and its associated resources.

The delete behavior of each Persistent Volume Claims (``PVC``) generated by the 
Tenant depends on the 
:kube-docs:`Reclaim Policy 
<concepts/storage/persistent-volumes/#reclaim-policy>` of its bound 
Persistent Volume (``PV``):

- For ``recycle`` or ``delete`` policies, the command deletes the ``PVC``.

- For ``retain``, the command retains the ``PVC``.

Deletion of the underlying ``PV``, whether automatic or manual, results in the 
loss of any objects stored on the MinIO Tenant. Perform all due diligence in 
ensuring the safety of stored data *prior* to deleting the Tenant.

.. code-block:: shell
   :class: copyable

   kubectl minio tenant delete TENANT_NAME \
     --namespace TENANT_NAMESPACE

- Replace ``TENANT_NAME`` with the name of the Tenant.
- Replace ``TENANT_NAMESPACE`` with the namespace of the Tenant.

The command includes a confirmation prompt that requires explicit 
approval of the delete operation.
