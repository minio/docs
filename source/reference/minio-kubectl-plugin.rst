:orphan:

.. _minio-kubectl-plugin:

=======================
MinIO Kubernetes Plugin
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

MinIO is a high performance distributed object storage server, designed for
large-scale private cloud infrastructure. Orchestration platforms like
Kubernetes provide perfect cloud-native environment to deploy and scale MinIO.
The :minio-git:`MinIO Kubernetes Operator </minio-operator>` brings native MinIO
support to Kubernetes. 

The :mc:`kubectl minio` plugin brings native support for deploying MinIO
tenants to Kubernetes clusters using the ``kubectl`` CLI. You can use
:mc:`kubectl minio` to deploy a MinIO tenant with little to no interaction
with ``YAML`` configuration files. 

.. image:: /images/Kubernetes-Minio.svg
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: Kubernetes Orchestration with the MinIO Operator facilitates automated deployment of MinIO clusters.

:mc:`kubectl minio` builds its interface on top of the
MinIO Kubernetes Operator. Visit the
:minio-git:`MinIO Operator </minio-operator>` Github repository to follow
ongoing development on the Operator and Plugin.

Installation
------------

The MinIO Kubernetes Plugin requires Kubernetes 1.17.0 or later:

**Prerequisite**

Install the `krew <https://github.com/kubernetes-sigs/krew>`__ ``kubectl`` 
plugin manager using the `documented installation procedure
<https://krew.sigs.k8s.io/docs/user-guide/setup/install/>`__. 

Install Using ``krew``
~~~~~~~~~~~~~~~~~~~~~~

Run the following command to install :mc:`kubectl minio` using ``krew``:

.. code-block:: shell
   :class: copyable

   kubectl krew update
   kubectl krew install minio

Update Using ``krew``
~~~~~~~~~~~~~~~~~~~~~

Run the following command to update :mc:`kubectl minio`:

.. code-block:: shell
   :class: copyable

   kubectl krew upgrade



MinIO Kubernetes Plugin Syntax
------------------------------

.. mc:: kubectl minio

Create the MinIO Operator
~~~~~~~~~~~~~~~~~~~~~~~~~

.. mc-cmd:: init
   :fullpath:

   Initializes the MinIO Operator. :mc:`kubectl minio` requires the operator for
   core functionality.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio init [FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: image
      :option:

      The image to use for deploying the operator. 
      Defaults to the :minio-git:`latest release of the operator
      <minio/operator/releases/latest>`:

      ``minio/k8s-operator:latest``

   .. mc-cmd:: namespace
      :option:

      The namespace into which to deploy the operator.

      Defaults to ``minio-operator``.

   .. mc-cmd:: cluster-domain
      :option:

      The domain name to use when configuring the DNS hostname of the
      operator. Defaults to ``cluster.local``.

   .. mc-cmd:: namespace-to-watch
      :option:

      The namespace which the operator watches for MinIO tenants.

      Defaults to ``""`` or *all namespaces*.

   .. mc-cmd:: image-pull-secret
      :option:

      Secret key for use with pulling the 
      :mc-cmd-option:`~kubectl minio init image`.

      The MinIO-hosted ``minio/k8s-operator`` image is *not* password protected.
      This option is only required for non-MinIO image sources which are
      password protected.

   .. mc-cmd:: output
      :option:

      Performs a dry run and outputs the generated YAML to ``STDOUT``. Use
      this option to customize the YAML and apply it manually using
      ``kubectl apply -f <FILE>``.

Delete the MinIO Operator
~~~~~~~~~~~~~~~~~~~~~~~~~

.. mc-cmd:: delete
   :fullpath:

   Deletes the MinIO Operator along with all associated resources, 
   including all MinIO Tenant instances in the
   :mc-cmd:`watched namespace <kubectl minio init namespace-to-watch>`.

   .. warning::

      If the underlying Persistent Volumes (``PV``) were created with
      a reclaim policy of ``recycle`` or ``delete``, deleting the MinIO
      Tenant results in complete loss of all objects stored on the tenant.

      Ensure you have performed all due diligence in confirming the safety of
      any data on the MinIO Tenant prior to deletion.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio delete [FLAGS]

   The command accepts the following arguments:

   .. mc-cmd:: namespace
      :option:

      The namespace of the MinIO operator to delete.

      Defaults to ``minio-operator``.

Create a MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc


.. mc-cmd:: tenant create
   :fullpath:

   Creates a MinIO Tenant using the 
   :minio-git:`latest release <minio/minio/releases/latest>` of ``minio``:

   ``minio/minio:latest``

   The command creates the following resources in the Kubernetes cluster. 

   - The MinIO Tenant.

   - Persistent Volume Claims (``PVC``) for each  
     :mc-cmd:`volume <kubectl minio tenant create volumes>` in the tenant.

   - Pods for each
     :mc-cmd:`server <kubectl minio tenant create servers>` in the tenant.

   - Kubernetes secrets for storing access keys and secret keys. Each
     secret is prefixed with the Tenant name.

   - The MinIO Console Service (MCS). See the :minio-git:`console <console>` 
     Github repository for more information on MCS.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant create          \
        --names            NAME            \
        --servers          SERVERS         \
        --volumes          VOLUMES         \
        --capacity         CAPACITY        \
        --storageClassName STORAGECLASS    \
        [OPTIONAL_FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required*

      The name of the MinIO tenant which the command creates. The
      name *must* be unique in the 
      :mc-cmd:`~kubectl minio tenant create namespace`.

   .. mc-cmd:: servers
      :option:

      *Required*

      The number of ``minio`` servers to deploy on the Kubernetes cluster.
      
      Ensure that the specified number of 
      :mc-cmd-option:`~kubectl minio tenant create servers` does *not*
      exceed the number of nodes in the Kubernetes cluster. MinIO strongly
      recommends sizing the cluster to have one node per MinIO server.

   .. mc-cmd:: volumes
      :option:

      *Required*

      The number of volumes in the MinIO tenant. :mc:`kubectl minio`
      generates one Persistent Volume Claim (``PVC``) for each volume.
      :mc:`kubectl minio` divides the 
      :mc-cmd-option:`~kubectl minio tenant create capacity` by the number of
      volumes to determine the amount of ``resources.requests.storage`` to
      set for each ``PVC``.
      
      :mc:`kubectl minio` determines
      the number of ``PVC`` to associate to each ``minio`` server by dividing
      :mc-cmd-option:`~kubectl minio tenant create volumes` by 
      :mc-cmd-option:`~kubectl minio tenant create servers`.

      :mc:`kubectl minio` also configures each ``PVC`` with node-aware
      selectors, such that the ``minio`` server process uses a ``PVC``
      which correspond to a ``local`` Persistent Volume (``PV``) on the 
      same node running that process. This ensures that each process
      uses local disks for optimal performance.

      If the specified number of volumes exceeds the number of 
      ``PV`` available on the cluster, :mc:`kubectl minio tenant create`
      hangs and waits until the required ``PV`` exist.

   .. mc-cmd:: capacity
      :option:

      *Required*

      The total capacity of the MinIO tenant. :mc:`kubectl minio` divides
      the capacity by the number of
      :mc-cmd-option:`~kubectl minio tenant create volumes` to determine the 
      amount of ``resources.requests.storage`` to set for each
      Persistent Volume Claim (``PVC``).

      If the existing Persistent Volumes (``PV``) in the cluster cannot
      satisfy the requested storage, :mc:`kubectl minio tenant create`
      hangs and waits until the required storage exists.

   .. mc-cmd:: storageClassName
      :option:

      *Required*

      The name of the Kubernetes 
      :kube-docs:`Storage Class <concepts/storage/storage-classes/>` to use
      when creating Persistent Volume Claims (``PVC``) for the
      MinIO Tenant. The specified 
      :mc-cmd-option:`~kubectl minio tenant create storageClassName` 
      *must* match the ``StorageClassName`` of the Persistent Volumes (``PVs``)
      to which the ``PVCs`` should bind.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to create the MinIO Tenant. 

      Defaults to ``minio``.

   .. mc-cmd:: kes-config
      :option:

      The name of the Kubernetes Secret which contains the 
      MinIO Key Encryption Service (KES) configuration.

   .. mc-cmd:: output
      :option:

      Outputs the generated ``YAML`` objects to ``STDOUT`` for further
      customization. 
      
      :mc-cmd-option:`~kubectl minio tenant create output` does 
      **not** create the MinIO Tenant. Use ``kubectl apply -f <FILE>`` to
      manually create the MinIO tenant using the generated file.

Expand a MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. mc-cmd:: tenant expand
   :fullpath:

   Adds a new zone to an existing MinIO Tenant.

   The command creates the new zone using the 
   :minio-git:`latest release <minio/minio/releases/latest>` of ``minio``:

   ``minio/minio:latest``

   Consider using :mc-cmd:`kubectl minio tenant upgrade` to upgrade the
   MinIO tenant *before* adding the new zone to ensure consistency across the
   entire tenant.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant expand  \
        --names    NAME            \
        --servers  SERVERS         \
        --volumes  VOLUMES         \
        --capacity CAPACITY        \
        [OPTIONAL_FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required*

      The name of the MinIO Tenant which the command expands.

   .. mc-cmd:: servers
      :option:

      *Required*

      The number of ``minio`` servers to deploy in the new MinIO Tenant zone.
      
      Ensure that the specified number of 
      :mc-cmd-option:`~kubectl minio tenant expand servers` does *not* exceed
      the number of unused nodes in the Kubernetes cluster. MinIO strongly
      recommends sizing the cluster to have one node per MinIO server in the new
      zone.

   .. mc-cmd:: volumes
      :option:

      *Required*

      The number of volumes in the new MinIO Tenant zone. 
      :mc:`kubectl minio` generates one Persistent Volume Claim (``PVC``) for
      each volume. :mc:`kubectl minio` divides the 
      :mc-cmd-option:`~kubectl minio tenant expand capacity` by the number of
      volumes to determine the amount of ``resources.requests.storage`` to set
      for each ``PVC``.
      
      :mc:`kubectl minio` determines
      the number of ``PVC`` to associate to each ``minio`` server by dividing
      :mc-cmd-option:`~kubectl minio tenant expand volumes` by 
      :mc-cmd-option:`~kubectl minio tenant expand servers`.

      :mc:`kubectl minio` also configures each ``PVC`` with node-aware
      selectors, such that the ``minio`` server process uses a ``PVC``
      which correspond to a ``local`` Persistent Volume (``PV``) on the 
      same node running that process. This ensures that each process
      uses local disks for optimal performance.

      If the specified number of volumes exceeds the number of 
      ``PV`` available on the cluster, :mc:`kubectl minio tenant expand`
      hangs and waits until the required ``PV`` exist.

   .. mc-cmd:: capacity
      :option:

      *Required*

      The total capacity of the new MinIO Tenant zone. :mc:`kubectl minio` 
      divides the capacity by the number of
      :mc-cmd-option:`~kubectl minio tenant expand volumes` to determine the 
      amount of ``resources.requests.storage`` to set for each
      Persistent Volume Claim (``PVC``).

      If the existing Persistent Volumes (``PV``) in the cluster cannot
      satisfy the requested storage, :mc:`kubectl minio tenant expand`
      hangs and waits until the required storage exists.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to create the new MinIO Tenant zone. The namespace
      *must* match that of the MinIO Tenant being extended.

      Defaults to ``minio``.

   .. mc-cmd:: output
      :option:

      Outputs the generated ``YAML`` objects to ``STDOUT`` for further
      customization. 
      
      :mc-cmd-option:`~kubectl minio tenant expand output` does **not** create
      the new MinIO Tenant zone. Use ``kubectl apply -f <FILE>`` to manually
      create the MinIO tenant using the generated file.

Get MinIO Tenant Zones
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. mc-cmd:: tenant info
   :fullpath:

   Lists all existing MinIO zones in a MinIO Tenant.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant info --names NAME [OPTIONAL_FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required*

      The name of the MinIO Tenant for which the command returns the
      existing zones.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to look for the MinIO Tenant.

      Defaults to ``minio``.

Upgrade MinIO Tenant
~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. mc-cmd:: tenant upgrade
   :fullpath:

   Upgrades the ``minio`` server Docker image used by the MinIO Tenant.
   
   .. important::

      MinIO upgrades *all* ``minio`` server processes at once. This may
      result in a brief period of downtime if a majority (``n/2-1``) of 
      servers are offline at the same time.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant upgrade --names NAME [OPTIONAL_FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required*

      The name of the MinIO Tenant which the command updates.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to look for the MinIO Tenant.

      Defaults to ``minio``.

Delete a MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. mc-cmd:: tenant delete
   :fullpath:

   Deletes the MinIO Tenant and its associated resources.

   Kubernetes only deletes the Minio Tenant Persistent Volume Claims (``PVC``)
   if the underlying Persistent Volumes (``PV``) were created with a 
   reclaim policy of ``recycle`` or ``delete``. ``PV`` with a reclaim policy of
   ``retain`` require manual deletion of their associated ``PVC``.
   
   Deletion of the underlying ``PV``, whether automatic or manual, results in
   the loss of any objects stored on the MinIO Tenant. Perform all due 
   diligence in ensuring the safety of stored data *prior* to deleting the 
   tenant.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant delete --names NAME [OPTIONAL_FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required*

      The name of the MinIO Tenant to delete.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to look for the MinIO Tenant.

      Defaults to ``minio``.

