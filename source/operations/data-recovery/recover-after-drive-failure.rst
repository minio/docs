.. _minio-restore-hardware-failure-drive:

======================
Drive Failure Recovery
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports hot-swapping failed drives with new healthy drives. MinIO detects
and heals those drives without requiring any node or deployment-level restart.
MinIO healing occurs only on the replaced drive(s) and does not typically impact
deployment performance.

MinIO healing ensures consistency and correctness of all data restored onto the
drive. **Do not** attempt to manually recover or migrate data from the failed
drive onto the new healthy drive.

The following steps provide a more detailed walkthrough of drive replacement.
These steps assume a MinIO deployment where each node manages drives using
``/etc/fstab`` with per-drive labels as per the
:ref:`documented prerequisites <minio-installation>`.

1) Unmount the failed drive(s)
------------------------------

Unmount each failed drive using ``umount``. For example, the following
command unmounts the drive at ``/dev/sdb``:

.. code-block:: shell

   umount /dev/sdb

2) Replace the failed drive(s)
------------------------------

Remove the failed drive(s) from the node hardware and replace it with known
healthy drive(s). Replacement drives *must* meet the following requirements:

- :ref:`XFS formatted <deploy-minio-distributed-prereqs-storage>` and empty.
- Same drive type (e.g. HDD, SSD, NVMe).
- Equal or greater performance.
- Equal or greater capacity.

Using a replacement drive with greater capacity does not increase the total
cluster storage. MinIO uses the *smallest* drive's capacity as the ceiling for
all drives in the :ref:`Server Pool <minio-intro-server-pool>`.

The following command formats a drive as XFS and assigns it a label to match
the failed drive.

.. code-block:: shell

   mkfs.xfs /dev/sdb -L DISK1

MinIO **strongly recommends** using label-based mounting to ensure consistent
drive order that persists through system restarts.

3) Review and Update ``fstab``
------------------------------

Review the ``/etc/fstab`` file and update as needed such that the entry for
the failed disk points to the newly formatted replacement.

- If using label-based disk assignment, ensure that each label points to the
  correct newly formatted disk.

- If using UUID-based disk assignment, update the UUID for each point based on
  the newly formatted disk. You can use ``lsblk`` to view disk UUIDs.

For example, consider 

.. code-block:: shell

   $ cat /etc/fstab

     # <file system>  <mount point>  <type>  <options>         <dump>  <pass>
     LABEL=DISK1      /mnt/disk1     xfs     defaults,noatime  0       2
     LABEL=DISK2      /mnt/disk2     xfs     defaults,noatime  0       2
     LABEL=DISK3      /mnt/disk3     xfs     defaults,noatime  0       2
     LABEL=DISK4      /mnt/disk4     xfs     defaults,noatime  0       2

Given the previous example command, no changes are required to 
``fstab`` since the replacement disk at ``/mnt/disk1`` uses the same
label ``DISK1`` as the failed disk.

4) Remount the Replaced Drive(s)
--------------------------------

Use ``mount -a`` to remount the drives unmounted at the beginning of this
procedure:

.. code-block:: shell
   :class: copyable

   mount -a

The command should result in remounting of all of the replaced drives.

5) Monitor MinIO for Drive Detection and Healing Status
-------------------------------------------------------

Use :mc-cmd:`mc admin console` command *or* ``journalctl -u minio`` for
``systemd``-managed installations to monitor the server log output after
remounting drives. The output should include messages identifying each formatted
and empty drive.

Use :mc-cmd:`mc admin heal` to monitor the overall healing status on the
deployment. MinIO aggressively heals replaced drive(s) to ensure rapid recovery
from the degraded state.

6) Next Steps
-------------

Monitor the cluster for any further drive failures. Some drive batches may fail
in close proximity to each other. Deployments seeing higher than expected drive
failure rates should schedule dedicated maintenance around replacing the known
bad batch. Consider using `MinIO SUBNET <https://min.io/pricing?jmp=docs>`__ to
coordinate with MinIO engineering around guidance for any such operations.