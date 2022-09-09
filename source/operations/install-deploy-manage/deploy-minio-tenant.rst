.. The following label handles links from content to distributed MinIO in K8s context
.. _deploy-minio-distributed:

.. Redirect all references to tenant topologies here

.. _minio-snsd:
.. _minio-snmd:
.. _minio-mnmd:

.. _minio-k8s-deploy-minio-tenant:

=====================
Deploy a MinIO Tenant
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

This procedure documents deploying a MinIO Tenant using the MinIO Operator Console.

.. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

The MinIO Operator supports only the Distributed (Multi-Node Multi-Drive) MinIO topology.
You can use basic Kubernetes YAML resource definitions to deploy Single-Node Single-Drive and Single-Node Multi-Drive topologies for local testing and evaluation as necessary.

The Operator Console provides a rich user interface for deploying and managing MinIO Tenants on Kubernetes infrastructure. 
Installing the MinIO :ref:`Kubernetes Operator <deploy-operator-kubernetes>` automatically installs and configures the Operator Console.

This documentation assumes familiarity with all referenced Kubernetes concepts, utilities, and procedures. 
While this documentation *may* provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

.. _deploy-minio-distributed-prereqs-storage:

Prerequisites
-------------

MinIO Kubernetes Operator and Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The procedures on this page *requires* a valid installation of the MinIO
Kubernetes Operator and assumes the local host has a matching installation of
the MinIO Kubernetes Operator. This procedure assumes the latest stable Operator
and Plugin version |operator-version-stable|.

See :ref:`deploy-operator-kubernetes` for complete documentation on deploying the MinIO Operator.

.. include:: /includes/k8s/install-minio-kubectl-plugin.rst

Kubernetes Version 1.19.0
~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with v4.0.0, the MinIO Operator requires Kubernetes 1.19.0 and later.
The Kubernetes infrastructure *and* the ``kubectl`` CLI tool must have the same
version of 1.19.0+.

This procedure assumes the host machine has ``kubectl`` installed and 
configured with access to the target Kubernetes cluster. The host machine 
*must* have access to a web browser application.

Locally Attached Drives
~~~~~~~~~~~~~~~~~~~~~~~

MinIO *strongly recommends* using locally attached drives on each node intended
to support the MinIO Tenant. MinIO’s strict read-after-write and
list-after-write consistency model requires local disk filesystems (xfs, ext4,
etc.). MinIO also shows best performance with locally-attached drives.

MinIO automatically generates :kube-docs:`Persistent Volume Claims (PVC)
<concepts/storage/persistent-volumes/#persistentvolumeclaims>` as part of
deploying a MinIO Tenant. The Operator generates one PVC for each volume in the
tenant *plus* two PVC to support collecting Tenant Metrics and logs. For
example, deploying a Tenant with 16 volumes requires 18 (16 + 2) ``PV``.

This procedure uses the MinIO :minio-git:`DirectPV <directpv>` driver to
automatically provision Persistent Volumes from locally attached drives to
support the generated PVC. See the :minio-git:`DirectPV Documentation
<directpv/blob/master/README.md>` for installation and configuration
instructions.

For clusters which cannot deploy MinIO DirectPV, 
:kube-docs:`Local Persistent Volumes <concepts/storage/volumes/#local>`.

The following tabs provide example YAML objects for a local persistent 
volume and a supporting 
:kube-docs:`StorageClass <concepts/storage/storage-classes/>`:

.. tab-set::
   
   .. tab-item:: Local Persistent Volume

      The following YAML describes a :kube-docs:`Local Persistent Volume
      <concepts/storage/volumes/#local>`:

      .. include:: /includes/k8s/deploy-tenant-requirements.rst
         :start-after: start-local-persistent-volume
         :end-before: end-local-persistent-volume

      Replace values in brackets ``<VALUE>`` with the appropriate 
      value for the local drive.

   .. tab-item:: Storage Class

      The following YAML describes a 
      :kube-docs:`StorageClass <concepts/storage/storage-classes/>` that 
      meets the requirements for a MinIO Tenant:

      .. include:: /includes/k8s/deploy-tenant-requirements.rst
         :start-after: start-storage-class
         :end-before: end-storage-class

      The storage class *must* have ``volumeBindingMode: WaitForFirstConsumer``.
      Ensure all Persistent Volumes provisioned to support the MinIO Tenant 
      use this storage class.

Procedure (MinIO Operator Console)
----------------------------------

To deploy a tenant from the MinIO Operator Console, complete the following steps in order:

:ref:`create-tenant-access-minio-operator-console`

:ref:`create-tenant-complete-tenant-setup`

:ref:`create-tenant-configure-section`

:ref:`create-tenant-images-section`

:ref:`create-tenant-pod-placement-section`

:ref:`create-tenant-identity-provider-section`

:ref:`create-tenant-security-section`

:ref:`create-tenant-encryption-section`

:ref:`create-tenant-deploy-view-tenant`

:ref:`create-tenant-connect-tenant`

:ref:`create-tenant-operator-forward-ports`

.. _create-tenant-access-minio-operator-console:

1) Access the MinIO Operator Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio proxy` command to temporarily forward traffic between the local host machine and the MinIO Operator Console:

.. code-block:: shell
   :class: copyable

   kubectl minio proxy

The command returns output similar to the following:

.. code-block:: shell

   Starting port forward of the Console UI.

   To connect open a browser and go to http://localhost:9090

   Current JWT to login: TOKEN

Open your browser to the specified URL and enter the JWT Token into the login page. 
You should see the :guilabel:`Tenants` page:

.. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

Click the :guilabel:`+ Create Tenant` to start creating a MinIO Tenant.

.. _create-tenant-complete-tenant-setup:

2) Complete the Tenant :guilabel:`Setup`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Setup` pane displays core configuration settings for the MinIO Tenant. 

Settings marked with an asterisk :guilabel:`*` are *required*:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Field
     - Description

   * - :guilabel:`Name`
     - The name of the MinIO Tenant

   * - :guilabel:`Namespace`
     - The Kubernetes Namespace in which to deploy the tenant. 
       You can create the namespace by selecting the plus :guilabel:`+` icon if it does not exist.

       The Operator supports at most *one* MinIO Tenant per namespace.

   * - :guilabel:`Storage Class`
     - Specify the Kubernetes Storage Class the Operator uses when generating Persistent Volume Claims for the Tenant. 

       This procedure assumes using the :minio-git:`DirectPV <directpv>` storage class ``directpv-min-io``. 
       See the :minio-git:`DirectPV Documentation <directpv/blob/master/README.md>` for installation and configuration instructions.

   * - :guilabel:`Number of Servers`
     - The total number of MinIO server pods to deploy in the Tenant.
       
       The Operator by default uses pod anti-affinity, such that the Kubernetes cluster *must* have at least one worker node per MinIO server pod. 
       Use the :guilabel:`Pod Placement` pane to modify the pod scheduling settings for the Tenant.

   * - :guilabel:`Number of Drives per Server`
     - The number of storage volumes (Persistent Volume Claims) the Operator requests per Server. 

       The Operator displays the :guilabel:`Total Volumes` under the :guilabel:`Resource Allocation` section. 
       The Operator generates an equal number of PVC *plus two* for supporting Tenant services (Metrics and Log Search).
       
       The specified :guilabel:`Storage Class` *must* correspond to a set of Persistent Volumes sufficient in number to match each generated PVC.

   * - :guilabel:`Total Size`
     - The total raw storage size for the Tenant. 
       Specify both the total storage size *and* the :guilabel:`Unit` of that storage. 
       All storage units are in SI values, e.g. :math:`Gi = GiB = 1024^3` bytes.

       The Operator displays the :guilabel:`Drive Capacity` under the:guilabel:`Resource Allocation` section. 
       The Operator sets this value as the requested storage capacity in each generated PVC.

       The specified :guilabel:`Storage Class` *must* correspond to a set of Persistent Volumes sufficient in capacity to match each generated PVC.

   * - :guilabel:`Memory per Node [Gi]`
     - Specify the total amount of memory (RAM) to allocate per MinIO server pod. 
       See :ref:`minio-k8s-production-considerations-memory` for guidance on setting this value.

       The Kubernetes cluster *must* have worker nodes with sufficient free RAM to match the pod request.

   * - :guilabel:`Erasure Code Parity`
     - The Erasure Code Parity to set for the deployment.

       The Operator displays the selected parity and its effect on the deployment under the :guilabel:`Erasure Code Configuration` section.
       Erasure Code parity defines the overall resiliency and availability of data on the cluster. 
       Higher parity values increase tolerance to drive or node failure at the cost of total storage. 
       See :ref:`minio-erasure-coding` for more complete documentation.
       
Select :guilabel:`Create` to create the Tenant using the current configuration.
While all subsequent sections are *optional*, MinIO recommends reviewing them prior to deploying the Tenant.

.. _create-tenant-configure-section:

3) The :guilabel:`Configure` Section
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Configure` section displays optional configuration settings for the MinIO Tenant and its supporting services.

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Field
     - Description

   * - :guilabel:`Expose Services`
     - The MinIO Operator by default directs the MinIO Tenant services to request an externally accessible IP address from the Kubernetes cluster Load Balancer if one is available.

       Most public cloud Kubernetes infrastructures include a global Load Balancer which meets this requirements. 
       Other Kubernetes distributions *may* include a load balancer that can respond to these requests.

       You can direct the Tenant to not make this request by toggling the option to :guilabel:`Off` for the MinIO Service and Console Service.

   * - :guilabel:`Override Tenant Defaults`
     - The MinIO Operator sets the Kubernetes Security Context for pods to a default of ``1000`` for User, Group, and FsGroup. 
       MinIO runs the pod using the ``root`` user.

       You can modify the Security Context to direct MinIO to run using a different User, Group, or FsGroup ID. 
       You can also direct MinIO to not run as the Root user.

   * - :guilabel:`Override Log Search Defaults`
     - The MinIO Operator deploys a Log Search service (SQL Database and Log Search API) to support Audit Log search in the MinIO Tenant Console.

       You can modify the Security Context to run the associated pod commands using a different User, Group, or FsGroup ID. 
       You can also direct the pod to not run commands as the Root user.

       You can also modify the storage class and requested capacity associated to the PVC generated to support the Log Search service.

   * - :guilabel:`Override Prometheus Search Defaults`
     - The MinIO Operator deploys a Prometheus service to support detailed metrics in the MinIO Tenant Console.

       You can modify the Security Context to run the associated pod commands using a different User, Group, or FsGroup ID. 
       You can also direct the pod to not run commands as the Root user.

       You can also modify the storage class and requested capacity associated to the PVC generated to support the Prometheus service.

.. _create-tenant-images-section:

4) The :guilabel:`Images` Section
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Images` section displays container image settings used by the MinIO Tenant.

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Field
     - Description

   * - :guilabel:`MinIO's Image`
     - The container image to use for the MinIO Server. 
       See the `MinIO Quay <https://quay.io/repository/minio/minio>`__ or the `MinIO DockerHub <https://hub.docker.com/r/minio/minio/tags>`__ repositories for a list of valid tags.

   * - :guilabel:`Log Search API's Image`
     - The container image to use for MinIO Log Search API.

   * - :guilabel:`KES Image`
     - The container image to use for MinIO :minio-git:`KES <kes>`.

   * - | :guilabel:`Log Search Postgres Image`
       | :guilabel:`Log Search Postgres Init Image`
     - The container images to use for starting the PostgreSQL service supporting the Log Search API

   * - | :guilabel:`Prometheus Image`
       | :guilabel:`Prometheus Sidecar Image`
       | :guilabel:`Prometheus Init Image`

     - The container images to use for starting the Prometheus service supporting the Log Search API.

.. _create-tenant-pod-placement-section:

5) The :guilabel:`Pod Placement` Section
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Pod Placement` section displays pod scheduler settings for the MinIO Tenant.

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Field
     - Description

   * - :guilabel:`None`
     - Disables pod scheduling constraints for the tenant. 
       This allows Kubernetes to schedule multiple Tenant pods onto the same node.

       This may decrease resiliency, as a single Kubernetes worker can host multiple MinIO pods. 
       If that worker is down or lost, objects may also be unavailable or lost.

       Consider using this setting only in early development or sandbox environments with a limited number of worker nodes.

   * - :guilabel:`Default (Pod Anti-Affinity)`
     - Directs the Operator to set anti-affinity settings such that no Kubernetes worker can host more than one MinIO server pod for this Tenant.

   * - :guilabel:`Node Selector`
     - Directs the operator to set a Node Selector such that pods only deploy onto Kubernetes workers whose labels match the selector.

.. _create-tenant-identity-provider-section:

6) The :guilabel:`Identity Provider` Section
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Identity Provider` section displays the :ref:`Identity Provider <minio-authentication-and-identity-management>` settings for the MinIO Tenant. 
This includes configuring an external IDP such as :ref:`OpenID <minio-external-identity-management-openid>` or :ref:`Active Directory / LDAP <minio-external-identity-management-ad-ldap>`.

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Field
     - Description

   * - :guilabel:`Built-In`
     - Configure additional internal MinIO users for the Operator to create as part of deploying the Tenant.

   * - :guilabel:`OpenID`
     - Configure an OpenID Connect-compatible service as an external Identity Provider (e.g. Keycloak, Okta, Google, Facebook, Dex) to manage MinIO users. 

   * - :guilabel:`Active Directory`
     - Configure an Active Directory or OpenLDAP service as the external Identity Provider to manage MinIO users.

.. _create-tenant-security-section:

.. _minio-k8s-deploy-minio-tenant-security:

7) The :guilabel:`Security` Section
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Security` section displays TLS certificate settings for the MinIO Tenant.

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Field
     - Description

   * - :guilabel:`Enable TLS`
     - Enable or disable TLS for the MinIO Tenant. 

   * - :guilabel:`Enable AutoCert`
     - Directs the Operator to generate Certificate Signing Requests for submission to the Kubernetes TLS API.

       The MinIO Tenant uses the generated certificates for enabling and establishing TLS connections.

   * - :guilabel:`Custom Certificates`
     - Specify one or more custom TLS certificates for use by the MinIO Tenant.
       
       MinIO supports Server Name Indication (SNI) such that the Tenant can select the appropriate TLS certificate based on the request hostname and the certificate Subject Alternative Name.

       MinIO also supports specifying Certificate Authority certificates for validating client certificates minted by that CA.

.. _create-tenant-encryption-section:

8) The :guilabel:`Encryption` Section
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Encryption` section displays the :ref:`Server-Side Encryption (SSE) <minio-sse>` settings for the MinIO Tenant. 

Enabling SSE also creates :minio-git:`MinIO Key Encryption Service <kes>` pods in the Tenant to facilitate SSE operations.

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Field
     - Description
   
   * - :guilabel:`Vault`
     - Configure `Hashicorp Vault <https://www.vaultproject.io/>`__ as the external KMS for storing root encryption keys. 
       See :ref:`minio-sse-vault` for guidance on the displayed fields.

   * - :guilabel:`AWS`
     - Configure `AWS Secrets Manager <https://aws.amazon.com/secrets-manager/>`__ as the external KMS for storing root encryption keys. 
       See :ref:`minio-sse-aws` for guidance on the displayed fields.

   * - :guilabel:`GCP`
     - Configure `Google Cloud Platform Secret Manager <https://cloud.google.com/secret-manager/>`__ as the external KMS for storing root encryption keys. 
       See :ref:`minio-sse-gcp` for guidance on the displayed fields.

   * - :guilabel:`Azure`
     - Configure `Azure Key Vault <https://azure.microsoft.com/en-us/services/key-vault/#product-overview>`__  as the external KMS for storing root encryption keys. 
       See :ref:`minio-sse-azure` for guidance on the displayed fields.       

.. _create-tenant-deploy-view-tenant:

9) Deploy and View the Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Select :guilabel:`Create` at any time to begin the deployment process. 
The MinIO Operator displays the root user credentials *once* as part of deploying the Tenant. 
Copy these credentials to a secure location.

You can monitor the Tenant creation process from the :guilabel:`Tenants` view. 
The :guilabel:`State` column updates throughout the deployment process.

Tenant deployment can take several minutes to complete. 
Once the :guilabel:`State` reads as :guilabel:`Initialized`, click the Tenant to view its details.

.. image:: /images/k8s/operator-tenant-view.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Tenant View

Each tab provides additional details or configuration options for the MinIO Tenant. 

- :guilabel:`METRICS` - Displays metrics collected from the MinIO Tenant.
- :guilabel:`SECURITY` - Provides TLS-related configuration options.
- :guilabel:`POOLS` - Supports expanding the tenant by adding more Server Pools.
- :guilabel:`LICENSE` - Enter your `SUBNET <https://min.io/pricing?ref=docs>`__ license.

.. _create-tenant-connect-tenant:

10) Connect to the Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Operator creates services for the MinIO Tenant. 
Use the ``kubectl get svc -n NAMESPACE`` command to review the deployed services:

.. code-block:: shell
   :class: copyable

   kubectl get svc -n minio-tenant-1

.. code-block:: shell

   NAME                               TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
   minio                              LoadBalancer   10.97.114.60     <pending>     443:30979/TCP    2d3h
   minio-tenant-1-console             LoadBalancer   10.106.103.247   <pending>     9443:32095/TCP   2d3h
   minio-tenant-1-hl                  ClusterIP      None             <none>        9000/TCP         2d3h
   minio-tenant-1-log-hl-svc          ClusterIP      None             <none>        5432/TCP         2d3h
   minio-tenant-1-log-search-api      ClusterIP      10.103.5.235     <none>        8080/TCP         2d3h
   minio-tenant-1-prometheus-hl-svc   ClusterIP      None             <none>        9090/TCP         7h39m

- The ``minio`` service corresponds to the MinIO Tenant service. 
  Applications should use this service for performing operations against the MinIO Tenant.
 
- The ``*-console`` service corresponds to the :minio-git:`MinIO Console <console>`. 
  Administrators should use this service for accessing the MinIO Console and performing administrative operations on the MinIO Tenant.

The remaining services support Tenant operations and are not intended for consumption by users or administrators.
 
By default each service is visible only within the Kubernetes cluster. 
Applications deployed inside the cluster can access the services using the ``CLUSTER-IP``. 

Applications external to the Kubernetes cluster can access the services using the ``EXTERNAL-IP``. 
This value is only populated for Kubernetes clusters configured for Ingress or a similar network access service. 
Kubernetes provides multiple options for configuring external access to services. 
See the Kubernetes documentation on 
:kube-docs:`Publishing Services (ServiceTypes) <concepts/services-networking/service/#publishing-services-service-types>` 
and :kube-docs:`Ingress <concepts/services-networking/ingress/>` 
for more complete information on configuring external access to services.

.. _create-tenant-operator-forward-ports:

11) Forward Ports
~~~~~~~~~~~~~~~~~

You can temporarily expose each service using the ``kubectl port-forward`` utility. 
Run the following examples to forward traffic from the local host running ``kubectl`` to the services running inside the Kubernetes cluster.

.. tab-set::

   .. tab-item:: MinIO Tenant

      .. code-block:: shell
         :class: copyable

         kubectl port-forward service/minio 443:443

   .. tab-item:: MinIO Console
   
      .. code-block:: shell
         :class: copyable

         kubectl port-forward service/minio-tenant-1-console 9443:9443

.. _minio-k8s-deploy-minio-tenant-commandline:

Procedure (Command Line)
------------------------

The :mc:`kubectl minio tenant create` command supports creating a MinIO Tenant in your Kubernetes cluster.
The command *requires* that the cluster have a functional MinIO Operator installation.

To deploy a tenant from the command line, complete the following steps:

:ref:`create-tenant-cli-determine-settings-required-options`

:ref:`create-tenant-cli-determine-additional-options`

:ref:`create-tenant-cli-enter-command`

:ref:`create-tenant-cli-record-access-info`

:ref:`create-tenant-cli-access-tenant-console`

:ref:`create-tenant-cli-forward-ports`

.. _create-tenant-cli-determine-settings-required-options:

1) Determine Values for Required Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :mc:`kubectl minio tenant create` command requires several configuration settings.
Determine the values for all required settings.

.. tab-set::
   
   .. tab-item:: Required Settings

      The command requires values for each of the items in this table.

      .. list-table::
         :header-rows: 1
         :widths: 25 75
         :width: 100%

         * - Setting
           - Description

         * - :mc:`~kubectl minio tenant create TENANT_NAME`
           - The name to use for the new tenant.

         * - :mc:`~kubectl minio tenant create --capacity`
           - The total raw storage size for the Tenant across all volumes. 
             Specify both the total storage size *and* the :guilabel:`Unit` of that storage. 
             All storage units are in SI values, e.g. :math:`Gi = GiB = 1024^3` bytes.
     
             For example, 16 Ti for 16 Tebibytes.

         * - :mc:`~kubectl minio tenant create --servers`
           - The total number of MinIO server pods to deploy in the Tenant.
    
             The Operator by default uses pod anti-affinity, such that the Kubernetes cluster *must* have at least one worker node per MinIO server pod.

         * - :mc:`~kubectl minio tenant create --volumes`
           - The total number of storage volumes (Persistent Volume Claims).
             The Operator generates an equal number of PVC *plus one* for supporting logging. 
       
             The total number of persistent volume claims (``PVC``) per server is determined by dividing the number of volumes by the number of servers.
             The storage available for each ``PVC`` is determined by dividing the capacity by the number of volumes. 

             The generated claims have pod selectors so that claims are only made for volumes attached to node running the pod.

             If the number of volumes exceeds the numnber of persistent volumes available on the cluster, ``MinIO`` hangs until the number of persistent volumes are available.
  
         * - :mc:`~kubectl minio tenant create --namespace`
           - Each MinIO tenant requires its own ``namespace``.

             Specify a namespace with the :mc:`~kubectl minio tenant create --namespace` flag.
             If not specified, the MinIO Operator to uses ``minio``.

             The namespace must already exist in the Kubernetes cluster.
             Run ``kubectl create ns <new_namespace>`` to add one.

         * - :mc:`~kubectl minio tenant create --storage-class`
           - Specify the storage class to use.

             New MinIO tenants use the ``default`` storage class.
             To specify a different storage class, add the :mc:`~kubectl minio tenant create --storage-class` flag.

             The specified :mc-cmd:`~kubectl minio tenant create --storage-class` *must* match the ``storage-class`` of the Persistent Volumes (``PVs``) to which the ``PVCs`` should bind.

             MinIO strongly recommends creating a Storage Class that corresponds to locally-attached volumes on the host machines on which the Tenant deploys. 
             This ensures each pod can use locally-attached storage for maximum performance and throughput. 

   .. tab-item:: Example

      For example, the following command creates a new tenant with the following settings:

      Name
        ``miniotenant``
      
      Capacity
        16 Tebibytes
      
      Servers
        4

      Volumes
        16

      Namespace
        ``minio``

      Storage Class
        ``warm``
  
      .. code-block:: shell
         :class: copyable

         kubectl minio tenant create miniotenant          \
                                     --capacity 16Ti      \
                                     --servers 4          \
                                     --volumes 16         \
                                     --namespace minio    \
                                     --storage-class warm


.. _create-tenant-cli-determine-additional-options:

2) Determine Values for Optional Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can further customize your tenant by including any or all of the following *optional* flags when running the :mc:`kubectl minio tenant create` command:

.. list-table:: 
   :header-rows: 1
   :widths: 25 75
   :width: 100%

   * - Setting
     - Description

   * - :mc:`~kubectl minio tenant create --image`
     - Customize the ``minio`` image to use.
  
       By default, the Operator uses the release image available at the time of the Operator's release.
       To specify a different MinIO version for the tenant, such as the latest available, use the :mc:`~kubectl minio tenant create --image` flag.

       See the `MinIO Quay <https://quay.io/repository/minio/minio>`__ or the `MinIO DockerHub <https://hub.docker.com/r/minio/minio/tags>`__ repositories for a list of valid tags.

   * - :mc:`~kubectl minio tenant create --image-pull-secret`
     - If using a custom container registry, specify the secret to use when pulling the ``minio`` image.

       Use :mc:`~kubectl minio tenant create --image-pull-secret` to specify the secret.

   * - :mc:`~kubectl minio tenant create --kes-config`
     - Configure a :minio-git:`Key Encrption Service (KES) <kes>`

       Use the :mc:`~kubectl minio tenant create --kes-config` flag to specify the name of the secret to use for KES Key Management Service (KMS) setup.

       Enabling Server Side Encryption (SSE) also deploys a MinIO :minio-git:`KES <kes>` service in the Tenant to faciliate SSE operations.
  
       For more, see the `Github documentation <https://github.com/minio/kes/wiki>`__.

.. note:: Generate a YAML File for Further Customizations

   The MinIO Operator installs a `Custom Resource Definition (CRD) <https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/>`__ to describe tenants.
   Advanced users can generate a YAML file from the command line and customize the tenant based on the CRD.

   Do a dry run of a tenant creation process to generate a YAML file using the :mc:`~kubectl minio tenant create --output` flag.

   When using this flag, the operator does **not** create the tenant.
   Modify the generated YAML file as desired, then use ``kubectl apply -f <FILE>`` to manually create the MinIO tenant using the file.

.. _create-tenant-cli-enter-command:

3) Run the Command with Required and Optional Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

At the command line, enter the full command with all *Required* and any *Optional* flags.

Consider a tenant we want to create:

Tenant Name
  ``minio1``

Capacity
  16 Tebibytes

Servers
  4

Volumes
  16 (four per node)

Namespace
  ``miniotenantspace``

MinIO Image
  Latest version, |minio-latest|

Key ecnryption file
  ``minio-secret``

Storage class
  ``warm``

.. code-block:: shell
   :substitutions:

   kubectl minio tenant create                                \
                        minio1                                \
                        --capacity 16Ti                       \
                        --servers 4                           \
                        --volumes 16                          \
                        --namespace miniotenantspace          \
                        --image |minio-latest|  \
                        --kes-config minio-kes-secret         \
                        --storage-class warm

.. _create-tenant-cli-record-access-info:

4) Record the Access Credentials
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When generating the tenant, the MinIO Operator displays the access credentials to use for the tenant.

.. important::
   
   This is the only time the credentials display.
   Copy the credentials to a secure location.
   MinIO does not show these credentials again.

In addition to access credentials, the output shows the service name and service ports to use for accessing the tenant.

.. _create-tenant-cli-access-tenant-console:

5) Access the Tenant's MinIO Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To access the :ref:`MinIO Console <minio-console>` for the tenant, forward the tenant's port.

- If necessary, run ``kubectl get svc -n <namespace>`` to retrieve the tenant's port number.
- Run the following to forward the tenant's port and access it from a browser:

  .. code-block:: shell
     :class: copyable

     kubectl port-forward svc/<tenant-name>-console -n <tenant-namespace> <localport>:<tenantport>

  - Replace ``<tenant-name>`` with the name of your tenant.
  - Replace ``<tenant-namespace>`` with the namespace the tenant exists in.
  - Replace ``<localport>`` with the port number to use on your local machine to access the tenant's MinIO Console.
  - Replace ``<tenantport>`` with the port number the MinIO Operator assigned to the tenant.

- Go to ``https://127.0.0.1:<localport>`` to Access the tenant's MinIO Console.

  Replace ``<localport>`` with the port number you used when forwarding the tenant's port.

- Login with the username and password shown in the tenant creation output and recorded in step 4 above.

.. _create-tenant-cli-forward-ports:

6) Forward Ports
~~~~~~~~~~~~~~~~

You can temporarily expose each service using the ``kubectl port-forward`` utility. 
Run the following examples to forward traffic from the local host running ``kubectl`` to the services running inside the Kubernetes cluster.

.. tab-set::

   .. tab-item:: MinIO Tenant

      .. code-block:: shell
         :class: copyable

         kubectl port-forward service/minio 443:443

   .. tab-item:: MinIO Console
   
      .. code-block:: shell
         :class: copyable

         kubectl port-forward service/minio-tenant-1-console 9443:9443
