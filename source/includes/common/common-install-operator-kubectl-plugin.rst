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

.. versionchanged:: Operator 4.5.8

   The MinIO Operator Console implements websockets instead of http connections.
   This protocol provides better performance at the cost of reduced compatibility with Kubernetes port forwarding behavior.

   Users who encounter timeouts when using port forwarding should select from the tabbed list to view alternatives for connecting to the Operator Console

.. tab-set::

   .. tab-item:: Port Forwarding

      Run the :mc:`kubectl minio proxy` command to temporarily forward traffic from
      the :ref:`MinIO Operator Console <minio-operator-console>` service to your 
      local machine:

      .. code-block:: shell
         :class: copyable

         kubectl minio proxy

      The command output includes a JWT token you must use to log into the
      Operator Console. 

      .. image:: /images/k8s/operator-dashboard.png
         :align: center
         :width: 70%
         :class: no-scaled-link
         :alt: MinIO Operator Console

      You can deploy a new :ref:`MinIO Tenant <minio-k8s-deploy-minio-tenant>` from
      the Operator Dashboard.

   .. tab-item:: Node Ports

      Use the following command to identify the :kube-docs:`NodePorts <concepts/services-networking/service/#type-nodeport>` configured for the Operator Console.
      If your local host does not have the ``jq`` utility installed, you can run the first command and locate the ``spec.ports`` section of the output.

      .. code-block:: shell
         :class: copyable

         kubectl get svc/console -n minio-operator -o json | jq -r '.spec.ports'

      The output resembles the following:

      .. code-block:: json

         [
            {
               "name": "http",
               "nodePort": 31055,
               "port": 9090,
               "protocol": "TCP",
               "targetPort": 9090
            },
            {
               "name": "https",
               "nodePort": 31388,
               "port": 9443,
               "protocol": "TCP",
               "targetPort": 9443
            }
         ]

      Use the ``http`` or ``https`` port depending on whether you deployed the Operator with Console TLS enabled via :mc-cmd:`kubectl minio init --console-tls`.

      Append the ``nodePort`` value to the externally-accessible IP address of a worker node in your Kubernetes cluster.

      Use the following command to retrieve the JWT token necessary for logging into the Operator Console:

      .. code-block:: shell
         :class: copyable

         kubectl get secret/console-sa-secret -n minio-operator -o json | jq -r '.data.token' | base64 -d

      

