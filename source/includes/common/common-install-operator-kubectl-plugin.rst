1) Install the MinIO Kubernetes Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Kubernetes Plugin provides a command for initializing the MinIO Operator.

.. include:: /includes/k8s/install-minio-kubectl-plugin.rst

2) Initialize the MinIO Kubernetes Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run the :mc:`kubectl minio init` command to initialize the MinIO Operator:

.. code-block:: shell
   :class: copyable

   kubectl minio init

The command initializes the MinIO Operator with the following default settings:

- Deploy the Operator into the ``minio-operator`` namespace. 
  Specify the :mc-cmd:`kubectl minio init --namespace` argument to 
  deploy the operator into a different namespace.

- Use ``cluster.local`` as the cluster domain when configuring the DNS hostname
  of the operator. Specify the 
  :mc-cmd:`kubectl minio init --cluster-domain` argument to set a 
  different :kube-docs:`cluster domain 
  <tasks/administer-cluster/dns-custom-nameservers/>` value.


The Operator deploys with certain default settings and resource requests.
To modify these settings, do the following:

1. Append the ``kubectl minio init -o > operator.yaml`` to save the YAML configuration to file
2. Modify settings as-needed to fit your deployment
3. Run ``kubectl apply -f operator.yaml`` to apply the customized Operator deployment.

.. important::

   Document all arguments used when initializing the MinIO Operator.

3) Validate the Operator Installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To verify the installation, run the following command:

.. code-block:: shell
   :class: copyable

   kubectl get all --namespace minio-operator

If you initialized the Operator with a custom namespace, replace 
``minio-operator`` with that namespace.

The output resembles the following:

.. code-block:: shell

   NAME                                  READY   STATUS    RESTARTS   AGE
   pod/console-59b769c486-cv7zv          1/1     Running   0          81m
   pod/minio-operator-7976b4df5b-rsskl   1/1     Running   0          81m

   NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
   service/console    ClusterIP   10.105.218.94    <none>        9090/TCP,9443/TCP   81m
   service/operator   ClusterIP   10.110.113.146   <none>        4222/TCP,4233/TCP   81m

   NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
   deployment.apps/console          1/1     1            1           81m
   deployment.apps/minio-operator   1/1     1            1           81m

   NAME                                        DESIRED   CURRENT   READY   AGE
   replicaset.apps/console-59b769c486          1         1         1       81m
   replicaset.apps/minio-operator-7976b4df5b   1         1         1       81m

4) Open the Operator Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-k8s-connect-operator-console.rst

      

