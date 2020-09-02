=================================
MinIO Kubernetes Plugin Reference
=================================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2

The ``kubectl-minio`` plugin wraps the MinIO Kubernetes Operator (``operator``)
and provides a simple interface through ``kubectl`` for deploying and managing
MinIO resources. The ``kubectl-minio`` interface does not require familiarity
with the Kubernetes API, the MinIO ``operator`` API extension, or the creation
of ``YAML`` specifications. 

The MinIO ``kubectl-minio`` plugin is a part of the 
:minio-git:`MinIO Kubernetes Operator <operator/tree/master/kubectl-minio>` 
Github repository.

.. _minio-kubectl-minio-installation:

Installation
------------

Download the latest ``kubectl-minio`` binary from the MinIO ``operator``
:minio-git:`github repository <operator/releases>` and place it into your system
``PATH``. You may need to use ``chmod`` or an equivalent utility to set the
binary as executable.

The following command:

- Uses ``wget`` to download the latest stable version of the ``kubectl-minio``
  plugin to the ``/usr/local/bin`` directory, *and*

- Uses ``sudo chmod`` to set the binary as executable.

.. code-block:: shell
   :class: copyable
   :substitutions:

   wget https://github.com/minio/operator/releases/download/|operator-release|/|kubectl-plugin-release| -O ~/usr/local/bin/kubectl-minio \
   && sudo chmod +x /usr/local/bin/kubectl-minio

- For Linux and OSX, type ``echo $PATH`` into a terminal to check which
  directories are included in the system path. Copy the ``kubectl-minio``
  plugin into the appropraite directory. For example,
  ``/usr/local/bin``.

- For Windows, ensure the path to the ``kubectl-minio`` binary exists in the
  system ``PATH`` environment variable. Defer to documentation on your version
  of Windows for instructions on setting the ``PATH`` variable.

.. _minio-kubectl-minio-create-tenant:

Create a MinIO Tenant using the MinIO Kubernetes Plugin
-------------------------------------------------------

Prerequisites
~~~~~~~~~~~~~

.. list-table::
   :width: 100%
   :widths: 10 90

   * - .. raw:: html

          <input type="checkbox">

     - Kubernetes v1.17.0 or later.

   * - .. raw:: html

          <input type="checkbox">
   
     - Persistent Volumes (``PV``) created using the 
       :doc:`MinIO Direct CSI </kubernetes/direct-csi>` plugin. 
       
       The cluster should have one Direct CSI ``PV`` for each planned 
       :mc-cmd:`volume <kubectl minio tenant create volumes>` in the MinIO
       tenant. For example, if the MinIO deployment will have 4 servers with 4
       volumes each, the Kubernetes cluster should have 16 total ``PV`` created
       using the MinIO Direct CSI plugin.

   * - .. raw:: html

          <input type="checkbox">
   
     - A machine with ``kubectl`` installed and configured with access to the
       target Kubernetes cluster. 

This procedure assumes the default ``kubectl`` context points to the
Kubernetes cluster in which you want to deploy the MinIO tenant. To
specify a different context, include the ``--context`` argument to
``kubectl``. For more information on Kubernetes contexts, see
:kube-docs:`Organizing Cluster Access using kubeconfig Files
<concepts/configuration/organize-cluster-access-kubeconfig/>`

1) Download the ``kubectl-minio`` Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Download the latest ``kubectl-minio`` binary from the MinIO ``operator``
:minio-git:`github repository <operator/releases>` and place it into your system
``PATH``. You may need to use ``chmod`` or an equivalent utility to set the
binary as executable.

The following command:

- Uses ``wget`` to download the latest stable version of the ``kubectl-minio``
  plugin to the ``/usr/local/bin`` directory, *and*

- Uses ``sudo chmod`` to set the binary as executable.

.. code-block:: shell
   :class: copyable
   :substitutions:

   wget https://github.com/minio/operator/releases/download/|operator-release|/|kubectl-plugin-release| -O ~/usr/local/bin/kubectl-minio \
   && sudo chmod +x /usr/local/bin/kubectl-minio

- For Linux and OSX, type ``echo $PATH`` into a terminal to check which
  directories are included in the system path. Copy the ``kubectl-minio``
  plugin into the appropraite directory. For example,
  ``/usr/local/bin``.

- For Windows, ensure the path to the ``kubectl-minio`` binary exists in the
  system ``PATH`` environment variable. Defer to documentation on your version
  of Windows for instructions on setting the ``PATH`` variable.

2) Validate the Installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run the following ``kubectl`` command to validate the installation:

.. code-block:: shell

   kubectl minio operator --version

The operation should return the latest version of the ``kubectl-minio`` plugin.

3) Create the Kubernetes Namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run the following ``kubectl`` command to create the namespace for the
MinIO tenant:

.. code-block:: shell
   :class: copyable

   kubectl create ns minio-tenant1

4) Create a Kubernetes Secret for MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO servers require an access key and secret key for configuring the
``root`` user. Create a Kubernetes secret for storing these values:

.. code-block:: shell
   :class: copyable

   kubectl create secret generic minio-tenant1-secret \
    --from-literal=accesskey=YOUR-ACCESS-KEY \
    --from-literal=secretkey=YOUR-SECRET-KEY-CHANGE-THIS

5) Create a MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~

Run the :mc-cmd:`kubectl minio tenant create` command to create a MinIO
tenant on a Kubernetes cluster. The following example uses the
default ``kubectl`` context:

.. code-block:: shell
   :class: copyable

   kubectl minio tenant create \
     --name minio-tenant1
     --namespace minio \
     --storageClass direct.csi.min.io \
     --servers 4 \
     --volumes 4 \
     --capacity 16Ti \
     --secret minio-tenant1-secret

- :mc-cmd-option:`~kubectl minio tenant create servers` sets the total number
  of ``minio`` servers in the cluster to ``4``. 

- :mc-cmd-option:`~kubectl minio tenant create volumes` sets the total number
  of volumes per server to ``4``. This results in ``16`` volumes across the
  cluster. 

- :mc-cmd-option:`~kubectl minio tenant create storageClass` sets the
  storage class of each volume to ``direct.csi.min.io``. This ensures each
  generated Persistent Volume Claim (``PVC``) binds to a Direct CSI 
  Persistent Volume (``PV``).

- :mc-cmd-option:`~kubectl minio tenant create capacity` sets the total
  MinIO deployment storage capacity to ``16Ti`` or 16 Tebibytes. 
  ``kubectl-minio`` distributes the capacity evenly over the total nunber of
  volumes. In this example, the deployment has 16 x ``1Ti`` (1 Tebibyte) drives.

Quick Reference
---------------

This section contains a quick lookup table of ``kubectl-minio`` commands:

Common Operations
-----------------

This section lists common operations using the ``kubectl-minio`` plugin:

.. todo

   Need to flesh out a handful of quickstart-like examples here.

Behavior
--------

.. _kubectl-minio-pvc:

Persistent Volumes and Persistent Volume Claims
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO ``kubectl-minio`` plugin automatically generates
Persistent Volume Claims (``PVC``) during tenant creation. The plugin calculates
the total number of ``PVC`` to create by multiplying the number of
:mc-cmd:`servers <kubectl minio tenant create servers>` by the number of 
:mc-cmd:`volumes <kubectl minio tenant create volumes>` per server. 
The plugin also sets the total requested capacity of each ``PVC`` by
dividing the total number of volumes by the total tenant
:mc-cmd:`capacity <kubectl minio tenant create capacity>`. 

For example, consider a MinIO tenant with:

- 4 servers,
- 4 volumes per server, *and*
- 16 ``Ti`` total capacity.

The MinIO tenant has a total of ``(4 servers x 4 volumes / server)`` or
``16`` volumes. Each volume has ``(16 volumes / 16 Ti capacity)`` or
1 ``Ti`` capacity each.

MinIO provides the :doc:`Direct CSI plugin </kubernetes/direct-csi>` for
creating ``PV`` using locally-attached disks. When creating the MinIO tenant,
set the :mc-cmd:`storageClass <kubectl minio tenant create storageclass>` to
``direct.csi.min.io`` to bind the generated ``PVC`` to Direct CSI ``PV``. The
``kubectl-minio`` plugin ensures that each ``minio`` server pod uses only
``PVC`` volumes which correspond to a Direct CSI ``PV`` on the node running that
pod.

MinIO strongly recommends using Persistent Volumes (``PV``) that correspond to
locally attached disks for maximum performance. MinIO cannot guarantee
predictable behavior, performance, or reliabilty with non-local ``PV`` volumes.
The MinIO Direct CSI plugin is specifically optimized for locally-attached
storage. See :doc:`Direct CSI plugin </kubernetes/direct-csi>` for more
information.

.. _kubectl-minio-capacity-units:

Supported Capacity Units
~~~~~~~~~~~~~~~~~~~~~~~~

The :mc-cmd:`kubectl minio tenant create` command requires specifying the
total :mc-cmd-option:`~kubectl minio tenant create capacity` of the
deployment. Similarly, the :mc-cmd:`kubectl minio tenant volumes add`
requires specifying the total additional 
:mc-cmd-option:`~kubectl minio tenant volumes add capacity` storage to add
to the deployment.

MinIO supports the following units when specifying storage ``capacity`` for
tenant creation or expansion:

.. list-table::
   :header-rows: 1
   :widths: 20 80
   :width: 100%

   * - Suffix
     - Unit Size

   * - ``k``
     - KB (Kilobyte, 1000 Bytes)

   * - ``m``
     - MB (Megabyte, 1000 Kilobytes)

   * - ``g``
     - GB (Gigabyte, 1000 Megabytes)

   * - ``t``
     - TB (Terrabyte, 1000 Gigabytes)

   * - ``ki``
     - KiB (Kibibyte, 1024 Bites)

   * - ``mi``
     - MiB (Mebibyte, 1024 Kibibytes)

   * - ``gi``
     - GiB (Gibibyte, 1024 Mebibytes)

   * - ``ti``
     - TiB (Tebibyte, 1024 Gibibytes)

Omitting the suffix defaults to ``bytes``.




Syntax
------

The ``kubectl-minio`` operator adds the following commands to ``kubectl``:

.. mc:: kubectl minio operator

.. mc-cmd:: create
   :fullpath:

   Creates the MinIO operator and its required resources. The command
   has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio operator create [ARGUMENTS]

   The command supports the following arguments:

   .. mc-cmd:: image
      :option:

      The name of the Docker image to use for deploying the operator. 
      Specify ``minio/k8s-operator:<version>``, where ``<version>`` is
      the specific release of the ``operator`` to install.

      For example:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         kubectl minio operator create --image |operator-release|

      Defaults to the latest released version of the MinIO
      ``operator``.

   .. mc-cmd:: namespace
      :option:

      The Kubernetes namespace on which to deploy the operator.
      Defaults to ``minio-operator``.

   .. mc-cmd:: service-account
      :option:

      The Kubernetes service account on which to deploy the operator.
      Defaults to ``minio-operator``

   .. mc-cmd:: cluster-domain
      :option:

      The Kubernetes cluster domain on which to deploy the operator.
      Defaults to ``cluster.local``.

   .. mc-cmd:: namespace-to-watch
      :option:

      The namespace which the ``operator`` watches for MinIO tenants.
      Defaults to ``default``, or all namespaces.

   .. mc-cmd:: image-pull-secret
      :option:

      The secret for the specified image to pull. Only required if specifying
      a password-protected mirror of the MinIO ``operator`` image.

   .. mc-cmd:: output
      :option:

      Performs a dry run of the command and prints the resulting
      ``YAML`` file on the command line.

.. mc:: kubectl minio tenant

.. mc-cmd:: create
   :fullpath:

   Creates a new MinIO tenant in the Kubernetes cluster. The command has
   the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant create [ARGUMENTS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required* The name of the MinIO tenant to create.


   .. mc-cmd:: namespace, n
      :option:

      *Required* The namespace in which to create the MinIO deployment.
      Defaults to ``minio``.

   .. mc-cmd:: servers
      :option:

      *Required* The number of MinIO ``minio`` pods to deploy in the cluster. 
      Specify an integer greater than or equal to ``2``. The 
      MinIO operator does not support standalone (``--servers 1``) 
      deployments.

   .. mc-cmd:: volumes
      :option:

      *Required* The total number of storage volumes in the deployment.
      Specify an integer that is a multiple of the value passed to
      :mc-cmd-option:`~kubectl minio tenant create servers`. The operator
      evenly distributes the specified number of volumes across the ``minio``
      servers in the deployment.

      The operator generates a Persistent Volume Claim (``PVC``) for
      each volume. The operator assumes that the appropriate Persistent
      Volumes (``PV``) exist to satisfy each generated ``PVC``. 

      For example, with ``--servers 4`` and ``--volumes 16``, the operator
      assigns 4 ``PVC`` to each server. 

      See :ref:`kubectl-minio-pvc` for more information.

   .. mc-cmd:: capacity
      :option:

      *Required* The total amount of storage capacity of the deployment.
      Specify an integer and :ref:`unit of measurement
      <kubectl-minio-capacity-units>`.

      The operator generates a Persistent Volume Claim (``PVC``) for each
      :mc-cmd:`volume <kubectl minio tenant create volumes>` in the
      deployment. The operator uses the ``capacity`` to set the
      ``resources.requests.storage`` key of each ``PVC``. Specifically,
      divides the total capacity by the number of 
      :mc-cmd-option:`~kubectl minio tenant create volumes` in the deployment to
      derive the value for ``resources.requests.storage``. 

      For example, with ``--volumes 16`` and ``--capacity 16Ti``, the
      operator requests ``1Ti`` of storage capacity per ``PVC``.
      
      See :ref:`kubectl-minio-pvc` for more information.

   .. mc-cmd:: secret
      :option:

      *Required* Name of the Kubernetes 
      :kube-docs:`secret <concepts/configuration/secret/>` to use as the
      root credentials of the MinIO cluster.

   .. mc-cmd:: storage-class, s
      :option:

      The name of the storage to use during Persistent Volume Claim (``PVC``)
      generation.

      The operator generates a Persistent Volume Claim (``PVC``) for each
      :mc-cmd:`volume <kubectl minio tenant create volumes>` in the
      deployment. The operator uses the ``storage-class`` to set the
      ``storageClassName`` key of each ``PVC``. The ``PVC`` storage class
      *must* match the ``PV`` :kube-docs:`StorageClass
      <concepts/storage/storage-classes/>`.

      For example, if using the MinIO 
      :minio-git:`Direct CSI Driver <direct-csi>` to provision a
      ``PV``, specify ``direct.csi.min.io`` for the ``storage-class``.

   .. mc-cmd:: image
      :option:

      The name of the Docker image to use for the ``minio`` server process. 
      Specify ``minio/minio:<version>``, where ``<version>`` is
      the specific release of the ``minio`` server to install.

      For example:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         kubectl minio tenant create --image |server-release|

      Defaults to the latest stable version of the ``minio`` server.

   .. mc-cmd:: image-pull-secret
      :option:

      The secret for the specified image to pull. Only required if specifying
      a password-protected mirror of the MinIO ``operator`` image.

   .. mc-cmd:: kms-secret
      :option:

      Name of the Kubernetes :kube-docs:`secret
      <concepts/configuration/secret/>` to use for deploying the
      MinIO Key Encryption Service (KES). KES enables automatic
      server-side object encryption using a Key Management System (KMS).

   .. mc-cmd:: console-secret
      :option:

      Name of the Kubernetes :kube-docs:`secret
      <concepts/configuration/secret/>` to use for deploying the
      MinIO Console Service (MCS). MCS provides a simple interface
      for managing your MinIO cluster.

   .. mc-cmd:: cert-secret
      :option:

      Name of the Kubernetes :kube-docs:`secret
      <concepts/configuration/secret/>` to use for
      automatic TLS certificate generation. 

   .. mc-cmd:: disable-tls
      :option:

      Disables automatic TLS certificate generation. The resulting MinIO
      deployment cannot enforce TLS if created using this option.

   .. mc-cmd:: output
      :option:

      Performs a dry run of the command and prints the resulting
      ``YAML`` file on the command line.


.. mc-cmd:: upgrade
   :fullpath:

   Upgrades the MinIO Docker image used by an existing MinIO tenant. The command
   upgrades *all* pods running the ``minio`` server at the same time. 
   The deployment may return errors on ``PUT`` or ``GET`` requests during
   the upgrade process. The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant upgrade [ARGUMENTS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required* The name of the MinIO tenant to upgrade. 

   .. mc-cmd:: image, i
      :option:

      *Required* The name of the Docker image to use for upgrading 
      the MinIO tenant. Specify ``minio/minio:<version>``, where
      ``<version>`` is a newer release of the ``minio`` server to install.
      For example:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         kubectl minio tenant upgrade --image minio/minio:|server-release|

      Defaults to the latest stable release of the ``minio`` server.

      You cannot specify an older ``<version>`` of the ``minio`` server.

   .. mc-cmd:: namespace, n

      *Required* The namespace in which the operator upgrades the
      :mc-cmd-option:`~kubectl minio tenant upgrade name` MinIO tenant.

   .. mc-cmd:: image-pull-secret
      :option:

      The secret for the specified image to pull. Only required if specifying
      a password-protected mirror of the MinIO ``minio/minio`` image.

   .. mc-cmd:: output
      :option:

      Performs a dry run of the command and prints the resulting
      ``YAML`` file on the command line.

.. mc-cmd:: delete
   :fullpath:

   Deletes a MinIO tenant in the Kubernetes cluster. The command
   *only* removes pods and Persistent Volume Claims (``PVC``). The command
   does *not* remove any Persistent Volumes (``PV``) used by the deleted
   ``PVC``. 
   
   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant delete [ARGUMENTS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required* The name of the MinIO tenant to delete.

   .. mc-cmd:: namespace
      :option:

      *Required* The namespace in which the operator deletes the specified 
      MinIO tenant.

.. mc-cmd:: volume add
   :fullpath:

   Adds a new MinIO zone to an existing MinIO tenant deployment. A MinIO zone
   *expands* the number of servers and drives on the existing deployment. 
   MinIO zones have *no relation* to Kubernetes zones. 

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant volume add [ARGUMENTS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required* The name of the MinIO tenant to which the plug adds the
      new zone.

   .. mc-cmd:: namespace, n
      :option:

      *Required* The Kubernetes namespace in which to expand the MinIO tenant
      deployment.

   .. mc-cmd:: servers
      :option:

      *Required* The number of MinIO ``minio`` pods to deploy in the zone. 

   .. mc-cmd:: volumes
      :option:

      *Required* The total number of storage volumes in the zone.
      Specify an integer that is a multiple of the value passed to
      :mc-cmd-option:`~kubectl minio tenant volume add servers`. The operator
      evenly distributes the specified number of volumes across the ``minio``
      servers in the zone.

      The operator generates a Persistent Volume Claim (``PVC``) for
      each volume. The operator assumes that the appropriate Persistent
      Volumes (``PV``) exist to satisfy each generated ``PVC``. 

      For example, with ``--servers 4`` and ``--volumes 16``, the operator
      assigns 4 ``PVC`` to each server. 

      See :ref:`kubectl-minio-pvc` for more information.

   .. mc-cmd:: capacity
      :option:

      *Required* The total amount of storage capacity of the zone.
      Specify an integer and :ref:`unit of measurement
      <kubectl-minio-capacity-units>`.

      The operator generates a Persistent Volume Claim (``PVC``) for each
      :mc-cmd:`volume <kubectl minio tenant volume add volumes>` in the
      deployment. The operator uses the ``capacity`` to set the
      ``resources.requests.storage`` key of each ``PVC``. Specifically,
      divides the total capacity by the number of 
      :mc-cmd-option:`~kubectl minio tenant volume add volumes` in the 
      deployment to derive the value for ``resources.requests.storage``. 

      For example, with ``--volumes 16`` and ``--capacity 16Ti``, the
      operator requests ``1Ti`` of storage capacity per ``PVC``.
      
      See :ref:`kubectl-minio-pvc` for more information.

.. mc-cmd:: volumes list
   :fullpath:

   This command lists the storage volumes in a MinIO tenant. The command
   has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio tenant volume list [ARGUMENTS]

   The command supports the following arguments:

   .. mc-cmd:: name
      :option:

      *Required* The name of the MinIO tenant from which the command lists the
      storage volumes.

   .. mc-cmd:: namespace, n
      :option:

      *Required* The Kubernetes namespace of the MinIO tenant.