.. start-install-minio-binary-desc

The following tabs provide examples of installing MinIO onto 64-bit Linux operating systems using RPM, DEB, or binary.
The RPM and DEB packages automatically install MinIO to the necessary system paths and create a ``minio`` service for ``systemctl``.
MinIO strongly recommends using the RPM or DEB installation routes.
To update deployments managed using ``systemctl``, see :ref:`minio-upgrade-systemctl`.

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

The following tabs provide examples of updating MinIO onto 64-bit Linux operating systems using RPM, DEB, or binary executable.

For infrastructure managed by tools such as Ansible or Terraform, defer to your internal procedures for updating packages or binaries across multiple managed hosts.

.. tab-set::

   .. tab-item:: RPM (RHEL)
      :sync: rpm

      Use the following commands to download the latest stable MinIO RPM and
      update the existing installation.

      .. code-block:: shell
         :class: copyable
         :substitutions:

         curl |minio-rpm| -O minio.rpm
         sudo dnf update minio.rpm

   .. tab-item:: DEB (Debian/Ubuntu)
      :sync: deb

      Use the following commands to download the latest stable MinIO DEB and
      upgrade the existing installation:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         curl |minio-deb| -O minio.deb
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

- Place TLS certificates into ``/home/minio-user/.minio/certs`` on each host.

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

.. start-local-jbod-single-node-desc

MinIO strongly recommends direct-attached :abbr:`JBOD (Just a Bunch of Disks)`
arrays with XFS-formatted disks for best performance.
Using any other type of backing storage (SAN/NAS, ext4, RAID, LVM) typically results in a reduction in performance, reliability, predictability, and consistency.

Ensure all server drives for which you intend MinIO to use are of the same type (NVMe, SSD, or HDD) with identical capacity (e.g. ``12`` TB).
MinIO does not distinguish drive types and does not benefit from mixed storage types. 
Additionally. MinIO limits the size used per drive to the smallest drive in the deployment. 
For example, if the deployment has 15 10TB drives and 1 1TB drive, MinIO limits the per-drive capacity to 1TB.

MinIO *requires* using expansion notation ``{x...y}`` to denote a sequential series of drives when creating the new |deployment|, where all nodes in the |deployment| have an identical set of mounted drives. 
MinIO also requires that the ordering of physical drives remain constant across restarts, such that a given mount point always points to the same formatted drive. 
MinIO therefore **strongly recommends** using ``/etc/fstab`` or a similar file-based mount configuration to ensure that drive ordering cannot change after a reboot.
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

.. note:: 

   Cloud environment instances which depend on mounted external storage may encounter boot failure if one or more of the remote file mounts return errors or failure.
   For example, an AWS ECS instances with mounted persistent EBS volumes may fail to boot with the standard ``/etc/fstab`` configuration if one or more EBS volumes fail to mount.

   You can set the ``nofail`` option to silence error reporting at boot and allow the instance to boot with one or more mount issues.
   
   You should not use this option on systems which have locally attached disks, as silencing drive errors prevents both MinIO and the OS from responding to those errors in a normal fashion.

You can then specify the entire range of drives using the expansion notation ``/mnt/disk{1...4}``. 
If you want to use a specific subfolder on each drive, specify it as ``/mnt/disk{1...4}/minio``.

MinIO **does not** support arbitrary migration of a drive with existing MinIO data to a new mount position, whether intentional or as the result of OS-level behavior.

.. end-local-jbod-single-node-desc

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
the size used per drive to the smallest drive in the deployment. For example, if
the deployment has 15 10TB drives and 1 1TB drive, MinIO limits the per-drive
capacity to 1TB.

MinIO *requires* using expansion notation ``{x...y}`` to denote a sequential
series of drives when creating the new |deployment|, where all nodes in the
|deployment| have an identical set of mounted drives. MinIO also
requires that the ordering of physical drives remain constant across restarts,
such that a given mount point always points to the same formatted drive. MinIO
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

You can then specify the entire range of drives using the expansion notation
``/mnt/disk{1...4}``. If you want to use a specific subfolder on each drive,
specify it as ``/mnt/disk{1...4}/minio``.

MinIO **does not** support arbitrary migration of a drive with existing MinIO
data to a new mount position, whether intentional or as the result of OS-level
behavior.

.. note:: 

   Cloud environment instances which depend on mounted external storage may encounter boot failure if one or more of the remote file mounts return errors or failure.
   For example, an AWS ECS instances with mounted persistent EBS volumes may fail to boot with the standard ``/etc/fstab`` configuration if one or more EBS volumes fail to mount.

   You can set the ``nofail`` option to silence error reporting at boot and allow the instance to boot with one or more mount issues.
   
   You should not use this option on systems which have locally attached disks, as silencing drive errors prevents both MinIO and the OS from responding to those errors in a normal fashion.


.. end-local-jbod-desc

.. start-nondisruptive-upgrade-desc

MinIO strongly recommends restarting all MinIO Server processes in a deployment simultaneously. 
MinIO operations are atomic and strictly consistent. 
As such the restart procedure is non-disruptive to applications and ongoing operations.

Do **not** perform "rolling" (e.g. one node at a time) restarts.

.. end-nondisruptive-upgrade-desc
