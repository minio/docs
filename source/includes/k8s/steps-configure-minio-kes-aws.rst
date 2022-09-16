Deploy MinIO Tenant with Server-Side Encryption using AWS SecretsManager
------------------------------------------------------------------------

1) Access the Operator Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio proxy` command to temporarily forward traffic between the local host machine and the MinIO Operator Console:

.. code-block:: shell
   :class: copyable

   kubectl minio proxy

The command returns output similar to the following:

.. code-block:: shell

   Starting port forward of the Console UI.

   To connect open a browser and go to http://localhost:9090

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

To enable |SSE| with AWS Key Management Service during Tenant deployment, select the :guilabel:`Encryption` section and toggle the switch to :guilabel:`Enabled`. 
You can then change the :guilabel:`Vault` Radio button to :guilabel:`AWS` to display the configuration settings.

.. image:: /images/k8s/operator-create-tenant-encryption-aws.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console - Create a Tenant - Encryption Section - AWS Key Management Service

An asterisk ``*`` marks required fields.
The following table provides general guidance for those fields:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Field
     - Description

   * - | Endpoint
       | Region

     - The hostname and AWS region for the AWS Secrets Manager instance (``https://secretmanager.us-east-2.amazonaws.com`` and ``us-east-2``) to use for |SSE|.
       
       The MinIO Tenant |KES| pods *must* have network access to the specified endpoint.
       This procedure assumes that your Kubernetes network configuration supports routing internal traffic to external networks like the public internet.

   * - | Access Key
       | Secret Key
       | Token

     - Specify the AWS User Access Key and Secret Key MinIO should use when authenticating to the Vault service.
       Review the :ref:`AWS Prerequisites <minio-sse-aws-prereq-aws>` for instructions on generating these values.

Once you have completed the AWS |KMS| configuration, you can finish any remaining sections of :ref:`Tenant Deployment <minio-k8s-deploy-minio-tenant>`.

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