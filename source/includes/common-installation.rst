.. start-install-minio-binary-desc

The following tabs provide examples of installing MinIO onto 64-bit Linux
operating systems using RPM, DEB, or binary. The RPM and DEB packages
automatically install MinIO to the necessary system paths and create a
``systemd`` service file for running MinIO automatically. MinIO strongly
recommends using RPM or DEB installation routes.

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

.. end-install-minio-binary-desc

.. start-upgrade-minio-binary-desc

The following tabs provide examples of updating MinIO onto 64-bit Linux operating systems using RPM, DEB, or binary.

For infrastructure managed by tools such as Ansible or Terraform, defer to your internal procedures for updating packages or binaries across multiple managed hosts.

.. tab-set::

   .. tab-item:: RPM (RHEL)
      :sync: rpm

      Use the following commands to download the latest stable MinIO RPM and
      update the existing installation.

      .. code-block:: shell
         :class: copyable
         :substitutions:

         curl |minio-rpm| --output minio.rpm
         sudo dnf update minio.rpm

   .. tab-item:: DEB (Debian/Ubuntu)
      :sync: deb

      Use the following commands to download the latest stable MinIO DEB and
      upgrade the existing installation:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         curl |minio-deb| --output minio.deb
         sudo dpkg -i minio.deb

   .. tab-item:: Binary
      :sync: binary

      Use the following commands to download the latest stable MinIO binary and
      overwrite the existing binary:

      .. code-block:: shell
         :class: copyable

         curl https://dl.min.io/server/minio/release/linux-amd64/minio
         chmod +x minio
         sudo mv minio /usr/local/bin/

      Replace ``/usr/local/bin`` with the location of the existing MinIO binary. 
      Run ``which minio`` to identify the path if not already known.

You can validate the upgrade by computing the ``SHA256`` checksum of each binary and ensuring the checksum matches across all hosts:

.. code-block:: shell
   :class: copyable

   shasum -a 256 /usr/local/bin/minio

The output of :mc-cmd:`minio --version <minio server>` should also match across all hosts.

.. end-upgrade-minio-binary-desc

.. start-install-minio-tls-desc

MinIO enables :ref:`Transport Layer Security (TLS) <minio-tls>` 1.2+ 
automatically upon detecting a valid x.509 certificate (``.crt``) and
private key (``.key``) in the MinIO ``${HOME}/.minio/certs`` directory.

For ``systemd``-managed deployments, use the ``$HOME`` directory for the
user which runs the MinIO server process. The provided ``minio.service``
file runs the process as ``minio-user``. The previous step includes instructions
for creating this user with a home directory ``/home/minio-user``.

- Place TLS certificates into ``/home/minio-user/.minio/certs``.

- If *any* MinIO server or client uses certificates signed by an unknown
  Certificate Authority (self-signed or internal CA), you *must* place the CA
  certs in the ``/home/minio-user/.minio/certs/CAs`` on all MinIO hosts in the
  deployment. MinIO rejects invalid certificates (untrusted, expired, or
  malformed).

If the ``minio.service`` file specifies a different user account, use the
``$HOME`` directory for that account. Alternatively, specify a custom
certificate directory using the :mc-cmd:`minio server --certs-dir`
commandline argument. Modify the ``MINIO_OPTS`` variable in
``/etc/defaults/minio`` to set this option. The ``systemd`` user which runs the
MinIO server process *must* have read and listing permissions for the specified
directory.

For more specific guidance on configuring MinIO for TLS, including multi-domain
support via Server Name Indication (SNI), see :ref:`minio-tls`. You can
optionally skip this step to deploy without TLS enabled. MinIO strongly
recommends *against* non-TLS deployments outside of early development.

.. end-install-minio-tls-desc

.. start-install-minio-systemd-desc

The ``.deb`` or ``.rpm`` packages install the following 
`systemd <https://www.freedesktop.org/wiki/Software/systemd/>`__ service file to 
``/etc/systemd/system/minio.service``. For binary installations, create this
file manually on all MinIO hosts:

.. code-block:: shell
   :class: copyable

   [Unit]
   Description=MinIO
   Documentation=https://docs.min.io
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

The specified disk paths are provided as an example. Change them to match
the path to those disks intended for use by MinIO.

Alternatively, change the ``User`` and ``Group`` values to another user and
group on the system host with the necessary access and permissions.

MinIO publishes additional startup script examples on 
:minio-git:`github.com/minio/minio-service <minio-service>`.

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

.. start-install-minio-console-desc

Open your browser and access any of the MinIO hostnames at port ``:9001`` to
open the :ref:`MinIO Console <minio-console>` login page. For example,
``https://minio1.example.com:9001``.

Log in with the :guilabel:`MINIO_ROOT_USER` and :guilabel:`MINIO_ROOT_PASSWORD`
from the previous step.

.. image:: /images/minio-console/console-login.png
   :width: 600px
   :alt: MinIO Console Login Page
   :align: center

You can use the MinIO Console for general administration tasks like
Identity and Access Management, Metrics and Log Monitoring, or 
Server Configuration. Each MinIO server includes its own embedded MinIO
Console.

.. end-install-minio-console-desc

.. start-local-jbod-desc

MinIO strongly recommends direct-attached :abbr:`JBOD (Just a Bunch of Disks)`
arrays with XFS-formatted disks for best performance.  

- Direct-Attached Storage (DAS) has significant performance and consistency
  advantages over networked storage (NAS, SAN, NFS). 

- Deployments using non-XFS filesystems (ext4, btrfs, zfs) tend to have
  lower performance while exhibiting unexpected or undesired behavior.  

- RAID or similar technologies do not provide additional resilience or
  availability benefits when used with distributed MinIO deployments, and
  typically reduce system performance.

Ensure all nodes in the |deployment| use the same type (NVMe, SSD, or HDD)  of
drive with identical capacity (e.g. ``N`` TB) . MinIO does not distinguish drive
types and does not benefit from mixed storage types. Additionally. MinIO limits
the size used per disk to the smallest drive in the deployment. For example, if
the deployment has 15 10TB disks and 1 1TB disk, MinIO limits the per-disk
capacity to 1TB.

MinIO *requires* using expansion notation ``{x...y}`` to denote a sequential
series of disks when creating the new |deployment|, where all nodes in the
|deployment| have an identical set of mounted drives. MinIO also
requires that the ordering of physical disks remain constant across restarts,
such that a given mount point always points to the same formatted disk. MinIO
therefore **strongly recommends** using ``/etc/fstab`` or a similar file-based
mount configuration to ensure that drive ordering cannot change after a reboot.
For example:

.. code-block:: shell

   $ mkfs.xfs /dev/sdb -L DISK1
   $ mkfs.xfs /dev/sdc -L DISK2
   $ mkfs.xfs /dev/sdd -L DISK3
   $ mkfs.xfs /dev/sde -L DISK4

   $ nano /etc/fstab

     # <file system>  <mount point>  <type>  <options>         <dump>  <pass>
     LABEL=DISK1      /mnt/disk1     xfs     defaults,noatime  0       2
     LABEL=DISK2      /mnt/disk2     xfs     defaults,noatime  0       2
     LABEL=DISK3      /mnt/disk3     xfs     defaults,noatime  0       2
     LABEL=DISK4      /mnt/disk4     xfs     defaults,noatime  0       2

You can then specify the entire range of disks using the expansion notation
``/mnt/disk{1...4}``. If you want to use a specific subfolder on each disk,
specify it as ``/mnt/disk{1...4}/minio``.

MinIO **does not** support arbitrary migration of a drive with existing MinIO
data to a new mount position, whether intentional or as the result of OS-level
behavior.

.. end-local-jbod-desc

.. start-nondisruptive-upgrade-desc

MinIO strongly recommends restarting all nodes simultaneously. MinIO operations
are atomic and strictly consistent. As such the restart procedure is
non-disruptive to applications and ongoing operations.

Do **not** perform "rolling" (e.g. one node at a time) restarts.

.. end-nondisruptive-upgrade-desc