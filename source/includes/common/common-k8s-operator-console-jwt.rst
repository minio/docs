Use the following command to retrieve the JSON Web Token (JWT) necessary for logging in to the Operator Console:

.. code-block:: shell
   :class: copyable

   kubectl get secret/console-sa-secret -n minio-operator -o json | jq -r '.data.token' | base64 -d

If your local host does not have the ``jq`` utility installed, you can run the ``kubectl`` part of this command (before ``| jq``) and locate the ``data.token`` section of the output.
