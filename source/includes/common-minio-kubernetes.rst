.. default-domain:: minio

.. start-kubeapi-customresourcedefinition

See the Kubernetes API reference on 
:kube-api:`CustomResourceDefinition
<#customresourcedefinition-v1-apiextensions-k8s-io>` objects for more complete
documentation on this field.

.. end-kubeapi-customresourcedefinition

.. start-kubeapi-objectmeta

See the Kubernetes API reference on :kube-api:`ObjectMeta <#objectmeta-v1-meta>`
objects for more complete documentation on this field.

.. end-kubeapi-objectmeta

.. start-kubeapi-envvar

See the Kubernetes API reference on :kube-api:`EnvVar<#envvar-v1-core>` objects
for more complete documentation on this field.

.. end-kubeapi-envvar

.. start-kubeapi-nodeselector

See the Kubernetes API reference on 
:kube-api:`NodeSelector <#nodeselector-v1-core>` objects for more complete
documentation on this field.

.. end-kubeapi-nodeselector

.. start-kubeapi-resources

See the Kubernetes API reference on :kube-api:`ResourceRequirements 
<#resourcerequirements-v1-core>` objects for more complete documentation on
this field.

.. end-kubeapi-resources

.. start-kubeapi-securitycontext

See the Kubernetes API reference on :kube-api:`PodSecurityContext 
<#podsecuritycontext-v1-core>` for more complete documentation on this field.

.. end-kubeapi-securitycontext

.. start-kubeapi-podmanagementpolicy

See the Kubernetes API reference on :kube-api:`StatefulSetSpec 
<#statefulsetspec-v1-apps>` for more complete documentation on this field.

.. end-kubeapi-podmanagementpolicy

.. start-kubeapi-priorityclassname

See the Kubernetes API reference on :kube-api:`PodSpec <#podspec-v1-core>` 
for more complete documentation on this field.

.. end-kubeapi-priorityclassname

.. start-kubeapi-affinity

See the Kubernetes API reference on :kube-api:`Affinity <#affinity-v1-core>`
for more complete documentation on this field.

.. end-kubeapi-affinity

.. start-kubeapi-tolerations

See the Kubernetes API reference on :kube-api:`Toleration <#toleration-v1-core>`
for more complete documentation on this field.

.. end-kubeapi-toleartions

.. start-kubeapi-persistentvolumeclaimspec

See the Kubernetes API reference on 
:kube-api:`PersistentVolumeClaimSpec <#persistentvolumeclaimspec-v1-core>`
for more complete documentation on this field.

.. end-kubeapi-persistentvolumeclaimspec

.. start-console-access

.. admonition:: MinIO Console Connectivity
   :class: note

   The following procedure assumes use of a MinIO Console instance 
   deployed as part of the MinIO Tenant. Since Kubernetes restricts external
   access The procedure therefore assumes that:

   - The user is accessing the Console from a host inside the Kubernetes cluster,
  
     *-or-*

   - The Kubernetes Cluster has an 
     :kube-docs:`Ingress <concepts/services-networking/ingress/>` resource 
     configured to grant external access to the MinIO Tenant and Console.

.. end-console-access