Deploy MinIO Tenant with Server-Side Encryption
-----------------------------------------------

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

To enable |SSE| with a :kes-docs:`supported KMS target <#supported-kms-targets>` during Tenant deployment, select the :guilabel:`Encryption` section and toggle the switch to :guilabel:`Enabled`. 
You can then select the Radio button for the chosen KMS provider to display configuration settings for that provider.

.. image:: /images/k8s/operator-create-tenant-encryption.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console - Create a Tenant - Encryption Section

An asterisk ``*`` marks required fields.

Refer to the Configuration References section of the tutorial for your chosen :kes-docs:`supported KMS target <#supported-kms-targets>` for more information on the configuration options for your KMS.

Once you have completed the configuration, you can finish any remaining sections of :ref:`Tenant Deployment <minio-k8s-deploy-minio-tenant>`.

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