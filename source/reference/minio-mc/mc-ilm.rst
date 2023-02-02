==========
``mc ilm``
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm


Description
-----------

.. start-mc-ilm-desc

The :mc:`mc ilm` commands manage :ref:`object lifecycle management rules <minio-lifecycle-management>` and tiering on a MinIO deployment. 

.. end-mc-ilm-desc

Use these command to 

- create tiers
- create :ref:`tiering <minio-lifecycle-management-tiering>` rules
- manage :ref:`expiration <minio-lifecycle-management-expiration>` rules for objects on a bucket
     

Subcommands
-----------

:mc:`mc ilm` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc ilm restore`
     - .. include:: /reference/minio-mc/mc-ilm-restore.rst
          :start-after: start-mc-ilm-restore-desc
          :end-before: end-mc-ilm-restore-desc

   * - :mc:`~mc ilm rule`
     - .. include:: /reference/minio-mc/mc-ilm-rule.rst
          :start-after: start-mc-ilm-rule-desc
          :end-before: end-mc-ilm-rule-desc

   * - :mc:`~mc ilm tier`
     - .. include:: /reference/minio-mc/mc-ilm-tier.rst
          :start-after: start-mc-ilm-tier-desc
          :end-before: end-mc-ilm-tier-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-ilm-restore
   /reference/minio-mc/mc-ilm-rule
   /reference/minio-mc/mc-ilm-tier
