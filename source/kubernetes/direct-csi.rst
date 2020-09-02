==============================================
MinIO Direct Container Storage Interface (CSI)
==============================================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2

Overview
--------

The MinIO Direct Container Storage Interface (CSI) plugin for Kubernetes
supports dynamically creating Persistent Volumes (``PV``) from disks attached to
a :kube-docs:`Node <concepts/architecture/nodes/>`. The Direct CSI plugin is
ideally suited for MinIO deployments on Kubernetes clusters running on
bare-metal with JBOD (Just a Bunch of Disks) storage. 

The Direct CSI plugin requires specifying the path to drives on each node in the
Kubernetes cluster. The Direct CSI plugin assumes that all nodes in the cluster
use consistent paths for locally-attached drives. The plugin does not
support arbitary file paths per node.

For example, consider a Kubernetes cluster with four nodes, where each node
has four locally-attached disks.

<diagram>

The :doc:`MinIO Kubernetes Plugin </kubernetes/kubectl-plugin-reference>` 
creates a MinIO tenant using Direct CSI volumes:

<diagram>

The Direct CSI plugin responds to each ``PVC`` request by dynamically generating
a matching ``PV`` using a disk on the node that runs the ``minio`` server pod.

<diagram>

For more information on Direct CSI ``PV`` generation, see
:ref:`minio-direct-csi-persistent-volume-generation`.

The MinIO documentation focuses on guidance and reference material related to
using the MinIO Direct CSI plugin. The documentation makes a best effort to
summarize or link to Kubernetes-specific concepts and resources, and is neither
intended nor designed to replace Kubernetes-centric documentation. For more
complete information on the Container Storage Interface, see the Kubernetes
:kube-docs:`Container Storage Interface <concepts/storage/volumes/#csi>`
documentation.

Quickstart
----------

The following command performs a ``kustomize``-based installation of the MinIO
Direct CSI plugin using the default ``kubectl`` context. The command includes
environment variables that set the location of the locally-attached disks on
each node in the Kubernetes cluster. The plugin uses the environment variables
to identify the location of the physical disks on each node.

.. code-block:: shell
   :class: copyable

   DIRECT_CSI_DRIVES_DIR=/mnt \
   DIRECT_CSI_DRIVES=data{1...4} \
   kubectl apply -k github.com/minio/direct-csi

The command sets the following environment variables for use with the 
``kustomize`` installation:

- :data:`DIRECT_CSI_DRIVES_DIR` specifies the root directory of the
  drives which the Direct CSI plugin uses when creating Persistent Volumes
  (``PV``).

- :data:`DIRECT_CSI_DRIVES` specifies the path to the drive(s) which the
  Direct CSI plugin uses for creating Persistent Volumes (``PV``).

The example command creates the following four ``PV`` on each node in the
cluster:

- ``/mnt/data1``
- ``/mnt/data2``
- ``/mnt/data3``
- ``/mnt/data4``

When creating a Persistent Volume Claim (``PVC``), specify ``direct.csi.min.io``
as the ``spec.storageClassName`` to use the created ``PV``. 

If using the 
:doc:`MinIO Kubernetes Plugin </kubernetes/kubectl-plugin-reference>`, 
specify ``direct.csi.min.io`` as the 
:mc-cmd:`--storageclass <kubectl minio tenant create storageclass>`.

.. important::

   The Direct CSI plugin assumes that all nodes in the Kubernetes cluster
   use consistent paths for locally-attached drives. You cannot specify arbitary
   paths per node using the Direct CSI plugin.

Use Direct CSI with MinIO Kubernetes Operator
---------------------------------------------

The :doc:`MinIO Kubernetes Operator </kubernetes/operator-reference>` uses the
``spec.volumeClaimTemplate`` object to generate the required Persistant
Volume Claims (``PVC``) for the MinIO tenant. To direct the operator
to generate ``PVC`` using Direct CSI volumes, set
``spec.zones.volumeClaimTemplate.storageClassName`` to ``direct.csi.min.io``.

For a complete procedure on using the MinIO Kubernetes Operator to create a
MinIO tenant that uses Direct CSI volumes, see :ref:`todo`.

Use Direct CSI with MinIO Kubernetes Plugin
-------------------------------------------

The :doc:`MinIO Kubernetes Plugin </kubernetes/kubectl-plugin-reference>`
(``kubectl-minio``) wraps the MinIO Kubernetes Operator (``operator``) and
provides a simple interface through ``kubectl`` for deploying and managing MinIO
resources. To use Direct CSI volumes when creating a MinIO tenant with the
``kubectl-minio`` plugin, include the 
:mc-cmd:`--storageclass <kubectl minio tenant create storageclass>` option as
part of the :mc-cmd:`kubectl minio tenant create` command.

For a complete procedure on using ``kubectl-minio`` to create a MinIO tenant
that uses Direct CSI volumes, see :ref:`minio-kubectl-minio-create-tenant`.

.. _minio-direct-csi-persistent-volume-generation:

Persistent Volume Generation
----------------------------

The Direct CSI plugin dynamically generates a Persistent Volume (``PV``)
to satisfy any Persistent Volume Claim (``PVC``) requesting a 
Direct CSI volume (``storageClasName: direct.csi.min.io``).

The Direct CSI plugin configuration includes the path to one or more disks on
:kube-docs:`Nodes <concepts/architecture/nodes/>` in the Kubernetes cluster.
When the plugin detects a pod ``PVC`` requesting a Direct ``PV``, the plugin
performs a round-robin selection of the available disks on the node running the
pod. The plugin creates a subfolder on the selected disk to serve as the root
for the new ``PV``.

The plugin continues the round-robin selection process until it can find a disk
with enough capacity to satisfy the ``PVC`` request. If no disk has sufficient
capacity, the pod making the ``PVC`` request may fail to start as the requested
volume remains unsatisfied.

The plugin supports creating multiple ``PV`` on a single disk, where each
``PV`` gets a unique subfolder on that disk. While the ideal ratio of 
``PV`` to disk is 1:1, the plugin only limits ``PV`` creation to the total
available storage for disk. 

For example, consider a 1``Ti`` drive. The plugin can generate any number of
``PV`` subfolders on that drive in response to ``PVC`` requests up to the
capacity of the drive. However, deployments that exceed the 1:1 ratio have
increased failure risk as the loss of a single physical drive in turn disables
multiple virtual volumes.

.. _minio-direct-csi-k8s-scheduler:

Direct CSI Volumes Support Local Access Only
--------------------------------------------

Direct ``PVC`` volumes only support access from pods on the same node as the
``PV`` disk. If a pod moves to a different node, it cannot access the existing
``PVC`` volumes *even if* those volumes are otherwise available on the node.
Furthermore, the Direct CSI plugin *rejects* any ``PVC`` requests from the node
until an administrator removes the original ``PVC`` and corresponding ``PV``
resources.

Add or Remove Disks from the Direct CSI Plugin
----------------------------------------------

ToDo: Procedure for adding or removing disks from the Direct CSI plugin.

Syntax
------

The MinIO Direct CSI supports the following arguments:

.. data:: DIRECT_CSI_DRIVES_DIR

   The root path to the locally-attached disks which the Direct CSI plugin
   uses when creating Persistent Volumes (``PV``).

   Each node in the Kubernetes cluster *must* use a consistent root path for the
   Direct CSI plugin to function predictably.
   
   Defaults to ``/mnt``. 

.. data:: DIRECT_CSI_DRIVES

   The path to the drives which the Direct CSI plugin uses when creating 
   Persistent Volumes (``PV``).

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



