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


Deploying Single-Node topologies requires additional configurations not covered in this documentation.
You can alternatively use a simple Kubernetes YAML object to describe a Single-Node topology for local testing and evaluation as necessary.
MinIO does not recommend nor support single-node deployment topologies for production environments.

This documentation assumes familiarity with all referenced Kubernetes concepts, utilities, and procedures. 
While this documentation *may* provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

.. _minio-k8s-deploy-minio-tenant-security:

Deploy a MinIO Tenant using Kustomize
-------------------------------------

The following procedure uses ``kubectl -k`` to deploy a MinIO Tenant using the ``base`` Kustomization template in the :minio-git:`MinIO Operator Github repository <operator/tree/master/examples/kustomization/base>`.

You can select a different base or pre-built template from the :minio-git:`repository <operator/tree/master/examples/kustomization/>` as your starting point, or build your own Kustomization resources using the :ref:`MinIO Custom Resource Documentation <minio-operator-crd>`.

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


Use the ``kubectl get svc -n NAMESPACE`` command to review the deployed services.
For Kubernetes services which use a custom ``kubectl`` analog, you can substitute the name of that program.

.. code-block:: shell
   :class: copyable

   kubectl get svc -n minio-tenant-1

.. code-block:: shell

   NAME                               TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
   minio                              LoadBalancer   10.97.114.60     <pending>     443:30979/TCP    2d3h
   TENANT-NAMESPACE-console           LoadBalancer   10.106.103.247   <pending>     9443:32095/TCP   2d3h
   TENANT-NAMESPACE-hl                ClusterIP      None             <none>        9000/TCP         2d3h

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
