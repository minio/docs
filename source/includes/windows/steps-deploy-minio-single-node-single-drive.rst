1) Download the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   Download the MinIO executable from the following URL:

   .. code-block:: shell
      :class: copyable

      https://dl.min.io/server/minio/release/windows-amd64/minio.exe
      
   The next step includes instructions for running the executable. 
   You cannot run the executable from the Explorer or by double clicking the file.
   Instead, you call the executable to launch the server.

2) Prepare the Data Path for MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure the data path is empty and contains no existing files, including any hidden or Windows system files.

If specifying a drive not dedicated for use by MinIO, consider creating a dedicated folder for storing MinIO data such as ``D:/Minio``.

3) Start the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the Command Prompt or Powershell and issue the following command to start the MinIO |SNSD| deployment in that session:

.. code-block:: shell
   :class: copyable

   minio.exe server D:/minio --console-address ":9001"

The output should resemble the following:

.. code-block:: shell

   Status:         1 Online, 0 Offline. 
   API: http://192.168.2.100:9000  http://127.0.0.1:9000       
   Console: http://192.168.2.100:9001 http://127.0.0.1:9001

   Command-line: https://min.io/docs/minio/linux/reference/minio-mc.html
      $ mc alias set myminio http://10.0.2.100:9000 minioadmin minioadmin

   Documentation: https://min.io/docs/minio/linux/index.html

The ``API`` block lists the network interfaces and port on which clients can access the MinIO S3 API.
The ``Console`` block lists the network interfaces and port on which clients can access the MinIO Web Console.

4) Connect to the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-deploy.rst
   :start-after: start-common-deploy-connect-to-minio-deployment
   :end-before: end-common-deploy-connect-to-minio-deployment
