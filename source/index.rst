=====================================
MinIO High Performance Object Storage
=====================================

.. default-domain:: minio

Welcome to the MinIO Documentation! MinIO is a high performance object storage 
solution with native support for Kubernetes deployments. MinIO provides an 
Amazon Web Services S3-compatible API and supports all core S3 features. 
MinIO is released under `GNU Affero General Public License v3.0 
<https://www.gnu.org/licenses/agpl-3.0.en.html>`__. 

This documentation targets the latest stable version of MinIO, |minio-tag|.

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

See the :doc:`MinIO Client Complete Reference </reference/minio-mc>`
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
   Create a folder on the local drive for MinIO to use for object storage
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

   The output resembles the following:

   .. code-block:: shell

      API: http://127.0.0.1:9000      
      RootUser: minioadmin
      RootPass: minioadmin
      Region:   us-east-1
      Console: http://127.0.0.1:64518 
      RootUser: minioadmin
      RootPass: minioadmin
      Command-line: https://docs.min.io/docs/minio-client-quickstart-guide
         $ mc alias set myminio http://127.0.0.1:9000 minioadmin minioadmin
      Documentation: https://docs.min.io

   Applications should use one of the addresses listed in the :guilabel:`API`
   key for connecting to and performing operations on the MinIO Tenant. 
   For early development and application, applications can authenticate
   using the :guilabel:`RootUser` and :guilabel:`RootPass` credentials.
   For long-term development and production, create dedicated users. 
   See :doc:`/security/iam-overview` for more information.

   You can also use the :mc:`mc` commandline tool to perform operations on the
   MinIO server. Use :mc:`mc alias set` to update the ``myminio`` alias with
   the access key and secret key set on the MinIO server.

3\) Open MinIO Console
   Open your browser and http://127.0.0.1:9000 to open the 
   :ref:`MinIO Console <minio-console>` login page.
   
   Log in with the :guilabel:`Root User` and :guilabel:`Root Pass` from the
   previous step.
   
   .. image:: /images/minio-console-dashboard.png
      :width: 600px
      :alt: MinIO Console Dashboard displaying Monitoring Data
      :align: center

   You can use the MinIO Console for general administration tasks like
   Identity and Access Management, Metrics and Log Monitoring, or 
   Server Configuration. See :ref:`minio-console` for more information.

Licensing
---------

We have designed MinIO as an Open Source software for the Open Source software
community. This requires applications to consider whether their usage of MinIO
is in compliance with the 
:minio-git:`GNU AGPLv3 license <mc/blob/master/LICENSE>`.

MinIO cannot make the determination as to whether your application's usage of
MinIO is in compliance with the AGPLv3 license requirements. You should instead
rely on your own legal counsel or licensing specialists to audit and ensure your
application is in compliance with the licenses of MinIO and all other
open-source projects with which your application integrates or interacts. We
understand that AGPLv3 licensing is complex and nuanced. It is for that reason
we strongly encourage using experts in licensing to make any such determinations
around compliance instead of relying on apocryphal or anecdotal advice.

`MinIO Commercial Licensing <https://min.io/pricing>`__ is the best option for
applications that trigger AGPLv3 obligations (e.g. open sourcing your
application). Applications using MinIO - or any other OSS-licensed code -
without validating their usage do so at their own risk.

.. toctree::
   :titlesonly:
   :hidden:

   /introduction/minio-overview
   /installation/deployment-and-management
   /security/iam-overview
   /security/encryption-overview
   Object Retention </object-retention/minio-object-retention>
   /lifecycle-management/lifecycle-management-overview
   /replication/bucket-replication-overview
   /replication/site-replication-overview
   /monitoring/monitoring-overview
   /reference/minio-mc
   /reference/minio-mc-admin
   /reference/minio-server/minio-server
   /console/minio-console
   /sdk/minio-drivers