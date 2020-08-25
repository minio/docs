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

Installation
------------

Prerequisites
~~~~~~~~~~~~~

- Kubernetes v1.17.0 or later

- One Persistant Volumes (``PV``) created using the 
  :doc:`MinIO Direct CSI </kubernetes/direct-csi>`
  plugin for each :mc-cmd:`volume <kubectl minio tenant create volumes>` 
  the ``minio`` server uses. For example, if the MinIO deployment will have
  4 servers with 4 volumes each, the Kubernetes cluster should have 16
  total ``PV`` created using the MinIO Direct CSI plugin.

- ``kubectl`` configured for access to the target Kubernetes cluster. Note
  that ``kubectl`` is suppored within one minor version older or newer than
  the ``kube-apiserver`` on the destination cluser. See
  the Kubernetes documentation 
  :kube-docs:`Kubernetes version and version skew support policy
  <setup/release/version-skew-policy>`

This procedure assumes the default ``kubectl`` context points to the
Kubernetes cluster in which you want to deploy the MinIO tenant. To
specify a different context, include the ``--context`` argument to
``kubectl``. For more information on Kubernetes contexts, see
:kube-docs:`Organizing Cluster Access using kubeconfig Files
<concepts/configuration/organize-cluster-access-kubeconfig/>`

1) Download the ``kubectl-minio`` Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :minio-git:`Github Releases Page <opreator/releases>` lists all
releases for the MinIO ``operator`` and the ``kubectl-minio`` plugin.

Download the latest release onto a host machine with ``kubectl`` installed.
The following command downloads the latest stable version of the 
``kubectl-minio`` plugin:

.. code-block:: shell
   :class: copyable
   :substitutions:

   wget https://github.com/minio/operator/releases/download/|operator-release|/|kubectl-plugin-release| \
      -O ~/Downloads/kubectl-minio

You may need to use ``chmod`` or an equivalent utility to set the binary file
as executable:

.. code-block:: shell
   
   sudo chmod +x ~/Downloads/kubectl-minio

2) Move the ``kubectl-minio`` Binary into your System Path
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The location of your system path depends on your filesystem.

- For Linux and OSX, type ``echo $PATH`` into a terminal to check which
  directories are included in the system path. Copy the ``kubectl-minio``
  plugin into the appropraite directory. For example,
  ``/usr/local/bin``.

- For Windows, ensure the path to the ``kubectl-minio`` binary exists in the
  system ``PATH`` environment variable. Defer to documentation on your version
  of Windows for instructions on setting the ``PATH`` variable.

3) Validate the Installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run the following ``kubectl`` command to validate the installation:

.. code-block:: shell

   kubectl minio operator --version

The operation should return the latest version of the ``kubectl-minio`` plugin.

4) Create the Kubernetes Namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run the following ``kubectl`` command to create the namespace for the
MinIO tenant:

.. code-block:: shell
   :class: copyable

   kubectl create ns MinIOTenant1

5) Create a Kubernetes Secret for MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO servers require an access key and secret key for configuring the
``root`` user. Create a Kubernetes secret for storing these values:

.. code-block:: shell
   :class: copyable

   kubectl create secret generic MinIOTenant1Secret \
    --from-literal=accesskey=YOUR-ACCESS-KEY \
    --from-literal=secretkey=YOUR-SECRET-KEY-CHANGE-THIS

6) Create a MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~

Run the :mc-cmd:`kubectl minio tenant create` command to create a MinIO
tenant on a Kubernetes cluster. The following example uses the
default ``kubectl`` context.

.. code-block:: shell
   :class: copyable

   kubectl minio tenant create \
     --name MinIOTenant1
     --namespace minio \
     --storageClass direct.csi.min.io \
     --servers 4 \
     --volumes 4 \
     --capacity 16Ti \
     --secret MinIOTenant1Secret

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

Persistant Volumes and Persistant Volume Claims
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section will discuss in detail how the ``kubectl-minio`` plugin provisions
Persistant Volume Claims (``PVC``) and what Persistant Volumes (``PV``) those
claims are designed for. 

.. _kubectl-minio-capacity-units:

Supported Capacity Units
~~~~~~~~~~~~~~~~~~~~~~~~

The :mc-cmd:`kubectl minio tenant create` command requires specifying the
total :mc-cmd-option:`~kubectl minio tenant create capacity` of the
deployment. MinIO supports the following units:

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

      The operator generates a Persistant Volume Claim (``PVC``) for
      each volume. The operator assumes that the appropriate Persistant
      Volumes (``PV``) exist to satisfy each generated ``PVC``. 

      For example, with ``--servers 4`` and ``--volumes 16``, the operator
      assigns 4 ``PVC`` to each server. 

      See :ref:`kubectl-minio-pvc` for more information.

   .. mc-cmd:: capacity
      :option:

      *Required* The total amount of storage capacity of the deployment.
      Specify an integer and :ref:`unit of measurement
      <kubectl-minio-capacity-units>`.

      The operator generates a Persistant Volume Claim (``PVC``) for each
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

      The name of the storage to use during Persistant Volume Claim (``PVC``)
      generation.

      The operator generates a Persistant Volume Claim (``PVC``) for each
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
   *only* removes pods and Persistant Volume Claims (``PVC``). The command
   does *not* remove any Persistant Volumes (``PV``) used by the deleted
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

      The operator generates a Persistant Volume Claim (``PVC``) for
      each volume. The operator assumes that the appropriate Persistant
      Volumes (``PV``) exist to satisfy each generated ``PVC``. 

      For example, with ``--servers 4`` and ``--volumes 16``, the operator
      assigns 4 ``PVC`` to each server. 

      See :ref:`kubectl-minio-pvc` for more information.

   .. mc-cmd:: capacity
      :option:

      *Required* The total amount of storage capacity of the zone.
      Specify an integer and :ref:`unit of measurement
      <kubectl-minio-capacity-units>`.

      The operator generates a Persistant Volume Claim (``PVC``) for each
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