.. _minio-restore-hardware-failure:

==============================
Recover after Hardware Failure
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Distributed MinIO deployments rely on :ref:`Erasure Coding
<minio-erasure-coding>` to provide built-in tolerance for multiple drive or node
failures. Depending on the deployment topology and the selected erasure code
parity, MinIO can tolerate the loss of up to half the drives or nodes in the
deployment while maintaining read access ("read quorum") to objects. 

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
     - MinIO detects when a node rejoins the deployment and begins proactively healing the node shortly after it is joined back to the cluster healing data previously stored on that node.

   * - :ref:`Site Failure <minio-restore-hardware-failure-site>`
     - MinIO Site Replication supports complete resynchronization of buckets, objects, and replication-eligible configuration settings after total site loss.

Since MinIO can operate in a degraded state without significant performance
loss, administrators can schedule hardware replacement in proportion to the rate
of hardware failure. "Normal" failure rates (single drive or node failure) may
allow for a more reasonable replacement timeframe, while "critical" failure
rates (multiple drives or nodes) may require a faster response.

For nodes with one or more drives that are either partially failed or operating
in a degraded state (increasing drive errors, SMART warnings, timeouts in MinIO
logs, etc.), you can safely unmount the drive *if* the cluster has sufficient
remaining healthy drives to maintain
:ref:`read and write quorum <minio-ec-parity>`. Missing drives are less
disruptive to the deployment than drives that are reliably producing read and
write errors.

.. admonition:: MinIO Professional Support
   :class: note

   `MinIO SUBNET <https://min.io/pricing?jmp=docs>`__ users can
   `log in <https://subnet.min.io/>`__ and create a new issue related to drive, node, or site failures. 
   Coordination with MinIO Engineering via SUBNET can ensure successful recovery operations of production MinIO deployments, including root-cause analysis, and health diagnostics.

   Community users can seek support on the `MinIO Community Slack <https://slack.min.io>`__. 
   Community Support is best-effort only and has no SLAs around responsiveness.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/data-recovery/recover-after-drive-failure
   /operations/data-recovery/recover-after-node-failure
   /operations/data-recovery/recover-after-site-failure