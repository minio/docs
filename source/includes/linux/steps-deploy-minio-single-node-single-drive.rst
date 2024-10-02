1) Download the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/linux/common-installation.rst
   :start-after: start-install-minio-binary-desc
   :end-before: end-install-minio-binary-desc

2) Create the ``systemd`` Service File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``.deb`` or ``.rpm`` packages install the following `systemd <https://www.freedesktop.org/wiki/Software/systemd/>`__ service file to ``/usr/lib/systemd/system/minio.service``. 
For binary installations, create this file manually on all MinIO hosts.

.. note::
   
   ``systemd`` checks the ``/etc/systemd/...`` path before checking the ``/usr/lib/systemd/...`` path and uses the first file it finds.
   To avoid conflicting or unexpected configuration options, check that the file exists only at the ``/usr/lib/systemd/system/minio.service`` path.

   Refer to the `man page for systemd.unit <https://www.man7.org/linux/man-pages/man5/systemd.unit.5.html>`__ for details on the file path search order.
    
.. code-block:: shell
   :class: copyable

   [Unit]
   Description=MinIO
   Documentation=https://min.io/docs/minio/linux/index.html
   Wants=network-online.target
   After=network-online.target
   AssertFileIsExecutable=/usr/local/bin/minio

   [Service]
   WorkingDirectory=/usr/local

   User=minio-user
   Group=minio-user
   ProtectProc=invisible

   EnvironmentFile=-/etc/default/minio
   ExecStartPre=/bin/bash -c "if [ -z \"${MINIO_VOLUMES}\" ]; then echo \"Variable MINIO_VOLUMES not set in /etc/default/minio\"; exit 1; fi"
   ExecStart=/usr/local/bin/minio server $MINIO_OPTS $MINIO_VOLUMES

   # MinIO RELEASE.2023-05-04T21-44-30Z adds support for Type=notify (https://www.freedesktop.org/software/systemd/man/systemd.service.html#Type=)
   # This may improve systemctl setups where other services use `After=minio.server`
   # Uncomment the line to enable the functionality
   # Type=notify

   # Let systemd restart this service always
   Restart=always

   # Specifies the maximum file descriptor number that can be opened by this process
   LimitNOFILE=65536

   # Specifies the maximum number of threads this process can create
   TasksMax=infinity

   # Disable timeout logic and wait until process is stopped
   TimeoutStopSec=infinity
   SendSIGKILL=no

   [Install]
   WantedBy=multi-user.target

   # Built for ${project.name}-${project.version} (${project.name})

The ``minio.service`` file runs as the ``minio-user`` User and Group by default.
You can create the user and group using the ``groupadd`` and ``useradd``
commands. The following example creates the user and group, and sets permissions
to access the folder paths intended for use by MinIO. These commands typically
require root (``sudo``) permissions.

.. code-block:: shell
   :class: copyable

   groupadd -r minio-user
   useradd -M -r -g minio-user minio-user
   chown minio-user:minio-user /mnt/data

The drive path in this example is specified by the `MINIO_VOLUMES` environment variable. Change the value here and in the environment variable file to match
the path to the drive intended for use by MinIO.

Alternatively, change the ``User`` and ``Group`` values to another user and
group on the system host with the necessary access and permissions.

MinIO publishes additional startup script examples on 
:minio-git:`github.com/minio/minio-service <minio-service>`.

To update deployments managed using ``systemctl``, see :ref:`minio-upgrade-systemctl`.


3) Create the Environment Variable File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create an environment variable file at ``/etc/default/minio``.
The MinIO Server container can use this file as the source of all :ref:`environment variables <minio-server-environment-variables>`.

The following example provides a starting environment file:

.. code-block:: shell
   :class: copyable

   # MINIO_ROOT_USER and MINIO_ROOT_PASSWORD sets the root account for the MinIO server.
   # This user has unrestricted permissions to perform S3 and administrative API operations on any resource in the deployment.
   # Omit to use the default values 'minioadmin:minioadmin'.
   # MinIO recommends setting non-default values as a best practice, regardless of environment

   MINIO_ROOT_USER=myminioadmin
   MINIO_ROOT_PASSWORD=minio-secret-key-change-me

   # MINIO_VOLUMES sets the storage volume or path to use for the MinIO server.

   MINIO_VOLUMES="/mnt/data"

   # MINIO_OPTS sets any additional commandline options to pass to the MinIO server.
   # For example, `--console-address :9001` sets the MinIO Console listen port
   MINIO_OPTS="--console-address :9001"

Include any other environment variables as required for your deployment.

.. versionadded:: Server RELEASE.2024-03-03T17-50-39Z

MinIO automatically generates unique root credentials if all of the following conditions are true:

- :kes-docs:`KES <tutorials/getting-started/>` Release 2024-03-01T18-06-46Z or later running
  
- **Have not** defined:
  
  - ``MINIO_ROOT_USER`` variable 
  - ``MINIO_ROOT_PASSWORD`` variable 
  
- **Have**:
  
  - set up KES with a :kes-docs:`supported KMS target <#supported-kms-targets>`
  - disabled root access with the :ref:`MinIO environment variable <minio-disable-root-access>`

When those conditions are met at startup, MinIO uses the KMS to generate unique root credentials for the deployment using a `hash-based message authentication code (HMAC) <https://en.wikipedia.org/wiki/HMAC>`__.

If MinIO generates such credentials, the key used to generate the credentials **must** remain the same *and* continue to exist.
All data on the deployment is encrypted with this key!

To rotate the generated root credentials, generate a new key in the KMS, then update the value of the :envvar:`MINIO_KMS_KES_KEY_NAME` with the new key.


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
