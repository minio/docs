
.. _kubectl-minio-init:

=========================
``kubectl minio init``
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio init

Description
-----------

.. start-kubectl-minio-init-desc

The :mc:`kubectl minio init` command initialize the MinIO Operator.

.. end-kubectl-minio-init-desc

If the Kubernetes cluster has an existing MinIO Operator installation, this command upgrades the Operator to match the MinIO plugin version.
For more information on upgrading the MinIO Operator, see :ref:`minio-k8s-upgrade-minio-operator`.

Syntax
------

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command initializes a new MinIO Operator deployment running |operator-version-stable|.

      .. code-block:: shell
         :class: copyable

         kubectl minio init

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         kubectl minio init                      \
                       [--cluster-domain]        \
                       [--console-image]         \
                       [--console-tls]           \
                       [--default-console-image] \
                       [--default-kes-image]     \
                       [--default-minio-image]   \
                       [--image]                 \
                       [--image-pull-secret]     \
                       [--namespace]             \
                       [--namespace-to-watch]    \
                       [--output]                \
                       [--prometheus-name]       \
                       [--prometheus-namespace]

Flags
-----

.. 
   Default values update frequently and can be found in the following files:
   https://github.com/minio/operator/blob/master/kubectl-minio/cmd/init.go
   https://github.com/minio/operator/blob/master/kubectl-minio/cmd/helpers/constants.go

   For minio/console, run ``kubectl minio init -o | grep minio/console``

The command supports the following flags:

.. mc-cmd:: --cluster-domain
   :optional:

   The domain name to use when configuring the DNS hostname of the operator. 
   Defaults to ``cluster.local``.

.. mc-cmd:: --console-image
   :optional:

   The image to use when deploying the :minio-git:`MinIO Console <console>` in Operator mode, where administrators can create and manage MinIO tenants using a Graphical User Interface.
   Defaults to ``minio/console:v0.17.3``.

.. mc-cmd:: --console-tls
   :optional:

   .. versionadded:: 4.5.6

   Enables TLS for the Operator Console.

   Disabled by default.

.. mc-cmd:: --default-console-image
   :optional:

   The default :minio-git:`MinIO Console <console>` image to use when creating a new MinIO tenant. 
   Defaults to ``minio/console:v0.17.3``.

.. mc-cmd:: --default-kes-image
   :optional:

   The default :minio-git:`kes <kes>` image to use when creating a new MinIO tenant. 
   Defaults to ``minio/kes:v0.18.0``.

.. mc-cmd:: --default-minio-image
   :optional:

   The default :minio-git:`minio <minio>` image to use when creating a new MinIO tenant. 
   Defaults to ``minio/minio:RELEASE.2022-05-26T05-48-41Z``.

.. mc-cmd:: --image
   :optional:

   The image to use for deploying the operator. 
   Defaults to the :minio-git:`latest release of the operator <operator/releases/latest>`.

.. mc-cmd:: --image-pull-secret
   :optional:

   Secret key for use with pulling the :mc-cmd:`~kubectl minio init --image`.

   The MinIO-hosted ``minio/k8s-operator`` image is *not* password protected.
   This option is only required for non-MinIO image sources which are password protected.

.. mc-cmd:: --namespace
   :optional:

   The namespace into which to deploy the operator.
   Defaults to ``minio-operator``.

.. mc-cmd:: --namespace-to-watch
   :optional:

   The namespace which the operator watches for MinIO tenants.
   Defaults to ``""`` for *all namespaces*.

.. mc-cmd:: --output
   :optional:

   Performs a dry run and outputs the generated YAML to ``STDOUT``. 
   Use this option to customize the YAML and apply it manually using ``kubectl apply -f <FILE>``.

.. mc-cmd:: --prometheus-name
   :optional:

   The name of the Prometheus service managed by the Prometheus Operator.
   Defaults to ``PROMETHEUS_NAME``

.. mc-cmd:: --prometheus-namespace
   :optional:

   The namespace into which to deploy Prometheus.
   Defaults to ``PROMETHEUS_NAMESPACE``