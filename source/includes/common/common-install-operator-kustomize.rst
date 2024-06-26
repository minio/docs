.. _minio-k8s-deploy-operator-kustomize-repo-2:

Install the MinIO Operator using Kustomize
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following procedure uses ``kubectl -k`` to install the Operator from the MinIO Operator GitHub repository.
``kubectl -k`` and ``kubectl --kustomize`` are aliases that perform the same command.

.. important::

   If you use Kustomize to install the Operator, you must use Kustomize to manage or upgrade that installation.
   Do not use ``kubectl krew``, a Helm chart, or similar methods to manage or upgrade a MinIO Operator installation deployed with Kustomize.

   You can, however, use Kustomize to upgrade a previous version of Operator (5.0.14 or earlier) installed with the MinIO Kubernetes Plugin.

#. Install the latest version of Operator

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

#. Verify the Operator pods are running:

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

   .. _minio-k8s-deploy-operator-access-console:

#. *(Optional)* Configure access to the Operator Console service

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

#. Verify the Operator installation

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

   The output of this command is the JSON Web Token (JWT) login credential for Operator Console.

#. Log into the MinIO Operator Console


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
