.. _minio-k8s-deploy-minio-tenant-commandline:

Deploy a MinIO Tenant using the Command Line
--------------------------------------------

The :mc:`kubectl minio tenant create` command supports creating a MinIO Tenant in your Kubernetes cluster.
The command *requires* that the cluster have a functional MinIO Operator installation.

To deploy a tenant from the command line, complete the following steps:

:ref:`create-tenant-cli-determine-settings-required-options`

:ref:`create-tenant-cli-determine-additional-options`

:ref:`create-tenant-cli-enter-command`

:ref:`create-tenant-cli-record-access-info`

:ref:`create-tenant-cli-access-tenant-console`

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