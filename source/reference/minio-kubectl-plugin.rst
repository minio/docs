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

   Creates a MinIO Tenant with the following resources in the Kubernetes
   cluster. :mc-cmd:`~kubectl minio tenant create` always uses the 
   latest stable version of the 
   :github:`MinIO Server <minio/releases>` and 
   :github:`MinIO Console <console/releases>`.

   .. tabs::

      .. tab:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell

            kubectl minio tenant create TENANT_NAME FLAGS [ FLAGS ]

      .. tab:: EXAMPLE

         The following example creates a MinIO Tenant consisting of 
         4 MinIO servers with 8 drives each and a total capacity of 
         32Ti:

         .. code-block:: shell

            kubectl minio tenant create minio-tenant-1 \
              --servers          4                     \
              --volumes          8                     \
              --capacity         32Ti                  \
              --namespace        minio-tenant-1        \
              --storageClassName local-storage

   On success, the command returns the following:

   - The administrative username and password for the Tenant. Store these 
     credentials in a secure location, such as a password protected 
     key manager. MinIO does *not* show these credentials again.

   - The Service created for connecting to the MinIO Console. The Console
     supports administrative operations on the Tenant, such as configuring 
     Identity and Access Management (IAM) and bucket configurations.

   - The Service created for connecting to the MinIO Tenant. Applications 
     should use this service for performing operations against the MinIO 
     Tenant.

   The command supports the following arguments:

   .. mc-cmd:: TENANT_NAME

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

      The number of volumes in the MinIO tenant. 
      :mc-cmd:`kubectl minio tenant create`
      generates one :kube-docs:`Persistent Volume Claim (PVC) 
      <concepts/storage/persistent-volumes/#persistentvolumeclaims>` for each 
      volume. 

      The number of volumes affects both the requested storage of each 
      ``PVC`` *and* the number of ``PVC`` to associate to each MinIO Pod in 
      the cluster:

      - The command :mc:`kubectl minio` divides the 
        :mc-cmd-option:`~kubectl minio tenant create capacity` by the number of 
        volumes to determine the amount of ``resources.requests.storage`` to set 
        for each ``PVC``.

      - :mc:`kubectl minio` determines the number of ``PVC`` to associate to 
        each ``minio`` server by dividing
        :mc-cmd-option:`~kubectl minio tenant create volumes` by 
        :mc-cmd-option:`~kubectl minio tenant create servers`.

      The command generates each ``PVC`` with Pod-specific selectors, such that
      each Pod only uses ``PV`` that are locally-attached to the node running
      that Pod.

      If the specified number of volumes exceeds the number of unbound
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

      If no Persistent Volumes (``PV``) can satisfy the requested storage,
      :mc:`kubectl minio tenant create` hangs and waits until the required
      storage exists.

   .. mc-cmd:: storageClassName
      :option:

      *Optional*

      The name of the Kubernetes 
      :kube-docs:`Storage Class <concepts/storage/storage-classes/>` to use
      when creating Persistent Volume Claims (``PVC``) for the
      MinIO Tenant. The specified 
      :mc-cmd-option:`~kubectl minio tenant create storageClassName` 
      *must* match the ``StorageClassName`` of the Persistent Volumes (``PVs``)
      to which the ``PVCs`` should bind.

      MinIO strongly recommends creating a Storage Class that corresponds to 
      locally-attached volumes on the host machines on which the Tenant 
      deploys. This ensures each pod can use locally-attached storage for 
      maximum performance and throughput. See the 
      :doc:`/tutorials/deploy-minio-tenant` tutorial for guidance 
      on creating Storage Classes for supporting the MinIO Tenant.

      Defaults to ``default``.

   .. mc-cmd:: namespace
      :option:

      *Optional*

      The namespace in which to create the MinIO Tenant and its associated
      resources. 
      
      MinIO supports exactly *one* MinIO Tenant per namespace. Create
      a unique namespace for each MinIO Tenant deployed into the cluster.

      Defaults to ``minio``.

   .. mc-cmd:: kes-config
      :option:

      The name of the Kubernetes Secret which contains the 
      MinIO Key Encryption Service (KES) configuration. Required for 
      enabling Server Side Encryption of objects (SSE-S3).

   .. mc-cmd:: output
      :option:

      Outputs the generated ``YAML``-formatted specification objects to
      ``STDOUT`` for further customization. 
      
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

   Extends the total capacity of a MinIO Tenant by adding a new Pool. A Pool
   consists of an independent set of pods running the MinIO Server and 
   MinIO Console. The new pool uses the same Docker image for the 
   MinIO Server and Console as the existing Tenant.

   .. tabs::

      .. tab:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell

            kubectl minio tenant expand TENANT_NAME --REQ_FLAGS [OPT_FLAGS]

      .. tab:: EXAMPLE

         The following example expands a MinIO Tenant with a Pool consisting of 
         4 MinIO servers with 8 drives each and a total additional capacity of 
         32Ti:

         .. code-block:: shell

            kubectl minio tenant expand minio-tenant-1 \
              --servers          4                     \
              --volumes          8                     \
              --capacity         32Ti                  \
              --namespace        minio-tenant-1        \
              --storageClassName local-storage

   The command supports the following arguments:

   .. mc-cmd:: TENANT_NAME

      *Required*

      The name of the MinIO Tenant which the command expands.

   .. mc-cmd:: servers
      :option:

      *Required*

      The number of ``minio`` servers to deploy in the new MinIO Tenant Pool.
      
      Ensure that the specified number of 
      :mc-cmd-option:`~kubectl minio tenant expand servers` does *not* exceed
      the number of available nodes in the Kubernetes cluster.

   .. mc-cmd:: volumes
      :option:

      *Required*

      The number of volumes in the new MinIO Tenant Pool. 
      :mc:`kubectl minio` generates one Persistent Volume Claim (``PVC``) for
      each volume. 

      The number of volumes affects both the requested storage of each 
      ``PVC`` *and* the number of ``PVC`` to associate to each MinIO Pod in 
      the new Pool:

      - The command :mc:`kubectl minio` divides the 
        :mc-cmd-option:`~kubectl minio tenant expand capacity` by the number of 
        volumes to determine the amount of ``resources.requests.storage`` to set 
        for each ``PVC``.

      - :mc:`kubectl minio` determines the number of ``PVC`` to associate to 
        each ``minio`` server by dividing
        :mc-cmd-option:`~kubectl minio tenant expand volumes` by 
        :mc-cmd-option:`~kubectl minio tenant expand servers`.

      The command generates each ``PVC`` with Pod-specific selectors, such that
      each Pod only uses ``PV`` that are locally-attached to the node running
      that Pod.

      If the specified number of volumes exceeds the number of unbound
      ``PV`` available in the cluster, :mc:`kubectl minio tenant expand`
      hangs and waits until the required ``PV`` exist.

   .. mc-cmd:: capacity
      :option:

      *Required*

      The total capacity of the new MinIO Tenant Pool. :mc:`kubectl minio` 
      divides the capacity by the number of
      :mc-cmd-option:`~kubectl minio tenant expand volumes` to determine the 
      amount of ``resources.requests.storage`` to set for each
      Persistent Volume Claim (``PVC``).

      If the existing Persistent Volumes (``PV``) can satisfy the requested
      storage, :mc:`kubectl minio tenant expand` hangs and waits until the
      required storage exists.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to create the new MinIO Tenant Pool. The namespace
      *must* match that of the MinIO Tenant being extended.

      Defaults to ``minio``.

   .. mc-cmd:: output
      :option:

      Outputs the generated ``YAML`` objects to ``STDOUT`` for further
      customization. 
      
      :mc-cmd-option:`~kubectl minio tenant expand output` does **not** create
      the new MinIO Tenant Pool. Use ``kubectl apply -f <FILE>`` to manually
      create the MinIO tenant using the generated file.

Get MinIO Tenant Details
~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. mc-cmd:: tenant info
   :fullpath:

   Displays information on a MinIO Tenant, including but not limited to:

   - The total capacity of the Tenant
   - The version of MinIO server and MinIO Console running on the Tenant
   - The configuration of each Pool in the Tenant.

   .. tabs::

      .. tab:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell

            kubectl minio tenant info TENANT_NAME [ FLAGS ]

      .. tab:: EXAMPLE

         The following example retrieves the information of the MinIO 
         Tenant ``minio-tenant-1`` in the namespace ``minio-tenant-1``.

         .. code-block:: shell

            kubectl minio tenant info minio-tenant-1 \
              --namespace minio-tenant-1 

   The command supports the following arguments:

   .. mc-cmd:: TENANT_NAME

      *Required*

      The name of the MinIO Tenant for which the command returns the
      existing zones.

   .. mc-cmd:: namespace
      :option:

      *Optional*

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

      MinIO upgrades the image used by all pods in the Tenant at once. This may
      result in downtime until the upgrade process completes.

   .. tabs::

      .. tab:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell

            kubectl minio tenant upgrade TENANT_NAME FLAGS [FLAGS]

      .. tab:: EXAMPLE

         The following example upgrades a MinIO Tenant to use the latest 
         stable version of the MinIO server:

         .. code-block:: shell

            kubectl minio tenant upgrade minio-tenant-1 \
              --image  minio/minio

   The command supports the following arguments:

   .. mc-cmd:: TENANT_NAME

      *Required*

      The name of the MinIO Tenant which the command updates.

   .. mc-cmd:: image
      :option:

      *Required*

      The Docker image to use for upgrading the MinIO Tenant.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to look for the MinIO Tenant.

      Defaults to ``minio``.

   .. mc-cmd:: output
      :option:

      Outputs the generated ``YAML``-formatted specification objects to
      ``STDOUT`` for further customization. 
      
      :mc-cmd-option:`~kubectl minio tenant upgrade output` does 
      **not** upgrade the MinIO Tenant. Use ``kubectl apply -f <FILE>`` to
      manually upgrade the MinIO tenant using the generated file.

Delete a MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. mc-cmd:: tenant delete
   :fullpath:

   Deletes the MinIO Tenant and its associated resources.

   The delete behavior of each Persistent Volume Claims (``PVC``) generated by the 
   Tenant depends on the 
   :kube-docs:`Reclaim Policy 
   <concepts/storage/persistent-volumes/#reclaim-policy>` of its bound 
   Persistent Volume (``PV``):

   - For ``recycle`` or ``delete`` policies, the command deletes the ``PVC``.

   - For ``retain``, the command retains the ``PVC``.

   Deletion of the underlying ``PV``, whether automatic or manual, results in
   the loss of any objects stored on the MinIO Tenant. Perform all due 
   diligence in ensuring the safety of stored data *prior* to deleting the 
   tenant.

   .. tabs::

      .. tab:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell

            kubectl minio tenant delete TENANT_NAME FLAGS [ FLAGS ]

      .. tab:: EXAMPLE

            kubectl minio tenant delete minio-tenant-1 \
              --namespace minio-tenant-1

   The command includes a confirmation prompt that requires explicit 
   approval of the delete operation.

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant delete --names TENANT_NAME [OPTIONAL_FLAGS]

   The command supports the following arguments:

   .. mc-cmd:: TENANT_NAME

      *Required*

      The name of the MinIO Tenant to delete.

   .. mc-cmd:: namespace
      :option:

      *Optional*

      The namespace in which to look for the MinIO Tenant.

      Defaults to ``minio``.

