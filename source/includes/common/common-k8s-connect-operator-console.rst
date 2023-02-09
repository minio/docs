.. dropdown:: Port Forwarding
   :open:

   .. note::
      
      Some Kubernetes deployments may experience issues with timeouts during port-forwarding operations with the Operator Console.
      Select the :guilabel:`NodePorts` section to view instructions for alternative access.
      You can alternatively configure your preferred Ingress to grant access to the Operator Console service.
      See https://github.com/kubernetes/kubectl/issues/1368 for more information.

   Run the :mc:`kubectl minio proxy` command to temporarily forward traffic from the :ref:`MinIO Operator Console <minio-operator-console>` service to your local machine:

   .. cond:: k8s and not openshift

      .. code-block:: shell
         :class: copyable

         kubectl minio proxy

   .. cond:: openshift

      .. code-block:: shell
         :class: copyable

         oc minio proxy

   The command output includes a required token for logging into the Operator Console. 

   .. image:: /images/k8s/operator-dashboard.png
      :align: center
      :width: 70%
      :class: no-scaled-link
      :alt: MinIO Operator Console

   You can deploy a new :ref:`MinIO Tenant <minio-k8s-deploy-minio-tenant>` from the Operator Dashboard.

.. dropdown:: NodePorts

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