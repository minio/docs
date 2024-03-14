1) Download the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/macos/common-installation.rst
   :start-after: start-install-minio-binary-desc
   :end-before: end-install-minio-binary-desc

2) Create the Environment Variable File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-deploy.rst
   :start-after: start-common-deploy-create-environment-file-single-drive
   :end-before: end-common-deploy-create-environment-file-single-drive

.. include:: /includes/common/common-deploy.rst
   :start-after: start-common-deploy-create-unique-root-credentials 
   :end-before: end-common-deploy-create-unique-root-credentials

3) Start the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following command on the local host to start the MinIO |SNSD| deployment as a foreground process.
You must keep the shell or terminal session open to keep the process running.

.. include:: /includes/macos/common-installation.rst
   :start-after: start-run-minio-binary-desc
   :end-before: end-run-minio-binary-desc

4) Connect to the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-deploy.rst
   :start-after: start-common-deploy-connect-to-minio-deployment
   :end-before: end-common-deploy-connect-to-minio-deployment
