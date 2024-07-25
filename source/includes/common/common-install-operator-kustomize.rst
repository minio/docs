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

      NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
      deployment.apps/console          1/1     1            1           5m20s
      deployment.apps/minio-operator   2/2     2            2           5m20s

      NAME                                        DESIRED   CURRENT   READY   AGE
      replicaset.apps/console-56c7d8bd89          1         1         1       5m20s
      replicaset.apps/minio-operator-6c758b8c45   2         2         2       5m20s

#. Next Steps

   You can deploy MinIO tenants using the MinIO CRD and Kustomize.

   MinIO also provides a Helm chart for deploying Tenants. 
   However, MinIO recommends using the same method to install the Operator and deploy Tenants.
   Mixing Kustomize and Helm for Operator or Tenant management may increase operational complexity.
