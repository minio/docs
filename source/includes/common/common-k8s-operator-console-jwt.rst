Use the following command to retrieve the JSON Web Token (JWT) necessary for logging into the Operator Console:

.. code-block:: shell
   :class: copyable

   kubectl get secret/console-sa-secret -n minio-operator -o json | jq -r '.data.token' | base64 -d

If your local host does not have the ``jq`` utility installed, you can run the first part of the command and locate the ``data.token`` section of the output.
