
.. _minio-restore-hardware-failure:

==============================
Recover after Hardware Failure
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO deployments rely on :ref:`Erasure Coding <minio-erasure-coding>` to provide built-in tolerance for multiple disk or node failures. 
Depending on the deployment topology and the selected erasure code parity, MinIO can tolerate the loss of up to half the drives or nodes in the deployment while maintaining read access ("read quorum") to objects. 

:ref:`Single-Node Single-Drive <minio-installation-comparison>` deployments are zero-parity and depend on the underlying storage volume to provide recovery. Ensure the storage volume has the necessary resiliency settings and defer to the tools or software associated to that volume for recovery.

The following table lists the typical types of failure in a MinIO deployment
and links to procedures for recovering from each:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Failure Type
     - Description

   * - :ref:`Drive Failure <minio-restore-hardware-failure-drive>`
     - MinIO supports hot-swapping failed drives with new healthy drives. 

   * - :ref:`Node Failure <minio-restore-hardware-failure-node>`
     - MinIO detects when a node rejoins the deployment and begins proactively healing the node shortly after it is joined back to the cluster
       healing data previously stored on that node.

Since MinIO can operate in a degraded state without significant performance
loss, administrators can schedule hardware replacement in proportion to the rate
of hardware failure. "Normal" failure rates (single drive or node failure) may
allow for a more reasonable replacement timeframe, while "critical" failure
rates (multiple drives or nodes) may require a faster response.

For nodes with one or more drives that are either partially failed or operating
in a degraded state (increasing disk errors, SMART warnings, timeouts in MinIO
logs, etc.), you can safely unmount the drive *if* the cluster has sufficient
remaining healthy drives to maintain
:ref:`read and write quorum <minio-ec-parity>`. Missing drives are less
disruptive to the deployment than drives that are reliably producing read and
write errors.

.. admonition:: MinIO Professional Support
   :class: note

   `MinIO SUBNET <https://min.io/pricing?jmp=docs>`__ users can
   `log in <https://subnet.min.io/>`__ and create a new issue related to drive
   or node failures. Coordination with MinIO Engineering via SUBNET can ensure
   successful recovery operations of production MinIO deployments, including
   root-cause analysis, and health diagnostics.

   Community users can seek support on the `MinIO Community Slack
   <https://minio.slack.com>`__. Community Support is best-effort only and has
   no SLAs around responsiveness.

.. _minio-restore-hardware-failure-drive:

Drive Failure Recovery
----------------------

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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Unmount each failed drive using ``umount``. For example, the following
command unmounts the drive at ``/dev/sdb``:

.. code-block:: shell

   umount /dev/sdb

2) Replace the failed drive(s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use ``mount -a`` to remount the drives unmounted at the beginning of this
procedure:

.. code-block:: shell
   :class: copyable

   mount -a

The command should result in remounting of all of the replaced drives.

5) Monitor MinIO for Drive Detection and Healing Status
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin console` command *or* ``journalctl -u minio`` for
``systemd``-managed installations to monitor the server log output after
remounting drives. The output should include messages identifying each formatted
and empty drive.

Use :mc-cmd:`mc admin heal` to monitor the overall healing status on the
deployment. MinIO aggressively heals replaced drive(s) to ensure rapid recovery
from the degraded state.

6) Next Steps
~~~~~~~~~~~~~

Monitor the cluster for any further drive failures. Some drive batches may fail
in close proximity to each other. Deployments seeing higher than expected drive
failure rates should schedule dedicated maintenance around replacing the known
bad batch. Consider using `MinIO SUBNET <https://min.io/pricing?jmp=docs>`__ to
coordinate with MinIO engineering around guidance for any such operations.

.. _minio-restore-hardware-failure-node:

Node Failure Recovery
---------------------

If a MinIO node suffers complete hardware failure (e.g. loss of all drives,
data, etc.), the node begins healing operations once it rejoins the deployment.
MinIO healing occurs only on the replaced hardware and does not typically impact
deployment performance.

MinIO healing ensures consistency and correctness of all data restored onto the
drive. **Do not** attempt to manually recover or migrate data from the failed
node onto the new healthy node.

The replacement node hardware should be substantially similar to the failed
node. There are no negative performance implications to using improved hardware.

The replacement drive hardware should be substantially similar to the failed
drive. For example, replace a failed SSD with another SSD drive of the same
capacity. While you can use drives with larger capacity, MinIO uses the
*smallest* drive's capacity as the ceiling for all drives in the 
:ref:`Server Pool <minio-intro-server-pool>`.

The following steps provide a more detailed walkthrough of node replacement.
These steps assume a MinIO deployment where each node has a DNS hostname 
as per the :ref:`documented prerequisites <minio-installation>`.

1) Start the Replacement Node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure the new node has received all necessary security, firmware, and OS
updates as per industry, regulatory, or organizational standards and
requirements.

The new node software configuration *must* match that of the other nodes in the
deployment, including but not limited to the OS and Kernel versions and
configurations. Heterogeneous software configurations may result in unexpected
or undesired behavior in the deployment.

2) Update Hostname for the New Node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Optional* This step is only required if the replacement node has a
different IP address from the failed host.

Ensure the hostname associated to the failed node now resolves to the new node.

For example, if ``https://minio-1.example.net`` previously resolved to the
failed host, it should now resolve to the new host.

3) Download and Prepare the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Follow the :ref:`deployment procedure <minio-installation>` to download
and run the MinIO server using a matching configuration as all other nodes
in the deployment.

- The MinIO server version *must* match across all nodes
- The MinIO service and environment file configurations *must* match across
  all nodes.

4) Rejoin the node to the deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Start the MinIO server process on the node and monitor the process output
using :mc-cmd:`mc admin console` or by monitoring the MinIO service logs
using ``journalctl -u minio`` for ``systemd`` managed installations.

The server output should indicate that it has detected the other nodes
in the deployment and begun healing operations.

Use :mc-cmd:`mc admin heal` to monitor overall healing status on the
deployment. MinIO aggressively heals the node to ensure rapid recovery
from the degraded state.

5) Next Steps
~~~~~~~~~~~~~

Continue monitoring the deployment until healing completes. Deployments with
persistent and repeated node failures should schedule dedicated maintenance to
identify the root cause. Consider using
`MinIO SUBNET <https://min.io/pricing?jmp=docs>`__ to coordinate with MinIO
engineering around guidance for any such operations.
