.. _deploy-minio-tenant-redhat-openshift:

Deploy a Tenant using the OpenShift Web Console
-----------------------------------------------

1) Access the MinIO Operator Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can find the MinIO Operator Interface from the :guilabel:`Operators` left-hand navigation header.

1. Go to :guilabel:`Operators`, then :guilabel:`Installed Operators`. 

2. For the :guilabel:`Project` dropdown, select :guilabel:`openshift-operators`.

3. Select :guilabel:`MinIO Operators` from the list of installed operators.

Click :guilabel:`Create Tenant` to begin the Tenant Creation process.

2) Create the Tenant
~~~~~~~~~~~~~~~~~~~~
The :guilabel:`Form View` provides a user interface for configuring the new MinIO Tenant.

.. image:: /images/openshift/minio-openshift-tenant-create-ui.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: OpenShift Tenant Creation UI View

- Ensure the :guilabel:`Tenant Secret -> Name` is set to the name of the MinIO Root User Kubernetes Secret created as part of the prerequisites. 

- Ensure the :guilabel:`Console -> Console Secret -> Name` is set to the name of the MinIO Console Kubernetes Secret created as part of the prerequisites.

You can also use the YAML view to perform more granular configuration of the MinIO Tenant. 
Refer to the :minio-git:`MinIO Custom Resource Definition Documentation <operator/blob/master/docs/crd.adoc>` for guidance on setting specific fields. 
MinIO also publishes examples for additional guidance in creating custom Tenant YAML objects. 
Note that the OperatorHub YAML view supports creating only the MinIO Tenant object. 
Do not specify any other objects as part of the YAML input.

.. image:: /images/openshift/minio-openshift-tenant-create-yaml.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: OpenShift Tenant Creation UI View

Changes to one view are reflected in the other. 
For example, you can make modifications in the :guilabel:`YAML View` and see those changes in the :guilabel:`Form View`.

.. admonition:: Security Context Configuration
   :class: note

   If your OpenShift cluster Security Context Configuration restricts the supported pod security contexts, open the YAML View and locate the ``spec.pools[n].securityContext`` and ``spec.console.securityContext`` objects. 
   Modify the ``securityContext`` settings to use a supported UID based on the SCC of your OpenShift Cluster.

Click :guilabel:`Create` to create the MinIO Tenant using the specified configuration. 
Use the credentials specified as part of the MinIO Root User secret to access the MinIO Server.

3) Connect to the Tenant
~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Operator creates services for the MinIO Tenant. 
Use the ``oc get svc -n NAMESPACE`` command to review the deployed services:

.. code-block:: shell
   :class: copyable

   oc get svc -n minio-tenant-1

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

4) Forward Ports
~~~~~~~~~~~~~~~~

You can temporarily expose each service using the ``oc port-forward`` utility. 
Run the following examples to forward traffic from the local host running ``oc`` to the services running inside the Kubernetes cluster.

.. tab-set::

   .. tab-item:: MinIO Tenant

      .. code-block:: shell
         :class: copyable

         oc port-forward service/minio 443:443

   .. tab-item:: MinIO Console
   
      .. code-block:: shell
         :class: copyable

         oc port-forward service/minio-tenant-1-console 9443:9443
