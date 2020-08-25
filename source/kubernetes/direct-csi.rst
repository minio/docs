==============================================
MinIO Direct Container Storage Interface (CSI)
==============================================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2

Overview
--------

The MinIO Direct Container Storage Interface (CSI) driver for Kubernetes
supports creating Persistant Volumes (``PV``) from disks attached to a 
:kube-docs:`Node <concepts/architecture/nodes/>`. The
:doc:`MinIO Kubernetes Operator </kubernetes/operator-reference>` and
:doc:`MinIO Kubernetes Plugin </kubernetes/kubectl-plugin-reference>`
support using MinIO Direct CSI volumes when creating or expanding
MinIO deployments. 

Complete documentation on the :kube-docs:`Container Storage Interface
<concepts/storage/volumes/#csi>` is out of scope for this documentation. 
The MinIO documentation focuses on guidance and reference material related
to using the MinIO Direct CSI plugin. The documentation makes a best effort
to summarize or link to Kubernetes-specific concepts and resources, and is
neither intended nor designed to replace Kubernetes-centric documentation.

.. TODO: Compare/Contrast Direct CSI vs ``local`` and other volume types.

Quickstart
----------

The following command configures and deploys the MinIO Direct CSI plugin on a
Kubernetes cluster.

.. code-block:: shell
   :class: copyable

   DIRECT_CSI_DRIVES_DIR=/mnt \
   DIRECT_CSI_DRIVES=data{1...4} \
   kubectl apply -k github.com/minio/direct-csi

- :data:`DIRECT_CSI_DRIVES_DIR` specifies the root directory of the
  drives which the Direct CSI plugin uses when creating Persistant Volumes
  (``PV``).

- :data:`DIRECT_CSI_DRIVES` specifies the path to the drive(s) which the
  Direct CSI plugin uses for creating Persistant Volumes (``PV``).

The example command creates the following four ``PV`` on each node in the
cluster:

- ``/mnt/data1``
- ``/mnt/data2``
- ``/mnt/data3``
- ``/mnt/data4``

When creating a Persistant Volume Claim (``PVC``), specify ``direct.csi.min.io``
as the ``spec.storageClassName`` to use the created ``PV``. 

If using the 
:doc:`MinIO Kubernetes Plugin </kubernetes/kubectl-plugin-reference>`, 
specify ``direct.csi.min.io`` as the 
:mc-cmd:`--storageclass <kubectl minio tenant create storageclass>`.

.. important::

   The Direct CSI driver assumes that all nodes in the Kubernetes cluster
   use consistent paths for locally-attached drives. You cannot specify arbitary
   paths per node using the Direct CSI driver.

Syntax
------

The MinIO Direct CSI supports the following arguments:

.. data:: DIRECT_CSI_DRIVES_DIR

   The root path to the locally-attached disks which the Direct CSI plugin
   uses when creating Persistant Volumes (``PV``).

   Each node in the Kubernetes cluster *must* use a consistent root path for the
   Direct CSI plugin to function predictably.
   
   Defaults to ``/mnt``. 

.. data:: DIRECT_CSI_DRIVES

   The path to the drives which the Direct CSI plugin uses when creating 
   Persistant Volumes (``PV``).

   The Direct CSI plugin prepends the :data:`DIRECT_CSI_DRIVES_DIR` to the
   specified path to construct the full path to the disk or folder on disk.

   :data:`DIRECT_CSI_DRIVES` supports the expansion format where 
   ``{{x...y}}`` expands to the series of integers between ``x`` and ``y``
   inclusive. The following table lists example values to
   ``DIRECT_CSI_DRIVES`` and the resulting disk paths. The table assumes
   the default value of :data:`DIRECT_CSI_DRIVES_DIR`.

   .. list-table::
      :stub-columns: 1
      :widths: 40 60
      :width: 100%

      * - .. code-block:: shell
             :class: copyable

             DIRECT_CSI_DRIVES=disk1

        - ``/mnt/disk1``

      * - .. code-block:: shell
             :class: copyable

             DIRECT_CSI_DRIVES={disk1...4}

        - - ``/mnt/disk1``
          - ``/mnt/disk2``
          - ``/mnt/disk3``
          - ``/mnt/disk4``

      * - .. code-block:: shell
             :class: copyable

             DIRECT_CSI_DRIVES={disk1...4/data/}

        - - ``/mnt/disk1/data/``
          - ``/mnt/disk2/data/``
          - ``/mnt/disk3/data/``
          - ``/mnt/disk4/data/``



