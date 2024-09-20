==============
``mc license``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc license


Description
-----------

.. start-mc-license-desc

The :mc:`mc license` commands work with cluster registration for |SUBNET|. 
Use the commands to register a deployment, display information about the cluster's current license, or update the license key for a cluster.

.. end-mc-license-desc

Subcommands
-----------

:mc:`mc license` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc license info`
     - .. include:: /reference/minio-mc/mc-license-info.rst
          :start-after: start-mc-license-info-desc
          :end-before: end-mc-license-info-desc

   * - :mc:`~mc license register`
     - .. include:: /reference/minio-mc/mc-license-register.rst
          :start-after: start-mc-license-register-desc
          :end-before: end-mc-license-register-desc


.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-license-info
   /reference/minio-mc/mc-license-register