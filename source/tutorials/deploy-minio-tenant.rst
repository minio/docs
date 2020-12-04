=====================
Deploy a MinIO Tenant
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

This page documents procedures for using either the MinIO Operator Console 
*or* the ``kubectl minio`` plugin for deploying a MinIO Tenant.

Deploy a Tenant using the MinIO Console
---------------------------------------

This procedure documents deploying a MinIO Tenant using the 
MinIO Operator Console. 

.. Return to this when Operator Console is ready.

Deploy a Tenant using the MinIO Kubernetes Plugin
-------------------------------------------------

This procedure documents deploying a MinIO Tenant using the 
MinIO Kubernetes Plugin :mc:`kubectl minio`. 

Kubernetes administrators who require more specific customization of 
Tenants prior to deployment can use this tutorial to create a validated 
``yaml`` resource file for further modification.

The following procedure creates a MinIO tenant using the
:mc:`kubectl minio` plugin.

1) Initialize the MinIO Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:mc:`kubectl minio` requires the MinIO Operator. Use the
:mc-cmd:`kubectl minio init` command to initialize the MinIO Operator:

.. code-block:: shell
   :class: copyable

   kubectl minio init

The example command deploys the MinIO operator to the ``default`` namespace.
Include the :mc-cmd-option:`~kubectl minio init namespace` option to
specify the namespace you want to deploy the MinIO operator into.

2) Configure the Persistent Volumes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO automatically generates one 
:kube-docs:`Persistent Volume Claim (PVC) 
<concepts/storage/persistent-volumes/#persistentvolumeclaims>` for each 
volume in the cluster. The cluster *must* have an equal number of 
:kube-docs:`Persistent Volumes (PV) <concepts/storage/volumes/>`. MinIO 
*strongly recommends* using locally-attached storage to maximize performance and 
throughput.

The following steps create the necessary 
:kube-docs:`StorageClass <concepts/storage/storage-classes/>` and 
:kube-docs:`local <concepts/storage/volumes/#local>` Persistent Volumes (PV)
resources such that each MinIO Pod and their associated storage are local 
to the same Node.

You can skip this step if the cluster already has local ``PV`` resources and a
``StorageClass`` configured for use by the MinIO Tenant.


a. Create a ``StorageClass`` for the MinIO ``local`` Volumes
````````````````````````````````````````````````````````````

.. container:: indent

   The following YAML describes a
   :kube-docs:`StorageClass <concepts/storage/storage-classes/>` with the
   appropriate fields for use with the ``local`` PV:

   .. code-block:: yaml
      :class: copyable

      apiVersion: storage.k8s.io/v1
      kind: StorageClass
      metadata:
         name: local-storage
      provisioner: kubernetes.io/no-provisioner
      volumeBindingMode: WaitForFirstConsumer

   The ``StorageClass`` **must** have ``volumeBindingMode`` set to
   ``WaitForFirstConsumer`` to ensure correct binding of each pod's 
   :kube-docs:`Persistent Volume Claims (PVC) 
   <concepts/storage/persistent-volumes/#persistentvolumeclaims>` to the
   Node's local ``PV``.

b. Create the Required Persistent Volumes
`````````````````````````````````````````

.. container:: indent

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

   Create one ``PV`` for each volume in the MinIO tenant. For example, given a
   Kubernetes cluster with 4 Nodes with 4 locally attached drives each, create a
   total of 16 ``local`` ``PVs``. 

c. Validate the Created PV
``````````````````````````

.. container:: indent

   Issue the ``kubectl get PV`` command to validate the created PVs:

   .. code-block:: shell
      :class: copyable

      kubectl get PV

3) Create a Namespace for the MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the ``kubectl create namespace`` command to create a namespace for
the MinIO Tenant:

.. code-block:: shell
   :class: copyable

   kubectl create namespace minio-tenant-1

MinIO supports exactly *one* Tenant per namespace.

4) Create the MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant create` command to create the MinIO
Tenant. The command always uses the latest stable Docker image of the 
:github:`MinIO Server <minio/releases>` and 
:github:`MinIO Console <console/releases>`.

The following example creates a 4-node MinIO deployment with a
total capacity of 16Ti across 16 drives.

.. code-block:: shell
   :class: copyable

   kubectl minio tenant create minio-tenant-1   \
     --servers                 4                \
     --volumes                 16               \
     --capacity                16Ti             \
     --storageClassName        local-storage    \
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

   * - :mc-cmd-option:`~kubectl minio tenant create storageClassName`
     - The Kubernetes ``StorageClass`` to use when creating each PVC.

On success, the command returns the following:

- The administrative username and password for the Tenant. Store these 
  credentials in a secure location, such as a password protected 
  key manager. MinIO does *not* show these credentials again.

- The Service created for connecting to the MinIO Console. The Console
  supports administrative operations on the Tenant, such as configuring 
  Identity and Access Management (IAM) and bucket configurations.

- The Service created for connecting to the MinIO Tenant. Applications 
  should use this service for performing operations against the MinIO 
  Tenant.

5) Configure Access to the Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:mc:`kubectl minio` creates a service for the MinIO Tenant and MinIO Console.
The output of :mc-cmd:`kubectl minio tenant create` includes the details for 
both services. You can also use ``kubectl get svc`` to retrieve the service 
name:

.. code-block:: shell
   :class: copyable

   kubectl get svc --namespace minio-tenant-1

The command returns output similar to the following:

.. code-block:: shell

   NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
   minio                    ClusterIP   10.109.88.X     <none>        443/TCP             137m
   minio-tenant-1-console   ClusterIP   10.97.87.X      <none>        9090/TCP,9443/TCP   129m
   minio-tenant-1-hl        ClusterIP   None            <none>        9000/TCP            137m

- The ``minio`` service corresponds to the MinIO Tenant service. Applications 
  should use this service for performing operations against the MinIO Tenant.

- The ``minio-tenant-1-console`` service corresponds to the MinIO Console. 
  Administrators should use this service for accessing the MinIO Console and 
  performing administrative operations on the MinIO Tenant.

- The ``minio-tenant-1-hl`` corresponds to a headless service used to 
  facilitate communication between Pods in the Tenant. 

By default each service is visible only within the Kubernetes cluster. 
Applications deployed inside the cluster can access the services using the 
``CLUSTER-IP``. For applications external to the Kubernetes cluster, 
you must configure the appropriate network rules to expose access to the 
service. Kubernetes provides multiple options for configuring external access 
to services. See the Kubernetes documentation on 
:kube-docs:`Publishing Services (ServiceTypes)
<concepts/services-networking/service/#publishing-services-service-types>`
and :kube-docs:`Ingress <concepts/services-networking/ingress/>`
for more complete information on configuring external access to services.

You can temporarily expose each service using the 
``kubectl port-forward`` utility. Run the following examples to forward 
traffic from the local host running ``kubectl`` to the services running inside 
the Kubernetes cluster.

.. tabs::

   .. tab:: MinIO Tenant

      .. code-block:: shell
         :class: copyable

         kubectl port-forward service/minio 443:443

   .. tab:: MinIO Console
   
      .. code-block:: shell
         :class: copyable

         kubectl port-forward service/minio-tenant-1-console 9443:9443