=========================
``mc admin replicate``
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin replicate

Description
-----------

.. start-mc-admin-replicate-desc

The :mc:`mc admin replicate` command creates and manages :ref:`site replication <minio-site-replication-overview>` for a set of MinIO peer sites.

Where :ref:`bucket replication <minio-bucket-replication>` can manage the mirroring of particular buckets or objects from one location to another within a deployment or across deployments, site replication continuously mirrors an entire MinIO site to other sites.

Site replication mimics an active-active bucket replication, but for multiple MinIO sites.
On whichever site a data change occurs, the change replicates across all sites in the site replication group.

.. end-mc-admin-replicate-desc

:mc:`mc admin replicate` only supports site replication for distributed deployments across multiple sites.

Site replication requires that bucket versioning be enabled.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

The :mc:`mc admin replicate` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc admin replicate add`
     - Adds one or more sites for replication

   * - :mc-cmd:`mc admin replicate edit`
     - Edits the endpoint of a site participating in cluster replication

   * - :mc-cmd:`mc admin replicate remove`
     - Removes one or more sites from site replication

   * - :mc-cmd:`mc admin replicate info`
     - Returns information about site replication

   * - :mc-cmd:`mc admin replicate status`
     - Displays site replication status

Syntax
------

Flags
-----

.. code-block:: shell

   --config-dir value, -C value  path to configuration folder (default: "/Users/<user>/.mc")
   --quiet, -q                   disable progress bar display
   --no-color                    disable color theme
   --json                        enable JSON lines formatted output
   --debug                       enable debug output
   --insecure                    disable SSL certificate verification
   --help, -h                    show help



Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals