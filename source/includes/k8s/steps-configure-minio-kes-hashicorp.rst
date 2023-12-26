Deploy MinIO Tenant with Server-Side Encryption using Hashicorp Vault
---------------------------------------------------------------------

1) Access the Operator Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio proxy` command to temporarily forward traffic between the local host machine and the MinIO Operator Console:

.. code-block:: shell
   :class: copyable

   kubectl minio proxy

The command returns output similar to the following:

.. code-block:: shell

   Starting port forward of the Console UI.

   To connect open a browser and go to http://localhost:9001

   Current JWT to login: TOKEN

Open your browser to the specified URL and enter the JWT Token into the login page. 
You should see the :guilabel:`Tenants` page:

.. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

Click the :guilabel:`+ Create Tenant` to start creating a MinIO Tenant.

2) Complete the :guilabel:`Encryption` Section
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reference the :ref:`Deploy a MinIO Tenant <minio-k8s-deploy-minio-tenant>` procedure for complete documentation of other Tenant settings.

To enable |SSE| with Hashicorp Vault during Tenant deployment, select the :guilabel:`Encryption` section and toggle the switch to :guilabel:`Enabled`. 
You can then select the :guilabel:`Vault` Radio button to :guilabel:`Vault` to display the Vault configuration settings.

.. image:: /images/k8s/operator-create-tenant-encryption.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console - Create a Tenant - Encryption Section

An asterisk ``*`` marks required fields.
The following table provides general guidance for those fields:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Field
     - Description

   * - Endpoint

     - The hostname or IP address for the Vault service (``https://vault.example.net:8200``) to use for |SSE|.
       
       The MinIO Tenant |KES| pods *must* have network access to the specified endpoint. 
       
       For Vault services deployed in the *same* Kubernetes cluster as the MinIO Tenant, you can specify either the service's cluster IP *or* its :kube-docs:`DNS hostname <concepts/services-networking/dns-pod-service/>`.

       For Vault services external to the Kubernetes cluster, you can specify that external hostname to the MinIO Tenant.
       This assumes that your Kubernetes network configuration supports routing internal traffic to external networks like the public internet.

   * - | AppRole ID
       | AppRole Secret

     - Specify the Vault AppRole ID and AppRole Secret MinIO should use when authenticating to the Vault service.
       Review the :ref:`Vault Prerequisites <minio-sse-vault-prereq-vault>` for instructions on generating these values.

       MinIO defaults to using the `KV Version 1 <https://www.vaultproject.io/docs/secrets/kv>`__ engine.
       You can specify ``v2`` to enable the KV Version 2 engine.

Once you have completed the Vault configuration, you can finish any remaining sections of :ref:`Tenant Deployment <minio-k8s-deploy-minio-tenant>`.

3) Generate a New Encryption Key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/k8s/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

4) Enable SSE-KMS for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/k8s/common-minio-kes.rst
   :start-after: start-kes-enable-sse-kms-desc
   :end-before: end-kes-enable-sse-kms-desc