.. dropdown:: Port Forwarding
   :open:

   The :ref:`Operator Console service <minio-operator-console>` does not automatically bind or expose itself for external access on the Kubernetes cluster.
   Instead, configure a network control plane component, such as a load balancer or ingress, to grant external access.

   .. cond:: k8s and not openshift

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

   For example, a Kubernetes cluster with the following Operator nodes might be accessed at ``https://172.18.0.2:30443``:

      .. code-block:: shell

         kubectl get nodes -o custom-columns=IP:.status.addresses[:]
         IP
         map[address:172.18.0.5 type:InternalIP],map[address:k3d-MINIO-agent-3 type:Hostname]
         map[address:172.18.0.6 type:InternalIP],map[address:k3d-MINIO-agent-2 type:Hostname]
         map[address:172.18.0.2 type:InternalIP],map[address:k3d-MINIO-server-0 type:Hostname]
         map[address:172.18.0.4 type:InternalIP],map[address:k3d-MINIO-agent-1 type:Hostname]
         map[address:172.18.0.3 type:InternalIP],map[address:k3d-MINIO-agent-0 type:Hostname]

   Use the following command to retrieve the JWT token necessary for logging into the Operator Console:

   .. code-block:: shell
      :class: copyable

      kubectl get secret/console-sa-secret -n minio-operator -o json | jq -r '.data.token' | base64 -d

   If your local host does not have the ``jq`` utility installed, you can run the ``kubectl`` part of this command (before ``| jq``) and locate the ``data.token`` section of the output.

