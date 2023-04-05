==============
``mc support``
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc support


Description
-----------

.. start-mc-support-desc

The MinIO Client :mc:`mc support` commands provides tools for analyzing deployment health or performance and for running diagnostics.
You can also upload generated health reports for further analysis by MinIO engineering.

.. end-mc-support-desc

.. important::

   The ``mc support`` commands require an active |SUBNET| registration.
   
   :mc-cmd:`mc support proxy set` and :mc-cmd:`mc support proxy remove` are exceptions, as you may need to set up a proxy to complete the deployment registration.


Subcommands
-----------

:mc:`mc support` includes the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Subcommand
     - Description

   * - :mc:`~mc support callhome`
     - .. include:: /reference/minio-mc/mc-support-callhome.rst
          :start-after: start-mc-support-callhome-desc
          :end-before: end-mc-support-callhome-desc

   * - :mc:`~mc support diag`
     - .. include:: /reference/minio-mc/mc-support-diag.rst
          :start-after: start-mc-support-diag-desc
          :end-before: end-mc-support-diag-desc

   * - :mc:`~mc support inspect`
     - .. include:: /reference/minio-mc/mc-support-inspect.rst
          :start-after: start-mc-support-inspect-desc
          :end-before: end-mc-support-inspect-desc

   * - :mc:`~mc support perf`
     - .. include:: /reference/minio-mc/mc-support-perf.rst
          :start-after: start-mc-support-perf-desc
          :end-before: end-mc-support-perf-desc

   * - :mc:`~mc support profile`
     - .. include:: /reference/minio-mc/mc-support-profile.rst
          :start-after: start-mc-support-profile-desc
          :end-before: end-mc-support-profile-desc

   * - :mc:`~mc support proxy`
     - .. include:: /reference/minio-mc/mc-support-proxy.rst
          :start-after: start-mc-support-proxy-desc
          :end-before: end-mc-support-proxy-desc

   * - :mc:`~mc support top`
     - .. include:: /reference/minio-mc/mc-support-top.rst
          :start-after: start-mc-support-top-desc
          :end-before: end-mc-support-top-desc

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-support-callhome
   /reference/minio-mc/mc-support-diag
   /reference/minio-mc/mc-support-inspect
   /reference/minio-mc/mc-support-perf
   /reference/minio-mc/mc-support-profile
   /reference/minio-mc/mc-support-proxy
   /reference/minio-mc/mc-support-top