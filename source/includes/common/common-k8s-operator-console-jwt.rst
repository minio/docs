Use the following command to retrieve the JWT token necessary for logging into the Operator Console:

.. code-block:: shell
   :class: copyable

   kubectl get secret/console-sa-secret -n minio-operator -o json | jq -r '.data.token' | base64 -d

