.. _quickstart-macos:

.. |OS| replace:: MacOS

This procedure deploys a :ref:`Single-Node Single-Drive <minio-installation-comparison>` MinIO server onto |OS| for early development and evaluation of MinIO Object Storage and its S3-compatible API layer.

For instructions on deploying to production environments, see :ref:`deploy-minio-distributed`.

Prerequisites
-------------

- Read, write, and execute permissions for the user's home directory
- Familiarity with using the Terminal

Procedure
---------

#. **Install the MinIO Server**

   .. include:: /includes/macos/common-installation.rst
      :start-after: start-install-minio-binary-desc
      :end-before: end-install-minio-binary-desc

 
#. **Launch the MinIO Server**

   .. include:: /includes/macos/common-installation.rst
      :start-after: start-run-minio-binary-desc
      :end-before: end-run-minio-binary-desc

#. **Connect your Browser to the MinIO Server**

   Access the :ref:`minio-console` by going to a browser (such as Safari) and going to ``https://127.0.0.1:9000`` or one of the Console addresses specified in the :mc:`minio server` command's output.
   For example, :guilabel:`Console: http://192.0.2.10:9001 http://127.0.0.1:9001` in the example output indicates two possible addresses to use for connecting to the Console.

   While port ``9000`` is used for connecting to the API, MinIO automatically redirects browser access to the MinIO Console.

#. `(Optional)` Install the MinIO Client

   The :ref:`MinIO Client <minio-client>` allows you to work with your MinIO volume from the commandline.

   .. tab-set::

      .. tab-item:: Homebrew

         Run the following commands to install the latest stable MinIO Client package using `Homebrew <https://brew.sh>`_.

         .. code-block:: shell
            :class: copyable

            brew install minio/stable/mc

         To use the command, run 
         
         .. code-block::
            
            mc {command} {flag}

      .. tab-item:: Binary (arm64)

         Download the standalone MinIO server for MacOS and make it executable.
           
         .. code-block:: shell
            :class: copyable

            curl -O https://dl.min.io/client/mc/release/darwin-arm64/mc
            chmod +x mc
            sudo mv mc /usr/local/bin/mc
   
         To use the command, run 
         
         .. code-block:: shell
            
            mc {command} {flag}

      .. tab-item:: Binary (amd64)

         Download the standalone MinIO server for MacOS and make it executable.     

         .. code-block:: shell
            :class: copyable

            curl -O https://dl.min.io/client/mc/release/darwin-amd64/mc
            chmod +x mc
            sudo mv mc /usr/local/bin/mc

         To use the command, run 
         
         .. code-block:: shell
            
            mc {command} {flag}
            
   Use :mc:`mc alias set` to quickly authenticate and connect to the MinIO deployment.

   .. code-block:: shell
      :class: copyable

      mc alias set local http://127.0.0.1:9000 minioadmin minioadmin
      mc admin info local

   The :mc:`mc alias set` takes four arguments:

   - The name of the alias
   - The hostname or IP address and port of the MinIO server
   - The Access Key for a MinIO :ref:`user <minio-users>`
   - The Secret Key for a MinIO :ref:`user <minio-users>`

   For additional details about this command, see :ref:`alias`.

.. rst-class:: section-next-steps
   
Next Steps
----------

- :ref:`Connect your applications to MinIO <minio-drivers>`
- :ref:`Configure Object Retention <minio-object-retention>`
- :ref:`Configure Security <minio-authentication-and-identity-management>`
- :ref:`Deploy MinIO for Production Environments <deploy-minio-distributed>`
