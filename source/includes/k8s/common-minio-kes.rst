.. start-kes-prereq-hashicorp-vault-desc

This procedure assumes an existing :kes-docs:`supported KMS installation <#supported-kms-targets>` accessible from the Kubernetes cluster.

- For deployments within the same Kubernetes cluster as the MinIO Tenant, you can use Kubernetes service names to allow the MinIO Tenant to establish connectivity to the target KMS service.

- For deployments external to the Kubernetes cluster, you must ensure the cluster supports routing communications between Kubernetes services and pods and the external network.
  This may require configuration or deployment of additional Kubernetes network components and/or enabling access to the public internet.

Defer to the documentation for your chosen KMS solution for guidance on deployment and configuration.

.. end-kes-prereq-hashicorp-vault-desc

.. start-kes-enable-sse-kms-desc

You can use either the MinIO Tenant Console or the MinIO :mc:`mc` CLI to enable bucket-default SSE-KMS with the generated key:

.. tab-set::

   .. tab-item:: MinIO Tenant Console

      Connect to the :ref:`MinIO Tenant Console service <create-tenant-connect-tenant>` and log in.
      For clients internal to the Kubernetes cluster, you can specify the :kube-docs:`service DNS name <concepts/services-networking/dns-pod-service/#a-aaaa-records>`.
      For clients external to the Kubernetes cluster, specify the hostname of the service exposed by Ingress, Load Balancer, or similar Kubernetes network control component.

      Once logged in, create a new Bucket and name it to your preference.
      Select the Gear :octicon:`gear` icon to open the management view.

      Select the pencil :octicon:`pencil` icon next to the :guilabel:`Encryption` field to open the modal for configuring a bucket default SSE scheme.

      Select :guilabel:`SSE-KMS`, then enter the name of the key created in the previous step.

      Once you save your changes, try to upload a file to the bucket. 
      When viewing that file in the object browser, note that in the sidebar the metadata includes the SSE encryption scheme and information on the key used to encrypt that object.
      This indicates the successful encrypted state of the object.

   .. tab-item:: MinIO CLI

      Use the :ref:`MinIO API Service <create-tenant-connect-tenant>` to create a new :ref:`alias <alias>` for the MinIO deployment.
      You can then use the :mc:`mc encrypt set` command to enable SSE-KMS encryption for a bucket:

      .. code-block:: shell
         :class: copyable

         mc alias set k8s https://minio.minio-tenant-1.svc.cluster-domain.example:443 ROOTUSER ROOTPASSWORD

         mc mb k8s/encryptedbucket
         mc encrypt set SSE-KMS encrypted-bucket-key k8s/encryptedbucket

      For clients external to the Kubernetes cluster, specify the hostname of the service exposed by Ingress, Load Balancer, or similar Kubernetes network control component.

      Write a file to the bucket using :mc:`mc cp` or any S3-compatible SDK with a ``PutObject`` function. 
      You can then run :mc:`mc stat` on the file to confirm the associated encryption metadata.

.. end-kes-enable-sse-kms-desc

.. start-kes-generate-key-desc

.. admonition:: Unseal Vault Before Creating Key
   :class: important

   If required by your chosen provider, you must unseal the backing vault instance before creating new encryption keys.
   See the documentation for your chosen KMS solution for more information.

MinIO requires that the |EK| for a given bucket or object exist on the root KMS *before* performing |SSE| operations using that key.
You can use the :mc-cmd:`mc admin kms key create` command against the MinIO Tenant.

You must ensure your local host can access the MinIO Tenant pods and services before using :mc:`mc` to manage the Tenant.
For hosts internal to the Kubernetes cluster, you can use the :kube-docs:`service DNS name <concepts/services-networking/dns-pod-service/#a-aaaa-records>`.
For hosts external to the Kubernetes cluster, specify the hostname of the service exposed by Ingress, Load Balancer, or similar Kubernetes network control component.

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