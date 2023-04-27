
.. _kubectl-minio-proxy:

=======================
``kubectl minio proxy``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio proxy

Description
-----------

.. start-kubectl-minio-proxy-desc

:mc-cmd:`kubectl minio proxy` creates a temporary proxy to forward traffic from the local host machine to the MinIO Operator Console. 
The :ref:`Operator Console <minio-operator-console>` provides a rich user interface for :ref:`deploying and managing MinIO Tenants <minio-k8s-deploy-minio-tenant>`.

This command is an alternative to configuring `Ingress <https://kubernetes.io/docs/concepts/services-networking/ingress/>`__ to grant access to the Operator Console pods.

.. end-kubectl-minio-proxy-desc

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. cond:: openshift

   .. versionchanged:: Operator 5.0.0

      The ``kubectl minio proxy`` command now supports retrieving the JWT for use with OpenShift deployments.

Syntax
------

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command creates proxy to use to access the operator graphical user interface for the ``myminio`` namespace:

      .. code-block:: shell
         :class: copyable

         kubectl minio proxy --namespace myminio 
          
   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         kubectl minio init           \
                       [--namespace] 

Flags
-----

.. 
   Default values update frequently and can be found in the following files:
   https://github.com/minio/operator/blob/master/kubectl-minio/cmd/init.go
   https://github.com/minio/operator/blob/master/kubectl-minio/cmd/helpers/constants.go

   For minio/console, run ``kubectl minio init -o | grep minio/console``

The command supports the following flags:

.. mc-cmd:: --namespace
   :optional:

   The namespace for which to access the operator.

   .. cond:: not openshift
   
      Defaults to ``minio-operator``.

   .. cond:: openshift

      Defaults to ``openshift-operators``.