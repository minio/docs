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

Create a :kube-docs:`Persistent Volume (PV) <concepts/storage/volumes/>`
for each drive on each node. 

MinIO recommends using :kube-docs:`local <concepts/storage/volumes/#local>` PVs
to ensure best performance and operations:

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
   Node ``PV``.

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
            storage: 100Gi
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

             nodeAfinnity:
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

4) Create the MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant create` command to create the MinIO
Tenant.

The following example creates a 4-node MinIO deployment with a
total capacity of 16Ti across 16 drives.

.. code-block:: shell
   :class: copyable

   kubectl minio tenant create            \
     --name             minio-tenant-1    \
     --servers          4                 \
     --volumes          16                \
     --capacity         16Ti              \
     --storageClassName local-storage     \
     --namespace minio-tenant-1

The following table explains each argument specified to the command:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Argument
     - Description

   * - :mc-cmd-option:`~kubectl minio tenant create name`
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

.. leave the broken link alone. Once the IAM sections are fleshed out, this
  link should work again.

If :mc-cmd:`kubectl minio tenant create` succeeds in creating the MinIO Tenant,
the command outputs connection information to the terminal. The output includes
the credentials for the ``minio`` :ref:`root <minio-users-root>` user and
the MinIO Console Service.

.. code-block:: shell
   :emphasize-lines: 1-3, 7-9
   
   Tenant
   Access Key: 999466bb-8bd6-4d73-8115-61df1b0311f4
   Secret Key: f8e5ecc3-7657-493b-b967-aaf350daeec9
   Version: minio/minio:RELEASE.2020-09-26T03-44-56Z
   ClusterIP Service: minio-tenant-1-internal-service

   MinIO Console
   Access Key: e9ae0f3f-18e5-44c6-a2aa-dc2e95497734
   Secret Key: 498ae13a-2f70-4adf-a38e-730d24327426
   Version: minio/console:v0.3.14
   ClusterIP Service: minio-tenant-1-console

:mc-cmd:`kubectl minio` stores all credentials using Kubernetes Secrets, where
each secret is prefixed with the tenant 
:mc-cmd:`name <kubectl minio tenant create name>`:

.. code-block:: shell

   > kubectl get secrets --namespace minio-tenant-1

   NAME                            TYPE       DATA   AGE

   minio-tenant-1-console-secret   Opaque     5      123d4h
   minio-tenant-1-console-tls      Opaque     2      123d4h
   minio-tenant-1-creds-secret     Opaque     2      123d4h
   minio-tenant-1-tls              Opaque     2      123d4h

Kubernetes administrators with the correct permissions can view the secret
contents and extract the access and secret key:

.. code-block:: shell

   kubectl get secrets minio-tenant-1-creds-secret -o yaml

The access key and secret key are ``base64`` encoded. You must decode the
values prior to specifying them to any S3-compatible tools.

5) Configure Access to the Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:mc:`kubectl minio` creates a service for the MinIO Tenant.
Use ``kubectl get svc`` to retrieve the service name:

.. code-block:: shell
   :class: copyable

   kubectl get svc --namespace minio-tenant-1

The command returns output similar to the following:

.. code-block:: shell

   NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
   minio                    ClusterIP   10.109.88.X     <none>        443/TCP             137m
   minio-tenant-1-console   ClusterIP   10.97.87.X      <none>        9090/TCP,9443/TCP   129m
   minio-tenant-1-hl        ClusterIP   None            <none>        9000/TCP            137m

The created services are visible only within the Kubernetes cluster. External
access to Kubernetes cluster resources requires creating an 
:kube-docs:`Ingress object <concepts/services-networking/ingress>` that routes
traffic from an externally-accessible IP address or hostname to the ``minio``
service. Configuring Ingress also requires creating an 
:kube-docs:`Ingress Controller 
<concepts/services-networking/ingress-controller>` in the cluster.
Defer to the :kube-docs:`Kubernetes Documentation 
<concepts/services-networking>` for guidance on creating and configuring the
required resources for external access to cluster resources.

The following example Ingress object depends on the
`NGINX Ingress Controller for Kubernetes 
<https://www.nginx.com/products/nginx/kubernetes-ingress-controller>`__. 
The example is intended as a *demonstration* for creating an Ingress object and
may not reflect the configuration and topology of your Kubernetes cluster and
MinIO tenant. You may need to add or remove listed fields to suit your
Kubernetes cluster. **Do not** use this example as-is or without modification.

.. code-block:: yaml

   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: minio-ingress
     annotations:
       kubernetes.io/tls-acme: "true"
       kubernetes.io/ingress.class: "nginx"
       nginx.ingress.kubernetes.io/proxy-body-size: 1024m
   spec:
     tls:
     - hosts:
       - minio.example.com
       secretName: minio-ingress-tls
     rules:
     - host: minio.example.com
       http:
         paths:
         - path: /
           backend:
             serviceName: minio
             servicePort: http