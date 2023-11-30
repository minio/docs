Deploy MinIO Tenant with Server-Side Encryption using GCP Secret Manager
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

To enable |SSE| with |rootkms-short| during Tenant deployment, select the :guilabel:`Encryption` section and toggle the switch to :guilabel:`Enabled`. 
You can then select the :guilabel:`GCP` Radio button to display the |rootkms-short| configuration settings.

.. image:: /images/k8s/operator-create-tenant-encryption-gcp.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console - Create a Tenant - Encryption Section - GCP

An asterisk ``*`` marks required fields.
The following table provides general guidance for those fields:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Field
     - Description

   * - | Project ID
       | Endpoint

     - The Project ID and endpoint for the |rootkms-short| service to use for |SSE|.
       
       The MinIO Tenant |KES| pods *must* have network access to the specified endpoint.

   * - | Client Email
       | Client ID
       | Private Key ID
       | Private Key

     - Specify the credentials for the GCP user with which the Tenant authenticates to the |rootkms-short| service.
       Review the :ref:`GCP Secret Manager Prerequisites <minio-sse-gcp-prereq-gcp>` for instructions on generating these values.

Once you have completed the |rootkms-short| configuration, you can finish any remaining sections of :ref:`Tenant Deployment <minio-k8s-deploy-minio-tenant>`.

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