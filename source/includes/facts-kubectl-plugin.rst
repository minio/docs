.. default-domain:: minio

.. start-kubectl-minio-requires-operator-desc

.. admonition:: Command Requires MinIO Operator
   :class: note

   Use the following command to validate that the operator
   is online and available prior to running this command:

   .. code-block:: shell
      :class: copyable

      kubectl get deployments -A --field-selector metadata.name=minio-operator

   Issue the :mc-cmd:`kubectl minio init` command to initiate the operator
   if it is not already running in the Kubernetes cluster.


.. end-kubectl-minio-requires-operator-desc