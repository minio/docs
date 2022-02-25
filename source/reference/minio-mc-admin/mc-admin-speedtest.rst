======================
``mc admin speedtest``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin speedtest

Description
-----------

.. start-mc-admin-speedtest-desc

The :mc-cmd:`mc admin speedtest` command tests throughputs per host with ``PUT`` 
and ``GET`` operations. 

.. end-mc-admin-speedtest-desc

:mc-cmd:`~mc admin speedtest` is available starting with ``mc``
:mc-release:`RELEASE.2021-09-02T09-21-27Z` and supports distributed MinIO
deployments running :minio-release:`RELEASE.2021-07-30T00-02-00Z` or later.

:mc-cmd:`~mc admin speedtest` does not support standalone or MinIO Gateway
deployments.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Syntax
------

:mc-cmd:`mc admin speedtest` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin speedtest [FLAGS] TARGET

:mc-cmd:`mc admin speedtest` supports the following arguments:

.. mc-cmd:: TARGET

   *Required*

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment to run the speedtest against.

.. mc-cmd:: --duration
   

   The duration the entire speedtests are run. Defaults to ``10s``.

.. mc-cmd:: --size
   

   The size of the objects used for uploads/downloads. Defaults to ``64MiB``.

.. mc-cmd:: --concurrent
   

   The number of concurrent requests per server. Defaults to ``32``.
