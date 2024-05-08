.. _minio-k8s-deploy-operator-kustomize:

==============================
Deploy Operator With Kustomize
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


Overview
--------

`Kustomize <https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization>`__ is a YAML-based templating tool that allows you to define Operator and Tenant templates using plain Kubernetes YAML reference language.
Kustomize is included with the :kube-docs:`kubectl <reference/kubectl>` command line tool.

The `default MinIO Operator Kustomize template <https://github.com/minio/operator/blob/master/kustomization.yaml>`__ provides a starting point for customizing configurations for your local environment.
You can modify a Kustomize Operator deployment after installation with :kube-docs:`kubectl patches <reference/kubectl/generated/kubectl_patch>`, which are additional YAML configurations applied over the existing base.


Prerequisites
-------------

To install the Operator with Kustomize you will need the following:

* An existing Kubernetes cluster, v1.21 or later.
* The ``kubectl`` CLI tool on your local host, the same version as the cluster.
* `Docker <https://docker.com>`__ for your platform.
* Access to run ``kubectl`` commands on the cluster from your local host.

For more about Operator installation requirements, including TLS certificates, see the :ref:`Operator deployment prerequisites <minio-operator-prerequisites>`.

This procedure assumes familiarity with the referenced Kubernetes concepts and utilities.
While this documentation may provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

.. _minio-k8s-deploy-operator-kustomize-repo:

Install the MinIO Operator using Kustomize
------------------------------------------

The following procedure uses ``kubectl -k`` to install the Operator from the MinIO Operator GitHub repository.
``kubectl -k`` and ``kubectl --kustomize`` are aliases that perform the same command.

.. important::

   If you use Kustomize to install the Operator, you must use Kustomize to manage that installation.
   Do not use ``kubectl krew``, a Helm chart, or similar methods to update or manage the MinIO Operator installation.

#. Install the latest version of Operator

   .. code-block:: shell
      :class: copyable
      :substitutions:

      kubectl apply -k github.com/minio/operator\?ref=v|operator-version-stable|

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

#. Verify the Operator pods are running:

   .. code-block:: shell
      :class: copyable

      kubectl get pods -n minio-operator

   The output resembles the following:

   .. code-block:: shell

      NAME                              READY   STATUS    RESTARTS   AGE
      console-6b6cf8946c-9cj25          1/1     Running   0          99s
      minio-operator-69fd675557-lsrqg   1/1     Running   0          99s

   In this example, the ``minio-operator`` pod is MinIO Operator and the ``console`` pod is the Operator Console.

   You can modify your Operator deplyoment by applying kubectl patches.
   You can find examples for common configurations in the `Operator GitHub repository <https://github.com/minio/operator/tree/master/examples/kustomization>`__.

#. *(Optional)* Configure access to the Operator Console port

   If needed, configure access to the Operator Console port.
   Depending on your local policies, this could be a Kubernetes load balancer, ingress, or similar control plane component that enables external access.

   For testing purposes, you can access Operator Console by configuring a NodePort using the following patch:

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


#. Verify the Operator installation

   Check the contents of the specified namespace (``minio-operator``) to ensure all pods and services have started successfully.

   .. code-block:: shell
      :class: copyable

      kubectl get all -n minio-operator

   The response should resemble the following:

   .. code-block:: shell

      NAME                                  READY   STATUS    RESTARTS   AGE
      pod/console-68d955874d-vxlzm          1/1     Running   0          25h
      pod/minio-operator-699f797b8b-th5bk   1/1     Running   0          25h
      pod/minio-operator-699f797b8b-nkrn9   1/1     Running   0          25h

      NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
      service/console    ClusterIP   10.43.195.224   <none>        9090/TCP,9443/TCP   25h
      service/operator   ClusterIP   10.43.44.204    <none>        4221/TCP            25h
      service/sts        ClusterIP   10.43.70.4      <none>        4223/TCP            25h

      NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
      deployment.apps/console          1/1     1            1           25h
      deployment.apps/minio-operator   2/2     2            2           25h

      NAME                                        DESIRED   CURRENT   READY   AGE
      replicaset.apps/console-68d955874d          1         1         1       25h
      replicaset.apps/minio-operator-699f797b8b   2         2         2       25h


#. Retrieve the Operator Console JWT for login

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


#. Log into the MinIO Operator Console


   .. tab-set::

      .. tab-item:: NodePort
         :selected:

         If you configured the service for access through a NodePort, specify the hostname of any worker node in the cluster with that port as ``HOSTNAME:NODEPORT`` to access the Console.

         For example, a deployment configured with a NodePort of 30090 and the following ``InternalIP`` addresses can be accessed at ``http://172.18.0.5:30090``.

         .. code-block:: shell
            :class: copyable

            $ kubectl get nodes -o custom-columns=IP:.status.addresses[:]
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
