.. _deploy-operator-gke:

=================================================
Deploy MinIO Operator on Google Kubernetes Engine
=================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

`Google  Kubernetes Engine <https://cloud.google.com/kubernetes-engine?ref=minio-docs>`__ (GKE) offers a highly automated secure and fully managed Kubernetes platform.
The MinIO Kubernetes Operator supports deploying MinIO Tenants onto GKE infrastructure using the MinIO Operator Console or `kustomize <https://kustomize.io/>`__ for :minio-git:`YAML-defined deployments <operator/tree/master/examples/kustomization>`.

:minio-web:`Through the GKE Marketplace <product/multicloud-google-kubernetes-service>`
   MinIO maintains an `GKE Marketplace listing <https://console.cloud.google.com/marketplace/product/minio-inc-public/minio-enterprise?pli=1&project=peak-essence-171622>`__ through which you can register your GKE cluster with |subnet|.
   Any MinIO tenant you deploy through Marketplace-connected clusters can take advantage of SUBNET registration, including 24/7 direct access to MinIO engineers.

Using Kubernetes Kustomize
   MinIO provides Kustomize templates for deploying the MinIO Operator onto Kubernetes infrastructure.
   You can use Kustomize to install the Operator onto EKS infrastructure.

   MinIO Operator installations and Tenants deployed through this path require manual subscription with MinIO SUBNET for licensing and support.

Using Kubernetes Helm
   MinIO provides a Helm chart for deploying the MinIO Operator onto Kubernetes infrastructure.
   See :ref:`minio-k8s-deploy-operator-helm` for instructions.

   MinIO Operator installations and Tenants deployed through this path require manual subscription with MinIO SUBNET for licensing and support.

This page documents deploying the MinIO Operator through the CLI using Kustomize.

This page documents deploying the MinIO Operator through the CLI using Kustomize.
For instructions on deploying the MinIO Operator through the GKE Marketplace, see :minio-web:`Deploy MinIO through GKE <product/multicloud-google-kubernetes-service/deploy>`

This documentation assumes familiarity with all referenced Kubernetes and Google Kubernetes Engine concepts, utilities, and procedures. 
While this documentation *may* provide guidance for configuring or deploying Kubernetes-related or Google Kubernetes Engine-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

Prerequisites
-------------

GKE Cluster with Compute Engine Nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure assumes an existing :abbr:`GKE (Google Kubernetes Engine)` cluster with a MinIO Operator installation and *at least* four Compute Engine nodes.
The Compute Engine nodes should have matching machine types and configurations to ensure predictable performance with MinIO.

MinIO provides :ref:`hardware guidelines <deploy-minio-distributed-recommendations>` for selecting the appropriate Compute Engine instance class and size.
MinIO strongly recommends selecting instances with support for local SSDs and *at least* 25Gbps egress bandwidth as a baseline for performance.

For more complete information on the available Compute Engine and Persistent Storage resources, see :gcp-docs:`Machine families resources and comparison guide <general-purpose-machines>` and :gcp-docs:`Persistent disks <disks>`.

``kubectl`` Access to the GKE Cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure your host machine has a ``kubectl`` installation compatible with the target GKE cluster.
For guidance on connecting ``kubectl`` to GKE, see :gke-docs:`Install kubectl and configure cluster access <how-to/cluster-access-for-kubectl>`.

Procedure
---------

The following steps deploy Operator using Kustomize and a ``kustomization.yaml`` file from the MinIO Operator GitHub repository.
To install Operator using a Helm chart, see :ref:`Deploy Operator with Helm <minio-k8s-deploy-operator-helm>`.

The following procedure uses ``kubectl -k`` to install the Operator from the MinIO Operator GitHub repository.
``kubectl -k`` and ``kubectl --kustomize`` are aliases that perform the same command.

.. important::

   If you use Kustomize to install the Operator, you must use Kustomize to manage or upgrade that installation.
   Do not use ``kubectl krew``, a Helm chart, or similar methods to manage or upgrade a MinIO Operator installation deployed with Kustomize.

   You can, however, use Kustomize to upgrade a previous version of Operator (5.0.14 or earlier) installed with the MinIO Kubernetes Plugin.

1. Install the latest version of Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable
   :substitutions:

   kubectl apply -k "github.com/minio/operator?ref=v|operator-version-stable|"

The output resembles the following:

.. code-block:: shell

   namespace/minio-operator created
   customresourcedefinition.apiextensions.k8s.io/miniojobs.job.min.io created
   customresourcedefinition.apiextensions.k8s.io/policybindings.sts.min.io created
   customresourcedefinition.apiextensions.k8s.io/tenants.minio.min.io created
   serviceaccount/console-sa created
   serviceaccount/minio-operator created
   clusterrole.rbac.authorization.k8s.io/console-sa-role created
   clusterrole.rbac.authorization.k8s.io/minio-operator-role created
   clusterrolebinding.rbac.authorization.k8s.io/console-sa-binding created
   clusterrolebinding.rbac.authorization.k8s.io/minio-operator-binding created
   configmap/console-env created
   secret/console-sa-secret created
   service/console created
   service/operator created
   service/sts created
   deployment.apps/console created
   deployment.apps/minio-operator created

2. Verify the Operator pods are running
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   kubectl get pods -n minio-operator

The output resembles the following:

.. code-block:: shell

   NAME                              READY   STATUS              RESTARTS   AGE
   console-56c7d8bd89-485qh          1/1     Running   0          2m42s
   minio-operator-6c758b8c45-nkhlx   1/1     Running   0          2m42s
   minio-operator-6c758b8c45-dgd8n   1/1     Running   0          2m42s

In this example, the ``minio-operator`` pod is MinIO Operator and the ``console`` pod is the Operator Console.

You can modify your Operator deployment by applying kubectl patches.
You can find examples for common configurations in the `Operator GitHub repository <https://github.com/minio/operator/tree/master/examples/kustomization>`__.

3. *(Optional)* Configure access to the Operator Console service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Operator Console service does not automatically bind or expose itself for external access on the Kubernetes cluster.
You must instead configure a network control plane component, such as a load balancer or ingress, to grant that external access.

For testing purposes or short-term access, expose the Operator Console service through a NodePort using the following patch:

.. code-block:: shell
   :class: copyable

   kubectl patch service -n minio-operator console -p '
   {
         "spec": {
            "ports": [
               {
                     "name": "http",
                     "port": 9090,
                     "protocol": "TCP",
                     "targetPort": 9090,
                     "nodePort": 30090
               },
               {
                     "name": "https",
                     "port": 9443,
                     "protocol": "TCP",
                     "targetPort": 9443,
                     "nodePort": 30433
               }
            ],
            "type": "NodePort"
         }
   }'

The patch command should output ``service/console patched``.
You can now access the service through ports ``30433`` (HTTPS) or ``30090`` (HTTP) on any of your Kubernetes worker nodes.

4. Verify the Operator installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check the contents of the specified namespace (``minio-operator``) to ensure all pods and services have started successfully.

.. code-block:: shell
   :class: copyable

   kubectl get all -n minio-operator

The response should resemble the following:

.. code-block:: shell

   NAME                                  READY   STATUS    RESTARTS   AGE
   pod/console-56c7d8bd89-485qh          1/1     Running   0          5m20s
   pod/minio-operator-6c758b8c45-nkhlx   1/1     Running   0          5m20s
   pod/minio-operator-6c758b8c45-dgd8n   1/1     Running   0          5m20s

   NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
   service/operator   ClusterIP   10.43.135.241   <none>        4221/TCP                        5m20s
   service/sts        ClusterIP   10.43.117.251   <none>        4223/TCP                        5m20s
   service/console    NodePort    10.43.235.38    <none>        9090:30090/TCP,9443:30433/TCP   5m20s

   NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
   deployment.apps/console          1/1     1            1           5m20s
   deployment.apps/minio-operator   2/2     2            2           5m20s

   NAME                                        DESIRED   CURRENT   READY   AGE
   replicaset.apps/console-56c7d8bd89          1         1         1       5m20s
   replicaset.apps/minio-operator-6c758b8c45   2         2         2       5m20s

5. Retrieve the Operator Console JWT for login
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   kubectl apply -f - <<EOF
   apiVersion: v1
   kind: Secret
   metadata:
      name: console-sa-secret
      namespace: minio-operator
      annotations:
         kubernetes.io/service-account.name: console-sa
   type: kubernetes.io/service-account-token
   EOF
   SA_TOKEN=$(kubectl -n minio-operator  get secret console-sa-secret -o jsonpath="{.data.token}" | base64 --decode)
   echo $SA_TOKEN

The output of this command is the JSON Web Token (JWT) login credential for Operator Console.

6. Log into the MinIO Operator Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: NodePort
      :selected:

      If you configured the service for access through a NodePort, specify the hostname of any worker node in the cluster with that port as ``HOSTNAME:NODEPORT`` to access the Console.

      For example, a deployment configured with a NodePort of 30090 and the following ``InternalIP`` addresses can be accessed at ``http://172.18.0.5:30090``.

      .. code-block:: shell
         :class: copyable

         kubectl get nodes -o custom-columns=IP:.status.addresses[:]
         IP
         map[address:172.18.0.5 type:InternalIP],map[address:k3d-MINIO-agent-3 type:Hostname]
         map[address:172.18.0.6 type:InternalIP],map[address:k3d-MINIO-agent-2 type:Hostname]
         map[address:172.18.0.2 type:InternalIP],map[address:k3d-MINIO-server-0 type:Hostname]
         map[address:172.18.0.4 type:InternalIP],map[address:k3d-MINIO-agent-1 type:Hostname]
         map[address:172.18.0.3 type:InternalIP],map[address:k3d-MINIO-agent-0 type:Hostname]

   .. tab-item:: Ingress or Load Balancer

      If you configured the ``svc/console`` service for access through ingress or a cluster load balancer, you can access the Console using the configured hostname and port.

   .. tab-item:: Port Forwarding

      You can use ``kubectl port forward`` to temporary forward ports for the Console:

      .. code-block:: shell
         :class: copyable

         kubectl port-forward svc/console -n minio-operator 9090:9090

      You can then use ``http://localhost:9090`` to access the MinIO Operator Console.

Once you access the Console, use the Console JWT to log in.
You can now :ref:`deploy and manage MinIO Tenants using the Operator Console <deploy-minio-distributed>`.
