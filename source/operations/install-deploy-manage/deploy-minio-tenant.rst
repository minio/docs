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

.. cond:: openshift

   This procedure documents deploying a MinIO Tenant through OpenShift 4.7+ using the OpenShift Web Console and the MinIO Kubernetes Operator.

.. cond:: k8s and not openshift

   This procedure documents deploying a MinIO Tenant onto a stock Kubernetes cluster using the MinIO Operator Console.

.. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console


The MinIO Operator Console is designed with deploying multi-node distributed MinIO Deployments.

Deploying Single-Node topologies requires additional configurations not covered in this documentation.
You can alternatively use a simple Kubernetes YAML object to describe a Single-Node topology for local testing and evaluation as necessary.

MinIO does not recommend nor support single-node deployment topologies for production environments.

The Operator Console provides a rich user interface for deploying and managing MinIO Tenants on Kubernetes infrastructure. 
Installing the MinIO :ref:`Kubernetes Operator <deploy-operator-kubernetes>` automatically installs and configures the Operator Console.

This documentation assumes familiarity with all referenced Kubernetes concepts, utilities, and procedures. 
While this documentation *may* provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.






Prerequisites
-------------

MinIO Kubernetes Operator
~~~~~~~~~~~~~~~~~~~~~~~~~

The procedures on this page *requires* a valid installation of the MinIO
Kubernetes Operator and assumes the local host has a matching installation of
the MinIO Kubernetes Operator. This procedure assumes the latest stable Operator, version |operator-version-stable|.

See :ref:`deploy-operator-kubernetes` for complete documentation on deploying the MinIO Operator.

.. cond:: k8s and not (openshift or eks or gke or aks)

   Kubernetes Version 1.21.0
   ~~~~~~~~~~~~~~~~~~~~~~~~~

   MinIO Operator requires Kubernetes 1.21.0 and later.
   The Kubernetes infrastructure *and* the ``kubectl`` CLI tool must have the same version of 1.21.0+.

   This procedure assumes the host machine has ``kubectl`` installed and configured with access to the target Kubernetes cluster. 
   The host machine *must* have access to a web browser application.

.. cond:: openshift

   OpenShift 4.7+ and ``oc`` CLI Tool
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   This procedure assumes installation of the MinIO Operator using the OpenShift 4.7+ and the OpenShift OperatorHub.

   This procedure assumes your local machine has the OpenShift ``oc`` CLI tool installed and configured for access to the OpenShift Cluster.
   :openshift-docs:`Download and Install <cli_reference/openshift_cli/getting-started-cli.html>` the OpenShift :abbr:`CLI (command-line interface)` ``oc`` for use in this procedure.

   See :ref:`deploy-operator-openshift` for more complete instructions.

.. cond:: openshift

   Check Security Context Constraints
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   The MinIO Operator deploys pods using the following default :kube-docs:`Security Context <tasks/configure-pod-container/security-context/>` per pod:

   .. code-block:: yaml
      :class: copyable

      securityContext:
        runAsUser: 1000
        runAsGroup: 1000
        runAsNonRoot: true
        fsGroup: 1000

   Certain OpenShift :openshift-docs:`Security Context Constraints </authentication/managing-security-context-constraints.html>` limit the allowed UID or GID for a pod such that MinIO cannot deploy the Tenant successfully. 
   Ensure that the Project in which the Operator deploys the Tenant has sufficient SCC settings that allow the default pod security context. 
   You can alternatively modify the tenant security context settings during deployment.

   The following command returns the optimal value for the securityContext: 

   .. code-block:: shell
      :class: copyable

      oc get namespace <namespace> \
      -o=jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.supplemental-groups}{"\n"}'

   The command returns output similar to the following:
   
   .. code-block:: shell

      1056560000/10000

   Take note of this value before the slash for use in this procedure.

.. cond:: gke

   GKE Cluster with Compute Engine Nodes
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   This procedure assumes an existing :abbr:`GKE (Google Kubernetes Engine)` cluster with a MinIO Operator installation and *at least* four Compute Engine nodes.
   The Compute Engine nodes should have matching machine types and configurations to ensure predictable performance with MinIO.

   MinIO provides :ref:`hardware guidelines <deploy-minio-distributed-recommendations>` for selecting the appropriate Compute Engine instance class and size.
   MinIO strongly recommends selecting instances with support for local SSDs and *at least* 25Gbps egress bandwidth as a baseline for performance.

   For more complete information on the available Compute Engine and Persistent Storage resources, see :gcp-docs:`Machine families resources and comparison guide <general-purpose-machines>` and :gcp-docs:`Persistent disks <disks>`.

.. cond:: eks

   EKS Cluster with EBS-Optimized EC2 Nodes
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   This procedure assumes an existing :abbr:`EKS (Elastic Kubernetes Service)` cluster with *at least* four EC2 nodes.
   The EC2 nodes should have matching machine types and configurations to ensure predictable performance with MinIO.

   MinIO provides :ref:`hardware guidelines <deploy-minio-distributed-recommendations>` for selecting the appropriate EC2 instance class and size.
   MinIO strongly recommends selecting EBS-optimized instances with *at least* 25Gbps Network bandwidth as a baseline for performance.

   For more complete information on the available EC2 and EBS resources, see `EC2 Instance Types <https://aws.amazon.com/ec2/instance-types/>`__ and `EBS Volume Types <https://aws.amazon.com/ebs/volume-types/>`__.
   |subnet| customers should reach out to MinIO engineering as part of architecture planning for assistance in selecting the optimal instance and volume types for the target workload and performance goals.

.. cond:: aks

   AKS Cluster with Azure Virtual Machines
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   This procedure assumes an existing :abbr:`AKS (Azure Kubernetes Service)` cluster with *at least* four Azure virtual machines (VM).
   The Azure VMs should have matching machine types and configurations to ensure predictable performance with MinIO.

   MinIO provides :ref:`hardware guidelines <deploy-minio-distributed-recommendations>` for selecting the appropriate EC2 instance class and size.
   MinIO strongly recommends selecting VM instances with support for Premium SSDs and *at least* 25Gbps Network bandwidth as a baseline for performance.

   For more complete information on Azure Virtual Machine types and Storage resources, see :azure-docs:`Sizes for virtual machines in Azure <virtual-machines/sizes>` and :azure-docs:`Azure managed disk types <virtual-machines/disks-types>`

.. _deploy-minio-tenant-pv:

Persistent Volumes
~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-admonitions.rst
   :start-after: start-exclusive-drive-access
   :end-before: end-exclusive-drive-access

.. cond:: not eks

   MinIO can use any Kubernetes :kube-docs:`Persistent Volume (PV) <concepts/storage/persistent-volumes>` that supports the :kube-docs:`ReadWriteOnce <concepts/storage/persistent-volumes/#access-modes>` access mode.
   MinIO's consistency guarantees require the exclusive storage access that ``ReadWriteOnce`` provides.
   Additionally, MinIO recommends setting a reclaim policy of ``Retain`` for the PVC :kube-docs:`StorageClass <concepts/storage/storage-classes>`.
   Where possible, configure the Storage Class, CSI, or other provisioner underlying the PV to format volumes as XFS to ensure best performance.

   For Kubernetes clusters where nodes have Direct Attached Storage, MinIO strongly recommends using the `DirectPV CSI driver <https://min.io/directpv?ref=docs>`__. 
   DirectPV provides a distributed persistent volume manager that can discover, format, mount, schedule, and monitor drives across Kubernetes nodes.
   DirectPV addresses the limitations of manually provisioning and monitoring :kube-docs:`local persistent volumes <concepts/storage/volumes/#local>`.

.. cond:: eks

   MinIO Tenants on EKS must use the :github:`EBS CSI Driver <kubernetes-sigs/aws-ebs-csi-driver>` to provision the necessary underlying persistent volumes.
   MinIO strongly recommends using SSD-backed EBS volumes for best performance.
   MinIO strongly recommends deploying EBS-based PVs with the XFS filesystem.
   Create a StorageClass for the MinIO EBS PVs and set the ``csi.storage.k8s.io/fstype`` `parameter <https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/parameters.md>`__ to ``xfs``  .
   For more information on EBS resources, see `EBS Volume Types <https://aws.amazon.com/ebs/volume-types/>`__.
   For more information on StorageClass Parameters, see `StorageClass Parameters <https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/parameters.md>`__.

.. cond:: gke

   MinIO Tenants on GKE should use the :gke-docs:`Compute Engine Persistent Disk CSI Driver <how-to/persistent-volumes/gce-pd-csi-driver>` to provision the necessary underlying persistent volumes.
   MinIO strongly recommends SSD-backed disk types for best performance.
   For more information on GKE disk types, see :gcp-docs:`Persistent Disks <disks>`.

.. cond:: aks

   MinIO Tenants on AKS should use the :azure-docs:`Azure Disks CSI driver <azure-disk-csi>` to provision the necessary underlying persistent volumes.
   MinIO strongly recommends SSD-backed disk types for best performance.
   For more information on AKS disk types, see :azure-docs:`Azure disk types <virtual-machines/disk-types>`.

Deploy a Tenant using Kustomize
-------------------------------

To deploy a tenant using Kustomize...


Deploy a Tenant using the MinIO Operator Console
------------------------------------------------

To deploy a tenant from the MinIO Operator Console, complete the following steps in order:

:ref:`create-tenant-access-minio-operator-console`

:ref:`create-tenant-complete-tenant-setup`

:ref:`create-tenant-configure-section`

:ref:`create-tenant-images-section`

:ref:`create-tenant-pod-placement-section`

:ref:`create-tenant-identity-provider-section`

:ref:`create-tenant-security-section`

:ref:`create-tenant-encryption-section`

:ref:`minio-tenant-audit-logging-settings`

:ref:`minio-tenant-monitoring-settings`

:ref:`create-tenant-deploy-view-tenant`

:ref:`create-tenant-connect-tenant`

.. _create-tenant-access-minio-operator-console:

1) Access the MinIO Operator Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-k8s-connect-operator-console.rst

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
     - .. cond:: not eks
     
          Specify the Kubernetes Storage Class the Operator uses when generating Persistent Volume Claims for the Tenant.

          Ensure the specified storage class has sufficient available Persistent Volume resources to match each generated Persistent Volume Claim.

       .. cond:: eks

          Specify the EBS volume type to use for this tenant.
          The following list is populated based on the AWS EBS CSI driver list of supported :github:`EBS volume types <kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/parameters.md>`:

          - ``gp3`` (General Purpose SSD)
          - ``gp2`` (General Purpose SSD)
          - ``io2`` (Provisioned IOPS SSD)
          - ``io1`` (Provisioned IOPS SSD)
          - ``st1`` (Throughput Optimized HDD)
          - ``sc1`` (Cold Storage HDD)

       .. cond:: gke

          Specify the GKE persistent disk type to use for this tenant.
          The :gke-docs:`GKE CSI Driver <how-to/persistent-volumes/gce-pd-csi-driver>` provides the following storage classes by default:

          - ``standard-rwo`` (Balanced Persistent SSD)
          - ``premium-rwo`` (Performance Persistent SSD)

          You can create additional StorageClasses to represent other supported persistent disk types.
          See :gke-docs:`Create a Storage Class <how-to/persistent-volumes/gce-pd-csi-driver#create_a_storageclass>` for more information.

       .. cond:: aks

          Specify the AKS persistent disk type to use for this tenant.
          The :aks-docs:`AKS CSI Driver <azure-disk-csi>` provides the following storage classes by default:

          - ``managed-csi`` (Standard SSD)
          - ``managed-csi-premium`` (Premium SSD)

          You can create additional Storage Classes to represent other supported persistent disk types.
          See :aks-docs:`Create a custom storage class <https://learn.microsoft.com/en-us/azure/aks/azure-disk-csi#create-a-custom-storage-class>` for more information.

   * - :guilabel:`Number of Servers`
     - The total number of MinIO server pods to deploy in the Tenant.
       The Operator enforces a minimum of four server pods per tenant.
       
       The Operator by default uses pod anti-affinity, such that the Kubernetes cluster *must* have at least one worker node per MinIO server pod. 
       Use the :guilabel:`Pod Placement` pane to modify the pod scheduling settings for the Tenant.

   * - :guilabel:`Number of Drives per Server`
     - The number of storage volumes (Persistent Volume Claims) the Operator requests per Server. 

       The Operator displays the :guilabel:`Total Volumes` under the :guilabel:`Resource Allocation` section. 
       The Operator generates an equal number of PVC *plus two* for supporting Tenant services (Metrics and Log Search).

       .. cond:: not eks
       
          The specified :guilabel:`Storage Class` *must* correspond to a set of Persistent Volumes sufficient in number to match each generated PVC.

       .. cond:: eks

          For deployments using the EBS CSI driver, the Operator provisions Persistent Volume Claims which result in the creation of EBS volumes of the specified :guilabel:`Storage Class` equal to ``Number of Drives per Server X Number of Servers``.

       .. cond:: gke

          For deployments using the GKE CSI driver, the Operator provisions Persistent Volume Claims which result in the creation of GCP Disks of the specified :guilabel:`Storage Class` equal to ``Number of Drives per Server X Number of Servers``.

       .. cond:: aks

          For deployments using the AKS CSI Driver, the Operator provisions Persistent Volume Claims which result in the creation of Azure Disks of the specified :guilabel:`Storage Class` equal to ``Number of Drives per Server X Number of Servers``.

   * - :guilabel:`Total Size`
     - The total raw storage size for the Tenant. 
       Specify both the total storage size *and* the :guilabel:`Unit` of that storage. 
       All storage units are in SI values, e.g. :math:`Gi = GiB = 1024^3` bytes.

       The Operator displays the :guilabel:`Drive Capacity` under the:guilabel:`Resource Allocation` section. 
       The Operator sets this value as the requested storage capacity in each generated PVC.

       The specified :guilabel:`Storage Class` *must* correspond to a set of Persistent Volumes sufficient in capacity to match each generated PVC.

   * - :guilabel:`Memory per Node [Gi]`
     - Specify the total amount of memory (RAM) to allocate per MinIO server pod. 
       See :ref:`minio-hardware-checklist-memory` for guidance on setting this value.
       MinIO **requires** a minimum of 2GiB of memory per worker.

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

   * - :guilabel:`Expose MinIO Service`
     - The MinIO Operator by default directs the MinIO Tenant services to request an externally accessible IP address from the Kubernetes cluster Load Balancer if one is available to access the tenant.

       .. cond:: eks

          If your EKS cluster includes the :aws-docs:`AWS Load Balancer Controller add-on <eks/latest/userguide/aws-load-balancer-controller.html>`, enabling this setting directs the load balancer to assign an address to the Tenant services.

          Other load balancers *may* function similarly depending on their configuration.

       .. cond:: not eks

       Your Kubernetes distributions *may* include a load balancer that can respond to these requests.
       Installation and configuration of load balancers is out of the scope of this documentation.

   * - :guilabel:`Expose Console Service`
     - Select whether the Tenant should request an IP address from the Load Balancer to access the Tenant's Console. 

       .. cond:: eks

          If your EKS cluster includes the :aws-docs:`AWS Load Balancer Controller add-on <eks/latest/userguide/aws-load-balancer-controller.html>`, enabling this setting directs the load balancer to assign an address to the Tenant services.

          Other load balancers *may* function similarly depending on their configuration.

       .. cond:: not eks

       Your Kubernetes distributions *may* include a load balancer that can respond to these requests.
       Installation and configuration of load balancers is out of the scope of this documentation.

   * - :guilabel:`Set Custom Domains`
     - Toggle on to customize the domains allowed to access the tenant's console and other tenant services.

   * - :guilabel:`Security Context`
     - The MinIO Operator sets the Kubernetes Security Context for pods to a default of ``1000`` for User, Group, and FsGroup. 
       The FSGroupChangePolicy defaults to ``Always``. 
       MinIO does not run the pod using the ``root`` user.

       You can modify the Security Context to direct MinIO to run using a different User, Group,FsGroup ID, and FSGroupChangePolicy. 
       You can also direct MinIO to run as the Root user.

       .. cond:: openshift

          .. important::

             If your OpenShift cluster enforces :openshift-docs:`Security Context Constraints </authentication/managing-security-context-constraints.html>` , ensure you set the Tenant constraints appropriately such that pods can start and run normally.

   * - :guilabel:`Custom Runtime Configurations`
     - Toggle on to customize the :kube-docs:`Runtime Class <concepts/containers/runtime-class/>` for the tenant to use. 

   * - :guilabel:`Additional Environment Variables`
     - Enter any additional the key:value pairs to use as environment variables for the tenant.


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
     - When enabled, you can upload custom TLS certificates for MinIO to use for server and client credentials.
       
       MinIO supports Server Name Indication (SNI) such that the Tenant can select the appropriate TLS certificate based on the request hostname and the certificate Subject Alternative Name.

       MinIO also supports uploading Certificate Authority certificates for validating client certificates minted by that CA.

.. admonition:: Supported Secret Types
   :class: note
    
   MinIO supports three types of :kube-docs:`secrets in Kubernetes <concepts/configuration/secret/#secret-types>`.
       
   #. ``opaque``
    
      Using ``private.key`` and ``public.crt`` files.
   #. ``tls``
     
      Using ``tls.key`` and ``tls.crt`` files.
   #. `cert-manager <https://cert-manager.io/>`__ 1.7.x or later 
    
      Running on Kubernetes 1.21 or later.

.. versionadded:: Console 0.23.1

   A message displays under the certificate with the date of expiration and length of time until expiration.

   The message adjusts depending on the length of time to expiration:
   
   - More than 30 days, the message text displays in gray.
   - Within 30 days, the message text changes to orange.
   - Within 10 days, the message text changes to red.
   - Within 24 hours, the message displays as an hour and minute countdown in red text.
   - After expiration, the message displays as ``EXPIRED``.

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

.. _minio-tenant-audit-logging-settings:

9) Audit Log Settings
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-k8s-deprecation-audit-prometheus.rst
   :start-after: start-deprecate-audit-logs
   :end-before: end-deprecate-audit-logs

.. versionchanged:: Console 0.23.1 and Operator 5.0.0

   New tenants have Audit Logs :guilabel:`Disabled` by default.

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Field
     - Description

   * - Log Search Storage Class
     - Select the storage class and requested capacity associated to the PVC generated to support audit logging.

   * - Storage Size
     - Specify the size of storage to make available for audit logging.

   * - :guilabel:`SecurityContext for LogSearch`
     - The MinIO Operator deploys a Log Search service (SQL Database and Log Search API) to support Audit Log search in the MinIO Tenant Console.

       You can modify the Security Context to run the associated pod commands using a different ``User``, ``Group``, ``FsGroup``, or ``FSGroupChangePolicy``. 
       You can also direct the pod to not run commands as the ``Root`` user.

   * - :guilabel:`SecurityContext for PostgreSQL`
     - The MinIO Operator deploys a PostgreSQL database to support logging services.

       You can modify the Security Context to run the associated pod commands using a different ``User``, ``Group``, ``FsGroup``, or ``FSGroupChangePolicy``. 
       You can also direct the pod to not run commands as the ``Root`` user.

       You can also modify the storage class and requested capacity associated to the PVC generated to support the Prometheus service.

.. _minio-tenant-monitoring-settings:

10) Monitoring Settings
~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-k8s-deprecation-audit-prometheus.rst
   :start-after: start-deprecate-prometheus
   :end-before: end-deprecate-prometheus

.. versionchanged:: Console 0.23.1 and Operator 5.0.0

   New tenants have monitoring :guilabel:`Disabled` by default.

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Field
     - Description

   * - Storage Class
     - Select the storage class and requested capacity associated to the PVC generated to support Prometheus.

   * - Storage Size
     - Specify the size of storage to make available for Prometheus.

   * - :guilabel:`SecurityContext`
     - The MinIO Operator assigns this Security Context for the Prometheus pod.

       You can modify the Security Context to run the associated pod commands using a different ``User``, ``Group``, ``FsGroup``, or ``FSGroupChangePolicy``. 
       You can also direct the pod to not run commands as the ``Root`` user.

.. _create-tenant-deploy-view-tenant:

11) Deploy and View the Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

12) Connect to the Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Operator creates services for the MinIO Tenant. 

.. cond:: openshift

   Use the ``oc get svc -n TENANT-PROJECT`` command to review the deployed services:

   .. code-block:: shell
      :class: copyable

      oc get svc -n minio-tenant-1

.. cond:: k8s and not openshift 

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

.. cond:: k8s and not openshift

   See the Kubernetes documentation on :kube-docs:`Publishing Services (ServiceTypes) <concepts/services-networking/service/#publishing-services-service-types>` and :kube-docs:`Ingress <concepts/services-networking/ingress/>` for more complete information on configuring external access to services.

.. cond:: openshift

   See the OpenShift documentation on :openshift-docs:`Route or Ingress <networking/understanding-networking.html#nw-ne-comparing-ingress-route_understanding-networking>` for more complete information on configuring external access to services.

.. cond:: openshift

   .. include:: /includes/openshift/steps-deploy-minio-tenant.rst

.. toctree::
   :titlesonly:
   :hidden:

   /operations/install-deploy-manage/deploy-minio-tenant-helm
