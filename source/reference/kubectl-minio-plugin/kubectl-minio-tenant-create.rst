
.. _kubectl-minio-tenant-create:

===============================
``kubectl minio tenant create``
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio tenant create

Description
-----------

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. start-kubectl-minio-tenant-create-desc

:mc-cmd:`kubectl minio tenant create` adds a new MinIO tenant and associated resources to a Kubernetes cluster. 
The :ref:`Operator Console <minio-operator-console>` provides a rich user interface for :ref:`deploying and managing MinIO Tenants <minio-k8s-deploy-minio-tenant>`.

:mc-cmd:`~kubectl minio tenant create` always uses the latest stable version of the  :github:`MinIO Server <minio/releases>` and :github:`MinIO Console <console/releases>`.

.. end-kubectl-minio-tenant-create-desc

On success, the command returns the following:

- The administrative username and password for the Tenant. 

  .. important:: 
     
     Store these credentials in a secure location, such as a password protected key manager. 
     MinIO does *not* show these credentials again.

- The Service created for connecting to the MinIO Console. 
  The Console supports administrative operations on the Tenant, such as configuring Identity and Access Management (IAM) and bucket configurations.

- The Service created for connecting to the MinIO Tenant. 
  Applications should use this service for performing operations against the MinIO Tenant.

Syntax
------

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example creates a MinIO Tenant in the namespace ``minio-tenant-1`` consisting of 4 MinIO servers with 8 drives each and a total capacity of 32Ti.

      .. code-block:: shell
         :class: copyable

         kubectl minio tenant create                             \
                              minio-tenant-1                     \
                              --servers          4               \
                              --volumes          8               \
                              --capacity         32Ti            \
                              --namespace        minio-tenant-1  \
                              --storage-class    local-storage

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell

         kubectl minio tenant create                            \
                              TENANT_NAME                       \
                              --capacity                        \
                              --servers                         \
                              --volumes | --volumes-per-server  \
                              [--interactive]                   \
                              [--disable-tls]                   \
                              [--enable-audit-logs]             \
                              [--enable-prometheus]             \
                              [--expose-console-service]        \
                              [--expose-minio-service]          \
                              [--image]                         \
                              [--image-pull-secret]             \
                              [--kes-config]                    \
                              [--kes-image]                     \
                              [--namespace]                     \
                              [--output]                        \
                              [--pool]                          \
                              [--storage-class]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Flags
-----

The command supports the following flags:

.. mc-cmd:: --interactive
   :optional:

   Offers command line prompts to request the information required to set up a new tenant.
   This command is mutually exclusive of the other flags when creating a new tenant.

   When added, prompts ask for input for the following values:

   - Tenant name
   - Total servers
   - Total volumes
   - Namespace
   - Capacity
   - Disable TLS
   - Disable audit logs
   - Disable prometheus

.. mc-cmd:: TENANT_NAME
   :required:

   The name of the MinIO tenant which the command creates. 
   The name *must* be unique in the :mc-cmd:`~kubectl minio tenant create --namespace`. 

.. mc-cmd:: --capacity
   :required:

   Total raw capacity of the MinIO tenant, such as 16Ti.
   Include a string that is a number and a standard storage capacity unit.

   The total capacity of the MinIO tenant. :mc:`kubectl minio` divides the capacity by the number of :mc-cmd:`~kubectl minio tenant create --volumes` to determine the amount of ``resources.requests.storage`` to set for each Persistent Volume Claim (``PVC``).

   If no Persistent Volumes (``PV``) can satisfy the requested storage, :mc:`kubectl minio tenant create` hangs and waits until the required storage exists.

.. mc-cmd:: --servers
   :required:

   The number of ``minio`` servers to deploy on the Kubernetes cluster.

   Ensure that the specified number of :mc-cmd:`~kubectl minio tenant create --servers` does *not* exceed the number of nodes in the Kubernetes cluster. 

.. mc-cmd:: --volumes
   :required:

   Mutually exclusive with :mc-cmd:`~kubectl minio tenant create --volumes-per-server`.
   Use either :mc-cmd:`~kubectl minio tenant create --volumes` or :mc-cmd:`~kubectl minio tenant create --volumes-per-server`.

   The total number of volumes in the new MinIO Tenant Pool.
   :mc-cmd:`kubectl minio tenant create` generates one :kube-docs:`Persistent Volume Claim (PVC) <concepts/storage/persistent-volumes/#persistentvolumeclaims>` for each volume. 

   The number of volumes affects both the requested storage of each ``PVC`` *and* the number of ``PVCs`` to associate to each MinIO Pod in the cluster:

   - The command :mc:`kubectl minio` divides the :mc-cmd:`~kubectl minio tenant create --capacity` by the number of volumes to determine the amount of ``resources.requests.storage`` to set for each ``PVC``.

   - :mc:`kubectl minio` determines the number of ``PVCs`` to associate to each ``minio`` server by dividing :mc-cmd:`~kubectl minio tenant create --volumes` by :mc-cmd:`~kubectl minio tenant create --servers`.

   The command generates each ``PVC`` with Pod-specific selectors, such that each Pod only uses ``PVs`` that are locally-attached to the node running that Pod.

   If the specified number of volumes exceeds the number of unbound ``PVs`` available on the cluster, :mc:`kubectl minio tenant create` hangs and waits until the required ``PVs`` exist.

.. mc-cmd:: --volumes-per-server
   :required:

   Mutually exclusive with :mc-cmd:`~kubectl minio tenant create --volumes`.
   Use either :mc-cmd:`~kubectl minio tenant create --volumes-per-server` or :mc-cmd:`~kubectl minio tenant create --volumes`.

   Number of volumes to use for each server in the pool.

   Similar to :mc-cmd:`~kubectl minio tenant create --volumes`, but instead of specifying the total number of volumes for all MinIO servers, associate ``--volumes-per-server`` volumes to each server.

   If the combined total number of volumes exceeds the number of unbound ``PVs`` available on the cluster, :mc:`kubectl minio tenant create` hangs and waits until the required ``PVs`` exist.

.. mc-cmd:: --disable-tls
   :optional:

   Disables automatic TLS certificate provisioning on the Tenant.

.. mc-cmd:: --enable-audit-logs
   :optional:

   .. include:: /includes/common/common-k8s-deprecation-audit-prometheus.rst
      :start-after: start-deprecate-audit-logs
      :end-before: end-deprecate-audit-logs

   Defaults to ``true``.

   Deploys the MinIO Tenant with a PostgreSQL Pod which, combined with an additional auto-deployed service, enables Audit Logging in the Tenant Console.

   You can control the configuration of the PostgreSQL pod using the following optional parameters:

   .. list-table::
      :header-rows: 1
      :widths: 40 60
      :width: 80%

      * - Option
        - Description

      * - ``--audit-logs-disk-space <int>``
        - Specify the amount of storage to provision for the PostgreSQL pod.
          The Operator provisions a PVC requesting the specified amount of storage in gigabytes.

          Defaults to ``5``

          If no Persistent Volume can meet the PVC request, the pod fails to deploy.

      * - ``--audit-logs-pg-image``
        - Specify the Docker image to use for deploying the PostgreSQL pod.

      * - ``--audit-logs-storage-class``
        - Specify the storage class to assign to the generated PVC for the PostgreSQL Pod.

   Specify ``false`` to deploy the Tenant without the PostgreSQL and Audit Logging Console feature.

.. mc-cmd:: --enable-prometheus
   :optional:

   .. include:: /includes/common/common-k8s-deprecation-audit-prometheus.rst
      :start-after: start-deprecate-prometheus
      :end-before: end-deprecate-prometheus

   Defaults to ``true``.

   Deploys the MinIO Tenant with a Prometheus pod which enables the :ref:`MinIO Console Metrics <minio-console-monitoring>` view.

   You can control the configuration of the Prometheus pod using the following optional parameters:

   .. list-table::
      :header-rows: 1
      :widths: 40 60
      :width: 80%

      * - Option
        - Description

      * - ``--prometheus-disk-space <int>``
        - Specify the amount of storage to provision for the Prometheus pod.
          The Operator provisions a PVC requesting the specified amount of storage in gigabytes.

          Defaults to ``5``.

      * - ``--prometheus-image``
        - Specify the Docker image to use for deploying the Prometheus pod.

      * - ``--prometheus-storage-class``
        - Specify the storage class to assign to the generated PVC for the Prometheus pod.


.. mc-cmd:: --expose-console-service
   :optional:

   Directs the Operator to configure the MinIO Tenant Console service with the :kube-docs:`LoadBalancer <concepts/services-networking/service/#loadbalancer>` networking type. 
   For Kubernetes clusters configured with a global load balancer, this option allows the Console to request an external IP address automatically.

.. mc-cmd:: --expose-minio-service
   :optional:

   Directs the Operator to configure the MinIO API service with the :kube-docs:`LoadBalancer <concepts/services-networking/service/#loadbalancer>` networking type. 
   For Kubernetes clusters configured with a global load balancer, this option allows the Console to request an external IP address automatically.

.. mc-cmd:: --image
   :optional:

   MinIO image to use for the tenant.
   Defaults to the latest minio release.

.. mc-cmd:: --image-pull-secret
   :optional:

   The image secret to use for pulling MinIO.

.. mc-cmd:: --kes-config
   :optional:

   The name of the Kubernetes Secret which contains the MinIO Key Encryption Service (KES) configuration. 
   Required for enabling Server Side Encryption of objects (SSE-S3).

   For more, see the `Github documentation <https://github.com/minio/operator/blob/master/examples/kes-secret.yaml>`__. 

.. mc-cmd:: --kes-image
   :optional:

   .. versionadded:: v5.0.11

   The KES image to use when deploying KES pods in the tenant.

   .. important::

      You cannot downgrade KES images after deployment.

.. mc-cmd:: --namespace
   :optional:

   The namespace in which to create the MinIO Tenant and its associated resources. 
      
   MinIO supports exactly *one* MinIO Tenant per namespace. 
   Create a unique namespace for each MinIO Tenant deployed into the cluster.

   Defaults to ``minio``.
   
.. mc-cmd:: --output
   :optional:

   Dry run the command and generate the ``YAML``. 
      
   :mc-cmd:`~kubectl minio tenant create --output` does **not** create the MinIO Tenant. 
   Use ``kubectl apply -f <FILE>`` to manually create the MinIO tenant using the generated file.

.. mc-cmd:: --pool
   :optional:

   Assign a name for the pool added for the tenant.

.. mc-cmd:: --storage-class
   :optional:

   The type of storage to use for this tenant.

   The name of the Kubernetes :kube-docs:`Storage Class <concepts/storage/storage-classes/>` to use when creating Persistent Volume Claims (``PVC``) for the MinIO Tenant. 
   The specified :mc-cmd:`~kubectl minio tenant create --storage-class` *must* match the ``storage-class`` of the Persistent Volumes (``PVs``) to which the ``PVCs`` should bind.

   MinIO strongly recommends creating a Storage Class that corresponds to locally-attached volumes on the host machines on which the Tenant deploys. 
   This ensures each pod can use locally-attached storage for maximum performance and throughput. 
   See the :ref:`Deploy MinIO Tenant <minio-k8s-deploy-minio-tenant>` tutorial for guidance on creating Storage Classes for supporting the MinIO Tenant.

   Defaults to ``default``.
