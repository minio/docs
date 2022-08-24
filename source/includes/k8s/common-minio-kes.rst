.. start-kes-prereq-hashicorp-vault-desc

This procedure assumes an existing `Hashicorp Vault <https://www.vaultproject.io/>`__ installation accessible from the Kubernetes cluster.

- For Vault deployments within the same Kubernetes cluster as the MinIO Tenant, you can use Kubernetes service names to allow the MinIO Tenant to establish connectivity to the Vault service.

- For Vault deployments external to the Kubernetes cluster, you must configure Ingress or a similar network control plane component to allow the MinIO Tenant to establish connectivity to Vault.

Defer to the `Vault Documentation <https://learn.hashicorp.com/vault>`__ for guidance on deployment and configuration.

.. end-kes-prereq-hashicorp-vault-desc

.. start-kes-enable-sse-kms-desc

You can use either the MinIO Tenant Console or the MinIO :mc:`mc` CLI to enable bucket-default SSE-KMS with the generated key:

.. tab-set::

   .. tab-item:: MinIO Tenant Console

      You can manually :ref:`port forward <create-tenant-operator-forward-ports>` the MinIO Tenant Console service to your local host machine for simplified access:

      .. code-block:: shell
         :class: copyable

         # Replace 'minio-tenant' with the name of the MinIO Tenant
         # Replace '-n minio' with the namespace of the MinIO Tenant

         kubectl port-forward svc/minio-tenant-console 9443:9443 -n minio

      Open the MinIO Console by navigating to http://127.0.0.1:9443 in your preferred browser and logging in with the root credentials for the deployment.

      Once logged in, create a new Bucket and name it to your preference.
      Select the Gear :octicon:`gear` icon to open the management view.

      Select the pencil :octicon:`pencil` icon next to the :guilabel:`Encryption` field to open the modal for configuring a bucket default SSE scheme.

      Select :guilabel:`SSE-KMS`, then enter the name of the key created in the previous step.

      Once you save your changes, try to upload a file to the bucket. 
      When viewing that file in the object browser, note that in the sidebar the metadata includes the SSE encryption scheme and information on the key used to encrypt that object.
      This indicates the successful encrypted state of the object.

   .. tab-item:: MinIO CLI

      You can manually :ref:`port forward <create-tenant-operator-forward-ports>` the ``minio`` service for temporary access via the local host.

      Run this command in a separate Terminal or Shell:

      .. code-block:: shell
         :class: copyable

         # Replace '-n minio' with the namespace of the MinIO deployment
         # If you deployed the Tenant without TLS you may need to change the port range
         
         # You can validate the ports in use by running
         #  kubectl get svc/minio -n minio

         kubectl port forward svc/minio 443:443 -n minio

      The following commands in a new Terminal or Shell window:
      
      - Create a new :ref:`alias <alias>` for the MinIO deployment
      - Create a new bucket for storing encrypted data
      - Enable SSE-KMS encryption on that bucket

      .. code-block:: shell
         :class: copyable

         mc alias set k8s https://127.0.0.1:443 ROOTUSER ROOTPASSWORD

         mc mb k8s/encryptedbucket
         mc encrypt set SSE-KMS encrypted-bucket-key k8s/encryptedbucket

      Write a file to the bucket using :mc:`mc cp` or any S3-compatible SDK with a ``PutObject`` function. 
      You can then run :mc:`mc stat` on the file to confirm the associated encryption metadata.

.. end-kes-enable-sse-kms-desc

.. start-kes-generate-key-desc

MinIO requires that the |EK| for a given bucket or object exist on the root KMS *before* performing |SSE| operations using that key.
You can use the :mc:`mc admin kms key create` command against the MinIO Tenant.

You must ensure your local host can access the MinIO Tenant pods and services before using :mc:`mc` to manage the Tenant.
You can manually :ref:`port forward <create-tenant-operator-forward-ports>` the ``minio`` service for temporary access via the local host.

Run this command in a separate Terminal or Shell:

.. code-block:: shell
   :class: copyable

   # Replace '-n minio' with the namespace of the MinIO deployment
   # If you deployed the Tenant without TLS you may need to change the port range
   
   # You can validate the ports in use by running
   #  kubectl get svc/minio -n minio

   kubectl port forward svc/minio 443:443 -n minio

The following commands in a new Terminal or Shell window:

- Connect a local :mc:`mc` client to the Tenant.

- Create the encryption key.

See :ref:`mc-install` for instructions on installing ``mc`` on your local host.

.. code-block:: shell
   :class: copyable

   # Replace USERNAME and PASSWORD with a user on the tenant with administrative permissions
   # such as the root user

   mc alias add k8s https://localhost:443 ROOTUSER ROOTPASSWORD

   # Replace my-new-key with the name of the key you want to use for SSE-KMS
   mc admin kms key create k8s encrypted-bucket-key

.. end-kes-generate-key-desc