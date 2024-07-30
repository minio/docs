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

   This procedure documents deploying a MinIO Tenant onto a stock Kubernetes cluster using either Kustomize or MinIO's Helm Charts.

.. screenshot temporarily removed

   .. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console


Deploying Single-Node topologies requires additional configurations not covered in this documentation.
You can alternatively use a simple Kubernetes YAML object to describe a Single-Node topology for local testing and evaluation as necessary.
MinIO does not recommend nor support single-node deployment topologies for production environments.

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

   Kubernetes Version 1.28.0
   ~~~~~~~~~~~~~~~~~~~~~~~~~

   MinIO Operator requires Kubernetes 1.28.0 or later.
   The Kubernetes infrastructure *and* the ``kubectl`` CLI tool must be the same version.
   Upgrade ``kubectl`` to the same version as the Kubernetes version used on the cluster.

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
   The Persistent Volume **must** exist prior to deploying the Tenant.


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


Deploy a MinIO Tenant using Kustomize
-------------------------------------

The following procedure uses ``kubectl -k`` to deploy a MinIO Tenant using the ``base`` Kustomization template in the :minio-git:`MinIO Operator Github repository <operator/tree/master/examples/kustomization/base>`.

You can select a different base or pre-built template from the :minio-git:`repository <operator/tree/master/examples/kustomization/>` as your starting point, or build your own Kustomization resources using the MinIO Custom Resource Documentation.

.. important::

   If you use Kustomize to deploy a MinIO Tenant, you must use Kustomize to manage or upgrade that deployment.
   Do not use ``kubectl krew``, a Helm Chart, or similar methods to manage or upgrade the MinIO Tenant.

This procedure is not exhaustive of all possible configuration options available in the :ref:`Tenant CRD <minio-operator-crd>`.
It provides a baseline from which you can modify and tailor the Tenant to your requirements.

.. container:: procedure

   #. Create a YAML object for the Tenant

      Use the ``kubectl kustomize`` command to produce a YAML file containing all Kubernetes resources necessary to deploy the ``base`` Tenant:

      .. code-block:: shell
         :class: copyable

         kubectl kustomize https://github.com/minio/operator/examples/kustomization/base/ > tenant-base.yaml

      The command creates a single YAML file with multiple objects separated by the ``---`` line.
      Open the file in your preferred editor.

      The following steps reference each object based on it's ``kind`` and ``metadata.name`` fields:

   #. Configure the Tenant topology

      The ``kind: Tenant`` object describes the MinIO Tenant.

      The following fields share the ``spec.pools[0]`` prefix and control the number of servers, volumes per server, and storage class of all pods deployed in the Tenant:
      
      .. list-table::
         :header-rows: 1
         :widths: 30 70

         * - Field
           - Description

         * - ``servers`` 
           - The number of MinIO pods to deploy in the Server Pool.

         * - ``volumesPerServer`` 
           - The number of persistent volumes to attach to each MinIO pod (``servers``).
             The Operator generates ``volumesPerServer x servers`` Persistant Volume Claims for the Tenant.

         * - ``volumeClaimTemplate.spec.storageClassName`` 
           - The Kubernetes storage class to associate with the generated Persistent Volume Claims.

             If no storage class exists matching the specified value *or* if the specified storage class cannot meet the requested number of PVCs or storage capacity, the Tenant may fail to start.

         * - ``volumeClaimTemplate.spec.resources.requests.storage``
           - The amount of storage to request for each generated PVC.

   #. Configure Tenant Affinity or Anti-Affinity

      The MinIO Operator supports the following Kubernetes Affinity and Anti-Affinity configurations:

      - Node Affinity (``spec.pools[n].nodeAffinity``)
      - Pod Affinity (``spec.pools[n].podAffinity``)
      - Pod Anti-Affinity (``spec.pools[n].podAntiAffinity``)

      MinIO recommends configuring Tenants with Pod Anti-Affinity to ensure that the Kubernetes schedule does not schedule multiple pods on the same worker node.

      If you have specific worker nodes on which you want to deploy the tenant, pass those node labels or filters to the ``nodeAffinity`` field to constrain the scheduler to place pods on those nodes.

   #. Configure Network Encryption

      The MinIO Tenant CRD provides the following fields from which you can configure tenant TLS network encryption:

      .. list-table::
         :header-rows: 1
         :widths: 30 70

         * - Field
           - Description

         * - ``tenant.certificate.requestAutoCert``
           - Enable or disable MinIO :ref:`automatic TLS certificate generation <minio-tls>`

             Defaults to ``true`` or enabled if omitted.

         * - ``tenant.certificate.certConfig``
           - Customize the behavior of :ref:`automatic TLS <minio-tls>`, if enabled.

         * - ``tenant.certificate.externalCertSecret``
           - Enable TLS for multiple hostnames via Server Name Indication (SNI)
         
             Specify one or more Kubernetes secrets of type ``kubernetes.io/tls`` or ``cert-manager``.

         * - ``tenant.certificate.externalCACertSecret``
           - Enable validation of client TLS certificates signed by unknown, third-party, or internal Certificate Authorities (CA).
         
             Specify one or more Kubernetes secrets of type ``kubernetes.io/tls`` containing the full chain of CA certificates for a given authority.

   #. Configure MinIO Environment Variables

      You can set MinIO Server environment variables using the ``tenant.configuration`` field.

      .. list-table::
         :header-rows: 1
         :widths: 30 70

         * - Field
           - Description

         * - ``tenant.configuration``
           - Specify a Kubernetes opaque secret whose data payload ``config.env`` contains each MinIO environment variable you want to set.

             The ``config.env`` data payload **must** be a base64-encoded string.
             You can create a local file, set your environment variables, and then use ``cat LOCALFILE | base64`` to create the payload.

      The YAML includes an object ``kind: Secret`` with ``metadata.name: storage-configuration`` that sets the root username, password, erasure parity settings, and enables Tenant Console.

      Modify this as needed to reflect your Tenant requirements.

   #. Review the Namespace

      The YAML object ``kind: Namespace`` sets the default namespace for the Tenant to ``minio-tenant``.

      You can change this value to create a different namespace for the Tenant.
      You must change **all** ``metadata.namespace`` values in the YAML file to match the Namespace.

   #. Deploy the Tenant

      Use the ``kubectl apply -f`` command to deploy the Tenant.

      .. code-block:: shell
         :class: copyable

         kubectl apply -f tenant-base.yaml

      The command creates each of the resources specified in the YAML object at the configured namespace.

      You can monitor the progress using the following command:

      .. code-block:: shell
         :class: copyable

         watch kubectl get all -n minio-tenant

   #. Expose the Tenant MinIO S3 API port

      To test the MinIO Client :mc:`mc` from your local machine, forward the MinIO port and create an alias.

      * Forward the Tenant's MinIO port:

      .. code-block:: shell
         :class: copyable

         kubectl port-forward svc/MINIO_TENANT_NAME-hl 9000 -n MINIO_TENANT_NAMESPACE

      * Create an alias for the Tenant service:

      .. code-block:: shell
         :class: copyable

         mc alias set myminio https://localhost:9000 minio minio123 --insecure

      You can use :mc:`mc mb` to create a bucket on the Tenant:
      
      .. code-block:: shell
         :class: copyable

         mc mb myminio/mybucket --insecure

      If you deployed your MinIO Tenant using TLS certificates minted by a trusted Certificate Authority (CA) you can omit the ``--insecure`` flag.
      
      See :ref:`create-tenant-connect-tenant` for specific instructions.

.. _create-tenant-connect-tenant:

Connect to the Tenant
---------------------

The MinIO Operator creates services for the MinIO Tenant. 

.. cond:: openshift

   Use the ``oc get svc -n TENANT-PROJECT`` command to review the deployed services:

   .. code-block:: shell
      :class: copyable

      oc get svc -n TENANT-NAMESPACE

.. cond:: k8s and not openshift 

   Use the ``kubectl get svc -n NAMESPACE`` command to review the deployed services:

   .. code-block:: shell
      :class: copyable

      kubectl get svc -n TENANT-NAMESPACE

.. code-block:: shell

   NAME                               TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
   minio                              LoadBalancer   10.97.114.60     <pending>     443:30979/TCP    2d3h
   TENANT-NAMESPACE-console             LoadBalancer   10.106.103.247   <pending>     9443:32095/TCP   2d3h
   TENANT-NAMESPACE-hl                  ClusterIP      None             <none>        9000/TCP         2d3h

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
