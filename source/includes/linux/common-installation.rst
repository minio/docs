.. start-install-minio-binary-desc

The following tabs provide examples of installing MinIO onto 64-bit Linux operating systems using RPM, DEB, or binary.
The RPM and DEB packages automatically install MinIO to the necessary system paths and create a ``minio`` service for ``systemctl``.
MinIO strongly recommends using the RPM or DEB installation routes.
To update deployments managed using ``systemctl``, see :ref:`minio-upgrade-systemctl`.

.. dropdown:: amd64 (Intel or AMD 64-bit processors)
   :open:

   Use one of the following options to download the MinIO server installation file for a machine running Linux on an Intel or AMD 64-bit processor.

   .. tab-set::
   
      .. tab-item:: RPM (RHEL)
         :sync: rpm
   
         Use the following commands to download the latest stable MinIO RPM and
         install it.
   
         .. code-block:: shell
            :class: copyable
            :substitutions:
   
            wget |minio-rpm| -O minio.rpm
            sudo dnf install minio.rpm
   
      .. tab-item:: DEB (Debian/Ubuntu)
         :sync: deb
   
         Use the following commands to download the latest stable MinIO DEB and
         install it:
   
         .. code-block:: shell
            :class: copyable
            :substitutions:
   
            wget |minio-deb| -O minio.deb
            sudo dpkg -i minio.deb
   
      .. tab-item:: Binary
         :sync: binary
   
         Use the following commands to download the latest stable MinIO binary and
         install it to the system ``$PATH``:
   
         .. code-block:: shell
            :class: copyable
   
            wget https://dl.min.io/server/minio/release/linux-amd64/minio
            chmod +x minio
            sudo mv minio /usr/local/bin/

.. dropdown:: arm64 (Apple M1/M2 or other ARM 64-bit processors)
   
   Use one of the following options to download the MinIO server installation file for a machine running Linux on an ARM 64-bit processor, such as the Apple M1 or M2.

   .. tab-set::
   
      .. tab-item:: RPM (RHEL)
         :sync: rpm
   
         Use the following commands to download the latest stable MinIO RPM and
         install it.
   
         .. code-block:: shell
            :class: copyable
            :substitutions:
   
            wget |minio-rpmarm64| -O minio.rpm
            sudo dnf install minio.rpm
   
      .. tab-item:: DEB (Debian/Ubuntu)
         :sync: deb
   
         Use the following commands to download the latest stable MinIO DEB and
         install it:
   
         .. code-block:: shell
            :class: copyable
            :substitutions:
   
            wget |minio-debarm64| -O minio.deb
            sudo dpkg -i minio.deb
   
      .. tab-item:: Binary
         :sync: binary
   
         Use the following commands to download the latest stable MinIO binary and
         install it to the system ``$PATH``:
   
         .. code-block:: shell
            :class: copyable
   
            wget https://dl.min.io/server/minio/release/linux-arm64/minio
            chmod +x minio
            MINIO_ROOT_USER=admin MINIO_ROOT_PASSWORD=password ./minio server /mnt/data --console-address ":9001"

.. dropdown:: Other Architectures

   MinIO also supports additional architectures:

   - ppc64le
   - s390x

   For instructions to download the binary, RPM, or DEB files for those architectures, see the `MinIO download page <https://min.io/download#/linux?ref=docs-install>`__.

.. end-install-minio-binary-desc

.. start-run-minio-binary-desc

Run the :mc-cmd:`minio server` command to start the MinIO server.
Specify the path to the volume or folder to use as the storage directory.
The :mc-cmd:`minio` process must have full access (``rwx``) to the specified path and all subfolders:

The following example uses the ``~/minio-data`` folder:

.. code-block:: shell
   :class: copyable

   mkdir ~/minio-data
   minio server ~/minio-data --console-address ":9090"

The :mc:`minio server` process prints its output to the system console, similar
to the following:

.. code-block:: shell

   API: http://192.0.2.10:9000  http://127.0.0.1:9000
   RootUser: minioadmin 
   RootPass: minioadmin 

   Console: http://192.0.2.10:9090 http://127.0.0.1:9090     
   RootUser: minioadmin 
   RootPass: minioadmin 

   Command-line: https://min.io/docs/minio/linux/reference/minio-mc.html
      $ mc alias set myminio http://192.0.2.10:9000 minioadmin minioadmin

   Documentation: https://min.io/docs/minio/linux/index.html

   WARNING: Detected default credentials 'minioadmin:minioadmin', we recommend that you change these values with 'MINIO_ROOT_USER' and 'MINIO_ROOT_PASSWORD' environment variables

Open your browser to any of the listed :guilabel:`Console` addresses to open the
:ref:`MinIO Console <minio-console>` and log in with the :guilabel:`RootUser`
and :guilabel:`RootPass`. You can use the MinIO Console for performing
administration on the MinIO server.

For applications, use the :guilabel:`API` addresses to access the MinIO
server and perform S3 operations.

The following steps are optional but recommended for further securing the
MinIO deployment.

.. end-run-minio-binary-desc

.. start-upgrade-minio-binary-desc

The following tabs provide examples of updating MinIO onto 64-bit Linux
operating systems using RPM, DEB, or binary:

.. tab-set::

   .. tab-item:: RPM (RHEL)
      :sync: rpm

      Use the following commands to download the latest stable MinIO RPM and
      update the existing installation.

      .. code-block:: shell
         :class: copyable
         :substitutions:

         wget |minio-rpm| -O minio.rpm
         sudo dnf update minio.rpm

   .. tab-item:: DEB (Debian/Ubuntu)
      :sync: deb

      Use the following commands to download the latest stable MinIO DEB and
      upgrade the existing installation:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         wget |minio-deb| -O minio.deb
         sudo dpkg -i minio.deb

   .. tab-item:: Binary
      :sync: binary

      Use the following commands to download the latest stable MinIO binary and
      overwrite the existing binary:

      .. code-block:: shell
         :class: copyable

         wget https://dl.min.io/server/minio/release/linux-amd64/minio
         chmod +x minio
         sudo mv minio /usr/local/bin/

      Replace ``/usr/local/bin`` with the location of the existing MinIO
      binary. Run ``which minio`` to identify the path if not already known.

.. end-upgrade-minio-binary-desc

.. start-install-minio-systemd-desc

The ``.deb`` or ``.rpm`` packages install the following `systemd <https://www.freedesktop.org/wiki/Software/systemd/>`__ service file to ``/usr/lib/systemd/system/minio.service``. 
For binary installations, create this file manually on all MinIO hosts.

.. note::
   
   ``systemd`` checks the ``/etc/systemd/...`` path before checking the ``/usr/lib/systemd/...`` path.
   Make sure the file only exists at ``/usr/lib/systemd/system/minio.service`` path.
    
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
commands. The following example creates the user, group, and sets permissions
to access the folder paths intended for use by MinIO. These commands typically
require root (``sudo``) permissions.

.. code-block:: shell
   :class: copyable

   groupadd -r minio-user
   useradd -M -r -g minio-user minio-user
   chown minio-user:minio-user /mnt/disk1 /mnt/disk2 /mnt/disk3 /mnt/disk4

The specified drive paths are provided as an example. Change them to match
the path to those drives intended for use by MinIO.

Alternatively, change the ``User`` and ``Group`` values to another user and
group on the system host with the necessary access and permissions.

MinIO publishes additional startup script examples on 
:minio-git:`github.com/minio/minio-service <minio-service>`.

To update deployments managed using ``systemctl``, see :ref:`minio-upgrade-systemctl`.

.. end-install-minio-systemd-desc

.. start-install-minio-start-service-desc

.. code-block:: shell
   :class: copyable

   sudo systemctl start minio.service

Use the following commands to confirm the service is online and functional:

.. code-block:: shell
   :class: copyable

   sudo systemctl status minio.service
   journalctl -f -u minio.service

MinIO may log an increased number of non-critical warnings while the 
server processes connect and synchronize. These warnings are typically 
transient and should resolve as the deployment comes online.

.. versionchanged:: RELEASE.2023-02-09T05-16-53Z

   MinIO starts if it detects enough drives to meet the :ref:`write quorum <minio-ec-parity>` for the deployment.
      
   If any drives remain offline after starting MinIO, check and cure any issues blocking their functionality before starting production workloads.

.. end-install-minio-start-service-desc

.. start-install-minio-restart-service-desc

.. code-block:: shell
   :class: copyable

   sudo systemctl restart minio.service

Use the following commands to confirm the service is online and functional:

.. code-block:: shell
   :class: copyable

   sudo systemctl status minio.service
   journalctl -f -u minio.service

MinIO may log an increased number of non-critical warnings while the 
server processes connect and synchronize. These warnings are typically 
transient and should resolve as the deployment comes online.

.. end-install-minio-restart-service-desc
