=====================================
MinIO High Performance Object Storage
=====================================

.. default-domain:: minio

Welcome to the MinIO Documentation! MinIO is a high performance object storage 
solution with native support for Kubernetes deployments. MinIO provides an 
Amazon Web Services S3-compatible API and supports all core S3 features. 

You can get started exploring MinIO features using our ``play`` server at
https://play.min.io. ``play`` is a *public* MinIO cluster running the latest
stable MinIO server. Any file uploaded to ``play`` should be considered public
and non-protected.

The MinIO Client :mc:`mc` commandline interface includes an
:mc-cmd:`alias <mc alias>` for the ``play`` server. After 
`Downloading the MinIO Client <https://min.io/downloads>`__, use the 
``play`` alias to perform S3-compatible object storage operations:

.. code-block:: shell
   :class: copyable

   mc alias list play
   mc mb --with-lock play/mynewbucket
   mc cp ~/data/mytestdata play/mynewbucket

See the :doc:`MinIO Client Complete Reference </reference/minio-cli/minio-mc>`
for complete documentation on the available :mc:`mc` commands.

- First-time users of MinIO *or* object storage services should start with 
  our :doc:`Introduction </introduction/minio-overview>`.

- Users deploying onto a Kubernetes cluster should start with our 
  :docs-k8s:`Kubernetes documentation <>`.

Quickstart
----------

The following steps deploys MinIO in filesystem mode with a single folder or
disk on the local host. This deployment is best used for initial evaluation of
MinIO S3-compatible object storage. Filesystem mode does not support features
such as versioning and replication.

1\) Create a Data Folder
   Create a folder on the local drive for MinIO to use for object storag
   operations. For example:

   .. code-block:: shell
      :class: copyable

      mkdir /mnt/data
      sudo chmod -R 775 /mnt/data
      
2\) Download MinIO Server and Commandline Tools
   Visit `https://min.io/downloads <https://min.io/downloads?ref=docs>`__ and
   following the instructions for your host operating system to download and
   configure the :mc:`minio` and :mc:`mc` binaries.  Consider adding the
   ``minio`` and ``mc`` binaries to the operating system PATH for simplified
   operations.

   Follow the instructions on the download site to start the :mc:`minio server`
   process. For example, the following command starts the
   :mc:`minio server` using the created directory:

   .. code-block:: shell
      :class: copyable

      export MINIO_ROOT_USER=myminioaccesskey
      export MINIO_ROOT_PASSWORD=myminiosecretkey
      export MINIO_KMS_SECRET_KEY=my-minio-encryption-key:bXltaW5pb2VuY3J5cHRpb25rZXljaGFuZ2VtZTEyMwo=

      minio server /mnt/data

   .. list-table::
      :stub-columns: 1
      :widths: 30 60
      :width: 100%

      * - :envvar:`MINIO_ROOT_USER`
        - The :ref:`root user <minio-users-root>` access key. Replace the
          sample value with a long, random, and unique string.

      * - :envvar:`MINIO_ROOT_PASSWORD`
        - The :ref:`root user <minio-users-root>` secret key. Replace the
          sample value with a long, random, and unique string.

      * - :envvar:`MINIO_KMS_SECRET_KEY`
        - The encryption key for the MinIO IAM backend. Replace the
          sample value with a 32-bit base-64 encoded value. For example,
          use the following command to generate a random key:

          .. code-block:: shell
             :class: copyable

             cat /dev/urandom`` | head -c 32 | base64 -

   MinIO by default listens on port ``9000``. Applications running on the
   same host can connect and perform S3 operations on the MinIO server
   using the ``http://localhost:9000`` url.

   You can also use the :mc:`mc` commandline tool to perform operations on the
   MinIO server. Use :mc:`mc alias set` to update the ``myminio`` alias with
   the access key and secret key set on the MinIO server.

3\) Configure Console User for MinIO
   Create a a :ref:`policy <minio-policy>` and :ref:`user <minio-users>` for
   supporting the :minio-git:`MinIO Console <console>`. The Console provides a
   rich graphical user interface for interacting with the MinIO server.

   The following command downloads the JSON policy file, creates the appropriate
   policy, and assigns that policy to a user:

   .. code-block:: shell
      :class: copyable

      wget -O - https://docs.min.io/minio/baremetal/examples/ConsoleAdmin.json | \
      mc admin policy add myminio ConsoleAdminPolicy /dev/stdin
      mc admin user add myminio consoleAdmin LongRandomSecretKey
      mc admin policy set Alpha ConsoleAdminPolicy user=consoleAdmin

4\) Install and run the MinIO Console
   Download the :minio-git:`Latest Stable <console/releases/latest>` version
   of MinIO Console for the host operating system.
   
   Set the ``CONSOLE_MINIO_SERVER`` environment variable with the
   URL of the MinIO server:

   .. code-block:: shell
      :class: copyable

      export CONSOLE_MINIO_SERVER=http://localhost:9000

   Run the Console:

   .. code-block:: shell
      :class: copyable

      ./console server

5\) Open the MinIO Console
   Open your browser and navigate to ``http://localhost:9090`` to access the
   MinIO Console. Log in with the ``consoleAdmin`` access key and secret key to
   begin interacting with the MinIO Tenant.

.. toctree::
   :titlesonly:
   :hidden:

   /introduction/minio-overview
   /concepts/feature-overview
   /tutorials/minio-installation
   /lifecycle-management/lifecycle-management-overview
   /replication/replication-overview
   /security/security-overview
   /monitoring/monitoring-overview
   /reference/minio-cli/minio-mc
   /reference/minio-cli/minio-mc-admin
   /reference/minio-server/minio-server
   /reference/minio-server/minio-gateway
