===============================
Deploy MinIO in Standalone Mode
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

The procedures on this page cover deploying MinIO in 
:guilabel:`Standalone Mode`. A standalone MinIO deployment consists of a single
MinIO server process with a single drive or storage volume ("filesystem mode").
The MinIO server provides an S3 access layer to the drive or volume and stores
objects as-is without any :ref:`erasure coding <minio-erasure-coding>`.

For extended development or production environments, *or* to access
:ref:`advanced MinIO functionality <minio-installation-comparison>` deploy MinIO
in :guilabel:`Distributed Mode`. See :ref:`deploy-minio-distributed` for more
information.

.. _deploy-minio-standalone:

Deploy Standalone MinIO on Baremetal
------------------------------------

The following procedure deploys MinIO in :guilabel:`Standalone Mode` consisting
of a single MinIO server and a single drive or storage volume. Standalone
deployments are best suited for evaluation and initial development environments.

1) Download and Run MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Visit `https://min.io/download <https://min.io/download?ref=docs>`__ and select
the tab most relevant to your use case. Follow the displayed instructions to
download the :mc:`minio` binary to your local machine. The example instructions
use the ``/data`` folder by default. You can create or change this folder
as necessary for your deployment. The :mc:`minio` process must have 
full access to the specified folder *and* all of its subfolders.

The :mc:`minio server` process prints its output to the system console, similar
to the following:

.. code-block:: shell

   API: http://192.0.2.10:9000  http://127.0.0.1:9000
   RootUser: minioadmin 
   RootPass: minioadmin 

   Console: http://192.0.2.10:9001 http://127.0.0.1:9001     
   RootUser: minioadmin 
   RootPass: minioadmin 

   Command-line: https://docs.min.io/docs/minio-client-quickstart-guide
      $ mc alias set myminio http://192.0.2.10:9000 minioadmin minioadmin

   Documentation: https://docs.min.io

   WARNING: Detected default credentials 'minioadmin:minioadmin', we recommend that you change these values with 'MINIO_ROOT_USER' and 'MINIO_ROOT_PASSWORD' environment variables

Open your browser to any of the listed :guilabel:`Console` addresses to open the
:ref:`MinIO Console <minio-console>` and log in with the :guilabel:`RootUser`
and :guilabel:`RootPass`. You can use the MinIO Console for performing
administration on the MinIO server.

For applications, use the :guilabel:`API` addresses to access the MinIO
server and perform S3 operations.

The following steps are optional but recommended for further securing the
MinIO deployment.

2) Add TLS Certificates
~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports enabling :ref:`Transport Layer Security (TLS) <minio-TLS>` 1.2+
automatically upon detecting a x.509 private key (``private.key``) and public
certificate (``public.crt``) in the MinIO ``certs`` directory:

- For Linux/MacOS: ``${HOME}/.minio/certs``

- For Windows: ``%%USERPROFILE%%\.minio\certs``

You can override the certificate directory using the 
:mc-cmd-option:`minio server certs-dir` commandline argument.

3) Run the MinIO Server with Non-Default Credentials
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following command to start the :mc:`minio server` with non-default
credentials. The table following this command breaks down each portion of the
command:

.. code-block:: shell
   :class: copyable

   export MINIO_ROOT_USER=minio-admin
   export MINIO_ROOT_PASSWORD=minio-secret-key-CHANGE-ME
   #export MINIO_KMS_SECRET_KEY=my-minio-encryption-key:bXltaW5pb2VuY3J5cHRpb25rZXljaGFuZ2VtZTEyMwo=

   minio server /data --console-address ":9001"

The example command breaks down as follows:

.. list-table::
   :widths: 40 60
   :width: 100%

   * - :envvar:`MINIO_ROOT_USER`
     - The access key for the :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string. 

   * - :envvar:`MINIO_ROOT_PASSWORD`
     - The corresponding secret key to use for the 
       :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string.

   * - :envvar:`MINIO_KMS_SECRET_KEY`
     - The key to use for encrypting the MinIO backend (users, groups,
       policies, and server configuration). Single-key backend encryption
       provides a baseline of security for non-production environments, and does
       not support features like key rotation. You can leave this command
       commented to deploy MinIO without backend encryption. 
     
       Do not use this setting in production environments. Use the MinIO
       :minio-git:`Key Encryption Service (KES) <kes>` and an external Key
       Management System (KMS) to enable encryption functionality. Specify the
       name of the encryption key to use to the :envvar:`MINIO_KMS_KES_KEY_NAME`
       instead. See :minio-git:`KMS IAM/Config Encryption
       <minio/blob/master/docs/kms/IAM.md>` for more information.

       Use the following format when specifying the encryption key:

       ``<key-name>:<encryption-key>``

       - Replace the ``<key-name>`` with any string. You must use this
         key name if you later migrate to using a dedicated KMS for 
         managing encryption keys. See :minio-git:`KMS IAM/Config Encryption
         <minio/blob/master/docs/kms/IAM.md>` for more information.

       - Replace ``<encryption-key>`` with a 32-bit base64 encoded value.
         For example:

         .. code-block:: shell
            :class: copyable
   
            cat /dev/urandom | head -c 32 | base64 -

         Save the encryption key to a secure location. You cannot restart the
         MinIO server without this key.

   * - ``/data``
     - The path to each disk on the host machine. 

       See :mc-cmd:`minio server DIRECTORIES` for more information on
       configuring the backing storage for the :mc:`minio server` process.

       MinIO writes objects to the specified directory as is and without
       :ref:`minio-erasure-coding`. Any other application accessing that
       directory can read and modify stored objects.

   * - ``--console-address ":9001"``
     - The static port on which the embedded MinIO Console listens for incoming
       connections.

       Omit to allow MinIO to select a dynamic port for the MinIO Console. 
       With dynamic port selection, browsers opening the root node hostname 
       ``https://minio1.example.com:9000`` are automatically redirected to the
       Console.

You may specify other :ref:`environment variables 
<minio-server-environment-variables>` as required by your deployment.

4) Open the MinIO Console
~~~~~~~~~~~~~~~~~~~~~~~~~

Open your browser to the DNS name or IP address corresponding to the 
container and the :ref:`MinIO Console <minio-console>` port. For example,
``https://127.0.0.1:9001``.

Log in with the :guilabel:`MINIO_ROOT_USER` and :guilabel:`MINIO_ROOT_PASSWORD`
from the previous step.

.. image:: /images/minio-console-dashboard.png
   :width: 600px
   :alt: MinIO Console Dashboard displaying Monitoring Data
   :align: center

You can use the MinIO Console for general administration tasks like
Identity and Access Management, Metrics and Log Monitoring, or 
Server Configuration. Each MinIO server includes its own embedded MinIO
Console.

Applications should use the ``https://HOST-ADDRESS:9000`` to perform S3
operations against the MinIO server.

.. _deploy-minio-standalone-container:

Deploy Standalone MinIO in a Container
--------------------------------------

The following procedure deploys a single MinIO container with a single drive.
Standalone deployments are best suited for evaluation and initial development
environments.

The procedure uses `Podman <https://podman.io/>`__ for running the MinIO
container in rootfull mode. Configuring for rootless mode is out of scope for
this procedure.

1) Create a Configuration File to store Environment Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO reads configuration values from environment variables. MinIO supports
reading these environment variables from  ``/run/secrets/config.env``. Save
the ``config.env`` file as a :podman-docs:`Podman secret <secret.html>` and
specify it as part of running the container.

Create a file ``config.env`` using your preferred text editor and enter the
following environment variables:

.. code-block:: shell
   :class: copyable

   export MINIO_ROOT_USER=minio-admin
   export MINIO_ROOT_PASSWORD=minio-secret-key-CHANGE-ME
   #export MINIO_KMS_SECRET_KEY=my-minio-encryption-key:bXltaW5pb2VuY3J5cHRpb25rZXljaGFuZ2VtZTEyMwo=

Create the Podman secret using the ``config.env`` file:

.. code-block:: shell
   :class: copyable

   sudo podman secret create config.env config.env

The following table details each environment variable set in ``config.env``:

.. list-table::
   :widths: 40 60
   :width: 100%

   * - :envvar:`MINIO_ROOT_USER`
     - The access key for the :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string. 

   * - :envvar:`MINIO_ROOT_PASSWORD`
     - The corresponding secret key to use for the 
       :ref:`root <minio-users-root>` user.

       Replace this value with a unique, random, and long string.

   * - :envvar:`MINIO_KMS_SECRET_KEY`
     - The key to use for encrypting the MinIO backend (users, groups,
       policies, and server configuration). Single-key backend encryption
       provides a baseline of security for non-production environments, and does
       not support features like key rotation. You can leave this command
       commented to deploy MinIO without backend encryption. 
     
       Do not use this setting in production environments. Use the MinIO
       :minio-git:`Key Encryption Service (KES) <kes>` and an external Key
       Management System (KMS) to enable encryption functionality. Specify the
       name of the encryption key to use to the :envvar:`MINIO_KMS_KES_KEY_NAME`
       instead. See :minio-git:`KMS IAM/Config Encryption
       <minio/blob/master/docs/kms/IAM.md>` for more information.

       Use the following format when specifying the encryption key:

       ``<key-name>:<encryption-key>``

       - Replace the ``<key-name>`` with any string. You must use this
         key name if you later migrate to using a dedicated KMS for 
         managing encryption keys. See :minio-git:`KMS IAM/Config Encryption
         <minio/blob/master/docs/kms/IAM.md>` for more information.

       - Replace ``<encryption-key>`` with a 32-bit base64 encoded value.
         For example:

         .. code-block:: shell
            :class: copyable
   
            cat /dev/urandom | head -c 32 | base64 -

         Save the encryption key to a secure location. You cannot restart the
         MinIO server without this key.

You may specify other :ref:`environment variables 
<minio-server-environment-variables>` as required by your deployment.

2) Add TLS Certificates
~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports enabling :ref:`Transport Layer Security (TLS) <minio-TLS>` 1.2+
automatically upon detecting a x.509 private key (``private.key``) and public
certificate (``public.crt``) in the MinIO ``certs`` directory:

Create a Podman secret pointing to the x.509 
``private.key`` and ``public.crt`` to use for the container.

.. code-block:: shell
   :class: copyable

   sudo podman secret create private.key /path/to/private.key
   sudo podman secret create public.crt /path/to/public.crt

You can optionally skip this step to deploy without TLS enabled. MinIO
strongly recommends *against* non-TLS deployments outside of early development.

3) Run the MinIO Container
~~~~~~~~~~~~~~~~~~~~~~~~~~

Issue the following command to start the MinIO server in a container:

.. code-block:: shell
   :class: copyable

   sudo podman run -p 9000:9000 -p 9001:9001 \
     -v /data:/data \
     --secret private.key \
     --secret public.crt \
     --secret config.env \
     minio/minio server /data \
     --console-address ":9001" \
     --certs-dir "/run/secrets/"

The example command breaks down as follows:

.. list-table::
   :widths: 40 60
   :width: 100%

   * - ``-p 9000:9000, -p 9001:9001``
     - Exposes the container internal port ``9000`` and ``9001`` through 
       the node port ``9000`` and ``9001`` respectively.

       Port ``9000`` is the default MinIO server listen port. 

       Port ``9001`` is the :ref:`MinIO Console <minio-console>` listen port
       specified by the ``--console-address`` argument.

   * - ``-v /data:/data``
     - Mounts a local volume to the container at the specified path.

   * - ``--secret ...``
     - Mounts a secret to the container. The specified secrets correspond to
       the following:

       - The x.509 private and public key the MinIO server process uses for
         enabling TLS.
  
       - The ``config.env`` file from which MinIO looks for configuration
         environment variables.

   * - ``/data``
     - The path to the container volume in which the ``minio`` server stores
       all information related to the deployment. 

       See :mc-cmd:`minio server DIRECTORIES` for more information on
       configuring the backing storage for the :mc:`minio server` process.

   * - ``--console-address ":9001"``
     - The static port on which the embedded MinIO Console listens for incoming
       connections.

       Omit to allow MinIO to select a dynamic port for the MinIO Console. 
       With dynamic port selection, browsers opening the root node hostname 
       ``https://minio1.example.com:9000`` are automatically redirected to the
       Console.

   * - ``--cert /run/secrets/``
     - Directs the MinIO server to use the ``/run/secrets/`` folder for 
       retrieving x.509 certificates to use for enabling TLS.

4) Open the MinIO Console
~~~~~~~~~~~~~~~~~~~~~~~~~

Open your browser to the DNS name or IP address corresponding to the 
container and the :ref:`MinIO Console <minio-console>` port. For example,
``https://127.0.0.1:9001``.

Log in with the :guilabel:`MINIO_ROOT_USER` and :guilabel:`MINIO_ROOT_PASSWORD`
from the previous step.

.. image:: /images/minio-console-dashboard.png
   :width: 600px
   :alt: MinIO Console Dashboard displaying Monitoring Data
   :align: center

You can use the MinIO Console for general administration tasks like
Identity and Access Management, Metrics and Log Monitoring, or 
Server Configuration. Each MinIO server includes its own embedded MinIO
Console.

Applications should use the ``https://HOST-ADDRESS:9000`` to perform S3
operations against the MinIO server.