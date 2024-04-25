.. _minio-restore-hardware-failure-node:

=====================
Node Failure Recovery
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

If a MinIO node suffers complete hardware failure (e.g. loss of all drives,
data, etc.), the node begins healing operations once it rejoins the deployment.
MinIO healing occurs only on the replaced hardware and does not typically impact
deployment performance.

MinIO healing ensures consistency and correctness of all data restored onto the
drive.

.. include:: /includes/common-admonitions.rst
   :start-after: start-exclusive-drive-access
   :end-before: end-exclusive-drive-access

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
-----------------------------

Ensure the new node has received all necessary security, firmware, and OS
updates as per industry, regulatory, or organizational standards and
requirements.

The new node software configuration *must* match that of the other nodes in the
deployment, including but not limited to the OS and Kernel versions and
configurations. Heterogeneous software configurations may result in unexpected
or undesired behavior in the deployment.

2) Update Hostname for the New Node
-----------------------------------

*Optional* This step is only required if the replacement node has a
different IP address from the failed host.

Ensure the hostname associated to the failed node now resolves to the new node.

For example, if ``https://minio-1.example.net`` previously resolved to the
failed host, it should now resolve to the new host.

3) Download and Prepare the MinIO Server
----------------------------------------

Follow the :ref:`deployment procedure <minio-installation>` to download
and run the MinIO server using a matching configuration as all other nodes
in the deployment.

- The MinIO server version *must* match across all nodes
- The MinIO service and environment file configurations *must* match across
  all nodes.

4) Rejoin the node to the deployment
------------------------------------

Start the MinIO server process on the node and monitor the process output
using :mc:`mc admin console` or by monitoring the MinIO service logs
using ``journalctl -u minio`` for ``systemd`` managed installations.

The server output should indicate that it has detected the other nodes
in the deployment and begun healing operations.

Use :mc:`mc admin heal` to monitor overall healing status on the
deployment. MinIO aggressively heals the node to ensure rapid recovery
from the degraded state.

5) Next Steps
-------------

Continue monitoring the deployment until healing completes. Deployments with
persistent and repeated node failures should schedule dedicated maintenance to
identify the root cause. Consider using
`MinIO SUBNET <https://min.io/pricing?jmp=docs>`__ to coordinate with MinIO
engineering around guidance for any such operations.
