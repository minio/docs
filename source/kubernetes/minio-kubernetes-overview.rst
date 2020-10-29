.. _minio-kubernetes:

=======================
MinIO Kubernetes Plugin
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

MinIO is a high performance distributed object storage server, designed for
large-scale private cloud infrastructure. Orchestration platforms like
Kubernetes provide perfect cloud-native environment to deploy and scale MinIO.
The :minio-git:`MinIO Kubernetes Operator </minio-operator>` brings native MinIO
support to Kubernetes. 

The :mc:`kubectl minio` plugin brings native support for deploying MinIO
tenants to Kubernetes clusters using the ``kubectl`` CLI. You can use
:mc:`kubectl minio` to deploy a MinIO tenant with little to no interaction
with ``YAML`` configuration files. 

.. image:: /images/Kubernetes-Minio.svg
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: Kubernetes Orchestration with the MinIO Operator facilitates automated deployment of MinIO clusters.

:mc:`kubectl minio` builds its interface on top of the
MinIO Kubernetes Operator. Visit the
:minio-git:`MinIO Operator </minio-operator>` Github repository to follow
ongoing development on the Operator and Plugin.

Installation
------------

**Prerequisite**

Install the `krew <https://github.com/kubernetes-sigs/krew>`__ ``kubectl`` 
plugin manager using the `documented installation procedure
<https://krew.sigs.k8s.io/docs/user-guide/setup/install/>`__. 

Install Using ``krew``
~~~~~~~~~~~~~~~~~~~~~~

Run the following command to install :mc:`kubectl minio` using ``krew``:

.. code-block:: shell
   :class: copyable

   kubectl krew update
   kubectl krew install minio

Update Using ``krew``
~~~~~~~~~~~~~~~~~~~~~

Run the following command to update :mc:`kubectl minio`:

.. code-block:: shell
   :class: copyable

   kubectl krew upgrade

Deploy a MinIO Tenant
---------------------

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
     - The number of :mc:`minio` servers to deploy across the Kubernetes 
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

If :mc-cmd:`kubectl minio tenant create` succeeds in creating the MinIO Tenant,
the command outputs connection information to the terminal. The output includes
the credentials for the :mc:`minio` :ref:`root <minio-users-root>` user and
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
values prior to specifying them to :mc:`mc` or other S3-compatible tools.

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

MinIO Kubernetes Plugin Syntax
------------------------------

.. mc:: kubectl minio

Create the MinIO Operator
~~~~~~~~~~~~~~~~~~~~~~~~~

.. mc-cmd:: init
   :fullpath:

   Initializes the MinIO Operator. :mc:`kubectl minio` requires the operator for
   core functionality.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio init [FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: image
      :option:

      The image to use for deploying the operator. 
      Defaults to the :minio-git:`latest release of the operator
      <minio/operator/releases/latest>`:

      ``minio/k8s-operator:latest``

   .. mc-cmd:: namespace
      :option:

      The namespace into which to deploy the operator.

      Defaults to ``minio-operator``.

   .. mc-cmd:: cluster-domain
      :option:

      The domain name to use when configuring the DNS hostname of the
      operator. Defaults to ``cluster.local``.

   .. mc-cmd:: namespace-to-watch
      :option:

      The namespace which the operator watches for MinIO tenants.

      Defaults to ``""`` or *all namespaces*.

   .. mc-cmd:: image-pull-secret
      :option:

      Secret key for use with pulling the 
      :mc-cmd-option:`~kubectl minio init image`.

      The MinIO-hosted ``minio/k8s-operator`` image is *not* password protected.
      This option is only required for non-MinIO image sources which are
      password protected.

   .. mc-cmd:: output
      :option:

      Performs a dry run and outputs the generated YAML to ``STDOUT``. Use
      this option to customize the YAML and apply it manually using
      ``kubectl apply -f <FILE>``.

Delete the MinIO Operator
~~~~~~~~~~~~~~~~~~~~~~~~~

.. mc-cmd:: delete
   :fullpath:

   Deletes the MinIO Operator along with all associated resources, 
   including all MinIO Tenant instances in the
   :mc-cmd:`watched namespace <kubectl minio init namespace-to-watch>`.

   .. warning::

      If the underlying Persistent Volumes (``PV``) were created with
      a reclaim policy of ``recycle`` or ``delete``, deleting the MinIO
      Tenant results in complete loss of all objects stored on the tenant.

      Ensure you have performed all due diligence in confirming the safety of
      any data on the MinIO Tenant prior to deletion.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio delete [FLAGS]

   The command accepts the following arguments:

   .. mc-cmd:: namespace
      :option:

      The namespace of the MinIO operator to delete.

      Defaults to ``minio-operator``.

Create a MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc


.. mc-cmd:: tenant create
   :fullpath:

   Creates a MinIO Tenant using the 
   :minio-git:`latest release <minio/minio/releases/latest>` of :mc:`minio`:

   ``minio/minio:latest``

   The command creates the following resources in the Kubernetes cluster. 

   - The MinIO Tenant.

   - Persistent Volume Claims (``PVC``) for each  
     :mc-cmd:`volume <kubectl minio tenant create volumes>` in the tenant.

   - Pods for each
     :mc-cmd:`server <kubectl minio tenant create servers>` in the tenant.

   - Kubernetes secrets for storing access keys and secret keys. Each
     secret is prefixed with the Tenant name.

   - The MinIO Console Service (MCS). See the :minio-git:`console <console>` 
     Github repository for more information on MCS.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant create          \
        --names            NAME            \
        --servers          SERVERS         \
        --volumes          VOLUMES         \
        --capacity         CAPACITY        \
        --storageClassName STORAGECLASS    \
        [OPTIONAL_FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required*

      The name of the MinIO tenant which the command creates. The
      name *must* be unique in the 
      :mc-cmd:`~kubectl minio tenant create namespace`.

   .. mc-cmd:: servers
      :option:

      *Required*

      The number of :mc:`minio` servers to deploy on the Kubernetes cluster.
      
      Ensure that the specified number of 
      :mc-cmd-option:`~kubectl minio tenant create servers` does *not*
      exceed the number of nodes in the Kubernetes cluster. MinIO strongly
      recommends sizing the cluster to have one node per MinIO server.

   .. mc-cmd:: volumes
      :option:

      *Required*

      The number of volumes in the MinIO tenant. :mc:`kubectl minio`
      generates one Persistent Volume Claim (``PVC``) for each volume.
      :mc:`kubectl minio` divides the 
      :mc-cmd-option:`~kubectl minio tenant create capacity` by the number of
      volumes to determine the amount of ``resources.requests.storage`` to
      set for each ``PVC``.
      
      :mc:`kubectl minio` determines
      the number of ``PVC`` to associate to each :mc:`minio` server by dividing
      :mc-cmd-option:`~kubectl minio tenant create volumes` by 
      :mc-cmd-option:`~kubectl minio tenant create servers`.

      :mc:`kubectl minio` also configures each ``PVC`` with node-aware
      selectors, such that the :mc:`minio` server process uses a ``PVC``
      which correspond to a ``local`` Persistent Volume (``PV``) on the 
      same node running that process. This ensures that each process
      uses local disks for optimal performance.

      If the specified number of volumes exceeds the number of 
      ``PV`` available on the cluster, :mc:`kubectl minio tenant create`
      hangs and waits until the required ``PV`` exist.

   .. mc-cmd:: capacity
      :option:

      *Required*

      The total capacity of the MinIO tenant. :mc:`kubectl minio` divides
      the capacity by the number of
      :mc-cmd-option:`~kubectl minio tenant create volumes` to determine the 
      amount of ``resources.requests.storage`` to set for each
      Persistent Volume Claim (``PVC``).

      If the existing Persistent Volumes (``PV``) in the cluster cannot
      satisfy the requested storage, :mc:`kubectl minio tenant create`
      hangs and waits until the required storage exists.

   .. mc-cmd:: storageClassName
      :option:

      *Required*

      The name of the Kubernetes 
      :kube-docs:`Storage Class <concepts/storage/storage-classes/>` to use
      when creating Persistent Volume Claims (``PVC``) for the
      MinIO Tenant. The specified 
      :mc-cmd-option:`~kubectl minio tenant create storageClassName` 
      *must* match the ``StorageClassName`` of the Persistent Volumes (``PVs``)
      to which the ``PVCs`` should bind.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to create the MinIO Tenant. 

      Defaults to ``minio``.

   .. mc-cmd:: kes-config
      :option:

      The name of the Kubernetes Secret which contains the 
      MinIO Key Encryption Service (KES) configuration.

   .. mc-cmd:: output
      :option:

      Outputs the generated ``YAML`` objects to ``STDOUT`` for further
      customization. 
      
      :mc-cmd-option:`~kubectl minio tenant create output` does 
      **not** create the MinIO Tenant. Use ``kubectl apply -f <FILE>`` to
      manually create the MinIO tenant using the generated file.

Expand a MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. mc-cmd:: tenant expand
   :fullpath:

   Adds a new zone to an existing MinIO Tenant.

   The command creates the new zone using the 
   :minio-git:`latest release <minio/minio/releases/latest>` of :mc:`minio`:

   ``minio/minio:latest``

   Consider using :mc-cmd:`kubectl minio tenant upgrade` to upgrade the
   MinIO tenant *before* adding the new zone to ensure consistency across the
   entire tenant.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant expand  \
        --names    NAME            \
        --servers  SERVERS         \
        --volumes  VOLUMES         \
        --capacity CAPACITY        \
        [OPTIONAL_FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required*

      The name of the MinIO Tenant which the command expands.

   .. mc-cmd:: servers
      :option:

      *Required*

      The number of :mc:`minio` servers to deploy in the new MinIO Tenant zone.
      
      Ensure that the specified number of 
      :mc-cmd-option:`~kubectl minio tenant expand servers` does *not* exceed
      the number of unused nodes in the Kubernetes cluster. MinIO strongly
      recommends sizing the cluster to have one node per MinIO server in the new
      zone.

   .. mc-cmd:: volumes
      :option:

      *Required*

      The number of volumes in the new MinIO Tenant zone. 
      :mc:`kubectl minio` generates one Persistent Volume Claim (``PVC``) for
      each volume. :mc:`kubectl minio` divides the 
      :mc-cmd-option:`~kubectl minio tenant expand capacity` by the number of
      volumes to determine the amount of ``resources.requests.storage`` to set
      for each ``PVC``.
      
      :mc:`kubectl minio` determines
      the number of ``PVC`` to associate to each :mc:`minio` server by dividing
      :mc-cmd-option:`~kubectl minio tenant expand volumes` by 
      :mc-cmd-option:`~kubectl minio tenant expand servers`.

      :mc:`kubectl minio` also configures each ``PVC`` with node-aware
      selectors, such that the :mc:`minio` server process uses a ``PVC``
      which correspond to a ``local`` Persistent Volume (``PV``) on the 
      same node running that process. This ensures that each process
      uses local disks for optimal performance.

      If the specified number of volumes exceeds the number of 
      ``PV`` available on the cluster, :mc:`kubectl minio tenant expand`
      hangs and waits until the required ``PV`` exist.

   .. mc-cmd:: capacity
      :option:

      *Required*

      The total capacity of the new MinIO Tenant zone. :mc:`kubectl minio` 
      divides the capacity by the number of
      :mc-cmd-option:`~kubectl minio tenant expand volumes` to determine the 
      amount of ``resources.requests.storage`` to set for each
      Persistent Volume Claim (``PVC``).

      If the existing Persistent Volumes (``PV``) in the cluster cannot
      satisfy the requested storage, :mc:`kubectl minio tenant expand`
      hangs and waits until the required storage exists.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to create the new MinIO Tenant zone. The namespace
      *must* match that of the MinIO Tenant being extended.

      Defaults to ``minio``.

   .. mc-cmd:: output
      :option:

      Outputs the generated ``YAML`` objects to ``STDOUT`` for further
      customization. 
      
      :mc-cmd-option:`~kubectl minio tenant expand output` does **not** create
      the new MinIO Tenant zone. Use ``kubectl apply -f <FILE>`` to manually
      create the MinIO tenant using the generated file.

Get MinIO Tenant Zones
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. mc-cmd:: tenant info
   :fullpath:

   Lists all existing MinIO zones in a MinIO Tenant.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant info --names NAME [OPTIONAL_FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required*

      The name of the MinIO Tenant for which the command returns the
      existing zones.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to look for the MinIO Tenant.

      Defaults to ``minio``.

Upgrade MinIO Tenant
~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. mc-cmd:: tenant upgrade
   :fullpath:

   Upgrades the :mc:`minio` server Docker image used by the MinIO Tenant.
   
   .. important::

      MinIO upgrades *all* :mc:`minio` server processes at once. This may
      result in a brief period of downtime if a majority (``n/2-1``) of 
      servers are offline at the same time.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant upgrade --names NAME [OPTIONAL_FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required*

      The name of the MinIO Tenant which the command updates.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to look for the MinIO Tenant.

      Defaults to ``minio``.

Delete a MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. mc-cmd:: tenant delete
   :fullpath:

   Deletes the MinIO Tenant and its associated resources.

   Kubernetes only deletes the Minio Tenant Persistent Volume Claims (``PVC``)
   if the underlying Persistent Volumes (``PV``) were created with a 
   reclaim policy of ``recycle`` or ``delete``. ``PV`` with a reclaim policy of
   ``retain`` require manual deletion of their associated ``PVC``.
   
   Deletion of the underlying ``PV``, whether automatic or manual, results in
   the loss of any objects stored on the MinIO Tenant. Perform all due 
   diligence in ensuring the safety of stored data *prior* to deleting the 
   tenant.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant delete --names NAME [OPTIONAL_FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required*

      The name of the MinIO Tenant to delete.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to look for the MinIO Tenant.

      Defaults to ``minio``.

.. toctree::
   :hidden:
   :titlesonly:

   /kubernetes/minio-operator-reference