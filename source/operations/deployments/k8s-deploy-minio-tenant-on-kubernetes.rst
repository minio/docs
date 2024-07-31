.. _minio-k8s-deploy-minio-tenant:
.. _deploy-minio-tenant-redhat-openshift:

=====================
Deploy a MinIO Tenant
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

This procedure documents deploying a MinIO Tenant using the MinIO Operator.

.. screenshot temporarily removed

   .. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console


The MinIO Operator Console is designed for deploying multi-node distributed MinIO Deployments.

Deploying Single-Node topologies requires additional configurations not covered in this documentation.
You can alternatively use a simple Kubernetes YAML object to describe a Single-Node topology for local testing and evaluation as necessary.

MinIO does not recommend nor support single-node deployment topologies for production environments.

The Operator Console provides a rich user interface for deploying and managing MinIO Tenants on Kubernetes infrastructure. 
Installing the MinIO :ref:`Kubernetes Operator <deploy-operator-kubernetes>` automatically installs and configures the Operator Console.

This documentation assumes familiarity with all referenced Kubernetes concepts, utilities, and procedures. 
While this documentation *may* provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

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

:ref:`create-tenant-deploy-view-tenant`

:ref:`create-tenant-connect-tenant`

.. _create-tenant-access-minio-operator-console:

1) Access the MinIO Operator Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-k8s-connect-operator-console.rst

Open your browser to the appropriate URL and enter the JWT Token into the login page. 
You should see the :guilabel:`Tenants` page.

.. screenshot temporarily removed

   .. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

Select :guilabel:`+ Create Tenant` to start creating a MinIO Tenant.

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

       Ensure the specified storage class has sufficient available Persistent Volume resources to match each generated Persistent Volume Claim.

   * - :guilabel:`Number of Servers`
     - The total number of MinIO server pods to deploy in the Tenant.
       The Operator enforces a minimum of four server pods per tenant.
       
       The Operator by default uses pod anti-affinity, such that the Kubernetes cluster *must* have at least one worker node per MinIO server pod. 
       Use the :guilabel:`Pod Placement` pane to modify the pod scheduling settings for the Tenant.

   * - :guilabel:`Drives per Server`
     - The number of storage volumes (Persistent Volume Claims) the Operator requests per Server. 

       The Operator displays the :guilabel:`Total Volumes` under the :guilabel:`Resource Allocation` section. 
       The Operator generates an equal number of PVC *plus two* for supporting Tenant services (Metrics and Log Search).

       The specified :guilabel:`Storage Class` *must* correspond to a set of Persistent Volumes sufficient in number to match each generated PVC.
       
       For deployments using a CSI driver, this setting results in the creation of volumes equal to ``Number of Drives per Server X Number of Servers`` using the specified :guilabel:`Storage Class`.

   * - :guilabel:`Total Size`
     - The total raw storage size for the Tenant. 
       Specify both the total storage size *and* the :guilabel:`Unit` of that storage. 
       All storage units are in SI values, e.g. :math:`Gi = GiB = 1024^3` bytes.

       The Operator displays the :guilabel:`Drive Capacity` under the:guilabel:`Resource Allocation` section. 
       The Operator sets this value as the requested storage capacity in each generated PVC.

       The specified :guilabel:`Storage Class` *must* correspond to a set of Persistent Volumes sufficient in capacity to match each generated PVC.

   * - :guilabel:`Erasure Code Parity`
     - The Erasure Code Parity to set for the deployment.

       The Operator displays the selected parity and its effect on the deployment under the :guilabel:`Erasure Code Configuration` section.
       Erasure Code parity defines the overall resiliency and availability of data on the cluster.
       Higher parity values increase tolerance to drive or node failure at the cost of total storage.
       See :ref:`minio-erasure-coding` for more complete documentation.

   * - :guilabel:`CPU Request`
     - Specify the desired number of CPUs to allocate per MinIO server pod.

   * - :guilabel:`Memory Request [Gi]`
     - Specify the desired amount of memory (RAM) to allocate per MinIO server pod. 
       See :ref:`minio-hardware-checklist-memory` for guidance on setting this value.
       MinIO **requires** a minimum of 2GiB of memory per worker.

       The Kubernetes cluster *must* have worker nodes with sufficient free RAM to match the pod request.

   * - :guilabel:`Specify Limit`
     - Toggle to :guilabel:`ON` to specify maximum CPU and memory limits.

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

       Your Kubernetes distributions *may* include a load balancer that can respond to these requests.
       Installation and configuration of load balancers is out of the scope of this documentation.

   * - :guilabel:`Expose Console Service`
     - Select whether the Tenant should request an IP address from the Load Balancer to access the Tenant's Console. 

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

       For Kubernetes clusters which enforce security context constraints, such as  :openshift-docs:`OpenShift </authentication/managing-security-context-constraints.html>`, ensure you set the Tenant constraints appropriately such that pods can start and run normally.

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

   * - :guilabel:`MinIO`
     - The container image to use for the MinIO Server. 
       See the `MinIO Quay <https://quay.io/repository/minio/minio>`__ or the `MinIO DockerHub <https://hub.docker.com/r/minio/minio/tags>`__ repositories for a list of valid tags.

   * - :guilabel:`KES Image`
     - The container image to use for MinIO :minio-git:`KES <kes>`.

   * - :guilabel:`Use a private container registry`
     - If the tenant requires a private container registry, toggle to :guilabel:`ON`, then specify the location and credentials for the private registry.

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

   * - :guilabel:`Tolerations`
     - Specify any required tolerations for this tenant's pods.

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

   * - :guilabel:`TLS`
     - Enable or disable TLS for the MinIO Tenant. 

   * - :guilabel:`AutoCert`
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
     - Configure `HashiCorp Vault <https://www.vaultproject.io/>`__ as the external KMS for storing root encryption keys. 
       See :ref:`minio-sse-vault` for guidance on the displayed fields.

   * - :guilabel:`AWS`
     - Configure `AWS Secrets Manager <https://aws.amazon.com/secrets-manager/>`__ as the external KMS for storing root encryption keys. 
       See :ref:`minio-sse-aws` for guidance on the displayed fields.

   * - :guilabel:`Gemalto`
     - Configure `Gemalto (Thales Digital Identity and Security) <https://github.com/minio/kes/wiki/Gemalto-KeySecure/>`__ as the external KMS for storing root encryption keys.
       See :kes-docs:`Thales CipherTrust Manager (formerly Gemalto KeySecure) <integrations/thales-ciphertrust/>` for guidance on the displayed fields.

   * - :guilabel:`GCP`
     - Configure `Google Cloud Platform Secret Manager <https://cloud.google.com/secret-manager/>`__ as the external KMS for storing root encryption keys. 
       See :ref:`minio-sse-gcp` for guidance on the displayed fields.

   * - :guilabel:`Azure`
     - Configure `Azure Key Vault <https://azure.microsoft.com/en-us/services/key-vault/#product-overview>`__  as the external KMS for storing root encryption keys. 
       See :ref:`minio-sse-azure` for guidance on the displayed fields.       

.. _minio-tenant-audit-logging-settings:

.. _create-tenant-deploy-view-tenant:

9) Deploy and View the Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Select :guilabel:`Create` at any time to begin the deployment process. 
The MinIO Operator displays the root user credentials *once* as part of deploying the Tenant. 
Copy these credentials to a secure location.

You can monitor the Tenant creation process from the :guilabel:`Tenants` view. 
The :guilabel:`State` column updates throughout the deployment process.

Tenant deployment can take several minutes to complete. 
Once the :guilabel:`State` reads as :guilabel:`Initialized`, select the Tenant to view its details.

.. screenshot temporarily removed

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


Use the ``kubectl get svc -n NAMESPACE`` command to review the deployed services.
For Kubernetes services which use a custom ``kubectl`` analog, you can substitute the name of that program.

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

See the Kubernetes documentation on :kube-docs:`Publishing Services (ServiceTypes) <concepts/services-networking/service/#publishing-services-service-types>` and :kube-docs:`Ingress <concepts/services-networking/ingress/>` for more complete information on configuring external access to services.

For specific flavors of Kubernetes, such as OpenShift or Rancher, defer to the service documentation on the preferred or available methods of exposing Services to internal or external access.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/deployments/k8s-deploy-minio-tenant-helm-on-kubernetes
   /operations/deployments/k8s-upgrade-minio-tenant-on-kubernetes
   /operations/deployments/k8s-expand-minio-tenant-on-kubernetes
   /operations/deployments/k8s-modify-minio-tenant-on-kubernetes
   /operations/deployments/k8s-delete-minio-tenant-on-kubernetes
