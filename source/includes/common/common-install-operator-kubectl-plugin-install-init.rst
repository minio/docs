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
