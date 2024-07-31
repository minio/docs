The Operator Console service does not automatically bind or expose itself for external access on the Kubernetes cluster.
Instead, you must configure a network control plane component, such as a load balancer or ingress, to grant external access.

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

After applying the path, you can access the service through port ``30433`` on any of the Kubernetes worker nodes.

Append the ``nodePort`` value to the externally-accessible IP address of a worker node in your Kubernetes cluster.
Use the appropriate ``http`` or ``https`` port depending on whether you deployed Operator Console with TLS.
