===============================
``mc admin prometheus metrics``
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin prometheus metrics

Starting with MinIO Server :minio-release:`RELEASE.2024-07-15T19-02-30Z` and MinIO Client :mc-release:`RELEASE.2024-07-11T18-01-28Z`, metrics :ref:`version 3 (v3) <minio-metrics-and-alerts>` replaces the deprecated :ref:`version 2 (v2) <minio-metrics-v2>`.

Description
-----------

.. start-mc-admin-prometheus-metrics-desc

The :mc:`mc admin prometheus metrics` command prints Prometheus metrics for a cluster.

.. end-mc-admin-prometheus-metrics-desc

The output includes additional information about each metric, such as if its value is a ``counter`` or ``gauge``.

For more complete documentation on using MinIO with Prometheus, see :ref:`How to monitor MinIO server with Prometheus <minio-metrics-collect-using-prometheus>`

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command prints cluster metrics from the deployment at :term:`alias` ``myminio``:

      .. code-block:: shell
         :class: copyable

         mc admin prometheus metrics play cluster --api-version v3

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin prometheus metrics  \
                                           ALIAS                                           \
                                           [TYPE]                                          \
                                           [--api_version v3]                              \
                                           [TYPE --bucket <bucket name> --api_version v3]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc:`alias <mc alias>` of a configured MinIO deployment for which the command prints metrics.

.. mc-cmd:: --api-version
   :optional:

   To print :ref:`version 3 (v3) <minio-metrics-and-alerts>` metrics, include an ``--api-version v3`` parameter.
   ``v3`` is the only accepted value.

   Omit ``--api-version`` to print :ref:`version 2 (v2) <minio-metrics-v2>` metrics.

.. mc-cmd:: --bucket
   :optional:

   For v3 metric types that return bucket-level metrics, specify a bucket name.
   Use with :mc-cmd:`~mc admin prometheus metrics --api-version`.

   ``--bucket`` works for the following v3 metric types:

   - ``api``
   - ``replication``

   The following example prints API metrics for the bucket ``mybucket``:

   .. code-block:: shell
      :class: copyable

      mc admin prometheus metrics ALIAS api --bucket mybucket --api-version v3

.. mc-cmd:: TYPE
   :optional:

   The type of metrics to print.

      Valid values for metrics version 3 are:

      - ``api``
      - ``audit``
      - ``cluster``
      - ``debug``
      - ``ilm``
      - ``logger``
      - ``notification``
      - ``replication``
      - ``scanner``
      - ``system``

      If not specified, a ``v3`` command returns all metrics.

      Valid values for metrics version 2 are:

      - ``bucket``
      - ``cluster``
      - ``node``
      - ``resource``

      If not specified, a ``v2`` command returns cluster metrics.
      Cluster metrics also include rollups of certain node metrics.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Example
-------

Print v3 metrics
~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin prometheus metrics --api-version v3 <mc admin prometheus metrics --api-version>` to print all available v3 metrics and their current values for a MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin prometheus metrics ALIAS --api-version v3

- Replace ``ALIAS`` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

To print a specific type of metrics, include the :mc-cmd:`~mc admin prometheus metrics TYPE`.
The following prints all scanner metrics for a deployment:

.. code-block:: shell
   :class: copyable

   mc admin prometheus metrics ALIAS scanner --api-version v3


Print v3 bucket replication metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Certain metric types accept a :mc-cmd:`~mc admin prometheus metrics --bucket` parameter to specify the bucket for which to print metrics.
The following example prints v3 replication metrics for bucket ``mybucket``:

.. code-block:: shell
   :class: copyable

   mc admin prometheus metrics ALIAS replication --bucket mybucket --api-version v3

- Replace ``ALIAS`` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

To print API metrics for a bucket, replace ``replication`` with ``api``.


Print v2 metrics
~~~~~~~~~~~~~~~~

By default, :mc-cmd:`mc admin prometheus metrics` prints v2 cluster metrics:

.. code-block:: shell
   :class: copyable

   mc admin prometheus metrics ALIAS

- Replace ``ALIAS`` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

To print another type of metrics, specify the desired :mc-cmd:`~mc admin prometheus metrics TYPE`.
The following example prints v2 bucket metrics:

.. code-block:: shell
   :class: copyable

   mc admin prometheus metrics ALIAS bucket
