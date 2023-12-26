1) Download the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   Download the MinIO executable from the following URL:

   .. code-block:: shell
      :class: copyable

      https://dl.min.io/server/minio/release/windows-amd64/minio.exe
      
   The next step includes instructions for running the executable. 
   You cannot run the executable from the Explorer or by double clicking the file.
   Instead, you call the executable to launch the server.

2) Create the ``systemd`` Service File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/linux/common-installation.rst
   :start-after: start-install-minio-systemd-desc
   :end-before: end-install-minio-systemd-desc

3) Create the Environment Variable File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-deploy.rst
   :start-after: start-common-deploy-create-environment-file-single-drive
   :end-before: end-common-deploy-create-environment-file-single-drive

4) Start the MinIO Service
~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following command on the local host to start the MinIO |SNSD| deployment as a service:

.. include:: /includes/linux/common-installation.rst
   :start-after: start-install-minio-start-service-desc
   :end-before: end-install-minio-start-service-desc

The ``journalctl`` output should resemble the following:

.. code-block:: shell

   Status:         1 Online, 0 Offline. 
   API: http://192.168.2.100:9000  http://127.0.0.1:9000       
   RootUser: myminioadmin 
   RootPass: minio-secret-key-change-me 
   Console: http://192.168.2.100:9001 http://127.0.0.1:9001    
   RootUser: myminioadmin 
   RootPass: minio-secret-key-change-me 

   Command-line: https://min.io/docs/minio/linux/reference/minio-mc.html
      $ mc alias set myminio http://10.0.2.100:9000 myminioadmin minio-secret-key-change-me

   Documentation: https://min.io/docs/minio/linux/index.html

The ``API`` block lists the network interfaces and port on which clients can access the MinIO S3 API.
The ``Console`` block lists the network interfaces and port on which clients can access the MinIO Web Console.

5) Connect to the MinIO Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-deploy.rst
   :start-after: start-common-deploy-connect-to-minio-deployment
   :end-before: end-common-deploy-connect-to-minio-deployment
