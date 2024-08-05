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

   The following command installs the Operator to the ``minio-operator`` namespace:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      kubectl apply -k "github.com/minio/operator?ref=v|operator-version-stable|"

   The command outputs a list of installed resources.

#. Verify the Operator pods are running:

   .. code-block:: shell
      :class: copyable

      kubectl get pods -n minio-operator

   The output resembles the following:

   .. code-block:: shell

      NAME                              READY   STATUS              RESTARTS   AGE
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
      pod/minio-operator-6c758b8c45-nkhlx   1/1     Running   0          5m20s
      pod/minio-operator-6c758b8c45-dgd8n   1/1     Running   0          5m20s

      NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
      service/operator   ClusterIP   10.43.135.241   <none>        4221/TCP                        5m20s
      service/sts        ClusterIP   10.43.117.251   <none>        4223/TCP                        5m20s

      NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
      deployment.apps/minio-operator   2/2     2            2           5m20s

      NAME                                        DESIRED   CURRENT   READY   AGE
      replicaset.apps/minio-operator-6c758b8c45   2         2         2       5m20s

#. Next Steps

   You can deploy MinIO tenants using the :ref:`MinIO CRD and Kustomize. <minio-k8s-deploy-minio-tenant>`
   MinIO also provides a :ref:`Helm chart for deploying Tenants <deploy-tenant-helm>`. 

   MinIO recommends using the same method of Tenant deployment and management used to install the Operator.
   Mixing Kustomize and Helm for Operator or Tenant management may increase operational complexity.
